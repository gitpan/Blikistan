package Blikistan::MagicEngine::Perl;
use strict;
use warnings;
use base 'Blikistan::MagicEngine';
use Template;
use Socialtext::WikiObject::YAML;

sub print_blog {
    my $self = shift;
    my $r = $self->{rester};
    
    my $params = Socialtext::WikiObject::YAML->new(
        rester => $r, 
        page => $self->{config_page},
    )->as_hash;

    my $show_latest = delete $params->{show_latest_posts}
        || $self->{show_latest_posts};

    my @posts = $r->get_taggedpages($self->{post_tag});
    @posts = splice @posts, 0, $show_latest;

    $r->accept('text/html');
    my $server_url = $r->server . $r->workspace;
    $params->{posts} = [
        map { 
            title => $_, 
            content => $r->get_page($_),
            permalink => "$server_url/index.cgi?$_",
        }, @posts,
    ];

    my $template = Template->new({ INCLUDE_PATH => $FindBin::Bin });
    $template->process( $self->{template_name}, $params ) or
        die $template->error;
}

1;

