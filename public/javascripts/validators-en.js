
Object.extend(Form.Validator.Validators, {
  Version: '0.2.0',

  _parseDate: function(date) {
    var match = /^(\d\d?)\/(\d\d?)\/(\d\d(\d\d)?)$/.exec(date);
    if (!match) {
      return undefined;
    }
    return [ match[3], match[1], match[2] ];
  }
});
