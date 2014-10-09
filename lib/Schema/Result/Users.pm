package Schema::Result::Users;

use base qw/DBIx::Class::Core/;
use Dancer::Plugin::Passphrase;

__PACKAGE__->table('users');
__PACKAGE__->add_columns(qw/ id email encrypted_password reset_password_token reset_password_sent_at remember_created_at sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip created_at updated_at salt/);
__PACKAGE__->set_primary_key('id');


sub validate_login {

    my ($self, $user_email, $user_password) = @_;

    my $h = passphrase($user_password)->generate( { salt => $self->salt} );
    my $encrypted_password = $h->rfc2307;
    if ( $encrypted_password eq $self->encrypted_password ) {
        return 1;
    }

    return 0;

}

1;
