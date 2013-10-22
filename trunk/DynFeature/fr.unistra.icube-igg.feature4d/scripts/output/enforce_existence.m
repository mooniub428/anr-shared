function [ ] = enforce_existence( dir_name )

if(~exist(dir_name))
    mkdir(dir_name);
end % if

end % function

