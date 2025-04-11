--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.12 (Homebrew)

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

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	66881872-3418-4596-b875-d372be74fdf5	{"action":"user_signedup","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 03:50:15.054383+00	
00000000-0000-0000-0000-000000000000	33369836-ae1d-4fd7-9617-55e988266bed	{"action":"login","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 03:50:15.064813+00	
00000000-0000-0000-0000-000000000000	b88a7ca0-9017-4823-9c1d-770067f45b12	{"action":"logout","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 03:55:56.203657+00	
00000000-0000-0000-0000-000000000000	70e97b48-f8fd-4024-8043-fba306fe1bfc	{"action":"login","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 03:56:26.90368+00	
00000000-0000-0000-0000-000000000000	7f2a9d06-f576-4719-9252-f8ae8de1cf71	{"action":"logout","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 04:07:31.558893+00	
00000000-0000-0000-0000-000000000000	2295554d-8536-4055-9749-138df17ccb15	{"action":"login","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:08:00.116916+00	
00000000-0000-0000-0000-000000000000	2903b09b-f179-44bd-b15a-f63a2d20d592	{"action":"logout","actor_id":"0389831a-959d-46bf-bc63-8910060ce10c","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 04:08:31.779276+00	
00000000-0000-0000-0000-000000000000	c9730ddc-e995-42ff-9a1a-47e2c612b819	{"action":"user_signedup","actor_id":"3a6b889d-3160-4887-b133-c39a7cef4859","actor_username":"test@test.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 04:15:57.267738+00	
00000000-0000-0000-0000-000000000000	8529886b-69bd-4ce5-80e3-4b0318c2a315	{"action":"login","actor_id":"3a6b889d-3160-4887-b133-c39a7cef4859","actor_username":"test@test.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:15:57.272005+00	
00000000-0000-0000-0000-000000000000	d6fcd534-5b04-4e2c-b115-20dcde312177	{"action":"logout","actor_id":"3a6b889d-3160-4887-b133-c39a7cef4859","actor_username":"test@test.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 04:16:11.23032+00	
00000000-0000-0000-0000-000000000000	8f7d5dfa-6d20-4cd6-a29d-109f719e3a8f	{"action":"user_signedup","actor_id":"9f73c994-395c-49b9-96a0-fd6f7471bd39","actor_username":"none1@none1.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 04:21:13.454134+00	
00000000-0000-0000-0000-000000000000	57065cbd-0c3a-4f9c-9812-711d76004f63	{"action":"login","actor_id":"9f73c994-395c-49b9-96a0-fd6f7471bd39","actor_username":"none1@none1.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:21:13.458634+00	
00000000-0000-0000-0000-000000000000	4b0a27a1-db4e-476c-89bc-aed5f777de57	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"test@test.com","user_id":"3a6b889d-3160-4887-b133-c39a7cef4859","user_phone":""}}	2025-02-26 04:27:36.376778+00	
00000000-0000-0000-0000-000000000000	742ed0b2-32dc-4419-8fb9-56a768ff3b7c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"none@none.com","user_id":"0389831a-959d-46bf-bc63-8910060ce10c","user_phone":""}}	2025-02-26 04:27:36.388654+00	
00000000-0000-0000-0000-000000000000	ad223517-76a6-43a9-939e-99cbfaa07914	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"none1@none1.com","user_id":"9f73c994-395c-49b9-96a0-fd6f7471bd39","user_phone":""}}	2025-02-26 04:27:36.389414+00	
00000000-0000-0000-0000-000000000000	8d36dfda-c894-420c-9984-c02939bff6fa	{"action":"user_signedup","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-26 04:28:22.625551+00	
00000000-0000-0000-0000-000000000000	cf0c5a76-b073-42b8-a269-4db91804d73d	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 04:28:22.628758+00	
00000000-0000-0000-0000-000000000000	8f6de197-d4ba-4de2-84d7-6300c75856c4	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 20:03:44.341769+00	
00000000-0000-0000-0000-000000000000	8f0b7483-143c-4ce4-850c-62df7c49aa45	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 20:03:44.351162+00	
00000000-0000-0000-0000-000000000000	ca99103f-26c3-4a88-8ba6-7950cf22312a	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 20:33:15.485994+00	
00000000-0000-0000-0000-000000000000	b9c04c95-6d1c-4b91-bdc9-c31c3894e949	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 20:51:16.138477+00	
00000000-0000-0000-0000-000000000000	4399dc33-cf89-4bc7-93d7-22f624acb6ea	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-26 20:57:59.829465+00	
00000000-0000-0000-0000-000000000000	6750286b-8e8c-4067-b992-f424e83c4f0d	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 20:59:26.167054+00	
00000000-0000-0000-0000-000000000000	d140c967-181c-4cfe-ad7f-13507c5ee384	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 21:57:56.245716+00	
00000000-0000-0000-0000-000000000000	ce182510-9f71-4714-b87d-483a1c738175	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 21:57:56.248+00	
00000000-0000-0000-0000-000000000000	5a0c6812-140b-40ce-a4fc-592668f2687f	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 22:56:24.077481+00	
00000000-0000-0000-0000-000000000000	70feb18d-e47b-47ea-9863-689d09af366b	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 22:56:24.07842+00	
00000000-0000-0000-0000-000000000000	9341a581-6ad5-459e-8e1c-d43866e00d20	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 23:54:36.868777+00	
00000000-0000-0000-0000-000000000000	6945752b-7fc2-4d24-9bab-a6807053f77f	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 23:54:36.871329+00	
00000000-0000-0000-0000-000000000000	015808e7-8a1a-4744-8329-b01d18b15dcb	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 00:52:42.169541+00	
00000000-0000-0000-0000-000000000000	d4237323-d9bf-4b01-83e6-2e0350d4e4e9	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 00:52:42.171553+00	
00000000-0000-0000-0000-000000000000	acb9110a-90b6-4db6-982e-1bee71ac1b84	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 01:50:48.295378+00	
00000000-0000-0000-0000-000000000000	07c8a50a-533b-4cb0-8ba1-4abff123c766	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 01:50:48.296259+00	
00000000-0000-0000-0000-000000000000	418334f0-4265-4f1c-80ce-5c881fac2890	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 02:49:01.208148+00	
00000000-0000-0000-0000-000000000000	e665ae6f-d48b-4412-bd1d-62d98c5ba4db	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 02:49:01.208944+00	
00000000-0000-0000-0000-000000000000	20f0cd25-22a0-47b8-abde-e9690d4875aa	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 03:48:49.205383+00	
00000000-0000-0000-0000-000000000000	269a78bf-1cc8-4d9e-8516-2b43782642ec	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 03:48:49.206824+00	
00000000-0000-0000-0000-000000000000	7fce4d96-f257-499e-b2f2-18f1ab4021b8	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-27 04:22:49.537404+00	
00000000-0000-0000-0000-000000000000	75fcc4b6-4319-4af3-b4ef-ea5ed7e7dd17	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 04:51:57.412848+00	
00000000-0000-0000-0000-000000000000	402b8ef6-1124-46c3-b149-9199a918fd1c	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 13:20:42.124878+00	
00000000-0000-0000-0000-000000000000	440204d1-551f-4b82-a8a6-48ec0bd487e4	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-27 13:21:50.123627+00	
00000000-0000-0000-0000-000000000000	d6dadf72-2b18-4275-b436-a1e505a6c3f9	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 17:27:35.974524+00	
00000000-0000-0000-0000-000000000000	08d0906b-e19b-492e-b2f6-b700d2a2d1ee	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-02-27 17:28:09.009653+00	
00000000-0000-0000-0000-000000000000	f3d55199-db10-4710-9383-ec5a32528768	{"action":"user_signedup","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-27 17:48:46.116249+00	
00000000-0000-0000-0000-000000000000	fa0866a0-89dc-4955-b244-8fae724a573a	{"action":"login","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 17:48:46.122059+00	
00000000-0000-0000-0000-000000000000	bc661d2f-102c-4966-b2c7-eec464ce80df	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 18:57:40.175453+00	
00000000-0000-0000-0000-000000000000	487f128a-a50d-4cc0-a3e6-8bc862793972	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 19:55:44.696865+00	
00000000-0000-0000-0000-000000000000	858fffe0-7792-4960-ad43-685d08a2cef3	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 19:55:44.699817+00	
00000000-0000-0000-0000-000000000000	2ee1aeb6-f079-4d58-8d07-afb9c3049f99	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 20:53:47.952778+00	
00000000-0000-0000-0000-000000000000	bfd49678-9dac-4a40-82de-bb26c997de70	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 20:53:47.955421+00	
00000000-0000-0000-0000-000000000000	7140638a-0078-47b7-b268-935452864176	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 21:51:52.017274+00	
00000000-0000-0000-0000-000000000000	278f46e1-a47b-4e33-ab24-bbeb8d594301	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 21:51:52.019873+00	
00000000-0000-0000-0000-000000000000	e3b19a16-c2bf-45bc-b9aa-3ec58407c897	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 22:50:33.273268+00	
00000000-0000-0000-0000-000000000000	b7e55ae9-8140-4bfa-8a9c-da4eea9b7ac9	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 22:50:33.274707+00	
00000000-0000-0000-0000-000000000000	97347e31-ac2d-4466-9614-2624697c2b32	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 23:48:51.709942+00	
00000000-0000-0000-0000-000000000000	a9c03b51-0368-45d1-9d03-e47037a4fc8d	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 23:48:51.711322+00	
00000000-0000-0000-0000-000000000000	50a1954f-b23c-4012-b4cd-6a49fcf30d68	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 00:46:58.493295+00	
00000000-0000-0000-0000-000000000000	e73005ca-9301-4fbc-904c-05c5572f875b	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 00:46:58.494777+00	
00000000-0000-0000-0000-000000000000	d0c63595-4864-49e5-9187-552ff380eb88	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:45:23.733034+00	
00000000-0000-0000-0000-000000000000	3b3dbbe1-e6fc-4804-80a8-799db0e59616	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:45:23.733922+00	
00000000-0000-0000-0000-000000000000	08765907-8967-43ff-8301-a2c1eb1b51f8	{"action":"token_refreshed","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:46:32.239292+00	
00000000-0000-0000-0000-000000000000	8ccb9944-3533-458f-9f68-d2a2277d14dc	{"action":"token_revoked","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:46:32.24013+00	
00000000-0000-0000-0000-000000000000	8836eb3a-87e9-435c-82b9-5d1153bb600b	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 02:43:51.671864+00	
00000000-0000-0000-0000-000000000000	8123a7ec-9140-48d3-87a9-e0ae1a59597a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 02:43:51.673872+00	
00000000-0000-0000-0000-000000000000	b6fa0945-e4ef-41b7-9bbd-80db95461eaa	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 03:42:00.206399+00	
00000000-0000-0000-0000-000000000000	6f9b6eec-2a4c-4aa9-8482-e46ccb017769	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 03:42:00.209068+00	
00000000-0000-0000-0000-000000000000	8007a1e2-6522-4450-b00e-853503440e47	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 04:40:19.829086+00	
00000000-0000-0000-0000-000000000000	6e01375f-8e76-4a64-a1a0-f1656ca7b46a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 04:40:19.831711+00	
00000000-0000-0000-0000-000000000000	0dd3fb5b-b93b-4b76-ab78-ec84d0194011	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 05:41:27.162786+00	
00000000-0000-0000-0000-000000000000	caa4dfee-9533-47a5-b457-c256daced912	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 05:41:27.16376+00	
00000000-0000-0000-0000-000000000000	34dcde8f-5b07-4599-ad87-6aec547f0b0d	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 07:05:58.104282+00	
00000000-0000-0000-0000-000000000000	0e848047-0c68-4646-9dfd-ece729e0c7f2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 07:05:58.12173+00	
00000000-0000-0000-0000-000000000000	ab166d24-11c0-4dc9-8496-a519bbec5948	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 10:01:37.689715+00	
00000000-0000-0000-0000-000000000000	18871dfe-6ee0-4d5e-8ef5-9323f857e6a6	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 10:01:37.691803+00	
00000000-0000-0000-0000-000000000000	c4c96b0f-08ec-4d5d-ba40-8bf1f0a8d7d8	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 11:57:50.203103+00	
00000000-0000-0000-0000-000000000000	69430e2b-c408-4063-a7ca-d22b8d164987	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 11:57:50.204062+00	
00000000-0000-0000-0000-000000000000	70c34021-28fe-4f4c-87e6-c58d84381f66	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 13:03:35.507456+00	
00000000-0000-0000-0000-000000000000	fc73b9ae-2561-4f4a-bfc1-2cb9735ff371	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 13:03:35.508344+00	
00000000-0000-0000-0000-000000000000	00b3423d-27ca-4271-a64c-d906afb29110	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 14:52:47.667896+00	
00000000-0000-0000-0000-000000000000	40295f01-ad5e-4ec4-9f0c-47c58dcd1be2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 14:52:47.676332+00	
00000000-0000-0000-0000-000000000000	fdc8261f-7d4c-47f7-b682-545fcc535d63	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:01:07.088804+00	
00000000-0000-0000-0000-000000000000	26de1ed8-2e1f-4635-a1d5-79c8845fb9fe	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:01:07.090281+00	
00000000-0000-0000-0000-000000000000	c54bee62-3bcb-4797-8108-bda1a454f0be	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:59:13.434958+00	
00000000-0000-0000-0000-000000000000	a7a322a1-0a6c-4599-a774-201d7c0c0d39	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 16:59:13.436526+00	
00000000-0000-0000-0000-000000000000	3fec69ca-85ca-43e0-9430-8f18cf0d4fc4	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 17:13:34.49523+00	
00000000-0000-0000-0000-000000000000	7141a4f1-e8c4-49b2-93a0-a1a584c9eaa1	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 17:13:34.507754+00	
00000000-0000-0000-0000-000000000000	4f15da09-5dc4-46db-a0a7-7f123b4f615b	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-03 17:48:21.207273+00	
00000000-0000-0000-0000-000000000000	9a82e0a1-a79f-438a-ba32-7b3c0ad9d970	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 17:48:22.638964+00	
00000000-0000-0000-0000-000000000000	2fb69fd1-5190-4d90-9645-a8a1427eef79	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 18:46:46.185754+00	
00000000-0000-0000-0000-000000000000	0dc58c68-4117-46cc-83f5-0c6e4255ca69	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 18:46:46.187828+00	
00000000-0000-0000-0000-000000000000	8b2499bc-ae34-418b-85dd-2f575735fc56	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 19:14:04.798068+00	
00000000-0000-0000-0000-000000000000	ba5dea8d-cc96-4307-abef-3946752de766	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 19:45:08.126234+00	
00000000-0000-0000-0000-000000000000	66d1bf5d-ee73-4ef7-8c70-abc5bafda9bd	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 19:45:08.128341+00	
00000000-0000-0000-0000-000000000000	7fb137d6-d386-4aef-a467-3ca088ce1860	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:12:18.082392+00	
00000000-0000-0000-0000-000000000000	bf5bd79f-c314-4c58-bfbe-b5c249bca136	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:12:18.084626+00	
00000000-0000-0000-0000-000000000000	38dedb99-1e91-406d-a733-7156b1a3bbcc	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:43:40.823863+00	
00000000-0000-0000-0000-000000000000	a5d57cba-6d7c-4425-bb3d-ed9f1aa66980	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 20:43:40.826807+00	
00000000-0000-0000-0000-000000000000	b4de527f-430e-4ed4-a4a4-5abca2de9c13	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:10:56.431339+00	
00000000-0000-0000-0000-000000000000	7fd316b5-d84b-4a06-b76a-3839a5260f4a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:10:56.433495+00	
00000000-0000-0000-0000-000000000000	17c69881-7a3e-4ece-9bb3-34177c2aeb7d	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:41:54.986075+00	
00000000-0000-0000-0000-000000000000	044b2393-8255-4525-a1b9-5bd42bf1d063	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 21:41:54.988917+00	
00000000-0000-0000-0000-000000000000	072dd65c-7b7b-4cdf-bc19-71ad077b7bca	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:09:15.890197+00	
00000000-0000-0000-0000-000000000000	cc8958c3-2766-4ed0-a324-f9ab0a50dc9a	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:09:15.89348+00	
00000000-0000-0000-0000-000000000000	9374f892-c30d-4516-b553-28d9b31848bd	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:40:02.496562+00	
00000000-0000-0000-0000-000000000000	9573e9b6-9310-4396-9059-a2360c0cb493	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-03 22:40:02.499202+00	
00000000-0000-0000-0000-000000000000	8b22a67c-5b8e-4f1d-a5dd-25f2f9b95694	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-03 23:02:54.266271+00	
00000000-0000-0000-0000-000000000000	ded3a3b2-0c22-4c84-bfa2-fdd872d2bff9	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 23:02:55.943543+00	
00000000-0000-0000-0000-000000000000	bc58acbb-db3d-4d0b-bb79-658d72937ad6	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-03 23:04:34.125315+00	
00000000-0000-0000-0000-000000000000	1d581882-9f69-40f2-aac6-1d3ddcf1722a	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:01:04.349298+00	
00000000-0000-0000-0000-000000000000	9f9e5373-2769-4c67-8680-79dee1915d40	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:01:04.351391+00	
00000000-0000-0000-0000-000000000000	b6547450-c83e-4620-b42b-2a7b3526702c	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:02:34.293493+00	
00000000-0000-0000-0000-000000000000	c171435f-edb3-49d9-a7cf-459a900151a7	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:02:34.294358+00	
00000000-0000-0000-0000-000000000000	b267bb43-b484-4c8f-8bd2-ef54028765f2	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:59:24.843274+00	
00000000-0000-0000-0000-000000000000	daf02d31-815a-4f19-a7e3-dcc3032715e2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 00:59:24.846356+00	
00000000-0000-0000-0000-000000000000	e91afc17-d2fc-482f-9249-f6b7da2665cc	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:00:42.329117+00	
00000000-0000-0000-0000-000000000000	84f74e62-f5d2-470a-8d2f-69ceca198337	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:00:42.330081+00	
00000000-0000-0000-0000-000000000000	2706aa18-63b7-4d84-b00b-03f466990954	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:58:20.020252+00	
00000000-0000-0000-0000-000000000000	06004f75-9381-4940-8a7f-19818844e333	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:58:20.023829+00	
00000000-0000-0000-0000-000000000000	357780f8-1269-4126-8858-7e2e6ae08158	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:59:45.87792+00	
00000000-0000-0000-0000-000000000000	0bd08b3d-6d80-49f2-badf-9e29bbb5dc8d	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 01:59:45.878762+00	
00000000-0000-0000-0000-000000000000	63014b4e-26fa-4fe5-8a98-989a2212d46e	{"action":"token_refreshed","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 02:40:25.583443+00	
00000000-0000-0000-0000-000000000000	c9ccd8a7-a447-476f-a471-646e69a39c9b	{"action":"token_revoked","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 02:40:25.586156+00	
00000000-0000-0000-0000-000000000000	24ee0113-cf6e-4f13-a1f1-60faa1415a0a	{"action":"logout","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 02:42:52.599058+00	
00000000-0000-0000-0000-000000000000	4c6ca3ea-e76b-47bf-b139-83bd8455c981	{"action":"user_recovery_requested","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"user"}	2025-03-04 02:43:16.358924+00	
00000000-0000-0000-0000-000000000000	e1b754be-60a0-4b5e-bb35-a6c4a8e1b3ab	{"action":"login","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 02:43:35.835073+00	
00000000-0000-0000-0000-000000000000	a2d3bebe-2a2d-4d6e-a98a-db1c23c551c2	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 03:33:34.820104+00	
00000000-0000-0000-0000-000000000000	681dd504-d25c-4bdc-8e2e-57f37ad9454b	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 03:33:34.821002+00	
00000000-0000-0000-0000-000000000000	5edf6159-564d-4edb-b2f3-79bf228a369c	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 04:30:08.723869+00	
00000000-0000-0000-0000-000000000000	26b1b838-77e2-4f3a-9938-c842eefbb8a1	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-04 04:30:28.584694+00	
00000000-0000-0000-0000-000000000000	0ccd45af-4247-4edd-bcce-991e737e83d0	{"action":"logout","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 04:41:53.114894+00	
00000000-0000-0000-0000-000000000000	bd5cadb0-3e3d-4d31-8e87-930ed7c9abf0	{"action":"login","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-04 04:41:54.396276+00	
00000000-0000-0000-0000-000000000000	5a233e48-18d0-45e0-ab43-8b7669055430	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 05:39:58.587683+00	
00000000-0000-0000-0000-000000000000	d10599e7-0406-4953-ba54-980b15e66f48	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 05:39:58.593773+00	
00000000-0000-0000-0000-000000000000	2ee1ffb9-74d5-4739-9d14-1e9e56151df0	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 06:38:13.252626+00	
00000000-0000-0000-0000-000000000000	d848ecb5-6d69-4773-8d31-d4521aca834f	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 06:38:13.269882+00	
00000000-0000-0000-0000-000000000000	834631f4-2d5b-462e-b1d3-313534b90f3e	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 07:50:35.508124+00	
00000000-0000-0000-0000-000000000000	f4b36064-8f7e-4cf9-aa37-cdf6552ead5e	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 07:50:35.508945+00	
00000000-0000-0000-0000-000000000000	8fe5b88b-1b71-4759-8bd1-82d8db959919	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 09:36:22.82058+00	
00000000-0000-0000-0000-000000000000	3d66edfb-1c80-4e16-bb2a-83c1cadfafbb	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 09:36:22.822666+00	
00000000-0000-0000-0000-000000000000	1f71f77a-9026-47b7-9c27-13135016b3ab	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 11:14:15.438599+00	
00000000-0000-0000-0000-000000000000	2572d105-66c7-4c5c-a0d0-3602808b7922	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 11:14:15.445041+00	
00000000-0000-0000-0000-000000000000	bbd40a22-be9f-475a-b34f-174d65fba671	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 12:37:26.879537+00	
00000000-0000-0000-0000-000000000000	a32225b5-86ed-4114-a292-b8307973b9b2	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 12:37:26.881185+00	
00000000-0000-0000-0000-000000000000	e04cc2bd-faa5-49f8-8a58-308a767aec57	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 13:43:56.496217+00	
00000000-0000-0000-0000-000000000000	37e2c8cc-e364-4ca9-b591-6c2a1660c0be	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 13:43:56.498208+00	
00000000-0000-0000-0000-000000000000	98d362f8-9e77-4174-9b3c-376fcdd737c9	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 14:43:06.579955+00	
00000000-0000-0000-0000-000000000000	2209860b-f995-4c33-bc47-34f1c4fc4c5d	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 14:43:06.582684+00	
00000000-0000-0000-0000-000000000000	698d25cc-a5f0-490a-b28a-6e5c50c667ce	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:42:06.630959+00	
00000000-0000-0000-0000-000000000000	ff6f5843-b973-4f42-aa07-a0cc03952dbc	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:42:06.633303+00	
00000000-0000-0000-0000-000000000000	41c8c935-06d5-4422-8e7b-339b3c50237d	{"action":"token_refreshed","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:55:21.273477+00	
00000000-0000-0000-0000-000000000000	47b8b304-f53e-4870-a54e-147ee3b2c9eb	{"action":"token_revoked","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 15:55:21.27502+00	
00000000-0000-0000-0000-000000000000	f3e058c1-fda8-4b6d-b061-c681bc26f7b4	{"action":"logout","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account"}	2025-03-04 16:00:31.469124+00	
00000000-0000-0000-0000-000000000000	363883ae-65b0-43db-8bb3-16069eaa2031	{"action":"login","actor_id":"8935db97-9a3d-4058-9589-6e0f9b01ee84","actor_username":"grant@gravicdesign.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-04 16:01:05.250434+00	
00000000-0000-0000-0000-000000000000	9e6a2b87-e020-4ac2-a578-aca9e3dcc65a	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 16:40:47.745788+00	
00000000-0000-0000-0000-000000000000	ed72f7bd-ab65-4359-a5ae-7e26cdfcecc9	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 16:40:47.749052+00	
00000000-0000-0000-0000-000000000000	b2b5bc3f-cd5d-4594-bac3-59d379869a2a	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 17:39:23.651855+00	
00000000-0000-0000-0000-000000000000	6b32fd2b-0694-4ea7-9f21-3f9fbe65f612	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 17:39:23.654428+00	
00000000-0000-0000-0000-000000000000	e62fdbca-d1d9-4791-9a57-55dbf39d8b9f	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 23:01:52.280091+00	
00000000-0000-0000-0000-000000000000	45f3dadb-f242-47d3-ae31-bd58eb169a2f	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-04 23:01:52.288304+00	
00000000-0000-0000-0000-000000000000	63a85ac8-6718-4a3c-82ec-99dc2adf882c	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:00:27.241918+00	
00000000-0000-0000-0000-000000000000	30188980-c9e1-4167-aeca-706fca6b03ca	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:00:27.244891+00	
00000000-0000-0000-0000-000000000000	79021f78-d60a-48a7-80ab-8b6cc6982f61	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:59:27.152267+00	
00000000-0000-0000-0000-000000000000	f50799b0-bbb1-4147-a453-463ab7f43718	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-03-05 00:59:27.154849+00	
00000000-0000-0000-0000-000000000000	613a7f3d-9e1c-4ad9-9491-7f603b880c94	{"action":"token_refreshed","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-04-10 20:07:51.642632+00	
00000000-0000-0000-0000-000000000000	fc6acd32-5f52-4f9a-b05f-c3ce7e41e952	{"action":"token_revoked","actor_id":"4174dc1e-6d0b-4e69-a716-1654abf40f1e","actor_username":"none@none.com","actor_via_sso":false,"log_type":"token"}	2025-04-10 20:07:51.644561+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	8935db97-9a3d-4058-9589-6e0f9b01ee84	authenticated	authenticated	grant@gravicdesign.com	$2a$10$WiGaopt1K5.ibhOzT7dRsue4PZD7VDXIF8zeURUh9ohbnvGOx179q	2025-02-27 17:48:46.117546+00	\N		\N		2025-03-04 02:43:16.361382+00			\N	2025-03-04 16:01:05.251106+00	{"provider": "email", "providers": ["email"]}	{"sub": "8935db97-9a3d-4058-9589-6e0f9b01ee84", "email": "grant@gravicdesign.com", "email_verified": true, "phone_verified": false}	\N	2025-02-27 17:48:46.096097+00	2025-03-04 16:01:05.258494+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4174dc1e-6d0b-4e69-a716-1654abf40f1e	authenticated	authenticated	none@none.com	$2a$10$0GxlfcyxYBuy9q/gA2x9gOTqfs0Qv/Yg1lSuOu8ovH/H.cKWtBFNW	2025-02-26 04:28:22.626012+00	\N		\N		\N			\N	2025-03-04 04:41:54.401281+00	{"provider": "email", "providers": ["email"]}	{"sub": "4174dc1e-6d0b-4e69-a716-1654abf40f1e", "email": "none@none.com", "email_verified": true, "phone_verified": false}	\N	2025-02-26 04:28:22.617771+00	2025-04-10 20:07:51.647078+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
4174dc1e-6d0b-4e69-a716-1654abf40f1e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{"sub": "4174dc1e-6d0b-4e69-a716-1654abf40f1e", "email": "none@none.com", "email_verified": false, "phone_verified": false}	email	2025-02-26 04:28:22.623013+00	2025-02-26 04:28:22.623059+00	2025-02-26 04:28:22.623059+00	fbc6d881-93bc-4ca1-92db-f8bd15bbae66
8935db97-9a3d-4058-9589-6e0f9b01ee84	8935db97-9a3d-4058-9589-6e0f9b01ee84	{"sub": "8935db97-9a3d-4058-9589-6e0f9b01ee84", "email": "grant@gravicdesign.com", "email_verified": false, "phone_verified": false}	email	2025-02-27 17:48:46.112031+00	2025-02-27 17:48:46.112089+00	2025-02-27 17:48:46.112089+00	c7bfb735-3fea-43d2-a8a1-54301017cf2c
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
962c97ff-d6a0-4363-99c4-07d4111b69ad	8935db97-9a3d-4058-9589-6e0f9b01ee84	2025-03-04 16:01:05.251813+00	2025-03-04 16:01:05.251813+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	5.182.32.111	\N
36137970-d1f3-49b9-bd41-ad5065de0ce1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 04:41:54.401933+00	2025-04-10 20:07:51.648565+00	\N	aal1	\N	2025-04-10 20:07:51.648486	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36	184.155.198.138	\N
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
36137970-d1f3-49b9-bd41-ad5065de0ce1	2025-03-04 04:41:54.407501+00	2025-03-04 04:41:54.407501+00	password	32436595-e359-4b78-8491-cbb4669a7cce
962c97ff-d6a0-4363-99c4-07d4111b69ad	2025-03-04 16:01:05.259023+00	2025-03-04 16:01:05.259023+00	password	659c424a-24ab-4be2-b865-58318d9a9163
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	73	QgdX6znWNMEvtoeTFJ0ohA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 15:42:06.6351+00	2025-03-04 16:40:47.749553+00	CweUi9AobRgp85doXrk0oA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	76	XY70qMvu4Zg2kvExidXWgg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 16:40:47.751312+00	2025-03-04 17:39:23.655503+00	QgdX6znWNMEvtoeTFJ0ohA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	77	943UzdcCmtxaTEHsG4aYwA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 17:39:23.656745+00	2025-03-04 23:01:52.288827+00	XY70qMvu4Zg2kvExidXWgg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	78	w_avnHKRBlQIpdBR8-0aNA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 23:01:52.29233+00	2025-03-05 00:00:27.245398+00	943UzdcCmtxaTEHsG4aYwA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	79	v9MeelDpg1HJWPvVq-24iQ	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-05 00:00:27.246572+00	2025-03-05 00:59:27.155339+00	w_avnHKRBlQIpdBR8-0aNA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	64	1ObvibdocmLQqYdMeTzqfg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 04:41:54.403567+00	2025-03-04 05:39:58.594307+00	\N	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	65	7iHimsAiXt_L2WDldeLqeA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 05:39:58.600785+00	2025-03-04 06:38:13.270534+00	1ObvibdocmLQqYdMeTzqfg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	66	vC09PfXWQZDKKuDLCDwfpA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 06:38:13.278168+00	2025-03-04 07:50:35.509424+00	7iHimsAiXt_L2WDldeLqeA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	67	g7e7yZF_ajcXqgk0dULSIg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 07:50:35.510046+00	2025-03-04 09:36:22.8232+00	vC09PfXWQZDKKuDLCDwfpA	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	68	MRYoevE2HxaU6k2jKgpctg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 09:36:22.824394+00	2025-03-04 11:14:15.445633+00	g7e7yZF_ajcXqgk0dULSIg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	69	kzMzkLhmLvV709s9XSJ0oQ	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 11:14:15.449854+00	2025-03-04 12:37:26.881673+00	MRYoevE2HxaU6k2jKgpctg	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	70	sgrOHk0GCWt2MhW6-y2xKQ	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 12:37:26.883195+00	2025-03-04 13:43:56.498676+00	kzMzkLhmLvV709s9XSJ0oQ	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	71	ptHdgRv0n6EFb1K0SwcZ1w	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 13:43:56.501598+00	2025-03-04 14:43:06.583162+00	sgrOHk0GCWt2MhW6-y2xKQ	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	72	CweUi9AobRgp85doXrk0oA	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-04 14:43:06.586134+00	2025-03-04 15:42:06.633839+00	ptHdgRv0n6EFb1K0SwcZ1w	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	75	YRwFCbWBvwXDYWpIxdsy2A	8935db97-9a3d-4058-9589-6e0f9b01ee84	f	2025-03-04 16:01:05.255037+00	2025-03-04 16:01:05.255037+00	\N	962c97ff-d6a0-4363-99c4-07d4111b69ad
00000000-0000-0000-0000-000000000000	80	RS-lzBb2MUmzHREj0vthvg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t	2025-03-05 00:59:27.155938+00	2025-04-10 20:07:51.64515+00	v9MeelDpg1HJWPvVq-24iQ	36137970-d1f3-49b9-bd41-ad5065de0ce1
00000000-0000-0000-0000-000000000000	81	4U2TUw-3jAc1BAhcSTm2pg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f	2025-04-10 20:07:51.645935+00	2025-04-10 20:07:51.645935+00	RS-lzBb2MUmzHREj0vthvg	36137970-d1f3-49b9-bd41-ad5065de0ce1
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, first_name, last_name, username, profile_photo_url, phone_number, phone_number_raw, address, participates_in_challenges, gender, dob, height, weight, body_fat_percentage, bmi, bmr, first_name_public, last_name_public, username_public, phone_number_public, address_public, participates_in_challenges_public, gender_public, dob_public, height_public, weight_public, body_fat_percentage_public, profile_photo_url_public, bmi_public, bmr_public) FROM stdin;
4174dc1e-6d0b-4e69-a716-1654abf40f1e	Buzz	McCallister	buzzmccallister	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/profile_photos/4174dc1e-6d0b-4e69-a716-1654abf40f1e.webp	5555555555	5555555555	123 Main St. Miami, FL 	t	Male	1975-01-01	75	239	21	29.9	2030	t	t	t	f	f	t	t	f	f	f	f	t	f	f
8935db97-9a3d-4058-9589-6e0f9b01ee84	\N	\N	gravic	\N	\N	\N	\N	f	\N	\N	0	0	0	\N	\N	f	f	t	f	f	f	f	f	f	f	f	t	f	f
\.


--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blocks (id, blocker_id, blocked_id, created_at) FROM stdin;
\.


--
-- Data for Name: challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenges (id, title, type, participants_current, participants_max, cost, prize_pool, scoring_type, is_public, created_at, created_by, challenge_name, challenge_type, max_participants, buy_in_cost, additional_prize_money, prize_type, prize_amount, number_of_winners, is_private, invitation_link, cover_media, start_datetime, end_datetime, creator_id, creator_participating) FROM stdin;
0439a9ac-83ba-4073-9590-956d5852ddf4	Test Challenge 1	Reading Books	1	0	0.00	0.00	Points	t	2025-02-27 02:15:45.546221+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	5	0	winner_takes_all	\N	\N	f	\N	\N	2025-03-20 21:01:12.417385+00	2025-03-05 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
2d7e28dc-f82f-4b74-a30e-6a1ad5d3f210	Jane's Walking Challenge	Fitness	1	0	0.00	0.00	Distance	t	2025-02-27 02:29:25.357343+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	400	0	winner_takes_all	\N	\N	f	\N	\N	2025-02-27 21:01:12.417385+00	2025-03-22 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
d636f426-a9ad-44ec-a91a-337fc0b422bd	Grant's Challenge	Fitness	1	5	0.00	0.00	Consistency	t	2025-02-27 13:21:14.908055+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	20	200	winner_takes_all	\N	\N	f	\N	\N	2025-03-15 21:01:12.417385+00	2025-03-22 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
287e5a38-68db-4587-a7f3-cc16f1530206	Gravic Challenge	Fitness	1	6	0.00	0.00	Points	t	2025-02-27 17:49:41.083809+00	8935db97-9a3d-4058-9589-6e0f9b01ee84	\N	\N	\N	10	100	winner_takes_all	\N	\N	f	\N	\N	2025-03-03 16:00:00+00	2025-03-28 16:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
09b58dac-817c-494e-aff1-fccd7a920616	Bob's Running Challenge	Fitness	1	0	0.00	0.00	Time (High)	t	2025-02-27 04:59:56.112283+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	\N	\N	\N	25	350	tournament	\N	\N	f	\N	\N	2025-03-28 21:01:12.417385+00	2025-04-01 21:01:12.417385+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
e793e456-36fa-47d2-a143-c1bb42742ed5	bl0b-a-thon	Fitness	0	250	0.00	0.00	Time (High)	t	2025-02-27 22:15:23.737916+00	\N	\N	\N	\N	25	25000	tournament	\N	\N	t	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1740694523059-1024.png	2025-02-28 15:15:00+00	2025-03-03 15:15:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
fd339687-04aa-46ca-8b51-7b1f9dd83203	bl0b-run	Fitness	0	10000	0.00	0.00	Consistency	t	2025-03-04 01:44:00.973373+00	\N	\N	\N	\N	100	2500	evenly_distributed	\N	1000	f	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1741052639691-Asset%201@4x.png	2025-03-05 10:00:00+00	2025-03-31 10:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t
f063d1f4-0b98-436b-a401-75cd670e5127	Bible in 90-Days	Bible Reading	0	0	0.00	0.00	Consistency	t	2025-03-04 01:49:38.532532+00	\N	\N	\N	\N	0	0	just_for_fun	\N	\N	f	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1741052977711-bible.jpg	2025-03-04 09:00:00+00	2025-04-01 00:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t
5e1adc0e-7401-4995-a2f8-d9340123a07a	Jay's Chores	Chore Challenge!	0	1	0.00	0.00	Consistency	t	2025-03-04 01:51:30.990814+00	\N	\N	\N	\N	0	5	winner_takes_all	\N	\N	t	\N	\N	2025-03-09 00:00:00+00	2025-03-16 00:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	f
364a2611-28e0-4aa9-9f81-9b5f56961837	Jonathan's Workout Challenge	Fitness	0	0	0.00	0.00	Consistency	t	2025-03-04 16:21:12.76892+00	\N	\N	\N	\N	20	150	tournament	\N	\N	f	\N	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/challenge-covers/1741105272110-bible.jpg	2025-03-05 00:00:00+00	2025-04-04 00:00:00+00	4174dc1e-6d0b-4e69-a716-1654abf40f1e	t
\.


--
-- Data for Name: challenge_lobbies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_lobbies (id, challenge_id, name, created_at) FROM stdin;
\.


--
-- Data for Name: challenge_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_participants (id, challenge_id, user_id, joined_at, "position", score) FROM stdin;
ae09871a-9983-417f-9007-26554abe4bf5	287e5a38-68db-4587-a7f3-cc16f1530206	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 19:11:17.757431	0	0
0e3abda7-4a60-4c22-b24b-38be28991705	0439a9ac-83ba-4073-9590-956d5852ddf4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 20:53:46.047087	0	0
4ce800e5-b617-4de1-86e9-9ce48faffbe2	d636f426-a9ad-44ec-a91a-337fc0b422bd	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 20:53:51.595193	0	0
36c552ab-5a6a-4b7a-bd3a-77d180981d86	09b58dac-817c-494e-aff1-fccd7a920616	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 21:04:42.265665	0	0
051dfce7-c827-46df-9686-76e1878855ed	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 23:01:35.818903	0	0
dbad233e-4e2a-42a5-ad6a-887031db1bc7	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:42:12.847017	0	0
a47e96e9-501b-4da4-b4ea-5a77b899ca54	287e5a38-68db-4587-a7f3-cc16f1530206	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:42:16.274837	0	0
de33db24-a0d8-44c2-abd2-4811fff7d73b	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:45:06.29535	0	0
922c432f-ac77-4a74-82ec-f60a491691e4	287e5a38-68db-4587-a7f3-cc16f1530206	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 05:45:31.889004	0	0
1e662743-1d7b-4257-beba-5a15a09c91d9	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-03 23:24:06.190678	0	0
057984dd-4dec-4b35-907d-34162f5778ab	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-03 23:24:08.858413	0	0
7d274d90-1cb2-4658-be45-52ff430ddb2f	e793e456-36fa-47d2-a143-c1bb42742ed5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-03 23:24:11.224573	0	0
14290ebf-38af-448e-8cc1-e43a4c1ab022	2d7e28dc-f82f-4b74-a30e-6a1ad5d3f210	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 00:55:06.283038	0	0
058cd0a3-abad-44ef-b134-e079bb9575e6	fd339687-04aa-46ca-8b51-7b1f9dd83203	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:44:01.076622	0	0
b01c05b0-0987-45bb-8c51-f892369bd920	f063d1f4-0b98-436b-a401-75cd670e5127	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:49:38.702171	0	0
e340bd7c-6a14-4dca-8c35-1ff5326487d5	5e1adc0e-7401-4995-a2f8-d9340123a07a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 04:25:17.526023	0	0
\.


--
-- Data for Name: challenge_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_types (id, name, usage_count) FROM stdin;
1	Fitness	0
2	Other	0
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, username, bio, avatar_url, favorite_color, first_name, last_name, phone_number, address, participates_in_challenges, gender, height_inches, weight_lbs, body_fat_percentage, dob) FROM stdin;
4174dc1e-6d0b-4e69-a716-1654abf40f1e	none@none.com	bobleblaw	\N	\N	\N	Bob	Leblaw	5555555555	123 Main St. Miami, FL	f	\N	\N	\N	\N	\N
8935db97-9a3d-4058-9589-6e0f9b01ee84	grant@gravicdesign.com	gravic	\N	\N	\N	Grant	V	7025555555	123 Some St	t	male	71	325	3	1987-01-01
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, user_id, content, color_code, created_at, challenge_id, media_url, parent_id, media_urls) FROM stdin;
2a9326fd-bd0e-4077-8622-1bddbdb0c758	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Say something!\n	\N	2025-02-28 00:25:10.882	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
8322b947-167b-42b3-89b8-84b1deb3e745	\N	Completed task: Run a Marathon!	\N	2025-02-28 00:27:10.590551	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
fef7328a-8f04-4d27-828b-0c343ed70cb1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 00:27:10.709	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
96d98179-07e3-4819-be8e-1db663f9259f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I don't want to.	\N	2025-02-28 00:27:37.918	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	2a9326fd-bd0e-4077-8622-1bddbdb0c758	{}
a0a59b4a-086d-40bb-b2a3-f97c07fe31a7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 00:42:29.139	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
665eeb4a-3adf-4c48-8048-9271565ff614	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Great Job!	\N	2025-02-28 00:46:34.206	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	fef7328a-8f04-4d27-828b-0c343ed70cb1	{}
4019b449-0473-40a5-85b2-ddbb77afcc06	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 00:46:52.995	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
0d4dd596-4ed6-4a9e-bee3-f661d413711e	4174dc1e-6d0b-4e69-a716-1654abf40f1e		\N	2025-02-28 02:02:25.119	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://media0.giphy.com/media/ftqLysT45BJMagKFuk/200.gif?cid=82dc00adynoyaivtvaur3fpsykvqxftxx6b83vpjmy5je02d&ep=v1_gifs_search&rid=200.gif&ct=g}	\N	{}
a2edbc63-e372-4719-a288-3eb0a3a67e7c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Neither do I!	\N	2025-02-28 02:10:21.473	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
e6ceba81-24f5-40a8-872d-a537955f7b21	4174dc1e-6d0b-4e69-a716-1654abf40f1e	What's up, ya'll?!\n	\N	2025-02-28 02:16:58.766	d636f426-a9ad-44ec-a91a-337fc0b422bd	{}	\N	{}
4efba640-568d-49e7-a327-8a5a02b881d7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45	\N	2025-02-28 02:59:06.58	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
d53ffa0f-de38-4e57-a7b9-09588d85850a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45	\N	2025-02-28 03:13:32.212	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
ad160bbd-4523-437a-81be-39075b92406f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45 and attached files.	\N	2025-02-28 03:36:15.492	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713774997-80.png}	\N	{}
25fb2e48-73c2-42d7-bc75-5649ab83c001	4174dc1e-6d0b-4e69-a716-1654abf40f1e		\N	2025-02-28 03:36:34.879	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713794428-80.png}	\N	{}
6076047c-4bcd-4cba-8700-f54f194bd9d5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 03:38:12.887	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
9046d4d7-78cf-4d92-9820-26e0793175ee	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw completed task: Run a Marathon! with Time Entry: 01:23:45 and attached files.	\N	2025-02-28 03:39:18.674	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713958093-80.png}	\N	{}
bdbe8bcb-3cb4-460f-810e-d2b54f774092	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw completed task: Run a Marathon! with Time Entry: 13:45:21 and attached files.	\N	2025-02-28 03:44:24.88	e793e456-36fa-47d2-a143-c1bb42742ed5	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740714264434-50.png}	\N	{}
d56bd5ae-a830-45d4-b978-c5563ee5f3bd	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Completed task: Run a Marathon!	\N	2025-02-28 03:54:47.938	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
0ddcab38-7a93-4c0c-8774-cfdb377c11fc	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Don't tell me what to do!	\N	2025-02-28 04:30:42.106	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
14c933d9-0d4c-45df-9d20-ddfbc4b0a4d2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Good job!	\N	2025-02-28 04:31:05.241	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	8322b947-167b-42b3-89b8-84b1deb3e745	{}
f7e70d1a-1f1e-41c4-884c-e6a66f2d2605	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Good work!	\N	2025-02-28 04:31:12.012	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
6ec76e55-1e61-49fd-bf0e-8c6556dd35ab	4174dc1e-6d0b-4e69-a716-1654abf40f1e	whatever!	\N	2025-02-28 04:31:27.098	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	14c933d9-0d4c-45df-9d20-ddfbc4b0a4d2	{}
eb0fe57e-7a0f-4f0c-949a-aacffbe4bbe2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Boop	\N	2025-02-28 04:34:20.804	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	665eeb4a-3adf-4c48-8048-9271565ff614	{}
2714ff8b-99af-4499-a334-de00c1f45b44	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I did it!	\N	2025-02-28 04:35:35.927	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
e8a17294-8ded-4915-882a-8a6581e748df	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I drank a gallon!	\N	2025-02-28 04:36:39.712	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
76fe3aca-9095-46a8-8313-4912379ac9d3	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw I know, right?!	\N	2025-02-28 04:47:05.849	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	665eeb4a-3adf-4c48-8048-9271565ff614	{}
e9e7dc18-3538-491d-883f-ab7bc0d32e77	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown Right?!\n	\N	2025-02-28 04:47:21.678	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	96d98179-07e3-4819-be8e-1db663f9259f	{}
7a9ef8a9-ee0c-42af-9c38-5795d0cd1238	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw completed Drink a Gallon of Water\nYeah, bro! I totes did it!	\N	2025-02-28 04:47:52.446	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
f7d92936-08ad-4b30-9465-9d61576d349d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown boop!	\N	2025-02-28 04:52:01.089	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	665eeb4a-3adf-4c48-8048-9271565ff614	{}
25619012-5e61-4cf9-ba5b-370cbb4637ad	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown hi	\N	2025-02-28 04:52:09.627	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	14c933d9-0d4c-45df-9d20-ddfbc4b0a4d2	{}
5c4cc6e1-1255-48d1-a57e-a16be857fef1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hey there!	\N	2025-02-28 05:02:25.44	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
2f48bb50-36ea-4d46-bfe2-072083484798	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Yeah, boy!	\N	2025-02-28 05:02:30.934	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	5c4cc6e1-1255-48d1-a57e-a16be857fef1	{}
ec7e4963-850e-401c-96e2-c43bb2bbd037	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw bonjour\n	\N	2025-02-28 05:07:54.326	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
4f48340f-3731-4bfe-bc58-6b66ba410ff1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Let's see if it works!	\N	2025-02-28 05:13:44.97	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
e66fc783-0e7f-467b-a277-1aaa8db40554	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Dang	\N	2025-02-28 05:13:53.858	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	9046d4d7-78cf-4d92-9820-26e0793175ee	{}
438f0f2c-0993-4cd0-8a46-96ad20cc4e1e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's up?\n	\N	2025-02-28 05:14:04.169	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	9046d4d7-78cf-4d92-9820-26e0793175ee	{}
3984fffa-4da6-411c-9224-efb6b3b84bd0	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi\n	\N	2025-02-28 05:41:54.862	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	d53ffa0f-de38-4e57-a7b9-09588d85850a	{}
e254faca-02c5-4e63-a2de-c0f513f218c5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Good job	\N	2025-02-28 05:41:59.315	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	3984fffa-4da6-411c-9224-efb6b3b84bd0	{}
ca2ef15c-57d5-4eae-a9eb-c9a72b14e69a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw giuguik	\N	2025-02-28 05:57:44.123	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	bdbe8bcb-3cb4-460f-810e-d2b54f774092	{}
9d4a84e5-8e59-4291-9af0-7ef0145d6451	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw jhvi	\N	2025-02-28 05:57:48.965	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	ca2ef15c-57d5-4eae-a9eb-c9a72b14e69a	{}
e4f3badc-ee8a-43da-817e-a136748d0cab	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Good job.	\N	2025-03-03 17:44:02.568	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	7a9ef8a9-ee0c-42af-9c38-5795d0cd1238	{}
b6052d87-3d4b-4e49-b44e-34b3391dfb82	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw whatcho mean?	\N	2025-03-03 17:44:11.929	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
6733a7e7-17eb-4e85-a82c-70ab5eca594c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hello?	#ffffff	2025-03-03 18:44:15.081	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
c656c6d6-70dd-4fbe-911c-be4bfcc38cec	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hi!	#ffffff	2025-03-03 18:56:12.113	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
ecf07b31-16f6-4819-a76d-f0ef735106fa	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hello!	#ffffff	2025-03-03 18:59:56.819	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
1c5588c2-9c82-4224-9eaa-746917fc6aee	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's up, Bob?	#ffffff	2025-03-03 19:36:02.07	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e254faca-02c5-4e63-a2de-c0f513f218c5	{}
a2bdd4cf-4a54-49be-9c6d-dbaf2f12ffea	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Nothing Much	#ffffff	2025-03-03 19:36:22.238	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	1c5588c2-9c82-4224-9eaa-746917fc6aee	{}
a2f983e9-0e5a-4469-af03-c6541967b143	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Why is it posting like this?	#ffffff	2025-03-03 19:36:37.803	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	a2bdd4cf-4a54-49be-9c6d-dbaf2f12ffea	{}
96dc6cca-5de1-4859-b097-bf81d3daf126	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's happening?	#ffffff	2025-03-03 19:36:29.007	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	1c5588c2-9c82-4224-9eaa-746917fc6aee	{}
9bd41a67-1f04-4b38-a5cc-49438197addf	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey, what's up!?	#ffffff	2025-03-03 19:38:51.204	\N	\N	\N	{}
ce4ab032-7f67-4d26-87d8-593d75a95fef	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw righteous	#ffffff	2025-03-03 19:39:06.942	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	1c5588c2-9c82-4224-9eaa-746917fc6aee	{}
02283e31-3517-4fa7-94c2-62894885bf69	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Great job!	#ffffff	2025-03-03 19:56:40.766	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	9046d4d7-78cf-4d92-9820-26e0793175ee	{}
8cf7dcd8-ca0c-423d-bb0e-30d8e0680f02	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw I know, right?!	#ffffff	2025-03-03 19:56:46.049	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	02283e31-3517-4fa7-94c2-62894885bf69	{}
2c2f406a-d09c-43a7-8b3e-d1f3d8ab5125	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Thanks	#ffffff	2025-03-03 20:03:38.839	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
4551bfbb-f2e9-4e2c-b8d4-d489e4544232	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Sounds good	#ffffff	2025-03-03 20:13:34.447	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
7e890877-ff1d-487c-8c5c-d211a3896bef	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Thanks!	#ffffff	2025-03-03 20:13:39.402	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	e4f3badc-ee8a-43da-817e-a136748d0cab	{}
c7879f5e-16f0-46d2-996b-e6dd7cc66b9f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hey!	#ffffff	2025-03-03 20:16:58.573	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	5c4cc6e1-1255-48d1-a57e-a16be857fef1	{}
4cc3ee6e-2f9e-41ff-b7ba-5b860d1e634d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi!	#ffffff	2025-03-03 20:17:25.462	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ec7e4963-850e-401c-96e2-c43bb2bbd037	{}
a1028653-0414-4fc3-918f-0fa345ec9774	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw This is another test comment.	#ffffff	2025-03-03 20:17:33.772	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	5c4cc6e1-1255-48d1-a57e-a16be857fef1	{}
bb320647-9508-430a-abed-e6ed4c37f2eb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Booyah!	#ffffff	2025-03-03 20:19:46.064	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	b6052d87-3d4b-4e49-b44e-34b3391dfb82	{}
719fb300-bdc1-4510-aa3d-0daec3d96339	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi!	#ffffff	2025-03-03 20:20:46.853	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
546aaf46-689d-4b2e-b17a-1f5d92942df5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw How are you?	#ffffff	2025-03-03 20:20:51.496	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	719fb300-bdc1-4510-aa3d-0daec3d96339	{}
6e9d4e22-73ac-4701-b965-ac8b7abc46aa	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Not bad, and you?	#ffffff	2025-03-03 20:22:53.689	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
62add388-9c0a-46b6-a1c2-8e9e4ad98bd4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hello?	#ffffff	2025-03-03 20:22:58.876	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
db202839-dcd3-47b9-bd15-63e78675a17a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's going on?	#ffffff	2025-03-03 20:23:04.04	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	c656c6d6-70dd-4fbe-911c-be4bfcc38cec	{}
02f55d65-0c5e-41fb-85e9-0a3817cbb9c9	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw I'm great, thank you!	#ffffff	2025-03-03 20:24:39.346	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	6e9d4e22-73ac-4701-b965-ac8b7abc46aa	{}
82b7de8c-a9a0-4a3e-a874-6d771e48bc17	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw haha.. that's funny	#ffffff	2025-03-03 21:10:58.121	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
cefd4142-aff0-4974-8492-35c8afa611bb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Good job!	#ffffff	2025-03-03 21:14:43.858	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
36564e76-46be-44f5-81b2-e87a0e0091a6	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw That's awesome!	#ffffff	2025-03-03 21:14:49.3	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
5370ff88-65b7-4cd8-a4b7-bc241bd91015	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Wow!	#ffffff	2025-03-03 21:14:52.443	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
94a581ad-ae77-48e3-bf5d-401feba0c1f2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Way to go!	#ffffff	2025-03-03 21:14:56.833	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
765377c3-ad9e-404f-bb0b-e717dce86f19	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Are you kidding me!?	#ffffff	2025-03-03 21:15:04.433	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
c136c3d6-0b5a-4212-b272-86c3484731e9	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw You sure about that?	#ffffff	2025-03-03 21:19:00.334	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
777b8101-ca54-414b-9729-0a387d922b65	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Hi!	#ffffff	2025-03-03 21:19:06.382	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
ada57b5d-0316-40fa-976f-b14b080dd3a1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Great job!	#ffffff	2025-03-03 21:19:10.033	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	546aaf46-689d-4b2e-b17a-1f5d92942df5	{}
f3d692de-5e14-4622-a378-bace2c894dba	4174dc1e-6d0b-4e69-a716-1654abf40f1e	This is a general post\n	#ffffff	2025-03-03 22:37:24.031	\N	\N	\N	{}
9afae28a-066d-4e9d-b8b7-38c1dce25cb7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey there!	#ffffff	2025-03-03 22:55:04.082	\N	\N	\N	{}
01583222-993b-4443-a878-f6093956acd8	4174dc1e-6d0b-4e69-a716-1654abf40f1e	What's Up!?\n	#ffffff	2025-03-03 22:55:09.168	\N	\N	\N	{}
a3deb286-58fd-4105-92bc-5a80a4bf9b7d	\N	This is a general post	\N	2025-03-03 23:01:30.745304	\N	{}	\N	{}
d69f240c-d121-4398-9e0b-1ceb5cfd931f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	How's it going?	#ffffff	2025-03-03 23:41:43.506	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	\N	{}
0cdab924-91a0-4299-9798-c614caed1f8f	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw @bobleblaw Hey there.	#ffffff	2025-03-03 23:50:12.533	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	d69f240c-d121-4398-9e0b-1ceb5cfd931f	{}
26e1cbe4-28f0-4752-8b5e-6eb5bf05c2ae	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@Unknown Hoo-doggy!	#ffffff	2025-03-04 00:11:14.644	\N	\N	a3deb286-58fd-4105-92bc-5a80a4bf9b7d	{}
6908efaa-d79c-4532-b592-983db1a5190b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's happening now?	#ffffff	2025-03-04 00:11:22.242	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	0cdab924-91a0-4299-9798-c614caed1f8f	{}
76e77899-c122-4824-9579-6955b1c88b64	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What?!	#ffffff	2025-03-04 00:11:29.135	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	0cdab924-91a0-4299-9798-c614caed1f8f	{}
4f4b368f-ce63-4ef8-b1bb-7a72d9d96f26	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw It doesn't appear to be working...	#ffffff	2025-03-04 00:11:36.287	d636f426-a9ad-44ec-a91a-337fc0b422bd	\N	0cdab924-91a0-4299-9798-c614caed1f8f	{}
f2c5b027-37ab-448c-9076-58142dcb1280	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Oh yeah?	#ffffff	2025-03-04 00:12:43.209	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	719fb300-bdc1-4510-aa3d-0daec3d96339	{}
681772c2-672a-4c51-a78f-7e925450e391	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Where is this going?	#ffffff	2025-03-04 00:12:55.991	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	ecf07b31-16f6-4819-a76d-f0ef735106fa	{}
a53f70d2-6411-4904-bc85-d706558745ce	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown Hi 1	#ffffff	2025-03-04 00:30:19.148	\N	\N	26e1cbe4-28f0-4752-8b5e-6eb5bf05c2ae	{}
638d196b-2233-4c7e-8d1d-e624118e8fc5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown Hola! 2	#ffffff	2025-03-04 00:30:25.767	\N	\N	26e1cbe4-28f0-4752-8b5e-6eb5bf05c2ae	{}
e8d64191-bd52-4839-90e8-4fe6b5bbf703	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey there	#ffffff	2025-03-04 00:49:33.048	\N	\N	\N	{}
a76292cf-703c-4795-8026-f8c6dc753e2c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Booyah!	#ffffff	2025-03-04 00:55:11.314	2d7e28dc-f82f-4b74-a30e-6a1ad5d3f210	\N	\N	{}
95d69669-3f89-4f26-a943-09c9049d46b0	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Hey, ya'll!	#ffffff	2025-03-04 00:56:23.28	\N	\N	\N	{}
a1e01736-3879-448b-b588-2296e6f68ae1	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw What's up!?	#ffffff	2025-03-04 00:56:45.943	\N	\N	e8d64191-bd52-4839-90e8-4fe6b5bbf703	{}
30634e98-6072-42c6-aa98-510053fc1a3a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Are you working now?!	#ffffff	2025-03-04 01:02:40.214	\N	\N	\N	{}
d9872985-95b0-440b-a6b4-8906624696cb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Is this working?	#ffffff	2025-03-04 01:07:11.568	\N	\N	e8d64191-bd52-4839-90e8-4fe6b5bbf703	{}
156aae4c-1de2-42e6-9e2d-00c697c49327	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw It appears so!	#ffffff	2025-03-04 01:07:23.361	\N	\N	d9872985-95b0-440b-a6b4-8906624696cb	{}
1f0846a5-266d-4781-b6eb-e275d34cb548	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Why do I have to refresh the page everytime I post a new comment?	#ffffff	2025-03-04 01:07:40.27	\N	\N	156aae4c-1de2-42e6-9e2d-00c697c49327	{}
931d59b8-d764-4558-a0fb-65c59f40d7cd	4174dc1e-6d0b-4e69-a716-1654abf40f1e	But there ARE posts!	#ffffff	2025-03-04 01:15:28.786	\N	\N	\N	{}
03fff4c8-1edd-4c5b-8cc9-2573092edb8b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Let's do this thing!	#ffffff	2025-03-04 01:24:11.566	e793e456-36fa-47d2-a143-c1bb42742ed5	\N	\N	{}
f1a247cb-92d5-4399-9da4-0fe66babe6d5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Let's run! Invite your friends!	#ffffff	2025-03-04 01:44:21.171	fd339687-04aa-46ca-8b51-7b1f9dd83203	\N	\N	{}
6fe19ed4-93da-4df1-9240-275b0ed59a3c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Let's read!	#ffffff	2025-03-04 03:38:24.911	f063d1f4-0b98-436b-a401-75cd670e5127	\N	\N	{}
3eeae95a-0c92-434e-8507-cad0e9800b5e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw what up!	#ffffff	2025-03-04 05:13:47.697	\N	\N	156aae4c-1de2-42e6-9e2d-00c697c49327	{}
d1fa77c1-ecc0-45e0-a383-5c181210a127	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw ?	#ffffff	2025-03-04 05:13:56.017	\N	\N	156aae4c-1de2-42e6-9e2d-00c697c49327	{}
1c7c424f-edc7-4778-9877-52aa8f03ed16	4174dc1e-6d0b-4e69-a716-1654abf40f1e		#ffffff	2025-03-04 05:14:28.351	\N	{https://media3.giphy.com/media/tfUW8mhiFk8NlJhgEh/200.gif?cid=82dc00ad8kkert19hs79utthv23ogy6sl6m3abhgula9at2j&ep=v1_gifs_search&rid=200.gif&ct=g}	\N	{}
0b1d4267-3713-4c2e-85ed-d42c92e67798	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Oh yeah?	#ffffff	2025-03-04 05:32:29.246	\N	\N	1c7c424f-edc7-4778-9877-52aa8f03ed16	{}
8f21d82e-767b-42e8-b466-507e89cc44a2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Nice	#ffffff	2025-03-04 05:32:34.267	\N	\N	0b1d4267-3713-4c2e-85ed-d42c92e67798	{}
cc8f3e9f-0291-4d9e-a6ca-b0c4eb0a06bb	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Excellent.	#ffffff	2025-03-04 05:32:40.681	\N	\N	0b1d4267-3713-4c2e-85ed-d42c92e67798	{}
3bfae5ea-16fc-435c-905e-5914d0623dd5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	Wow.	#ffffff	2025-03-04 05:39:07.903	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	\N	{}
2b7dc382-ddc2-4a2c-87c7-4f362f319b93	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown wowowow	#ffffff	2025-03-04 05:39:14.945	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	3bfae5ea-16fc-435c-905e-5914d0623dd5	{}
fd92a2f5-8822-421a-b146-24208dc730c4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown Why does it think I'm anonumous?	#ffffff	2025-03-04 05:39:28.439	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
ca344934-e0e4-40b7-a800-fc75308b74b2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown It didn't that time	#ffffff	2025-03-04 05:39:36.383	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
b608b4fc-eaf5-4632-9153-a6162d2f4dde	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@unknown What does "Challenge Post" mean?	#ffffff	2025-03-04 05:39:53.064	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
68c51512-9ce9-4aef-9321-f1966bb8070b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw whatchoo talkin' about?	#ffffff	2025-03-04 05:43:48.842	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
29834055-e3a1-498d-ad85-a405aed077c7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	@bobleblaw Oh yeah?	#ffffff	2025-03-04 05:43:55.657	5e1adc0e-7401-4995-a2f8-d9340123a07a	\N	2b7dc382-ddc2-4a2c-87c7-4f362f319b93	{}
0f5d22f0-64f4-4c20-89be-d1e82a44dc97	4174dc1e-6d0b-4e69-a716-1654abf40f1e	All done for the day!!	\N	2025-03-04 05:47:49.771	5e1adc0e-7401-4995-a2f8-d9340123a07a	{}	\N	{}
acd85b53-3520-47c8-a363-e4bd3e3f062d	\N	Buzz McCallister completed a task in #bl0b-a-thon!	\N	2025-03-04 06:37:04.571453	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{}
7c990718-c580-4f72-bc46-f489a36dc58b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	I did it!	\N	2025-03-04 06:37:04.51	e793e456-36fa-47d2-a143-c1bb42742ed5	{}	\N	{https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1741070223958-bl0b%20coin%202.jpg}
e63ceed6-284b-44a4-a262-5828f00053b4	8935db97-9a3d-4058-9589-6e0f9b01ee84	Hello!	#ffffff	2025-03-04 15:59:35.062	\N	\N	\N	{}
4a9999a2-503f-4726-9297-ae7d2ca53dd8	8935db97-9a3d-4058-9589-6e0f9b01ee84	Testing Anon post.	#ffffff	2025-03-04 16:01:18.654	\N	\N	\N	{}
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, user_id, content, created_at, parent_id) FROM stdin;
\.


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follows (id, follower_id, following_id, created_at) FROM stdin;
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friends (id, user_id, friend_id, created_at) FROM stdin;
\.


--
-- Data for Name: friendships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friendships (id, user_id, friend_id, created_at) FROM stdin;
\.


--
-- Data for Name: private_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.private_groups (id, name, created_at) FROM stdin;
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_members (id, group_id, user_id) FROM stdin;
\.


--
-- Data for Name: news_feed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.news_feed (id, message, created_at) FROM stdin;
451917a0-4676-43f3-a069-c13feccb9d24	Challenge "Run Fest" has a winner!	2025-02-27 19:15:19.904476
a3831b08-aea7-4bd7-8481-0d5624e6a994	New challenge "Push-Up Pro" created!	2025-02-27 19:15:19.904476
\.


--
-- Data for Name: post_reactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_reactions (id, post_id, user_id, reaction_type, created_at) FROM stdin;
990d5c8e-7d65-45a0-a4b0-dfe09146eb4c	4019b449-0473-40a5-85b2-ddbb77afcc06	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-02-28 00:58:41.604477+00
47fd89a3-1e51-46d2-80b4-50b82eacc1ef	a0a59b4a-086d-40bb-b2a3-f97c07fe31a7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-02-28 00:58:48.529056+00
f452ccea-2450-4398-b7c0-36b348803d30	4019b449-0473-40a5-85b2-ddbb77afcc06	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-02-28 01:07:25.240976+00
72982d1b-1ef6-42fe-9e1a-de85e74615b0	a0a59b4a-086d-40bb-b2a3-f97c07fe31a7	4174dc1e-6d0b-4e69-a716-1654abf40f1e	laugh	2025-02-28 01:18:53.456028+00
fc01e485-1cac-4e7e-8921-4eb468f03b62	e6ceba81-24f5-40a8-872d-a537955f7b21	4174dc1e-6d0b-4e69-a716-1654abf40f1e	comfort	2025-02-28 02:17:03.749061+00
2d3e39a3-6c08-4482-88cf-4ea70aa23231	e6ceba81-24f5-40a8-872d-a537955f7b21	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-02-28 02:17:15.142426+00
f28389d7-7145-468a-9667-8f1cabe3cdd3	d53ffa0f-de38-4e57-a7b9-09588d85850a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-02-28 05:43:40.509229+00
bf517ab9-b7c3-4e98-be0c-457f90bb9c62	b6052d87-3d4b-4e49-b44e-34b3391dfb82	4174dc1e-6d0b-4e69-a716-1654abf40f1e	laugh	2025-03-03 18:13:05.601597+00
e2bb6c00-51d3-4503-9fb6-4301940f0ee2	e4f3badc-ee8a-43da-817e-a136748d0cab	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-03-03 18:13:09.670989+00
ccc79db4-dbf0-4089-9a9d-bdcd7800e0ff	9d4a84e5-8e59-4291-9af0-7ef0145d6451	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-03-03 18:13:11.398502+00
3da4bf42-ecfb-402d-8092-a341bcbc978b	ecf07b31-16f6-4819-a76d-f0ef735106fa	4174dc1e-6d0b-4e69-a716-1654abf40f1e	comfort	2025-03-03 19:16:39.143221+00
a2a74f5c-45ca-4a37-98ea-d4aab82bfe03	30634e98-6072-42c6-aa98-510053fc1a3a	4174dc1e-6d0b-4e69-a716-1654abf40f1e	laugh	2025-03-04 01:06:52.173808+00
d19c738f-d6fa-4561-86ef-75d2b45c5b19	acd85b53-3520-47c8-a363-e4bd3e3f062d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	heart	2025-03-04 06:40:26.322121+00
fe79ebe5-b2e8-4202-b81f-c80dd5fcbd0c	acd85b53-3520-47c8-a363-e4bd3e3f062d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	like	2025-03-04 12:38:49.524492+00
\.


--
-- Data for Name: social_channels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.social_channels (id, name, is_public, created_at) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, challenge_id, action, frequency, verification_type, notes, created_at, updated_at, require_attachment, completed, user_id, requires_attachment, media_url, require_video_completion) FROM stdin;
a8f35559-ec40-4a4b-8f9b-4f62ec56fda1	287e5a38-68db-4587-a7f3-cc16f1530206	Run a Mile	per day	Attachment Upload	You must run one mile every day of the challenge.	2025-02-27 21:31:35.935073+00	2025-02-27 21:31:35.935073+00	f	f	\N	f	\N	f
aaecda17-696a-4cd0-8e04-b84c5ed94b53	e793e456-36fa-47d2-a143-c1bb42742ed5	Run a Marathon!	per challenge	Time Entry	Run the bl0b-a-thon and then enter your race time and upload photos as proof.	2025-02-27 23:13:27.332937+00	2025-02-27 23:13:27.332937+00	t	t	\N	f	\N	f
0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	e793e456-36fa-47d2-a143-c1bb42742ed5	Drink a Gallon of Water	per day	No Verification		2025-02-28 04:27:47.627291+00	2025-02-28 04:27:47.627291+00	f	f	\N	f	\N	f
d22a113f-2204-4a26-9cf2-9a5edfda2171	5e1adc0e-7401-4995-a2f8-d9340123a07a	Sunday's Chores	per challenge	Text Form	What all did you do? Upload a picture at the end of the day.	2025-03-04 01:52:17.090464+00	2025-03-04 01:52:17.090464+00	t	f	\N	f	\N	f
a6586327-c636-4e38-8cfe-6c7414707ad5	5e1adc0e-7401-4995-a2f8-d9340123a07a	Watch this School Video	per challenge	Text Form	Watch this video and then tell me what you learned before you can move on from this task.	2025-03-04 04:06:15.168009+00	2025-03-04 04:06:15.168009+00	f	f	\N	f	https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1741061171598-Home%20Page%20Background%20vid.mp4	t
\.


--
-- Data for Name: task_completions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_completions (id, task_id, user_id, challenge_id, submitted_data, created_at, status) FROM stdin;
8cb9552d-de69-44db-83a0-6a894612c31f	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 02:59:06.68317	pending
0c9c57f6-bd32-4677-9b7e-666200eb44c4	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 03:13:32.309974	pending
ef7ada72-f9ed-41bc-b54b-b7db1736c6de	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713774997-80.png"], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 03:36:15.585813	pending
4902e568-d67d-4456-8c14-e99bc2a03bfc	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740713958093-80.png"], "verification": {"type": "Time Entry", "value": "01:23:45"}}	2025-02-28 03:39:18.769338	pending
5b28fe6f-521c-4ee3-afdd-eb5eaf2bc4e7	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1740714264434-50.png"], "verification": {"type": "Time Entry", "value": "13:45:21"}}	2025-02-28 03:44:24.977033	pending
c5ec22e3-ca8c-4068-91ee-c1522ceacbd0	0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "No Verification", "value": null}}	2025-02-28 04:35:35.986138	pending
afe691ac-206c-4b0e-b80f-6e6c59d2d247	0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "No Verification", "value": null}}	2025-02-28 04:36:39.764312	pending
0c80c9c7-b643-419a-b820-a56b8c6a9d62	0fa904eb-3daa-4513-ac60-ca7e4b0fb62c	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": [], "verification": {"type": "No Verification", "value": null}}	2025-02-28 04:47:52.465843	pending
0e4384ef-2a43-44bb-bba3-a14e8876e7f7	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "It was a video of a bunch of houses."}, "video_watched": true}	2025-03-04 04:25:57.550551	pending
95acd4c7-a2f6-40d6-adc8-029f4afacc72	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "blah"}, "video_watched": true}	2025-03-04 05:15:54.911836	pending
eac7634b-3423-46b9-a329-574aaddda4ab	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "It's a video."}, "video_watched": true}	2025-03-04 05:36:28.333232	pending
e0645b39-5664-4c43-b20c-1b6e65071480	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "It's a video."}, "video_watched": true}	2025-03-04 05:37:20.362154	pending
10292dfa-a745-4e64-a7e5-5c26e9237f57	a6586327-c636-4e38-8cfe-6c7414707ad5	4174dc1e-6d0b-4e69-a716-1654abf40f1e	5e1adc0e-7401-4995-a2f8-d9340123a07a	{"attachments": [], "verification": {"type": "Text Form", "value": "Cool Video!"}, "video_watched": true}	2025-03-04 05:47:49.836758	pending
4da68bec-e153-46a4-8159-21e706ac8ca9	aaecda17-696a-4cd0-8e04-b84c5ed94b53	4174dc1e-6d0b-4e69-a716-1654abf40f1e	e793e456-36fa-47d2-a143-c1bb42742ed5	{"attachments": ["https://aacvoxossqxdkfahgsvc.supabase.co/storage/v1/object/public/media/1741070223958-bl0b%20coin%202.jpg"], "verification": {"type": "Time Entry", "value": "01:23:45"}, "video_watched": null}	2025-03-04 06:37:04.571453	pending
\.


--
-- Data for Name: user_challenge_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_challenge_logs (id, user_id, challenge_id, metric_value, logged_at, proof_url) FROM stdin;
\.


--
-- Data for Name: user_challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_challenges (id, user_id, challenge_id, joined_at) FROM stdin;
\.


--
-- Data for Name: whispers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.whispers (id, sender_id, recipient_id, content, created_at, read) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_01; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_01 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_02; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_02 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_03; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_03 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_04; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_04 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_05; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_05 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_06; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_06 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_03_07; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_03_07 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-02-25 20:12:18
20211116045059	2025-02-25 20:12:18
20211116050929	2025-02-25 20:12:18
20211116051442	2025-02-25 20:12:18
20211116212300	2025-02-25 20:12:18
20211116213355	2025-02-25 20:12:18
20211116213934	2025-02-25 20:12:18
20211116214523	2025-02-25 20:12:18
20211122062447	2025-02-25 20:12:18
20211124070109	2025-02-25 20:12:18
20211202204204	2025-02-25 20:12:18
20211202204605	2025-02-25 20:12:18
20211210212804	2025-02-25 20:12:19
20211228014915	2025-02-25 20:12:19
20220107221237	2025-02-25 20:12:19
20220228202821	2025-02-25 20:12:19
20220312004840	2025-02-25 20:12:19
20220603231003	2025-02-25 20:12:19
20220603232444	2025-02-25 20:12:19
20220615214548	2025-02-25 20:12:19
20220712093339	2025-02-25 20:12:19
20220908172859	2025-02-25 20:12:19
20220916233421	2025-02-25 20:12:19
20230119133233	2025-02-25 20:12:19
20230128025114	2025-02-25 20:12:19
20230128025212	2025-02-25 20:12:19
20230227211149	2025-02-25 20:12:19
20230228184745	2025-02-25 20:12:19
20230308225145	2025-02-25 20:12:19
20230328144023	2025-02-25 20:12:19
20231018144023	2025-02-25 20:12:19
20231204144023	2025-02-25 20:12:19
20231204144024	2025-02-25 20:12:19
20231204144025	2025-02-25 20:12:19
20240108234812	2025-02-25 20:12:19
20240109165339	2025-02-25 20:12:19
20240227174441	2025-02-25 20:12:19
20240311171622	2025-02-25 20:12:19
20240321100241	2025-02-25 20:12:19
20240401105812	2025-02-25 20:12:19
20240418121054	2025-02-25 20:12:19
20240523004032	2025-02-25 20:12:19
20240618124746	2025-02-25 20:12:19
20240801235015	2025-02-25 20:12:19
20240805133720	2025-02-25 20:12:19
20240827160934	2025-02-25 20:12:19
20240919163303	2025-02-25 20:12:19
20240919163305	2025-02-25 20:12:19
20241019105805	2025-02-25 20:12:19
20241030150047	2025-02-25 20:12:19
20241108114728	2025-02-25 20:12:19
20241121104152	2025-02-25 20:12:19
20241130184212	2025-02-25 20:12:19
20241220035512	2025-02-25 20:12:19
20241220123912	2025-02-25 20:12:19
20241224161212	2025-02-25 20:12:19
20250107150512	2025-02-25 20:12:19
20250110162412	2025-02-25 20:12:19
20250123174212	2025-02-25 20:12:19
20250128220012	2025-02-25 20:12:19
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
avatars	avatars	\N	2025-02-25 21:43:03.294511+00	2025-02-25 21:43:03.294511+00	f	f	\N	\N	\N
challenge-covers	challenge-covers	\N	2025-02-27 22:09:03.654267+00	2025-02-27 22:09:03.654267+00	t	f	\N	\N	\N
media	media	\N	2025-02-28 01:57:00.963846+00	2025-02-28 01:57:00.963846+00	t	f	\N	\N	\N
task-media	task-media	\N	2025-03-04 03:54:18.783347+00	2025-03-04 03:54:18.783347+00	f	f	\N	\N	\N
profile_photos	Profile Photos	\N	2025-02-27 02:50:57.930731+00	2025-02-27 02:50:57.930731+00	t	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-02-25 20:10:38.054229
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-02-25 20:10:38.082941
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-02-25 20:10:38.096984
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-02-25 20:10:38.141898
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-02-25 20:10:38.195386
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-02-25 20:10:38.213945
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-02-25 20:10:38.234392
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-02-25 20:10:38.252229
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-02-25 20:10:38.26625
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-02-25 20:10:38.293047
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-02-25 20:10:38.30739
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-02-25 20:10:38.321552
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-02-25 20:10:38.340232
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-02-25 20:10:38.357068
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-02-25 20:10:38.375327
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-02-25 20:10:38.427176
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-02-25 20:10:38.446699
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-02-25 20:10:38.478833
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-02-25 20:10:38.516355
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-02-25 20:10:38.563991
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-02-25 20:10:38.577097
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-02-25 20:10:38.639083
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-02-25 20:10:38.689873
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-02-25 20:10:38.742585
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-02-25 20:10:38.774928
25	custom-metadata	67eb93b7e8d401cafcdc97f9ac779e71a79bfe03	2025-02-25 20:10:38.795766
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
393d8573-c8a4-4c11-8517-fbecd7389f67	challenge-covers	1740694218395-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:10:18.96376+00	2025-02-27 22:10:18.96376+00	2025-02-27 22:10:18.96376+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:10:19.000Z", "contentLength": 89291, "httpStatusCode": 200}	d75d5d7e-ed50-4d16-b425-3f6fdb0ab4ee	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
2f0f777c-1cc4-44b1-b944-4ce3c771eeae	challenge-covers	1740694235272-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:10:35.793112+00	2025-02-27 22:10:35.793112+00	2025-02-27 22:10:35.793112+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:10:36.000Z", "contentLength": 89291, "httpStatusCode": 200}	9fe677ac-bba8-40f2-bcdb-0e3c9622a587	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
e132678a-0022-48d5-b1b0-07ce2f7a0ca9	challenge-covers	1740694313077-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:11:53.618753+00	2025-02-27 22:11:53.618753+00	2025-02-27 22:11:53.618753+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:11:54.000Z", "contentLength": 89291, "httpStatusCode": 200}	a6fd403d-8b22-444d-b99a-7fd94fe61483	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
a65f10c7-355c-4629-97ca-4a9a7d7bd9f4	challenge-covers	1740694465281-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:14:25.774867+00	2025-02-27 22:14:25.774867+00	2025-02-27 22:14:25.774867+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:14:26.000Z", "contentLength": 89291, "httpStatusCode": 200}	244c29c3-781a-4158-8c9d-112a75cd9cc8	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
a8aba1eb-9ede-4d86-8ab7-f5784440479d	challenge-covers	1740694523059-1024.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-27 22:15:23.507386+00	2025-02-27 22:15:23.507386+00	2025-02-27 22:15:23.507386+00	{"eTag": "\\"cdd9cd93c3867b80d60023fd3e0fd0e7\\"", "size": 89291, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T22:15:24.000Z", "contentLength": 89291, "httpStatusCode": 200}	ca41ac5a-0f8c-497b-8311-0a612b54795b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
db6ee64f-da2d-480e-99ba-456b662ae9db	media	1740713774997-80.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:36:15.371714+00	2025-02-28 03:36:15.371714+00	2025-02-28 03:36:15.371714+00	{"eTag": "\\"a6530c8556f34cc1bf5379f0162cbbe3\\"", "size": 4631, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:36:16.000Z", "contentLength": 4631, "httpStatusCode": 200}	4d7e2d10-0e1b-43da-ab9e-fc4646e8a81b	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
fe9a86a7-5250-4688-9401-7ae3c68d7232	media	1740713794428-80.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:36:34.851872+00	2025-02-28 03:36:34.851872+00	2025-02-28 03:36:34.851872+00	{"eTag": "\\"a6530c8556f34cc1bf5379f0162cbbe3\\"", "size": 4631, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:36:35.000Z", "contentLength": 4631, "httpStatusCode": 200}	bb50cd1c-b6b7-43e1-b1db-53255609023d	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
77ab75b6-f240-44e7-ae71-d4c352af6fe8	media	1740713958093-80.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:39:18.543491+00	2025-02-28 03:39:18.543491+00	2025-02-28 03:39:18.543491+00	{"eTag": "\\"a6530c8556f34cc1bf5379f0162cbbe3\\"", "size": 4631, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:39:19.000Z", "contentLength": 4631, "httpStatusCode": 200}	f37a6b2a-f504-4322-b066-bd6bdcac7c10	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
f0d91019-50db-4cf0-b9b9-ccfdefcfdb5a	media	1740714264434-50.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-02-28 03:44:24.79903+00	2025-02-28 03:44:24.79903+00	2025-02-28 03:44:24.79903+00	{"eTag": "\\"184560facbe584e4203f2b16bb886fc5\\"", "size": 2802, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:44:25.000Z", "contentLength": 2802, "httpStatusCode": 200}	29d80b06-0302-4dd4-8bde-0a26c1b7fc72	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
c4467593-c9c1-4cc0-b94e-a04729843155	challenge-covers	1741052639691-Asset 1@4x.png	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:44:00.711768+00	2025-03-04 01:44:00.711768+00	2025-03-04 01:44:00.711768+00	{"eTag": "\\"e57f0da11b43e55357379699325331d5\\"", "size": 23735, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T01:44:01.000Z", "contentLength": 23735, "httpStatusCode": 200}	82ea793d-59bd-439f-95d1-d6c3932f54c4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
c160881e-d1cd-4eb8-939e-b126ec988c0d	profile_photos	4174dc1e-6d0b-4e69-a716-1654abf40f1e.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:36:09.799105+00	2025-03-04 04:58:16.770208+00	2025-03-04 01:36:09.799105+00	{"eTag": "\\"1e23725c7fb8af3763ceac847ebd894b\\"", "size": 475130, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T04:58:17.000Z", "contentLength": 475130, "httpStatusCode": 200}	60856002-c46f-45bf-9806-191db4756d7e	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
e34741b2-5256-404c-90c1-38584de4bbb8	challenge-covers	1741052977711-bible.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 01:49:38.289394+00	2025-03-04 01:49:38.289394+00	2025-03-04 01:49:38.289394+00	{"eTag": "\\"ee07dca91a60d2880923444f4a8b2578\\"", "size": 33672, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T01:49:39.000Z", "contentLength": 33672, "httpStatusCode": 200}	fe283010-2896-46b3-92e4-0d92f3368a23	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
3191fb77-f225-4202-bf55-3f18e4a609c4	media	1741061171598-Home Page Background vid.mp4	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 04:06:14.643858+00	2025-03-04 04:06:14.643858+00	2025-03-04 04:06:14.643858+00	{"eTag": "\\"7dd9151e676d3f374cddd0c9aedc790a-2\\"", "size": 8004285, "mimetype": "video/mp4", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T04:06:14.000Z", "contentLength": 8004285, "httpStatusCode": 200}	e88b8bb1-d597-4ec0-80ff-ec420c557b84	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
2aa981fa-e1cf-4f20-8a58-a32a81e1ec31	profile_photos	4174dc1e-6d0b-4e69-a716-1654abf40f1e.webp	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 06:25:49.19016+00	2025-03-04 06:25:49.19016+00	2025-03-04 06:25:49.19016+00	{"eTag": "\\"23e8478b1bbc8f441b80821fccb7b977\\"", "size": 79076, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T06:25:50.000Z", "contentLength": 79076, "httpStatusCode": 200}	0e031ec7-e2df-4592-934d-8cd39b8dc555	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
39dd6aaa-c80a-4b0d-9295-88fb7da71334	media	1741070223958-bl0b coin 2.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 06:37:04.37285+00	2025-03-04 06:37:04.37285+00	2025-03-04 06:37:04.37285+00	{"eTag": "\\"a966f7a5dd7759286f7948937875a47c\\"", "size": 61749, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T06:37:05.000Z", "contentLength": 61749, "httpStatusCode": 200}	d71f752e-deb6-4815-abc2-a8a63dbe8e89	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
1061cbfa-d6f9-4d2e-bcf0-c38a86a0036c	profile_photos	8935db97-9a3d-4058-9589-6e0f9b01ee84.png	8935db97-9a3d-4058-9589-6e0f9b01ee84	2025-03-04 15:55:55.157114+00	2025-03-04 15:55:55.157114+00	2025-03-04 15:55:55.157114+00	{"eTag": "\\"437449304cae8f97bda2924737258220\\"", "size": 108416, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T15:55:56.000Z", "contentLength": 108416, "httpStatusCode": 200}	1dc8a4e6-e8f3-479c-a098-218fab3ebd56	8935db97-9a3d-4058-9589-6e0f9b01ee84	{}
04d97e48-97e9-4a1b-9e14-bca1312e3918	challenge-covers	1741105272110-bible.jpg	4174dc1e-6d0b-4e69-a716-1654abf40f1e	2025-03-04 16:21:12.557357+00	2025-03-04 16:21:12.557357+00	2025-03-04 16:21:12.557357+00	{"eTag": "\\"ee07dca91a60d2880923444f4a8b2578\\"", "size": 33672, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-03-04T16:21:13.000Z", "contentLength": 33672, "httpStatusCode": 200}	bc753c08-7220-49fd-9f31-75be534393e2	4174dc1e-6d0b-4e69-a716-1654abf40f1e	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 81, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: challenge_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challenge_types_id_seq', 2, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

