package Schema::Result::Sites;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('sites');
__PACKAGE__->add_columns(qw/ id created_at updated_at base_name disp_name is_home_ssl admin_email welcome about/);
__PACKAGE__->set_primary_key('id');

1;
