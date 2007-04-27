
module ScheduledItem

  has_many :tasks ,      :class_name=>'Task',         :foreign_key=> 'assigned_to_user_id' do
      def overdue(limit=10,options={})
        with_scope :find => options  do
          find(:all,:conditions=>['ended_at < ? and status_id in (0,1,2,3,4) ',Time.now],:limit=>limit  )
        end  
      end
      
      def current(limit=10,options={})
        with_scope :find => options  do
          find(:all,:conditions=>['? between started_at and ended_at and status_id in (0,1,2,3,4) ',Time.now],:limit=>limit  )
        end
      end
      
      def future(limit=10,options={})
        with_scope :find => options do
          find(:all,:conditions=>[' started_at > ?  and status_id in (0,1,2,3,4) ',Time.now],:limit=>limit )
        end
      end
  end
   
end
