package VotingApp;
use Mojo::Base 'Mojolicious';

use Mojo::Pg;
use VotingApp::Model::Core;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');
  $self->helper(pg => sub { state $pg = Mojo::Pg->new( shift->config('pg'))});
  $self->helper(core => sub { 
	my $app = shift;
	state $core = VotingApp::Model::Core->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 :  0) ;
  });

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};
  $self->sessions->default_expiration('3600');
  
  #Keeping the database in sync - Will mess with this someday
  #$self->pg->migrations->from_file('./sql/migrations.sql')->migrate;
  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('core#index')->name('index');
  $r->get('/nominate')->to('core#nominate_form')->name('nominate_form');
  $r->post('/nominate')->to('core#nominate')->name('nominate');
  $r->get('/vote')->to('core#vote_form')->name('vote_form');
  $r->post('/vote')->to('core#vote')->name('vote');
  $r->get('/login')->to('auth#login_form')->name('login_form');
  $r->post('/login')->to('auth#login')->name('login');
  my $authed = $r->under()->to('auth#check_session');
  $r->get('/campaigns')->to('core#campaign_list')->name('campaigns');
  $r->get('/results/:campaign_id')->to('core#campaign')->name('campaign');
  $r->get('/thanks')->to('core#thanks')->name('thanks');
}

1;
