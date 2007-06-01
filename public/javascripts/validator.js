// Validator: a mostly declarative client-side form validator
// Copyright (c) 2006, Michael Schuerig, michael@schuerig.de
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if (!Array.prototype.equals) {
  Array.prototype.equals = function(other) {
    if (!other) {
      return false;
    }
    var len = this.length;
    if (len != other.length) {
      return false;
    }
    for (var i = 0; i < len; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  };
}

if (!String.isBlank) {
  String.isBlank = function(s) {
    return (!s || (/^\s*$/).test(s));
  };
}

Function.trueFunc = function() {
  return true;
};

Function.andCombiner = function(funcs) {
  var _funcs = $A(arguments).flatten();
  if (_funcs.length == 1) {
    return _funcs[0];
  } else if (_funcs.length > 1) {
    return function() {
      var len = _funcs.length;
      for (var i = 0; i < len; i++) {
        if (! _funcs[i].apply(this, arguments)) {
          return false;
        }
      }
      return true;
    };
  } else {
    return Function.trueFunc;
  }
};


Event.UserActionObserver = Class.create();

Event.UserActionObserver.ignoredKeys = [
  Event.KEY_TAB,
  Event.KEY_RETURN,
  Event.KEY_ESC
];

Event.UserActionObserver.prototype = {
  initialize: function(container, callback, options) {
    options = Object.extend({
      latency: 0.4,
      events: ['keypress', 'change']
    }, options);

    this.container = $(container);
    this.callback = callback;
    this.latency = options.latency * 1000;
    this.timer = null;
    this.notifyCallback = this._notifyCallback.bind(this);
    var onAction = this._onAction.bindAsEventListener(this);

    var events = options.events;
    for (var i = 0; i < events.length; i++) {
      Event.observe(this.container, events[i], onAction);
    }
  },

  _onAction: function(event) {
    if (Event.UserActionObserver.ignoredKeys.include(event.keyCode)) {
      return;
    }
    if (this.timer) {
      clearTimeout(this.timer);
    }
    this.timer = setTimeout(this.notifyCallback, this.latency);
  },

  _notifyCallback: function() {
    this.callback();
  }
};


Form.Validator = Class.create();

Object.extend(Form.Validator, {
  Version: '0.2.5',
  debug: false,
  trace: false,
  validatorsState: {},

  clearDebugArea: function() {
    if (!(window.console && window.console.log)) {
      if (!Form.Validator.debugArea) {
        Form.Validator.debugArea = document.createElement('div');
        document.body.appendChild(Form.Validator.debugArea);
      }
      Form.Validator.debugArea.innerHTML = '';
    }
  },

  debugValidity: function(element, isValid) {
    if (window.console && window.console.log) {
      // console.log('Element ' + element.id + ' is valid: ' + isValid);
    } else {
      Form.Validator.debugArea.innerHTML += element.id + ': ' + isValid + '<br />';
    }
  },

  installForAllValidatedForms: function(options) {
    Event.observe(window, 'load', function() {
      var forms = document.forms;
      for (var i = 0; i < forms.length; i++) {
        if (Element.hasClassName(forms[i], 'validated')) {
          Form.Validator.install(forms[i], options);
        }
      }
      return true;
    });
  },

  install: function(form, options) {
    form.__validator = new Form.Validator(form, options);
  },

  revalidate: function(element) {
    element = $(element);
    var form = element.form;
    if (form && form.__validator) {
      form.__validator.check();
    }
  },

  switchClassNameInvalid: function(element, isValid) {
    element = $(element);
    if (isValid) {
      element.removeClassName('invalid');
    } else {
      element.addClassName('invalid');
    }
  },

  notifyElementStatusChangeCallback: function(element, isValid) {
    if (typeof element.__statusChangedCallback == 'function') {
      element.__statusChangedCallback(isValid);
    }
  },

  getValueCheckerFor: function(inputType) {
    switch (inputType) {
      case 'hidden':
      case 'password':
      case 'select-one':
      case 'text':
      case 'textarea':
        return Form.Validator.Utils.checkHasValue;
      case 'radio':
        return Form.Validator.Utils.checkRadioSelected;
      case 'select-multiple':
        return Form.Validator.Utils.checkHasOptions;
    }
    return null;
  },

  _getValueFunc: function() {
    return $F(this);
  }
});


Form.Validator.prototype = {
  // Options:
  // validators({name:function(validator),...}) - a hash of validation functions; default Form.Validator.Validators
  // formValidator(form, validator) - a validation function for the form as a whole
  // onElementStatusChange - a hash of element ids to function(elementIsValid) that are called when the validity of an element has changed
  // onElementStatusChangeDefault - a default element callback; it has a default itself: a function that adds/removes the class 'invalid' to/from an element.
  // onFormStatusChange - function(formIsValid)
  initialize: function(form, options) {
    this.form = $(form);
    if (!this.form) {
      return;
    }
    if (!options) {
      options = {}
    }
    this.validators = options.validators || Form.Validator.Validators;
    this.formValidator = options.formValidator;
    this.onElementStatusChange = options.onElementStatusChange || {};
    this.onElementStatusChangeDefault = options.onElementStatusChangeDefault || this._classNameChangingElementCallback;
    this.onFormStatusChange = options.onFormStatusChange;
    this.submitButtons = Form.Validator.Utils.submitButtons(this.form);
    var validatedElements = this._installValidators();
    this._installSubmitInterceptor();

    this.check();
    new Event.UserActionObserver(this.form, this.check.bind(this),
      {latency: 0.2, events:['keypress', 'change', 'click']});
  },

  check: function() {
    var formWasValid = this.formIsValid;
    this.formIsValid = true;
    if (Form.Validator.trace) {
      Form.Validator.clearDebugArea();
    }
    var elements = Form.getElements(this.form);
    for (var i = elements.length - 1; i >= 0; i--) {
      this._checkElement(elements[i]);
    }
    this._checkWholeForm();
    this._adjustSubmitButtons();
    if (formWasValid != this.formIsValid) {
      this._notifyFormStatusChangeCallback();
    }
  },

  _checkElement: function(element) {
    if (element && typeof element.__checkValidity == 'function') {
      try {
        var elementIsValid = element.__checkValidity(this);

        if (Form.Validator.trace) {
          Form.Validator.debugValidity(element, elementIsValid);
        }

        this.formIsValid = this.formIsValid && elementIsValid;
        if (element.__wasValid !== elementIsValid) {
          Form.Validator.notifyElementStatusChangeCallback(element, elementIsValid);
          element.__wasValid = elementIsValid;
        }
      } catch (e) {
        if (Form.Validator.debug) {
          throw e;
        }
      }
      return elementIsValid;
    }
    return true;
  },

  _checkWholeForm: function() {
    if (this.formIsValid && this.formValidator) {
      try {
        this.formIsValid = this.formValidator(this.form, this);
      } catch (e) {
        if (Form.Validator.debug) {
          throw e;
        }
      }
    }
  },

  _installValidators: function() {
    var elements = Form.getElements(this.form);
    var validatedElements = []
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i];
      if (/^submit$/i.test(element.tagName) || /^submit$/i.test(element.type) || Element.hasClassName(element, 'dontvalidate')) {
        continue;
      }
      var myself = this;
      var validatorFuncs = element.classNames().inject([], function(memo, className) {
        var validator = myself._getValidatorFor(element, className);
        if (typeof validator == 'function') {
          memo.push(validator);
        }
        return memo;
      });
      
      if (validatorFuncs.length > 0) {
        element.__statusChangedCallback = (typeof this.onElementStatusChange[element.id] == 'function') ?
          this.onElementStatusChange[element.id] : this.onElementStatusChangeDefault;
        element.__checkValidity = Function.andCombiner(validatorFuncs);
        element.__getValue = Form.Validator._getValueFunc;
        validatedElements.push(element);
      }
    }
    return validatedElements;
  },

  _installSubmitInterceptor: function() {
    Event.observe(this.form, 'submit', this._onSubmit.bindAsEventListener(this));
  },

  _getValidatorFor: function(element, className) {
    try {
      if (className == 'mandatory') {
        return Form.Validator.getValueCheckerFor(element.type);
      } else if (/^validate_/.test(className)) {
        var args = className.split('_');
        args.shift();
        var funcName = args.shift();
        var validatorGenerator = this.validators[funcName];
        if (typeof validatorGenerator == 'function') {
          var gen = validatorGenerator(element, args);
          return gen;
        }
      } else {
        return this.validators[className];
      }
    } catch (e) {
      if (this.debug) {
        throw(e);
      } else {
        return null;
      }
    }
  },

  _adjustSubmitButtons: function() {
    var disabled = !this.formIsValid;
    for (var i = this.submitButtons.length - 1; i >= 0; i--) {
      this.submitButtons[i].disabled = disabled;
    }
  },

  _classNameChangingElementCallback: function(isValid) {
    Form.Validator.switchClassNameInvalid(this, isValid);
  },

  _notifyFormStatusChangeCallback: function() {
    if (typeof this.onFormStatusChange == 'function') {
      this.onFormStatusChange(this.formIsValid);
    }
  },

  _onSubmit: function(event) {
    if (Form.Validator.debug) {
      // allow a loophole to test submission of invalid forms
      return true;
    }
    if (!this.formIsValid) {
      return Event.stop(event);
    }
    return true;
  }
};


