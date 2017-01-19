-- mod_c2s_limit_sessions_kickold

local next, count = next, require "util.iterators".count;

local max_resources = module:get_option_number("max_resources", 1);

local sessions = hosts[module.host].sessions;
module:hook("resource-bind", function(event)
	local session = event.session;
	if count(next, sessions[session.username].sessions) > max_resources then

		for resource, session in pairs(sessions[session.username].sessions) 
		do if session ~= event.session then 
		session:close{ condition = "policy-violation", text = "Too many resources" };
		end end
		return false
	end
end, -1);

for resource, session in pairs(sessions[session.username].sessions) 
do if session ~= event.session then 
session:close() end end

