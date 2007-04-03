class Permission < ActiveRecord::Base

  def Permission.rebuild
     for subject in Role.controllers.keys
       for action in Role.methods(subject)
         unless Permission.location(subject,action)
           permission = Permission.new(:subject=>subject,:action=>action)
           permission.checked =  ['list','show','edit','new','destroy'].any?{|i|i==action}
           permission.save
         end
       end
     end
  end
  
  def Permission.location(subject,action)
     Permission.find(:first,:conditions=>['subject=? and action =?',subject.to_s, action.to_s])
  end

end
