function struct = solution_1(dataFileName)

    points = readmatrix(dataFileName);
    points = sortrows(points, [2, 1, 3]);

    struct.current = points(:, 1);
    struct.airgap  = points(:, 2);
    struct.force   = points(:, 3);

end