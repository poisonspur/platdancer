package Schema::Result::NewsItems;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('news_items');
__PACKAGE__->add_columns(qw/ id created_at updated_at body/);
__PACKAGE__->set_primary_key('id');

sub update {

    my ($self, $q) = @_;


    if ( is_valid($q) ) {

        $self->SUPER::update( { body =>, $q->{body}, updated_at => \'NOW()' } );
    }

}


sub insert {

    my ($self, $q) = @_;

    if ( is_valid($q) ) {
        $self->SUPER::set_columns( { body => $q->{body}, 
                                created_at => \'NOW()', 
                                updated_at => \'NOW()' 
                              } );
        $self->SUPER::insert;
    }


}

sub is_valid {

    my ($q) = @_;

    unless ( $q->{body} ) {
        return 0;
    }

    return 1;

}

1;
