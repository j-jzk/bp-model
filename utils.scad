module mirror_copy(v = [1,0,0]) {
    children();
    mirror(v) {
        children();
    }
}

module rounded_rect(size, r, center=false) {
    module _shape() {
        hull() {
            translate([r, r]) circle(r);
            translate([size.x - r, r]) circle(r);
            translate([r, size.y - r]) circle(r);
            translate([size.x - r, size.y - r]) circle(r);
        }
    }
    if (!center)
        _shape();
    else 
        translate([-size.x/2, -size.y/2]) _shape();
}
