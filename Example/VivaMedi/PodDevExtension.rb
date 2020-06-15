$REGISTERED_DEPENDENCIES = Hash.new

self.class.class_eval do
	module DSL
		alias_method "origin_pod", "pod"
	end	
end
self.define_singleton_method("pod") do |name, *requirements|
	if $REGISTERED_DEPENDENCIES[name]
		puts "skip #{name.red} with #{requirements}"
	else
		puts "install #{name.yellow} with #{requirements}"
		self.send("origin_pod", name, *requirements)
		$REGISTERED_DEPENDENCIES[name] = requirements
	end
end


eval(File.open('Podfile.local').read) if File.exist? 'Podfile.local' 
