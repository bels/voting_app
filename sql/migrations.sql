-- 1 up
CREATE TABLE campaign(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT NOT NULL,
	election_date TIMESTAMPTZ NOT NULL
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON campaign TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON campaign
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE authorized_voters(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	voter TEXT NOT NULL,
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

CREATE TABLE vote(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	candidate UUID NOT NULL REFERENCES candidate(id),
	campaign UUID NOT NULL REFERENCES campaign(id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON vote TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON vote
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE offices(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT NOT NULL,
	active BOOLEAN DEFAULTE true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON offices TO voting_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON offices
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();