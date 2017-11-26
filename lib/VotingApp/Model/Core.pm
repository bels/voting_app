package VotingApp::Model::Core;
use Mojo::Base -base;

#use Platform::Log;
has 'pg';
has 'debug';

sub voting_phase{
	my ($self,$campaign_id) = @_;

	my $reached_deadline = $self->pg->db->query('select nomination_deadline, case when now() >= nomination_deadline then 1 else 0 END from campaign where id = ?',$campaign_id)->hash;
	
	if($reached_deadline->{'case'}){
		#if we reached the nomination deadline it is time to vote.
		return 'voting';
	} else {
		return 'nomination';
	}
}

#will return the latest campaign id
sub get_current_campaign{
	my $self = shift;
	
	my $campaign = $self->pg->db->query('select * from campaign order by election_date desc limit 1')->hash;
	
	return $campaign;
}

sub get_campaign_list{
	my $self = shift;

	my $campaign_list = $self->pg->db->query('select id,name from campaign where active = true order by genesis desc')->hashes->to_array;
	
	return $campaign_list;
}

sub get_offices{
	my ($self, $campaign_id) = @_;
	
	my $offices = $self->pg->db->query('select name,id from offices where campaign = ?', $campaign_id)->arrays->to_array;
	
	return $offices;
}

sub record_nominations{
	my ($self,$data) = @_;
	
	#first check to see if they are eligible to vote
	my $eligible = $self->pg->db->query('select count(*) from authorized_voters where voter = ? and active = true',$data->{'voter'})->hash;
	if($eligible->{'count'}){
		for(my $i = 0; $i < scalar @{$data->{'offices'}}; $i++){
			$self->pg->db->query('insert into nominations (name, office, campaign) values (?,?,?)',$data->{'offices'}->[$i],$data->{'office_ids'}->[$i],$data->{'campaign'});
		}
		return 1;
	} else {
		#couldn't vote
		return 0;
	}
	
}

sub record_votes{
	my ($self,$data) = @_;
	use Data::Dumper;
	warn Dumper $data;
	#first check to see if this person is eligible to vote
	my $eligible = $self->pg->db->query('select count(*) from authorized_voters where voter = ? and active = true',$data->{'voter'})->hash;
	if($eligible->{'count'}){
		#second check to see if they have already voted
		my $already_voted = $self->pg->db->query('select count(*) from voter_tracking where voter = (select id from authorized_voters where voter = ?) and campaign = ?', $data->{'voter'}, $data->{'campaign'})->hash;
		unless($already_voted->{'count'}){
			foreach my $office (keys $data->{'votes'}){
				$self->pg->db->query('insert into votes(candidate, campaign, office) values (?,?,(select id from offices where name = ?))',$data->{'votes'}->{$office},$data->{'campaign'},$office) ;
				$self->pg->db->query('insert into voter_tracking(voter,campaign) values((select id from authorized_voters where voter = ?),?)',$data->{'voter'},$data->{'campaign'});
			}
		} else {
			return {code => -2, message => 'Already voted'};
		}
	} else {
		return {code => -1, message => 'Not eligible to vote'};
	}
}

sub get_voting_results{
	my ($self,$campaign) = @_;

	my $results = $self->pg->db->query('select c.name,count(c.name) as votes,o.name as office from votes v join candidate c on v.candidate = c.id join offices o on v.office = o.id where v.campaign = ? group by c.name, o.name',$campaign)->hashes->to_array;
}

sub get_candidates{
	my ($self,$campaign_id) = @_;
	
	my $candidates = $self-> pg->db->query('select array_agg(c.id) as candidate_ids, array_agg(c.name) as candidates,office,o.name from candidate c join offices o on c.office = o.id where c.campaign = ? group by office,o.name', $campaign_id)->hashes->to_array;
	
	return $candidates;
}
1;
