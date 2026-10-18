--
-- PostgreSQL database dump
--

\restrict xqT48lgCUOukyo7rZUAPFuXdWlOlQP9TuZKYpavri6sx0Ag9i3nqeDNZswuAJez

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6 (Debian 18.6-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: booking; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.booking (
    id integer NOT NULL,
    user_id integer,
    status_id integer CONSTRAINT booking_status_id_not_null1 NOT NULL,
    total_amount numeric(12,2) NOT NULL,
    booking_time timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_booking_amount CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public.booking OWNER TO test;

--
-- Name: booking_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.booking ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: booking_status; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.booking_status (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.booking_status OWNER TO test;

--
-- Name: booking_status_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.booking_status ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.booking_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_type; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.document_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.document_type OWNER TO test;

--
-- Name: document_type_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.document_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.document_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gender; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.gender (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.gender OWNER TO test;

--
-- Name: gender_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.gender ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.gender_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notification_log; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.notification_log (
    id integer NOT NULL,
    template_id integer NOT NULL,
    recipient_email character varying(255) NOT NULL,
    sent_at timestamp with time zone,
    status character varying(30) DEFAULT 'pending'::character varying NOT NULL
);


ALTER TABLE public.notification_log OWNER TO test;

--
-- Name: notification_log_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.notification_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.notification_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notification_template; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.notification_template (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    subject text NOT NULL,
    body text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notification_template OWNER TO test;

--
-- Name: notification_template_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.notification_template ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.notification_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: passengers; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.passengers (
    id integer NOT NULL,
    user_id integer,
    full_name text NOT NULL,
    document_type_id integer NOT NULL,
    document_number character varying(50) NOT NULL,
    birth_date date NOT NULL,
    gender_id integer NOT NULL,
    citizenship text
);


ALTER TABLE public.passengers OWNER TO test;

--
-- Name: passengers_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.passengers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.passengers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: payment; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_method_id integer NOT NULL,
    status_id integer CONSTRAINT payment_status_id_not_null1 NOT NULL,
    payment_time timestamp with time zone,
    CONSTRAINT chk_payment_amount CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.payment OWNER TO test;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.payment ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.payment_methods OWNER TO test;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.payment_methods ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.payment_provider (
    id integer NOT NULL,
    name text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    payment_method_id integer NOT NULL
);


ALTER TABLE public.payment_provider OWNER TO test;

--
-- Name: payment_provider_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.payment_provider ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payment_provider_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: payment_status; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.payment_status (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.payment_status OWNER TO test;

--
-- Name: payment_status_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.payment_status ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payment_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: role; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.role (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.role OWNER TO test;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.role ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: route; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.route (
    id integer NOT NULL,
    departure_station_id integer NOT NULL,
    arrival_station_id integer NOT NULL,
    distance_km integer NOT NULL,
    CONSTRAINT chk_route_distance CHECK ((distance_km > 0)),
    CONSTRAINT chk_route_stations CHECK ((departure_station_id <> arrival_station_id))
);


ALTER TABLE public.route OWNER TO test;

--
-- Name: route_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.route ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: station; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.station (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    timezone character varying(50) NOT NULL,
    city character varying(100) NOT NULL
);


ALTER TABLE public.station OWNER TO test;

--
-- Name: station_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.station ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.station_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ticket; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.ticket (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    user_id integer NOT NULL,
    provider_id integer NOT NULL
);


ALTER TABLE public.ticket OWNER TO test;

--
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.ticket ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: train_operator; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.train_operator (
    id integer NOT NULL,
    name text NOT NULL,
    commission_rate numeric(12,2) CONSTRAINT train_operator_comission_rate_not_null NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.train_operator OWNER TO test;

--
-- Name: train_operator_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.train_operator ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.train_operator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: test
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    phone_number character varying(20),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    role integer CONSTRAINT users_role_id_not_null NOT NULL,
    full_name text
);


ALTER TABLE public.users OWNER TO test;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vw_booking_details; Type: VIEW; Schema: public; Owner: test
--

CREATE VIEW public.vw_booking_details AS
 SELECT b.id AS booking_id,
    u.full_name AS user_name,
    s.name AS status_name,
    b.total_amount,
    b.booking_time
   FROM ((public.booking b
     LEFT JOIN public.users u ON ((b.user_id = u.id)))
     JOIN public.booking_status s ON ((b.status_id = s.id)));


ALTER VIEW public.vw_booking_details OWNER TO test;

--
-- Name: vw_ticket_details; Type: VIEW; Schema: public; Owner: test
--

CREATE VIEW public.vw_ticket_details AS
 SELECT t.id AS ticket_id,
    t.booking_id,
    u.full_name AS user_name,
    o.name AS operator_name
   FROM ((public.ticket t
     JOIN public.users u ON ((t.user_id = u.id)))
     JOIN public.train_operator o ON ((t.provider_id = o.id)));


ALTER VIEW public.vw_ticket_details OWNER TO test;

--
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.booking (id, user_id, status_id, total_amount, booking_time) FROM stdin;
2	2	2	4200.00	2026-10-02 09:15:00+00
3	3	1	1800.00	2026-10-03 04:00:00+00
4	4	4	5600.00	2026-10-04 13:45:00+00
5	2	3	3200.00	2026-10-05 06:20:00+00
6	1	1	2500.00	2026-10-17 17:16:50.875268+00
1	1	3	2502.00	2026-10-01 05:30:00+00
7	1	1	11111.00	2026-10-17 18:18:19.095644+00
\.


--
-- Data for Name: booking_status; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.booking_status (id, code, name) FROM stdin;
1	pending	Ожидает подтверждения
2	confirmed	Бронирование подтверждено
3	ticketed	Билеты оформлены
4	cancelled	Бронирование отменено
5	expired	Срок бронирования истек
6	failed	Ошибка бронирования
\.


--
-- Data for Name: document_type; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.document_type (id, name, is_active) FROM stdin;
1	Паспорт РФ	t
2	Заграничный паспорт	t
3	Свидетельство о рождении	t
\.


--
-- Data for Name: gender; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.gender (id, code, name) FROM stdin;
1	male	Мужской
2	female	Женский
\.


--
-- Data for Name: notification_log; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.notification_log (id, template_id, recipient_email, sent_at, status) FROM stdin;
1	1	anna@example.com	\N	pending
2	2	ivan@example.com	\N	pending
\.


--
-- Data for Name: notification_template; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.notification_template (id, name, subject, body, is_active, created_at) FROM stdin;
1	booking_confirmed	Бронирование подтверждено	Ваш билет забронирован.	t	2026-10-11 16:14:02.358522+00
2	payment_success	Оплата успешна	Ваш билет успешно оплачен.	t	2026-10-11 16:14:02.358522+00
3	booking_cancelled	Бронирование отменено	Ваше бронирование отменено.	f	2026-10-11 16:15:03.934113+00
\.


--
-- Data for Name: passengers; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.passengers (id, user_id, full_name, document_type_id, document_number, birth_date, gender_id, citizenship) FROM stdin;
1	1	Иван Петров	1	79324509123	1995-04-12	1	Россия
2	2	Анна Смирнова	1	79324510987	1998-08-25	2	Россия
3	3	Павел Сидоров	2	7932751234	1992-11-03	1	Россия
4	4	Мария Иванова	1	79325123000	2000-02-17	2	Россия
5	2	Елена Смирнова	3	79321234561	2015-06-20	2	Россия
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.payment (id, booking_id, amount, payment_method_id, status_id, payment_time) FROM stdin;
1	1	2500.00	1	3	2026-10-01 05:35:00+00
2	2	4200.00	2	2	\N
3	3	1800.00	1	1	\N
4	4	5600.00	1	5	\N
5	5	3200.00	2	3	2026-10-05 06:25:00+00
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.payment_methods (id, code, name) FROM stdin;
1	card	Оплата картой
2	sbp	Через СБП
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.payment_provider (id, name, active, payment_method_id) FROM stdin;
1	ЮKassa	t	1
2	CloudPayments	t	1
3	Т-Банк Эквайринг	t	1
4	Сбербанк Эквайринг	t	2
5	Альфа-Банк Эквайринг	f	2
\.


--
-- Data for Name: payment_status; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.payment_status (id, code, name) FROM stdin;
1	pending	Ожидает оплаты
2	processing	Оплата обрабатывается
3	succeeded	Оплачено
4	failed	Ошибка оплаты
5	cancelled	Отмена оплаты
6	refunded	Деньги возвращены
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.role (id, code, name) FROM stdin;
1	user	Зарегистрированный пользователь
2	admin	Администратор
\.


--
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.route (id, departure_station_id, arrival_station_id, distance_km) FROM stdin;
1	1	2	330
2	2	3	250
3	3	4	700
4	1	4	1280
5	5	1	1800
\.


--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.station (id, name, timezone, city) FROM stdin;
1	Екатеринбург-Пассажирский	Asia/Yekaterinburg	Екатеринбург
2	Тюмень	Asia/Yekaterinburg	Тюмень
3	Тобольск	Asia/Yekaterinburg	Тобольск
4	Нижневартовск-1	Asia/Yekaterinburg	Нижневартовск
5	Москва Казанская	Europe/Moscow	Москва
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.ticket (id, booking_id, user_id, provider_id) FROM stdin;
1	1	1	1
2	1	1	2
3	2	2	1
4	5	2	3
5	5	2	4
6	1	1	1
7	2	2	2
8	3	3	1
9	3	3	2
10	4	4	3
11	6	1	1
\.


--
-- Data for Name: train_operator; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.train_operator (id, name, commission_rate, is_active) FROM stdin;
1	АО «Федеральная пассажирская компания» (ФПК)	5.00	t
2	Дирекция скоростного сообщения (ДОСС)	4.50	t
3	АО ТК «Гранд Сервис Экспресс»	6.00	t
4	ООО «Тверской экспресс»	5.50	t
5	АО «Пассажирская компания „Сахалин“»	4.00	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: test
--

COPY public.users (id, email, password_hash, phone_number, created_at, updated_at, role, full_name) FROM stdin;
1	ivan@example.com	demo_hash_001	+79990000001	2026-10-10 16:33:58.391668+00	\N	1	Иван Петров
2	anna@example.com	demo_hash_002	+79990000002	2026-10-10 16:33:58.391668+00	\N	1	Анна Смирнова
3	pavel@example.com	demo_hash_003	+79990000003	2026-10-10 16:33:58.391668+00	\N	1	Павел Сидоров
4	maria@example.com	demo_hash_004	+79990000004	2026-10-10 16:33:58.391668+00	\N	1	Мария Иванова
5	admin@example.com	demo_hash_005	+79990000005	2026-10-10 16:33:58.391668+00	\N	2	Алексей Орлов
\.


--
-- Name: booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.booking_id_seq', 7, true);


--
-- Name: booking_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.booking_status_id_seq', 6, true);


--
-- Name: document_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.document_type_id_seq', 3, true);


--
-- Name: gender_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.gender_id_seq', 2, true);


--
-- Name: notification_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.notification_log_id_seq', 2, true);


--
-- Name: notification_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.notification_template_id_seq', 3, true);


--
-- Name: passengers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.passengers_id_seq', 5, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.payment_id_seq', 5, true);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.payment_methods_id_seq', 2, true);


--
-- Name: payment_provider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.payment_provider_id_seq', 5, true);


--
-- Name: payment_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.payment_status_id_seq', 6, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.role_id_seq', 2, true);


--
-- Name: route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.route_id_seq', 5, true);


--
-- Name: station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.station_id_seq', 5, true);


--
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.ticket_id_seq', 11, true);


--
-- Name: train_operator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.train_operator_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (id);


--
-- Name: booking_status booking_status_code_key; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.booking_status
    ADD CONSTRAINT booking_status_code_key UNIQUE (code);


--
-- Name: booking_status booking_status_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.booking_status
    ADD CONSTRAINT booking_status_pkey PRIMARY KEY (id);


--
-- Name: document_type document_type_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.document_type
    ADD CONSTRAINT document_type_pkey PRIMARY KEY (id);


--
-- Name: gender gender_code_key; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.gender
    ADD CONSTRAINT gender_code_key UNIQUE (code);


--
-- Name: gender gender_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id);


--
-- Name: passengers passengers_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_code_key; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_code_key UNIQUE (code);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_status payment_status_code_key; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment_status
    ADD CONSTRAINT payment_status_code_key UNIQUE (code);


--
-- Name: payment_status payment_status_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment_status
    ADD CONSTRAINT payment_status_pkey PRIMARY KEY (id);


--
-- Name: notification_log pk_notification_log; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.notification_log
    ADD CONSTRAINT pk_notification_log PRIMARY KEY (id);


--
-- Name: notification_template pk_notification_template; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.notification_template
    ADD CONSTRAINT pk_notification_template PRIMARY KEY (id);


--
-- Name: role role_code_key; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_code_key UNIQUE (code);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: route route_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (id);


--
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: train_operator train_operator_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.train_operator
    ADD CONSTRAINT train_operator_pkey PRIMARY KEY (id);


--
-- Name: notification_template uq_notification_template_name; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.notification_template
    ADD CONSTRAINT uq_notification_template_name UNIQUE (name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: booking fk_booking_status; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT fk_booking_status FOREIGN KEY (status_id) REFERENCES public.booking_status(id);


--
-- Name: booking fk_booking_user; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notification_log fk_notification_template; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.notification_log
    ADD CONSTRAINT fk_notification_template FOREIGN KEY (template_id) REFERENCES public.notification_template(id);


--
-- Name: passengers fk_passenger_document_type; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT fk_passenger_document_type FOREIGN KEY (document_type_id) REFERENCES public.document_type(id);


--
-- Name: passengers fk_passenger_gender; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT fk_passenger_gender FOREIGN KEY (gender_id) REFERENCES public.gender(id);


--
-- Name: passengers fk_passenger_user; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT fk_passenger_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payment fk_payment_booking; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES public.booking(id);


--
-- Name: payment fk_payment_method; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: payment_provider fk_payment_provider_method; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT fk_payment_provider_method FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: payment fk_payment_status; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_status FOREIGN KEY (status_id) REFERENCES public.payment_status(id);


--
-- Name: route fk_route_arrival; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.route
    ADD CONSTRAINT fk_route_arrival FOREIGN KEY (arrival_station_id) REFERENCES public.station(id);


--
-- Name: route fk_route_departure; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.route
    ADD CONSTRAINT fk_route_departure FOREIGN KEY (departure_station_id) REFERENCES public.station(id);


--
-- Name: ticket fk_ticket_booking; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_booking FOREIGN KEY (booking_id) REFERENCES public.booking(id);


--
-- Name: ticket fk_ticket_provider; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_provider FOREIGN KEY (provider_id) REFERENCES public.train_operator(id);


--
-- Name: ticket fk_ticket_user; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users fk_users_role; Type: FK CONSTRAINT; Schema: public; Owner: test
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_role FOREIGN KEY (role) REFERENCES public.role(id);


--
-- PostgreSQL database dump complete
--

\unrestrict xqT48lgCUOukyo7rZUAPFuXdWlOlQP9TuZKYpavri6sx0Ag9i3nqeDNZswuAJez

