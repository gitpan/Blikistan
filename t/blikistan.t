#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw/no_plan/;
use Socialtext::Resting::Mock;

BEGIN {
    use_ok 'Blikistan';
    use_ok 'Blikistan::MagicEngine';
    use_ok 'Blikistan::MagicEngine::Perl';
}

my $r = Socialtext::Resting::Mock->new(
    server => 'http://test',
    workspace => 'wksp',
);

Render_page: {
    $r->put_page('Blog Config', "title: bar\n");
    $r->put_page('post1', 'content1');
    $r->put_pagetag('post1', 'blog post');
    $r->response->set_always('header', 'Today');
    my $b = Blikistan->new(
        rester => $r,
        magic_opts => {
            template_name => 'test.tmpl',
        },
    );
    is $b->print_blog, <<EOT;
bar

Posts:
  title: post1
  content: content1
  permalink: http://test/wksp/index.cgi?post1
  date: Today
EOT
}

Munge_wiki_links: {
    $r->put_page('Foo', 'Some <a href="other_page">other page</a>');
    my $page = Blikistan::MagicEngine::Perl::_get_page($r, 'Foo');
    is $page, 'Some <a href="http://test/wksp/index.cgi?other_page">'
              . 'other page</a>';

    $r->put_page('Bar', q{Note to self: <a href="internal_wiki_links" >internal wiki links</a> aren't working yet.});
    $page = Blikistan::MagicEngine::Perl::_get_page($r, 'Bar');
    is $page, q{Note to self: <a href="http://test/wksp/index.cgi?internal_wiki_links">internal wiki links</a> aren't working yet.};
}

Template_in_the_wiki: {
    $r->put_page('Blog Template', 'title: [% title %]');
    $r->put_page('Blog Config', "title: bar\n");
    my $b = Blikistan->new(
        rester => $r,
        magic_opts => {
            template_page => 'Blog Template',
        },
    );
    is $b->print_blog, 'title: bar';
}
