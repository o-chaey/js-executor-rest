--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-1.pgdg110+1)
-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO kc_db_admin;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO kc_db_admin;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO kc_db_admin;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO kc_db_admin;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO kc_db_admin;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO kc_db_admin;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO kc_db_admin;

--
-- Name: client; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO kc_db_admin;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    value character varying(4000),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_attributes OWNER TO kc_db_admin;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO kc_db_admin;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO kc_db_admin;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO kc_db_admin;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO kc_db_admin;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO kc_db_admin;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO kc_db_admin;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO kc_db_admin;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO kc_db_admin;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO kc_db_admin;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO kc_db_admin;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO kc_db_admin;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO kc_db_admin;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO kc_db_admin;

--
-- Name: component; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO kc_db_admin;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO kc_db_admin;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO kc_db_admin;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO kc_db_admin;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO kc_db_admin;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO kc_db_admin;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO kc_db_admin;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO kc_db_admin;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO kc_db_admin;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO kc_db_admin;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO kc_db_admin;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO kc_db_admin;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO kc_db_admin;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO kc_db_admin;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO kc_db_admin;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO kc_db_admin;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO kc_db_admin;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO kc_db_admin;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO kc_db_admin;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO kc_db_admin;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO kc_db_admin;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO kc_db_admin;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO kc_db_admin;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO kc_db_admin;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO kc_db_admin;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO kc_db_admin;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO kc_db_admin;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO kc_db_admin;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO kc_db_admin;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO kc_db_admin;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO kc_db_admin;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO kc_db_admin;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO kc_db_admin;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO kc_db_admin;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO kc_db_admin;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO kc_db_admin;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO kc_db_admin;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO kc_db_admin;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO kc_db_admin;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO kc_db_admin;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO kc_db_admin;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO kc_db_admin;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO kc_db_admin;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO kc_db_admin;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO kc_db_admin;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO kc_db_admin;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO kc_db_admin;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO kc_db_admin;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO kc_db_admin;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO kc_db_admin;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO kc_db_admin;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO kc_db_admin;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO kc_db_admin;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO kc_db_admin;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO kc_db_admin;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO kc_db_admin;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO kc_db_admin;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO kc_db_admin;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO kc_db_admin;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO kc_db_admin;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO kc_db_admin;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO kc_db_admin;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO kc_db_admin;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO kc_db_admin;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO kc_db_admin;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO kc_db_admin;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO kc_db_admin;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO kc_db_admin;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO kc_db_admin;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: kc_db_admin
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO kc_db_admin;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
d9825d7e-dd79-475d-97dd-d27a80922b9b	\N	auth-cookie	328a8777-dc28-41dd-931b-66af1660c31c	560df60e-1a9b-4a64-ad30-146026c9f58c	2	10	f	\N	\N
47e47cad-ac53-49cb-a55a-7edf5aba597f	\N	auth-spnego	328a8777-dc28-41dd-931b-66af1660c31c	560df60e-1a9b-4a64-ad30-146026c9f58c	3	20	f	\N	\N
b831ec01-02ec-4e94-8cc2-d2157ad27b17	\N	identity-provider-redirector	328a8777-dc28-41dd-931b-66af1660c31c	560df60e-1a9b-4a64-ad30-146026c9f58c	2	25	f	\N	\N
efabff9e-8c0b-4019-b279-f53e367e0ab7	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	560df60e-1a9b-4a64-ad30-146026c9f58c	2	30	t	110410e9-7d9e-41a8-9721-5c7953222557	\N
56051df1-8c16-447d-9d1a-ed05c2709908	\N	auth-username-password-form	328a8777-dc28-41dd-931b-66af1660c31c	110410e9-7d9e-41a8-9721-5c7953222557	0	10	f	\N	\N
b374c562-c148-4f9d-adbc-0464863f2035	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	110410e9-7d9e-41a8-9721-5c7953222557	1	20	t	18671a59-6a47-4b4c-aec9-73ef57500230	\N
f34f8d22-1f1d-43d8-b6f6-7f64b0e80897	\N	conditional-user-configured	328a8777-dc28-41dd-931b-66af1660c31c	18671a59-6a47-4b4c-aec9-73ef57500230	0	10	f	\N	\N
a4950690-56bc-4156-b951-46ac4f611989	\N	auth-otp-form	328a8777-dc28-41dd-931b-66af1660c31c	18671a59-6a47-4b4c-aec9-73ef57500230	0	20	f	\N	\N
4dbd947e-c47a-4323-a23f-a28bcad6edcf	\N	direct-grant-validate-username	328a8777-dc28-41dd-931b-66af1660c31c	c8df21b1-3808-48da-9146-3546dee7972e	0	10	f	\N	\N
2611eecf-40de-4d25-96d3-4aaafd663c72	\N	direct-grant-validate-password	328a8777-dc28-41dd-931b-66af1660c31c	c8df21b1-3808-48da-9146-3546dee7972e	0	20	f	\N	\N
3349ee62-477a-44d4-ad78-72fe5f0ee42b	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	c8df21b1-3808-48da-9146-3546dee7972e	1	30	t	1df0e190-998b-41b1-8ff1-42a34be739a6	\N
99fec03a-aea6-4171-b6a1-1f11b47b264a	\N	conditional-user-configured	328a8777-dc28-41dd-931b-66af1660c31c	1df0e190-998b-41b1-8ff1-42a34be739a6	0	10	f	\N	\N
d74fb53a-11f2-4ca0-b2dc-093e50235c51	\N	direct-grant-validate-otp	328a8777-dc28-41dd-931b-66af1660c31c	1df0e190-998b-41b1-8ff1-42a34be739a6	0	20	f	\N	\N
c1d9fddd-0c6f-4f91-a36d-f6d14d3742eb	\N	registration-page-form	328a8777-dc28-41dd-931b-66af1660c31c	e4a1f86d-bd20-4687-bcda-22be338747d8	0	10	t	499ee03b-b430-41f5-86fc-f355fba37fcb	\N
015cf71c-b84b-411f-b8ca-75d91a605d7c	\N	registration-user-creation	328a8777-dc28-41dd-931b-66af1660c31c	499ee03b-b430-41f5-86fc-f355fba37fcb	0	20	f	\N	\N
aff411c8-af8b-45f3-93c5-d72958585d1a	\N	registration-profile-action	328a8777-dc28-41dd-931b-66af1660c31c	499ee03b-b430-41f5-86fc-f355fba37fcb	0	40	f	\N	\N
c6cab639-283e-4e25-baff-424d6c13211c	\N	registration-password-action	328a8777-dc28-41dd-931b-66af1660c31c	499ee03b-b430-41f5-86fc-f355fba37fcb	0	50	f	\N	\N
9c001927-cfff-4fb8-9b62-681a92ab5372	\N	registration-recaptcha-action	328a8777-dc28-41dd-931b-66af1660c31c	499ee03b-b430-41f5-86fc-f355fba37fcb	3	60	f	\N	\N
74d0f317-b6ae-424b-8bb4-f22b6eef58c9	\N	reset-credentials-choose-user	328a8777-dc28-41dd-931b-66af1660c31c	22d0d2a0-d8be-4600-9c9d-4807035e396f	0	10	f	\N	\N
1a7370a1-bd75-4737-9c8b-d1c38cbd0ff3	\N	reset-credential-email	328a8777-dc28-41dd-931b-66af1660c31c	22d0d2a0-d8be-4600-9c9d-4807035e396f	0	20	f	\N	\N
b4888a20-b4ce-4ee6-b725-920b7b7d0559	\N	reset-password	328a8777-dc28-41dd-931b-66af1660c31c	22d0d2a0-d8be-4600-9c9d-4807035e396f	0	30	f	\N	\N
10c21722-cbdb-4cbd-b4f6-57f33cefd3b5	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	22d0d2a0-d8be-4600-9c9d-4807035e396f	1	40	t	e21429ab-add8-4bd1-8e1b-ead25ffadd41	\N
d709fdfd-60ea-455c-a174-5ff159678fff	\N	conditional-user-configured	328a8777-dc28-41dd-931b-66af1660c31c	e21429ab-add8-4bd1-8e1b-ead25ffadd41	0	10	f	\N	\N
25f5db69-74bd-461f-87e3-cfabe3e5ee1a	\N	reset-otp	328a8777-dc28-41dd-931b-66af1660c31c	e21429ab-add8-4bd1-8e1b-ead25ffadd41	0	20	f	\N	\N
87958054-79f7-464c-a730-2b0c0df65486	\N	client-secret	328a8777-dc28-41dd-931b-66af1660c31c	c86dd04d-b0e4-4580-8f6c-5721bb86e5e3	2	10	f	\N	\N
04d31ab0-835e-49e4-8ba4-014930f55e85	\N	client-jwt	328a8777-dc28-41dd-931b-66af1660c31c	c86dd04d-b0e4-4580-8f6c-5721bb86e5e3	2	20	f	\N	\N
9959928b-8dc9-4520-a780-a2ac8655863a	\N	client-secret-jwt	328a8777-dc28-41dd-931b-66af1660c31c	c86dd04d-b0e4-4580-8f6c-5721bb86e5e3	2	30	f	\N	\N
38ffc5ba-460f-46b3-ba81-0c94f54e4370	\N	client-x509	328a8777-dc28-41dd-931b-66af1660c31c	c86dd04d-b0e4-4580-8f6c-5721bb86e5e3	2	40	f	\N	\N
f5225998-21b5-4dd5-9c6f-f14933f31d06	\N	idp-review-profile	328a8777-dc28-41dd-931b-66af1660c31c	e5a54abe-ddfa-4194-bdda-9df724112dc4	0	10	f	\N	86c8d9a7-ef82-4bc7-945e-9430b1b7fdec
ae48164c-5d63-405e-8a85-a3c87da68b81	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	e5a54abe-ddfa-4194-bdda-9df724112dc4	0	20	t	fa9adfca-e910-4a45-bfe8-0b975556946a	\N
1b90c900-19cb-45f6-a414-3cfca8ed7067	\N	idp-create-user-if-unique	328a8777-dc28-41dd-931b-66af1660c31c	fa9adfca-e910-4a45-bfe8-0b975556946a	2	10	f	\N	07e72f02-753d-4210-adb5-fb0b47233ce3
0130c1b0-460a-4ace-b59e-d9b124e070c9	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	fa9adfca-e910-4a45-bfe8-0b975556946a	2	20	t	760117c2-5880-4633-acc6-3896b9fd4327	\N
54786250-9cf9-4a9b-8926-550c43397af8	\N	idp-confirm-link	328a8777-dc28-41dd-931b-66af1660c31c	760117c2-5880-4633-acc6-3896b9fd4327	0	10	f	\N	\N
c33c350d-bc29-4cf5-a520-41fb3bccdf83	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	760117c2-5880-4633-acc6-3896b9fd4327	0	20	t	b2423cee-3e59-4740-8301-4b9e7b42253a	\N
da2fd944-f898-4928-8fd0-fec3cc076918	\N	idp-email-verification	328a8777-dc28-41dd-931b-66af1660c31c	b2423cee-3e59-4740-8301-4b9e7b42253a	2	10	f	\N	\N
37581c89-9d75-4040-a80c-aeb4b8bd486d	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	b2423cee-3e59-4740-8301-4b9e7b42253a	2	20	t	fcacad86-9c8a-4959-8285-83050c9d8c48	\N
bf50a74a-0942-4c87-b0bb-2e9dba6fa727	\N	idp-username-password-form	328a8777-dc28-41dd-931b-66af1660c31c	fcacad86-9c8a-4959-8285-83050c9d8c48	0	10	f	\N	\N
e29f8238-e88d-45a2-9522-1f6f9d21e3dc	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	fcacad86-9c8a-4959-8285-83050c9d8c48	1	20	t	e827a10c-6328-4110-b5bb-335bf233d4fe	\N
8708a433-b6e7-4ef5-9a8a-c0987dd3d240	\N	conditional-user-configured	328a8777-dc28-41dd-931b-66af1660c31c	e827a10c-6328-4110-b5bb-335bf233d4fe	0	10	f	\N	\N
1099f870-c34f-4f79-8873-d8b4bad2e3a5	\N	auth-otp-form	328a8777-dc28-41dd-931b-66af1660c31c	e827a10c-6328-4110-b5bb-335bf233d4fe	0	20	f	\N	\N
401650dc-d880-48dd-b493-582f7cacdc79	\N	http-basic-authenticator	328a8777-dc28-41dd-931b-66af1660c31c	3121ed85-237b-4f1e-90c9-e41f21823138	0	10	f	\N	\N
7e39b85a-cd98-4b82-b168-99af7dd00624	\N	docker-http-basic-authenticator	328a8777-dc28-41dd-931b-66af1660c31c	e179bc12-099a-4d68-9f28-9df1a14a90f3	0	10	f	\N	\N
d3aa071b-d022-4537-b861-cd1a6506b98e	\N	no-cookie-redirect	328a8777-dc28-41dd-931b-66af1660c31c	b89ee494-ac13-440a-abf9-c819a6bdcc57	0	10	f	\N	\N
0076611a-2a32-4b59-9226-4b913e2f811a	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	b89ee494-ac13-440a-abf9-c819a6bdcc57	0	20	t	8cac5d4e-b8f2-48b7-9e96-fb6681b78583	\N
e93c4c80-0b47-4118-a756-f02624e01435	\N	basic-auth	328a8777-dc28-41dd-931b-66af1660c31c	8cac5d4e-b8f2-48b7-9e96-fb6681b78583	0	10	f	\N	\N
544b48f6-6195-4bc3-a64b-466e61bb38f8	\N	basic-auth-otp	328a8777-dc28-41dd-931b-66af1660c31c	8cac5d4e-b8f2-48b7-9e96-fb6681b78583	3	20	f	\N	\N
a5385dcb-1061-4d96-824c-7de96bf77895	\N	auth-spnego	328a8777-dc28-41dd-931b-66af1660c31c	8cac5d4e-b8f2-48b7-9e96-fb6681b78583	3	30	f	\N	\N
0461548e-054d-4096-8ef9-b53ce4fe717a	\N	auth-cookie	80229060-53a8-4a28-bfc4-ceebabe05d64	84f5c146-2eb2-412d-9d6d-a11cfb0bf83a	2	10	f	\N	\N
9b3430de-33cb-48ee-ad52-693e9a3d5347	\N	auth-spnego	80229060-53a8-4a28-bfc4-ceebabe05d64	84f5c146-2eb2-412d-9d6d-a11cfb0bf83a	3	20	f	\N	\N
a0e0f1e6-ef27-4ff5-9206-f65336f2e012	\N	identity-provider-redirector	80229060-53a8-4a28-bfc4-ceebabe05d64	84f5c146-2eb2-412d-9d6d-a11cfb0bf83a	2	25	f	\N	\N
a54722dd-09e3-413c-a98a-3af34fa4163a	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	84f5c146-2eb2-412d-9d6d-a11cfb0bf83a	2	30	t	534e84f8-359a-43c3-ac79-6c4826407aec	\N
55477062-52a1-4aba-8c1d-ee0604a34117	\N	auth-username-password-form	80229060-53a8-4a28-bfc4-ceebabe05d64	534e84f8-359a-43c3-ac79-6c4826407aec	0	10	f	\N	\N
b5adba99-f292-4398-abf1-49c450808f63	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	534e84f8-359a-43c3-ac79-6c4826407aec	1	20	t	d95b8763-264a-45e4-ae73-962c8841dbff	\N
1a735728-2024-46ff-a8c4-96098efb195f	\N	conditional-user-configured	80229060-53a8-4a28-bfc4-ceebabe05d64	d95b8763-264a-45e4-ae73-962c8841dbff	0	10	f	\N	\N
d266ba4b-3b63-48e8-9f91-595af026f70a	\N	auth-otp-form	80229060-53a8-4a28-bfc4-ceebabe05d64	d95b8763-264a-45e4-ae73-962c8841dbff	0	20	f	\N	\N
a72b4975-2192-4395-9a33-0070ef9a6d65	\N	direct-grant-validate-username	80229060-53a8-4a28-bfc4-ceebabe05d64	4aa604b3-d1a1-4866-bd38-072b8fd7cf46	0	10	f	\N	\N
6a1d7444-c6fa-49d5-be62-ecd9df0754c2	\N	direct-grant-validate-password	80229060-53a8-4a28-bfc4-ceebabe05d64	4aa604b3-d1a1-4866-bd38-072b8fd7cf46	0	20	f	\N	\N
98ce4e04-39ea-4aa8-a23d-4dd7708e1fa4	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	4aa604b3-d1a1-4866-bd38-072b8fd7cf46	1	30	t	66502f6e-1b13-4028-8f57-ab01c0f4f2e5	\N
926e528a-47c1-49fb-8d04-b8feca3b9505	\N	conditional-user-configured	80229060-53a8-4a28-bfc4-ceebabe05d64	66502f6e-1b13-4028-8f57-ab01c0f4f2e5	0	10	f	\N	\N
a44ba3df-42d2-4c03-b556-3b3e290a27cc	\N	direct-grant-validate-otp	80229060-53a8-4a28-bfc4-ceebabe05d64	66502f6e-1b13-4028-8f57-ab01c0f4f2e5	0	20	f	\N	\N
86ecf410-6fa2-4594-8c30-dfb1e47b6410	\N	registration-page-form	80229060-53a8-4a28-bfc4-ceebabe05d64	63349463-77be-4c6f-8623-0a6acd2bee8b	0	10	t	b994bccd-3e3a-4210-9e2a-f3a25dd316c0	\N
69ceefa1-2f16-42d9-915e-c5f2cf758348	\N	registration-user-creation	80229060-53a8-4a28-bfc4-ceebabe05d64	b994bccd-3e3a-4210-9e2a-f3a25dd316c0	0	20	f	\N	\N
9b861b5f-6d79-4e1e-a35f-d4e89a99752b	\N	registration-profile-action	80229060-53a8-4a28-bfc4-ceebabe05d64	b994bccd-3e3a-4210-9e2a-f3a25dd316c0	0	40	f	\N	\N
b1339de0-9be5-4509-b80e-25b8f932a702	\N	registration-password-action	80229060-53a8-4a28-bfc4-ceebabe05d64	b994bccd-3e3a-4210-9e2a-f3a25dd316c0	0	50	f	\N	\N
47f9ad5d-e699-4ce1-b76b-4e2015b9a7cc	\N	registration-recaptcha-action	80229060-53a8-4a28-bfc4-ceebabe05d64	b994bccd-3e3a-4210-9e2a-f3a25dd316c0	3	60	f	\N	\N
889dff03-0ec8-4a89-8ca0-1e80105a917c	\N	reset-credentials-choose-user	80229060-53a8-4a28-bfc4-ceebabe05d64	4f93ebdb-cb14-474f-b8c0-0dc14a4442e4	0	10	f	\N	\N
afca4462-9af7-4039-b3a2-e0c33e4fc66c	\N	reset-credential-email	80229060-53a8-4a28-bfc4-ceebabe05d64	4f93ebdb-cb14-474f-b8c0-0dc14a4442e4	0	20	f	\N	\N
f4c2537e-aea5-4277-8540-a4594b5567e4	\N	reset-password	80229060-53a8-4a28-bfc4-ceebabe05d64	4f93ebdb-cb14-474f-b8c0-0dc14a4442e4	0	30	f	\N	\N
a24c52e5-2f1e-49c0-935d-9267e48aa631	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	4f93ebdb-cb14-474f-b8c0-0dc14a4442e4	1	40	t	646e82d3-0d54-4bdc-a9f5-c7541bf2b11f	\N
1412719e-8203-47f6-993c-b3160a036cc2	\N	conditional-user-configured	80229060-53a8-4a28-bfc4-ceebabe05d64	646e82d3-0d54-4bdc-a9f5-c7541bf2b11f	0	10	f	\N	\N
47d343f5-fd57-4bee-bce0-eac02b2ba1e1	\N	reset-otp	80229060-53a8-4a28-bfc4-ceebabe05d64	646e82d3-0d54-4bdc-a9f5-c7541bf2b11f	0	20	f	\N	\N
92fef9c8-7e75-49bc-8e68-c181795aaf26	\N	client-secret	80229060-53a8-4a28-bfc4-ceebabe05d64	81b8fde3-af19-48b9-8acd-672897f7ca5e	2	10	f	\N	\N
15e6ce8e-89f8-489a-bf82-63e4a3f075be	\N	client-jwt	80229060-53a8-4a28-bfc4-ceebabe05d64	81b8fde3-af19-48b9-8acd-672897f7ca5e	2	20	f	\N	\N
c5fe6b86-9f1e-4f3b-83b9-2eddb92b4f82	\N	client-secret-jwt	80229060-53a8-4a28-bfc4-ceebabe05d64	81b8fde3-af19-48b9-8acd-672897f7ca5e	2	30	f	\N	\N
a196ca2a-5b48-46d3-b245-05dcfef96ba1	\N	client-x509	80229060-53a8-4a28-bfc4-ceebabe05d64	81b8fde3-af19-48b9-8acd-672897f7ca5e	2	40	f	\N	\N
19f6fcb6-b9ab-4b4c-bead-8f48542478dc	\N	idp-review-profile	80229060-53a8-4a28-bfc4-ceebabe05d64	24055b02-3b06-4b79-8efc-458f1caeee4b	0	10	f	\N	4b1d114d-fbb9-4d0a-9a51-55d4e700721b
ce218621-1d8d-4849-9657-2b9f33821fbb	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	24055b02-3b06-4b79-8efc-458f1caeee4b	0	20	t	1cb23aa7-c488-40df-bd47-70241714d6dc	\N
0d2df684-fa6b-4eea-bb5d-12df6fca2274	\N	idp-create-user-if-unique	80229060-53a8-4a28-bfc4-ceebabe05d64	1cb23aa7-c488-40df-bd47-70241714d6dc	2	10	f	\N	a91c56aa-98c1-4e50-b912-d2c0c54aee36
51e5ec8c-d00c-489d-babe-50431e24ce67	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	1cb23aa7-c488-40df-bd47-70241714d6dc	2	20	t	3cf6280c-9988-4ba6-926e-00f2e8bdb036	\N
ea005a09-9af0-4bdf-afd5-bcfd13bfd39d	\N	idp-confirm-link	80229060-53a8-4a28-bfc4-ceebabe05d64	3cf6280c-9988-4ba6-926e-00f2e8bdb036	0	10	f	\N	\N
2ea787f8-9dfa-4209-b207-2374983c7495	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	3cf6280c-9988-4ba6-926e-00f2e8bdb036	0	20	t	55df3bf2-ec51-450c-b679-7bd7c18519b5	\N
d2c0efe7-be34-4f76-921f-9be2fd1926ec	\N	idp-email-verification	80229060-53a8-4a28-bfc4-ceebabe05d64	55df3bf2-ec51-450c-b679-7bd7c18519b5	2	10	f	\N	\N
757fcf78-9418-4b22-be4e-e3c3db6e4afe	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	55df3bf2-ec51-450c-b679-7bd7c18519b5	2	20	t	36cf24fe-073a-43b5-8b12-a8c9e0b90d53	\N
0c346720-d471-42bc-9eaa-47ae4795835d	\N	idp-username-password-form	80229060-53a8-4a28-bfc4-ceebabe05d64	36cf24fe-073a-43b5-8b12-a8c9e0b90d53	0	10	f	\N	\N
2950be06-ba47-4d9d-9bab-ec227c4f65f6	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	36cf24fe-073a-43b5-8b12-a8c9e0b90d53	1	20	t	a8d89f93-8e7d-4a6c-9c47-9bae96e57608	\N
2d1b74d1-b62a-45c4-b69a-7fd751f51067	\N	conditional-user-configured	80229060-53a8-4a28-bfc4-ceebabe05d64	a8d89f93-8e7d-4a6c-9c47-9bae96e57608	0	10	f	\N	\N
d64a0f06-55a5-4dbe-9b26-93abdce60c31	\N	auth-otp-form	80229060-53a8-4a28-bfc4-ceebabe05d64	a8d89f93-8e7d-4a6c-9c47-9bae96e57608	0	20	f	\N	\N
96d9b80a-9dbb-4c61-8533-83572652216f	\N	http-basic-authenticator	80229060-53a8-4a28-bfc4-ceebabe05d64	39d19950-4aeb-40ee-9d36-c0a60b778c5c	0	10	f	\N	\N
598c972f-480a-42f9-8816-c65e720f646f	\N	docker-http-basic-authenticator	80229060-53a8-4a28-bfc4-ceebabe05d64	97b464f2-8f49-49b5-931b-cdbe4928af2e	0	10	f	\N	\N
f6bb4aea-4d2e-417c-9fe2-c22c0bf98927	\N	no-cookie-redirect	80229060-53a8-4a28-bfc4-ceebabe05d64	ca05309b-7942-4f4a-8349-92955821c77f	0	10	f	\N	\N
04c589a7-3b76-4f30-a1e1-5e36255502c9	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	ca05309b-7942-4f4a-8349-92955821c77f	0	20	t	fb52c68d-7295-4440-ba8f-719c522ff058	\N
f9ddb817-e06a-4ff6-b3df-94d32543b254	\N	basic-auth	80229060-53a8-4a28-bfc4-ceebabe05d64	fb52c68d-7295-4440-ba8f-719c522ff058	0	10	f	\N	\N
3e41141c-8987-4405-8646-fd2d9aa31897	\N	basic-auth-otp	80229060-53a8-4a28-bfc4-ceebabe05d64	fb52c68d-7295-4440-ba8f-719c522ff058	3	20	f	\N	\N
da75a2a2-810e-42a2-adcc-a0db2bac1729	\N	auth-spnego	80229060-53a8-4a28-bfc4-ceebabe05d64	fb52c68d-7295-4440-ba8f-719c522ff058	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
560df60e-1a9b-4a64-ad30-146026c9f58c	browser	browser based authentication	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
110410e9-7d9e-41a8-9721-5c7953222557	forms	Username, password, otp and other auth forms.	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
18671a59-6a47-4b4c-aec9-73ef57500230	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
c8df21b1-3808-48da-9146-3546dee7972e	direct grant	OpenID Connect Resource Owner Grant	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
1df0e190-998b-41b1-8ff1-42a34be739a6	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
e4a1f86d-bd20-4687-bcda-22be338747d8	registration	registration flow	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
499ee03b-b430-41f5-86fc-f355fba37fcb	registration form	registration form	328a8777-dc28-41dd-931b-66af1660c31c	form-flow	f	t
22d0d2a0-d8be-4600-9c9d-4807035e396f	reset credentials	Reset credentials for a user if they forgot their password or something	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
e21429ab-add8-4bd1-8e1b-ead25ffadd41	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
c86dd04d-b0e4-4580-8f6c-5721bb86e5e3	clients	Base authentication for clients	328a8777-dc28-41dd-931b-66af1660c31c	client-flow	t	t
e5a54abe-ddfa-4194-bdda-9df724112dc4	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
fa9adfca-e910-4a45-bfe8-0b975556946a	User creation or linking	Flow for the existing/non-existing user alternatives	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
760117c2-5880-4633-acc6-3896b9fd4327	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
b2423cee-3e59-4740-8301-4b9e7b42253a	Account verification options	Method with which to verity the existing account	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
fcacad86-9c8a-4959-8285-83050c9d8c48	Verify Existing Account by Re-authentication	Reauthentication of existing account	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
e827a10c-6328-4110-b5bb-335bf233d4fe	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
3121ed85-237b-4f1e-90c9-e41f21823138	saml ecp	SAML ECP Profile Authentication Flow	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
e179bc12-099a-4d68-9f28-9df1a14a90f3	docker auth	Used by Docker clients to authenticate against the IDP	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
b89ee494-ac13-440a-abf9-c819a6bdcc57	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	t	t
8cac5d4e-b8f2-48b7-9e96-fb6681b78583	Authentication Options	Authentication options.	328a8777-dc28-41dd-931b-66af1660c31c	basic-flow	f	t
84f5c146-2eb2-412d-9d6d-a11cfb0bf83a	browser	browser based authentication	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
534e84f8-359a-43c3-ac79-6c4826407aec	forms	Username, password, otp and other auth forms.	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
d95b8763-264a-45e4-ae73-962c8841dbff	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
4aa604b3-d1a1-4866-bd38-072b8fd7cf46	direct grant	OpenID Connect Resource Owner Grant	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
66502f6e-1b13-4028-8f57-ab01c0f4f2e5	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
63349463-77be-4c6f-8623-0a6acd2bee8b	registration	registration flow	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
b994bccd-3e3a-4210-9e2a-f3a25dd316c0	registration form	registration form	80229060-53a8-4a28-bfc4-ceebabe05d64	form-flow	f	t
4f93ebdb-cb14-474f-b8c0-0dc14a4442e4	reset credentials	Reset credentials for a user if they forgot their password or something	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
646e82d3-0d54-4bdc-a9f5-c7541bf2b11f	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
81b8fde3-af19-48b9-8acd-672897f7ca5e	clients	Base authentication for clients	80229060-53a8-4a28-bfc4-ceebabe05d64	client-flow	t	t
24055b02-3b06-4b79-8efc-458f1caeee4b	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
1cb23aa7-c488-40df-bd47-70241714d6dc	User creation or linking	Flow for the existing/non-existing user alternatives	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
3cf6280c-9988-4ba6-926e-00f2e8bdb036	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
55df3bf2-ec51-450c-b679-7bd7c18519b5	Account verification options	Method with which to verity the existing account	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
36cf24fe-073a-43b5-8b12-a8c9e0b90d53	Verify Existing Account by Re-authentication	Reauthentication of existing account	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
a8d89f93-8e7d-4a6c-9c47-9bae96e57608	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
39d19950-4aeb-40ee-9d36-c0a60b778c5c	saml ecp	SAML ECP Profile Authentication Flow	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
97b464f2-8f49-49b5-931b-cdbe4928af2e	docker auth	Used by Docker clients to authenticate against the IDP	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
ca05309b-7942-4f4a-8349-92955821c77f	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	t	t
fb52c68d-7295-4440-ba8f-719c522ff058	Authentication Options	Authentication options.	80229060-53a8-4a28-bfc4-ceebabe05d64	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
86c8d9a7-ef82-4bc7-945e-9430b1b7fdec	review profile config	328a8777-dc28-41dd-931b-66af1660c31c
07e72f02-753d-4210-adb5-fb0b47233ce3	create unique user config	328a8777-dc28-41dd-931b-66af1660c31c
4b1d114d-fbb9-4d0a-9a51-55d4e700721b	review profile config	80229060-53a8-4a28-bfc4-ceebabe05d64
a91c56aa-98c1-4e50-b912-d2c0c54aee36	create unique user config	80229060-53a8-4a28-bfc4-ceebabe05d64
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
07e72f02-753d-4210-adb5-fb0b47233ce3	false	require.password.update.after.registration
86c8d9a7-ef82-4bc7-945e-9430b1b7fdec	missing	update.profile.on.first.login
4b1d114d-fbb9-4d0a-9a51-55d4e700721b	missing	update.profile.on.first.login
a91c56aa-98c1-4e50-b912-d2c0c54aee36	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
242805d5-7a12-4a07-8b69-c046f326d6fa	t	f	master-realm	0	f	\N	\N	t	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
fa8efa56-6835-455d-943e-1cf089f80040	t	f	broker	0	f	\N	\N	t	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
1a9079ff-fb56-4e60-b231-96b51a96c044	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
e821bfef-ba63-4c05-ab2a-27df71280656	t	f	admin-cli	0	t	\N	\N	f	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
f485b846-6289-40b6-a42c-287e95d8cd82	t	f	JsExecutor-realm	0	f	\N	\N	t	\N	f	328a8777-dc28-41dd-931b-66af1660c31c	\N	0	f	f	JsExecutor Realm	f	client-secret	\N	\N	\N	t	f	f	f
559dfb53-c90c-4d4b-ba77-7235c4341189	t	f	realm-management	0	f	\N	\N	t	\N	f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	f	account	0	t	\N	/realms/JsExecutor/account/	f	\N	f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
132434ea-1786-4839-9d02-33a3b6354f90	t	f	account-console	0	t	\N	/realms/JsExecutor/account/	f	\N	f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	t	f	broker	0	f	\N	\N	t	\N	f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
0466602c-8f11-4581-b7e4-d01932dd42df	t	f	security-admin-console	0	t	\N	/admin/JsExecutor/console/	f	\N	f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
627811f1-1819-493d-9513-95b7b688aafb	t	f	admin-cli	0	t	\N	\N	f	\N	f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
646226dc-1492-41e1-afcb-b398abd036bd	t	t	swagger-ui-local	0	f	SPhAtEWpKUg5hQrlC67mg25Wo13uLgtp	https://localhost:8080/swagger-ui/index.html	f		f	80229060-53a8-4a28-bfc4-ceebabe05d64	openid-connect	-1	t	f	Swagger Local	t	client-secret	https://localhost:8080/		\N	t	f	f	t
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_attributes (client_id, value, name) FROM stdin;
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	+	post.logout.redirect.uris
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	+	post.logout.redirect.uris
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	S256	pkce.code.challenge.method
1a9079ff-fb56-4e60-b231-96b51a96c044	+	post.logout.redirect.uris
1a9079ff-fb56-4e60-b231-96b51a96c044	S256	pkce.code.challenge.method
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	+	post.logout.redirect.uris
132434ea-1786-4839-9d02-33a3b6354f90	+	post.logout.redirect.uris
132434ea-1786-4839-9d02-33a3b6354f90	S256	pkce.code.challenge.method
0466602c-8f11-4581-b7e4-d01932dd42df	+	post.logout.redirect.uris
0466602c-8f11-4581-b7e4-d01932dd42df	S256	pkce.code.challenge.method
646226dc-1492-41e1-afcb-b398abd036bd	1660562491	client.secret.creation.time
646226dc-1492-41e1-afcb-b398abd036bd	false	oauth2.device.authorization.grant.enabled
646226dc-1492-41e1-afcb-b398abd036bd	false	oidc.ciba.grant.enabled
646226dc-1492-41e1-afcb-b398abd036bd	true	backchannel.logout.session.required
646226dc-1492-41e1-afcb-b398abd036bd	false	backchannel.logout.revoke.offline.tokens
646226dc-1492-41e1-afcb-b398abd036bd	false	display.on.consent.screen
646226dc-1492-41e1-afcb-b398abd036bd	false	use.jwks.url
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
d3996c34-1f91-4652-a309-b014fd1fc37b	offline_access	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect built-in scope: offline_access	openid-connect
bebc7eb3-27d6-4865-baa6-fb59bac35fd6	role_list	328a8777-dc28-41dd-931b-66af1660c31c	SAML role list	saml
2c3ad767-8a8a-4b97-85d2-622dafcc05c3	profile	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect built-in scope: profile	openid-connect
b4e81c0b-1a5d-486c-925d-7d2db8f637f5	email	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect built-in scope: email	openid-connect
93947f32-256d-4e4b-a2e2-1b7c9b62021e	address	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect built-in scope: address	openid-connect
569b2a22-6e96-48ad-bda6-bd3e57fb27ba	phone	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect built-in scope: phone	openid-connect
02d1f9b1-9d90-4160-9618-e18af6019b6b	roles	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect scope for add user roles to the access token	openid-connect
95d18b9a-e258-480c-b693-d898fb700b03	web-origins	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect scope for add allowed web origins to the access token	openid-connect
87e7dc68-e7b7-4356-b91b-6e6a3186ae08	microprofile-jwt	328a8777-dc28-41dd-931b-66af1660c31c	Microprofile - JWT built-in scope	openid-connect
9e134cbe-d9d8-4c47-b810-fe23e21a5433	acr	328a8777-dc28-41dd-931b-66af1660c31c	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
42a22ce4-c6c8-44e8-8191-206ad6afe765	offline_access	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect built-in scope: offline_access	openid-connect
b70b8542-a92c-4a16-96a4-4da2a928ddcc	role_list	80229060-53a8-4a28-bfc4-ceebabe05d64	SAML role list	saml
bcb9bf08-4901-4aa7-ad37-62815752e282	profile	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect built-in scope: profile	openid-connect
cb45d198-cf9c-4b54-a821-17bd1452dfab	email	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect built-in scope: email	openid-connect
865cb18b-4d01-4b1b-bd13-3b903efe7e1c	address	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect built-in scope: address	openid-connect
46d7b3e7-31e6-4023-ab99-fcfdc770a997	phone	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect built-in scope: phone	openid-connect
1a89ce96-08ac-4636-8487-6173ad97b4f4	roles	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect scope for add user roles to the access token	openid-connect
7f755b10-af77-4d7c-9ca7-f46a179d86ef	web-origins	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect scope for add allowed web origins to the access token	openid-connect
69a5e293-0504-4453-a2ae-bd3c35422ac2	microprofile-jwt	80229060-53a8-4a28-bfc4-ceebabe05d64	Microprofile - JWT built-in scope	openid-connect
92161823-edea-4df2-ab3b-7923c06d9fea	acr	80229060-53a8-4a28-bfc4-ceebabe05d64	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	swagger	80229060-53a8-4a28-bfc4-ceebabe05d64		openid-connect
16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	app_admin	80229060-53a8-4a28-bfc4-ceebabe05d64		openid-connect
b5704760-278f-49af-adb7-efb002023c2f	app	80229060-53a8-4a28-bfc4-ceebabe05d64		openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
d3996c34-1f91-4652-a309-b014fd1fc37b	true	display.on.consent.screen
d3996c34-1f91-4652-a309-b014fd1fc37b	${offlineAccessScopeConsentText}	consent.screen.text
bebc7eb3-27d6-4865-baa6-fb59bac35fd6	true	display.on.consent.screen
bebc7eb3-27d6-4865-baa6-fb59bac35fd6	${samlRoleListScopeConsentText}	consent.screen.text
2c3ad767-8a8a-4b97-85d2-622dafcc05c3	true	display.on.consent.screen
2c3ad767-8a8a-4b97-85d2-622dafcc05c3	${profileScopeConsentText}	consent.screen.text
2c3ad767-8a8a-4b97-85d2-622dafcc05c3	true	include.in.token.scope
b4e81c0b-1a5d-486c-925d-7d2db8f637f5	true	display.on.consent.screen
b4e81c0b-1a5d-486c-925d-7d2db8f637f5	${emailScopeConsentText}	consent.screen.text
b4e81c0b-1a5d-486c-925d-7d2db8f637f5	true	include.in.token.scope
93947f32-256d-4e4b-a2e2-1b7c9b62021e	true	display.on.consent.screen
93947f32-256d-4e4b-a2e2-1b7c9b62021e	${addressScopeConsentText}	consent.screen.text
93947f32-256d-4e4b-a2e2-1b7c9b62021e	true	include.in.token.scope
569b2a22-6e96-48ad-bda6-bd3e57fb27ba	true	display.on.consent.screen
569b2a22-6e96-48ad-bda6-bd3e57fb27ba	${phoneScopeConsentText}	consent.screen.text
569b2a22-6e96-48ad-bda6-bd3e57fb27ba	true	include.in.token.scope
02d1f9b1-9d90-4160-9618-e18af6019b6b	true	display.on.consent.screen
02d1f9b1-9d90-4160-9618-e18af6019b6b	${rolesScopeConsentText}	consent.screen.text
02d1f9b1-9d90-4160-9618-e18af6019b6b	false	include.in.token.scope
95d18b9a-e258-480c-b693-d898fb700b03	false	display.on.consent.screen
95d18b9a-e258-480c-b693-d898fb700b03		consent.screen.text
95d18b9a-e258-480c-b693-d898fb700b03	false	include.in.token.scope
87e7dc68-e7b7-4356-b91b-6e6a3186ae08	false	display.on.consent.screen
87e7dc68-e7b7-4356-b91b-6e6a3186ae08	true	include.in.token.scope
9e134cbe-d9d8-4c47-b810-fe23e21a5433	false	display.on.consent.screen
9e134cbe-d9d8-4c47-b810-fe23e21a5433	false	include.in.token.scope
42a22ce4-c6c8-44e8-8191-206ad6afe765	true	display.on.consent.screen
42a22ce4-c6c8-44e8-8191-206ad6afe765	${offlineAccessScopeConsentText}	consent.screen.text
b70b8542-a92c-4a16-96a4-4da2a928ddcc	true	display.on.consent.screen
b70b8542-a92c-4a16-96a4-4da2a928ddcc	${samlRoleListScopeConsentText}	consent.screen.text
bcb9bf08-4901-4aa7-ad37-62815752e282	true	display.on.consent.screen
bcb9bf08-4901-4aa7-ad37-62815752e282	${profileScopeConsentText}	consent.screen.text
bcb9bf08-4901-4aa7-ad37-62815752e282	true	include.in.token.scope
cb45d198-cf9c-4b54-a821-17bd1452dfab	true	display.on.consent.screen
cb45d198-cf9c-4b54-a821-17bd1452dfab	${emailScopeConsentText}	consent.screen.text
cb45d198-cf9c-4b54-a821-17bd1452dfab	true	include.in.token.scope
865cb18b-4d01-4b1b-bd13-3b903efe7e1c	true	display.on.consent.screen
865cb18b-4d01-4b1b-bd13-3b903efe7e1c	${addressScopeConsentText}	consent.screen.text
865cb18b-4d01-4b1b-bd13-3b903efe7e1c	true	include.in.token.scope
46d7b3e7-31e6-4023-ab99-fcfdc770a997	true	display.on.consent.screen
46d7b3e7-31e6-4023-ab99-fcfdc770a997	${phoneScopeConsentText}	consent.screen.text
46d7b3e7-31e6-4023-ab99-fcfdc770a997	true	include.in.token.scope
1a89ce96-08ac-4636-8487-6173ad97b4f4	true	display.on.consent.screen
1a89ce96-08ac-4636-8487-6173ad97b4f4	${rolesScopeConsentText}	consent.screen.text
1a89ce96-08ac-4636-8487-6173ad97b4f4	false	include.in.token.scope
7f755b10-af77-4d7c-9ca7-f46a179d86ef	false	display.on.consent.screen
7f755b10-af77-4d7c-9ca7-f46a179d86ef		consent.screen.text
7f755b10-af77-4d7c-9ca7-f46a179d86ef	false	include.in.token.scope
69a5e293-0504-4453-a2ae-bd3c35422ac2	false	display.on.consent.screen
69a5e293-0504-4453-a2ae-bd3c35422ac2	true	include.in.token.scope
92161823-edea-4df2-ab3b-7923c06d9fea	false	display.on.consent.screen
92161823-edea-4df2-ab3b-7923c06d9fea	false	include.in.token.scope
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d		consent.screen.text
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	true	display.on.consent.screen
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	true	include.in.token.scope
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d		gui.order
16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	false	display.on.consent.screen
16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	true	include.in.token.scope
16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0		gui.order
b5704760-278f-49af-adb7-efb002023c2f		consent.screen.text
b5704760-278f-49af-adb7-efb002023c2f	true	display.on.consent.screen
b5704760-278f-49af-adb7-efb002023c2f	true	include.in.token.scope
b5704760-278f-49af-adb7-efb002023c2f		gui.order
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	95d18b9a-e258-480c-b693-d898fb700b03	t
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	d3996c34-1f91-4652-a309-b014fd1fc37b	f
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	95d18b9a-e258-480c-b693-d898fb700b03	t
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	d3996c34-1f91-4652-a309-b014fd1fc37b	f
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
e821bfef-ba63-4c05-ab2a-27df71280656	95d18b9a-e258-480c-b693-d898fb700b03	t
e821bfef-ba63-4c05-ab2a-27df71280656	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
e821bfef-ba63-4c05-ab2a-27df71280656	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
e821bfef-ba63-4c05-ab2a-27df71280656	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
e821bfef-ba63-4c05-ab2a-27df71280656	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
e821bfef-ba63-4c05-ab2a-27df71280656	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
e821bfef-ba63-4c05-ab2a-27df71280656	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
e821bfef-ba63-4c05-ab2a-27df71280656	d3996c34-1f91-4652-a309-b014fd1fc37b	f
e821bfef-ba63-4c05-ab2a-27df71280656	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
fa8efa56-6835-455d-943e-1cf089f80040	95d18b9a-e258-480c-b693-d898fb700b03	t
fa8efa56-6835-455d-943e-1cf089f80040	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
fa8efa56-6835-455d-943e-1cf089f80040	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
fa8efa56-6835-455d-943e-1cf089f80040	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
fa8efa56-6835-455d-943e-1cf089f80040	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
fa8efa56-6835-455d-943e-1cf089f80040	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
fa8efa56-6835-455d-943e-1cf089f80040	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
fa8efa56-6835-455d-943e-1cf089f80040	d3996c34-1f91-4652-a309-b014fd1fc37b	f
fa8efa56-6835-455d-943e-1cf089f80040	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
242805d5-7a12-4a07-8b69-c046f326d6fa	95d18b9a-e258-480c-b693-d898fb700b03	t
242805d5-7a12-4a07-8b69-c046f326d6fa	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
242805d5-7a12-4a07-8b69-c046f326d6fa	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
242805d5-7a12-4a07-8b69-c046f326d6fa	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
242805d5-7a12-4a07-8b69-c046f326d6fa	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
242805d5-7a12-4a07-8b69-c046f326d6fa	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
242805d5-7a12-4a07-8b69-c046f326d6fa	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
242805d5-7a12-4a07-8b69-c046f326d6fa	d3996c34-1f91-4652-a309-b014fd1fc37b	f
242805d5-7a12-4a07-8b69-c046f326d6fa	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
1a9079ff-fb56-4e60-b231-96b51a96c044	95d18b9a-e258-480c-b693-d898fb700b03	t
1a9079ff-fb56-4e60-b231-96b51a96c044	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
1a9079ff-fb56-4e60-b231-96b51a96c044	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
1a9079ff-fb56-4e60-b231-96b51a96c044	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
1a9079ff-fb56-4e60-b231-96b51a96c044	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
1a9079ff-fb56-4e60-b231-96b51a96c044	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
1a9079ff-fb56-4e60-b231-96b51a96c044	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
1a9079ff-fb56-4e60-b231-96b51a96c044	d3996c34-1f91-4652-a309-b014fd1fc37b	f
1a9079ff-fb56-4e60-b231-96b51a96c044	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	bcb9bf08-4901-4aa7-ad37-62815752e282	t
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	92161823-edea-4df2-ab3b-7923c06d9fea	t
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
132434ea-1786-4839-9d02-33a3b6354f90	bcb9bf08-4901-4aa7-ad37-62815752e282	t
132434ea-1786-4839-9d02-33a3b6354f90	92161823-edea-4df2-ab3b-7923c06d9fea	t
132434ea-1786-4839-9d02-33a3b6354f90	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
132434ea-1786-4839-9d02-33a3b6354f90	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
132434ea-1786-4839-9d02-33a3b6354f90	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
132434ea-1786-4839-9d02-33a3b6354f90	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
132434ea-1786-4839-9d02-33a3b6354f90	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
132434ea-1786-4839-9d02-33a3b6354f90	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
132434ea-1786-4839-9d02-33a3b6354f90	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
627811f1-1819-493d-9513-95b7b688aafb	bcb9bf08-4901-4aa7-ad37-62815752e282	t
627811f1-1819-493d-9513-95b7b688aafb	92161823-edea-4df2-ab3b-7923c06d9fea	t
627811f1-1819-493d-9513-95b7b688aafb	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
627811f1-1819-493d-9513-95b7b688aafb	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
627811f1-1819-493d-9513-95b7b688aafb	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
627811f1-1819-493d-9513-95b7b688aafb	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
627811f1-1819-493d-9513-95b7b688aafb	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
627811f1-1819-493d-9513-95b7b688aafb	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
627811f1-1819-493d-9513-95b7b688aafb	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	bcb9bf08-4901-4aa7-ad37-62815752e282	t
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	92161823-edea-4df2-ab3b-7923c06d9fea	t
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
559dfb53-c90c-4d4b-ba77-7235c4341189	bcb9bf08-4901-4aa7-ad37-62815752e282	t
559dfb53-c90c-4d4b-ba77-7235c4341189	92161823-edea-4df2-ab3b-7923c06d9fea	t
559dfb53-c90c-4d4b-ba77-7235c4341189	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
559dfb53-c90c-4d4b-ba77-7235c4341189	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
559dfb53-c90c-4d4b-ba77-7235c4341189	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
559dfb53-c90c-4d4b-ba77-7235c4341189	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
559dfb53-c90c-4d4b-ba77-7235c4341189	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
559dfb53-c90c-4d4b-ba77-7235c4341189	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
559dfb53-c90c-4d4b-ba77-7235c4341189	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
0466602c-8f11-4581-b7e4-d01932dd42df	bcb9bf08-4901-4aa7-ad37-62815752e282	t
0466602c-8f11-4581-b7e4-d01932dd42df	92161823-edea-4df2-ab3b-7923c06d9fea	t
0466602c-8f11-4581-b7e4-d01932dd42df	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
0466602c-8f11-4581-b7e4-d01932dd42df	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
0466602c-8f11-4581-b7e4-d01932dd42df	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
0466602c-8f11-4581-b7e4-d01932dd42df	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
0466602c-8f11-4581-b7e4-d01932dd42df	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
0466602c-8f11-4581-b7e4-d01932dd42df	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
0466602c-8f11-4581-b7e4-d01932dd42df	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
646226dc-1492-41e1-afcb-b398abd036bd	bcb9bf08-4901-4aa7-ad37-62815752e282	t
646226dc-1492-41e1-afcb-b398abd036bd	92161823-edea-4df2-ab3b-7923c06d9fea	t
646226dc-1492-41e1-afcb-b398abd036bd	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
646226dc-1492-41e1-afcb-b398abd036bd	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
646226dc-1492-41e1-afcb-b398abd036bd	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
646226dc-1492-41e1-afcb-b398abd036bd	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
646226dc-1492-41e1-afcb-b398abd036bd	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
646226dc-1492-41e1-afcb-b398abd036bd	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
646226dc-1492-41e1-afcb-b398abd036bd	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
646226dc-1492-41e1-afcb-b398abd036bd	b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	t
646226dc-1492-41e1-afcb-b398abd036bd	16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	t
646226dc-1492-41e1-afcb-b398abd036bd	b5704760-278f-49af-adb7-efb002023c2f	t
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
d3996c34-1f91-4652-a309-b014fd1fc37b	08190870-0bbc-4b26-b075-c874be0bddbc
42a22ce4-c6c8-44e8-8191-206ad6afe765	1a723420-63dc-43cf-9cca-4b9155939561
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	aad89f55-21f9-4284-82b5-6dfd3e0b5bfd
16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	aad89f55-21f9-4284-82b5-6dfd3e0b5bfd
b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	5a9a8bac-c79f-4f93-b170-06e42885f9e4
16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	a4068e6e-8f49-47b0-aa74-d261b33be10a
b5704760-278f-49af-adb7-efb002023c2f	5a9a8bac-c79f-4f93-b170-06e42885f9e4
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
41dfb227-f0c8-4199-b56d-02d677fb3aa1	Trusted Hosts	328a8777-dc28-41dd-931b-66af1660c31c	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	anonymous
f1a4dc71-2452-4071-be1e-3050acd2366d	Consent Required	328a8777-dc28-41dd-931b-66af1660c31c	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	anonymous
405881af-1a4c-4246-ba69-c7865a7ef84c	Full Scope Disabled	328a8777-dc28-41dd-931b-66af1660c31c	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	anonymous
6453dff7-6736-42e4-b2d4-878eb5fafc65	Max Clients Limit	328a8777-dc28-41dd-931b-66af1660c31c	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	anonymous
ed68a78f-9e36-4168-ab38-402a9ea1a924	Allowed Protocol Mapper Types	328a8777-dc28-41dd-931b-66af1660c31c	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	anonymous
edca1385-6ed9-4b1b-86f1-4ea5bdb8be32	Allowed Client Scopes	328a8777-dc28-41dd-931b-66af1660c31c	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	anonymous
e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	Allowed Protocol Mapper Types	328a8777-dc28-41dd-931b-66af1660c31c	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	authenticated
9ac8671f-bb3b-4bdb-a276-d3344b8397df	Allowed Client Scopes	328a8777-dc28-41dd-931b-66af1660c31c	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	328a8777-dc28-41dd-931b-66af1660c31c	authenticated
12b5d4eb-0de2-4048-b0ca-047e2becaede	rsa-generated	328a8777-dc28-41dd-931b-66af1660c31c	rsa-generated	org.keycloak.keys.KeyProvider	328a8777-dc28-41dd-931b-66af1660c31c	\N
ef668ff9-00f1-4e96-b2e2-e1006705cbb6	rsa-enc-generated	328a8777-dc28-41dd-931b-66af1660c31c	rsa-enc-generated	org.keycloak.keys.KeyProvider	328a8777-dc28-41dd-931b-66af1660c31c	\N
415e2632-1519-404e-9e48-3056d4e70ad5	hmac-generated	328a8777-dc28-41dd-931b-66af1660c31c	hmac-generated	org.keycloak.keys.KeyProvider	328a8777-dc28-41dd-931b-66af1660c31c	\N
a53514cf-1af8-4ae0-87db-ab58fd2db287	aes-generated	328a8777-dc28-41dd-931b-66af1660c31c	aes-generated	org.keycloak.keys.KeyProvider	328a8777-dc28-41dd-931b-66af1660c31c	\N
1406df29-6e32-4cba-bda0-08c0aa32a8ea	rsa-generated	80229060-53a8-4a28-bfc4-ceebabe05d64	rsa-generated	org.keycloak.keys.KeyProvider	80229060-53a8-4a28-bfc4-ceebabe05d64	\N
de82528d-5d69-49b5-95d9-b6a9080644cb	rsa-enc-generated	80229060-53a8-4a28-bfc4-ceebabe05d64	rsa-enc-generated	org.keycloak.keys.KeyProvider	80229060-53a8-4a28-bfc4-ceebabe05d64	\N
89ff6032-a771-44ee-9f34-2d45bf2a79f3	hmac-generated	80229060-53a8-4a28-bfc4-ceebabe05d64	hmac-generated	org.keycloak.keys.KeyProvider	80229060-53a8-4a28-bfc4-ceebabe05d64	\N
1b9f5388-52e8-4477-b62b-0d16ffd3bf25	aes-generated	80229060-53a8-4a28-bfc4-ceebabe05d64	aes-generated	org.keycloak.keys.KeyProvider	80229060-53a8-4a28-bfc4-ceebabe05d64	\N
17d410a1-2da0-4549-9271-11de438498b8	Trusted Hosts	80229060-53a8-4a28-bfc4-ceebabe05d64	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	anonymous
b2bab282-e07a-4a56-b001-f995af65a4f3	Consent Required	80229060-53a8-4a28-bfc4-ceebabe05d64	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	anonymous
9fb5a0a4-a4ce-4614-8012-85297111d73c	Full Scope Disabled	80229060-53a8-4a28-bfc4-ceebabe05d64	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	anonymous
bb77e222-624d-4c0e-a6b9-97016068f851	Max Clients Limit	80229060-53a8-4a28-bfc4-ceebabe05d64	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	anonymous
b81f47e5-2535-40b2-b0a8-51936b27d4d8	Allowed Protocol Mapper Types	80229060-53a8-4a28-bfc4-ceebabe05d64	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	anonymous
fe556759-6091-49c9-9e16-3b3257a69594	Allowed Client Scopes	80229060-53a8-4a28-bfc4-ceebabe05d64	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	anonymous
42ca28c9-d589-46d8-9c4a-a1f3134463cb	Allowed Protocol Mapper Types	80229060-53a8-4a28-bfc4-ceebabe05d64	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	authenticated
26f42861-d6ce-440d-911d-a04f542e6066	Allowed Client Scopes	80229060-53a8-4a28-bfc4-ceebabe05d64	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	authenticated
38948a36-7755-432e-8a2d-051ea7404cfc	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	80229060-53a8-4a28-bfc4-ceebabe05d64	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
380c0b3f-302c-4a00-9851-9b3f3b185b91	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
31364a19-12f2-49ac-ba9e-768aa4388f23	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
03afe63a-9043-4d66-8ac9-12bcdec75c70	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	oidc-full-name-mapper
5e27792b-d648-4084-8455-23554f27aa27	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	oidc-address-mapper
7b81d9ba-ad69-499e-9b27-8d8e8c43f57e	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	saml-user-property-mapper
9b2ff161-7059-4162-94dc-582bd2887b35	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	saml-role-list-mapper
0c18a35a-9f62-4507-9a0b-928c5a2ca65c	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	saml-user-attribute-mapper
439a83a7-8688-452d-9bc8-17844c051cdc	e51ffb6e-f68c-4c9f-9bdb-0392e3bc3f0b	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
96ee197e-9eb3-4054-8323-064dbc994853	9ac8671f-bb3b-4bdb-a276-d3344b8397df	allow-default-scopes	true
b03a0a32-6dc6-442b-b729-2f3aab17c485	edca1385-6ed9-4b1b-86f1-4ea5bdb8be32	allow-default-scopes	true
93a0f29c-f24c-4fde-8f3c-7218859e3566	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
4c3ece29-2a41-4291-8b70-de0d729c14ec	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
567e5dd8-ad82-4c48-93d3-56bcc0d206db	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	saml-role-list-mapper
13452e4c-29a2-4185-a6c6-994d0877583f	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
e80014e2-9d41-43cb-83f5-6afc670b5baf	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	oidc-full-name-mapper
722fee81-560b-47cc-83aa-eddf1ef44f5b	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	saml-user-property-mapper
63b9d7d8-3f29-4249-ba22-79fcbbf72bab	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	oidc-address-mapper
895ad1e8-754b-4f2a-aeb5-22392815a2d4	ed68a78f-9e36-4168-ab38-402a9ea1a924	allowed-protocol-mapper-types	saml-user-attribute-mapper
a8d550cc-d276-4ef9-8727-b585dc47cce6	41dfb227-f0c8-4199-b56d-02d677fb3aa1	client-uris-must-match	true
3b0a02b4-34e9-42db-81bf-b7a2f7bf78d7	41dfb227-f0c8-4199-b56d-02d677fb3aa1	host-sending-registration-request-must-match	true
73cafeaa-8112-45ae-85c3-ebb1179a008a	6453dff7-6736-42e4-b2d4-878eb5fafc65	max-clients	200
bc72a973-2233-4212-ace9-b59f346bb8e1	ef668ff9-00f1-4e96-b2e2-e1006705cbb6	keyUse	ENC
9f00b73a-6c83-4096-984f-9e025f61563f	ef668ff9-00f1-4e96-b2e2-e1006705cbb6	privateKey	MIIEowIBAAKCAQEAuK9Gs/mbMG+EMoZ5bHuk5FmZMLSreNQFXrQ97d5c78Of2vZc0q4QauddtlH0FYfi31TzVBw1euEPib0VuoLbn5ewzVJNam4B4ZIzqz8vwpzqe6+CYDpumb/Re8KjQfJ149uKpvvkWSswl4NJSsOprlWahOImZinnuViHFq8vn20UtA6OVoNF0Bzvq1eJggcHNf81x1SplQenwUSpyeD3+Z3jI9309Kh/1xrqRbgUqtchHjonxxx2NU13XHUTMENN8kZ9tmpaDc6GUJZ1AtWvEWM9BF90BkesYG9dJZSc2cpgVBBDj5kU7c5EKXiWEyp6XBt/7XcnEEUMHLP8q1i3YwIDAQABAoIBAAKbz/4mmYd3g8c2haXyulnS91142whjyK5vEex3g00lsIimVma2OIG+2+C0sdbRN3MOuNMoaz73L9t/tSKQMTiRxKVzZkGJftnoHg+33qpU9UdWK5uSJ7hg1vCOR46pm8dIqHtpIm9GzP+brKANBhGlOhk3aPIKrhaJoBR1DASoWEWBucs/0fc8qQVO6Za4TRPdcbuvclN7C8TvPoljmRwDiIQJpshkgrnyNZTkrtv4a55hsCsS26dthNX+iS7GtxjnPgC50qctZm+NKtu7NZdPQxL4KQYChebWx1QwfANQ0ywBMDzNGb6ZeZu6e5ct/MDfkQjs2HhvSS4csypmWzECgYEA+9c5ONY4iIGIR/3BkY0B/y9K19QxvFJLjdG8IOs6cxOZg5tAuiXzT6MDP0z5EwUgVismA02SOaTZOj7RYD1roiAXVeWCRNZl+DOmtFktpnqfrVSEHcyzfCXxhNed062F1D74HaC5JNx60MT+KqBtqHEo4BnRv61Vc45OssCrP5MCgYEAu7weV6MwNuOa3IHh0430Bjzt8dbS1eKIGLloxG3IJdF1MkVW17xm8qDZRWUihXZ1K8vAcgd8CsMR2mmPPalWMu/f3h/99q9/j20bVXIUS7OmALsaTwPqcLrXu1TKgorrZEdv231JQxZTeesFYSvIGA+j3IDolBT9QNX/1GJVavECgYEA0Kf6bh/3SQphepxBc7Gr1N0/GmFiL9DTbpY2U+PxUoULrSHF2DU3SWUbfKfuuhaGOz6WySfNHlt566s+WImrEvGZw/5bF2O3qpRI66Xzj7qLb9XVfMcscpERcWogBtD/T+I4Onv+yg6u5yhAGds/386Z+ksKINChOxPOGoZNnGcCgYAPooEcZ1jSmW4CQ0bdaYsTIevnIi745R7UgEx7X3E1xRXvk9rBqM0iE8dEgkG3v7/OX++tD3aDJu/LstLdHccyAswwIZXy/3auKTYHjbKnA1Ul5m8weXEC5mylC1C6QnuMJG7qZqq9TZSyKKKQDydg6ZyJ9qpn+r+EsM3XkEDw4QKBgDCLiZyErSSxugu0zhZwL1NFHSjd/aGNE/sP93PT7tqAZlhTzR6Isz5ZR/5qE/RN+CryBIjIyS7dglHnEzn2qQwS2QQUZL3hDMTlUVk9xQPg9KEZjokb4En2Nx6JMxFiA+bPhSLGGq7XsuxPUanTaOh2mIFZhqInBPRZ9YNLYaPi
1bb7bd6b-f986-473e-bbb4-002dec41c96a	ef668ff9-00f1-4e96-b2e2-e1006705cbb6	algorithm	RSA-OAEP
3fca31bd-9ec9-43c6-82c3-496b826f4ee8	ef668ff9-00f1-4e96-b2e2-e1006705cbb6	certificate	MIICmzCCAYMCBgGCoSZEvzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjIwODE1MTA1NTE2WhcNMzIwODE1MTA1NjU2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4r0az+Zswb4Qyhnlse6TkWZkwtKt41AVetD3t3lzvw5/a9lzSrhBq5122UfQVh+LfVPNUHDV64Q+JvRW6gtufl7DNUk1qbgHhkjOrPy/CnOp7r4JgOm6Zv9F7wqNB8nXj24qm++RZKzCXg0lKw6muVZqE4iZmKee5WIcWry+fbRS0Do5Wg0XQHO+rV4mCBwc1/zXHVKmVB6fBRKnJ4Pf5neMj3fT0qH/XGupFuBSq1yEeOifHHHY1TXdcdRMwQ03yRn22aloNzoZQlnUC1a8RYz0EX3QGR6xgb10llJzZymBUEEOPmRTtzkQpeJYTKnpcG3/tdycQRQwcs/yrWLdjAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAEYxi/iS7hnUBEdiofPkb+MCiS5xUtFK+nlPEGtK0SZd62gjon21eRB+0JKuYnbkPvoj26MRQw9q6LfrduCXZNldFEBRUjvCiFKKdwEYMw6TJrSTUarse4/Ojcfq6gOYngtmUbleArZc60lZZkR7hZaztcU25MqHELEqvX2S1Tg/ACU/cFqOHx854Lwd03y1w5vQhVaeYbZ0Qt8cvTc/3YFyw3GXQsAoEo80YbKz7X5ZtrxlsyrG2YF7TWJKZWMDN8qm+bQldtjrUpnpL/eM3PXIoSrcMFGFF6lXfPAKm6BL/mO1BUS7EwXU4yajSm0/fXUPWx5+b0Z0Qo/YVIhNBWI=
f5f12d99-2391-474d-8a16-14a9b214a394	ef668ff9-00f1-4e96-b2e2-e1006705cbb6	priority	100
6135e4f7-db59-42e5-9c34-be3b72f8e29b	a53514cf-1af8-4ae0-87db-ab58fd2db287	secret	RjGFrHAlFQVXnewRxqLi8A
f6baa2c7-9c22-4c5a-816c-b3e9e5f8fcb4	a53514cf-1af8-4ae0-87db-ab58fd2db287	priority	100
146a03b8-eb34-47da-b41e-410e1a1a26c9	a53514cf-1af8-4ae0-87db-ab58fd2db287	kid	a9b27282-be29-4599-8eae-cf43dbee095c
b2266ea4-c72d-4cfe-ac69-0196fc8b172a	12b5d4eb-0de2-4048-b0ca-047e2becaede	certificate	MIICmzCCAYMCBgGCoSZCmzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjIwODE1MTA1NTE1WhcNMzIwODE1MTA1NjU1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCyTbXS+zA0UwXmPhaDJG58LTyxDq4Z5Vod0eGUmw2vU6SmFbS4zu3jKLs2utD+33tRiSqxKPy7kDN/2FI/NJQCk0uUCg7v+qP1Z1ZXNYILPvmC/CoyJ/L0PWbE7Pg5bHHNV5wMe+oNflPfaawVIlAUcmm0CGkoJ4eHfK0swwWFQ8Wuxb7yje0Khq9B5LpE5KOILYkdXOU3aUbZuTzw3Mb8qFiXqcqkxzf4fOVt+ZsCgHXlyREUhMAI4oePn+AfBJutBUPFF4Gq/e3tu/qwNlbOhRwbAPA8j700Hsimsp/WSr351FbwW0jU7C6QNO1r8NX0rGBl98kB89EM7wKZtIq3AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFpEkhTdASvETDdnxJ4xNB5UHJVRRZuB7sN589WhjmIaWTG4lSlsPlovPzw7E9xouS+thVQy67pot79v24wkSjfFmv689LsRA7vPUUW8fdbWmstavbJlSLc6EuAJ+OlSMaI2XU8tT0YJFfjf0B91L1/FrcUUNykbObOhM7DX4aOAKpz7odb3vNzH3J4jNBHyF1YY3Zq/lfCgTmIH09gpi0vm9Zt6Cx2fRPVD07m8sLgDf0rfMR81KESfMh6Cz1RBdtqRV8C7nHcNTSJUc/wmYi0KOcIDWmC7goCBm3S95Yxp7ZbIeBQwfLoHVmpd49II+1yBWRE4RA8mcjJKBJvn+LI=
a3b96e33-006e-400d-9ae8-7726652e455a	12b5d4eb-0de2-4048-b0ca-047e2becaede	keyUse	SIG
5c4e28ee-3326-4d4d-b358-00d9bc623202	12b5d4eb-0de2-4048-b0ca-047e2becaede	privateKey	MIIEogIBAAKCAQEAsk210vswNFMF5j4WgyRufC08sQ6uGeVaHdHhlJsNr1OkphW0uM7t4yi7NrrQ/t97UYkqsSj8u5Azf9hSPzSUApNLlAoO7/qj9WdWVzWCCz75gvwqMify9D1mxOz4OWxxzVecDHvqDX5T32msFSJQFHJptAhpKCeHh3ytLMMFhUPFrsW+8o3tCoavQeS6ROSjiC2JHVzlN2lG2bk88NzG/KhYl6nKpMc3+HzlbfmbAoB15ckRFITACOKHj5/gHwSbrQVDxReBqv3t7bv6sDZWzoUcGwDwPI+9NB7IprKf1kq9+dRW8FtI1OwukDTta/DV9KxgZffJAfPRDO8CmbSKtwIDAQABAoIBACYp+vaPPEie0p7vACuOwzVCC4EMVtiFHk5Oq51+uKWj3hSMhdOeuw1JnRTAVNaQ6BjSJrinwLy2x0cgeq47p0iL1Xv40SytdaWjujfNZKnaj1ZpefClW1vKvrH81L6ZxxwAGg8UAMtllDc4K5SUdRaDTLuzpypol5o45eo0TfyxYigH4ioD3IE5oL/F38rQtSMLpP2sfOdj4G7W4BTDMCUPUc5Idad4KpKojTL4o9Ok9AB8G8Lt6HcCgVeFlYny+ldYlsj348z8mTEUr0eeuiWBI0mb9wP0ChhkD+oCm+M212ZZrI+l4KZ8Ujcp7dKROdwrHbAl4UXyI8gp1rqVyD0CgYEA8xb1zCyHoGUKaVDwO/KquLBUc6ZKMJ25MtpfYVOeOMPNkSYknSbGtJ9heRsP28p7ccpxY3VM4ET/7KfD/KPu3uOKPwKDZDZMzp7MbLGMZ2EaoICHOANT/7PdrunZwpMOfidK7Tw2qtQ+oEAIcbtcfP4p5yGxTQdRw1QDExk2A/UCgYEAu8Xre9v4OCHKv4O33b8M2aWsiQbPNPjdZ6ah/e47e23oWa2AsHteQLPoNR4cKnfVkqYFbkH6Akug039/mRD9L6L71TfXA6AZ3TjpEcMrS2lgpmK+sVXy0m9THeELmc4j2N8VC1PnSs3TQaem4ErO503//WG9Dhvgchv9I1U7lHsCgYA0Tp55XqOYeeVxn/7xh1gBAcBKWl/gci/lp2Oat7l2EXvsXb7HKg7b0ufQfWg+LSW+6IbZleYC5BYFwFvFwyilQWUABfRr3dtNIpJuWQ4TOKvYGY//F4g9n2B2QM+gtLALqTzQK4K/44fOR7kJb/2Iz9AIchGKt6Z6V1uKAoTC+QKBgHAotpITQF73AE4I9YjEl35h0X8/zAEOLeG9zMEKzgjaC5GVa2r/JbtsOuWPiK9tSOsBs/i5/AXm+reaTrM1TKZpqhcf9ZS6yvgzCDSN6Yxv80Uvckwm1JYR3QnZ5L4IPa1LAxzzDxLFgsySwcDzrkbHdoL5IJ4O1LAUO84hGSeFAoGAGACwxDhTZXV6maFQo4JUdSPojblHceHcDExwVW6fBOil4BxEFO4UKm+7KFbWmm9cY2vlbkco1+YSjIDj0N4VBWvbgIVGJK6plF8tMVmAl/NOYsvVx8ll4wh0HkSGCHBDOOYTT301Lj8HilR6h31JG9MrVEPsGRqJFXQgKk1X5C8=
10e27beb-ccb4-4c20-9d08-9c6123ae8b97	12b5d4eb-0de2-4048-b0ca-047e2becaede	priority	100
138f3d75-da33-472a-a544-34082a45da99	415e2632-1519-404e-9e48-3056d4e70ad5	algorithm	HS256
1459de4c-85f1-455c-abf7-4a7866ce5cda	415e2632-1519-404e-9e48-3056d4e70ad5	kid	fdc4b9df-1cb2-4e8e-a5c9-a362af0b955c
6be37b5f-5c44-40ba-8e75-7c7b638d243d	415e2632-1519-404e-9e48-3056d4e70ad5	priority	100
d529fa11-374a-490f-aedd-5736d79dfd2d	415e2632-1519-404e-9e48-3056d4e70ad5	secret	vGgs6bEk5YhjT7qgJl9YdfZQBeSeB9hPx1HJfZpwqGEe1rPxisnjgoBs3gr4TfS2wJr0gpSrRX3MfMWQYpDx6Q
45bda73e-85f4-4ea1-a273-4fe164939f95	de82528d-5d69-49b5-95d9-b6a9080644cb	privateKey	MIIEowIBAAKCAQEAohKP3o0uYb5JCuZpnJzutUAccHlXcJ6X1bghBccIUMe5nj6Mqrj5yqmvUI20CiLBTBbHUuR5GGOFakV9nLoeDd9J/m5MiZsQRj48QjX7CpcauS4H59+fIKot1qXV01BPSHqOnKkk/JC/UwLcPMmNueVQhRRszmBVnc+gsBVhQ2nyHKDg8ldJK0TQh6axJQpfpZ9qvLk8wr9xd84lYnfRcLgqYFsG1RnKwCajyTBeD1SQVJAW+1Yjy+FNaJbW4P8Xs+B5KvUkcsyuyDjOSX+NH3fxuOukeS3T/7Vb1lRv/8f+VWdIASePu3CJrY9iOhOAkgxkRihT61hpWkjWFR4tZQIDAQABAoIBAAw9daMbq3yTR+XsV96NlZOXt24hI+Lr/1CTOt86VFzxcInMdIgyNx9AqG5ffVDkpg+OitguTBz06y8G94EeJ0Xp7qcqAlrEHLsJWTiw5fg7SDfjC5LN9zEa2SJkXN08K/iv1NRtC8+NSP3GcgafPDZlZKrgS4VcjirAcwTJYJKcL3VXv4XjPtJ/vvQccYf8tgyxvauMaOw6VYzzWHM+qn6XdajdJb1uoKjwAKV30/+wrs38wl7I1BUCjuAyUNVBSi2aNYRvH0nZBS7yvWS98zqmwJLZ/5Z6s4pccfSsOOYlS6z2yWj41CIvtAY/kvRCcEHPXO9B2Pf/dKPGzGiD1mECgYEA0sQRcHvnGG5ktZfdOYV/0A2W6MGDFa+3gwJtVnDij8B0XMZIl4bxpW1rswbSdSoHDWSVekTvWE6RLJv74MBRiHPzv9BFSHqcqTAenyVbdHXSvJFjNVSWdvit6tbLScckqNTVYkWIM5WOFA10rZ5zE7VjW8ANqO9bKt23fZdCmVECgYEAxNssrq17nDRMhI+qjkf9Eoi1WFsMix/LCjFeW1BH3hVvrTT29v6xNJPxm1C76rsdIBzsIyMCH8eNocgfFbNUmbqkVRU+DvglUE8MYehbpc7PELXrxSiPFjddSMCHVdaqbeA7gGvUD0MJ4wvwv4eq2LC3RSmBqU+0skFSrKdTjdUCgYEAh3uh+jyrgPj1pAXLH37BemxB5bz/FqGtxXl572cBPIbqRfjwEPedvkloQdzQzKAHiIRv0fkeIhXfHF3ou8DkqGJg/ZxT7RNkQR29kW/iKirTHIQY0d9eGXwh0CPi6bopxp2JzXIE66PngNxldHW2Y6TmCcSbA01ZvWRo30KsfQECgYAOreVUFT2tdTzreacXOwkFE8qqDwgNa86BMRM/LepeBi0wtk1gN7fRGuMeWNPaeh9+4Ik/SYIECqZmFP00ag359LACZDYfeaOWrH5Y4rHK2HQaY+Zz6kVZO8GqBilRXlORI/Jr7h5/ENmw45gNQDmeNPdFogW4MWhhDnvywft6DQKBgGun2Hgz3ro9G59EUgQA8Y77QdM5Tbnby2jeKB45b8zMlk+vXASUjaMEAP2lIcAYB+oM7RatcaWp6Koy7eSJvEuf7MZRCgF9b6NJTtSQ2WsJ9XLJxcFJ+ao2p+po+UzduLnfkwIAGXQkMhh8lkM48u+mIHHzolxx9vO9WHibHY5C
a06eae9a-e724-4483-a03f-46d008a0d75e	de82528d-5d69-49b5-95d9-b6a9080644cb	keyUse	ENC
4ae431f5-bc71-420d-8ec8-4f78e1e9cbee	de82528d-5d69-49b5-95d9-b6a9080644cb	algorithm	RSA-OAEP
50dbe68e-1908-4300-809a-af36083d9b6f	de82528d-5d69-49b5-95d9-b6a9080644cb	priority	100
af4496fa-2805-4137-bc39-f098104806f9	de82528d-5d69-49b5-95d9-b6a9080644cb	certificate	MIICozCCAYsCBgGCoTNv+zANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDDApKc0V4ZWN1dG9yMB4XDTIyMDgxNTExMDkzOVoXDTMyMDgxNTExMTExOVowFTETMBEGA1UEAwwKSnNFeGVjdXRvcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKISj96NLmG+SQrmaZyc7rVAHHB5V3Cel9W4IQXHCFDHuZ4+jKq4+cqpr1CNtAoiwUwWx1LkeRhjhWpFfZy6Hg3fSf5uTImbEEY+PEI1+wqXGrkuB+ffnyCqLdal1dNQT0h6jpypJPyQv1MC3DzJjbnlUIUUbM5gVZ3PoLAVYUNp8hyg4PJXSStE0IemsSUKX6Wfary5PMK/cXfOJWJ30XC4KmBbBtUZysAmo8kwXg9UkFSQFvtWI8vhTWiW1uD/F7PgeSr1JHLMrsg4zkl/jR938bjrpHkt0/+1W9ZUb//H/lVnSAEnj7twia2PYjoTgJIMZEYoU+tYaVpI1hUeLWUCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEACfk7bYTFYJXnkWgeoL4HdVzmxWjg9fDzJVRM5qoaXG75VEmvK5JoNwNj6CBnMAIK5o0X2DzFdCCe8Oq4vkf2pyzI9s8LUkp+QrLDEYXD8z2Hlte3zcs6PWwpySKLjUvQkgT4SV7Z4D3XU34DeEVzzPIhANQngQZOFXD6l03Fqj40t3RYNIvYnOXjX/z93jgnTZY4U/6MLrKupPB1qFJKjzpFpUnBXjfZLouOoa9Ufp2b5mWGhtTzOUGxiHe5IspTD1XjbftYYYNKMtQmBUe9iQQt3VaPWvFfSYh3/MJv4li6zxVF5eFJhJcFmPUeQtKL+EwCn51EyCmgOeE/C4a8mQ==
f9775ab7-37ac-4052-bd09-f2c5336d0231	89ff6032-a771-44ee-9f34-2d45bf2a79f3	secret	G8WfXv7cBXu_SEdQZF64-jOkI7cNr6eV__6HcOqHA13PHWcbxcmvjWBEmDYL3aFmkGWq1SWPUmr2BFzWruULfw
2633742f-0d4e-4a4c-bd80-45e69837624c	89ff6032-a771-44ee-9f34-2d45bf2a79f3	algorithm	HS256
a8fed017-769b-413b-8153-56ee13c2306c	89ff6032-a771-44ee-9f34-2d45bf2a79f3	kid	e67498d9-d5b6-47c4-a956-8c714f4fae19
d47fea23-ed8e-406c-b14a-29377977551e	89ff6032-a771-44ee-9f34-2d45bf2a79f3	priority	100
908081de-1ef4-4322-bed5-69fb60e76206	1406df29-6e32-4cba-bda0-08c0aa32a8ea	certificate	MIICozCCAYsCBgGCoTNvTDANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDDApKc0V4ZWN1dG9yMB4XDTIyMDgxNTExMDkzOFoXDTMyMDgxNTExMTExOFowFTETMBEGA1UEAwwKSnNFeGVjdXRvcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALotzrFCq1tnyFes3LZdsSLA/S521gU5pIJfY0jNOjnuShJH6yZ/aQl+2IGbMbpuvFItAUajvxhCYR2D+vrrtTO42h8pPtpScU1F26PdizsXrUrcdNgSz48JQ4+hUhdJNuOdtFrhQIJlPh9FN6QSV3qvWF5fJW0m+fa7M3B7CNoV3tvhOgxV0pab2vMIHAEtgfNEwwJl/5squQcub8e3ZUkQ4VBCzSsdh1mMxwlWZY6o8P/D8kXSF6NXS+Gtb4ks0JnL5MlyoGSgQ8TyRkbs+qwR0qoZVNruWj0dqyfocNrGwP7QO9oDncGgHsPub/BwQxnWBFDI/0TJKR6ej3IWLS8CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAUlgZecu4d4I+cLMwKutAa6nsJSEmpUaloGbMBupg3702qOKM3Fe7GSDOxr9uUSt1IYk1Ez+OQ68YUnpCURDFj8CWIlPXeU79hMzWvm2al54U3770Xl4EmF7RJ7UIgoRx9KT4/H7qL8xXm4Z9R3HIGKlrbFugil5wCW8U+Mf/ecHDRd97ruLddq9i7Jx+T4bAQDhCwdybwbN9/vzQXm9gu4EdJu90kNGTDDeMkBMTf585KXgUofWbGLMirosh98L1AyZHHrORAp+p4hKIZRrZsNrp/hzqZ7x9+39eSBc2ilLcchfWMCQE2nANFzC4u8248eFRtqjDIySp5LNYz9IXFw==
04e86b77-8dc8-467d-a3eb-26efd797c63a	1406df29-6e32-4cba-bda0-08c0aa32a8ea	privateKey	MIIEowIBAAKCAQEAui3OsUKrW2fIV6zctl2xIsD9LnbWBTmkgl9jSM06Oe5KEkfrJn9pCX7YgZsxum68Ui0BRqO/GEJhHYP6+uu1M7jaHyk+2lJxTUXbo92LOxetStx02BLPjwlDj6FSF0k24520WuFAgmU+H0U3pBJXeq9YXl8lbSb59rszcHsI2hXe2+E6DFXSlpva8wgcAS2B80TDAmX/myq5By5vx7dlSRDhUELNKx2HWYzHCVZljqjw/8PyRdIXo1dL4a1viSzQmcvkyXKgZKBDxPJGRuz6rBHSqhlU2u5aPR2rJ+hw2sbA/tA72gOdwaAew+5v8HBDGdYEUMj/RMkpHp6PchYtLwIDAQABAoIBAB0sf2aEcXCVzy15723+OXseLa5BveC8uxwY0Wh/jD+2qNG7hkwWjAGKaGfKx1yU7Jqd5cTJdPDaufgTjdkS5WaQ8VEPuAMjBxEaQMQpO5+LYsLHz+Fp9S9PPtB7cW8nsFuzgyb4hBDKx5TD1me13hJh9qF3HFjB0kqI5BMcnHL71MmfSQweuuKjetwDmII1Lc+2Rb74vcLOEEMPy03szMt7wxhy3PTT2/rQXXXd7K0QCI9YOfg87CqPEuQHsegxW6b6nAPWqLra/h12NoaF1viKoAiMOS3HNzspl9kfX4mQGPOGF7KPv3td/q0kq+TWrxIK72fhFNxB9JnjWpaoxEkCgYEA6UdoCpDqd9ji7XpFzG+7ESGUUIJoH5qWmPJYWFkK4lYrFemrZqNozwmhBMBBUEiDaaVtagY6z5d2hgWEmAlutPoW+0afPtMJQsjxLosC+SbEhWZnX2pIUGA/9aBKQtFPwR6jNsVinfv+jWf5/ND/tAuX10WLgkAyew/4KyfyNYkCgYEAzFABnPtE49/T1nAvUjpX4RX9ien2NCvO93Ux3jRG6UWe0nANfNk5x2oTEFehfXL/6LaD6yoRccOhUceBIGRNcubIaynwnsRc7zMDOXGLUP6mZK4eoKWS4Ygwe52/pFXUN9Yg8vdm5yPcOQXRv61RBuRpygJEMCS2kQtypDSE1vcCgYEAsQViykHV60RGT/dtaAmRZxqYNc//u5vPlBizObe4LrE82NANJUHzksi3y6co6Qdd0ZmbQc2ga0+AvYsKZ2UhAWyWa+/XgBEdAfUCMFOE2hS1JJXk897vKS8g2f/c2n+DigT5zeJTR5emPyAb7+GZaMMzYkR/7UNSC1i+9eDGSCECgYAaIlXCfcWXHGddc6Yp73qUORrgTEQI8l2b+6qwUKGNbzFcm6auBJ9GacQcgAkRIeeoHciMCSqIEc0Nx+Y1fX8GpoyWYJv9wwJcOns8GtEGQDyKflc+l09Nd/0zor8Dx1LI/aPjUFAiWsztolftG79UkV0S0O1l9xw/O2ajqHAhiwKBgA9LZSKjNtsiyb7f4CtlsegJZ835fE2GXyTQhp6HEC98B1wfAoM7E+IExa9LVBlKMiNBwFhlgBa36CYhKSxT+gi8LLob34RK7jiH+AYSwAdHWZkc29ohz5ehgRLiioqJS/tGdxt0VpG/Jc8wqUw16zBxtvjxyPBxdSZBCJIRi1Cd
9bed5cb4-bdb3-4222-811a-df672111cc67	1406df29-6e32-4cba-bda0-08c0aa32a8ea	keyUse	SIG
f90215a2-b931-4a7f-b833-3ce66a19897d	1406df29-6e32-4cba-bda0-08c0aa32a8ea	priority	100
9bbfe847-8898-4c77-ad2f-1e7776f82c98	1b9f5388-52e8-4477-b62b-0d16ffd3bf25	secret	vNxhPbTFf9ZGfJHG470uZw
cde6a278-3f0e-42a6-ab84-af348d70c521	1b9f5388-52e8-4477-b62b-0d16ffd3bf25	priority	100
d0b11407-ccee-4c1a-ae37-4d042048cec6	1b9f5388-52e8-4477-b62b-0d16ffd3bf25	kid	39d47c3c-efcc-4f9b-9396-332ee56f7617
8a5f1a8f-5463-4489-92e9-0c441a737331	17d410a1-2da0-4549-9271-11de438498b8	host-sending-registration-request-must-match	true
aae776f3-f4b5-469c-b68a-f2468a82b07d	17d410a1-2da0-4549-9271-11de438498b8	client-uris-must-match	true
19dbbb28-183c-4b1f-8695-9b540cbda98e	fe556759-6091-49c9-9e16-3b3257a69594	allow-default-scopes	true
7e82867a-7ef3-463c-8db0-d564efa4c39a	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	saml-role-list-mapper
22f226bb-6af4-4d0f-b526-01d0b4ea3d67	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	saml-user-property-mapper
6bc71bf6-7425-4b47-9f4d-d7bac6fd8c16	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
ed81a8cf-a9f7-40ca-bb3b-5ed72ba8e074	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
66b41a8e-35e9-4ced-b40e-3186b5a72746	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	oidc-address-mapper
75b26669-d1cd-4478-ba7a-64504f5634d1	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	saml-user-attribute-mapper
124ed78a-aaef-4a80-b960-8cfb8e390742	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
aae915b5-8fca-472a-aa16-0022b9ec803f	b81f47e5-2535-40b2-b0a8-51936b27d4d8	allowed-protocol-mapper-types	oidc-full-name-mapper
4b1564f2-52e6-432e-9ede-14eec2560390	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
35e26deb-e272-4a18-bbc6-15738a74c8ba	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
3cf15d57-413d-4152-9f91-890a754ba5c9	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	oidc-address-mapper
2b4fd4f4-35de-4634-83c6-2e926844036b	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	saml-user-attribute-mapper
2cc97a9a-82c4-416f-a9b5-fdfb1ee46e7c	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	saml-user-property-mapper
55cb3ff8-f169-4f99-af9a-e7a8b6aa8dc5	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
4f494fe6-be0e-4124-bf9f-a3160caf0cd2	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	oidc-full-name-mapper
f1465deb-5aa6-4518-9b81-8c2f728c819f	42ca28c9-d589-46d8-9c4a-a1f3134463cb	allowed-protocol-mapper-types	saml-role-list-mapper
8a42d358-e5f8-43c8-a201-aa3855f68455	bb77e222-624d-4c0e-a6b9-97016068f851	max-clients	200
0e61b74d-f0ec-4f45-af81-fdd00ef43375	26f42861-d6ce-440d-911d-a04f542e6066	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.composite_role (composite, child_role) FROM stdin;
d75823db-40d7-40f1-960a-679d4df2df1c	d7303df5-f6c7-45c3-8ad7-c28bb128518c
d75823db-40d7-40f1-960a-679d4df2df1c	681a0f8c-41f3-4d2e-ab0a-039b2ad5281f
d75823db-40d7-40f1-960a-679d4df2df1c	ed32a44c-d31a-415b-a69c-e7d39f8715dc
d75823db-40d7-40f1-960a-679d4df2df1c	4043c8da-f859-4455-9e25-6945184efd43
d75823db-40d7-40f1-960a-679d4df2df1c	d4ad36d5-7e67-44c6-9aaf-c7f65598d33a
d75823db-40d7-40f1-960a-679d4df2df1c	e1a9b68b-cd77-4a0e-a0d9-9bd62357bbfa
d75823db-40d7-40f1-960a-679d4df2df1c	430d719f-162d-4107-aa0f-e87ac29878b0
d75823db-40d7-40f1-960a-679d4df2df1c	84a4a718-b1ac-4d4b-b104-55fa31467b54
d75823db-40d7-40f1-960a-679d4df2df1c	23509922-f730-4f65-a7d7-155f1e72b513
d75823db-40d7-40f1-960a-679d4df2df1c	395c4c7e-d15c-46f1-91bd-61ed96b7861c
d75823db-40d7-40f1-960a-679d4df2df1c	6b701e9b-0fef-48c7-9c56-ab27464f388b
d75823db-40d7-40f1-960a-679d4df2df1c	7bba26fc-1db8-4f43-9311-5174838d4507
d75823db-40d7-40f1-960a-679d4df2df1c	96cc84ed-6a71-4136-bbee-1c91fd18284a
d75823db-40d7-40f1-960a-679d4df2df1c	f5ffe075-fb6b-4596-ae0d-5884b7f7129b
d75823db-40d7-40f1-960a-679d4df2df1c	0069e219-6be6-4cfb-9ea5-b2ce47cb1049
d75823db-40d7-40f1-960a-679d4df2df1c	ffaced2c-53b8-404a-bbb4-eb6c51ca55bd
d75823db-40d7-40f1-960a-679d4df2df1c	f7649520-a055-4ac2-baa3-2a626a8068ce
d75823db-40d7-40f1-960a-679d4df2df1c	e9ec4dea-3432-46f6-aae3-76500ea76f2b
4043c8da-f859-4455-9e25-6945184efd43	0069e219-6be6-4cfb-9ea5-b2ce47cb1049
4043c8da-f859-4455-9e25-6945184efd43	e9ec4dea-3432-46f6-aae3-76500ea76f2b
c0e8f3f2-c318-4146-835d-eba53fc89bb6	74b74e26-84cd-4cfd-aaac-75c4ddc5cec1
d4ad36d5-7e67-44c6-9aaf-c7f65598d33a	ffaced2c-53b8-404a-bbb4-eb6c51ca55bd
c0e8f3f2-c318-4146-835d-eba53fc89bb6	02ff9384-da1c-4857-8ce9-306784a39c74
02ff9384-da1c-4857-8ce9-306784a39c74	96dae680-33e7-49d0-8b81-47d8d92a738a
b1af48b5-e87c-4381-a8bc-8d6bf3e45ab3	d6c8e87b-5633-47f3-aa97-e8843fade2d0
d75823db-40d7-40f1-960a-679d4df2df1c	fba90118-07b1-416a-9f44-2a108d239750
c0e8f3f2-c318-4146-835d-eba53fc89bb6	08190870-0bbc-4b26-b075-c874be0bddbc
c0e8f3f2-c318-4146-835d-eba53fc89bb6	290f0837-8512-44fc-864e-23f60cb8cea6
d75823db-40d7-40f1-960a-679d4df2df1c	6b0201e9-8ca6-43d4-aed3-1178f4d664c8
d75823db-40d7-40f1-960a-679d4df2df1c	b74aa35d-767e-4de6-bee5-6c837864bd20
d75823db-40d7-40f1-960a-679d4df2df1c	a93644b3-4886-4586-bbd0-1b501f74b010
d75823db-40d7-40f1-960a-679d4df2df1c	c0a95eeb-fa99-4776-9908-186dcfdcbcc7
d75823db-40d7-40f1-960a-679d4df2df1c	8fd58a3c-707b-4170-a740-8a7861955c56
d75823db-40d7-40f1-960a-679d4df2df1c	56e119eb-3394-466f-a722-a0fb19465cd6
d75823db-40d7-40f1-960a-679d4df2df1c	6c69bcd1-a264-4ac5-a362-b86e76ad95d3
d75823db-40d7-40f1-960a-679d4df2df1c	53edf4b9-1bfe-4ae0-9b65-b395b1ceb839
d75823db-40d7-40f1-960a-679d4df2df1c	e0b406e4-3cca-4eeb-adec-7ddb937fd887
d75823db-40d7-40f1-960a-679d4df2df1c	d2defefd-0e06-4687-a714-b11612381a6a
d75823db-40d7-40f1-960a-679d4df2df1c	d8ebd68e-1707-470d-878c-3b8837e1ff0d
d75823db-40d7-40f1-960a-679d4df2df1c	44f6ec0d-984a-45fe-8845-54fafb6d7f7b
d75823db-40d7-40f1-960a-679d4df2df1c	314d9e79-b3af-4ecf-9867-70c7caa8782d
d75823db-40d7-40f1-960a-679d4df2df1c	f15fa265-e476-4d8b-93f9-b3bae951690c
d75823db-40d7-40f1-960a-679d4df2df1c	283df9f6-4aa6-4cb9-ba9d-cfc518201536
d75823db-40d7-40f1-960a-679d4df2df1c	9d0e77f7-6c44-44f0-98bd-859ea9163701
d75823db-40d7-40f1-960a-679d4df2df1c	0b3ee2ad-90cb-4f61-8eb7-7c5419095aa3
a93644b3-4886-4586-bbd0-1b501f74b010	f15fa265-e476-4d8b-93f9-b3bae951690c
a93644b3-4886-4586-bbd0-1b501f74b010	0b3ee2ad-90cb-4f61-8eb7-7c5419095aa3
c0a95eeb-fa99-4776-9908-186dcfdcbcc7	283df9f6-4aa6-4cb9-ba9d-cfc518201536
f44f8fdf-2936-45aa-b9ca-949c57694e46	1b064b04-9b79-424c-8f51-be1fbd7174c7
f44f8fdf-2936-45aa-b9ca-949c57694e46	156793cd-c6c8-4ac9-91f9-48c01ad05eee
f44f8fdf-2936-45aa-b9ca-949c57694e46	290206c6-be59-4ebc-9202-c85ebb5d4d5e
f44f8fdf-2936-45aa-b9ca-949c57694e46	e6cfb05d-4f8e-4356-8501-1f17f5f78a2b
f44f8fdf-2936-45aa-b9ca-949c57694e46	5877e3df-2e67-48f9-918a-c1d5a7e7e615
f44f8fdf-2936-45aa-b9ca-949c57694e46	f887f72d-bece-4a23-adeb-ce02c7786991
f44f8fdf-2936-45aa-b9ca-949c57694e46	fb46cf1d-05dc-456c-a5a1-3eef9a2589cf
f44f8fdf-2936-45aa-b9ca-949c57694e46	b0030f2d-10fc-4951-9c3b-ebc5010d6a69
f44f8fdf-2936-45aa-b9ca-949c57694e46	3b77fb26-c035-428b-9cb9-93c53bb754f3
f44f8fdf-2936-45aa-b9ca-949c57694e46	c2206afd-adf6-4dd3-a1c5-0c2ade86d85d
f44f8fdf-2936-45aa-b9ca-949c57694e46	a1e18ebd-ac65-45d5-905a-7721a47fb181
f44f8fdf-2936-45aa-b9ca-949c57694e46	8e05fb27-421a-459c-a5ee-7486d9cc1d15
f44f8fdf-2936-45aa-b9ca-949c57694e46	f08f991b-d88e-40fd-b5f0-83963a7b28df
f44f8fdf-2936-45aa-b9ca-949c57694e46	e439f868-9ec9-484b-b5eb-f2ac2bc704fc
f44f8fdf-2936-45aa-b9ca-949c57694e46	87c87f7f-0f88-49b0-96e9-d98aa0c634c1
f44f8fdf-2936-45aa-b9ca-949c57694e46	413a4a62-a0ae-4bab-9bf8-1fa9040e0576
f44f8fdf-2936-45aa-b9ca-949c57694e46	2b0a65d1-8ec2-4e57-8410-870e86fc01db
290206c6-be59-4ebc-9202-c85ebb5d4d5e	2b0a65d1-8ec2-4e57-8410-870e86fc01db
290206c6-be59-4ebc-9202-c85ebb5d4d5e	e439f868-9ec9-484b-b5eb-f2ac2bc704fc
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	a6a4c637-6bd4-4435-8467-db893794fb79
e6cfb05d-4f8e-4356-8501-1f17f5f78a2b	87c87f7f-0f88-49b0-96e9-d98aa0c634c1
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	2df25649-b570-430e-b145-78ba9d7e4431
2df25649-b570-430e-b145-78ba9d7e4431	56a7cc17-1674-445f-a5d7-0800080154ac
5f9bde64-c0c3-484e-b121-3731e1d4bd2e	5f41b026-ae42-4ba1-866d-f6ea6d114079
d75823db-40d7-40f1-960a-679d4df2df1c	d8d1e63e-9eb0-40f6-bc46-cc9b3e941c71
f44f8fdf-2936-45aa-b9ca-949c57694e46	42010b73-1b88-42c4-b242-2bcb55af0cba
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	1a723420-63dc-43cf-9cca-4b9155939561
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	2bdef8e1-d7c6-4e0a-ae0f-035923df2758
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	bbebcd31-327a-419b-a463-8e2fd46c9c53
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	5a9a8bac-c79f-4f93-b170-06e42885f9e4
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
942d4d82-bc6d-41a7-a1df-12ac9a1e1154	\N	password	45a3abe7-4853-44f0-bbe5-c5dd013af39c	1660561017007	\N	{"value":"6brkKvcuAGDUMttDkNSA97nYWE3z91gmhfK1M+4lewnoSuee4IlLSJLX0locLLUm+5Op1L1tPfDNd2bzOPcuZw==","salt":"CBRRs4bnjX+ovRUne6idKg==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
132fd55f-f9f5-410b-a45a-5cf86d6217fa	\N	password	d5ea372b-b383-4a42-a7d3-9785cce62c5f	1661544157899	My password	{"value":"uXDP5gTnAuPIuFzzuWMuWd4MLq+Y46TjK7l8UQm+nLeeTHH0yW4jS7u+bQd08f4KBD2ZWUfT36OAnPEUVvVC9g==","salt":"JnvATse3BrZU+VY+ndeXuQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
1b6c79f7-94d6-47bd-8e28-5ab4d9f8d525	\N	password	77857d0d-eb2f-4037-bb1e-38ff2f91d05a	1661761889830	My password	{"value":"03j1UAGebBeLuFsXi3Kp95dOB330vDdGWEbiipk6FxCtKq4bG3AawWRmEkfowiwloIW2ak8VJm85zP9eLXaNqQ==","salt":"p1ad7sdNgp8dgpilc+RE5Q==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
1b61b83e-3016-4c10-97d8-7c819381a96b	\N	password	8a75967b-d19c-48e1-9992-8abb57cee314	1661762543378	\N	{"value":"XzoKiAUiwZcFQoBzkmokRMepICfT0Ah/3AWj20umdxuxZFcaaSsqruDI4p0NS50ojrpGfgFg6yAsEknD6yMYwg==","salt":"FA7nNBBVGiXe4ISaCzZZaQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2022-08-15 10:56:48.06601	1	EXECUTED	8:bda77d94bf90182a1e30c24f1c155ec7	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.8.0	\N	\N	0561007152
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2022-08-15 10:56:48.086699	2	MARK_RAN	8:1ecb330f30986693d1cba9ab579fa219	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.8.0	\N	\N	0561007152
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2022-08-15 10:56:48.199276	3	EXECUTED	8:cb7ace19bc6d959f305605d255d4c843	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.8.0	\N	\N	0561007152
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2022-08-15 10:56:48.209095	4	EXECUTED	8:80230013e961310e6872e871be424a63	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.8.0	\N	\N	0561007152
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2022-08-15 10:56:48.472329	5	EXECUTED	8:67f4c20929126adc0c8e9bf48279d244	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.8.0	\N	\N	0561007152
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2022-08-15 10:56:48.481799	6	MARK_RAN	8:7311018b0b8179ce14628ab412bb6783	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.8.0	\N	\N	0561007152
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2022-08-15 10:56:48.706272	7	EXECUTED	8:037ba1216c3640f8785ee6b8e7c8e3c1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.8.0	\N	\N	0561007152
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2022-08-15 10:56:48.716711	8	MARK_RAN	8:7fe6ffe4af4df289b3157de32c624263	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.8.0	\N	\N	0561007152
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2022-08-15 10:56:48.731355	9	EXECUTED	8:9c136bc3187083a98745c7d03bc8a303	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.8.0	\N	\N	0561007152
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2022-08-15 10:56:48.935775	10	EXECUTED	8:b5f09474dca81fb56a97cf5b6553d331	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.8.0	\N	\N	0561007152
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2022-08-15 10:56:49.09784	11	EXECUTED	8:ca924f31bd2a3b219fdcfe78c82dacf4	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.8.0	\N	\N	0561007152
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2022-08-15 10:56:49.108733	12	MARK_RAN	8:8acad7483e106416bcfa6f3b824a16cd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.8.0	\N	\N	0561007152
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2022-08-15 10:56:49.146886	13	EXECUTED	8:9b1266d17f4f87c78226f5055408fd5e	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.8.0	\N	\N	0561007152
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2022-08-15 10:56:49.188427	14	EXECUTED	8:d80ec4ab6dbfe573550ff72396c7e910	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.8.0	\N	\N	0561007152
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2022-08-15 10:56:49.19361	15	MARK_RAN	8:d86eb172171e7c20b9c849b584d147b2	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0561007152
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2022-08-15 10:56:49.198057	16	MARK_RAN	8:5735f46f0fa60689deb0ecdc2a0dea22	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.8.0	\N	\N	0561007152
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2022-08-15 10:56:49.202748	17	EXECUTED	8:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.8.0	\N	\N	0561007152
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2022-08-15 10:56:49.307632	18	EXECUTED	8:5c1a8fd2014ac7fc43b90a700f117b23	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.8.0	\N	\N	0561007152
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2022-08-15 10:56:49.410533	19	EXECUTED	8:1f6c2c2dfc362aff4ed75b3f0ef6b331	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.8.0	\N	\N	0561007152
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2022-08-15 10:56:49.42078	20	EXECUTED	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.8.0	\N	\N	0561007152
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2022-08-15 10:56:50.449266	45	EXECUTED	8:a164ae073c56ffdbc98a615493609a52	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.8.0	\N	\N	0561007152
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2022-08-15 10:56:49.429635	21	MARK_RAN	8:9eb2ee1fa8ad1c5e426421a6f8fdfa6a	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.8.0	\N	\N	0561007152
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2022-08-15 10:56:49.435298	22	MARK_RAN	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.8.0	\N	\N	0561007152
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2022-08-15 10:56:49.486473	23	EXECUTED	8:d9fa18ffa355320395b86270680dd4fe	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.8.0	\N	\N	0561007152
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2022-08-15 10:56:49.501948	24	EXECUTED	8:90cff506fedb06141ffc1c71c4a1214c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.8.0	\N	\N	0561007152
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2022-08-15 10:56:49.506625	25	MARK_RAN	8:11a788aed4961d6d29c427c063af828c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.8.0	\N	\N	0561007152
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2022-08-15 10:56:49.591259	26	EXECUTED	8:a4218e51e1faf380518cce2af5d39b43	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.8.0	\N	\N	0561007152
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2022-08-15 10:56:49.769457	27	EXECUTED	8:d9e9a1bfaa644da9952456050f07bbdc	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.8.0	\N	\N	0561007152
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2022-08-15 10:56:49.777057	28	EXECUTED	8:d1bf991a6163c0acbfe664b615314505	update tableName=RESOURCE_SERVER_POLICY		\N	4.8.0	\N	\N	0561007152
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2022-08-15 10:56:49.916403	29	EXECUTED	8:88a743a1e87ec5e30bf603da68058a8c	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.8.0	\N	\N	0561007152
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2022-08-15 10:56:49.950057	30	EXECUTED	8:c5517863c875d325dea463d00ec26d7a	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.8.0	\N	\N	0561007152
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2022-08-15 10:56:49.998889	31	EXECUTED	8:ada8b4833b74a498f376d7136bc7d327	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.8.0	\N	\N	0561007152
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2022-08-15 10:56:50.010554	32	EXECUTED	8:b9b73c8ea7299457f99fcbb825c263ba	customChange		\N	4.8.0	\N	\N	0561007152
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2022-08-15 10:56:50.026111	33	EXECUTED	8:07724333e625ccfcfc5adc63d57314f3	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0561007152
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2022-08-15 10:56:50.033979	34	MARK_RAN	8:8b6fd445958882efe55deb26fc541a7b	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.8.0	\N	\N	0561007152
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2022-08-15 10:56:50.093762	35	EXECUTED	8:29b29cfebfd12600897680147277a9d7	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.8.0	\N	\N	0561007152
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2022-08-15 10:56:50.103894	36	EXECUTED	8:73ad77ca8fd0410c7f9f15a471fa52bc	addColumn tableName=REALM		\N	4.8.0	\N	\N	0561007152
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2022-08-15 10:56:50.116147	37	EXECUTED	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0561007152
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2022-08-15 10:56:50.124593	38	EXECUTED	8:27180251182e6c31846c2ddab4bc5781	addColumn tableName=FED_USER_CONSENT		\N	4.8.0	\N	\N	0561007152
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2022-08-15 10:56:50.131812	39	EXECUTED	8:d56f201bfcfa7a1413eb3e9bc02978f9	addColumn tableName=IDENTITY_PROVIDER		\N	4.8.0	\N	\N	0561007152
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2022-08-15 10:56:50.136213	40	MARK_RAN	8:91f5522bf6afdc2077dfab57fbd3455c	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.8.0	\N	\N	0561007152
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2022-08-15 10:56:50.14118	41	MARK_RAN	8:0f01b554f256c22caeb7d8aee3a1cdc8	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.8.0	\N	\N	0561007152
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2022-08-15 10:56:50.15287	42	EXECUTED	8:ab91cf9cee415867ade0e2df9651a947	customChange		\N	4.8.0	\N	\N	0561007152
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2022-08-15 10:56:50.429096	43	EXECUTED	8:ceac9b1889e97d602caf373eadb0d4b7	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.8.0	\N	\N	0561007152
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2022-08-15 10:56:50.43844	44	EXECUTED	8:84b986e628fe8f7fd8fd3c275c5259f2	addColumn tableName=USER_ENTITY		\N	4.8.0	\N	\N	0561007152
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2022-08-15 10:56:50.461171	46	EXECUTED	8:70a2b4f1f4bd4dbf487114bdb1810e64	customChange		\N	4.8.0	\N	\N	0561007152
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2022-08-15 10:56:50.465418	47	MARK_RAN	8:7be68b71d2f5b94b8df2e824f2860fa2	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.8.0	\N	\N	0561007152
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2022-08-15 10:56:50.549741	48	EXECUTED	8:bab7c631093c3861d6cf6144cd944982	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.8.0	\N	\N	0561007152
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2022-08-15 10:56:50.563434	49	EXECUTED	8:fa809ac11877d74d76fe40869916daad	addColumn tableName=REALM		\N	4.8.0	\N	\N	0561007152
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2022-08-15 10:56:50.672139	50	EXECUTED	8:fac23540a40208f5f5e326f6ceb4d291	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.8.0	\N	\N	0561007152
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2022-08-15 10:56:50.742507	51	EXECUTED	8:2612d1b8a97e2b5588c346e817307593	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.8.0	\N	\N	0561007152
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2022-08-15 10:56:50.752551	52	EXECUTED	8:9842f155c5db2206c88bcb5d1046e941	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0561007152
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2022-08-15 10:56:50.760383	53	EXECUTED	8:2e12e06e45498406db72d5b3da5bbc76	update tableName=REALM		\N	4.8.0	\N	\N	0561007152
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2022-08-15 10:56:50.769206	54	EXECUTED	8:33560e7c7989250c40da3abdabdc75a4	update tableName=CLIENT		\N	4.8.0	\N	\N	0561007152
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2022-08-15 10:56:50.783296	55	EXECUTED	8:87a8d8542046817a9107c7eb9cbad1cd	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.8.0	\N	\N	0561007152
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2022-08-15 10:56:50.793514	56	EXECUTED	8:3ea08490a70215ed0088c273d776311e	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.8.0	\N	\N	0561007152
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2022-08-15 10:56:50.836183	57	EXECUTED	8:2d56697c8723d4592ab608ce14b6ed68	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.8.0	\N	\N	0561007152
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2022-08-15 10:56:51.036745	58	EXECUTED	8:3e423e249f6068ea2bbe48bf907f9d86	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.8.0	\N	\N	0561007152
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2022-08-15 10:56:51.086005	59	EXECUTED	8:15cabee5e5df0ff099510a0fc03e4103	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.8.0	\N	\N	0561007152
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2022-08-15 10:56:51.097624	60	EXECUTED	8:4b80200af916ac54d2ffbfc47918ab0e	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.8.0	\N	\N	0561007152
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2022-08-15 10:56:51.115404	61	EXECUTED	8:66564cd5e168045d52252c5027485bbb	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.8.0	\N	\N	0561007152
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2022-08-15 10:56:51.12647	62	EXECUTED	8:1c7064fafb030222be2bd16ccf690f6f	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.8.0	\N	\N	0561007152
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2022-08-15 10:56:51.134545	63	EXECUTED	8:2de18a0dce10cdda5c7e65c9b719b6e5	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.8.0	\N	\N	0561007152
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2022-08-15 10:56:51.141127	64	EXECUTED	8:03e413dd182dcbd5c57e41c34d0ef682	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.8.0	\N	\N	0561007152
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2022-08-15 10:56:51.148481	65	EXECUTED	8:d27b42bb2571c18fbe3fe4e4fb7582a7	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.8.0	\N	\N	0561007152
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2022-08-15 10:56:51.177184	66	EXECUTED	8:698baf84d9fd0027e9192717c2154fb8	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.8.0	\N	\N	0561007152
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2022-08-15 10:56:51.191982	67	EXECUTED	8:ced8822edf0f75ef26eb51582f9a821a	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.8.0	\N	\N	0561007152
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2022-08-15 10:56:51.20285	68	EXECUTED	8:f0abba004cf429e8afc43056df06487d	addColumn tableName=REALM		\N	4.8.0	\N	\N	0561007152
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2022-08-15 10:56:51.224291	69	EXECUTED	8:6662f8b0b611caa359fcf13bf63b4e24	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.8.0	\N	\N	0561007152
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2022-08-15 10:56:51.236475	70	EXECUTED	8:9e6b8009560f684250bdbdf97670d39e	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.8.0	\N	\N	0561007152
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2022-08-15 10:56:51.245282	71	EXECUTED	8:4223f561f3b8dc655846562b57bb502e	addColumn tableName=RESOURCE_SERVER		\N	4.8.0	\N	\N	0561007152
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2022-08-15 10:56:51.273769	72	EXECUTED	8:215a31c398b363ce383a2b301202f29e	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.8.0	\N	\N	0561007152
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2022-08-15 10:56:51.291946	73	EXECUTED	8:83f7a671792ca98b3cbd3a1a34862d3d	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.8.0	\N	\N	0561007152
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2022-08-15 10:56:51.296544	74	MARK_RAN	8:f58ad148698cf30707a6efbdf8061aa7	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.8.0	\N	\N	0561007152
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2022-08-15 10:56:51.337833	75	EXECUTED	8:79e4fd6c6442980e58d52ffc3ee7b19c	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.8.0	\N	\N	0561007152
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2022-08-15 10:56:51.357001	76	EXECUTED	8:87af6a1e6d241ca4b15801d1f86a297d	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.8.0	\N	\N	0561007152
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2022-08-15 10:56:51.365671	77	EXECUTED	8:b44f8d9b7b6ea455305a6d72a200ed15	addColumn tableName=CLIENT		\N	4.8.0	\N	\N	0561007152
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2022-08-15 10:56:51.370614	78	MARK_RAN	8:2d8ed5aaaeffd0cb004c046b4a903ac5	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.8.0	\N	\N	0561007152
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2022-08-15 10:56:51.406487	79	EXECUTED	8:e290c01fcbc275326c511633f6e2acde	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.8.0	\N	\N	0561007152
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2022-08-15 10:56:51.41349	80	MARK_RAN	8:c9db8784c33cea210872ac2d805439f8	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.8.0	\N	\N	0561007152
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2022-08-15 10:56:51.427326	81	EXECUTED	8:95b676ce8fc546a1fcfb4c92fae4add5	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.8.0	\N	\N	0561007152
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2022-08-15 10:56:51.43178	82	MARK_RAN	8:38a6b2a41f5651018b1aca93a41401e5	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0561007152
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2022-08-15 10:56:51.443883	83	EXECUTED	8:3fb99bcad86a0229783123ac52f7609c	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0561007152
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2022-08-15 10:56:51.451783	84	MARK_RAN	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0561007152
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2022-08-15 10:56:51.463957	85	EXECUTED	8:ab4f863f39adafd4c862f7ec01890abc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.8.0	\N	\N	0561007152
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2022-08-15 10:56:51.476332	86	EXECUTED	8:13c419a0eb336e91ee3a3bf8fda6e2a7	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.8.0	\N	\N	0561007152
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2022-08-15 10:56:51.493989	87	EXECUTED	8:e3fb1e698e0471487f51af1ed80fe3ac	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.8.0	\N	\N	0561007152
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2022-08-15 10:56:51.518243	88	EXECUTED	8:babadb686aab7b56562817e60bf0abd0	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.8.0	\N	\N	0561007152
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.535256	89	EXECUTED	8:72d03345fda8e2f17093d08801947773	addColumn tableName=REALM; customChange		\N	4.8.0	\N	\N	0561007152
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.548847	90	EXECUTED	8:61c9233951bd96ffecd9ba75f7d978a4	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.8.0	\N	\N	0561007152
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.560675	91	EXECUTED	8:ea82e6ad945cec250af6372767b25525	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0561007152
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.580332	92	EXECUTED	8:d3f4a33f41d960ddacd7e2ef30d126b3	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.8.0	\N	\N	0561007152
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.58406	93	MARK_RAN	8:1284a27fbd049d65831cb6fc07c8a783	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.8.0	\N	\N	0561007152
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.60009	94	EXECUTED	8:9d11b619db2ae27c25853b8a37cd0dea	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.8.0	\N	\N	0561007152
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.604159	95	MARK_RAN	8:3002bb3997451bb9e8bac5c5cd8d6327	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.8.0	\N	\N	0561007152
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2022-08-15 10:56:51.614421	96	EXECUTED	8:dfbee0d6237a23ef4ccbb7a4e063c163	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.8.0	\N	\N	0561007152
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.639493	97	EXECUTED	8:75f3e372df18d38c62734eebb986b960	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0561007152
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.643448	98	MARK_RAN	8:7fee73eddf84a6035691512c85637eef	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0561007152
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.667874	99	MARK_RAN	8:7a11134ab12820f999fbf3bb13c3adc8	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0561007152
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.679028	100	EXECUTED	8:c0f6eaac1f3be773ffe54cb5b8482b70	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0561007152
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.683341	101	MARK_RAN	8:18186f0008b86e0f0f49b0c4d0e842ac	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0561007152
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.693932	102	EXECUTED	8:09c2780bcb23b310a7019d217dc7b433	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.8.0	\N	\N	0561007152
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2022-08-15 10:56:51.7067	103	EXECUTED	8:276a44955eab693c970a42880197fff2	customChange		\N	4.8.0	\N	\N	0561007152
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2022-08-15 10:56:51.722027	104	EXECUTED	8:ba8ee3b694d043f2bfc1a1079d0760d7	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.8.0	\N	\N	0561007152
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2022-08-15 10:56:51.733172	105	EXECUTED	8:5e06b1d75f5d17685485e610c2851b17	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.8.0	\N	\N	0561007152
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2022-08-15 10:56:51.743686	106	EXECUTED	8:4b80546c1dc550ac552ee7b24a4ab7c0	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.8.0	\N	\N	0561007152
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2022-08-15 10:56:51.753943	107	EXECUTED	8:af510cd1bb2ab6339c45372f3e491696	customChange		\N	4.8.0	\N	\N	0561007152
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
328a8777-dc28-41dd-931b-66af1660c31c	d3996c34-1f91-4652-a309-b014fd1fc37b	f
328a8777-dc28-41dd-931b-66af1660c31c	bebc7eb3-27d6-4865-baa6-fb59bac35fd6	t
328a8777-dc28-41dd-931b-66af1660c31c	2c3ad767-8a8a-4b97-85d2-622dafcc05c3	t
328a8777-dc28-41dd-931b-66af1660c31c	b4e81c0b-1a5d-486c-925d-7d2db8f637f5	t
328a8777-dc28-41dd-931b-66af1660c31c	93947f32-256d-4e4b-a2e2-1b7c9b62021e	f
328a8777-dc28-41dd-931b-66af1660c31c	569b2a22-6e96-48ad-bda6-bd3e57fb27ba	f
328a8777-dc28-41dd-931b-66af1660c31c	02d1f9b1-9d90-4160-9618-e18af6019b6b	t
328a8777-dc28-41dd-931b-66af1660c31c	95d18b9a-e258-480c-b693-d898fb700b03	t
328a8777-dc28-41dd-931b-66af1660c31c	87e7dc68-e7b7-4356-b91b-6e6a3186ae08	f
328a8777-dc28-41dd-931b-66af1660c31c	9e134cbe-d9d8-4c47-b810-fe23e21a5433	t
80229060-53a8-4a28-bfc4-ceebabe05d64	42a22ce4-c6c8-44e8-8191-206ad6afe765	f
80229060-53a8-4a28-bfc4-ceebabe05d64	b70b8542-a92c-4a16-96a4-4da2a928ddcc	t
80229060-53a8-4a28-bfc4-ceebabe05d64	bcb9bf08-4901-4aa7-ad37-62815752e282	t
80229060-53a8-4a28-bfc4-ceebabe05d64	cb45d198-cf9c-4b54-a821-17bd1452dfab	t
80229060-53a8-4a28-bfc4-ceebabe05d64	865cb18b-4d01-4b1b-bd13-3b903efe7e1c	f
80229060-53a8-4a28-bfc4-ceebabe05d64	46d7b3e7-31e6-4023-ab99-fcfdc770a997	f
80229060-53a8-4a28-bfc4-ceebabe05d64	1a89ce96-08ac-4636-8487-6173ad97b4f4	t
80229060-53a8-4a28-bfc4-ceebabe05d64	7f755b10-af77-4d7c-9ca7-f46a179d86ef	t
80229060-53a8-4a28-bfc4-ceebabe05d64	69a5e293-0504-4453-a2ae-bd3c35422ac2	f
80229060-53a8-4a28-bfc4-ceebabe05d64	92161823-edea-4df2-ab3b-7923c06d9fea	t
80229060-53a8-4a28-bfc4-ceebabe05d64	16c0ac5d-0ab4-425c-9ffc-bcd2c04caed0	t
80229060-53a8-4a28-bfc4-ceebabe05d64	b5704760-278f-49af-adb7-efb002023c2f	t
80229060-53a8-4a28-bfc4-ceebabe05d64	b16307a7-dadb-45e5-bf6a-09ceeb7fe75d	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
c0e8f3f2-c318-4146-835d-eba53fc89bb6	328a8777-dc28-41dd-931b-66af1660c31c	f	${role_default-roles}	default-roles-master	328a8777-dc28-41dd-931b-66af1660c31c	\N	\N
d7303df5-f6c7-45c3-8ad7-c28bb128518c	328a8777-dc28-41dd-931b-66af1660c31c	f	${role_create-realm}	create-realm	328a8777-dc28-41dd-931b-66af1660c31c	\N	\N
d75823db-40d7-40f1-960a-679d4df2df1c	328a8777-dc28-41dd-931b-66af1660c31c	f	${role_admin}	admin	328a8777-dc28-41dd-931b-66af1660c31c	\N	\N
681a0f8c-41f3-4d2e-ab0a-039b2ad5281f	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_create-client}	create-client	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
ed32a44c-d31a-415b-a69c-e7d39f8715dc	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_view-realm}	view-realm	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
4043c8da-f859-4455-9e25-6945184efd43	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_view-users}	view-users	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
d4ad36d5-7e67-44c6-9aaf-c7f65598d33a	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_view-clients}	view-clients	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
e1a9b68b-cd77-4a0e-a0d9-9bd62357bbfa	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_view-events}	view-events	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
430d719f-162d-4107-aa0f-e87ac29878b0	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_view-identity-providers}	view-identity-providers	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
84a4a718-b1ac-4d4b-b104-55fa31467b54	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_view-authorization}	view-authorization	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
23509922-f730-4f65-a7d7-155f1e72b513	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_manage-realm}	manage-realm	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
395c4c7e-d15c-46f1-91bd-61ed96b7861c	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_manage-users}	manage-users	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
6b701e9b-0fef-48c7-9c56-ab27464f388b	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_manage-clients}	manage-clients	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
7bba26fc-1db8-4f43-9311-5174838d4507	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_manage-events}	manage-events	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
96cc84ed-6a71-4136-bbee-1c91fd18284a	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_manage-identity-providers}	manage-identity-providers	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
f5ffe075-fb6b-4596-ae0d-5884b7f7129b	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_manage-authorization}	manage-authorization	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
0069e219-6be6-4cfb-9ea5-b2ce47cb1049	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_query-users}	query-users	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
ffaced2c-53b8-404a-bbb4-eb6c51ca55bd	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_query-clients}	query-clients	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
f7649520-a055-4ac2-baa3-2a626a8068ce	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_query-realms}	query-realms	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
e9ec4dea-3432-46f6-aae3-76500ea76f2b	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_query-groups}	query-groups	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
74b74e26-84cd-4cfd-aaac-75c4ddc5cec1	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_view-profile}	view-profile	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
02ff9384-da1c-4857-8ce9-306784a39c74	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_manage-account}	manage-account	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
96dae680-33e7-49d0-8b81-47d8d92a738a	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_manage-account-links}	manage-account-links	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
212cadf6-5cc2-4f95-b737-ac68ba0d21e2	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_view-applications}	view-applications	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
d6c8e87b-5633-47f3-aa97-e8843fade2d0	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_view-consent}	view-consent	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
b1af48b5-e87c-4381-a8bc-8d6bf3e45ab3	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_manage-consent}	manage-consent	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
7f9b0015-7c5e-497d-b138-2919fe9f7d6c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	t	${role_delete-account}	delete-account	328a8777-dc28-41dd-931b-66af1660c31c	a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	\N
4ce0f971-8b06-488e-b3a7-e0d2d3ab7fe0	fa8efa56-6835-455d-943e-1cf089f80040	t	${role_read-token}	read-token	328a8777-dc28-41dd-931b-66af1660c31c	fa8efa56-6835-455d-943e-1cf089f80040	\N
fba90118-07b1-416a-9f44-2a108d239750	242805d5-7a12-4a07-8b69-c046f326d6fa	t	${role_impersonation}	impersonation	328a8777-dc28-41dd-931b-66af1660c31c	242805d5-7a12-4a07-8b69-c046f326d6fa	\N
08190870-0bbc-4b26-b075-c874be0bddbc	328a8777-dc28-41dd-931b-66af1660c31c	f	${role_offline-access}	offline_access	328a8777-dc28-41dd-931b-66af1660c31c	\N	\N
290f0837-8512-44fc-864e-23f60cb8cea6	328a8777-dc28-41dd-931b-66af1660c31c	f	${role_uma_authorization}	uma_authorization	328a8777-dc28-41dd-931b-66af1660c31c	\N	\N
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	80229060-53a8-4a28-bfc4-ceebabe05d64	f	${role_default-roles}	default-roles-jsexecutor	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
6b0201e9-8ca6-43d4-aed3-1178f4d664c8	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_create-client}	create-client	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
b74aa35d-767e-4de6-bee5-6c837864bd20	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_view-realm}	view-realm	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
a93644b3-4886-4586-bbd0-1b501f74b010	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_view-users}	view-users	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
c0a95eeb-fa99-4776-9908-186dcfdcbcc7	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_view-clients}	view-clients	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
8fd58a3c-707b-4170-a740-8a7861955c56	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_view-events}	view-events	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
56e119eb-3394-466f-a722-a0fb19465cd6	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_view-identity-providers}	view-identity-providers	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
6c69bcd1-a264-4ac5-a362-b86e76ad95d3	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_view-authorization}	view-authorization	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
53edf4b9-1bfe-4ae0-9b65-b395b1ceb839	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_manage-realm}	manage-realm	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
e0b406e4-3cca-4eeb-adec-7ddb937fd887	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_manage-users}	manage-users	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
d2defefd-0e06-4687-a714-b11612381a6a	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_manage-clients}	manage-clients	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
d8ebd68e-1707-470d-878c-3b8837e1ff0d	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_manage-events}	manage-events	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
44f6ec0d-984a-45fe-8845-54fafb6d7f7b	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_manage-identity-providers}	manage-identity-providers	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
314d9e79-b3af-4ecf-9867-70c7caa8782d	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_manage-authorization}	manage-authorization	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
f15fa265-e476-4d8b-93f9-b3bae951690c	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_query-users}	query-users	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
283df9f6-4aa6-4cb9-ba9d-cfc518201536	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_query-clients}	query-clients	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
9d0e77f7-6c44-44f0-98bd-859ea9163701	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_query-realms}	query-realms	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
0b3ee2ad-90cb-4f61-8eb7-7c5419095aa3	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_query-groups}	query-groups	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
f44f8fdf-2936-45aa-b9ca-949c57694e46	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_realm-admin}	realm-admin	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
1b064b04-9b79-424c-8f51-be1fbd7174c7	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_create-client}	create-client	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
156793cd-c6c8-4ac9-91f9-48c01ad05eee	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_view-realm}	view-realm	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
290206c6-be59-4ebc-9202-c85ebb5d4d5e	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_view-users}	view-users	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
e6cfb05d-4f8e-4356-8501-1f17f5f78a2b	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_view-clients}	view-clients	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
5877e3df-2e67-48f9-918a-c1d5a7e7e615	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_view-events}	view-events	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
f887f72d-bece-4a23-adeb-ce02c7786991	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_view-identity-providers}	view-identity-providers	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
fb46cf1d-05dc-456c-a5a1-3eef9a2589cf	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_view-authorization}	view-authorization	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
b0030f2d-10fc-4951-9c3b-ebc5010d6a69	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_manage-realm}	manage-realm	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
3b77fb26-c035-428b-9cb9-93c53bb754f3	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_manage-users}	manage-users	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
c2206afd-adf6-4dd3-a1c5-0c2ade86d85d	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_manage-clients}	manage-clients	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
a1e18ebd-ac65-45d5-905a-7721a47fb181	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_manage-events}	manage-events	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
8e05fb27-421a-459c-a5ee-7486d9cc1d15	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_manage-identity-providers}	manage-identity-providers	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
f08f991b-d88e-40fd-b5f0-83963a7b28df	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_manage-authorization}	manage-authorization	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
e439f868-9ec9-484b-b5eb-f2ac2bc704fc	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_query-users}	query-users	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
87c87f7f-0f88-49b0-96e9-d98aa0c634c1	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_query-clients}	query-clients	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
413a4a62-a0ae-4bab-9bf8-1fa9040e0576	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_query-realms}	query-realms	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
2b0a65d1-8ec2-4e57-8410-870e86fc01db	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_query-groups}	query-groups	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
a6a4c637-6bd4-4435-8467-db893794fb79	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_view-profile}	view-profile	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
2df25649-b570-430e-b145-78ba9d7e4431	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_manage-account}	manage-account	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
56a7cc17-1674-445f-a5d7-0800080154ac	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_manage-account-links}	manage-account-links	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
66fe3b32-d1c2-4317-b3be-c9fb1bd5cf92	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_view-applications}	view-applications	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
5f41b026-ae42-4ba1-866d-f6ea6d114079	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_view-consent}	view-consent	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
5f9bde64-c0c3-484e-b121-3731e1d4bd2e	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_manage-consent}	manage-consent	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
b7c59a5c-f120-4b5a-924b-793f737bcf47	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	t	${role_delete-account}	delete-account	80229060-53a8-4a28-bfc4-ceebabe05d64	ee3cb8e7-1f63-47c3-973c-2c7a1427095c	\N
d8d1e63e-9eb0-40f6-bc46-cc9b3e941c71	f485b846-6289-40b6-a42c-287e95d8cd82	t	${role_impersonation}	impersonation	328a8777-dc28-41dd-931b-66af1660c31c	f485b846-6289-40b6-a42c-287e95d8cd82	\N
42010b73-1b88-42c4-b242-2bcb55af0cba	559dfb53-c90c-4d4b-ba77-7235c4341189	t	${role_impersonation}	impersonation	80229060-53a8-4a28-bfc4-ceebabe05d64	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
2a4965b2-8926-4b48-a1cd-841f7f7e4335	008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	t	${role_read-token}	read-token	80229060-53a8-4a28-bfc4-ceebabe05d64	008d1d7c-6622-4f57-9b63-6ba9bc55d1d9	\N
1a723420-63dc-43cf-9cca-4b9155939561	80229060-53a8-4a28-bfc4-ceebabe05d64	f	${role_offline-access}	offline_access	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
2bdef8e1-d7c6-4e0a-ae0f-035923df2758	80229060-53a8-4a28-bfc4-ceebabe05d64	f	${role_uma_authorization}	uma_authorization	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
bbebcd31-327a-419b-a463-8e2fd46c9c53	80229060-53a8-4a28-bfc4-ceebabe05d64	f		user	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
297db9d7-eaac-40d4-8f34-ac31506259c3	646226dc-1492-41e1-afcb-b398abd036bd	t	\N	uma_protection	80229060-53a8-4a28-bfc4-ceebabe05d64	646226dc-1492-41e1-afcb-b398abd036bd	\N
5a9a8bac-c79f-4f93-b170-06e42885f9e4	80229060-53a8-4a28-bfc4-ceebabe05d64	f		app_user	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
dc80715a-a29e-4f71-81a0-5c179eef805a	646226dc-1492-41e1-afcb-b398abd036bd	t	\N	app_user	80229060-53a8-4a28-bfc4-ceebabe05d64	646226dc-1492-41e1-afcb-b398abd036bd	\N
aad89f55-21f9-4284-82b5-6dfd3e0b5bfd	80229060-53a8-4a28-bfc4-ceebabe05d64	f		\N	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
a4068e6e-8f49-47b0-aa74-d261b33be10a	80229060-53a8-4a28-bfc4-ceebabe05d64	f		app_admin	80229060-53a8-4a28-bfc4-ceebabe05d64	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.migration_model (id, version, update_time) FROM stdin;
6zyqv	19.0.1	1660561012
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
4be580ce-f4b7-49c4-82f5-785471ad34c4	audience resolve	openid-connect	oidc-audience-resolve-mapper	3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	\N
eeafaa98-463c-426c-b1eb-8570616d95c7	locale	openid-connect	oidc-usermodel-attribute-mapper	1a9079ff-fb56-4e60-b231-96b51a96c044	\N
af496024-228f-4154-b5a9-7dff0b6a598a	role list	saml	saml-role-list-mapper	\N	bebc7eb3-27d6-4865-baa6-fb59bac35fd6
e6fb52c2-8511-4832-a647-f03e4a870e11	full name	openid-connect	oidc-full-name-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
16dce695-7d90-415b-8e5d-600678c2bf99	family name	openid-connect	oidc-usermodel-property-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
76bada2b-85c7-45ea-8747-f43aa6dec342	given name	openid-connect	oidc-usermodel-property-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
39424253-0109-4956-855b-d534f1cb244c	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
4d394b0d-c0b5-41f0-addc-e18ca51535a2	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
64fe0345-b739-4c81-b396-ea23fc9c29cb	username	openid-connect	oidc-usermodel-property-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
a39f1b36-82d1-4921-84cb-31a486723831	website	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
3516f6bd-06b3-449a-bc39-4cbff41c5883	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
a7209295-b63e-493e-b557-a798bed5fcb4	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	2c3ad767-8a8a-4b97-85d2-622dafcc05c3
5804cf00-e34b-451f-bbc8-409bb09a6ef4	email	openid-connect	oidc-usermodel-property-mapper	\N	b4e81c0b-1a5d-486c-925d-7d2db8f637f5
6a371775-08a0-4a97-af98-9cfd1e15f42b	email verified	openid-connect	oidc-usermodel-property-mapper	\N	b4e81c0b-1a5d-486c-925d-7d2db8f637f5
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	address	openid-connect	oidc-address-mapper	\N	93947f32-256d-4e4b-a2e2-1b7c9b62021e
494975cc-f781-4799-9fbd-6b88e1db6593	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	569b2a22-6e96-48ad-bda6-bd3e57fb27ba
166bea35-f463-4640-b47c-9c50822d310f	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	569b2a22-6e96-48ad-bda6-bd3e57fb27ba
c5a0e27e-6101-4bad-bdd1-4584325020af	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	02d1f9b1-9d90-4160-9618-e18af6019b6b
83b99501-905a-49e5-aa05-c823cae05971	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	02d1f9b1-9d90-4160-9618-e18af6019b6b
4b6c8a7a-5fa2-4042-bf15-d96c56709c47	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	02d1f9b1-9d90-4160-9618-e18af6019b6b
fb8bb09c-07d1-49f9-8226-42ce23c6b590	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	95d18b9a-e258-480c-b693-d898fb700b03
7bfd6d72-f174-455e-9d68-29f50cc66481	upn	openid-connect	oidc-usermodel-property-mapper	\N	87e7dc68-e7b7-4356-b91b-6e6a3186ae08
a4555fe9-a819-485d-b41d-7803e9e8688a	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	87e7dc68-e7b7-4356-b91b-6e6a3186ae08
4c490443-5259-43bd-a646-5f32bd48b06f	acr loa level	openid-connect	oidc-acr-mapper	\N	9e134cbe-d9d8-4c47-b810-fe23e21a5433
24f30237-9ce8-49ec-a27e-cb3228826a8f	audience resolve	openid-connect	oidc-audience-resolve-mapper	132434ea-1786-4839-9d02-33a3b6354f90	\N
83b12318-8faf-4ff2-8df5-245430620ee8	role list	saml	saml-role-list-mapper	\N	b70b8542-a92c-4a16-96a4-4da2a928ddcc
4344216c-c224-4455-be78-b7c82637b308	full name	openid-connect	oidc-full-name-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
85b750c9-5434-4f77-8b37-3461ba5ba3a5	family name	openid-connect	oidc-usermodel-property-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
0d5ee454-82a9-4d91-b3b0-44409b766ce5	given name	openid-connect	oidc-usermodel-property-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
a26db2f5-d43d-4413-ace1-3b55e464258b	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
efe6105c-9d0c-4b45-9937-77a021063a2a	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
312eca4a-12f5-4673-aa6a-7a0babfb051d	username	openid-connect	oidc-usermodel-property-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
474db09c-f9f0-4a68-ada7-3bde43670da5	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
56ebbd96-16f6-4b6e-813b-4711228e66a0	website	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
f24191e3-d903-4fda-9028-61d6014f06c9	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
5796d068-0dfc-4254-9138-af59e05e2b17	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
9ab340ac-e659-48ac-b970-f1a2e0d06e13	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
d31404f1-d56b-4b88-af6c-5b4225d82713	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
20312f76-e3e9-4961-a78e-35ba87b25b1a	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	bcb9bf08-4901-4aa7-ad37-62815752e282
db869b1e-2167-4368-b5c0-dd134803f236	email	openid-connect	oidc-usermodel-property-mapper	\N	cb45d198-cf9c-4b54-a821-17bd1452dfab
f0caa016-6b05-4bf9-ac50-2626a9b25694	email verified	openid-connect	oidc-usermodel-property-mapper	\N	cb45d198-cf9c-4b54-a821-17bd1452dfab
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	address	openid-connect	oidc-address-mapper	\N	865cb18b-4d01-4b1b-bd13-3b903efe7e1c
37aae94b-58a7-468a-8353-8782d8e612fe	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	46d7b3e7-31e6-4023-ab99-fcfdc770a997
1efe27f7-a2a2-4177-931b-7a755f16b9ee	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	46d7b3e7-31e6-4023-ab99-fcfdc770a997
9fe9ada5-f362-46d7-acd9-0168619e6dff	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	1a89ce96-08ac-4636-8487-6173ad97b4f4
8ab5411a-48f8-475b-9e41-7d29f8b36613	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	1a89ce96-08ac-4636-8487-6173ad97b4f4
e7ef5ef8-08cc-4a0e-912d-a2d566821928	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	1a89ce96-08ac-4636-8487-6173ad97b4f4
f64086b6-bc2c-4ea6-ad6f-e0bc1058f5df	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	7f755b10-af77-4d7c-9ca7-f46a179d86ef
827ad9a6-691c-42a8-a9a2-d4be82042ace	upn	openid-connect	oidc-usermodel-property-mapper	\N	69a5e293-0504-4453-a2ae-bd3c35422ac2
6dac18b2-050e-4de0-9fca-e5f76d851208	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	69a5e293-0504-4453-a2ae-bd3c35422ac2
d8d6f7e2-8bbe-4a14-9291-00b00ebece13	acr loa level	openid-connect	oidc-acr-mapper	\N	92161823-edea-4df2-ab3b-7923c06d9fea
7834263a-7e68-49f5-8d79-bb2d496425d0	locale	openid-connect	oidc-usermodel-attribute-mapper	0466602c-8f11-4581-b7e4-d01932dd42df	\N
6cb535c7-4bdf-4f22-9d5c-8d16e0a659e5	rl_dvlpr	openid-connect	oidc-role-name-mapper	\N	b16307a7-dadb-45e5-bf6a-09ceeb7fe75d
a79bb444-e624-46f6-b106-f65e9a1496ea	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	646226dc-1492-41e1-afcb-b398abd036bd	\N
4d7c2382-e9c2-48bb-bf45-3ef65e2731a6	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	646226dc-1492-41e1-afcb-b398abd036bd	\N
d9688d09-d5a1-4680-b965-0dbf3b7dc117	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	646226dc-1492-41e1-afcb-b398abd036bd	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
eeafaa98-463c-426c-b1eb-8570616d95c7	true	userinfo.token.claim
eeafaa98-463c-426c-b1eb-8570616d95c7	locale	user.attribute
eeafaa98-463c-426c-b1eb-8570616d95c7	true	id.token.claim
eeafaa98-463c-426c-b1eb-8570616d95c7	true	access.token.claim
eeafaa98-463c-426c-b1eb-8570616d95c7	locale	claim.name
eeafaa98-463c-426c-b1eb-8570616d95c7	String	jsonType.label
af496024-228f-4154-b5a9-7dff0b6a598a	false	single
af496024-228f-4154-b5a9-7dff0b6a598a	Basic	attribute.nameformat
af496024-228f-4154-b5a9-7dff0b6a598a	Role	attribute.name
16dce695-7d90-415b-8e5d-600678c2bf99	true	userinfo.token.claim
16dce695-7d90-415b-8e5d-600678c2bf99	lastName	user.attribute
16dce695-7d90-415b-8e5d-600678c2bf99	true	id.token.claim
16dce695-7d90-415b-8e5d-600678c2bf99	true	access.token.claim
16dce695-7d90-415b-8e5d-600678c2bf99	family_name	claim.name
16dce695-7d90-415b-8e5d-600678c2bf99	String	jsonType.label
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	true	userinfo.token.claim
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	picture	user.attribute
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	true	id.token.claim
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	true	access.token.claim
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	picture	claim.name
1a9b682d-9f2a-4b8c-adbe-da8cd3d61a27	String	jsonType.label
3516f6bd-06b3-449a-bc39-4cbff41c5883	true	userinfo.token.claim
3516f6bd-06b3-449a-bc39-4cbff41c5883	gender	user.attribute
3516f6bd-06b3-449a-bc39-4cbff41c5883	true	id.token.claim
3516f6bd-06b3-449a-bc39-4cbff41c5883	true	access.token.claim
3516f6bd-06b3-449a-bc39-4cbff41c5883	gender	claim.name
3516f6bd-06b3-449a-bc39-4cbff41c5883	String	jsonType.label
39424253-0109-4956-855b-d534f1cb244c	true	userinfo.token.claim
39424253-0109-4956-855b-d534f1cb244c	middleName	user.attribute
39424253-0109-4956-855b-d534f1cb244c	true	id.token.claim
39424253-0109-4956-855b-d534f1cb244c	true	access.token.claim
39424253-0109-4956-855b-d534f1cb244c	middle_name	claim.name
39424253-0109-4956-855b-d534f1cb244c	String	jsonType.label
4d394b0d-c0b5-41f0-addc-e18ca51535a2	true	userinfo.token.claim
4d394b0d-c0b5-41f0-addc-e18ca51535a2	nickname	user.attribute
4d394b0d-c0b5-41f0-addc-e18ca51535a2	true	id.token.claim
4d394b0d-c0b5-41f0-addc-e18ca51535a2	true	access.token.claim
4d394b0d-c0b5-41f0-addc-e18ca51535a2	nickname	claim.name
4d394b0d-c0b5-41f0-addc-e18ca51535a2	String	jsonType.label
64fe0345-b739-4c81-b396-ea23fc9c29cb	true	userinfo.token.claim
64fe0345-b739-4c81-b396-ea23fc9c29cb	username	user.attribute
64fe0345-b739-4c81-b396-ea23fc9c29cb	true	id.token.claim
64fe0345-b739-4c81-b396-ea23fc9c29cb	true	access.token.claim
64fe0345-b739-4c81-b396-ea23fc9c29cb	preferred_username	claim.name
64fe0345-b739-4c81-b396-ea23fc9c29cb	String	jsonType.label
76bada2b-85c7-45ea-8747-f43aa6dec342	true	userinfo.token.claim
76bada2b-85c7-45ea-8747-f43aa6dec342	firstName	user.attribute
76bada2b-85c7-45ea-8747-f43aa6dec342	true	id.token.claim
76bada2b-85c7-45ea-8747-f43aa6dec342	true	access.token.claim
76bada2b-85c7-45ea-8747-f43aa6dec342	given_name	claim.name
76bada2b-85c7-45ea-8747-f43aa6dec342	String	jsonType.label
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	true	userinfo.token.claim
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	profile	user.attribute
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	true	id.token.claim
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	true	access.token.claim
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	profile	claim.name
8395bf4a-f74c-4c35-b6bf-0c955348bd2e	String	jsonType.label
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	true	userinfo.token.claim
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	birthdate	user.attribute
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	true	id.token.claim
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	true	access.token.claim
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	birthdate	claim.name
9ab639f7-63d6-4688-96a5-8be5d0fe0dbc	String	jsonType.label
a39f1b36-82d1-4921-84cb-31a486723831	true	userinfo.token.claim
a39f1b36-82d1-4921-84cb-31a486723831	website	user.attribute
a39f1b36-82d1-4921-84cb-31a486723831	true	id.token.claim
a39f1b36-82d1-4921-84cb-31a486723831	true	access.token.claim
a39f1b36-82d1-4921-84cb-31a486723831	website	claim.name
a39f1b36-82d1-4921-84cb-31a486723831	String	jsonType.label
a7209295-b63e-493e-b557-a798bed5fcb4	true	userinfo.token.claim
a7209295-b63e-493e-b557-a798bed5fcb4	zoneinfo	user.attribute
a7209295-b63e-493e-b557-a798bed5fcb4	true	id.token.claim
a7209295-b63e-493e-b557-a798bed5fcb4	true	access.token.claim
a7209295-b63e-493e-b557-a798bed5fcb4	zoneinfo	claim.name
a7209295-b63e-493e-b557-a798bed5fcb4	String	jsonType.label
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	true	userinfo.token.claim
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	updatedAt	user.attribute
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	true	id.token.claim
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	true	access.token.claim
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	updated_at	claim.name
afeb065e-7656-4c90-bce5-3b6d9d1a42fd	long	jsonType.label
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	true	userinfo.token.claim
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	locale	user.attribute
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	true	id.token.claim
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	true	access.token.claim
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	locale	claim.name
d02ae6b2-917c-4a1e-bc38-2fd2059f50c5	String	jsonType.label
e6fb52c2-8511-4832-a647-f03e4a870e11	true	userinfo.token.claim
e6fb52c2-8511-4832-a647-f03e4a870e11	true	id.token.claim
e6fb52c2-8511-4832-a647-f03e4a870e11	true	access.token.claim
5804cf00-e34b-451f-bbc8-409bb09a6ef4	true	userinfo.token.claim
5804cf00-e34b-451f-bbc8-409bb09a6ef4	email	user.attribute
5804cf00-e34b-451f-bbc8-409bb09a6ef4	true	id.token.claim
5804cf00-e34b-451f-bbc8-409bb09a6ef4	true	access.token.claim
5804cf00-e34b-451f-bbc8-409bb09a6ef4	email	claim.name
5804cf00-e34b-451f-bbc8-409bb09a6ef4	String	jsonType.label
6a371775-08a0-4a97-af98-9cfd1e15f42b	true	userinfo.token.claim
6a371775-08a0-4a97-af98-9cfd1e15f42b	emailVerified	user.attribute
6a371775-08a0-4a97-af98-9cfd1e15f42b	true	id.token.claim
6a371775-08a0-4a97-af98-9cfd1e15f42b	true	access.token.claim
6a371775-08a0-4a97-af98-9cfd1e15f42b	email_verified	claim.name
6a371775-08a0-4a97-af98-9cfd1e15f42b	boolean	jsonType.label
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	formatted	user.attribute.formatted
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	country	user.attribute.country
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	postal_code	user.attribute.postal_code
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	true	userinfo.token.claim
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	street	user.attribute.street
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	true	id.token.claim
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	region	user.attribute.region
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	true	access.token.claim
8cbc6fa6-a91d-4d9d-b235-0ae9c49bbba6	locality	user.attribute.locality
166bea35-f463-4640-b47c-9c50822d310f	true	userinfo.token.claim
166bea35-f463-4640-b47c-9c50822d310f	phoneNumberVerified	user.attribute
166bea35-f463-4640-b47c-9c50822d310f	true	id.token.claim
166bea35-f463-4640-b47c-9c50822d310f	true	access.token.claim
166bea35-f463-4640-b47c-9c50822d310f	phone_number_verified	claim.name
166bea35-f463-4640-b47c-9c50822d310f	boolean	jsonType.label
494975cc-f781-4799-9fbd-6b88e1db6593	true	userinfo.token.claim
494975cc-f781-4799-9fbd-6b88e1db6593	phoneNumber	user.attribute
494975cc-f781-4799-9fbd-6b88e1db6593	true	id.token.claim
494975cc-f781-4799-9fbd-6b88e1db6593	true	access.token.claim
494975cc-f781-4799-9fbd-6b88e1db6593	phone_number	claim.name
494975cc-f781-4799-9fbd-6b88e1db6593	String	jsonType.label
83b99501-905a-49e5-aa05-c823cae05971	true	multivalued
83b99501-905a-49e5-aa05-c823cae05971	foo	user.attribute
83b99501-905a-49e5-aa05-c823cae05971	true	access.token.claim
83b99501-905a-49e5-aa05-c823cae05971	resource_access.${client_id}.roles	claim.name
83b99501-905a-49e5-aa05-c823cae05971	String	jsonType.label
c5a0e27e-6101-4bad-bdd1-4584325020af	true	multivalued
c5a0e27e-6101-4bad-bdd1-4584325020af	foo	user.attribute
c5a0e27e-6101-4bad-bdd1-4584325020af	true	access.token.claim
c5a0e27e-6101-4bad-bdd1-4584325020af	realm_access.roles	claim.name
c5a0e27e-6101-4bad-bdd1-4584325020af	String	jsonType.label
7bfd6d72-f174-455e-9d68-29f50cc66481	true	userinfo.token.claim
7bfd6d72-f174-455e-9d68-29f50cc66481	username	user.attribute
7bfd6d72-f174-455e-9d68-29f50cc66481	true	id.token.claim
7bfd6d72-f174-455e-9d68-29f50cc66481	true	access.token.claim
7bfd6d72-f174-455e-9d68-29f50cc66481	upn	claim.name
7bfd6d72-f174-455e-9d68-29f50cc66481	String	jsonType.label
a4555fe9-a819-485d-b41d-7803e9e8688a	true	multivalued
a4555fe9-a819-485d-b41d-7803e9e8688a	foo	user.attribute
a4555fe9-a819-485d-b41d-7803e9e8688a	true	id.token.claim
a4555fe9-a819-485d-b41d-7803e9e8688a	true	access.token.claim
a4555fe9-a819-485d-b41d-7803e9e8688a	groups	claim.name
a4555fe9-a819-485d-b41d-7803e9e8688a	String	jsonType.label
4c490443-5259-43bd-a646-5f32bd48b06f	true	id.token.claim
4c490443-5259-43bd-a646-5f32bd48b06f	true	access.token.claim
83b12318-8faf-4ff2-8df5-245430620ee8	false	single
83b12318-8faf-4ff2-8df5-245430620ee8	Basic	attribute.nameformat
83b12318-8faf-4ff2-8df5-245430620ee8	Role	attribute.name
0d5ee454-82a9-4d91-b3b0-44409b766ce5	true	userinfo.token.claim
0d5ee454-82a9-4d91-b3b0-44409b766ce5	firstName	user.attribute
0d5ee454-82a9-4d91-b3b0-44409b766ce5	true	id.token.claim
0d5ee454-82a9-4d91-b3b0-44409b766ce5	true	access.token.claim
0d5ee454-82a9-4d91-b3b0-44409b766ce5	given_name	claim.name
0d5ee454-82a9-4d91-b3b0-44409b766ce5	String	jsonType.label
20312f76-e3e9-4961-a78e-35ba87b25b1a	true	userinfo.token.claim
20312f76-e3e9-4961-a78e-35ba87b25b1a	updatedAt	user.attribute
20312f76-e3e9-4961-a78e-35ba87b25b1a	true	id.token.claim
20312f76-e3e9-4961-a78e-35ba87b25b1a	true	access.token.claim
20312f76-e3e9-4961-a78e-35ba87b25b1a	updated_at	claim.name
20312f76-e3e9-4961-a78e-35ba87b25b1a	long	jsonType.label
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	true	userinfo.token.claim
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	picture	user.attribute
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	true	id.token.claim
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	true	access.token.claim
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	picture	claim.name
223bc5cf-1ea5-40d7-8eb2-7b688bf7b6bd	String	jsonType.label
312eca4a-12f5-4673-aa6a-7a0babfb051d	true	userinfo.token.claim
312eca4a-12f5-4673-aa6a-7a0babfb051d	username	user.attribute
312eca4a-12f5-4673-aa6a-7a0babfb051d	true	id.token.claim
312eca4a-12f5-4673-aa6a-7a0babfb051d	true	access.token.claim
312eca4a-12f5-4673-aa6a-7a0babfb051d	preferred_username	claim.name
312eca4a-12f5-4673-aa6a-7a0babfb051d	String	jsonType.label
4344216c-c224-4455-be78-b7c82637b308	true	userinfo.token.claim
4344216c-c224-4455-be78-b7c82637b308	true	id.token.claim
4344216c-c224-4455-be78-b7c82637b308	true	access.token.claim
474db09c-f9f0-4a68-ada7-3bde43670da5	true	userinfo.token.claim
474db09c-f9f0-4a68-ada7-3bde43670da5	profile	user.attribute
474db09c-f9f0-4a68-ada7-3bde43670da5	true	id.token.claim
474db09c-f9f0-4a68-ada7-3bde43670da5	true	access.token.claim
474db09c-f9f0-4a68-ada7-3bde43670da5	profile	claim.name
474db09c-f9f0-4a68-ada7-3bde43670da5	String	jsonType.label
56ebbd96-16f6-4b6e-813b-4711228e66a0	true	userinfo.token.claim
56ebbd96-16f6-4b6e-813b-4711228e66a0	website	user.attribute
56ebbd96-16f6-4b6e-813b-4711228e66a0	true	id.token.claim
56ebbd96-16f6-4b6e-813b-4711228e66a0	true	access.token.claim
56ebbd96-16f6-4b6e-813b-4711228e66a0	website	claim.name
56ebbd96-16f6-4b6e-813b-4711228e66a0	String	jsonType.label
5796d068-0dfc-4254-9138-af59e05e2b17	true	userinfo.token.claim
5796d068-0dfc-4254-9138-af59e05e2b17	birthdate	user.attribute
5796d068-0dfc-4254-9138-af59e05e2b17	true	id.token.claim
5796d068-0dfc-4254-9138-af59e05e2b17	true	access.token.claim
5796d068-0dfc-4254-9138-af59e05e2b17	birthdate	claim.name
5796d068-0dfc-4254-9138-af59e05e2b17	String	jsonType.label
85b750c9-5434-4f77-8b37-3461ba5ba3a5	true	userinfo.token.claim
85b750c9-5434-4f77-8b37-3461ba5ba3a5	lastName	user.attribute
85b750c9-5434-4f77-8b37-3461ba5ba3a5	true	id.token.claim
85b750c9-5434-4f77-8b37-3461ba5ba3a5	true	access.token.claim
85b750c9-5434-4f77-8b37-3461ba5ba3a5	family_name	claim.name
85b750c9-5434-4f77-8b37-3461ba5ba3a5	String	jsonType.label
9ab340ac-e659-48ac-b970-f1a2e0d06e13	true	userinfo.token.claim
9ab340ac-e659-48ac-b970-f1a2e0d06e13	zoneinfo	user.attribute
9ab340ac-e659-48ac-b970-f1a2e0d06e13	true	id.token.claim
9ab340ac-e659-48ac-b970-f1a2e0d06e13	true	access.token.claim
9ab340ac-e659-48ac-b970-f1a2e0d06e13	zoneinfo	claim.name
9ab340ac-e659-48ac-b970-f1a2e0d06e13	String	jsonType.label
a26db2f5-d43d-4413-ace1-3b55e464258b	true	userinfo.token.claim
a26db2f5-d43d-4413-ace1-3b55e464258b	middleName	user.attribute
a26db2f5-d43d-4413-ace1-3b55e464258b	true	id.token.claim
a26db2f5-d43d-4413-ace1-3b55e464258b	true	access.token.claim
a26db2f5-d43d-4413-ace1-3b55e464258b	middle_name	claim.name
a26db2f5-d43d-4413-ace1-3b55e464258b	String	jsonType.label
d31404f1-d56b-4b88-af6c-5b4225d82713	true	userinfo.token.claim
d31404f1-d56b-4b88-af6c-5b4225d82713	locale	user.attribute
d31404f1-d56b-4b88-af6c-5b4225d82713	true	id.token.claim
d31404f1-d56b-4b88-af6c-5b4225d82713	true	access.token.claim
d31404f1-d56b-4b88-af6c-5b4225d82713	locale	claim.name
d31404f1-d56b-4b88-af6c-5b4225d82713	String	jsonType.label
efe6105c-9d0c-4b45-9937-77a021063a2a	true	userinfo.token.claim
efe6105c-9d0c-4b45-9937-77a021063a2a	nickname	user.attribute
efe6105c-9d0c-4b45-9937-77a021063a2a	true	id.token.claim
efe6105c-9d0c-4b45-9937-77a021063a2a	true	access.token.claim
efe6105c-9d0c-4b45-9937-77a021063a2a	nickname	claim.name
efe6105c-9d0c-4b45-9937-77a021063a2a	String	jsonType.label
f24191e3-d903-4fda-9028-61d6014f06c9	true	userinfo.token.claim
f24191e3-d903-4fda-9028-61d6014f06c9	gender	user.attribute
f24191e3-d903-4fda-9028-61d6014f06c9	true	id.token.claim
f24191e3-d903-4fda-9028-61d6014f06c9	true	access.token.claim
f24191e3-d903-4fda-9028-61d6014f06c9	gender	claim.name
f24191e3-d903-4fda-9028-61d6014f06c9	String	jsonType.label
db869b1e-2167-4368-b5c0-dd134803f236	true	userinfo.token.claim
db869b1e-2167-4368-b5c0-dd134803f236	email	user.attribute
db869b1e-2167-4368-b5c0-dd134803f236	true	id.token.claim
db869b1e-2167-4368-b5c0-dd134803f236	true	access.token.claim
db869b1e-2167-4368-b5c0-dd134803f236	email	claim.name
db869b1e-2167-4368-b5c0-dd134803f236	String	jsonType.label
f0caa016-6b05-4bf9-ac50-2626a9b25694	true	userinfo.token.claim
f0caa016-6b05-4bf9-ac50-2626a9b25694	emailVerified	user.attribute
f0caa016-6b05-4bf9-ac50-2626a9b25694	true	id.token.claim
f0caa016-6b05-4bf9-ac50-2626a9b25694	true	access.token.claim
f0caa016-6b05-4bf9-ac50-2626a9b25694	email_verified	claim.name
f0caa016-6b05-4bf9-ac50-2626a9b25694	boolean	jsonType.label
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	formatted	user.attribute.formatted
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	country	user.attribute.country
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	postal_code	user.attribute.postal_code
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	true	userinfo.token.claim
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	street	user.attribute.street
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	true	id.token.claim
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	region	user.attribute.region
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	true	access.token.claim
6969d5bc-91e5-43d1-ac84-d86cc3f2bfa2	locality	user.attribute.locality
1efe27f7-a2a2-4177-931b-7a755f16b9ee	true	userinfo.token.claim
1efe27f7-a2a2-4177-931b-7a755f16b9ee	phoneNumberVerified	user.attribute
1efe27f7-a2a2-4177-931b-7a755f16b9ee	true	id.token.claim
1efe27f7-a2a2-4177-931b-7a755f16b9ee	true	access.token.claim
1efe27f7-a2a2-4177-931b-7a755f16b9ee	phone_number_verified	claim.name
1efe27f7-a2a2-4177-931b-7a755f16b9ee	boolean	jsonType.label
37aae94b-58a7-468a-8353-8782d8e612fe	true	userinfo.token.claim
37aae94b-58a7-468a-8353-8782d8e612fe	phoneNumber	user.attribute
37aae94b-58a7-468a-8353-8782d8e612fe	true	id.token.claim
37aae94b-58a7-468a-8353-8782d8e612fe	true	access.token.claim
37aae94b-58a7-468a-8353-8782d8e612fe	phone_number	claim.name
37aae94b-58a7-468a-8353-8782d8e612fe	String	jsonType.label
8ab5411a-48f8-475b-9e41-7d29f8b36613	true	multivalued
8ab5411a-48f8-475b-9e41-7d29f8b36613	foo	user.attribute
8ab5411a-48f8-475b-9e41-7d29f8b36613	true	access.token.claim
8ab5411a-48f8-475b-9e41-7d29f8b36613	resource_access.${client_id}.roles	claim.name
8ab5411a-48f8-475b-9e41-7d29f8b36613	String	jsonType.label
9fe9ada5-f362-46d7-acd9-0168619e6dff	true	multivalued
9fe9ada5-f362-46d7-acd9-0168619e6dff	foo	user.attribute
9fe9ada5-f362-46d7-acd9-0168619e6dff	true	access.token.claim
9fe9ada5-f362-46d7-acd9-0168619e6dff	realm_access.roles	claim.name
9fe9ada5-f362-46d7-acd9-0168619e6dff	String	jsonType.label
6dac18b2-050e-4de0-9fca-e5f76d851208	true	multivalued
6dac18b2-050e-4de0-9fca-e5f76d851208	foo	user.attribute
6dac18b2-050e-4de0-9fca-e5f76d851208	true	id.token.claim
6dac18b2-050e-4de0-9fca-e5f76d851208	true	access.token.claim
6dac18b2-050e-4de0-9fca-e5f76d851208	groups	claim.name
6dac18b2-050e-4de0-9fca-e5f76d851208	String	jsonType.label
827ad9a6-691c-42a8-a9a2-d4be82042ace	true	userinfo.token.claim
827ad9a6-691c-42a8-a9a2-d4be82042ace	username	user.attribute
827ad9a6-691c-42a8-a9a2-d4be82042ace	true	id.token.claim
827ad9a6-691c-42a8-a9a2-d4be82042ace	true	access.token.claim
827ad9a6-691c-42a8-a9a2-d4be82042ace	upn	claim.name
827ad9a6-691c-42a8-a9a2-d4be82042ace	String	jsonType.label
d8d6f7e2-8bbe-4a14-9291-00b00ebece13	true	id.token.claim
d8d6f7e2-8bbe-4a14-9291-00b00ebece13	true	access.token.claim
7834263a-7e68-49f5-8d79-bb2d496425d0	true	userinfo.token.claim
7834263a-7e68-49f5-8d79-bb2d496425d0	locale	user.attribute
7834263a-7e68-49f5-8d79-bb2d496425d0	true	id.token.claim
7834263a-7e68-49f5-8d79-bb2d496425d0	true	access.token.claim
7834263a-7e68-49f5-8d79-bb2d496425d0	locale	claim.name
7834263a-7e68-49f5-8d79-bb2d496425d0	String	jsonType.label
6cb535c7-4bdf-4f22-9d5c-8d16e0a659e5	ROLE_developer	new.role.name
6cb535c7-4bdf-4f22-9d5c-8d16e0a659e5	developer	role
4d7c2382-e9c2-48bb-bf45-3ef65e2731a6	clientHost	user.session.note
4d7c2382-e9c2-48bb-bf45-3ef65e2731a6	true	id.token.claim
4d7c2382-e9c2-48bb-bf45-3ef65e2731a6	true	access.token.claim
4d7c2382-e9c2-48bb-bf45-3ef65e2731a6	clientHost	claim.name
4d7c2382-e9c2-48bb-bf45-3ef65e2731a6	String	jsonType.label
a79bb444-e624-46f6-b106-f65e9a1496ea	clientId	user.session.note
a79bb444-e624-46f6-b106-f65e9a1496ea	true	id.token.claim
a79bb444-e624-46f6-b106-f65e9a1496ea	true	access.token.claim
a79bb444-e624-46f6-b106-f65e9a1496ea	clientId	claim.name
a79bb444-e624-46f6-b106-f65e9a1496ea	String	jsonType.label
d9688d09-d5a1-4680-b965-0dbf3b7dc117	clientAddress	user.session.note
d9688d09-d5a1-4680-b965-0dbf3b7dc117	true	id.token.claim
d9688d09-d5a1-4680-b965-0dbf3b7dc117	true	access.token.claim
d9688d09-d5a1-4680-b965-0dbf3b7dc117	clientAddress	claim.name
d9688d09-d5a1-4680-b965-0dbf3b7dc117	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
328a8777-dc28-41dd-931b-66af1660c31c	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	242805d5-7a12-4a07-8b69-c046f326d6fa	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	560df60e-1a9b-4a64-ad30-146026c9f58c	e4a1f86d-bd20-4687-bcda-22be338747d8	c8df21b1-3808-48da-9146-3546dee7972e	22d0d2a0-d8be-4600-9c9d-4807035e396f	c86dd04d-b0e4-4580-8f6c-5721bb86e5e3	2592000	f	900	t	f	e179bc12-099a-4d68-9f28-9df1a14a90f3	0	f	0	0	c0e8f3f2-c318-4146-835d-eba53fc89bb6
80229060-53a8-4a28-bfc4-ceebabe05d64	60	300	1740	\N	\N	\N	t	f	0	\N	JsExecutor	0	\N	t	f	f	f	NONE	1800	36000	f	f	f485b846-6289-40b6-a42c-287e95d8cd82	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	84f5c146-2eb2-412d-9d6d-a11cfb0bf83a	63349463-77be-4c6f-8623-0a6acd2bee8b	4aa604b3-d1a1-4866-bd38-072b8fd7cf46	4f93ebdb-cb14-474f-b8c0-0dc14a4442e4	81b8fde3-af19-48b9-8acd-672897f7ca5e	2592000	f	900	t	f	97b464f2-8f49-49b5-931b-cdbe4928af2e	0	f	0	0	9d8a0bfa-adbb-43ff-838e-01b3c15f334c
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	328a8777-dc28-41dd-931b-66af1660c31c	
_browser_header.xContentTypeOptions	328a8777-dc28-41dd-931b-66af1660c31c	nosniff
_browser_header.xRobotsTag	328a8777-dc28-41dd-931b-66af1660c31c	none
_browser_header.xFrameOptions	328a8777-dc28-41dd-931b-66af1660c31c	SAMEORIGIN
_browser_header.contentSecurityPolicy	328a8777-dc28-41dd-931b-66af1660c31c	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	328a8777-dc28-41dd-931b-66af1660c31c	1; mode=block
_browser_header.strictTransportSecurity	328a8777-dc28-41dd-931b-66af1660c31c	max-age=31536000; includeSubDomains
bruteForceProtected	328a8777-dc28-41dd-931b-66af1660c31c	false
permanentLockout	328a8777-dc28-41dd-931b-66af1660c31c	false
maxFailureWaitSeconds	328a8777-dc28-41dd-931b-66af1660c31c	900
minimumQuickLoginWaitSeconds	328a8777-dc28-41dd-931b-66af1660c31c	60
waitIncrementSeconds	328a8777-dc28-41dd-931b-66af1660c31c	60
quickLoginCheckMilliSeconds	328a8777-dc28-41dd-931b-66af1660c31c	1000
maxDeltaTimeSeconds	328a8777-dc28-41dd-931b-66af1660c31c	43200
failureFactor	328a8777-dc28-41dd-931b-66af1660c31c	30
displayName	328a8777-dc28-41dd-931b-66af1660c31c	Keycloak
displayNameHtml	328a8777-dc28-41dd-931b-66af1660c31c	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	328a8777-dc28-41dd-931b-66af1660c31c	RS256
offlineSessionMaxLifespanEnabled	328a8777-dc28-41dd-931b-66af1660c31c	false
offlineSessionMaxLifespan	328a8777-dc28-41dd-931b-66af1660c31c	5184000
actionTokenGeneratedByUserLifespan-verify-email	80229060-53a8-4a28-bfc4-ceebabe05d64	
actionTokenGeneratedByUserLifespan-idp-verify-account-via-email	80229060-53a8-4a28-bfc4-ceebabe05d64	
actionTokenGeneratedByUserLifespan-reset-credentials	80229060-53a8-4a28-bfc4-ceebabe05d64	
actionTokenGeneratedByUserLifespan-execute-actions	80229060-53a8-4a28-bfc4-ceebabe05d64	
displayName	80229060-53a8-4a28-bfc4-ceebabe05d64	
displayNameHtml	80229060-53a8-4a28-bfc4-ceebabe05d64	
bruteForceProtected	80229060-53a8-4a28-bfc4-ceebabe05d64	false
permanentLockout	80229060-53a8-4a28-bfc4-ceebabe05d64	false
maxFailureWaitSeconds	80229060-53a8-4a28-bfc4-ceebabe05d64	900
minimumQuickLoginWaitSeconds	80229060-53a8-4a28-bfc4-ceebabe05d64	60
waitIncrementSeconds	80229060-53a8-4a28-bfc4-ceebabe05d64	60
quickLoginCheckMilliSeconds	80229060-53a8-4a28-bfc4-ceebabe05d64	1000
maxDeltaTimeSeconds	80229060-53a8-4a28-bfc4-ceebabe05d64	43200
failureFactor	80229060-53a8-4a28-bfc4-ceebabe05d64	30
actionTokenGeneratedByAdminLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	43200
actionTokenGeneratedByUserLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	300
defaultSignatureAlgorithm	80229060-53a8-4a28-bfc4-ceebabe05d64	RS256
offlineSessionMaxLifespanEnabled	80229060-53a8-4a28-bfc4-ceebabe05d64	false
offlineSessionMaxLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	5184000
webAuthnPolicyRpEntityName	80229060-53a8-4a28-bfc4-ceebabe05d64	keycloak
oauth2DeviceCodeLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	600
oauth2DevicePollingInterval	80229060-53a8-4a28-bfc4-ceebabe05d64	5
webAuthnPolicySignatureAlgorithms	80229060-53a8-4a28-bfc4-ceebabe05d64	ES256
webAuthnPolicyRpId	80229060-53a8-4a28-bfc4-ceebabe05d64	
webAuthnPolicyAttestationConveyancePreference	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyAuthenticatorAttachment	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyRequireResidentKey	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyUserVerificationRequirement	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyCreateTimeout	80229060-53a8-4a28-bfc4-ceebabe05d64	0
webAuthnPolicyAvoidSameAuthenticatorRegister	80229060-53a8-4a28-bfc4-ceebabe05d64	false
webAuthnPolicyRpEntityNamePasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	ES256
webAuthnPolicyRpIdPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	
webAuthnPolicyAttestationConveyancePreferencePasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyRequireResidentKeyPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	not specified
webAuthnPolicyCreateTimeoutPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	80229060-53a8-4a28-bfc4-ceebabe05d64	false
client-policies.profiles	80229060-53a8-4a28-bfc4-ceebabe05d64	{"profiles":[]}
cibaBackchannelTokenDeliveryMode	80229060-53a8-4a28-bfc4-ceebabe05d64	poll
cibaExpiresIn	80229060-53a8-4a28-bfc4-ceebabe05d64	120
cibaInterval	80229060-53a8-4a28-bfc4-ceebabe05d64	5
cibaAuthRequestedUserHint	80229060-53a8-4a28-bfc4-ceebabe05d64	login_hint
parRequestUriLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	60
frontendUrl	80229060-53a8-4a28-bfc4-ceebabe05d64	
acr.loa.map	80229060-53a8-4a28-bfc4-ceebabe05d64	[]
client-policies.policies	80229060-53a8-4a28-bfc4-ceebabe05d64	{"policies":[]}
_browser_header.contentSecurityPolicyReportOnly	80229060-53a8-4a28-bfc4-ceebabe05d64	
_browser_header.xContentTypeOptions	80229060-53a8-4a28-bfc4-ceebabe05d64	nosniff
_browser_header.xRobotsTag	80229060-53a8-4a28-bfc4-ceebabe05d64	none
_browser_header.xFrameOptions	80229060-53a8-4a28-bfc4-ceebabe05d64	SAMEORIGIN
_browser_header.contentSecurityPolicy	80229060-53a8-4a28-bfc4-ceebabe05d64	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	80229060-53a8-4a28-bfc4-ceebabe05d64	1; mode=block
_browser_header.strictTransportSecurity	80229060-53a8-4a28-bfc4-ceebabe05d64	max-age=31536000; includeSubDomains
clientSessionIdleTimeout	80229060-53a8-4a28-bfc4-ceebabe05d64	0
clientSessionMaxLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	0
clientOfflineSessionIdleTimeout	80229060-53a8-4a28-bfc4-ceebabe05d64	0
clientOfflineSessionMaxLifespan	80229060-53a8-4a28-bfc4-ceebabe05d64	0
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
328a8777-dc28-41dd-931b-66af1660c31c	jboss-logging
80229060-53a8-4a28-bfc4-ceebabe05d64	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	328a8777-dc28-41dd-931b-66af1660c31c
password	password	t	t	80229060-53a8-4a28-bfc4-ceebabe05d64
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.redirect_uris (client_id, value) FROM stdin;
a9400c8f-8e34-4c9e-bb99-3f8368a7bc3e	/realms/master/account/*
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	/realms/master/account/*
1a9079ff-fb56-4e60-b231-96b51a96c044	/admin/master/console/*
ee3cb8e7-1f63-47c3-973c-2c7a1427095c	/realms/JsExecutor/account/*
132434ea-1786-4839-9d02-33a3b6354f90	/realms/JsExecutor/account/*
0466602c-8f11-4581-b7e4-d01932dd42df	/admin/JsExecutor/console/*
646226dc-1492-41e1-afcb-b398abd036bd	https://localhost:8080/swagger-ui/index.html
646226dc-1492-41e1-afcb-b398abd036bd	https://localhost:8080/swagger-ui/oauth2-redirect.html
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
53e33291-73ae-48e9-9f9c-699ab574be7a	VERIFY_EMAIL	Verify Email	328a8777-dc28-41dd-931b-66af1660c31c	t	f	VERIFY_EMAIL	50
13432870-f8fa-4be3-a5af-c35a902f27cb	UPDATE_PROFILE	Update Profile	328a8777-dc28-41dd-931b-66af1660c31c	t	f	UPDATE_PROFILE	40
5bcca02f-99ee-4798-8187-90372bae4cdf	CONFIGURE_TOTP	Configure OTP	328a8777-dc28-41dd-931b-66af1660c31c	t	f	CONFIGURE_TOTP	10
398c0af8-ec78-4b88-b63d-2640f8fe0cc4	UPDATE_PASSWORD	Update Password	328a8777-dc28-41dd-931b-66af1660c31c	t	f	UPDATE_PASSWORD	30
297778fc-9b57-482c-a4b6-8bd77b41b29e	terms_and_conditions	Terms and Conditions	328a8777-dc28-41dd-931b-66af1660c31c	f	f	terms_and_conditions	20
f1b61776-c935-4dad-a332-1de4be49d547	update_user_locale	Update User Locale	328a8777-dc28-41dd-931b-66af1660c31c	t	f	update_user_locale	1000
c39433f9-b7d0-4644-8af4-d26b56b2f3bd	delete_account	Delete Account	328a8777-dc28-41dd-931b-66af1660c31c	f	f	delete_account	60
5ffdb0c6-5ba1-4d1a-8f4b-b4334cd579a3	webauthn-register	Webauthn Register	328a8777-dc28-41dd-931b-66af1660c31c	t	f	webauthn-register	70
2c52ca76-522b-4a4e-b935-f9055a173736	webauthn-register-passwordless	Webauthn Register Passwordless	328a8777-dc28-41dd-931b-66af1660c31c	t	f	webauthn-register-passwordless	80
2bbd37ea-d24d-4043-a629-c08d6329e3f2	VERIFY_EMAIL	Verify Email	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	VERIFY_EMAIL	50
24c1e86b-8150-4b6c-ab9a-abc794b95e06	UPDATE_PROFILE	Update Profile	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	UPDATE_PROFILE	40
209144bf-b394-4a75-8e61-aa0125b3dc40	CONFIGURE_TOTP	Configure OTP	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	CONFIGURE_TOTP	10
68b3afc1-63d6-443f-9753-2857280566ac	UPDATE_PASSWORD	Update Password	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	UPDATE_PASSWORD	30
aafc924b-796b-44d5-a07e-21cdabe7ee33	terms_and_conditions	Terms and Conditions	80229060-53a8-4a28-bfc4-ceebabe05d64	f	f	terms_and_conditions	20
99e439e5-1a2b-49fb-99d6-679b31b0908f	update_user_locale	Update User Locale	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	update_user_locale	1000
b06024b9-802a-4eee-b664-f62bbfcf2b09	delete_account	Delete Account	80229060-53a8-4a28-bfc4-ceebabe05d64	f	f	delete_account	60
39ceca3f-6fe6-4b19-89e1-5290d7a0e195	webauthn-register	Webauthn Register	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	webauthn-register	70
41c759e6-eb3c-4354-8b47-858a18d205d2	webauthn-register-passwordless	Webauthn Register Passwordless	80229060-53a8-4a28-bfc4-ceebabe05d64	t	f	webauthn-register-passwordless	80
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	6c9e94c2-0686-4083-817a-0f50e4d583f1
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	19283882-f264-42a6-ad36-38d7b2e55f92
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	6c736ff1-8566-4b81-9cbb-2164255e15ff
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	143d249e-a1e1-4e9b-91a4-63f2df833342
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	084be5cd-636d-49f5-abb4-f6fefef54f7c
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	ca275cb7-ea83-404a-b272-752d196da0ba
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
559dfb53-c90c-4d4b-ba77-7235c4341189	f	0	1
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
6c9e94c2-0686-4083-817a-0f50e4d583f1	map-role.permission.aad89f55-21f9-4284-82b5-6dfd3e0b5bfd	\N	scope	0	0	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
19283882-f264-42a6-ad36-38d7b2e55f92	map-role-client-scope.permission.aad89f55-21f9-4284-82b5-6dfd3e0b5bfd	\N	scope	0	0	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
6c736ff1-8566-4b81-9cbb-2164255e15ff	map-role-composite.permission.aad89f55-21f9-4284-82b5-6dfd3e0b5bfd	\N	scope	0	0	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
e57913d5-3b5a-446f-9dcc-7e6e02c71ee6	role.resource.aad89f55-21f9-4284-82b5-6dfd3e0b5bfd	Role	\N	559dfb53-c90c-4d4b-ba77-7235c4341189	559dfb53-c90c-4d4b-ba77-7235c4341189	f	\N
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
143d249e-a1e1-4e9b-91a4-63f2df833342	map-role	\N	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
084be5cd-636d-49f5-abb4-f6fefef54f7c	map-role-client-scope	\N	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
ca275cb7-ea83-404a-b272-752d196da0ba	map-role-composite	\N	559dfb53-c90c-4d4b-ba77-7235c4341189	\N
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
40967c14-8a80-47b6-871e-e2cce9a9df43	5a9a8bac-c79f-4f93-b170-06e42885f9e4	app_role	user
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
3e8f4bf7-63a8-4d07-86e9-2ab030f2634c	02ff9384-da1c-4857-8ce9-306784a39c74
132434ea-1786-4839-9d02-33a3b6354f90	2df25649-b570-430e-b145-78ba9d7e4431
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
143d249e-a1e1-4e9b-91a4-63f2df833342	6c9e94c2-0686-4083-817a-0f50e4d583f1
084be5cd-636d-49f5-abb4-f6fefef54f7c	19283882-f264-42a6-ad36-38d7b2e55f92
ca275cb7-ea83-404a-b272-752d196da0ba	6c736ff1-8566-4b81-9cbb-2164255e15ff
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
45a3abe7-4853-44f0-bbe5-c5dd013af39c	\N	b066081e-4753-4240-89d2-bf3157004296	f	t	\N	\N	\N	328a8777-dc28-41dd-931b-66af1660c31c	admin	1660561016706	\N	0
d5ea372b-b383-4a42-a7d3-9785cce62c5f	\N	6c6e35a9-0827-4300-b486-4ddb98ede118	f	t	\N			80229060-53a8-4a28-bfc4-ceebabe05d64	app_admin	1661542283324	\N	0
77857d0d-eb2f-4037-bb1e-38ff2f91d05a	\N	854fc2bf-bad7-4cec-9eb3-b6c34433c70c	f	t	\N			80229060-53a8-4a28-bfc4-ceebabe05d64	test	1661761869961	\N	0
8a75967b-d19c-48e1-9992-8abb57cee314	test_reg@abc.com	test_reg@abc.com	f	t	\N	Test_reg	Test_reg	80229060-53a8-4a28-bfc4-ceebabe05d64	test_reg	1661762543218	\N	0
57f4e9b7-73f4-462a-818e-3361404ee4d6	\N	b2c7881d-9de4-40ee-b464-ef9f0422aeb4	f	t	\N	\N	\N	80229060-53a8-4a28-bfc4-ceebabe05d64	service-account-swagger-ui-local	1661764641873	646226dc-1492-41e1-afcb-b398abd036bd	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
c0e8f3f2-c318-4146-835d-eba53fc89bb6	45a3abe7-4853-44f0-bbe5-c5dd013af39c
d75823db-40d7-40f1-960a-679d4df2df1c	45a3abe7-4853-44f0-bbe5-c5dd013af39c
6b0201e9-8ca6-43d4-aed3-1178f4d664c8	45a3abe7-4853-44f0-bbe5-c5dd013af39c
b74aa35d-767e-4de6-bee5-6c837864bd20	45a3abe7-4853-44f0-bbe5-c5dd013af39c
a93644b3-4886-4586-bbd0-1b501f74b010	45a3abe7-4853-44f0-bbe5-c5dd013af39c
c0a95eeb-fa99-4776-9908-186dcfdcbcc7	45a3abe7-4853-44f0-bbe5-c5dd013af39c
8fd58a3c-707b-4170-a740-8a7861955c56	45a3abe7-4853-44f0-bbe5-c5dd013af39c
56e119eb-3394-466f-a722-a0fb19465cd6	45a3abe7-4853-44f0-bbe5-c5dd013af39c
6c69bcd1-a264-4ac5-a362-b86e76ad95d3	45a3abe7-4853-44f0-bbe5-c5dd013af39c
53edf4b9-1bfe-4ae0-9b65-b395b1ceb839	45a3abe7-4853-44f0-bbe5-c5dd013af39c
e0b406e4-3cca-4eeb-adec-7ddb937fd887	45a3abe7-4853-44f0-bbe5-c5dd013af39c
d2defefd-0e06-4687-a714-b11612381a6a	45a3abe7-4853-44f0-bbe5-c5dd013af39c
d8ebd68e-1707-470d-878c-3b8837e1ff0d	45a3abe7-4853-44f0-bbe5-c5dd013af39c
44f6ec0d-984a-45fe-8845-54fafb6d7f7b	45a3abe7-4853-44f0-bbe5-c5dd013af39c
314d9e79-b3af-4ecf-9867-70c7caa8782d	45a3abe7-4853-44f0-bbe5-c5dd013af39c
f15fa265-e476-4d8b-93f9-b3bae951690c	45a3abe7-4853-44f0-bbe5-c5dd013af39c
283df9f6-4aa6-4cb9-ba9d-cfc518201536	45a3abe7-4853-44f0-bbe5-c5dd013af39c
9d0e77f7-6c44-44f0-98bd-859ea9163701	45a3abe7-4853-44f0-bbe5-c5dd013af39c
0b3ee2ad-90cb-4f61-8eb7-7c5419095aa3	45a3abe7-4853-44f0-bbe5-c5dd013af39c
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	d5ea372b-b383-4a42-a7d3-9785cce62c5f
aad89f55-21f9-4284-82b5-6dfd3e0b5bfd	d5ea372b-b383-4a42-a7d3-9785cce62c5f
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	77857d0d-eb2f-4037-bb1e-38ff2f91d05a
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	8a75967b-d19c-48e1-9992-8abb57cee314
9d8a0bfa-adbb-43ff-838e-01b3c15f334c	57f4e9b7-73f4-462a-818e-3361404ee4d6
297db9d7-eaac-40d4-8f34-ac31506259c3	57f4e9b7-73f4-462a-818e-3361404ee4d6
5a9a8bac-c79f-4f93-b170-06e42885f9e4	77857d0d-eb2f-4037-bb1e-38ff2f91d05a
a4068e6e-8f49-47b0-aa74-d261b33be10a	d5ea372b-b383-4a42-a7d3-9785cce62c5f
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: kc_db_admin
--

COPY public.web_origins (client_id, value) FROM stdin;
1a9079ff-fb56-4e60-b231-96b51a96c044	+
0466602c-8f11-4581-b7e4-d01932dd42df	+
646226dc-1492-41e1-afcb-b398abd036bd	https://localhost:8080
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: kc_db_admin
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: kc_db_admin
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

