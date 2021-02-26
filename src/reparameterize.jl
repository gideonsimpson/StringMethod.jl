"""
`spline_reparametrize`: Reparametrize a string of points with a specified
distance function using cubic spline interpolation
"""
function spline_reparametrize!(U, dist::TD, pin::Bool) where {TD}
    n_images = length(U);
    d = length(U[1]); #dimension of the each image
    s = zeros(n_images);

    # reference image values
    s_ref = LinRange(0, 1, n_images);

    # compute integrated arc length
    for i in 2:n_images
        s[i] = s[i-1] + dist(U[i], U[i-1]);
    end
    # normalize
    @. s = s/s[end];

    # interpolate back onto the uniform mesh
    for j in 1:d
        # Construct spline through the j-th image
        spl = Spline1D(s, [U[i][j] for i in 1:n_images], k=3);
        u_spl = spl(s_ref);
        # Interpolate the j-th image
        for i in 2:n_images-1
            U[i][j] = u_spl[i];
        end
        if !pin
            U[1][j] = u_spl[1];
            U[end][j] = u_spl[end];
        end
    end
    U
end