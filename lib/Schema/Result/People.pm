package Schema::Result::People;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('people');
__PACKAGE__->add_columns(qw/ id last_name first_name email summary created_at updated_at profile_photo/);
__PACKAGE__->set_primary_key('id');

1;
