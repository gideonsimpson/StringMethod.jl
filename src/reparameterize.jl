"""
`spline_reparametrize`: Reparametrize a string of points with a specified
distance function using cubic spline interpolation
"""
function spline_reparametrize!(U, dist::TD) where {TD}
    n_images = length(U);
    n = length(U[1]);
    s = zeros(n_images);

    # reference image values
    s_ref = LinRange(0, 1, n_images);

    # compute integrated arc length
    for i in 2:n_images
        s[i] = s[i-1] + norm(dist.(U[i], U[i-1]));
    end
    # normalize
    @. s = s/s[end];

    # interpolate back onto the uniform mesh
    for j in 1:n
        # Construct spline through the j-th image
        spl = Spline1D(s, [U[i][j] for i in 1:n_images], k=3);
        u_spl = spl(s_ref);
        # Interpolate the j-th image
        for i in 1:n_images
            U[i][j] = u_spl[i];
        end
    end
    U
end