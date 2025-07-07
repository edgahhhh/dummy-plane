function requireFields(s, fieldList, structName)
% REQUIREFIELDS Validates that a struct contains required fields.
%
%   requireFields(S, FIELDLIST) checks that all fields in FIELDLIST are
%   present in the struct S. Throws an error if any are missing.
%
%   requireFields(S, FIELDLIST, STRUCTNAME) allows you to specify the name
%   of the struct (used in error messages for clarity).

    if nargin < 3
        structName = 'input struct';
    end

    for i = 1:numel(fieldList)
        if ~isfield(s, fieldList{i})
            error('Missing required field "%s" in %s.', fieldList{i}, structName);
        end
    end
end