module ModuleHelper
	
	def build_all_privilige
		result = {}
        privilege_data = UserModule.get_all_privilege       

        unless privilege_data.nil?
        	privilege_data.each do |item|        		
        		component = UserComponent.find(item['fk_user_component'])
        		module_key = "#{component[:name]} | #{item['name']}"
        		
        		unless result.has_key?(module_key)
        			result[module_key] = {}
        		end
        		
        		resource_key = item['resource_name']
        		unless result[module_key].has_key?(resource_key)
        			result[module_key][resource_key] = {} 
        		end
        		result[module_key][resource_key][item['privilege_id']]= {
        			'id' => item['privilege_id'],
        			'name' => item['privilege_name']
        		}
        	end
        end        
        result                
	end
end