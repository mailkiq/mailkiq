--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.1
-- Dumped by pg_dump version 9.5.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id integer NOT NULL,
    name character varying NOT NULL,
    email citext NOT NULL,
    encrypted_password character varying NOT NULL,
    language character varying,
    time_zone character varying DEFAULT 'UTC'::character varying,
    api_key uuid DEFAULT uuid_generate_v4(),
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    aws_access_key_id character varying,
    aws_secret_access_key character varying,
    aws_region character varying,
    aws_topic_arn character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    aws_queue_url character varying,
    used_credits integer DEFAULT 0 NOT NULL,
    iugu_subscription_id uuid,
    iugu_customer_id uuid
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE campaigns (
    id integer NOT NULL,
    name citext NOT NULL,
    subject character varying NOT NULL,
    from_name character varying NOT NULL,
    from_email character varying NOT NULL,
    reply_to character varying,
    plain_text text,
    html_text text NOT NULL,
    recipients_count integer DEFAULT 0 NOT NULL,
    unique_opens_count integer DEFAULT 0 NOT NULL,
    unique_clicks_count integer DEFAULT 0 NOT NULL,
    bounces_count integer DEFAULT 0 NOT NULL,
    complaints_count integer DEFAULT 0 NOT NULL,
    account_id integer NOT NULL,
    sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying DEFAULT ''::character varying NOT NULL,
    send_settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    trigger_settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    state integer NOT NULL
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE campaigns_id_seq OWNED BY campaigns.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE domains (
    id integer NOT NULL,
    name citext NOT NULL,
    verification_token character varying NOT NULL,
    verification_status integer NOT NULL,
    dkim_tokens text[] NOT NULL,
    dkim_verification_status integer NOT NULL,
    mail_from_domain_status integer NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE messages (
    id integer NOT NULL,
    uuid character varying(60) NOT NULL,
    token character varying(32) NOT NULL,
    referer character varying,
    user_agent character varying,
    ip_address inet,
    subscriber_id integer NOT NULL,
    campaign_id integer NOT NULL,
    sent_at timestamp without time zone NOT NULL,
    opened_at timestamp without time zone,
    clicked_at timestamp without time zone,
    state integer DEFAULT 0 NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id integer NOT NULL,
    data jsonb NOT NULL,
    message_id integer NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subscribers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subscribers (
    id integer NOT NULL,
    name character varying,
    email citext NOT NULL,
    state integer NOT NULL,
    custom_fields jsonb DEFAULT '{}'::jsonb NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    unsubscribed_at timestamp without time zone
);


--
-- Name: subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscribers_id_seq OWNED BY subscribers.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    subscriber_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying NOT NULL,
    slug citext NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns ALTER COLUMN id SET DEFAULT nextval('campaigns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscribers ALTER COLUMN id SET DEFAULT nextval('subscribers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_api_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_api_key ON accounts USING btree (api_key);


--
-- Name: index_accounts_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_email ON accounts USING btree (email);


--
-- Name: index_accounts_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_reset_password_token ON accounts USING btree (reset_password_token);


--
-- Name: index_bounced_notifications; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bounced_notifications ON notifications USING btree (message_id) WHERE (data ? 'bouncedRecipients'::text);


--
-- Name: index_campaigns_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaigns_on_account_id ON campaigns USING btree (account_id);


--
-- Name: index_campaigns_on_name_and_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_campaigns_on_name_and_account_id ON campaigns USING btree (name, account_id);


--
-- Name: index_complained_notifications; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_complained_notifications ON notifications USING btree (message_id) WHERE (data ? 'complainedRecipients'::text);


--
-- Name: index_domains_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_domains_on_account_id ON domains USING btree (account_id);


--
-- Name: index_domains_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_domains_on_name ON domains USING btree (name);


--
-- Name: index_messages_on_campaign_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_campaign_id ON messages USING btree (campaign_id);


--
-- Name: index_messages_on_subscriber_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_subscriber_id ON messages USING btree (subscriber_id);


--
-- Name: index_messages_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_token ON messages USING btree (token);


--
-- Name: index_messages_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_uuid ON messages USING btree (uuid);


--
-- Name: index_notifications_on_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_message_id ON notifications USING btree (message_id);


--
-- Name: index_subscribers_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscribers_on_account_id ON subscribers USING btree (account_id);


--
-- Name: index_subscribers_on_account_id_and_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscribers_on_account_id_and_email ON subscribers USING btree (account_id, email);


--
-- Name: index_subscribers_on_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscribers_on_custom_fields ON subscribers USING gin (custom_fields);


--
-- Name: index_taggings_on_subscriber_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_subscriber_id ON taggings USING btree (subscriber_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_tags_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_account_id ON tags USING btree (account_id);


--
-- Name: index_tags_on_slug_and_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_slug_and_account_id ON tags USING btree (slug, account_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_0537675996; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_0537675996 FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE;


--
-- Name: fk_rails_06c0f322c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns
    ADD CONSTRAINT fk_rails_06c0f322c9 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;


--
-- Name: fk_rails_248684c8cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_rails_248684c8cf FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE;


--
-- Name: fk_rails_430c86ced8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT fk_rails_430c86ced8 FOREIGN KEY (subscriber_id) REFERENCES subscribers(id) ON DELETE CASCADE;


--
-- Name: fk_rails_6f6670cc65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT fk_rails_6f6670cc65 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_86647bc40a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT fk_rails_86647bc40a FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;


--
-- Name: fk_rails_9fcd2e236b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT fk_rails_9fcd2e236b FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;


--
-- Name: fk_rails_c49ae5d0c8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_c49ae5d0c8 FOREIGN KEY (subscriber_id) REFERENCES subscribers(id) ON DELETE CASCADE;


--
-- Name: fk_rails_ebaf908896; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscribers
    ADD CONSTRAINT fk_rails_ebaf908896 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20151014232849');

INSERT INTO schema_migrations (version) VALUES ('20151015212030');

INSERT INTO schema_migrations (version) VALUES ('20151015224826');

INSERT INTO schema_migrations (version) VALUES ('20151018205618');

INSERT INTO schema_migrations (version) VALUES ('20151018211214');

INSERT INTO schema_migrations (version) VALUES ('20160202125621');

INSERT INTO schema_migrations (version) VALUES ('20160203115340');

INSERT INTO schema_migrations (version) VALUES ('20160215134153');

INSERT INTO schema_migrations (version) VALUES ('20160215135604');

INSERT INTO schema_migrations (version) VALUES ('20160222132702');

INSERT INTO schema_migrations (version) VALUES ('20160417033444');

INSERT INTO schema_migrations (version) VALUES ('20160428181200');

INSERT INTO schema_migrations (version) VALUES ('20160501172858');

INSERT INTO schema_migrations (version) VALUES ('20160518001918');

INSERT INTO schema_migrations (version) VALUES ('20160520183454');

INSERT INTO schema_migrations (version) VALUES ('20160520214010');

INSERT INTO schema_migrations (version) VALUES ('20160522235154');

INSERT INTO schema_migrations (version) VALUES ('20160526172302');

INSERT INTO schema_migrations (version) VALUES ('20160528115228');

INSERT INTO schema_migrations (version) VALUES ('20160531231716');

INSERT INTO schema_migrations (version) VALUES ('20160604154720');

INSERT INTO schema_migrations (version) VALUES ('20160604162650');

INSERT INTO schema_migrations (version) VALUES ('20160604163301');