Form.Validator.Utils = {
  submitButtons: function(form) {
    form = $(form);
    return [].concat(
      $A(form.getElementsByTagName('input')),
      $A(form.getElementsByTagName('button'))
    ).select(function(element) {
      return /^submit$/i.test(element.type) && /^commit$/i.test(element.name);
    });
  },

  validatorState: function(stateName, ctor) {
    var state = Form.Validator.validatorsState[stateName];
    if (!state && ctor) {
      state = new ctor();
      Form.Validator.validatorsState[stateName] = state;
    }
    return state;
  },

  setValidatorState: function(stateName, value) {
    Form.Validator.validatorsState[stateName] = value;
  },

  checkHasValue: function() {
    return (!String.isBlank(this.__getValue()));
  },

  checkRadioSelected: function() {
    if (String.isBlank(this.name)) {
      delete this.__checkValidity;
      return true;
    }
    var isValid = this.checked;
    var radios = Form.getInputs(this.form, 'radio', this.name);
    if (!isValid) {
      for (var i = radios.length - 1; i >= 0; i--) {
        if (radios[i].checked) {
          isValid = true;
          break;
        }
      }
    }
    for (var i = radios.length - 1; i >= 0; i--) {
      if (isValid) {
        delete radios[i].__checkValidity;
      }
      Form.Validator.notifyElementStatusChangeCallback(radios[i], isValid);
    }
    return isValid;
  },

  checkHasOptions: function() {
    return this.options.length > 0;
  },

  isValidDate: function(year, month, day) {
    if (month < 1 || month > 12) {
      return false;
    }
    if (day < 1 || day > 31) {
      return false;
    }
    if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) {
      return false;
    }
    if (month == 2) {
      var leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
      if (day > 29 || (day == 29 && !leap)) {
        return false;
      }
    }
    return true;
  },

  othersHaveDifferentValues: function(element, group) {
    var value = $F(element);
    if (!value) {
      return true;
    }
    for (var i = 0; i < group.length; i++) {
      var other = group[i];
      if (other != element) {
        var otherValue = $F(other);
        if (value == otherValue) {
          return false;
        }
      }
    }
    return true;
  }
};


