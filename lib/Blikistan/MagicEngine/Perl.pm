package Blikistan::MagicEngine::Perl;
use strict;
use warnings;
use base 'Blikistan::MagicEngine::TT2';
use base 'Blikistan::MagicEngine::YamlConfig';

sub print_blog {
    my $self = shift;
    my $r = $self->{rester};
    
    my $params = $self->load_config($r);
    $params->{rester} = $r;
    ($params->{post_tag} = $self->{post_tag}) =~ s/ /%20/g;

    my $show_latest = delete $params->{show_latest_posts}
        || $self->{show_latest_posts};

    my @posts = grep { !/template$/i } $r->get_taggedpages($self->{post_tag});
    @posts = splice @posts, 0, $show_latest;

    $r->accept('text/html');
    $params->{posts} = [
        map { 
            title => $_, 
            content => _get_page($r, $_),
            permalink => _linkify($r, $_),
            date => $r->response->header('Last-Modified'),
        }, @posts,
    ];

    return $self->render_template( $params );
}

sub _linkify {
    my $r = shift;
    my $page = shift;
    return $r->server . $r->workspace . "/index.cgi?$page";
}

sub _get_page {
    my $r = shift;
    my $page_name = shift;
    my $html = $r->get_page($page_name) || '';

    while ($html =~ s/<a href="([\w_]+)"\s*>/'<a href="' . _linkify($r, $1) . '">'/eg) {}
    return $html;
}

1;

