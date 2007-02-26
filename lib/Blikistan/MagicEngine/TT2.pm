package Blikistan::MagicEngine::TT2;
use strict;
use warnings;
use base 'Blikistan::MagicEngine';
use Template;
use FindBin;

sub render_template {
    my $self = shift;
    my $params = shift;

    $params->{magic_engine} = ref($self);
    my $path = join ': ', 
               grep { defined }
               ($self->{template_path}, $FindBin::Bin);
    my $template = Template->new( { INCLUDE_PATH => $path } );
    my $output = '';
    my $tmpl = $self->{template_name};
    if ($self->{template_page}) {
        $self->{rester}->accept('text/x.socialtext-wiki');
        my $content = $self->{rester}->get_page($self->{template_page});
        $content =~ s/^\.pre\n(.+?)\.pre\n?.*/$1/s;
        $tmpl = \$content;
    }
    $template->process( $tmpl, $params, \$output) or
        die $template->error;
    return $output;
}

1;