Form.Validator.Validators = {
  numeric: function() {
    var value = this.__getValue();
    if (!value) {
      return true;
    }
    return (/^\d*([,.]?\d+)$/.test(value));
  },

  integer: function() {
    var value = this.__getValue();
    if (!value) {
      return true;
    }
    return (/^\d+$/.test(value));
  },

  date: function() {
    var value = this.__getValue();
    if (!value) {
      return true;
    }
    var d = Form.Validator.Validators._parseDate(value);
    if (!d) {
      return false;
    }
    return Form.Validator.Utils.isValidDate(d[0], d[1], d[2]);
  },

  time: function() {
    var value = this.__getValue();
    if (!value) {
      return true;
    }
    return /^\d?\d(:\d\d){0,2}$/.test(value);
  },

  maxlength: function(element, args) {
    var maxLength = parseInt(args[0]);
    if (maxLength) {
      return function() {
        return this.__getValue().length <= maxLength;
      }
    }
    return null;
  },

  minlength: function(element, args) {
    var minLength = parseInt(args[0]);
    if (minLength) {
      return function() {
        var len = this.__getValue().length;
        return len == 0 || len >= minLength;
      }
    }
    return null;
  },

  format: function(element, args) {
    var format = decodeURIComponent(args[0]);
    if (format) {
      var re = eval(format);
      delete format;
      return function() {
        return re.test(this.__getValue());
      }
    }
    return null;
  },

  range: function(element, args) {
    var begin = parseInt(args[0]);
    var end   = parseInt(args[1]);
    if (!isNaN(begin) && !isNaN(end)) {
      return function() {
        var v = parseInt(this.__getValue());
        return !isNaN(v) ? (begin <= v && v <= end) : true;
      }
    }
    return null;
  },

  // Check if the defined values of elements in the same group
  // as the given one are different from the given element's value.
  // Elements are grouped by args[0]; e.g.
  // <input class="validate_different_1" />
  different: function(element, args) {
    var groupName = 'different' + args[0];
    var group = Form.Validator.Utils.validatorState(groupName, Array);
    group.push(element);
    group.ok = true;
  	return function(validator) {
  	  var ok = Form.Validator.Utils.othersHaveDifferentValues(this, group);
      group.ok = ok;
  	  return ok;
  	};
  },

  exactly: function(element, args) {
    var required_value_count = parseInt(args[0]);
    var groupName = 'exactly_' + args[0] + '_' + args[1];
    var group = Form.Validator.Utils.validatorState(groupName, Array);
    group.push(element);
    group.ok = true;
    return function(validator) {
      var value_count = 0;
      for (var i = 0; i < group.length; i++) {
        if ($F(group[i])) {
          value_count++;
        }
      }
      var ok = value_count == required_value_count;
      group.ok = ok;
      return ok;
    };
  },

  same: function(element, args) {
    var other = args.join('_');
    return function(validator) {
      ok = $F(element) == $F(other);
      return ok;
    }
  },

  zip: function() {
    var value = this.__getValue();
    if (value.length < 5) {
      return false;
   	}
    return (/\d\d\d\d\d/.test(value));
  },
  
  _parseDate: function(date) {
    var match = /^(\d\d(\d\d)?)-(\d\d?)-(\d\d?)$/.exec(date);
    if (!match) {
      return null;
    }
    return [ match[1], match[3], match[4] ];
  }
};
