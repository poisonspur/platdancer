package platdancer;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw(schema resultset rset);
use Schema;
use Data::Dumper;

our $VERSION = '0.1';

our $logged_in;

hook before => sub {

    if ( session('user') ) {
        $logged_in = 1;
    } else {
        $logged_in = 0;
    }

};

get '/' => sub {

    my $site = schema->resultset('Sites')->find(1);
    my $news_items = schema->resultset('NewsItems')->search( {}, {rows => 10, order_by => { -desc => 'created_at'} });

    template 'welcome' => {
        site => $site,
        recent_sitenews => [$news_items->all],
        navbar => _get_navbar('home'),
        latest_news => $news_items->first,
        logged_in => $logged_in,
    };
};

get '/about_dave' => sub {

    my $dave = schema->resultset('People')->find(1);
    my $news_items = schema->resultset('NewsItems')->search( {}, {rows => 10, order_by => { -desc => 'created_at'} });

    template 'about_dave' => {
        recent_sitenews => [$news_items->all],
        navbar => _get_navbar('about_dave'),
        dave => $dave,
        logged_in => $logged_in,
    };

};

get '/about_platypus' => sub {

    my $site = schema->resultset('Sites')->find(1);
    my $news_items = schema->resultset('NewsItems')->search( {}, {rows => 10, order_by => { -desc => 'created_at'} });

    template 'about_platypus' => {
        site => $site,
        recent_sitenews => [$news_items->all],
        navbar => _get_navbar('about_platypus'),
        logged_in => $logged_in,
    };

};

get '/site_news' => sub {

    my $news_items = schema->resultset('NewsItems')->search( {}, { order_by => { -desc => 'created_at'} });
    my @news_items = $news_items->all;
    my @recent_news_items = @news_items;
    $#recent_news_items = 9;

    template 'news_items' => {
        news_items => [@news_items],
        recent_sitenews => [@recent_news_items],
        navbar => _get_navbar('site_news'),
        logged_in => $logged_in,
    };

};

get '/news_items/:id' => sub {

    my $site = schema->resultset('Sites')->find(1);
    my $news_items = schema->resultset('NewsItems')->search( {}, {rows => 10, order_by => { -desc => 'created_at'} });
    my $news_item = schema->resultset('NewsItems')->find( params->{id} );

    template 'show_news_item' => {
        site => $site,
        recent_sitenews => [$news_items->all],
        news_item => $news_item,
        navbar => _get_navbar('site_news'),
        logged_in => $logged_in,
    };


};

any [ 'get', 'post' ] => '/news_items/:id/edit' => sub {

    my $news_items = schema->resultset('NewsItems')->search( {}, {rows => 10, order_by => { -desc => 'created_at'} });
    my $news_item = schema->resultset('NewsItems')->find( params->{id} );


    my $message = '';
    my $q = request->params;

    if ( $q->{commit} ) {

        if ( is_auth() ) {
            $message = "Update successful";
            $news_item->update($q);
            redirect '/news_items/' . params->{id};
        } else {
            $message = "You are not authorized to perform this action";
        }

    }

    template 'edit_news_item' => {
        recent_sitenews => [$news_items->all],
        news_item => $news_item,
        navbar => _get_navbar('site_news'),
        message => $message,
        form_action => '/news_items/edit',
        logged_in => $logged_in,
    };

};

any [ 'get', 'post' ] => '/site_news/add' => sub {

    my $news_items = schema->resultset('NewsItems')->search( {}, {rows => 10, order_by => { -desc => 'created_at'} });
    my $news_item = schema->resultset('NewsItems')->new({});

    my $message = '';
    my $q = request->params;

    if ( $q->{commit} ) {
        if ( is_auth() ) {
            $news_item->insert($q);
            my $id = $news_item->id;
            $message = "Add successful";
            redirect '/news_items/' . $id;
        } else {
            $message = "You are not authorized to perform this action";
        }
    }

    template 'add_news_item' => {
        recent_sitenews => [$news_items->all],
        news_item => $news_item,
        navbar => _get_navbar('site_news'),
        message => $message,
        form_action => '/site_news/add',
        logged_in => $logged_in,
    };

};


any [ 'get', 'post' ] => '/login' => sub {

    my $redir_page = '/';
    my $q = request->params;
    my $message = '';
    if ( $q->{commit} ) {

        my $user = schema->resultset('Users')->search( { email => $q->{user_email} } )->first;
        if ( $user && $user->validate_login($q->{user_email}, $q->{user_password}) ) {
            $redir_page = '/';
            session user => $user->id;
            redirect '/';
        } else {
        }
    } else {
        $redir_page = request->referer;
    } 

    template 'login' => {
        navbar => _get_navbar(''),
        message => $message,
        redir_page => $redir_page,
        logged_in => $logged_in,
    };

};

any [ 'get', 'post' ] => '/logout' => sub {

    session user => undef;
    redirect '/';


};

############################################################

sub is_auth {

    return 1;

}

sub _get_navbar {

    my ($key) = @_;

    my $navbar = {
        home => '',
        about_dave => '',
        about_platypus => '',
        site_news => '',
        projects => '',
    };

    $navbar->{$key} = 'current' if $key;

    return $navbar;

}


true;
