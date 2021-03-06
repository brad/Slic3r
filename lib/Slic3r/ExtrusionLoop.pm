package Slic3r::ExtrusionLoop;
use Moo;

use XXX;

extends 'Slic3r::Polyline::Closed';

# perimeter/fill/solid-fill/bridge/skirt
has 'role'         => (is => 'rw', required => 1);

sub split_at {
    my $self = shift;
    my ($point) = @_;
    
    $point = Slic3r::Point->new($point);
    
    # find index of point
    my $i = -1;
    for (my $n = 0; $n <= $#{$self->points}; $n++) {
        if ($point->id eq $self->points->[$n]->id) {
            $i = $n;
            last;
        }
    }
    die "Point not found" if $i == -1;
    
    my @new_points = ();
    push @new_points, @{$self->points}[$i .. $#{$self->points}];
    push @new_points, @{$self->points}[0 .. $i];
    
    return Slic3r::ExtrusionPath->new(points => [@new_points], role => $self->role);
}

1;
