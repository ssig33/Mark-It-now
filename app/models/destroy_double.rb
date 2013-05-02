module DestroyDouble
  extend ActiveSupport::Concern

  module ClassMethods
    def destroy_double
      hash = {}
      self.all.each do |a|
        begin
          hash[a.id.to_s] = [] unless hash[a.id.to_s]
          hash[a.id.to_s] << [a.id, a.created_at]
        rescue
          a.destroy
        end
      end
      hash.each{|k,v| hash[k] = v.sort{|a,b| a.last <=> b.last}}
      logger.debug hash
      #self.where(id: hash.map{|k,v| v.map{|x| x.first}}.flatten).delete_all
    end
  end
end
