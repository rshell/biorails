##
# This represent the default Authentication System with local password base
class AuthenticationSystem < ActiveRecord::Base
  has_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  
  def validate(user)
    if user
      return nil unless hash(user) == user.hashed_password        
      user.update_attribute(:last_login_on, Time.now) if user
      user
    end
    return user
  end  

  def reset_password(user)
    user.password_hash = hash(user)     
  end

protected  

  def hash(user)
     return Digest::SHA1.hexdigest(user.password_salt +  user.password)
  end
  
end

###
# Authenticate Via external LDAP systems
# 
class AuthenticationLdap < AuthenticationSystem 
  validates_presence_of :host, :port, :attr_login

  def after_initialize
    self.port = 389 if self.port == 0
  end
  
  def validate(user)
    attrs = []
    ldap_connection = initialize_ldap_con(self.account, self.account_password)
    login_filter = Net::LDAP::Filter.eq( self.attr_login, user.name ) 
    object_filter = Net::LDAP::Filter.eq( "objectClass", "*" ) 
    dn = String.new
    ldap_con.search( :base => self.base_dn, 
                     :filter => object_filter & login_filter, 
                     :attributes=> ['dn', self.attr_firstname, self.attr_lastname, self.attr_mail]) do |entry|
      dn = entry.dn
      attrs = [:firstname => AuthSourceLdap.get_attr(entry, self.attr_firstname),
               :lastname => AuthSourceLdap.get_attr(entry, self.attr_lastname),
               :mail => AuthSourceLdap.get_attr(entry, self.attr_mail),
               :auth_source_id => self.id ]
    end
    return nil if dn.empty?
    logger.debug "DN found for #{login}: #{dn}" if logger && logger.debug?
    # authenticate user
    ldap_con = initialize_ldap_con(dn, password)
    return nil unless ldap_con.bind
    # return user's attributes
    logger.debug "Authentication successful for '#{login}'" if logger && logger.debug?
    attrs    
  rescue  Net::LDAP::LdapError => text
    raise "LdapError: " + text
  end
 
private
  def initialize_ldap_con(ldap_user, ldap_password)
    Net::LDAP.new( {:host => self.host, 
                    :port => self.port, 
                    :auth => { :method => :simple, :username => Iconv.new('iso-8859-15', 'utf-8').iconv(ldap_user), :password => Iconv.new('iso-8859-15', 'utf-8').iconv(ldap_password) }} 
    ) 
  end
  
  def self.get_attr(entry, attr_name)
    entry[attr_name].is_a?(Array) ? entry[attr_name].first : entry[attr_name]
  end
end
