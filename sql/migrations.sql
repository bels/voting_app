-- 1 up
CREATE TABLE campaign(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT NOT NULL,
	election_date TIMESTAMPTZ NOT NULL,
	nomination_deadline TIMESTAMPTX NOT NULL,
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON campaign TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON campaign
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE authorized_voters(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	voter TEXT NOT NULL UNIQUE,
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON authorized_voters TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON authorized_voters
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE candidate(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT NOT NULL,
	bio TEXT,
	platform TEXT,
	campaign UUID NOT NULL REFERENCES campaign(id),
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON candidate TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON candidate
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE votes(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	candidate UUID NOT NULL REFERENCES candidate(id),
	campaign UUID NOT NULL REFERENCES campaign(id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON votes TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON votes
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE offices(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT NOT NULL,
	campaign UUID NOT NULL REFERENCES campaign(id),
	active BOOLEAN DEFAULTE true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON offices TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON offices
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE nominations(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT NOT NULL,
	office UUID NOT NULL REFERENCES offices(id),
	campaign UUID NOT NULL REFERENCES campaign(id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON nominations TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON nominations
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE voter_tracking(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	voter UUID NOT NULL REFERENCES authorized_voters(id),
	campaign UUID NOT NULL REFERENCES campaign(id)  
);

GRANT SELECT, INSERT, UPDATE, DELETE ON voter_tracking TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON voter_tracking
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

INSERT INTO campaign (name, nomination_deadline, election_date) VALUES ('2018 Election',now() + '1 month'::INTERVAL,now() + '2 months'::INTERVAL);
INSERT INTO offices (name,campaign) VALUES ('President',(SELECT id FROM campaign));
INSERT INTO offices (name,campaign) VALUES ('Vice President',(SELECT id FROM campaign));
INSERT INTO offices (name,campaign) VALUES ('Secretary',(SELECT id FROM campaign));
INSERT INTO offices (name,campaign) VALUES ('Treasurer',(SELECT id FROM campaign));
INSERT INTO offices (name,campaign) VALUES ('Event Coordinator',(SELECT id FROM campaign));