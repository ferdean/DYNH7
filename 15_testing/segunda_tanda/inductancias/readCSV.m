function struct = readCSV(directory, offset)

struct = dir(fullfile(directory,'*.csv')); 

for k = 1:numel(struct)
    F = fullfile(directory, struct(k).name);
    struct(k).data = csvread(F, offset, 0);
    struct(k).time = struct(k).data(:, 1);
    struct(k).data = struct(k).data(:, 2);
end

struct = rmfield(struct, "folder");
struct = rmfield(struct, "date");
struct = rmfield(struct, "isdir");
struct = rmfield(struct, "datenum");
