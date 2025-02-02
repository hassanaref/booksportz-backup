PGDMP  "                    |        
   booksportz    15.5    16.3 �   %           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            &           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            '           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            (           1262    16399 
   booksportz    DATABASE     v   CREATE DATABASE booksportz WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
    DROP DATABASE booksportz;
                abdelelbouhy    false                        3079    18516    fuzzystrmatch 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;
    DROP EXTENSION fuzzystrmatch;
                   false            )           0    0    EXTENSION fuzzystrmatch    COMMENT     ]   COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';
                        false    2                        3079    18527    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                   false            *           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                        false    3            j           1247    16775    applications_status_enum    TYPE     u   CREATE TYPE public.applications_status_enum AS ENUM (
    'PENDING_CONFIRMATION',
    'CANCELLED',
    'ACCEPTED'
);
 +   DROP TYPE public.applications_status_enum;
       public          abdelelbouhy    false            @           1247    16620    inquiries_status_enum    TYPE     Z   CREATE TYPE public.inquiries_status_enum AS ENUM (
    'NEW',
    'OPEN',
    'SOLVED'
);
 (   DROP TYPE public.inquiries_status_enum;
       public          abdelelbouhy    false            �           1247    18089    itemRequests_item_type_enum    TYPE     �   CREATE TYPE public."itemRequests_item_type_enum" AS ENUM (
    'SERVICE',
    'COURSE',
    'BOAt',
    'SCHEDULE',
    'TRIP',
    'BRANCH',
    'BANK'
);
 0   DROP TYPE public."itemRequests_item_type_enum";
       public          abdelelbouhy    false            p           1247    16804    itemRequests_status_enum    TYPE     �   CREATE TYPE public."itemRequests_status_enum" AS ENUM (
    'PENDING_CONFIRMATION',
    'ACCEPTED',
    'REJECTED',
    'SOLVED'
);
 -   DROP TYPE public."itemRequests_status_enum";
       public          abdelelbouhy    false            v           1247    16826    notifications_type_enum    TYPE       CREATE TYPE public.notifications_type_enum AS ENUM (
    'PENDING_CONFIRMATION',
    'CANCELLED',
    'REJECTED',
    'CONFIRMED',
    'COMPLETED',
    'REVIEW',
    'ADMIN',
    'APPLICATION',
    'INQUIRY',
    'REQUEST',
    'INQUIRY_RESOLVE',
    'POINTS'
);
 *   DROP TYPE public.notifications_type_enum;
       public          abdelelbouhy    false            |           1247    16862    reservations_status_enum    TYPE     �   CREATE TYPE public.reservations_status_enum AS ENUM (
    'PENDING_CONFIRMATION',
    'CANCELLED',
    'REJECTED',
    'CONFIRMED',
    'COMPLETED',
    'INCART',
    'REJECTED_BY_ADMIN',
    'CANCELLED_BY_ADMIN',
    'CANCELLED_CONFIRMED'
);
 +   DROP TYPE public.reservations_status_enum;
       public          abdelelbouhy    false            d           1247    16757    transactions_status_enum    TYPE     X   CREATE TYPE public.transactions_status_enum AS ENUM (
    'EXECUTED',
    'REFUNDED'
);
 +   DROP TYPE public.transactions_status_enum;
       public          abdelelbouhy    false            m           1255    17684 4   address_in_range(numeric, numeric, numeric, numeric)    FUNCTION     �  CREATE FUNCTION public.address_in_range(lat1 numeric, lng1 numeric, lat2 numeric, lng2 numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$

	DECLARE 
	a NUMERIC;
	b NUMERIC;
	c NUMERIC;
	d NUMERIC;
BEGIN
	a :=((SELECT cos(lat1 * (select pi()) / 180)) * (SELECT cos(lat2 * (select pi()) / 180)) * (SELECT cos(lng1 * (select pi()) / 180)) * (SELECT cos(lng2 * (select pi()) / 180)));
 	b :=((SELECT cos(lat1 * (select pi()) / 180)) * (SELECT sin(lng1 * (select pi()) / 180)) * (SELECT cos(lat2 * (select pi()) / 180)) * (SELECT sin(lng2 * (select pi()) / 180)));
 	c :=((SELECT sin(lat1 * (select pi()) / 180)) * (SELECT sin(lat2 * (select pi()) / 180)));
 	d :=((SELECT acos(a + b + c)) * 6370);
 RETURN d;
end
$$;
 _   DROP FUNCTION public.address_in_range(lat1 numeric, lng1 numeric, lat2 numeric, lng2 numeric);
       public          abdelelbouhy    false            n           1255    17685 +   currencyexchange(integer, integer, numeric)    FUNCTION     l  CREATE FUNCTION public.currencyexchange(firstc integer, secondc integer, price numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
 DECLARE A NUMERIC; B NUMERIC; BEGIN A :=
	(SELECT EXCHANGES.RATIO
		FROM EXCHANGES
		WHERE EXCHANGES."firstC" = FIRSTC
			AND EXCHANGES."secondC" = SECONDC);
			
			B := (PRICE * A );
			RETURN B;
			
			END
			
$$;
 W   DROP FUNCTION public.currencyexchange(firstc integer, secondc integer, price numeric);
       public          abdelelbouhy    false            o           1255    17686 /   totalreview(anyelement, anyelement, anyelement)    FUNCTION     �  CREATE FUNCTION public.totalreview(anyelement, anyelement, anyelement) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$

	DECLARE 
	a NUMERIC;
	b NUMERIC;
	BEGIN
	b := count(1) from public."reviews" where (reviews.service_id in($1) or reviews.service_id is null) and (reviews.course_id in($2) or reviews.course_id is null) and (reviews.boat_id in($3) or reviews.boat_id is null);
	a := trunc(((select sum(rate) from public."reviews" where (reviews.service_id in($1) or reviews.service_id is null) and (reviews.course_id in($2) or reviews.course_id is null) and (reviews.boat_id in($3) or reviews.boat_id is null)) * 5) / (b * 5));
	if a is null then a := 0;
	end if;
	return a;
	end
$_$;
 F   DROP FUNCTION public.totalreview(anyelement, anyelement, anyelement);
       public          abdelelbouhy    false            H           1259    17143    accommodations    TABLE     �  CREATE TABLE public.accommodations (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    cancellation_policy character varying(255) NOT NULL,
    checkin character varying NOT NULL,
    checkout character varying NOT NULL,
    description character varying(255) NOT NULL,
    no_of_beds integer NOT NULL,
    no_of_guest integer NOT NULL,
    spaces_available integer NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    address_id integer,
    user_id integer,
    trip_id integer NOT NULL
);
 "   DROP TABLE public.accommodations;
       public         heap    abdelelbouhy    false            G           1259    17142    accommodations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.accommodations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.accommodations_id_seq;
       public          abdelelbouhy    false    328            +           0    0    accommodations_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.accommodations_id_seq OWNED BY public.accommodations.id;
          public          abdelelbouhy    false    327            6           1259    17032 
   activities    TABLE     �  CREATE TABLE public.activities (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    trending_score integer DEFAULT 0 NOT NULL,
    name character varying(255) NOT NULL,
    image character varying(1024),
    category_id integer,
    boat_id integer,
    "cityId" integer,
    city_id integer,
    splits character varying[]
);
    DROP TABLE public.activities;
       public         heap    abdelelbouhy    false            5           1259    17031    activities_id_seq    SEQUENCE     �   CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.activities_id_seq;
       public          abdelelbouhy    false    310            ,           0    0    activities_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;
          public          abdelelbouhy    false    309            R           1259    17716    activity_log    TABLE     +  CREATE TABLE public.activity_log (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer,
    key character varying(50) NOT NULL,
    old_value jsonb,
    new_value jsonb
);
     DROP TABLE public.activity_log;
       public         heap    abdelelbouhy    false            Q           1259    17715    activity_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.activity_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.activity_log_id_seq;
       public          abdelelbouhy    false    338            -           0    0    activity_log_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.activity_log_id_seq OWNED BY public.activity_log.id;
          public          abdelelbouhy    false    337            F           1259    17124 	   addresses    TABLE     s  CREATE TABLE public.addresses (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    number character varying(255),
    street character varying(255),
    city character varying(255),
    postcode character varying(255),
    district character varying(255),
    lat character varying(255),
    lng character varying(255),
    "timeZone" character varying,
    service_id integer,
    course_id integer,
    company_id integer,
    country_id integer DEFAULT 60,
    boat_id integer,
    place_id character varying
);
    DROP TABLE public.addresses;
       public         heap    abdelelbouhy    false            E           1259    17123    addresses_id_seq    SEQUENCE     �   CREATE SEQUENCE public.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.addresses_id_seq;
       public          abdelelbouhy    false    326            .           0    0    addresses_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;
          public          abdelelbouhy    false    325            <           1259    17067 	   amenities    TABLE     >  CREATE TABLE public.amenities (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    accommodation_id integer,
    service_id integer,
    image character varying
);
    DROP TABLE public.amenities;
       public         heap    abdelelbouhy    false            ;           1259    17066    amenities_id_seq    SEQUENCE     �   CREATE SEQUENCE public.amenities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.amenities_id_seq;
       public          abdelelbouhy    false    316            /           0    0    amenities_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.amenities_id_seq OWNED BY public.amenities.id;
          public          abdelelbouhy    false    315            J           1259    17156    applicationVisits    TABLE     ~   CREATE TABLE public."applicationVisits" (
    id integer NOT NULL,
    day timestamp without time zone,
    visits integer
);
 '   DROP TABLE public."applicationVisits";
       public         heap    abdelelbouhy    false            I           1259    17155    applicationVisits_id_seq    SEQUENCE     �   CREATE SEQUENCE public."applicationVisits_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."applicationVisits_id_seq";
       public          abdelelbouhy    false    330            0           0    0    applicationVisits_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."applicationVisits_id_seq" OWNED BY public."applicationVisits".id;
          public          abdelelbouhy    false    329                       1259    16782    applications    TABLE     3  CREATE TABLE public.applications (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    status public.applications_status_enum NOT NULL,
    "assignedUser" integer
);
     DROP TABLE public.applications;
       public         heap    abdelelbouhy    false    1130                       1259    16781    applications_id_seq    SEQUENCE     �   CREATE SEQUENCE public.applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.applications_id_seq;
       public          abdelelbouhy    false    278            1           0    0    applications_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.applications_id_seq OWNED BY public.applications.id;
          public          abdelelbouhy    false    277            \           1259    18671    available_amenities    TABLE       CREATE TABLE public.available_amenities (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    image character varying
);
 '   DROP TABLE public.available_amenities;
       public         heap    abdelelbouhy    false            [           1259    18670    available_amenities_id_seq    SEQUENCE     �   CREATE SEQUENCE public.available_amenities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.available_amenities_id_seq;
       public          abdelelbouhy    false    348            2           0    0    available_amenities_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.available_amenities_id_seq OWNED BY public.available_amenities.id;
          public          abdelelbouhy    false    347            �            1259    16494    banks    TABLE     2  CREATE TABLE public.banks (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    currency_id integer,
    card_holder_name character varying(255),
    account_number character varying(255),
    iban_number character varying(255),
    swift_code character varying(255),
    branch_number character varying(255),
    branch_name character varying(255),
    full_name character varying(255),
    email_address character varying(255),
    phone_number character varying(255),
    mobile_number character varying(255),
    refund_policy character varying(3000),
    account_nationality character varying,
    status character varying DEFAULT 'ENABLED'::character varying NOT NULL
);
    DROP TABLE public.banks;
       public         heap    abdelelbouhy    false            �            1259    16493    banks_id_seq    SEQUENCE     �   CREATE SEQUENCE public.banks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.banks_id_seq;
       public          abdelelbouhy    false    226            3           0    0    banks_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.banks_id_seq OWNED BY public.banks.id;
          public          abdelelbouhy    false    225            B           1259    17104    boatActivity    TABLE     �   CREATE TABLE public."boatActivity" (
    id integer NOT NULL,
    boat_id integer NOT NULL,
    activity_id integer NOT NULL
);
 "   DROP TABLE public."boatActivity";
       public         heap    abdelelbouhy    false            A           1259    17103    boatActivity_id_seq    SEQUENCE     �   CREATE SEQUENCE public."boatActivity_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."boatActivity_id_seq";
       public          abdelelbouhy    false    322            4           0    0    boatActivity_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."boatActivity_id_seq" OWNED BY public."boatActivity".id;
          public          abdelelbouhy    false    321            �            1259    16471    boatEquipments    TABLE     �  CREATE TABLE public."boatEquipments" (
    id integer NOT NULL,
    boat_id integer,
    title character varying(60),
    description character varying(1200),
    per_day_price double precision,
    currency_id integer,
    no_of_equipments integer,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    foreigner_per_day_price numeric,
    foreigner_currency_id integer
);
 $   DROP TABLE public."boatEquipments";
       public         heap    abdelelbouhy    false            �            1259    16470    boatEquipments_id_seq    SEQUENCE     �   CREATE SEQUENCE public."boatEquipments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."boatEquipments_id_seq";
       public          abdelelbouhy    false    222            5           0    0    boatEquipments_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."boatEquipments_id_seq" OWNED BY public."boatEquipments".id;
          public          abdelelbouhy    false    221                       1259    16690    boatFeatures    TABLE       CREATE TABLE public."boatFeatures" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    sea_safari_id integer
);
 "   DROP TABLE public."boatFeatures";
       public         heap    abdelelbouhy    false                       1259    16689    boatFeatures_id_seq    SEQUENCE     �   CREATE SEQUENCE public."boatFeatures_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."boatFeatures_id_seq";
       public          abdelelbouhy    false    262            6           0    0    boatFeatures_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."boatFeatures_id_seq" OWNED BY public."boatFeatures".id;
          public          abdelelbouhy    false    261                       1259    16699 
   boatSafety    TABLE     	  CREATE TABLE public."boatSafety" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    type character varying(255) NOT NULL,
    sea_safari_id integer
);
     DROP TABLE public."boatSafety";
       public         heap    abdelelbouhy    false                       1259    16698    boatSafety_id_seq    SEQUENCE     �   CREATE SEQUENCE public."boatSafety_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."boatSafety_id_seq";
       public          abdelelbouhy    false    264            7           0    0    boatSafety_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."boatSafety_id_seq" OWNED BY public."boatSafety".id;
          public          abdelelbouhy    false    263            D           1259    17111    boats    TABLE     	  CREATE TABLE public.boats (
    id integer NOT NULL,
    user_id integer,
    title character varying(50) NOT NULL,
    description character varying(1200) NOT NULL,
    "isFavorite" boolean DEFAULT false,
    city_id integer,
    provider_id integer,
    length character varying(255),
    width character varying(255),
    no_of_cabins integer,
    no_of_engines integer,
    number_of_guests integer,
    fresh_water_maker character varying(255),
    top_speed character varying(255),
    features text[],
    navigation_and_safety text[],
    status character varying DEFAULT 'UNAPPROVED'::character varying NOT NULL,
    pending jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.boats;
       public         heap    abdelelbouhy    false            C           1259    17110    boats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.boats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.boats_id_seq;
       public          abdelelbouhy    false    324            8           0    0    boats_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.boats_id_seq OWNED BY public.boats.id;
          public          abdelelbouhy    false    323            �            1259    16516    branchCourse    TABLE       CREATE TABLE public."branchCourse" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    course_id integer NOT NULL,
    branch_id integer NOT NULL,
    city_id integer
);
 "   DROP TABLE public."branchCourse";
       public         heap    abdelelbouhy    false            �            1259    16515    branchCourse_id_seq    SEQUENCE     �   CREATE SEQUENCE public."branchCourse_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."branchCourse_id_seq";
       public          abdelelbouhy    false    230            9           0    0    branchCourse_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."branchCourse_id_seq" OWNED BY public."branchCourse".id;
          public          abdelelbouhy    false    229            L           1259    17163    branchEquipmentRental    TABLE       CREATE TABLE public."branchEquipmentRental" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    equipment_rental_id integer NOT NULL,
    branch_id integer NOT NULL
);
 +   DROP TABLE public."branchEquipmentRental";
       public         heap    abdelelbouhy    false            K           1259    17162    branchEquipmentRental_id_seq    SEQUENCE     �   CREATE SEQUENCE public."branchEquipmentRental_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."branchEquipmentRental_id_seq";
       public          abdelelbouhy    false    332            :           0    0    branchEquipmentRental_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."branchEquipmentRental_id_seq" OWNED BY public."branchEquipmentRental".id;
          public          abdelelbouhy    false    331            8           1259    17044    branchService    TABLE       CREATE TABLE public."branchService" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    service_id integer,
    branch_id integer,
    city_id integer
);
 #   DROP TABLE public."branchService";
       public         heap    abdelelbouhy    false            7           1259    17043    branchService_id_seq    SEQUENCE     �   CREATE SEQUENCE public."branchService_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."branchService_id_seq";
       public          abdelelbouhy    false    312            ;           0    0    branchService_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."branchService_id_seq" OWNED BY public."branchService".id;
          public          abdelelbouhy    false    311            0           1259    17000 
   branchTrip    TABLE       CREATE TABLE public."branchTrip" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    trip_id integer NOT NULL,
    branch_id integer NOT NULL
);
     DROP TABLE public."branchTrip";
       public         heap    abdelelbouhy    false            /           1259    16999    branchTrip_id_seq    SEQUENCE     �   CREATE SEQUENCE public."branchTrip_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."branchTrip_id_seq";
       public          abdelelbouhy    false    304            <           0    0    branchTrip_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."branchTrip_id_seq" OWNED BY public."branchTrip".id;
          public          abdelelbouhy    false    303            .           1259    16986    branches    TABLE     �  CREATE TABLE public.branches (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    user_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    address_id integer NOT NULL,
    city_id integer,
    status character varying NOT NULL,
    sub_city_id integer
);
    DROP TABLE public.branches;
       public         heap    abdelelbouhy    false            -           1259    16985    branches_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.branches_id_seq;
       public          abdelelbouhy    false    302            =           0    0    branches_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;
          public          abdelelbouhy    false    301            �            1259    16483 
   categories    TABLE       CREATE TABLE public.categories (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    image character varying(512)
);
    DROP TABLE public.categories;
       public         heap    abdelelbouhy    false            �            1259    16482    categories_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.categories_id_seq;
       public          abdelelbouhy    false    224            >           0    0    categories_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;
          public          abdelelbouhy    false    223            4           1259    17021    cities    TABLE     �  CREATE TABLE public.cities (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    city_name character varying(255) NOT NULL,
    governorate_name character varying(255),
    photo character varying(512),
    city_code character varying(255),
    lat character varying,
    lng character varying,
    "isFavorite" boolean,
    place_id character varying
);
    DROP TABLE public.cities;
       public         heap    abdelelbouhy    false            3           1259    17020    cities_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.cities_id_seq;
       public          abdelelbouhy    false    308            ?           0    0    cities_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;
          public          abdelelbouhy    false    307            �            1259    16505 	   companies    TABLE     1  CREATE TABLE public.companies (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    address_id integer,
    name character varying(255),
    logo character varying(255),
    trade_license_no character varying(255),
    tax_license_no character varying(255),
    certificate character varying(255),
    contact_email character varying(255),
    contact_phone character varying(255),
    contact_details jsonb,
    license_no character varying(255)
);
    DROP TABLE public.companies;
       public         heap    abdelelbouhy    false            �            1259    16504    companies_id_seq    SEQUENCE     �   CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.companies_id_seq;
       public          abdelelbouhy    false    228            @           0    0    companies_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;
          public          abdelelbouhy    false    227                       1259    16719 	   countries    TABLE     2  CREATE TABLE public.countries (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(255),
    dial_code character varying(255)
);
    DROP TABLE public.countries;
       public         heap    abdelelbouhy    false                       1259    16718    countries_id_seq    SEQUENCE     �   CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.countries_id_seq;
       public          abdelelbouhy    false    268            A           0    0    countries_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;
          public          abdelelbouhy    false    267            *           1259    16953    courses    TABLE     �  CREATE TABLE public.courses (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    title character varying(50) NOT NULL,
    description character varying(1200) NOT NULL,
    user_id integer NOT NULL,
    provider_id integer,
    category_id integer,
    activity_id integer NOT NULL,
    "cityId" integer,
    languages text[] NOT NULL,
    prerequisites text[],
    organization character varying(255),
    "isFavorite" boolean DEFAULT false,
    status character varying DEFAULT 'UNAPPROVED'::character varying NOT NULL,
    pending jsonb,
    city_id integer
);
    DROP TABLE public.courses;
       public         heap    abdelelbouhy    false            )           1259    16952    courses_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.courses_id_seq;
       public          abdelelbouhy    false    298            B           0    0    courses_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;
          public          abdelelbouhy    false    297            d           1259    18973    court    TABLE     2  CREATE TABLE public.court (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying,
    "scheduleId" integer NOT NULL,
    solo boolean DEFAULT false,
    space_id integer
);
    DROP TABLE public.court;
       public         heap    abdelelbouhy    false            c           1259    18972    court_id_seq    SEQUENCE     �   CREATE SEQUENCE public.court_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.court_id_seq;
       public          abdelelbouhy    false    356            C           0    0    court_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.court_id_seq OWNED BY public.court.id;
          public          abdelelbouhy    false    355            �            1259    16460 
   currencies    TABLE     @  CREATE TABLE public.currencies (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    logo character varying(512) NOT NULL
);
    DROP TABLE public.currencies;
       public         heap    abdelelbouhy    false            �            1259    16459    currencies_id_seq    SEQUENCE     �   CREATE SEQUENCE public.currencies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.currencies_id_seq;
       public          abdelelbouhy    false    220            D           0    0    currencies_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.currencies_id_seq OWNED BY public.currencies.id;
          public          abdelelbouhy    false    219            f           1259    19000    custom_payment_options    TABLE     .  CREATE TABLE public.custom_payment_options (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    item_type character varying,
    item_id integer
);
 *   DROP TABLE public.custom_payment_options;
       public         heap    abdelelbouhy    false            e           1259    18999    custom_payment_options_id_seq    SEQUENCE     �   CREATE SEQUENCE public.custom_payment_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.custom_payment_options_id_seq;
       public          abdelelbouhy    false    358            E           0    0    custom_payment_options_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.custom_payment_options_id_seq OWNED BY public.custom_payment_options.id;
          public          abdelelbouhy    false    357            b           1259    18962    custom_per_hour_day    TABLE     k  CREATE TABLE public.custom_per_hour_day (
    id integer NOT NULL,
    name character varying,
    "startTime" character varying,
    "endTime" character varying,
    "courtId" integer,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    availability boolean DEFAULT true
);
 '   DROP TABLE public.custom_per_hour_day;
       public         heap    abdelelbouhy    false            a           1259    18961    custom_per_hour_day_id_seq    SEQUENCE     �   CREATE SEQUENCE public.custom_per_hour_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.custom_per_hour_day_id_seq;
       public          abdelelbouhy    false    354            F           0    0    custom_per_hour_day_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.custom_per_hour_day_id_seq OWNED BY public.custom_per_hour_day.id;
          public          abdelelbouhy    false    353            �            1259    16572    devices    TABLE     �   CREATE TABLE public.devices (
    id integer NOT NULL,
    user_id integer NOT NULL,
    device_id character varying NOT NULL,
    token character varying NOT NULL
);
    DROP TABLE public.devices;
       public         heap    abdelelbouhy    false            �            1259    16571    devices_id_seq    SEQUENCE     �   CREATE SEQUENCE public.devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.devices_id_seq;
       public          abdelelbouhy    false    242            G           0    0    devices_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;
          public          abdelelbouhy    false    241                       1259    16730    equipmentRentals    TABLE     �   CREATE TABLE public."equipmentRentals" (
    id integer NOT NULL,
    item_id integer,
    equipment_id integer,
    name character varying(255) NOT NULL
);
 &   DROP TABLE public."equipmentRentals";
       public         heap    abdelelbouhy    false                       1259    16729    equipmentRentals_id_seq    SEQUENCE     �   CREATE SEQUENCE public."equipmentRentals_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."equipmentRentals_id_seq";
       public          abdelelbouhy    false    270            H           0    0    equipmentRentals_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."equipmentRentals_id_seq" OWNED BY public."equipmentRentals".id;
          public          abdelelbouhy    false    269            N           1259    17172 	   exchanges    TABLE     �   CREATE TABLE public.exchanges (
    id integer NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    "firstC" integer NOT NULL,
    "secondC" integer NOT NULL,
    ratio numeric NOT NULL
);
    DROP TABLE public.exchanges;
       public         heap    abdelelbouhy    false            M           1259    17171    exchanges_id_seq    SEQUENCE     �   CREATE SEQUENCE public.exchanges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.exchanges_id_seq;
       public          abdelelbouhy    false    334            I           0    0    exchanges_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.exchanges_id_seq OWNED BY public.exchanges.id;
          public          abdelelbouhy    false    333            ^           1259    18682    excludes    TABLE        CREATE TABLE public.excludes (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    item_type character varying,
    item_id integer
);
    DROP TABLE public.excludes;
       public         heap    abdelelbouhy    false            ]           1259    18681    excludes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.excludes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.excludes_id_seq;
       public          abdelelbouhy    false    350            J           0    0    excludes_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.excludes_id_seq OWNED BY public.excludes.id;
          public          abdelelbouhy    false    349            �            1259    16545    favorite    TABLE     7  CREATE TABLE public.favorite (
    id integer NOT NULL,
    user_id integer NOT NULL,
    course_id integer,
    boat_id integer,
    service_id integer,
    city_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.favorite;
       public         heap    abdelelbouhy    false            �            1259    16544    favorite_id_seq    SEQUENCE     �   CREATE SEQUENCE public.favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.favorite_id_seq;
       public          abdelelbouhy    false    236            K           0    0    favorite_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.favorite_id_seq OWNED BY public.favorite.id;
          public          abdelelbouhy    false    235            �            1259    16597    group_permission    TABLE     �   CREATE TABLE public.group_permission (
    id integer NOT NULL,
    "group_Id" integer NOT NULL,
    permission_id integer NOT NULL
);
 $   DROP TABLE public.group_permission;
       public         heap    abdelelbouhy    false            �            1259    16596    group_permission_id_seq    SEQUENCE     �   CREATE SEQUENCE public.group_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.group_permission_id_seq;
       public          abdelelbouhy    false    248            L           0    0    group_permission_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.group_permission_id_seq OWNED BY public.group_permission.id;
          public          abdelelbouhy    false    247            �            1259    16588    groups    TABLE     �   CREATE TABLE public.groups (
    id integer NOT NULL,
    color character varying NOT NULL,
    name character varying NOT NULL,
    company_id integer
);
    DROP TABLE public.groups;
       public         heap    abdelelbouhy    false            �            1259    16587    groups_id_seq    SEQUENCE     �   CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.groups_id_seq;
       public          abdelelbouhy    false    246            M           0    0    groups_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;
          public          abdelelbouhy    false    245            �            1259    16525    guest    TABLE     �   CREATE TABLE public.guest (
    id integer NOT NULL,
    title character varying,
    first_name character varying,
    last_name character varying,
    "reservationId" integer
);
    DROP TABLE public.guest;
       public         heap    abdelelbouhy    false            �            1259    16524    guest_id_seq    SEQUENCE     �   CREATE SEQUENCE public.guest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.guest_id_seq;
       public          abdelelbouhy    false    232            N           0    0    guest_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.guest_id_seq OWNED BY public.guest.id;
          public          abdelelbouhy    false    231            �            1259    16628 	   inquiries    TABLE     �  CREATE TABLE public.inquiries (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    type character varying,
    subject character varying(800),
    message character varying(800),
    user_id integer,
    "assignedGroupId" integer,
    status public.inquiries_status_enum DEFAULT 'NEW'::public.inquiries_status_enum NOT NULL,
    resolution character varying
);
    DROP TABLE public.inquiries;
       public         heap    abdelelbouhy    false    1088    1088            �            1259    16627    inquiries_id_seq    SEQUENCE     �   CREATE SEQUENCE public.inquiries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.inquiries_id_seq;
       public          abdelelbouhy    false    254            O           0    0    inquiries_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.inquiries_id_seq OWNED BY public.inquiries.id;
          public          abdelelbouhy    false    253                       1259    16814    itemRequests    TABLE     �  CREATE TABLE public."itemRequests" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    item_id integer NOT NULL,
    user_id integer NOT NULL,
    item_type public."itemRequests_item_type_enum" NOT NULL,
    status public."itemRequests_status_enum" NOT NULL,
    type character varying DEFAULT 'UPDATE'::character varying NOT NULL,
    assigned_user integer
);
 "   DROP TABLE public."itemRequests";
       public         heap    abdelelbouhy    false    1241    1136                       1259    16813    itemRequests_id_seq    SEQUENCE     �   CREATE SEQUENCE public."itemRequests_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."itemRequests_id_seq";
       public          abdelelbouhy    false    280            P           0    0    itemRequests_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."itemRequests_id_seq" OWNED BY public."itemRequests".id;
          public          abdelelbouhy    false    279            "           1259    16911 	   itemTimes    TABLE     +  CREATE TABLE public."itemTimes" (
    id integer NOT NULL,
    item_id integer,
    "startTime" timestamp with time zone,
    "endTime" timestamp with time zone,
    reservation_item_id integer,
    external_reserve boolean DEFAULT false,
    imported_reserve boolean,
    appointment_id integer
);
    DROP TABLE public."itemTimes";
       public         heap    abdelelbouhy    false            !           1259    16910    itemTimes_id_seq    SEQUENCE     �   CREATE SEQUENCE public."itemTimes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."itemTimes_id_seq";
       public          abdelelbouhy    false    290            Q           0    0    itemTimes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."itemTimes_id_seq" OWNED BY public."itemTimes".id;
          public          abdelelbouhy    false    289            P           1259    17696    loyalty_program    TABLE     �  CREATE TABLE public.loyalty_program (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    points numeric,
    user_id integer,
    parent_user_id integer,
    reservation_id integer,
    parent_user_type character varying,
    withdrawn boolean DEFAULT false,
    redeemed boolean DEFAULT false
);
 #   DROP TABLE public.loyalty_program;
       public         heap    abdelelbouhy    false            O           1259    17695    loyalty_program_id_seq    SEQUENCE     �   CREATE SEQUENCE public.loyalty_program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.loyalty_program_id_seq;
       public          abdelelbouhy    false    336            R           0    0    loyalty_program_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.loyalty_program_id_seq OWNED BY public.loyalty_program.id;
          public          abdelelbouhy    false    335            T           1259    17727    loyalty_program_withdraws    TABLE       CREATE TABLE public.loyalty_program_withdraws (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    points numeric,
    user_id integer,
    reservation_id integer
);
 -   DROP TABLE public.loyalty_program_withdraws;
       public         heap    abdelelbouhy    false            S           1259    17726     loyalty_program_withdraws_id_seq    SEQUENCE     �   CREATE SEQUENCE public.loyalty_program_withdraws_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.loyalty_program_withdraws_id_seq;
       public          abdelelbouhy    false    340            S           0    0     loyalty_program_withdraws_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.loyalty_program_withdraws_id_seq OWNED BY public.loyalty_program_withdraws.id;
          public          abdelelbouhy    false    339            �            1259    16446 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    abdelelbouhy    false            �            1259    16445    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          abdelelbouhy    false    217            T           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          abdelelbouhy    false    216                       1259    16850    notifications    TABLE     )  CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer,
    message character varying NOT NULL,
    reservation_id integer,
    review_id integer,
    request_id integer,
    "itemType" character varying,
    "itemId" integer,
    type public.notifications_type_enum NOT NULL,
    "toAllUsers" boolean,
    "toAllProviders" boolean,
    "toAllAdmins" boolean,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    "Seen" boolean DEFAULT false,
    cleared boolean DEFAULT false,
    redirect character varying
);
 !   DROP TABLE public.notifications;
       public         heap    abdelelbouhy    false    1142                       1259    16849    notifications_id_seq    SEQUENCE     �   CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public          abdelelbouhy    false    282            U           0    0    notifications_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;
          public          abdelelbouhy    false    281            
           1259    16708    organizations    TABLE     �   CREATE TABLE public.organizations (
    id integer NOT NULL,
    course_id integer,
    name character varying,
    status character varying
);
 !   DROP TABLE public.organizations;
       public         heap    abdelelbouhy    false            	           1259    16707    organizations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.organizations_id_seq;
       public          abdelelbouhy    false    266            V           0    0    organizations_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;
          public          abdelelbouhy    false    265            �            1259    16554 
   payMethods    TABLE     �  CREATE TABLE public."payMethods" (
    id integer NOT NULL,
    wallet_id integer,
    user_id integer,
    save_order_id character varying,
    "save_order_Token" character varying,
    token character varying,
    masked_pan character varying,
    merchant_id character varying,
    card_subtype character varying,
    created_at character varying,
    email character varying,
    user_added boolean,
    nationality character varying,
    get_way character varying
);
     DROP TABLE public."payMethods";
       public         heap    abdelelbouhy    false            �            1259    16553    payMethods_id_seq    SEQUENCE     �   CREATE SEQUENCE public."payMethods_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."payMethods_id_seq";
       public          abdelelbouhy    false    238            W           0    0    payMethods_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."payMethods_id_seq" OWNED BY public."payMethods".id;
          public          abdelelbouhy    false    237            V           1259    17797    payment_way    TABLE       CREATE TABLE public.payment_way (
    id integer NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    image character varying NOT NULL,
    availability boolean NOT NULL,
    "getWay" character varying,
    nationality character varying NOT NULL
);
    DROP TABLE public.payment_way;
       public         heap    abdelelbouhy    false            U           1259    17796    payment_way_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_way_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment_way_id_seq;
       public          abdelelbouhy    false    342            X           0    0    payment_way_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.payment_way_id_seq OWNED BY public.payment_way.id;
          public          abdelelbouhy    false    341            `           1259    18951    per_hour_price_range    TABLE     d  CREATE TABLE public.per_hour_price_range (
    id integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "startTime" character varying,
    "endTime" character varying,
    "egyptianPrice" numeric,
    "foreignPrice" numeric,
    "egyptianDiscountPrice" numeric,
    "foreignDiscountPrice" numeric,
    "egyptianDiscountStartTime" timestamp without time zone,
    "egyptianDiscountEndTime" timestamp without time zone,
    "foreignDiscountStartTime" timestamp without time zone,
    "foreignDiscountEndTime" timestamp without time zone,
    "customPerHourDayId" integer,
    "egyptianCurrencyId" integer,
    "foreignCurrencyId" integer,
    "egyptianBulkPrice" numeric,
    "foreignBulkPrice" numeric,
    "minimumBulk" numeric,
    "offerBy" character varying
);
 (   DROP TABLE public.per_hour_price_range;
       public         heap    abdelelbouhy    false            _           1259    18950    per_hour_price_range_id_seq    SEQUENCE     �   CREATE SEQUENCE public.per_hour_price_range_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.per_hour_price_range_id_seq;
       public          abdelelbouhy    false    352            Y           0    0    per_hour_price_range_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.per_hour_price_range_id_seq OWNED BY public.per_hour_price_range.id;
          public          abdelelbouhy    false    351            �            1259    16611    permissions    TABLE     �   CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying NOT NULL,
    admin boolean,
    supplier boolean
);
    DROP TABLE public.permissions;
       public         heap    abdelelbouhy    false            �            1259    16610    permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          abdelelbouhy    false    252            Z           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          abdelelbouhy    false    251            (           1259    16942    prices    TABLE     U  CREATE TABLE public.prices (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    type character varying(9) NOT NULL,
    price numeric NOT NULL,
    discount_price numeric,
    discount_start timestamp with time zone,
    discount_end timestamp with time zone,
    currency_id integer,
    accommodation_id integer,
    course_id integer,
    equipment_rental_id integer,
    unit_id integer,
    service_id integer,
    trip_id integer,
    room_id integer,
    schedule_id integer
);
    DROP TABLE public.prices;
       public         heap    abdelelbouhy    false            '           1259    16941    prices_id_seq    SEQUENCE     �   CREATE SEQUENCE public.prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.prices_id_seq;
       public          abdelelbouhy    false    296            [           0    0    prices_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.prices_id_seq OWNED BY public.prices.id;
          public          abdelelbouhy    false    295                        1259    16640    pricingPlans    TABLE     �   CREATE TABLE public."pricingPlans" (
    id integer NOT NULL,
    name character varying NOT NULL,
    plan_features jsonb DEFAULT '{}'::jsonb NOT NULL,
    price numeric NOT NULL,
    limited_offer boolean
);
 "   DROP TABLE public."pricingPlans";
       public         heap    abdelelbouhy    false            �            1259    16639    pricingPlans_id_seq    SEQUENCE     �   CREATE SEQUENCE public."pricingPlans_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."pricingPlans_id_seq";
       public          abdelelbouhy    false    256            \           0    0    pricingPlans_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."pricingPlans_id_seq" OWNED BY public."pricingPlans".id;
          public          abdelelbouhy    false    255            j           1259    19576    provider_contact    TABLE     g  CREATE TABLE public.provider_contact (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255),
    phone_number character varying,
    user_id integer,
    provider_id integer,
    blocked boolean DEFAULT false NOT NULL
);
 $   DROP TABLE public.provider_contact;
       public         heap    abdelelbouhy    false            i           1259    19575    provider_contact_id_seq    SEQUENCE     �   CREATE SEQUENCE public.provider_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.provider_contact_id_seq;
       public          abdelelbouhy    false    362            ]           0    0    provider_contact_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.provider_contact_id_seq OWNED BY public.provider_contact.id;
          public          abdelelbouhy    false    361            h           1259    19030    recurrences    TABLE     '  CREATE TABLE public.recurrences (
    id integer NOT NULL,
    court_id integer,
    rule character varying,
    "startTime" timestamp with time zone,
    "endTime" timestamp with time zone,
    "endDate" timestamp with time zone,
    appointment_id integer,
    excludes character varying[]
);
    DROP TABLE public.recurrences;
       public         heap    abdelelbouhy    false            g           1259    19029    recurrences_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recurrences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.recurrences_id_seq;
       public          abdelelbouhy    false    360            ^           0    0    recurrences_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.recurrences_id_seq OWNED BY public.recurrences.id;
          public          abdelelbouhy    false    359                        1259    16900    reservationItem    TABLE     �  CREATE TABLE public."reservationItem" (
    id integer NOT NULL,
    type character varying NOT NULL,
    reservation_date timestamp with time zone,
    quantity integer,
    price numeric,
    discount_value numeric DEFAULT 0,
    discounted boolean DEFAULT false,
    "reservationId" integer,
    original_discount_start timestamp with time zone,
    original_discount_end timestamp with time zone
);
 %   DROP TABLE public."reservationItem";
       public         heap    abdelelbouhy    false                       1259    16899    reservationItem_id_seq    SEQUENCE     �   CREATE SEQUENCE public."reservationItem_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."reservationItem_id_seq";
       public          abdelelbouhy    false    288            _           0    0    reservationItem_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."reservationItem_id_seq" OWNED BY public."reservationItem".id;
          public          abdelelbouhy    false    287                       1259    16876    reservations    TABLE     #  CREATE TABLE public.reservations (
    id integer NOT NULL,
    order_id character varying,
    payment_success boolean,
    reservation_date timestamp with time zone,
    status public.reservations_status_enum DEFAULT 'PENDING_CONFIRMATION'::public.reservations_status_enum NOT NULL,
    type character varying NOT NULL,
    activity_type character varying NOT NULL,
    category_type character varying,
    branch_name character varying NOT NULL,
    "currencyId" integer,
    price numeric,
    discount_value numeric,
    price_type character varying,
    discounted boolean DEFAULT false,
    number_of_people integer NOT NULL,
    user_id integer NOT NULL,
    provider_id integer,
    trip_id integer,
    schedule_id integer,
    first_name character varying,
    last_name character varying,
    contact_email character varying,
    contact_number character varying,
    payment_method character varying,
    reserved_currency_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    "usedPoints" numeric DEFAULT 0 NOT NULL,
    "actualTotalAmount" numeric,
    original_discount_start timestamp with time zone,
    original_discount_end timestamp with time zone,
    admin_fees numeric DEFAULT '0'::numeric NOT NULL,
    admin_total numeric DEFAULT '0'::numeric NOT NULL,
    "admin_fees_In_user_currency" numeric DEFAULT '0'::numeric,
    "price_In_user_currency" numeric DEFAULT '0'::numeric,
    rejection_reason character varying,
    get_way character varying
);
     DROP TABLE public.reservations;
       public         heap    abdelelbouhy    false    1148    1148                       1259    16875    reservations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reservations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.reservations_id_seq;
       public          abdelelbouhy    false    284            `           0    0    reservations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;
          public          abdelelbouhy    false    283            �            1259    16534    reviews    TABLE     �  CREATE TABLE public.reviews (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    review character varying(800),
    title character varying(800),
    rate integer,
    service_id integer,
    course_id integer,
    boat_id integer,
    user_id integer,
    reply_on_id integer
);
    DROP TABLE public.reviews;
       public         heap    abdelelbouhy    false            �            1259    16533    reviews_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reviews_id_seq;
       public          abdelelbouhy    false    234            a           0    0    reviews_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;
          public          abdelelbouhy    false    233                       1259    16889 
   roomRental    TABLE     �   CREATE TABLE public."roomRental" (
    id integer NOT NULL,
    item_id integer,
    room_id integer,
    "noOfPeople" integer,
    room_price integer,
    trip_id integer,
    room_name character varying,
    external_reserve boolean DEFAULT false
);
     DROP TABLE public."roomRental";
       public         heap    abdelelbouhy    false                       1259    16888    roomRental_id_seq    SEQUENCE     �   CREATE SEQUENCE public."roomRental_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."roomRental_id_seq";
       public          abdelelbouhy    false    286            b           0    0    roomRental_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."roomRental_id_seq" OWNED BY public."roomRental".id;
          public          abdelelbouhy    false    285            @           1259    17092    rooms    TABLE     �  CREATE TABLE public.rooms (
    id integer NOT NULL,
    boat_id integer,
    type character varying(60) NOT NULL,
    description character varying(1200) NOT NULL,
    no_of_guests integer,
    rooms_on_board integer,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.rooms;
       public         heap    abdelelbouhy    false            ?           1259    17091    rooms_id_seq    SEQUENCE     �   CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.rooms_id_seq;
       public          abdelelbouhy    false    320            c           0    0    rooms_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;
          public          abdelelbouhy    false    319            $           1259    16920    scheduleItems    TABLE     �   CREATE TABLE public."scheduleItems" (
    id integer NOT NULL,
    name character varying,
    number integer,
    "order" integer,
    schedule_id integer
);
 #   DROP TABLE public."scheduleItems";
       public         heap    abdelelbouhy    false            #           1259    16919    scheduleItems_id_seq    SEQUENCE     �   CREATE SEQUENCE public."scheduleItems_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."scheduleItems_id_seq";
       public          abdelelbouhy    false    292            d           0    0    scheduleItems_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."scheduleItems_id_seq" OWNED BY public."scheduleItems".id;
          public          abdelelbouhy    false    291            &           1259    16929 	   schedules    TABLE     4  CREATE TABLE public.schedules (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    start_date character varying,
    end_date character varying,
    "isSchedule" character varying(255) DEFAULT 'schedule'::character varying NOT NULL,
    name character varying NOT NULL,
    course_id integer,
    service_id integer,
    trip_id integer,
    user_id integer NOT NULL,
    service_unit character varying,
    description character varying(1200),
    duration character varying,
    "numberOfSessions" integer,
    "unlimitedSessions" boolean,
    "timeFrame" character varying,
    "timeFrameDescription" character varying(1200),
    "minBookTime" integer,
    "numberOfEquipments" integer,
    "perHourBranch" integer,
    "scheduleStartTime" character varying,
    "scheduleEndTime" character varying,
    status character varying DEFAULT 'UNAPPROVED'::character varying NOT NULL,
    pending jsonb,
    split character varying,
    solo boolean DEFAULT false
);
    DROP TABLE public.schedules;
       public         heap    abdelelbouhy    false            %           1259    16928    schedules_id_seq    SEQUENCE     �   CREATE SEQUENCE public.schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.schedules_id_seq;
       public          abdelelbouhy    false    294            e           0    0    schedules_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;
          public          abdelelbouhy    false    293            ,           1259    16966    serviceProviders    TABLE     �  CREATE TABLE public."serviceProviders" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    approved boolean DEFAULT false,
    "pricingPlan" character varying,
    video character varying(255),
    company_id integer,
    bank_id integer,
    "padelFinderName" character varying
);
 &   DROP TABLE public."serviceProviders";
       public         heap    abdelelbouhy    false            +           1259    16965    serviceProviders_id_seq    SEQUENCE     �   CREATE SEQUENCE public."serviceProviders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."serviceProviders_id_seq";
       public          abdelelbouhy    false    300            f           0    0    serviceProviders_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."serviceProviders_id_seq" OWNED BY public."serviceProviders".id;
          public          abdelelbouhy    false    299            :           1259    17053    services    TABLE     �  CREATE TABLE public.services (
    id integer NOT NULL,
    title character varying NOT NULL,
    "isService" character varying(255) DEFAULT 'service'::character varying NOT NULL,
    description character varying(1200) NOT NULL,
    rate integer,
    "isFavorite" boolean DEFAULT false,
    "perHourService" boolean,
    "cityId" integer,
    provider_id integer,
    category_id integer NOT NULL,
    activity_id integer NOT NULL,
    address_id integer,
    user_id integer NOT NULL,
    status character varying DEFAULT 'UNAPPROVED'::character varying NOT NULL,
    pending jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.services;
       public         heap    abdelelbouhy    false            9           1259    17052    services_id_seq    SEQUENCE     �   CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.services_id_seq;
       public          abdelelbouhy    false    314            g           0    0    services_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;
          public          abdelelbouhy    false    313            X           1259    18433    settings    TABLE       CREATE TABLE public.settings (
    id integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    section character varying NOT NULL,
    options jsonb NOT NULL
);
    DROP TABLE public.settings;
       public         heap    abdelelbouhy    false            W           1259    18432    settings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public          abdelelbouhy    false    344            h           0    0    settings_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;
          public          abdelelbouhy    false    343            Z           1259    18476    subCity    TABLE     o   CREATE TABLE public."subCity" (
    id integer NOT NULL,
    ar character varying,
    en character varying
);
    DROP TABLE public."subCity";
       public         heap    abdelelbouhy    false            Y           1259    18475    subCity_id_seq    SEQUENCE     �   CREATE SEQUENCE public."subCity_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."subCity_id_seq";
       public          abdelelbouhy    false    346            i           0    0    subCity_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."subCity_id_seq" OWNED BY public."subCity".id;
          public          abdelelbouhy    false    345            l           1259    19664    supplierThirdPartyDetails    TABLE     �   CREATE TABLE public."supplierThirdPartyDetails" (
    id integer NOT NULL,
    "providerId" integer NOT NULL,
    credentials json
);
 /   DROP TABLE public."supplierThirdPartyDetails";
       public         heap    abdelelbouhy    false            k           1259    19663     supplierThirdPartyDetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."supplierThirdPartyDetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."supplierThirdPartyDetails_id_seq";
       public          abdelelbouhy    false    364            j           0    0     supplierThirdPartyDetails_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."supplierThirdPartyDetails_id_seq" OWNED BY public."supplierThirdPartyDetails".id;
          public          abdelelbouhy    false    363                       1259    16762    transactions    TABLE     �  CREATE TABLE public.transactions (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    transaction_id character varying,
    order_id character varying,
    reservation_id integer,
    provider_id integer,
    amount numeric,
    currency_id integer,
    status public.transactions_status_enum,
    refunded_points numeric DEFAULT '0'::numeric,
    refunded_from_supplier numeric DEFAULT '0'::numeric,
    refunded_admin_fees numeric DEFAULT '0'::numeric,
    refunded_amount numeric DEFAULT 0,
    fees_amount numeric DEFAULT 0
);
     DROP TABLE public.transactions;
       public         heap    abdelelbouhy    false    1124                       1259    16761    transactions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.transactions_id_seq;
       public          abdelelbouhy    false    276            k           0    0    transactions_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;
          public          abdelelbouhy    false    275                       1259    16739    tripItineraries    TABLE       CREATE TABLE public."tripItineraries" (
    id integer NOT NULL,
    trip_id integer,
    day integer,
    description character varying(200),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public."tripItineraries";
       public         heap    abdelelbouhy    false                       1259    16738    tripItineraries_id_seq    SEQUENCE     �   CREATE SEQUENCE public."tripItineraries_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."tripItineraries_id_seq";
       public          abdelelbouhy    false    272            l           0    0    tripItineraries_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."tripItineraries_id_seq" OWNED BY public."tripItineraries".id;
          public          abdelelbouhy    false    271            2           1259    17009    trips    TABLE     �  CREATE TABLE public.trips (
    id integer NOT NULL,
    boat_id integer,
    sea_safari_id integer,
    title character varying(60),
    description character varying(1200),
    minimum_price numeric,
    currency_id integer,
    no_of_days integer NOT NULL,
    no_of_nights integer NOT NULL,
    departure_date timestamp without time zone,
    arrival_date timestamp without time zone,
    "cityId" integer,
    status character varying DEFAULT 'UNAPPROVED'::character varying NOT NULL,
    pending jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.trips;
       public         heap    abdelelbouhy    false            1           1259    17008    trips_id_seq    SEQUENCE     �   CREATE SEQUENCE public.trips_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.trips_id_seq;
       public          abdelelbouhy    false    306            m           0    0    trips_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.trips_id_seq OWNED BY public.trips.id;
          public          abdelelbouhy    false    305            �            1259    16454    typeorm_metadata    TABLE     �   CREATE TABLE public.typeorm_metadata (
    type character varying NOT NULL,
    database character varying,
    schema character varying,
    "table" character varying,
    name character varying,
    value text
);
 $   DROP TABLE public.typeorm_metadata;
       public         heap    abdelelbouhy    false                       1259    16748    units    TABLE     �   CREATE TABLE public.units (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    type character varying(255) NOT NULL
);
    DROP TABLE public.units;
       public         heap    abdelelbouhy    false                       1259    16747    units_id_seq    SEQUENCE     �   CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.units_id_seq;
       public          abdelelbouhy    false    274            n           0    0    units_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;
          public          abdelelbouhy    false    273            >           1259    17076    uploadFiles    TABLE     �  CREATE TABLE public."uploadFiles" (
    id integer NOT NULL,
    pending character varying DEFAULT 'false'::character varying,
    file_path character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    file_name text NOT NULL,
    azure_blob_name text,
    company_id integer,
    accommodation_id integer,
    equipment_rental_id integer,
    course_id integer,
    service_id integer,
    trip_id integer,
    organization_id integer,
    user_id integer,
    inquiry_id integer,
    sea_safari_id integer,
    boat_id integer,
    room_id integer,
    "position" character varying
);
 !   DROP TABLE public."uploadFiles";
       public         heap    abdelelbouhy    false            =           1259    17075    uploadFiles_id_seq    SEQUENCE     �   CREATE SEQUENCE public."uploadFiles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."uploadFiles_id_seq";
       public          abdelelbouhy    false    318            o           0    0    uploadFiles_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."uploadFiles_id_seq" OWNED BY public."uploadFiles".id;
          public          abdelelbouhy    false    317                       1259    16677    userDetails    TABLE     �  CREATE TABLE public."userDetails" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    date_of_birth date,
    gender character varying(255),
    photo character varying(255),
    emergency_number character varying(255),
    first_name character varying(255),
    last_name character varying(255)
);
 !   DROP TABLE public."userDetails";
       public         heap    abdelelbouhy    false                       1259    16676    userDetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userDetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."userDetails_id_seq";
       public          abdelelbouhy    false    260            p           0    0    userDetails_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."userDetails_id_seq" OWNED BY public."userDetails".id;
          public          abdelelbouhy    false    259            �            1259    16581 	   userGroup    TABLE     q   CREATE TABLE public."userGroup" (
    id integer NOT NULL,
    user_id integer,
    group_id integer NOT NULL
);
    DROP TABLE public."userGroup";
       public         heap    abdelelbouhy    false            �            1259    16580    userGroup_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userGroup_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."userGroup_id_seq";
       public          abdelelbouhy    false    244            q           0    0    userGroup_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."userGroup_id_seq" OWNED BY public."userGroup".id;
          public          abdelelbouhy    false    243            �            1259    16604    userPermission    TABLE     �   CREATE TABLE public."userPermission" (
    id integer NOT NULL,
    permission_id integer NOT NULL,
    "group_Id" integer,
    user_id integer NOT NULL
);
 $   DROP TABLE public."userPermission";
       public         heap    abdelelbouhy    false            �            1259    16603    userPermission_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userPermission_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."userPermission_id_seq";
       public          abdelelbouhy    false    250            r           0    0    userPermission_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."userPermission_id_seq" OWNED BY public."userPermission".id;
          public          abdelelbouhy    false    249                       1259    16650    users    TABLE     ]  CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    login_type character varying(50) NOT NULL,
    last_login timestamp with time zone,
    timezone character varying DEFAULT 'Egypt'::character varying NOT NULL,
    name character varying NOT NULL,
    status character varying DEFAULT 'ACTIVE'::character varying NOT NULL,
    type character varying DEFAULT 'USER'::character varying NOT NULL,
    email character varying(255),
    language character varying DEFAULT 'ENGLISH'::character varying NOT NULL,
    password character varying(255),
    mobile_number character varying(255) DEFAULT ''::character varying NOT NULL,
    nationality character varying(255) DEFAULT ''::character varying,
    interests integer[],
    is_mobile_number_verified boolean DEFAULT false NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    email_attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    password_attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    logged_in boolean DEFAULT false,
    plan_id integer DEFAULT 1,
    sub_order_id character varying,
    city_id integer,
    "lastSubDate" timestamp without time zone,
    referral_code character varying,
    parent_referral_code character varying,
    loyalty_points numeric DEFAULT 0 NOT NULL,
    subscripted boolean,
    registration_completed boolean DEFAULT false NOT NULL,
    geo_area character varying,
    social_user_id character varying,
    phone_attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    company_id integer
);
    DROP TABLE public.users;
       public         heap    abdelelbouhy    false                       1259    16649    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          abdelelbouhy    false    258            s           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          abdelelbouhy    false    257            �            1259    16563    wallets    TABLE     �   CREATE TABLE public.wallets (
    id integer NOT NULL,
    points integer,
    currency_id integer,
    user_id integer,
    stripe_id character varying
);
    DROP TABLE public.wallets;
       public         heap    abdelelbouhy    false            �            1259    16562    wallets_id_seq    SEQUENCE     �   CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.wallets_id_seq;
       public          abdelelbouhy    false    240            t           0    0    wallets_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallets.id;
          public          abdelelbouhy    false    239            �           2604    17146    accommodations id    DEFAULT     v   ALTER TABLE ONLY public.accommodations ALTER COLUMN id SET DEFAULT nextval('public.accommodations_id_seq'::regclass);
 @   ALTER TABLE public.accommodations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    327    328    328            �           2604    17035    activities id    DEFAULT     n   ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);
 <   ALTER TABLE public.activities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    309    310    310            �           2604    17719    activity_log id    DEFAULT     r   ALTER TABLE ONLY public.activity_log ALTER COLUMN id SET DEFAULT nextval('public.activity_log_id_seq'::regclass);
 >   ALTER TABLE public.activity_log ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    337    338    338            �           2604    17127    addresses id    DEFAULT     l   ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);
 ;   ALTER TABLE public.addresses ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    326    325    326            �           2604    17070    amenities id    DEFAULT     l   ALTER TABLE ONLY public.amenities ALTER COLUMN id SET DEFAULT nextval('public.amenities_id_seq'::regclass);
 ;   ALTER TABLE public.amenities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    316    315    316            �           2604    17159    applicationVisits id    DEFAULT     �   ALTER TABLE ONLY public."applicationVisits" ALTER COLUMN id SET DEFAULT nextval('public."applicationVisits_id_seq"'::regclass);
 E   ALTER TABLE public."applicationVisits" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    329    330    330            E           2604    16785    applications id    DEFAULT     r   ALTER TABLE ONLY public.applications ALTER COLUMN id SET DEFAULT nextval('public.applications_id_seq'::regclass);
 >   ALTER TABLE public.applications ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    277    278    278            �           2604    18674    available_amenities id    DEFAULT     �   ALTER TABLE ONLY public.available_amenities ALTER COLUMN id SET DEFAULT nextval('public.available_amenities_id_seq'::regclass);
 E   ALTER TABLE public.available_amenities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    348    347    348            �           2604    16497    banks id    DEFAULT     d   ALTER TABLE ONLY public.banks ALTER COLUMN id SET DEFAULT nextval('public.banks_id_seq'::regclass);
 7   ALTER TABLE public.banks ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    225    226    226            �           2604    17107    boatActivity id    DEFAULT     v   ALTER TABLE ONLY public."boatActivity" ALTER COLUMN id SET DEFAULT nextval('public."boatActivity_id_seq"'::regclass);
 @   ALTER TABLE public."boatActivity" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    321    322    322            �           2604    16474    boatEquipments id    DEFAULT     z   ALTER TABLE ONLY public."boatEquipments" ALTER COLUMN id SET DEFAULT nextval('public."boatEquipments_id_seq"'::regclass);
 B   ALTER TABLE public."boatEquipments" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    222    221    222            ,           2604    16693    boatFeatures id    DEFAULT     v   ALTER TABLE ONLY public."boatFeatures" ALTER COLUMN id SET DEFAULT nextval('public."boatFeatures_id_seq"'::regclass);
 @   ALTER TABLE public."boatFeatures" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    262    261    262            /           2604    16702    boatSafety id    DEFAULT     r   ALTER TABLE ONLY public."boatSafety" ALTER COLUMN id SET DEFAULT nextval('public."boatSafety_id_seq"'::regclass);
 >   ALTER TABLE public."boatSafety" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    264    263    264            �           2604    17114    boats id    DEFAULT     d   ALTER TABLE ONLY public.boats ALTER COLUMN id SET DEFAULT nextval('public.boats_id_seq'::regclass);
 7   ALTER TABLE public.boats ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    324    323    324            �           2604    16519    branchCourse id    DEFAULT     v   ALTER TABLE ONLY public."branchCourse" ALTER COLUMN id SET DEFAULT nextval('public."branchCourse_id_seq"'::regclass);
 @   ALTER TABLE public."branchCourse" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    230    229    230            �           2604    17166    branchEquipmentRental id    DEFAULT     �   ALTER TABLE ONLY public."branchEquipmentRental" ALTER COLUMN id SET DEFAULT nextval('public."branchEquipmentRental_id_seq"'::regclass);
 I   ALTER TABLE public."branchEquipmentRental" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    332    331    332            �           2604    17047    branchService id    DEFAULT     x   ALTER TABLE ONLY public."branchService" ALTER COLUMN id SET DEFAULT nextval('public."branchService_id_seq"'::regclass);
 A   ALTER TABLE public."branchService" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    312    311    312            x           2604    17003    branchTrip id    DEFAULT     r   ALTER TABLE ONLY public."branchTrip" ALTER COLUMN id SET DEFAULT nextval('public."branchTrip_id_seq"'::regclass);
 >   ALTER TABLE public."branchTrip" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    304    303    304            t           2604    16989    branches id    DEFAULT     j   ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);
 :   ALTER TABLE public.branches ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    302    301    302            �           2604    16486    categories id    DEFAULT     n   ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);
 <   ALTER TABLE public.categories ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    223    224    224                       2604    17024 	   cities id    DEFAULT     f   ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);
 8   ALTER TABLE public.cities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    307    308    308            �           2604    16508    companies id    DEFAULT     l   ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);
 ;   ALTER TABLE public.companies ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    228    227    228            3           2604    16722    countries id    DEFAULT     l   ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);
 ;   ALTER TABLE public.countries ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    268    267    268            k           2604    16956 
   courses id    DEFAULT     h   ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);
 9   ALTER TABLE public.courses ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    297    298    298            �           2604    18976    court id    DEFAULT     d   ALTER TABLE ONLY public.court ALTER COLUMN id SET DEFAULT nextval('public.court_id_seq'::regclass);
 7   ALTER TABLE public.court ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    356    355    356            �           2604    16463    currencies id    DEFAULT     n   ALTER TABLE ONLY public.currencies ALTER COLUMN id SET DEFAULT nextval('public.currencies_id_seq'::regclass);
 <   ALTER TABLE public.currencies ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    219    220    220            �           2604    19003    custom_payment_options id    DEFAULT     �   ALTER TABLE ONLY public.custom_payment_options ALTER COLUMN id SET DEFAULT nextval('public.custom_payment_options_id_seq'::regclass);
 H   ALTER TABLE public.custom_payment_options ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    358    357    358            �           2604    18965    custom_per_hour_day id    DEFAULT     �   ALTER TABLE ONLY public.custom_per_hour_day ALTER COLUMN id SET DEFAULT nextval('public.custom_per_hour_day_id_seq'::regclass);
 E   ALTER TABLE public.custom_per_hour_day ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    354    353    354                       2604    16575 
   devices id    DEFAULT     h   ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);
 9   ALTER TABLE public.devices ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    242    241    242            6           2604    16733    equipmentRentals id    DEFAULT     ~   ALTER TABLE ONLY public."equipmentRentals" ALTER COLUMN id SET DEFAULT nextval('public."equipmentRentals_id_seq"'::regclass);
 D   ALTER TABLE public."equipmentRentals" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    270    269    270            �           2604    17175    exchanges id    DEFAULT     l   ALTER TABLE ONLY public.exchanges ALTER COLUMN id SET DEFAULT nextval('public.exchanges_id_seq'::regclass);
 ;   ALTER TABLE public.exchanges ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    333    334    334            �           2604    18685    excludes id    DEFAULT     j   ALTER TABLE ONLY public.excludes ALTER COLUMN id SET DEFAULT nextval('public.excludes_id_seq'::regclass);
 :   ALTER TABLE public.excludes ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    349    350    350                       2604    16548    favorite id    DEFAULT     j   ALTER TABLE ONLY public.favorite ALTER COLUMN id SET DEFAULT nextval('public.favorite_id_seq'::regclass);
 :   ALTER TABLE public.favorite ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    235    236    236                       2604    16600    group_permission id    DEFAULT     z   ALTER TABLE ONLY public.group_permission ALTER COLUMN id SET DEFAULT nextval('public.group_permission_id_seq'::regclass);
 B   ALTER TABLE public.group_permission ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    248    247    248                       2604    16591 	   groups id    DEFAULT     f   ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);
 8   ALTER TABLE public.groups ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    245    246    246                       2604    16528    guest id    DEFAULT     d   ALTER TABLE ONLY public.guest ALTER COLUMN id SET DEFAULT nextval('public.guest_id_seq'::regclass);
 7   ALTER TABLE public.guest ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    232    231    232                       2604    16631    inquiries id    DEFAULT     l   ALTER TABLE ONLY public.inquiries ALTER COLUMN id SET DEFAULT nextval('public.inquiries_id_seq'::regclass);
 ;   ALTER TABLE public.inquiries ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    253    254    254            H           2604    16817    itemRequests id    DEFAULT     v   ALTER TABLE ONLY public."itemRequests" ALTER COLUMN id SET DEFAULT nextval('public."itemRequests_id_seq"'::regclass);
 @   ALTER TABLE public."itemRequests" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    279    280    280            _           2604    16914    itemTimes id    DEFAULT     p   ALTER TABLE ONLY public."itemTimes" ALTER COLUMN id SET DEFAULT nextval('public."itemTimes_id_seq"'::regclass);
 =   ALTER TABLE public."itemTimes" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    289    290    290            �           2604    17699    loyalty_program id    DEFAULT     x   ALTER TABLE ONLY public.loyalty_program ALTER COLUMN id SET DEFAULT nextval('public.loyalty_program_id_seq'::regclass);
 A   ALTER TABLE public.loyalty_program ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    336    335    336            �           2604    17730    loyalty_program_withdraws id    DEFAULT     �   ALTER TABLE ONLY public.loyalty_program_withdraws ALTER COLUMN id SET DEFAULT nextval('public.loyalty_program_withdraws_id_seq'::regclass);
 K   ALTER TABLE public.loyalty_program_withdraws ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    340    339    340            �           2604    16449    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    216    217    217            L           2604    16853    notifications id    DEFAULT     t   ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    281    282    282            2           2604    16711    organizations id    DEFAULT     t   ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);
 ?   ALTER TABLE public.organizations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    266    265    266            	           2604    16557    payMethods id    DEFAULT     r   ALTER TABLE ONLY public."payMethods" ALTER COLUMN id SET DEFAULT nextval('public."payMethods_id_seq"'::regclass);
 >   ALTER TABLE public."payMethods" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    238    237    238            �           2604    17800    payment_way id    DEFAULT     p   ALTER TABLE ONLY public.payment_way ALTER COLUMN id SET DEFAULT nextval('public.payment_way_id_seq'::regclass);
 =   ALTER TABLE public.payment_way ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    341    342    342            �           2604    18954    per_hour_price_range id    DEFAULT     �   ALTER TABLE ONLY public.per_hour_price_range ALTER COLUMN id SET DEFAULT nextval('public.per_hour_price_range_id_seq'::regclass);
 F   ALTER TABLE public.per_hour_price_range ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    351    352    352                       2604    16614    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    251    252    252            h           2604    16945 	   prices id    DEFAULT     f   ALTER TABLE ONLY public.prices ALTER COLUMN id SET DEFAULT nextval('public.prices_id_seq'::regclass);
 8   ALTER TABLE public.prices ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    295    296    296                       2604    16643    pricingPlans id    DEFAULT     v   ALTER TABLE ONLY public."pricingPlans" ALTER COLUMN id SET DEFAULT nextval('public."pricingPlans_id_seq"'::regclass);
 @   ALTER TABLE public."pricingPlans" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    256    255    256            �           2604    19579    provider_contact id    DEFAULT     z   ALTER TABLE ONLY public.provider_contact ALTER COLUMN id SET DEFAULT nextval('public.provider_contact_id_seq'::regclass);
 B   ALTER TABLE public.provider_contact ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    361    362    362            �           2604    19033    recurrences id    DEFAULT     p   ALTER TABLE ONLY public.recurrences ALTER COLUMN id SET DEFAULT nextval('public.recurrences_id_seq'::regclass);
 =   ALTER TABLE public.recurrences ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    360    359    360            \           2604    16903    reservationItem id    DEFAULT     |   ALTER TABLE ONLY public."reservationItem" ALTER COLUMN id SET DEFAULT nextval('public."reservationItem_id_seq"'::regclass);
 C   ALTER TABLE public."reservationItem" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    288    287    288            P           2604    16879    reservations id    DEFAULT     r   ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);
 >   ALTER TABLE public.reservations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    284    283    284                       2604    16537 
   reviews id    DEFAULT     h   ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);
 9   ALTER TABLE public.reviews ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    234    233    234            Z           2604    16892    roomRental id    DEFAULT     r   ALTER TABLE ONLY public."roomRental" ALTER COLUMN id SET DEFAULT nextval('public."roomRental_id_seq"'::regclass);
 >   ALTER TABLE public."roomRental" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    286    285    286            �           2604    17095    rooms id    DEFAULT     d   ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);
 7   ALTER TABLE public.rooms ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    320    319    320            a           2604    16923    scheduleItems id    DEFAULT     x   ALTER TABLE ONLY public."scheduleItems" ALTER COLUMN id SET DEFAULT nextval('public."scheduleItems_id_seq"'::regclass);
 A   ALTER TABLE public."scheduleItems" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    291    292    292            b           2604    16932    schedules id    DEFAULT     l   ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);
 ;   ALTER TABLE public.schedules ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    294    293    294            p           2604    16969    serviceProviders id    DEFAULT     ~   ALTER TABLE ONLY public."serviceProviders" ALTER COLUMN id SET DEFAULT nextval('public."serviceProviders_id_seq"'::regclass);
 D   ALTER TABLE public."serviceProviders" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    299    300    300            �           2604    17056    services id    DEFAULT     j   ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);
 :   ALTER TABLE public.services ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    314    313    314            �           2604    18436    settings id    DEFAULT     j   ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    344    343    344            �           2604    18479 
   subCity id    DEFAULT     l   ALTER TABLE ONLY public."subCity" ALTER COLUMN id SET DEFAULT nextval('public."subCity_id_seq"'::regclass);
 ;   ALTER TABLE public."subCity" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    346    345    346            �           2604    19667    supplierThirdPartyDetails id    DEFAULT     �   ALTER TABLE ONLY public."supplierThirdPartyDetails" ALTER COLUMN id SET DEFAULT nextval('public."supplierThirdPartyDetails_id_seq"'::regclass);
 M   ALTER TABLE public."supplierThirdPartyDetails" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    364    363    364            =           2604    16765    transactions id    DEFAULT     r   ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);
 >   ALTER TABLE public.transactions ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    275    276    276            7           2604    16742    tripItineraries id    DEFAULT     |   ALTER TABLE ONLY public."tripItineraries" ALTER COLUMN id SET DEFAULT nextval('public."tripItineraries_id_seq"'::regclass);
 C   ALTER TABLE public."tripItineraries" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    272    271    272            {           2604    17012    trips id    DEFAULT     d   ALTER TABLE ONLY public.trips ALTER COLUMN id SET DEFAULT nextval('public.trips_id_seq'::regclass);
 7   ALTER TABLE public.trips ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    306    305    306            :           2604    16751    units id    DEFAULT     d   ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);
 7   ALTER TABLE public.units ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    273    274    274            �           2604    17079    uploadFiles id    DEFAULT     t   ALTER TABLE ONLY public."uploadFiles" ALTER COLUMN id SET DEFAULT nextval('public."uploadFiles_id_seq"'::regclass);
 ?   ALTER TABLE public."uploadFiles" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    317    318    318            )           2604    16680    userDetails id    DEFAULT     t   ALTER TABLE ONLY public."userDetails" ALTER COLUMN id SET DEFAULT nextval('public."userDetails_id_seq"'::regclass);
 ?   ALTER TABLE public."userDetails" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    259    260    260                       2604    16584    userGroup id    DEFAULT     p   ALTER TABLE ONLY public."userGroup" ALTER COLUMN id SET DEFAULT nextval('public."userGroup_id_seq"'::regclass);
 =   ALTER TABLE public."userGroup" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    243    244    244                       2604    16607    userPermission id    DEFAULT     z   ALTER TABLE ONLY public."userPermission" ALTER COLUMN id SET DEFAULT nextval('public."userPermission_id_seq"'::regclass);
 B   ALTER TABLE public."userPermission" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    250    249    250                       2604    16653    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    258    257    258            
           2604    16566 
   wallets id    DEFAULT     h   ALTER TABLE ONLY public.wallets ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);
 9   ALTER TABLE public.wallets ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    240    239    240            �          0    17143    accommodations 
   TABLE DATA           �   COPY public.accommodations (id, created_at, updated_at, cancellation_policy, checkin, checkout, description, no_of_beds, no_of_guest, spaces_available, title, type, address_id, user_id, trip_id) FROM stdin;
    public          abdelelbouhy    false    328   ͟      �          0    17032 
   activities 
   TABLE DATA           �   COPY public.activities (id, created_at, updated_at, trending_score, name, image, category_id, boat_id, "cityId", city_id, splits) FROM stdin;
    public          abdelelbouhy    false    310   �                0    17716    activity_log 
   TABLE DATA           f   COPY public.activity_log (id, created_at, updated_at, user_id, key, old_value, new_value) FROM stdin;
    public          abdelelbouhy    false    338   v�      �          0    17124 	   addresses 
   TABLE DATA           �   COPY public.addresses (id, created_at, updated_at, number, street, city, postcode, district, lat, lng, "timeZone", service_id, course_id, company_id, country_id, boat_id, place_id) FROM stdin;
    public          abdelelbouhy    false    326   ��      �          0    17067 	   amenities 
   TABLE DATA           j   COPY public.amenities (id, created_at, updated_at, name, accommodation_id, service_id, image) FROM stdin;
    public          abdelelbouhy    false    316   �                 0    17156    applicationVisits 
   TABLE DATA           >   COPY public."applicationVisits" (id, day, visits) FROM stdin;
    public          abdelelbouhy    false    330   �      �          0    16782    applications 
   TABLE DATA           c   COPY public.applications (id, created_at, updated_at, user_id, status, "assignedUser") FROM stdin;
    public          abdelelbouhy    false    278   4,                0    18671    available_amenities 
   TABLE DATA           V   COPY public.available_amenities (id, created_at, updated_at, name, image) FROM stdin;
    public          abdelelbouhy    false    348   �6      �          0    16494    banks 
   TABLE DATA             COPY public.banks (id, created_at, updated_at, user_id, currency_id, card_holder_name, account_number, iban_number, swift_code, branch_number, branch_name, full_name, email_address, phone_number, mobile_number, refund_policy, account_nationality, status) FROM stdin;
    public          abdelelbouhy    false    226   ?8      �          0    17104    boatActivity 
   TABLE DATA           B   COPY public."boatActivity" (id, boat_id, activity_id) FROM stdin;
    public          abdelelbouhy    false    322   {      �          0    16471    boatEquipments 
   TABLE DATA           �   COPY public."boatEquipments" (id, boat_id, title, description, per_day_price, currency_id, no_of_equipments, deleted, created_at, updated_at, foreigner_per_day_price, foreigner_currency_id) FROM stdin;
    public          abdelelbouhy    false    222   c{      �          0    16690    boatFeatures 
   TABLE DATA           Y   COPY public."boatFeatures" (id, created_at, updated_at, name, sea_safari_id) FROM stdin;
    public          abdelelbouhy    false    262   t}      �          0    16699 
   boatSafety 
   TABLE DATA           W   COPY public."boatSafety" (id, created_at, updated_at, type, sea_safari_id) FROM stdin;
    public          abdelelbouhy    false    264   �}      �          0    17111    boats 
   TABLE DATA           
  COPY public.boats (id, user_id, title, description, "isFavorite", city_id, provider_id, length, width, no_of_cabins, no_of_engines, number_of_guests, fresh_water_maker, top_speed, features, navigation_and_safety, status, pending, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    324   �}      �          0    16516    branchCourse 
   TABLE DATA           c   COPY public."branchCourse" (id, created_at, updated_at, course_id, branch_id, city_id) FROM stdin;
    public          abdelelbouhy    false    230   �                0    17163    branchEquipmentRental 
   TABLE DATA           m   COPY public."branchEquipmentRental" (id, created_at, updated_at, equipment_rental_id, branch_id) FROM stdin;
    public          abdelelbouhy    false    332   ]�      �          0    17044    branchService 
   TABLE DATA           e   COPY public."branchService" (id, created_at, updated_at, service_id, branch_id, city_id) FROM stdin;
    public          abdelelbouhy    false    312   z�      �          0    17000 
   branchTrip 
   TABLE DATA           V   COPY public."branchTrip" (id, created_at, updated_at, trip_id, branch_id) FROM stdin;
    public          abdelelbouhy    false    304   ×      �          0    16986    branches 
   TABLE DATA           �   COPY public.branches (id, created_at, updated_at, name, user_id, is_active, address_id, city_id, status, sub_city_id) FROM stdin;
    public          abdelelbouhy    false    302   ��      �          0    16483 
   categories 
   TABLE DATA           M   COPY public.categories (id, created_at, updated_at, name, image) FROM stdin;
    public          abdelelbouhy    false    224   ί      �          0    17021    cities 
   TABLE DATA           �   COPY public.cities (id, created_at, updated_at, city_name, governorate_name, photo, city_code, lat, lng, "isFavorite", place_id) FROM stdin;
    public          abdelelbouhy    false    308   ��      �          0    16505 	   companies 
   TABLE DATA           �   COPY public.companies (id, created_at, updated_at, address_id, name, logo, trade_license_no, tax_license_no, certificate, contact_email, contact_phone, contact_details, license_no) FROM stdin;
    public          abdelelbouhy    false    228   �      �          0    16719 	   countries 
   TABLE DATA           V   COPY public.countries (id, created_at, updated_at, name, code, dial_code) FROM stdin;
    public          abdelelbouhy    false    268   ��      �          0    16953    courses 
   TABLE DATA           �   COPY public.courses (id, created_at, updated_at, title, description, user_id, provider_id, category_id, activity_id, "cityId", languages, prerequisites, organization, "isFavorite", status, pending, city_id) FROM stdin;
    public          abdelelbouhy    false    298   ��                0    18973    court 
   TABLE DATA           _   COPY public.court (id, created_at, updated_at, name, "scheduleId", solo, space_id) FROM stdin;
    public          abdelelbouhy    false    356   �      �          0    16460 
   currencies 
   TABLE DATA           R   COPY public.currencies (id, created_at, updated_at, name, code, logo) FROM stdin;
    public          abdelelbouhy    false    220   �                0    19000    custom_payment_options 
   TABLE DATA           f   COPY public.custom_payment_options (id, created_at, updated_at, name, item_type, item_id) FROM stdin;
    public          abdelelbouhy    false    358   �                0    18962    custom_per_hour_day 
   TABLE DATA           �   COPY public.custom_per_hour_day (id, name, "startTime", "endTime", "courtId", "createdAt", "updatedAt", availability) FROM stdin;
    public          abdelelbouhy    false    354   �'      �          0    16572    devices 
   TABLE DATA           @   COPY public.devices (id, user_id, device_id, token) FROM stdin;
    public          abdelelbouhy    false    242   �f      �          0    16730    equipmentRentals 
   TABLE DATA           M   COPY public."equipmentRentals" (id, item_id, equipment_id, name) FROM stdin;
    public          abdelelbouhy    false    270                   0    17172 	   exchanges 
   TABLE DATA           O   COPY public.exchanges (id, updated_at, "firstC", "secondC", ratio) FROM stdin;
    public          abdelelbouhy    false    334   !                0    18682    excludes 
   TABLE DATA           X   COPY public.excludes (id, created_at, updated_at, name, item_type, item_id) FROM stdin;
    public          abdelelbouhy    false    350   �      �          0    16545    favorite 
   TABLE DATA           p   COPY public.favorite (id, user_id, course_id, boat_id, service_id, city_id, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    236   �      �          0    16597    group_permission 
   TABLE DATA           I   COPY public.group_permission (id, "group_Id", permission_id) FROM stdin;
    public          abdelelbouhy    false    248   v      �          0    16588    groups 
   TABLE DATA           =   COPY public.groups (id, color, name, company_id) FROM stdin;
    public          abdelelbouhy    false    246   �      �          0    16525    guest 
   TABLE DATA           R   COPY public.guest (id, title, first_name, last_name, "reservationId") FROM stdin;
    public          abdelelbouhy    false    232   9      �          0    16628 	   inquiries 
   TABLE DATA           �   COPY public.inquiries (id, created_at, updated_at, type, subject, message, user_id, "assignedGroupId", status, resolution) FROM stdin;
    public          abdelelbouhy    false    254   V      �          0    16814    itemRequests 
   TABLE DATA           ~   COPY public."itemRequests" (id, created_at, updated_at, item_id, user_id, item_type, status, type, assigned_user) FROM stdin;
    public          abdelelbouhy    false    280         �          0    16911 	   itemTimes 
   TABLE DATA           �   COPY public."itemTimes" (id, item_id, "startTime", "endTime", reservation_item_id, external_reserve, imported_reserve, appointment_id) FROM stdin;
    public          abdelelbouhy    false    290   �p                0    17696    loyalty_program 
   TABLE DATA           �   COPY public.loyalty_program (id, created_at, updated_at, points, user_id, parent_user_id, reservation_id, parent_user_type, withdrawn, redeemed) FROM stdin;
    public          abdelelbouhy    false    336   X�      
          0    17727    loyalty_program_withdraws 
   TABLE DATA           p   COPY public.loyalty_program_withdraws (id, created_at, updated_at, points, user_id, reservation_id) FROM stdin;
    public          abdelelbouhy    false    340   "�      �          0    16446 
   migrations 
   TABLE DATA           ;   COPY public.migrations (id, "timestamp", name) FROM stdin;
    public          abdelelbouhy    false    217   f�      �          0    16850    notifications 
   TABLE DATA           �   COPY public.notifications (id, user_id, message, reservation_id, review_id, request_id, "itemType", "itemId", type, "toAllUsers", "toAllProviders", "toAllAdmins", created_at, "Seen", cleared, redirect) FROM stdin;
    public          abdelelbouhy    false    282   !�      �          0    16708    organizations 
   TABLE DATA           D   COPY public.organizations (id, course_id, name, status) FROM stdin;
    public          abdelelbouhy    false    266   ��      �          0    16554 
   payMethods 
   TABLE DATA           �   COPY public."payMethods" (id, wallet_id, user_id, save_order_id, "save_order_Token", token, masked_pan, merchant_id, card_subtype, created_at, email, user_added, nationality, get_way) FROM stdin;
    public          abdelelbouhy    false    238   ��                0    17797    payment_way 
   TABLE DATA           a   COPY public.payment_way (id, name, type, image, availability, "getWay", nationality) FROM stdin;
    public          abdelelbouhy    false    342   ��                0    18951    per_hour_price_range 
   TABLE DATA           �  COPY public.per_hour_price_range (id, "createdAt", "updatedAt", "startTime", "endTime", "egyptianPrice", "foreignPrice", "egyptianDiscountPrice", "foreignDiscountPrice", "egyptianDiscountStartTime", "egyptianDiscountEndTime", "foreignDiscountStartTime", "foreignDiscountEndTime", "customPerHourDayId", "egyptianCurrencyId", "foreignCurrencyId", "egyptianBulkPrice", "foreignBulkPrice", "minimumBulk", "offerBy") FROM stdin;
    public          abdelelbouhy    false    352   ��      �          0    16611    permissions 
   TABLE DATA           @   COPY public.permissions (id, name, admin, supplier) FROM stdin;
    public          abdelelbouhy    false    252   �W      �          0    16942    prices 
   TABLE DATA           �   COPY public.prices (id, created_at, updated_at, type, price, discount_price, discount_start, discount_end, currency_id, accommodation_id, course_id, equipment_rental_id, unit_id, service_id, trip_id, room_id, schedule_id) FROM stdin;
    public          abdelelbouhy    false    296   yX      �          0    16640    pricingPlans 
   TABLE DATA           W   COPY public."pricingPlans" (id, name, plan_features, price, limited_offer) FROM stdin;
    public          abdelelbouhy    false    256   p�                 0    19576    provider_contact 
   TABLE DATA           y   COPY public.provider_contact (id, created_at, updated_at, name, phone_number, user_id, provider_id, blocked) FROM stdin;
    public          abdelelbouhy    false    362   ��                0    19030    recurrences 
   TABLE DATA           v   COPY public.recurrences (id, court_id, rule, "startTime", "endTime", "endDate", appointment_id, excludes) FROM stdin;
    public          abdelelbouhy    false    360   �      �          0    16900    reservationItem 
   TABLE DATA           �   COPY public."reservationItem" (id, type, reservation_date, quantity, price, discount_value, discounted, "reservationId", original_discount_start, original_discount_end) FROM stdin;
    public          abdelelbouhy    false    288   כ      �          0    16876    reservations 
   TABLE DATA           ?  COPY public.reservations (id, order_id, payment_success, reservation_date, status, type, activity_type, category_type, branch_name, "currencyId", price, discount_value, price_type, discounted, number_of_people, user_id, provider_id, trip_id, schedule_id, first_name, last_name, contact_email, contact_number, payment_method, reserved_currency_id, created_at, updated_at, "usedPoints", "actualTotalAmount", original_discount_start, original_discount_end, admin_fees, admin_total, "admin_fees_In_user_currency", "price_In_user_currency", rejection_reason, get_way) FROM stdin;
    public          abdelelbouhy    false    284   ��      �          0    16534    reviews 
   TABLE DATA           �   COPY public.reviews (id, created_at, updated_at, review, title, rate, service_id, course_id, boat_id, user_id, reply_on_id) FROM stdin;
    public          abdelelbouhy    false    234   ��      �          0    16889 
   roomRental 
   TABLE DATA           |   COPY public."roomRental" (id, item_id, room_id, "noOfPeople", room_price, trip_id, room_name, external_reserve) FROM stdin;
    public          abdelelbouhy    false    286   ��      �          0    17092    rooms 
   TABLE DATA           ~   COPY public.rooms (id, boat_id, type, description, no_of_guests, rooms_on_board, deleted, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    320   ٦      �          0    16920    scheduleItems 
   TABLE DATA           Q   COPY public."scheduleItems" (id, name, number, "order", schedule_id) FROM stdin;
    public          abdelelbouhy    false    292   �      �          0    16929 	   schedules 
   TABLE DATA           �  COPY public.schedules (id, created_at, updated_at, start_date, end_date, "isSchedule", name, course_id, service_id, trip_id, user_id, service_unit, description, duration, "numberOfSessions", "unlimitedSessions", "timeFrame", "timeFrameDescription", "minBookTime", "numberOfEquipments", "perHourBranch", "scheduleStartTime", "scheduleEndTime", status, pending, split, solo) FROM stdin;
    public          abdelelbouhy    false    294   ;�      �          0    16966    serviceProviders 
   TABLE DATA           �   COPY public."serviceProviders" (id, name, created_at, updated_at, user_id, approved, "pricingPlan", video, company_id, bank_id, "padelFinderName") FROM stdin;
    public          abdelelbouhy    false    300   u�      �          0    17053    services 
   TABLE DATA           �   COPY public.services (id, title, "isService", description, rate, "isFavorite", "perHourService", "cityId", provider_id, category_id, activity_id, address_id, user_id, status, pending, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    314   
	                0    18433    settings 
   TABLE DATA           R   COPY public.settings (id, "createdAt", "updatedAt", section, options) FROM stdin;
    public          abdelelbouhy    false    344   [u	                0    18476    subCity 
   TABLE DATA           /   COPY public."subCity" (id, ar, en) FROM stdin;
    public          abdelelbouhy    false    346   �u	      "          0    19664    supplierThirdPartyDetails 
   TABLE DATA           T   COPY public."supplierThirdPartyDetails" (id, "providerId", credentials) FROM stdin;
    public          abdelelbouhy    false    364   ��	      �          0    16762    transactions 
   TABLE DATA           �   COPY public.transactions (id, created_at, updated_at, transaction_id, order_id, reservation_id, provider_id, amount, currency_id, status, refunded_points, refunded_from_supplier, refunded_admin_fees, refunded_amount, fees_amount) FROM stdin;
    public          abdelelbouhy    false    276   ��	      �          0    16739    tripItineraries 
   TABLE DATA           b   COPY public."tripItineraries" (id, trip_id, day, description, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    272   �	      �          0    17009    trips 
   TABLE DATA           �   COPY public.trips (id, boat_id, sea_safari_id, title, description, minimum_price, currency_id, no_of_days, no_of_nights, departure_date, arrival_date, "cityId", status, pending, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    306   ��	      �          0    16454    typeorm_metadata 
   TABLE DATA           X   COPY public.typeorm_metadata (type, database, schema, "table", name, value) FROM stdin;
    public          abdelelbouhy    false    218   ��	      �          0    16748    units 
   TABLE DATA           A   COPY public.units (id, created_at, updated_at, type) FROM stdin;
    public          abdelelbouhy    false    274   ��	      �          0    17076    uploadFiles 
   TABLE DATA             COPY public."uploadFiles" (id, pending, file_path, created_at, updated_at, file_name, azure_blob_name, company_id, accommodation_id, equipment_rental_id, course_id, service_id, trip_id, organization_id, user_id, inquiry_id, sea_safari_id, boat_id, room_id, "position") FROM stdin;
    public          abdelelbouhy    false    318   ��	      �          0    16677    userDetails 
   TABLE DATA           �   COPY public."userDetails" (id, created_at, updated_at, user_id, date_of_birth, gender, photo, emergency_number, first_name, last_name) FROM stdin;
    public          abdelelbouhy    false    260   �
      �          0    16581 	   userGroup 
   TABLE DATA           <   COPY public."userGroup" (id, user_id, group_id) FROM stdin;
    public          abdelelbouhy    false    244   'Q      �          0    16604    userPermission 
   TABLE DATA           R   COPY public."userPermission" (id, permission_id, "group_Id", user_id) FROM stdin;
    public          abdelelbouhy    false    250   \Q      �          0    16650    users 
   TABLE DATA           �  COPY public.users (id, created_at, updated_at, login_type, last_login, timezone, name, status, type, email, language, password, mobile_number, nationality, interests, is_mobile_number_verified, is_email_verified, email_attributes, password_attributes, logged_in, plan_id, sub_order_id, city_id, "lastSubDate", referral_code, parent_referral_code, loyalty_points, subscripted, registration_completed, geo_area, social_user_id, phone_attributes, company_id) FROM stdin;
    public          abdelelbouhy    false    258   T      �          0    16563    wallets 
   TABLE DATA           N   COPY public.wallets (id, points, currency_id, user_id, stripe_id) FROM stdin;
    public          abdelelbouhy    false    240   �      u           0    0    accommodations_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.accommodations_id_seq', 1, false);
          public          abdelelbouhy    false    327            v           0    0    activities_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.activities_id_seq', 112, true);
          public          abdelelbouhy    false    309            w           0    0    activity_log_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.activity_log_id_seq', 1, false);
          public          abdelelbouhy    false    337            x           0    0    addresses_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.addresses_id_seq', 669, true);
          public          abdelelbouhy    false    325            y           0    0    amenities_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.amenities_id_seq', 2413, true);
          public          abdelelbouhy    false    315            z           0    0    applicationVisits_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."applicationVisits_id_seq"', 265, true);
          public          abdelelbouhy    false    329            {           0    0    applications_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.applications_id_seq', 114, true);
          public          abdelelbouhy    false    277            |           0    0    available_amenities_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.available_amenities_id_seq', 16, true);
          public          abdelelbouhy    false    347            }           0    0    banks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.banks_id_seq', 125, true);
          public          abdelelbouhy    false    225            ~           0    0    boatActivity_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."boatActivity_id_seq"', 32, true);
          public          abdelelbouhy    false    321                       0    0    boatEquipments_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."boatEquipments_id_seq"', 7, true);
          public          abdelelbouhy    false    221            �           0    0    boatFeatures_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."boatFeatures_id_seq"', 1, false);
          public          abdelelbouhy    false    261            �           0    0    boatSafety_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."boatSafety_id_seq"', 1, false);
          public          abdelelbouhy    false    263            �           0    0    boats_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.boats_id_seq', 11, true);
          public          abdelelbouhy    false    323            �           0    0    branchCourse_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."branchCourse_id_seq"', 259, true);
          public          abdelelbouhy    false    229            �           0    0    branchEquipmentRental_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."branchEquipmentRental_id_seq"', 1, false);
          public          abdelelbouhy    false    331            �           0    0    branchService_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."branchService_id_seq"', 1573, true);
          public          abdelelbouhy    false    311            �           0    0    branchTrip_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."branchTrip_id_seq"', 1, false);
          public          abdelelbouhy    false    303            �           0    0    branches_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.branches_id_seq', 197, true);
          public          abdelelbouhy    false    301            �           0    0    categories_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.categories_id_seq', 4, true);
          public          abdelelbouhy    false    223            �           0    0    cities_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.cities_id_seq', 39, true);
          public          abdelelbouhy    false    307            �           0    0    companies_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.companies_id_seq', 125, true);
          public          abdelelbouhy    false    227            �           0    0    countries_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.countries_id_seq', 242, true);
          public          abdelelbouhy    false    267            �           0    0    courses_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.courses_id_seq', 43, true);
          public          abdelelbouhy    false    297            �           0    0    court_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.court_id_seq', 191, true);
          public          abdelelbouhy    false    355            �           0    0    currencies_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.currencies_id_seq', 1, false);
          public          abdelelbouhy    false    219            �           0    0    custom_payment_options_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.custom_payment_options_id_seq', 796, true);
          public          abdelelbouhy    false    357            �           0    0    custom_per_hour_day_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.custom_per_hour_day_id_seq', 2352, true);
          public          abdelelbouhy    false    353            �           0    0    devices_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.devices_id_seq', 1117, true);
          public          abdelelbouhy    false    241            �           0    0    equipmentRentals_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."equipmentRentals_id_seq"', 4, true);
          public          abdelelbouhy    false    269            �           0    0    exchanges_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.exchanges_id_seq', 9, true);
          public          abdelelbouhy    false    333            �           0    0    excludes_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.excludes_id_seq', 42, true);
          public          abdelelbouhy    false    349            �           0    0    favorite_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.favorite_id_seq', 159, true);
          public          abdelelbouhy    false    235            �           0    0    group_permission_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.group_permission_id_seq', 34, true);
          public          abdelelbouhy    false    247            �           0    0    groups_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.groups_id_seq', 4, true);
          public          abdelelbouhy    false    245            �           0    0    guest_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.guest_id_seq', 10, true);
          public          abdelelbouhy    false    231            �           0    0    inquiries_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.inquiries_id_seq', 3, true);
          public          abdelelbouhy    false    253            �           0    0    itemRequests_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."itemRequests_id_seq"', 1073, true);
          public          abdelelbouhy    false    279            �           0    0    itemTimes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."itemTimes_id_seq"', 22548769, true);
          public          abdelelbouhy    false    289            �           0    0    loyalty_program_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.loyalty_program_id_seq', 13, true);
          public          abdelelbouhy    false    335            �           0    0     loyalty_program_withdraws_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.loyalty_program_withdraws_id_seq', 3, true);
          public          abdelelbouhy    false    339            �           0    0    migrations_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.migrations_id_seq', 41, true);
          public          abdelelbouhy    false    216            �           0    0    notifications_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.notifications_id_seq', 2329, true);
          public          abdelelbouhy    false    281            �           0    0    organizations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.organizations_id_seq', 43, true);
          public          abdelelbouhy    false    265            �           0    0    payMethods_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."payMethods_id_seq"', 94, true);
          public          abdelelbouhy    false    237            �           0    0    payment_way_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.payment_way_id_seq', 1, true);
          public          abdelelbouhy    false    341            �           0    0    per_hour_price_range_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.per_hour_price_range_id_seq', 2946, true);
          public          abdelelbouhy    false    351            �           0    0    permissions_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.permissions_id_seq', 1, true);
          public          abdelelbouhy    false    251            �           0    0    prices_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.prices_id_seq', 996, true);
          public          abdelelbouhy    false    295            �           0    0    pricingPlans_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."pricingPlans_id_seq"', 2, true);
          public          abdelelbouhy    false    255            �           0    0    provider_contact_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.provider_contact_id_seq', 17, true);
          public          abdelelbouhy    false    361            �           0    0    recurrences_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.recurrences_id_seq', 811237, true);
          public          abdelelbouhy    false    359            �           0    0    reservationItem_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."reservationItem_id_seq"', 415, true);
          public          abdelelbouhy    false    287            �           0    0    reservations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.reservations_id_seq', 600, true);
          public          abdelelbouhy    false    283            �           0    0    reviews_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);
          public          abdelelbouhy    false    233            �           0    0    roomRental_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."roomRental_id_seq"', 8, true);
          public          abdelelbouhy    false    285            �           0    0    rooms_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.rooms_id_seq', 13, true);
          public          abdelelbouhy    false    319            �           0    0    scheduleItems_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."scheduleItems_id_seq"', 185, true);
          public          abdelelbouhy    false    291            �           0    0    schedules_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.schedules_id_seq', 576, true);
          public          abdelelbouhy    false    293            �           0    0    serviceProviders_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."serviceProviders_id_seq"', 144, true);
          public          abdelelbouhy    false    299            �           0    0    services_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.services_id_seq', 302, true);
          public          abdelelbouhy    false    313            �           0    0    settings_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.settings_id_seq', 2, true);
          public          abdelelbouhy    false    343            �           0    0    subCity_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."subCity_id_seq"', 599, true);
          public          abdelelbouhy    false    345            �           0    0     supplierThirdPartyDetails_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."supplierThirdPartyDetails_id_seq"', 2, true);
          public          abdelelbouhy    false    363            �           0    0    transactions_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.transactions_id_seq', 193, true);
          public          abdelelbouhy    false    275            �           0    0    tripItineraries_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."tripItineraries_id_seq"', 29, true);
          public          abdelelbouhy    false    271            �           0    0    trips_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.trips_id_seq', 5, true);
          public          abdelelbouhy    false    305            �           0    0    units_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.units_id_seq', 1, true);
          public          abdelelbouhy    false    273            �           0    0    uploadFiles_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."uploadFiles_id_seq"', 6375, true);
          public          abdelelbouhy    false    317            �           0    0    userDetails_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."userDetails_id_seq"', 708, true);
          public          abdelelbouhy    false    259            �           0    0    userGroup_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."userGroup_id_seq"', 18, true);
          public          abdelelbouhy    false    243            �           0    0    userPermission_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."userPermission_id_seq"', 314, true);
          public          abdelelbouhy    false    249            �           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 865, true);
          public          abdelelbouhy    false    257            �           0    0    wallets_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.wallets_id_seq', 701, true);
          public          abdelelbouhy    false    239            ^           2606    17102 $   rooms PK_0368a2d7c215f2d0458a54933f2 
   CONSTRAINT     d   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT "PK_0368a2d7c215f2d0458a54933f2" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.rooms DROP CONSTRAINT "PK_0368a2d7c215f2d0458a54933f2";
       public            abdelelbouhy    false    320            �           2606    18442 '   settings PK_0669fe20e252eb692bf4d344975 
   CONSTRAINT     g   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT "PK_0669fe20e252eb692bf4d344975" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.settings DROP CONSTRAINT "PK_0669fe20e252eb692bf4d344975";
       public            abdelelbouhy    false    344            z           2606    17725 +   activity_log PK_067d761e2956b77b14e534fd6f1 
   CONSTRAINT     k   ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT "PK_067d761e2956b77b14e534fd6f1" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.activity_log DROP CONSTRAINT "PK_067d761e2956b77b14e534fd6f1";
       public            abdelelbouhy    false    338            �           2606    16602 /   group_permission PK_12f86c54cc64469ecdb10edc29d 
   CONSTRAINT     o   ALTER TABLE ONLY public.group_permission
    ADD CONSTRAINT "PK_12f86c54cc64469ecdb10edc29d" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public.group_permission DROP CONSTRAINT "PK_12f86c54cc64469ecdb10edc29d";
       public            abdelelbouhy    false    248            v           2606    17180 (   exchanges PK_17ccd29473f939c68de98c2cea3 
   CONSTRAINT     h   ALTER TABLE ONLY public.exchanges
    ADD CONSTRAINT "PK_17ccd29473f939c68de98c2cea3" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.exchanges DROP CONSTRAINT "PK_17ccd29473f939c68de98c2cea3";
       public            abdelelbouhy    false    334                       2606    16746 .   tripItineraries PK_18935091aded1e2fc59994a6e0d 
   CONSTRAINT     p   ALTER TABLE ONLY public."tripItineraries"
    ADD CONSTRAINT "PK_18935091aded1e2fc59994a6e0d" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."tripItineraries" DROP CONSTRAINT "PK_18935091aded1e2fc59994a6e0d";
       public            abdelelbouhy    false    272            �           2606    18680 2   available_amenities PK_22662ee1fc9742cd7c053f303e8 
   CONSTRAINT     r   ALTER TABLE ONLY public.available_amenities
    ADD CONSTRAINT "PK_22662ee1fc9742cd7c053f303e8" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.available_amenities DROP CONSTRAINT "PK_22662ee1fc9742cd7c053f303e8";
       public            abdelelbouhy    false    348            �           2606    16543 &   reviews PK_231ae565c273ee700b283f15c1d 
   CONSTRAINT     f   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "PK_231ae565c273ee700b283f15c1d" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "PK_231ae565c273ee700b283f15c1d";
       public            abdelelbouhy    false    234            �           2606    16492 )   categories PK_24dbc6126a28ff948da33e97d3b 
   CONSTRAINT     i   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_24dbc6126a28ff948da33e97d3b" PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.categories DROP CONSTRAINT "PK_24dbc6126a28ff948da33e97d3b";
       public            abdelelbouhy    false    224            Z           2606    17086 *   uploadFiles PK_2877095f73684d7a395ec3b6c2b 
   CONSTRAINT     l   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "PK_2877095f73684d7a395ec3b6c2b" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "PK_2877095f73684d7a395ec3b6c2b";
       public            abdelelbouhy    false    318            :           2606    16951 %   prices PK_2e40b9e4e631a53cd514d82ccd2 
   CONSTRAINT     e   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "PK_2e40b9e4e631a53cd514d82ccd2" PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "PK_2e40b9e4e631a53cd514d82ccd2";
       public            abdelelbouhy    false    296                       2606    16686 *   userDetails PK_35f9ec44d0772d64d68f5417c6b 
   CONSTRAINT     l   ALTER TABLE ONLY public."userDetails"
    ADD CONSTRAINT "PK_35f9ec44d0772d64d68f5417c6b" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."userDetails" DROP CONSTRAINT "PK_35f9ec44d0772d64d68f5417c6b";
       public            abdelelbouhy    false    260            �           2606    16503 $   banks PK_3975b5f684ec241e3901db62d77 
   CONSTRAINT     d   ALTER TABLE ONLY public.banks
    ADD CONSTRAINT "PK_3975b5f684ec241e3901db62d77" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.banks DROP CONSTRAINT "PK_3975b5f684ec241e3901db62d77";
       public            abdelelbouhy    false    226            `           2606    17109 +   boatActivity PK_3bb7ba518026dcb6c863f022a3c 
   CONSTRAINT     m   ALTER TABLE ONLY public."boatActivity"
    ADD CONSTRAINT "PK_3bb7ba518026dcb6c863f022a3c" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."boatActivity" DROP CONSTRAINT "PK_3bb7ba518026dcb6c863f022a3c";
       public            abdelelbouhy    false    322            <           2606    16964 &   courses PK_3f70a487cc718ad8eda4e6d58c9 
   CONSTRAINT     f   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "PK_3f70a487cc718ad8eda4e6d58c9" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "PK_3f70a487cc718ad8eda4e6d58c9";
       public            abdelelbouhy    false    298            L           2606    17007 )   branchTrip PK_417d7fa3722c1177e4f7d0f08bb 
   CONSTRAINT     k   ALTER TABLE ONLY public."branchTrip"
    ADD CONSTRAINT "PK_417d7fa3722c1177e4f7d0f08bb" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."branchTrip" DROP CONSTRAINT "PK_417d7fa3722c1177e4f7d0f08bb";
       public            abdelelbouhy    false    304            P           2606    17030 %   cities PK_4762ffb6e5d198cfec5606bc11e 
   CONSTRAINT     e   ALTER TABLE ONLY public.cities
    ADD CONSTRAINT "PK_4762ffb6e5d198cfec5606bc11e" PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.cities DROP CONSTRAINT "PK_4762ffb6e5d198cfec5606bc11e";
       public            abdelelbouhy    false    308            �           2606    16523 +   branchCourse PK_478ec097bfef059e81fd64d2fe7 
   CONSTRAINT     m   ALTER TABLE ONLY public."branchCourse"
    ADD CONSTRAINT "PK_478ec097bfef059e81fd64d2fe7" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."branchCourse" DROP CONSTRAINT "PK_478ec097bfef059e81fd64d2fe7";
       public            abdelelbouhy    false    230            �           2606    16552 '   favorite PK_495675cec4fb09666704e4f610f 
   CONSTRAINT     g   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "PK_495675cec4fb09666704e4f610f" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "PK_495675cec4fb09666704e4f610f";
       public            abdelelbouhy    false    236            T           2606    17051 ,   branchService PK_4e3ea6a8b0fe337338347c3394a 
   CONSTRAINT     n   ALTER TABLE ONLY public."branchService"
    ADD CONSTRAINT "PK_4e3ea6a8b0fe337338347c3394a" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."branchService" DROP CONSTRAINT "PK_4e3ea6a8b0fe337338347c3394a";
       public            abdelelbouhy    false    312            �           2606    18483 &   subCity PK_4e7c3472570f7884f7bee322c3e 
   CONSTRAINT     h   ALTER TABLE ONLY public."subCity"
    ADD CONSTRAINT "PK_4e7c3472570f7884f7bee322c3e" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."subCity" DROP CONSTRAINT "PK_4e7c3472570f7884f7bee322c3e";
       public            abdelelbouhy    false    346                       2606    16648 +   pricingPlans PK_5486d72595055dee6d763f1882b 
   CONSTRAINT     m   ALTER TABLE ONLY public."pricingPlans"
    ADD CONSTRAINT "PK_5486d72595055dee6d763f1882b" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."pricingPlans" DROP CONSTRAINT "PK_5486d72595055dee6d763f1882b";
       public            abdelelbouhy    false    256            �           2606    16532 $   guest PK_57689d19445de01737dbc458857 
   CONSTRAINT     d   ALTER TABLE ONLY public.guest
    ADD CONSTRAINT "PK_57689d19445de01737dbc458857" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.guest DROP CONSTRAINT "PK_57689d19445de01737dbc458857";
       public            abdelelbouhy    false    232                       2606    16755 $   units PK_5a8f2f064919b587d93936cb223 
   CONSTRAINT     d   ALTER TABLE ONLY public.units
    ADD CONSTRAINT "PK_5a8f2f064919b587d93936cb223" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.units DROP CONSTRAINT "PK_5a8f2f064919b587d93936cb223";
       public            abdelelbouhy    false    274                       2606    16735 /   equipmentRentals PK_5de194c45157fb9e7822584f84a 
   CONSTRAINT     q   ALTER TABLE ONLY public."equipmentRentals"
    ADD CONSTRAINT "PK_5de194c45157fb9e7822584f84a" PRIMARY KEY (id);
 ]   ALTER TABLE ONLY public."equipmentRentals" DROP CONSTRAINT "PK_5de194c45157fb9e7822584f84a";
       public            abdelelbouhy    false    270            �           2606    19009 5   custom_payment_options PK_6240483154c38df84b1a738b44e 
   CONSTRAINT     u   ALTER TABLE ONLY public.custom_payment_options
    ADD CONSTRAINT "PK_6240483154c38df84b1a738b44e" PRIMARY KEY (id);
 a   ALTER TABLE ONLY public.custom_payment_options DROP CONSTRAINT "PK_6240483154c38df84b1a738b44e";
       public            abdelelbouhy    false    358            ~           2606    17804 *   payment_way PK_64931a4086462262c508a783c21 
   CONSTRAINT     j   ALTER TABLE ONLY public.payment_way
    ADD CONSTRAINT "PK_64931a4086462262c508a783c21" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.payment_way DROP CONSTRAINT "PK_64931a4086462262c508a783c21";
       public            abdelelbouhy    false    342            �           2606    19586 /   provider_contact PK_6594e561946063efacf15bb1197 
   CONSTRAINT     o   ALTER TABLE ONLY public.provider_contact
    ADD CONSTRAINT "PK_6594e561946063efacf15bb1197" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public.provider_contact DROP CONSTRAINT "PK_6594e561946063efacf15bb1197";
       public            abdelelbouhy    false    362            �           2606    16595 %   groups PK_659d1483316afb28afd3a90646e 
   CONSTRAINT     e   ALTER TABLE ONLY public.groups
    ADD CONSTRAINT "PK_659d1483316afb28afd3a90646e" PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.groups DROP CONSTRAINT "PK_659d1483316afb28afd3a90646e";
       public            abdelelbouhy    false    246            0           2606    16916 (   itemTimes PK_66a06181b5282e06d34f87b4e06 
   CONSTRAINT     j   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "PK_66a06181b5282e06d34f87b4e06" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "PK_66a06181b5282e06d34f87b4e06";
       public            abdelelbouhy    false    290            &           2606    16860 ,   notifications PK_6a72c3c0f683f6462415e653c3a 
   CONSTRAINT     l   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a";
       public            abdelelbouhy    false    282                       2606    16715 ,   organizations PK_6b031fcd0863e3f6b44230163f9 
   CONSTRAINT     l   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT "PK_6b031fcd0863e3f6b44230163f9" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.organizations DROP CONSTRAINT "PK_6b031fcd0863e3f6b44230163f9";
       public            abdelelbouhy    false    266            �           2606    16481 -   boatEquipments PK_73c69f0a1be9d2dc98a82d19e7f 
   CONSTRAINT     o   ALTER TABLE ONLY public."boatEquipments"
    ADD CONSTRAINT "PK_73c69f0a1be9d2dc98a82d19e7f" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public."boatEquipments" DROP CONSTRAINT "PK_73c69f0a1be9d2dc98a82d19e7f";
       public            abdelelbouhy    false    222            >           2606    16976 /   serviceProviders PK_74465e86dba18eca3f696c388ca 
   CONSTRAINT     q   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "PK_74465e86dba18eca3f696c388ca" PRIMARY KEY (id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "PK_74465e86dba18eca3f696c388ca";
       public            abdelelbouhy    false    300            d           2606    17133 (   addresses PK_745d8f43d3af10ab8247465e450 
   CONSTRAINT     h   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "PK_745d8f43d3af10ab8247465e450" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "PK_745d8f43d3af10ab8247465e450";
       public            abdelelbouhy    false    326            8           2606    16940 (   schedules PK_7e33fc2ea755a5765e3564e66dd 
   CONSTRAINT     h   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "PK_7e33fc2ea755a5765e3564e66dd" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "PK_7e33fc2ea755a5765e3564e66dd";
       public            abdelelbouhy    false    294            b           2606    17122 $   boats PK_7f192e10b468d99557a0aede7e5 
   CONSTRAINT     d   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "PK_7f192e10b468d99557a0aede7e5" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "PK_7f192e10b468d99557a0aede7e5";
       public            abdelelbouhy    false    324            H           2606    16996 '   branches PK_7f37d3b42defea97f1df0d19535 
   CONSTRAINT     g   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "PK_7f37d3b42defea97f1df0d19535" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "PK_7f37d3b42defea97f1df0d19535";
       public            abdelelbouhy    false    302            R           2606    17042 )   activities PK_7f4004429f731ffb9c88eb486a8 
   CONSTRAINT     i   ALTER TABLE ONLY public.activities
    ADD CONSTRAINT "PK_7f4004429f731ffb9c88eb486a8" PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.activities DROP CONSTRAINT "PK_7f4004429f731ffb9c88eb486a8";
       public            abdelelbouhy    false    310            �           2606    16568 &   wallets PK_8402e5df5a30a229380e83e4f7e 
   CONSTRAINT     f   ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "PK_8402e5df5a30a229380e83e4f7e" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.wallets DROP CONSTRAINT "PK_8402e5df5a30a229380e83e4f7e";
       public            abdelelbouhy    false    240            �           2606    16586 (   userGroup PK_858e0887636a55b726ff3b2bcf1 
   CONSTRAINT     j   ALTER TABLE ONLY public."userGroup"
    ADD CONSTRAINT "PK_858e0887636a55b726ff3b2bcf1" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public."userGroup" DROP CONSTRAINT "PK_858e0887636a55b726ff3b2bcf1";
       public            abdelelbouhy    false    244            �           2606    16561 )   payMethods PK_88ffeb20acd384bf51c4e188c3f 
   CONSTRAINT     k   ALTER TABLE ONLY public."payMethods"
    ADD CONSTRAINT "PK_88ffeb20acd384bf51c4e188c3f" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."payMethods" DROP CONSTRAINT "PK_88ffeb20acd384bf51c4e188c3f";
       public            abdelelbouhy    false    238            �           2606    16453 )   migrations PK_8c82d7f526340ab734260ea46be 
   CONSTRAINT     i   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.migrations DROP CONSTRAINT "PK_8c82d7f526340ab734260ea46be";
       public            abdelelbouhy    false    217            $           2606    16824 +   itemRequests PK_9100bc2b2feb5a8f46773a25f19 
   CONSTRAINT     m   ALTER TABLE ONLY public."itemRequests"
    ADD CONSTRAINT "PK_9100bc2b2feb5a8f46773a25f19" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."itemRequests" DROP CONSTRAINT "PK_9100bc2b2feb5a8f46773a25f19";
       public            abdelelbouhy    false    280            �           2606    16618 *   permissions PK_920331560282b8bd21bb02290df 
   CONSTRAINT     j   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT "PK_920331560282b8bd21bb02290df" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.permissions DROP CONSTRAINT "PK_920331560282b8bd21bb02290df";
       public            abdelelbouhy    false    252            x           2606    17703 .   loyalty_program PK_926584ab2a6ed625138cce7c134 
   CONSTRAINT     n   ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT "PK_926584ab2a6ed625138cce7c134" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.loyalty_program DROP CONSTRAINT "PK_926584ab2a6ed625138cce7c134";
       public            abdelelbouhy    false    336            "           2606    16789 +   applications PK_938c0a27255637bde919591888f 
   CONSTRAINT     k   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT "PK_938c0a27255637bde919591888f" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.applications DROP CONSTRAINT "PK_938c0a27255637bde919591888f";
       public            abdelelbouhy    false    278                       2606    16706 )   boatSafety PK_9e71f68258e055888e7eb6cf807 
   CONSTRAINT     k   ALTER TABLE ONLY public."boatSafety"
    ADD CONSTRAINT "PK_9e71f68258e055888e7eb6cf807" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."boatSafety" DROP CONSTRAINT "PK_9e71f68258e055888e7eb6cf807";
       public            abdelelbouhy    false    264                       2606    16771 +   transactions PK_a219afd8dd77ed80f5a862f1db9 
   CONSTRAINT     k   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "PK_a219afd8dd77ed80f5a862f1db9" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "PK_a219afd8dd77ed80f5a862f1db9";
       public            abdelelbouhy    false    276                       2606    16673 $   users PK_a3ffb1c0c8416b9fc6f907b7433 
   CONSTRAINT     d   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.users DROP CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433";
       public            abdelelbouhy    false    258            n           2606    17152 -   accommodations PK_a422a200297f93cd5ac87d049e8 
   CONSTRAINT     m   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "PK_a422a200297f93cd5ac87d049e8" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "PK_a422a200297f93cd5ac87d049e8";
       public            abdelelbouhy    false    328            �           2606    18691 '   excludes PK_a439afb4d03ef5a537bd1b8c973 
   CONSTRAINT     g   ALTER TABLE ONLY public.excludes
    ADD CONSTRAINT "PK_a439afb4d03ef5a537bd1b8c973" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.excludes DROP CONSTRAINT "PK_a439afb4d03ef5a537bd1b8c973";
       public            abdelelbouhy    false    350            �           2606    16609 -   userPermission PK_a8af9ac1595cc54a5d087ba82f1 
   CONSTRAINT     o   ALTER TABLE ONLY public."userPermission"
    ADD CONSTRAINT "PK_a8af9ac1595cc54a5d087ba82f1" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public."userPermission" DROP CONSTRAINT "PK_a8af9ac1595cc54a5d087ba82f1";
       public            abdelelbouhy    false    250            6           2606    16927 ,   scheduleItems PK_ada58e0790d2d96664862903fb9 
   CONSTRAINT     n   ALTER TABLE ONLY public."scheduleItems"
    ADD CONSTRAINT "PK_ada58e0790d2d96664862903fb9" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."scheduleItems" DROP CONSTRAINT "PK_ada58e0790d2d96664862903fb9";
       public            abdelelbouhy    false    292                       2606    16697 +   boatFeatures PK_adef14c3b25cf7873d57a2e92c3 
   CONSTRAINT     m   ALTER TABLE ONLY public."boatFeatures"
    ADD CONSTRAINT "PK_adef14c3b25cf7873d57a2e92c3" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."boatFeatures" DROP CONSTRAINT "PK_adef14c3b25cf7873d57a2e92c3";
       public            abdelelbouhy    false    262            �           2606    16579 &   devices PK_b1514758245c12daf43486dd1f0 
   CONSTRAINT     f   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT "PK_b1514758245c12daf43486dd1f0" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.devices DROP CONSTRAINT "PK_b1514758245c12daf43486dd1f0";
       public            abdelelbouhy    false    242                       2606    16728 (   countries PK_b2d7006793e8697ab3ae2deff18 
   CONSTRAINT     h   ALTER TABLE ONLY public.countries
    ADD CONSTRAINT "PK_b2d7006793e8697ab3ae2deff18" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.countries DROP CONSTRAINT "PK_b2d7006793e8697ab3ae2deff18";
       public            abdelelbouhy    false    268            *           2606    16896 )   roomRental PK_b84689a31f60fb2df7c6692936b 
   CONSTRAINT     k   ALTER TABLE ONLY public."roomRental"
    ADD CONSTRAINT "PK_b84689a31f60fb2df7c6692936b" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."roomRental" DROP CONSTRAINT "PK_b84689a31f60fb2df7c6692936b";
       public            abdelelbouhy    false    286            V           2606    17065 '   services PK_ba2d347a3168a296416c6c5ccb2 
   CONSTRAINT     g   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "PK_ba2d347a3168a296416c6c5ccb2" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "PK_ba2d347a3168a296416c6c5ccb2";
       public            abdelelbouhy    false    314            .           2606    16909 .   reservationItem PK_baa5fc55765f4f3a322f852414d 
   CONSTRAINT     p   ALTER TABLE ONLY public."reservationItem"
    ADD CONSTRAINT "PK_baa5fc55765f4f3a322f852414d" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."reservationItem" DROP CONSTRAINT "PK_baa5fc55765f4f3a322f852414d";
       public            abdelelbouhy    false    288            �           2606    19037 *   recurrences PK_bc886e2f5042804348556c33a2c 
   CONSTRAINT     j   ALTER TABLE ONLY public.recurrences
    ADD CONSTRAINT "PK_bc886e2f5042804348556c33a2c" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.recurrences DROP CONSTRAINT "PK_bc886e2f5042804348556c33a2c";
       public            abdelelbouhy    false    360            X           2606    17074 (   amenities PK_c0777308847b3556086f2fb233e 
   CONSTRAINT     h   ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT "PK_c0777308847b3556086f2fb233e" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.amenities DROP CONSTRAINT "PK_c0777308847b3556086f2fb233e";
       public            abdelelbouhy    false    316                        2606    16638 (   inquiries PK_ceacaa439988b25eb9459e694d9 
   CONSTRAINT     h   ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT "PK_ceacaa439988b25eb9459e694d9" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.inquiries DROP CONSTRAINT "PK_ceacaa439988b25eb9459e694d9";
       public            abdelelbouhy    false    254            �           2606    19671 8   supplierThirdPartyDetails PK_d0af4deac602fb821084e515034 
   CONSTRAINT     z   ALTER TABLE ONLY public."supplierThirdPartyDetails"
    ADD CONSTRAINT "PK_d0af4deac602fb821084e515034" PRIMARY KEY (id);
 f   ALTER TABLE ONLY public."supplierThirdPartyDetails" DROP CONSTRAINT "PK_d0af4deac602fb821084e515034";
       public            abdelelbouhy    false    364            |           2606    17736 8   loyalty_program_withdraws PK_d37982e764392ea976a899ff86f 
   CONSTRAINT     x   ALTER TABLE ONLY public.loyalty_program_withdraws
    ADD CONSTRAINT "PK_d37982e764392ea976a899ff86f" PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.loyalty_program_withdraws DROP CONSTRAINT "PK_d37982e764392ea976a899ff86f";
       public            abdelelbouhy    false    340            r           2606    17161 0   applicationVisits PK_d3a7ece045ad7ee3bd12bb5c995 
   CONSTRAINT     r   ALTER TABLE ONLY public."applicationVisits"
    ADD CONSTRAINT "PK_d3a7ece045ad7ee3bd12bb5c995" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."applicationVisits" DROP CONSTRAINT "PK_d3a7ece045ad7ee3bd12bb5c995";
       public            abdelelbouhy    false    330            �           2606    16514 (   companies PK_d4bc3e82a314fa9e29f652c2c22 
   CONSTRAINT     h   ALTER TABLE ONLY public.companies
    ADD CONSTRAINT "PK_d4bc3e82a314fa9e29f652c2c22" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.companies DROP CONSTRAINT "PK_d4bc3e82a314fa9e29f652c2c22";
       public            abdelelbouhy    false    228            �           2606    16469 )   currencies PK_d528c54860c4182db13548e08c4 
   CONSTRAINT     i   ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT "PK_d528c54860c4182db13548e08c4" PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.currencies DROP CONSTRAINT "PK_d528c54860c4182db13548e08c4";
       public            abdelelbouhy    false    220            �           2606    18983 $   court PK_d8f2118c52b422b03e0331a7b91 
   CONSTRAINT     d   ALTER TABLE ONLY public.court
    ADD CONSTRAINT "PK_d8f2118c52b422b03e0331a7b91" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.court DROP CONSTRAINT "PK_d8f2118c52b422b03e0331a7b91";
       public            abdelelbouhy    false    356            (           2606    16887 +   reservations PK_da95cef71b617ac35dc5bcda243 
   CONSTRAINT     k   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "PK_da95cef71b617ac35dc5bcda243" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.reservations DROP CONSTRAINT "PK_da95cef71b617ac35dc5bcda243";
       public            abdelelbouhy    false    284            t           2606    17170 4   branchEquipmentRental PK_ee8ece4f4956609a628465e3708 
   CONSTRAINT     v   ALTER TABLE ONLY public."branchEquipmentRental"
    ADD CONSTRAINT "PK_ee8ece4f4956609a628465e3708" PRIMARY KEY (id);
 b   ALTER TABLE ONLY public."branchEquipmentRental" DROP CONSTRAINT "PK_ee8ece4f4956609a628465e3708";
       public            abdelelbouhy    false    332            �           2606    18971 2   custom_per_hour_day PK_eeaff69f365217134afd46f7d43 
   CONSTRAINT     r   ALTER TABLE ONLY public.custom_per_hour_day
    ADD CONSTRAINT "PK_eeaff69f365217134afd46f7d43" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.custom_per_hour_day DROP CONSTRAINT "PK_eeaff69f365217134afd46f7d43";
       public            abdelelbouhy    false    354            �           2606    18960 3   per_hour_price_range PK_f1d09b266e225a97c71c6def461 
   CONSTRAINT     s   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "PK_f1d09b266e225a97c71c6def461" PRIMARY KEY (id);
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "PK_f1d09b266e225a97c71c6def461";
       public            abdelelbouhy    false    352            N           2606    17019 $   trips PK_f71c231dee9c05a9522f9e840f5 
   CONSTRAINT     d   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "PK_f71c231dee9c05a9522f9e840f5" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "PK_f71c231dee9c05a9522f9e840f5";
       public            abdelelbouhy    false    306            f           2606    17141 (   addresses REL_21b07f425d667f94949fcc0791 
   CONSTRAINT     k   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_21b07f425d667f94949fcc0791" UNIQUE (company_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_21b07f425d667f94949fcc0791";
       public            abdelelbouhy    false    326            @           2606    16984 /   serviceProviders REL_2d48f1742a279e7a912c542bc6 
   CONSTRAINT     q   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "REL_2d48f1742a279e7a912c542bc6" UNIQUE (bank_id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "REL_2d48f1742a279e7a912c542bc6";
       public            abdelelbouhy    false    300            p           2606    17154 -   accommodations REL_2db82c1775049b6fc0bef24063 
   CONSTRAINT     p   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "REL_2db82c1775049b6fc0bef24063" UNIQUE (address_id);
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "REL_2db82c1775049b6fc0bef24063";
       public            abdelelbouhy    false    328                        2606    16773 +   transactions REL_3f0b8d3da342d862a42b67d5c0 
   CONSTRAINT     r   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "REL_3f0b8d3da342d862a42b67d5c0" UNIQUE (reservation_id);
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "REL_3f0b8d3da342d862a42b67d5c0";
       public            abdelelbouhy    false    276            h           2606    17137 (   addresses REL_5323628dd808ef14b3e39263cd 
   CONSTRAINT     k   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_5323628dd808ef14b3e39263cd" UNIQUE (service_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_5323628dd808ef14b3e39263cd";
       public            abdelelbouhy    false    326            B           2606    16980 /   serviceProviders REL_6012fd887cebc68d6371b23700 
   CONSTRAINT     q   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "REL_6012fd887cebc68d6371b23700" UNIQUE (user_id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "REL_6012fd887cebc68d6371b23700";
       public            abdelelbouhy    false    300            ,           2606    16898 )   roomRental REL_69de05bc4527573321f85edf8d 
   CONSTRAINT     k   ALTER TABLE ONLY public."roomRental"
    ADD CONSTRAINT "REL_69de05bc4527573321f85edf8d" UNIQUE (item_id);
 W   ALTER TABLE ONLY public."roomRental" DROP CONSTRAINT "REL_69de05bc4527573321f85edf8d";
       public            abdelelbouhy    false    286                       2606    16737 /   equipmentRentals REL_76dec177c821074a2eed5a9116 
   CONSTRAINT     q   ALTER TABLE ONLY public."equipmentRentals"
    ADD CONSTRAINT "REL_76dec177c821074a2eed5a9116" UNIQUE (item_id);
 ]   ALTER TABLE ONLY public."equipmentRentals" DROP CONSTRAINT "REL_76dec177c821074a2eed5a9116";
       public            abdelelbouhy    false    270            j           2606    17135 (   addresses REL_8adde7f90b3f34dd994b20eaca 
   CONSTRAINT     h   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_8adde7f90b3f34dd994b20eaca" UNIQUE (boat_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_8adde7f90b3f34dd994b20eaca";
       public            abdelelbouhy    false    326            �           2606    16570 &   wallets REL_92558c08091598f7a4439586cd 
   CONSTRAINT     f   ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "REL_92558c08091598f7a4439586cd" UNIQUE (user_id);
 R   ALTER TABLE ONLY public.wallets DROP CONSTRAINT "REL_92558c08091598f7a4439586cd";
       public            abdelelbouhy    false    240            l           2606    17139 (   addresses REL_a8c79e2600f0f688b574c162f1 
   CONSTRAINT     j   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_a8c79e2600f0f688b574c162f1" UNIQUE (course_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_a8c79e2600f0f688b574c162f1";
       public            abdelelbouhy    false    326                       2606    16717 ,   organizations REL_b071480a21b1242365ace4c03e 
   CONSTRAINT     n   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT "REL_b071480a21b1242365ace4c03e" UNIQUE (course_id);
 X   ALTER TABLE ONLY public.organizations DROP CONSTRAINT "REL_b071480a21b1242365ace4c03e";
       public            abdelelbouhy    false    266            J           2606    16998 '   branches REL_c03aef26af49e109f784a101ec 
   CONSTRAINT     j   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "REL_c03aef26af49e109f784a101ec" UNIQUE (address_id);
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "REL_c03aef26af49e109f784a101ec";
       public            abdelelbouhy    false    302            
           2606    16688 *   userDetails REL_c1a882f399a453d730c2f4055c 
   CONSTRAINT     l   ALTER TABLE ONLY public."userDetails"
    ADD CONSTRAINT "REL_c1a882f399a453d730c2f4055c" UNIQUE (user_id);
 X   ALTER TABLE ONLY public."userDetails" DROP CONSTRAINT "REL_c1a882f399a453d730c2f4055c";
       public            abdelelbouhy    false    260            \           2606    17090 *   uploadFiles REL_c49c10511acf0024f50906d01a 
   CONSTRAINT     o   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "REL_c49c10511acf0024f50906d01a" UNIQUE (inquiry_id);
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "REL_c49c10511acf0024f50906d01a";
       public            abdelelbouhy    false    318            D           2606    16982 /   serviceProviders REL_e47a3ac28ef9462fae69aaceba 
   CONSTRAINT     t   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "REL_e47a3ac28ef9462fae69aaceba" UNIQUE (company_id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "REL_e47a3ac28ef9462fae69aaceba";
       public            abdelelbouhy    false    300            2           2606    16918 (   itemTimes REL_f909df65f5f3d72941802aade4 
   CONSTRAINT     v   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "REL_f909df65f5f3d72941802aade4" UNIQUE (reservation_item_id);
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "REL_f909df65f5f3d72941802aade4";
       public            abdelelbouhy    false    290            F           2606    16978 /   serviceProviders UQ_7a9f11a88b45dc94ceb4d8c0d4d 
   CONSTRAINT     n   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "UQ_7a9f11a88b45dc94ceb4d8c0d4d" UNIQUE (name);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "UQ_7a9f11a88b45dc94ceb4d8c0d4d";
       public            abdelelbouhy    false    300                       2606    16675 $   users UQ_97672ac88f789774dd47f7c8be3 
   CONSTRAINT     b   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);
 P   ALTER TABLE ONLY public.users DROP CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3";
       public            abdelelbouhy    false    258            �           2606    19039 $   recurrences antiDuplicatedRecurrence 
   CONSTRAINT     �   ALTER TABLE ONLY public.recurrences
    ADD CONSTRAINT "antiDuplicatedRecurrence" UNIQUE (court_id, "endDate", "startTime", "endTime");
 P   ALTER TABLE ONLY public.recurrences DROP CONSTRAINT "antiDuplicatedRecurrence";
       public            abdelelbouhy    false    360    360    360    360            4           2606    19397    itemTimes antiDuplicatedSlots 
   CONSTRAINT     �   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "antiDuplicatedSlots" UNIQUE (item_id, "startTime", "endTime", imported_reserve);
 K   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "antiDuplicatedSlots";
       public            abdelelbouhy    false    290    290    290    290            �           2606    19369    devices unique_token 
   CONSTRAINT     d   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT unique_token UNIQUE (user_id, token, device_id);
 >   ALTER TABLE ONLY public.devices DROP CONSTRAINT unique_token;
       public            abdelelbouhy    false    242    242    242            �           2606    17421 %   prices FK_069941a584af167b698f7ac9c57    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_069941a584af167b698f7ac9c57" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_069941a584af167b698f7ac9c57";
       public          abdelelbouhy    false    296    298    4924            �           2606    17371 .   reservationItem FK_0acace0118d09a48fc55efa67e6    FK CONSTRAINT     �   ALTER TABLE ONLY public."reservationItem"
    ADD CONSTRAINT "FK_0acace0118d09a48fc55efa67e6" FOREIGN KEY ("reservationId") REFERENCES public.reservations(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public."reservationItem" DROP CONSTRAINT "FK_0acace0118d09a48fc55efa67e6";
       public          abdelelbouhy    false    4904    288    284            �           2606    17246 '   favorite FK_0b73fbcf6371cc64893c07db1b9    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_0b73fbcf6371cc64893c07db1b9" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_0b73fbcf6371cc64893c07db1b9";
       public          abdelelbouhy    false    236    4950    314            �           2606    17236 '   favorite FK_0d72f85fd5f30f984ad51887ac6    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_0d72f85fd5f30f984ad51887ac6" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_0d72f85fd5f30f984ad51887ac6";
       public          abdelelbouhy    false    236    298    4924            �           2606    17281 /   group_permission FK_0e55010ae1d72304910446ee8e7    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_permission
    ADD CONSTRAINT "FK_0e55010ae1d72304910446ee8e7" FOREIGN KEY ("group_Id") REFERENCES public.groups(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.group_permission DROP CONSTRAINT "FK_0e55010ae1d72304910446ee8e7";
       public          abdelelbouhy    false    4856    246    248            �           2606    17416 %   prices FK_1182a9f9bfa1370f3a823bd8b86    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_1182a9f9bfa1370f3a823bd8b86" FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_1182a9f9bfa1370f3a823bd8b86";
       public          abdelelbouhy    false    4892    296    274            �           2606    17201 +   branchCourse FK_12130d3d7846ed4dda2681506b5    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchCourse"
    ADD CONSTRAINT "FK_12130d3d7846ed4dda2681506b5" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."branchCourse" DROP CONSTRAINT "FK_12130d3d7846ed4dda2681506b5";
       public          abdelelbouhy    false    4924    298    230            �           2606    17481 '   branches FK_1359c25adc8fa78046837f7ad60    FK CONSTRAINT     �   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "FK_1359c25adc8fa78046837f7ad60" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "FK_1359c25adc8fa78046837f7ad60";
       public          abdelelbouhy    false    258    302    4868            �           2606    17241 '   favorite FK_1cac9d6926ea4b5a95ecb45478c    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_1cac9d6926ea4b5a95ecb45478c" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_1cac9d6926ea4b5a95ecb45478c";
       public          abdelelbouhy    false    236    4962    324            �           2606    17636 $   boats FK_1d32140a23e65433c7785de4811    FK CONSTRAINT     �   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "FK_1d32140a23e65433c7785de4811" FOREIGN KEY (city_id) REFERENCES public.cities(id);
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "FK_1d32140a23e65433c7785de4811";
       public          abdelelbouhy    false    308    324    4944            �           2606    17426 %   prices FK_1f858d2631e4168d38440de398f    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_1f858d2631e4168d38440de398f" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_1f858d2631e4168d38440de398f";
       public          abdelelbouhy    false    296    314    4950            �           2606    17546 '   services FK_1f8d1173481678a035b4a81a4ec    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_1f8d1173481678a035b4a81a4ec" FOREIGN KEY (category_id) REFERENCES public.categories(id);
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_1f8d1173481678a035b4a81a4ec";
       public          abdelelbouhy    false    4830    314    224            �           2606    17581 *   uploadFiles FK_20b45b0f9115c34d14d86fffea7    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_20b45b0f9115c34d14d86fffea7" FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_20b45b0f9115c34d14d86fffea7";
       public          abdelelbouhy    false    318    328    4974            �           2606    17661 (   addresses FK_21b07f425d667f94949fcc07914    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_21b07f425d667f94949fcc07914" FOREIGN KEY (company_id) REFERENCES public.companies(id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_21b07f425d667f94949fcc07914";
       public          abdelelbouhy    false    326    4834    228            �           2606    17361 +   reservations FK_22d254a38b8ce7d6be792d43d4c    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "FK_22d254a38b8ce7d6be792d43d4c" FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.reservations DROP CONSTRAINT "FK_22d254a38b8ce7d6be792d43d4c";
       public          abdelelbouhy    false    294    284    4920            �           2606    17186 -   boatEquipments FK_24217aa21f8008cc727cc23df17    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatEquipments"
    ADD CONSTRAINT "FK_24217aa21f8008cc727cc23df17" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public."boatEquipments" DROP CONSTRAINT "FK_24217aa21f8008cc727cc23df17";
       public          abdelelbouhy    false    324    4962    222            �           2606    17326 .   tripItineraries FK_24c55f8feb095e0515a99796a8f    FK CONSTRAINT     �   ALTER TABLE ONLY public."tripItineraries"
    ADD CONSTRAINT "FK_24c55f8feb095e0515a99796a8f" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public."tripItineraries" DROP CONSTRAINT "FK_24c55f8feb095e0515a99796a8f";
       public          abdelelbouhy    false    306    4942    272            �           2606    17351 ,   notifications FK_264fbdfc991d71f3ae598b76ed1    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "FK_264fbdfc991d71f3ae598b76ed1" FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "FK_264fbdfc991d71f3ae598b76ed1";
       public          abdelelbouhy    false    4840    282    234            �           2606    17476 /   serviceProviders FK_2d48f1742a279e7a912c542bc62    FK CONSTRAINT     �   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "FK_2d48f1742a279e7a912c542bc62" FOREIGN KEY (bank_id) REFERENCES public.banks(id) ON DELETE SET NULL;
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "FK_2d48f1742a279e7a912c542bc62";
       public          abdelelbouhy    false    4832    300    226            �           2606    17666 -   accommodations FK_2db82c1775049b6fc0bef24063f    FK CONSTRAINT     �   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "FK_2db82c1775049b6fc0bef24063f" FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "FK_2db82c1775049b6fc0bef24063f";
       public          abdelelbouhy    false    326    328    4964            �           2606    17531 ,   branchService FK_33ba8869de9f50d6b94c9d82328    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchService"
    ADD CONSTRAINT "FK_33ba8869de9f50d6b94c9d82328" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."branchService" DROP CONSTRAINT "FK_33ba8869de9f50d6b94c9d82328";
       public          abdelelbouhy    false    314    312    4950            �           2606    17196 +   branchCourse FK_386d6db187ee5dcea975724d1d1    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchCourse"
    ADD CONSTRAINT "FK_386d6db187ee5dcea975724d1d1" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."branchCourse" DROP CONSTRAINT "FK_386d6db187ee5dcea975724d1d1";
       public          abdelelbouhy    false    230    4936    302            �           2606    17576 *   uploadFiles FK_3bbf2b4517174ea39708eed9330    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_3bbf2b4517174ea39708eed9330" FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_3bbf2b4517174ea39708eed9330";
       public          abdelelbouhy    false    4958    318    320            �           2606    19016 3   per_hour_price_range FK_3bd0b48f87deb86bc437e85b152    FK CONSTRAINT     �   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "FK_3bd0b48f87deb86bc437e85b152" FOREIGN KEY ("foreignCurrencyId") REFERENCES public.currencies(id);
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "FK_3bd0b48f87deb86bc437e85b152";
       public          abdelelbouhy    false    4826    220    352            �           2606    17571 *   uploadFiles FK_3d8ca1edfb94b9c89636d21e7b2    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_3d8ca1edfb94b9c89636d21e7b2" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_3d8ca1edfb94b9c89636d21e7b2";
       public          abdelelbouhy    false    324    318    4962            �           2606    18989 2   custom_per_hour_day FK_3eba8ec7a110fb5d7c8e8b54470    FK CONSTRAINT     �   ALTER TABLE ONLY public.custom_per_hour_day
    ADD CONSTRAINT "FK_3eba8ec7a110fb5d7c8e8b54470" FOREIGN KEY ("courtId") REFERENCES public.court(id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.custom_per_hour_day DROP CONSTRAINT "FK_3eba8ec7a110fb5d7c8e8b54470";
       public          abdelelbouhy    false    356    354    5004            �           2606    17331 +   transactions FK_3f0b8d3da342d862a42b67d5c02    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "FK_3f0b8d3da342d862a42b67d5c02" FOREIGN KEY (reservation_id) REFERENCES public.reservations(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "FK_3f0b8d3da342d862a42b67d5c02";
       public          abdelelbouhy    false    284    4904    276            �           2606    17551 '   services FK_421b94f0ef1cdb407654e67c59e    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_421b94f0ef1cdb407654e67c59e" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_421b94f0ef1cdb407654e67c59e";
       public          abdelelbouhy    false    4868    314    258            �           2606    19021 (   itemTimes FK_431f9477ab1f3be0f320fcfa458    FK CONSTRAINT     �   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "FK_431f9477ab1f3be0f320fcfa458" FOREIGN KEY (item_id) REFERENCES public.court(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "FK_431f9477ab1f3be0f320fcfa458";
       public          abdelelbouhy    false    290    5004    356            �           2606    17521 )   activities FK_463b4906ce5cd0817cbc2d0999a    FK CONSTRAINT     �   ALTER TABLE ONLY public.activities
    ADD CONSTRAINT "FK_463b4906ce5cd0817cbc2d0999a" FOREIGN KEY (city_id) REFERENCES public.cities(id);
 U   ALTER TABLE ONLY public.activities DROP CONSTRAINT "FK_463b4906ce5cd0817cbc2d0999a";
       public          abdelelbouhy    false    308    4944    310            �           2606    17436 %   prices FK_524b24ea7870382af4202ef0ce2    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_524b24ea7870382af4202ef0ce2" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_524b24ea7870382af4202ef0ce2";
       public          abdelelbouhy    false    296    4942    306            �           2606    17651 (   addresses FK_5323628dd808ef14b3e39263cd8    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_5323628dd808ef14b3e39263cd8" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_5323628dd808ef14b3e39263cd8";
       public          abdelelbouhy    false    326    4950    314            �           2606    17401 (   schedules FK_55e6651198104efea0b04568a88    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "FK_55e6651198104efea0b04568a88" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "FK_55e6651198104efea0b04568a88";
       public          abdelelbouhy    false    258    294    4868            �           2606    17616 +   boatActivity FK_591ed4a7ad448d4fb6b8b12b4a5    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatActivity"
    ADD CONSTRAINT "FK_591ed4a7ad448d4fb6b8b12b4a5" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."boatActivity" DROP CONSTRAINT "FK_591ed4a7ad448d4fb6b8b12b4a5";
       public          abdelelbouhy    false    322    4962    324            �           2606    17601 *   uploadFiles FK_5b4c3b94721ee97608c52741e9c    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_5b4c3b94721ee97608c52741e9c" FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_5b4c3b94721ee97608c52741e9c";
       public          abdelelbouhy    false    4880    266    318            �           2606    17181 -   boatEquipments FK_5d727aa852f8f7ed71304d30c7a    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatEquipments"
    ADD CONSTRAINT "FK_5d727aa852f8f7ed71304d30c7a" FOREIGN KEY (currency_id) REFERENCES public.currencies(id);
 [   ALTER TABLE ONLY public."boatEquipments" DROP CONSTRAINT "FK_5d727aa852f8f7ed71304d30c7a";
       public          abdelelbouhy    false    222    220    4826            �           2606    17266 &   devices FK_5e9bee993b4ce35c3606cda194c    FK CONSTRAINT     �   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT "FK_5e9bee993b4ce35c3606cda194c" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.devices DROP CONSTRAINT "FK_5e9bee993b4ce35c3606cda194c";
       public          abdelelbouhy    false    258    4868    242            �           2606    17466 /   serviceProviders FK_6012fd887cebc68d6371b237004    FK CONSTRAINT     �   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "FK_6012fd887cebc68d6371b237004" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "FK_6012fd887cebc68d6371b237004";
       public          abdelelbouhy    false    258    4868    300            �           2606    17461 &   courses FK_6158bff272157e1e16498eed44d    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_6158bff272157e1e16498eed44d" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_6158bff272157e1e16498eed44d";
       public          abdelelbouhy    false    300    4926    298            �           2606    17671 -   accommodations FK_61a6f64ec973fe15b0b6cbfaf72    FK CONSTRAINT     �   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "FK_61a6f64ec973fe15b0b6cbfaf72" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "FK_61a6f64ec973fe15b0b6cbfaf72";
       public          abdelelbouhy    false    328    258    4868            �           2606    17276 (   userGroup FK_61d2057e882356891f6cf9eafa7    FK CONSTRAINT     �   ALTER TABLE ONLY public."userGroup"
    ADD CONSTRAINT "FK_61d2057e882356891f6cf9eafa7" FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."userGroup" DROP CONSTRAINT "FK_61d2057e882356891f6cf9eafa7";
       public          abdelelbouhy    false    4856    246    244            �           2606    17431 %   prices FK_629f61f9867f39346ae1df5b862    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_629f61f9867f39346ae1df5b862" FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_629f61f9867f39346ae1df5b862";
       public          abdelelbouhy    false    294    4920    296            �           2606    17206 $   guest FK_634c70ef4f0a25b35ba169574de    FK CONSTRAINT     �   ALTER TABLE ONLY public.guest
    ADD CONSTRAINT "FK_634c70ef4f0a25b35ba169574de" FOREIGN KEY ("reservationId") REFERENCES public.reservations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.guest DROP CONSTRAINT "FK_634c70ef4f0a25b35ba169574de";
       public          abdelelbouhy    false    284    4904    232            �           2606    17216 &   reviews FK_6587db79174d07150fde1f1a4d6    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_6587db79174d07150fde1f1a4d6" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_6587db79174d07150fde1f1a4d6";
       public          abdelelbouhy    false    314    234    4950            �           2606    17386 ,   scheduleItems FK_665caa1f0e355060a3359d3f3dc    FK CONSTRAINT     �   ALTER TABLE ONLY public."scheduleItems"
    ADD CONSTRAINT "FK_665caa1f0e355060a3359d3f3dc" FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."scheduleItems" DROP CONSTRAINT "FK_665caa1f0e355060a3359d3f3dc";
       public          abdelelbouhy    false    4920    292    294            �           2606    17511 $   trips FK_6953304630116af4602dc6e3b35    FK CONSTRAINT     �   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "FK_6953304630116af4602dc6e3b35" FOREIGN KEY (currency_id) REFERENCES public.currencies(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "FK_6953304630116af4602dc6e3b35";
       public          abdelelbouhy    false    220    4826    306            �           2606    17366 )   roomRental FK_69de05bc4527573321f85edf8d1    FK CONSTRAINT     �   ALTER TABLE ONLY public."roomRental"
    ADD CONSTRAINT "FK_69de05bc4527573321f85edf8d1" FOREIGN KEY (item_id) REFERENCES public."reservationItem"(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."roomRental" DROP CONSTRAINT "FK_69de05bc4527573321f85edf8d1";
       public          abdelelbouhy    false    4910    286    288            �           2606    17611 $   rooms FK_6a64e95ff8396f2ca8ff008e441    FK CONSTRAINT     �   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT "FK_6a64e95ff8396f2ca8ff008e441" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.rooms DROP CONSTRAINT "FK_6a64e95ff8396f2ca8ff008e441";
       public          abdelelbouhy    false    324    320    4962            �           2606    17586 *   uploadFiles FK_6bcbc913c553d3ec55cdb8ce2e7    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_6bcbc913c553d3ec55cdb8ce2e7" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_6bcbc913c553d3ec55cdb8ce2e7";
       public          abdelelbouhy    false    318    298    4924            �           2606    17336 +   transactions FK_6cbed86cedb31104e975a579d10    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "FK_6cbed86cedb31104e975a579d10" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id);
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "FK_6cbed86cedb31104e975a579d10";
       public          abdelelbouhy    false    4926    300    276            �           2606    17226 &   reviews FK_728447781a30bc3fcfe5c2f1cdf    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_728447781a30bc3fcfe5c2f1cdf" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_728447781a30bc3fcfe5c2f1cdf";
       public          abdelelbouhy    false    234    258    4868            �           2606    17321 /   equipmentRentals FK_76dec177c821074a2eed5a91162    FK CONSTRAINT     �   ALTER TABLE ONLY public."equipmentRentals"
    ADD CONSTRAINT "FK_76dec177c821074a2eed5a91162" FOREIGN KEY (item_id) REFERENCES public."reservationItem"(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public."equipmentRentals" DROP CONSTRAINT "FK_76dec177c821074a2eed5a91162";
       public          abdelelbouhy    false    288    4910    270            �           2606    17556 '   services FK_7790290d3a7e8a22cb738f055c0    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_7790290d3a7e8a22cb738f055c0" FOREIGN KEY ("cityId") REFERENCES public.cities(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_7790290d3a7e8a22cb738f055c0";
       public          abdelelbouhy    false    4944    314    308            �           2606    17346 ,   notifications FK_7814037821140da2a093c972336    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "FK_7814037821140da2a093c972336" FOREIGN KEY (reservation_id) REFERENCES public.reservations(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "FK_7814037821140da2a093c972336";
       public          abdelelbouhy    false    282    4904    284            �           2606    17631 $   boats FK_7a2278b3104d396ca29ad90dc52    FK CONSTRAINT     �   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "FK_7a2278b3104d396ca29ad90dc52" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "FK_7a2278b3104d396ca29ad90dc52";
       public          abdelelbouhy    false    4926    300    324            �           2606    19011 3   per_hour_price_range FK_81a1517f93422a6717c769a36d7    FK CONSTRAINT     �   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "FK_81a1517f93422a6717c769a36d7" FOREIGN KEY ("egyptianCurrencyId") REFERENCES public.currencies(id);
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "FK_81a1517f93422a6717c769a36d7";
       public          abdelelbouhy    false    4826    352    220            �           2606    17561 (   amenities FK_85f93e760d004922a71bf914676    FK CONSTRAINT     �   ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT "FK_85f93e760d004922a71bf914676" FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.amenities DROP CONSTRAINT "FK_85f93e760d004922a71bf914676";
       public          abdelelbouhy    false    4974    316    328            �           2606    17646 (   addresses FK_8adde7f90b3f34dd994b20eacad    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_8adde7f90b3f34dd994b20eacad" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_8adde7f90b3f34dd994b20eacad";
       public          abdelelbouhy    false    324    326    4962            �           2606    17356 +   reservations FK_8e65d43933cbb37928f015ba42b    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "FK_8e65d43933cbb37928f015ba42b" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.reservations DROP CONSTRAINT "FK_8e65d43933cbb37928f015ba42b";
       public          abdelelbouhy    false    306    284    4942            �           2606    17566 (   amenities FK_9180945dcb1888c561fb3099bf2    FK CONSTRAINT     �   ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT "FK_9180945dcb1888c561fb3099bf2" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.amenities DROP CONSTRAINT "FK_9180945dcb1888c561fb3099bf2";
       public          abdelelbouhy    false    314    316    4950            �           2606    17626 $   boats FK_91a8892b04a4603324c43950849    FK CONSTRAINT     �   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "FK_91a8892b04a4603324c43950849" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "FK_91a8892b04a4603324c43950849";
       public          abdelelbouhy    false    4868    258    324            �           2606    17261 &   wallets FK_92558c08091598f7a4439586cda    FK CONSTRAINT     �   ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "FK_92558c08091598f7a4439586cda" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.wallets DROP CONSTRAINT "FK_92558c08091598f7a4439586cda";
       public          abdelelbouhy    false    258    4868    240            �           2606    17496 )   branchTrip FK_93810c72bba2e6fa802386d2000    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchTrip"
    ADD CONSTRAINT "FK_93810c72bba2e6fa802386d2000" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."branchTrip" DROP CONSTRAINT "FK_93810c72bba2e6fa802386d2000";
       public          abdelelbouhy    false    304    4942    306            �           2606    17641 (   addresses FK_98e1ca336038167c7eb48c02582    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_98e1ca336038167c7eb48c02582" FOREIGN KEY (country_id) REFERENCES public.countries(id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_98e1ca336038167c7eb48c02582";
       public          abdelelbouhy    false    326    4884    268            �           2606    17296 -   userPermission FK_9914ed53b6cc72cd2206632bf6d    FK CONSTRAINT     �   ALTER TABLE ONLY public."userPermission"
    ADD CONSTRAINT "FK_9914ed53b6cc72cd2206632bf6d" FOREIGN KEY (permission_id) REFERENCES public.permissions(id);
 [   ALTER TABLE ONLY public."userPermission" DROP CONSTRAINT "FK_9914ed53b6cc72cd2206632bf6d";
       public          abdelelbouhy    false    252    4862    250            �           2606    17341 ,   notifications FK_9a8a82462cab47c73d25f49261f    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "FK_9a8a82462cab47c73d25f49261f" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "FK_9a8a82462cab47c73d25f49261f";
       public          abdelelbouhy    false    4868    258    282            �           2606    17451 &   courses FK_a4396a5235f159ab156a6f8b603    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_a4396a5235f159ab156a6f8b603" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_a4396a5235f159ab156a6f8b603";
       public          abdelelbouhy    false    298    4868    258            �           2606    17591 *   uploadFiles FK_a60de16cba13ae4a833d7d5da0f    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_a60de16cba13ae4a833d7d5da0f" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_a60de16cba13ae4a833d7d5da0f";
       public          abdelelbouhy    false    314    4950    318            �           2606    17501 $   trips FK_a645f117e4c98b1f7e69479e85c    FK CONSTRAINT     �   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "FK_a645f117e4c98b1f7e69479e85c" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "FK_a645f117e4c98b1f7e69479e85c";
       public          abdelelbouhy    false    324    4962    306            �           2606    17301 (   inquiries FK_a896a1864d60d5707403e0a0810    FK CONSTRAINT     �   ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT "FK_a896a1864d60d5707403e0a0810" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.inquiries DROP CONSTRAINT "FK_a896a1864d60d5707403e0a0810";
       public          abdelelbouhy    false    254    258    4868            �           2606    17256 )   payMethods FK_a8ad1bca942f54ce1baf9c580f3    FK CONSTRAINT     �   ALTER TABLE ONLY public."payMethods"
    ADD CONSTRAINT "FK_a8ad1bca942f54ce1baf9c580f3" FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."payMethods" DROP CONSTRAINT "FK_a8ad1bca942f54ce1baf9c580f3";
       public          abdelelbouhy    false    240    4846    238            �           2606    17656 (   addresses FK_a8c79e2600f0f688b574c162f12    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_a8c79e2600f0f688b574c162f12" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_a8c79e2600f0f688b574c162f12";
       public          abdelelbouhy    false    298    326    4924            �           2606    17251 '   favorite FK_aa6ce8d4592db172192b9d9cfef    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_aa6ce8d4592db172192b9d9cfef" FOREIGN KEY (city_id) REFERENCES public.cities(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_aa6ce8d4592db172192b9d9cfef";
       public          abdelelbouhy    false    4944    308    236            �           2606    17491 )   branchTrip FK_ab9a0f198f6a3c6cddfdad3b0c9    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchTrip"
    ADD CONSTRAINT "FK_ab9a0f198f6a3c6cddfdad3b0c9" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."branchTrip" DROP CONSTRAINT "FK_ab9a0f198f6a3c6cddfdad3b0c9";
       public          abdelelbouhy    false    4936    304    302            �           2606    17316 ,   organizations FK_b071480a21b1242365ace4c03e8    FK CONSTRAINT     �   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT "FK_b071480a21b1242365ace4c03e8" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.organizations DROP CONSTRAINT "FK_b071480a21b1242365ace4c03e8";
       public          abdelelbouhy    false    298    4924    266            �           2606    17391 (   schedules FK_b1e10ac4dc72412af1c3f4d736d    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "FK_b1e10ac4dc72412af1c3f4d736d" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "FK_b1e10ac4dc72412af1c3f4d736d";
       public          abdelelbouhy    false    294    4924    298            �           2606    17676 4   branchEquipmentRental FK_b63231e3418da4533d94b663d6f    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchEquipmentRental"
    ADD CONSTRAINT "FK_b63231e3418da4533d94b663d6f" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 b   ALTER TABLE ONLY public."branchEquipmentRental" DROP CONSTRAINT "FK_b63231e3418da4533d94b663d6f";
       public          abdelelbouhy    false    302    332    4936            �           2606    17221 &   reviews FK_b7d143e7ceb1cad286c2cf4a19a    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_b7d143e7ceb1cad286c2cf4a19a" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_b7d143e7ceb1cad286c2cf4a19a";
       public          abdelelbouhy    false    4962    324    234            �           2606    17526 ,   branchService FK_b8b0a564517e0c93d782677cce7    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchService"
    ADD CONSTRAINT "FK_b8b0a564517e0c93d782677cce7" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."branchService" DROP CONSTRAINT "FK_b8b0a564517e0c93d782677cce7";
       public          abdelelbouhy    false    302    4936    312            �           2606    17411 %   prices FK_baf743d0e2daa78701b2cf394cb    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_baf743d0e2daa78701b2cf394cb" FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_baf743d0e2daa78701b2cf394cb";
       public          abdelelbouhy    false    4974    296    328            �           2606    17536 '   services FK_bbff764dfa6918af2cf15f1a7f7    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_bbff764dfa6918af2cf15f1a7f7" FOREIGN KEY (activity_id) REFERENCES public.activities(id);
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_bbff764dfa6918af2cf15f1a7f7";
       public          abdelelbouhy    false    310    4946    314            �           2606    17306 $   users FK_bc1cd381147462a1c604b425f7a    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_bc1cd381147462a1c604b425f7a" FOREIGN KEY (plan_id) REFERENCES public."pricingPlans"(id);
 P   ALTER TABLE ONLY public.users DROP CONSTRAINT "FK_bc1cd381147462a1c604b425f7a";
       public          abdelelbouhy    false    256    4866    258            �           2606    17286 /   group_permission FK_bfa1a11bbb745d29a4a941c7cc5    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_permission
    ADD CONSTRAINT "FK_bfa1a11bbb745d29a4a941c7cc5" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.group_permission DROP CONSTRAINT "FK_bfa1a11bbb745d29a4a941c7cc5";
       public          abdelelbouhy    false    252    4862    248            �           2606    17486 '   branches FK_c03aef26af49e109f784a101ecd    FK CONSTRAINT     �   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "FK_c03aef26af49e109f784a101ecd" FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE SET NULL;
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "FK_c03aef26af49e109f784a101ecd";
       public          abdelelbouhy    false    326    4964    302            �           2606    17311 *   userDetails FK_c1a882f399a453d730c2f4055cb    FK CONSTRAINT     �   ALTER TABLE ONLY public."userDetails"
    ADD CONSTRAINT "FK_c1a882f399a453d730c2f4055cb" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."userDetails" DROP CONSTRAINT "FK_c1a882f399a453d730c2f4055cb";
       public          abdelelbouhy    false    4868    260    258            �           2606    17606 *   uploadFiles FK_c49c10511acf0024f50906d01a6    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_c49c10511acf0024f50906d01a6" FOREIGN KEY (inquiry_id) REFERENCES public.inquiries(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_c49c10511acf0024f50906d01a6";
       public          abdelelbouhy    false    4864    254    318            �           2606    17516 )   activities FK_cf4a8062ad267056ddd5f867ac1    FK CONSTRAINT     �   ALTER TABLE ONLY public.activities
    ADD CONSTRAINT "FK_cf4a8062ad267056ddd5f867ac1" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.activities DROP CONSTRAINT "FK_cf4a8062ad267056ddd5f867ac1";
       public          abdelelbouhy    false    224    4830    310            �           2606    17596 *   uploadFiles FK_d31b25877c1328114d4bf17f171    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_d31b25877c1328114d4bf17f171" FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_d31b25877c1328114d4bf17f171";
       public          abdelelbouhy    false    318    228    4834            �           2606    17506 $   trips FK_d8926932b8ea2aa8ea85db56d78    FK CONSTRAINT     �   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "FK_d8926932b8ea2aa8ea85db56d78" FOREIGN KEY ("cityId") REFERENCES public.cities(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "FK_d8926932b8ea2aa8ea85db56d78";
       public          abdelelbouhy    false    4944    306    308            �           2606    17396 (   schedules FK_ddd03cb28bed3c395141ecc05b3    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "FK_ddd03cb28bed3c395141ecc05b3" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "FK_ddd03cb28bed3c395141ecc05b3";
       public          abdelelbouhy    false    294    4950    314            �           2606    17621 +   boatActivity FK_dfbff0b0269a87254cafaef9e24    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatActivity"
    ADD CONSTRAINT "FK_dfbff0b0269a87254cafaef9e24" FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."boatActivity" DROP CONSTRAINT "FK_dfbff0b0269a87254cafaef9e24";
       public          abdelelbouhy    false    310    322    4946            �           2606    17471 /   serviceProviders FK_e47a3ac28ef9462fae69aaceba6    FK CONSTRAINT     �   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "FK_e47a3ac28ef9462fae69aaceba6" FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "FK_e47a3ac28ef9462fae69aaceba6";
       public          abdelelbouhy    false    4834    300    228            �           2606    17446 &   courses FK_e4c260fe6bb1131707c4617f745    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_e4c260fe6bb1131707c4617f745" FOREIGN KEY (category_id) REFERENCES public.categories(id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_e4c260fe6bb1131707c4617f745";
       public          abdelelbouhy    false    4830    224    298            �           2606    18984 3   per_hour_price_range FK_e562209b36ec0fda719440d9f24    FK CONSTRAINT     �   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "FK_e562209b36ec0fda719440d9f24" FOREIGN KEY ("customPerHourDayId") REFERENCES public.custom_per_hour_day(id) ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "FK_e562209b36ec0fda719440d9f24";
       public          abdelelbouhy    false    354    5002    352            �           2606    17231 '   favorite FK_e666fc7cc4c80fba1944daa1a74    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_e666fc7cc4c80fba1944daa1a74" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_e666fc7cc4c80fba1944daa1a74";
       public          abdelelbouhy    false    4868    258    236            �           2606    17541 '   services FK_e7a40b21f8fd548be206fcc89b2    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_e7a40b21f8fd548be206fcc89b2" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_e7a40b21f8fd548be206fcc89b2";
       public          abdelelbouhy    false    314    300    4926            �           2606    17441 &   courses FK_ea2e349cd78d70d56055b54967d    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_ea2e349cd78d70d56055b54967d" FOREIGN KEY (activity_id) REFERENCES public.activities(id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_ea2e349cd78d70d56055b54967d";
       public          abdelelbouhy    false    310    298    4946            �           2606    17406 %   prices FK_efccf450fbef16adea889a07742    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_efccf450fbef16adea889a07742" FOREIGN KEY (currency_id) REFERENCES public.currencies(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_efccf450fbef16adea889a07742";
       public          abdelelbouhy    false    4826    296    220            �           2606    17291 -   userPermission FK_f3e6433a5004b37b935f0e4681f    FK CONSTRAINT     �   ALTER TABLE ONLY public."userPermission"
    ADD CONSTRAINT "FK_f3e6433a5004b37b935f0e4681f" FOREIGN KEY (user_id) REFERENCES public.users(id);
 [   ALTER TABLE ONLY public."userPermission" DROP CONSTRAINT "FK_f3e6433a5004b37b935f0e4681f";
       public          abdelelbouhy    false    250    258    4868            �           2606    17271 (   userGroup FK_f6e9388fbd41658ee6311ff4e24    FK CONSTRAINT     �   ALTER TABLE ONLY public."userGroup"
    ADD CONSTRAINT "FK_f6e9388fbd41658ee6311ff4e24" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."userGroup" DROP CONSTRAINT "FK_f6e9388fbd41658ee6311ff4e24";
       public          abdelelbouhy    false    258    4868    244            �           2606    17191 $   banks FK_f709fcbcd013e948be9fe3364e3    FK CONSTRAINT     �   ALTER TABLE ONLY public.banks
    ADD CONSTRAINT "FK_f709fcbcd013e948be9fe3364e3" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.banks DROP CONSTRAINT "FK_f709fcbcd013e948be9fe3364e3";
       public          abdelelbouhy    false    258    4868    226            �           2606    17456 &   courses FK_f78b5a39a694052fdc034fa6013    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_f78b5a39a694052fdc034fa6013" FOREIGN KEY (city_id) REFERENCES public.cities(id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_f78b5a39a694052fdc034fa6013";
       public          abdelelbouhy    false    308    4944    298            �           2606    17381 (   itemTimes FK_f909df65f5f3d72941802aade41    FK CONSTRAINT     �   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "FK_f909df65f5f3d72941802aade41" FOREIGN KEY (reservation_item_id) REFERENCES public."reservationItem"(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "FK_f909df65f5f3d72941802aade41";
       public          abdelelbouhy    false    4910    290    288            �           2606    17211 &   reviews FK_f99062f36181ab42863facfaea3    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_f99062f36181ab42863facfaea3" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_f99062f36181ab42863facfaea3";
       public          abdelelbouhy    false    298    4924    234            �           2606    18994 $   court FK_fa87bba54227ae111d62b3e42d8    FK CONSTRAINT     �   ALTER TABLE ONLY public.court
    ADD CONSTRAINT "FK_fa87bba54227ae111d62b3e42d8" FOREIGN KEY ("scheduleId") REFERENCES public.schedules(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.court DROP CONSTRAINT "FK_fa87bba54227ae111d62b3e42d8";
       public          abdelelbouhy    false    4920    294    356            �      x������ � �      �   |  x��\ko�F�<�D�.Z$b��з8Y�M�� �袀@˴��A�Hū��{$kh���H�����}�;G8�r@�������C.bn$�.Q�q����*YN6dR��b���u�O�e�*�d��.-�B��z0N�*�X�̓?�Er_��|�j#��L� ������QQsj"��L���eԨz�8�2;�4vLQŉ���zq]�;s�拻�uE�?���fuC�l̥���2��TL�U���Er3�e��L�A8���M�^��˫�(�|Q���1�𡰋���5��>�*鐪X:n4��|X��,� ��/�b����l�2�W>������2�����Bs���s���5Q��*@���5JZ��JK��|Ln��Yw���IL�NE�.(�R4V2m��q:3
�p�0G�\:���i}���Iِd~��I��R��I6�l�e,���C��dq3X/#���Yڙ��E�S�e6�=-K1�*B�Cz̝����|��d�4�Z_�g`�o��Y�n�^�x/*�#�[�{�q�}MJ�����W��U�-�����ɡC	:���v V589��&���*�Ȧݥ����ک��
6&v�
�30f#�������F^MA=��?2|g�� �]������Nf�D�R��u�c�6-�U]%��*���ƣT ����>�Jk�{d��ϫlYt�U��aB�#�ߒ�o~�'eԏ��z��/�����m�P�A�ϣ0��̰���P阂C��]E�3�M2.'�rqL�4����V&f�c���um#�!�J�R�.&v���C\ Dkd=w?����٧�*&�����({-@a��
w���V #	�����s 0��0��ZeH��,�Vk����]���I_^y���`�,-F��7���I6�ԫ�_���B�y�=@}-&�����p�Z"(��ߟ���{�d�%���u��n��Q�V7!�❉�IJ��U�=m>b�@�����`Z�S�XX錃����Y����Y7A!��G�[���ZmsC/�j����Pr5�Ծ�[5�'|�m���R���5K�
�<�Ck\�݆L	j"(7�}l��Y���a��j�P����|>��q�x,��>��қeE9Iٸ{�{��������#$�lrxˉ�d��deRf=j�=�١�2%q�c	��JV!Ns�Kr��>�w�&�qZ���0+4�����h�n�蓰�А+�F9H\�F��l��yR�r�Oɶ�����ϟ���!F���ݣϧ|<��̲�u�}��!ظ�
�ԝy�;[F�@�z�,�FD�����]�F���ei�Q=D�{(ܜF������FT�d�S�r;���d�F��|ޙc�1+�$�`CV��@���7h�(y�,Ɛ���,�xneTT(^������%t��^�δz>D*��0�,���	��2��1鲁Q'5�j�������:���|:D�M �ې�n� ]]���{�Z= %�
�~	��}=.c���Qq�d�������0G`'�_�w�9�`�*g�2�/Mo�5�Kn�y��#POJ�qlQ�;�4v�aKd�IW��9��F�A�}ғ20Qla��)��c�\$�sf�֠^��AE��;�U�Aƨ�P��0�]`��~��:��z�%��^n�F�5�X+c�&������X0M)��t�Ⱥ�3�
%j9�:��ϟR�m[�Bm����1�1�'W��M��W1݌ �����h�גag
�P���C�ԸPB3t�Y��7���z>P<>���7��Dl��i�#d���w]�cׅ��/�̗k���R�MB��>O�������!���8>,���\�YJ.W�r���V���V_V���"P����D�c*�Ֆ(B��`�gH��5�?�x�΄j943g-����Y�4�DZ	�{~�\,?�-_�P��r�7�b䧬WaϬ*�P��[z��q�w�$���s���#?n拤(�4�������٫�!9��E�X�ENĄ��iڋ��+s�K�݇��+��/W�|5Mg�=�i0�P�7ڎuZ��ۏ}@��&6Rr�S6��̒MQ��|i�#y�!��@>J]vcO5n�Ƣ�r�����\���r�Đ���0�k'P>Ti锠x��������
��7������)-�Γ�j�Db����s� ��A��_*�<�	�ƿX��*ӱQ�b�g	�Ǉu;�PS�|�g�XL*����l��k��o�t85�����p���|G3�q��q��Ϊ 8.�H�� �b�-�7�x/����3�q.uKj^/Q�S���u�4�
jZhY�[���%p`S�.�ܯ|�C	�a���K)��&��f���& �A�{���
`���@<u��OK���a�+�_��a6�dsR�6٧ũ/�8�b�g4��VdZ�$E�}��?��}�J�Y�?w�/��� ���66���2�gE��K^��*�Q�6lOBQ��6?�&|��Ɗy{���m�X��F71ji�07��RjgJ�"4%j,Q��^�'���wR=0p���5+�#���)���â.�.�k�x(l�xd�,mq��8�|<M��i�9�J�r�5��5�8����M�D�ɴ��L-{����.Q��,)�~��m�o§A�R�rQ/ѺQ�+1j�����I���j��wiY_���/�w���m�����Nv��?� �U�Aѯ����R�V7�Җ#�z��7�l������Cn#��\X�5K���z�.+���W� �DiX�Ӆ�bk8>$����mD!qv^��~�.�^�K�,[�Q&�aL�X�!3�)V��|N�gi��$�D�Q�AB[�I@o�ޑ���Q�w���_2�nݣ����&�_T�g�,�|(�p .o!,�+�����-BH�Z�i�UX��%���^G������
23�H�$���x�L����D�2��) at��|�
�� i� T���A�^�)n�����%�TB���JHRTiq�#�#�&Z�Q�ڦG�%J~M��I���ӱ{3�e�-�:��\2����0����8
�a�J����e����<�d-#ƚ���1r3������(\r��k��OL6��I��~"�a�=���U~�C�ӆ�
��k�ʪ%J��b<Y�Q o,���W6ڢ�F�[k#�A��G�X}ƌ+͈p�\�&��˴�Tm�B���J���"�oB��2e��	��޶�x��	r�.�}x�Vχ<q����������:iA[�������ӔB<L�$Dqm���ʇ����'���SGp��W$�BN�l�"��2(v�q<j��z�M���:Ψ�b�����i��]��K|�ҋ)���k�&Y�i���Y�o[���m��ol�(�a �](��OY��s����G	^?��ڌT<>���L) 3��Z�gPh鱪*!��v�:����3Ceђx	N���?뤘t�o��`˿��F�|3���dRsM4D���w7�8�{�n9�І�ݛ%:������#��t����C�f��ڎ1�� ʨC����H�i�cK۫S�|ֽ�.M!D��h\eS��S:V`Iͱ��R��܌�FK# �n���텈/iYߙ=*N[rpG��o��.�+�����G�����r���-�QS�跊�?{���DS�            x������ � �      �      x�ŽےǕ%�����f�o���.԰I���^BQU�Bը�0j�iԺ��/��f$��CcK��/�z=_2{m���p��H�j�H@�N�}���W�ȼ��{*��}������rq�(>�ꉢ��TZ��?맗��^\^�>�^�\��u�_�n��o�wg+k"�u����ڨ�5E��q�i�2zC!OQ��Q���'Ï^y��5j	��	�|��nC�V�Oi��������~�T�������l���쟶W/o.���%R���D�T"���I:2�a��ӛ�n�.�=�{��HUZ3IF?��'���'.m��>���Z�����s:���N3�ˌo����e�T>�T��<Qz�u�/�I�Y|}{��t����{�lϷ���MZ�]
�O��7�.�>ȳ�|��*������q5����z�]�1#i��f�������������e�ؠ�V�o\�?�����jE�9�8cl
�.�+"�z�iC�(o�D:�|4o�t���-�i�O�#���Z��z��Y������ 	��f8߾�o�__��*R�
YfN�ڤB�^�6�yO*X��0�hV�l�S��!��_7ڑ�zx�ޣ�G�>����$����?_]mA����/Wߺ����g��w���O���������Wq�P9d@xbF��%�V�1��i����h��GF��Gέ����7Y��.�X�YZ�a��g5��/�ߠ�k7���G�q��}M����k���{�������ӳ϶�lt~y��r���;�͋���F���
�y����$�ƨ��`{?0Zx���v&�b�s���U����%֤����<l����v8�=���
O����*��;t��;T>`���n�l	�oI��b��j}�ۇ_<�������~����y�U��_<�:��g������|�M����Y�~��b���n��tv�����b���V+�.h�&�[��i�� ��n��j��\���=��y}���Ŷ��>9��:����=�o���8%���?�fUF�eT�h�Ä����BI�{~�V���2��cK_��A2ce2m41��L����Z{������eU�7�j��=Z�{g��v��BT�g�����Yi��a'�!����qa�k�fe|��a�����۫W��ή�X9?��9;��K`���ܟXC��V'\f�X��1����14�u��5���q���?>��́�
��OT��
�[�.�uM�9�@��s8s�Vn_l�W�η7�������^y[ś��8�2�Ζs!�=��������.��S�̂�0S�`����٫�����5�a3�����x*�&���HSPͩ��V���^m�<u�����.�Xq|���w ��p����B�,�c2�&�o��,�Pp�Yf�]�����⵸�g�n�>;h�Um�����%9	�:�=`�Q��e�T�������nvbNri���x��(�G�U�*Ԗ8�L�q��bt��V������������yQ�֞����������?
=�Z7)�qY�fB�H�{q�1�_�[Z�����J3�>r�>}�b{����U_�p���\߽�O�!�	{����[MC;�ic�1*�=:1q=�1��$�O>nV�]��ޒH&��r�}�V�K��(�$.�sO�1�����ԈL�Rb5Aa�yu~�����i�N{d�+C��s��j1B�P�[{�Glm����3�8����cj�������:�Lpb�"[c�咿=�?eS�h������<%�[lk���f���� �ݱ��˺�w3ǧ�m��lH�c��L*�L޶��������bgp���%��5�Z6L͡ap�~�A@�9���;�����/sVe�R�b�B["#;�~���Oj�N��d�i<��N�'���%k�
1�ß���r�z����G۟vS��*m��c<��ͺH�-�,��1�85�K���>��r�7\�_
�����D�KJG��G0j�KS���A����0������=��#�_uR2��m��`.8H�8�"Ⰲ��e��%�������!)!�$nY={s�ө����j��9�j� ǳba�U�,!�vM�.o�g����8� c��ߕ?�Ѭoon�,hw7�o�+�.�_g�]�}*�h�O��R�v���*��n�U�����F�4��`�w����0����ƫÂ6\�*���W��gU��{�I+/�����l�Q�xs{vv�b!�O0�^p�)*ú�w�6L�����赙{�<���ߘ�v���s"�������������Yҙ����w�������<|��������	��/�/B�/�.g�'M�ƌ�%ϰ�1�D�{����w�&jkC|����|�t��uڏ=�dr�OG�ƴG��Qu��ߢ����Z����5�74$������o|�_�����s��?�t�UG�[����@0�����p=lzB�&���=�g���w��H��md�'W�;��/������
�������o����CxR�!��3�˒�;D��Rh-�P��=����`z��%$>��<��E�3�p"�r����3�8::~��~_�U��kh8�U������R�$��˳��ݞ��IN����dr�m����\�)3O4�,d@��o�bB��gWk6a�ND�(���8��]e��
�sOZ�a�}
mE���f����gJ��I�c�̇�ށ�=����Ｘ~s�#l�ט}�
�Dw�d���FZ88hBr�Tt�+ղ�ɥ�9Ne1D�3cڵ`�������	2bcÆ�u�D
Kc��CnwZ�GT�T�+�8H5n�/�L�<�G�t�L?���٥4�6����"R�({��6|)<苏���.�3�^�1(���g��hZ�Ҩ.���O�.8�R#~T��pH���������N�ڨF�4ѫ��/�4�-yD(An.Ȋ�{0E�_.Q��`��!�4��Ȧ	5)qT���E�2"_-�6�I�:��X��,�Z��o.^�h��C��A�xl�e6q%��n�)N_�	�Y�Y��`4�"�#��Ie�����N-�8�N�x��LM�˔FkXR)F7�H?�6Ań�09(-9@��Ѥ��:Ր֛���}'�4�$u�?��^F`��ĉ�a�o�a�{G|	�J>g���������?���w�#�P���@e�2�kv�G�P)��bQm5�vQ����5�b����E;���#i�\P�Z�'�w	���U^<s���.;��h\�U��"�b�FRՕ������<�0�"�S:���~#��36yy������y*�Ҷ���;�5I���κ��L�Rm^,2�F��3'7/�$�����<,�=�s�s5iA҈l�Y!���u&v�A���E ������'�8��R���m���|}%>�cv�׼S�(/*�|��h����E���1`uas���Q�򥱏��'~+r�їi&3��M�y��oxV����t��8��� �R� ����zc�B��y�'y���_~�V���:[0vlZz��O)@����ݖ��T�IG��	E����	"}5�Q7=*F���"d��9"�5qr�\��w������|��c����˛Y�cI��S%�6����#��G8����{�;� 39/�/��+%�,\r�g�z����VNb_-�FU�q�b9ZA��4<b����N�މ3�1��=:��c�J����EmVؕY�2>�\��
gF6�C�	��or�1�&�jօ]�@��$��ve#s,5���]iq�8��6�=:�Ѹ�fq�BK��{�I�d�r���e�b�Yt+k�Z�`�z{y����4,��Bk	�Y�ָ��1�sGr�>�G<�!E��|�����h��{�ܜ��fܐG�~��i҈��f�Gnpg9�L��=:5��&U��~�m8�	�<:Q�UM�!U���Af8��I��ND��ʠ�e��Ģ���ژZI&q8�቎s�UEp����6W�-ZB%?F�vVsLd�_�/�?����\�ݮ_����}s�?3��U�5�h�K�l\,
&59>�������N�k),k�v8`7>RH��p�� �S���1;�e�`�]IS�;��f=n�`�
��    �{'bjz�P�u��}zX�}�L��ϯ�ܬ?�|�MY�{<�$�z��؉��x��0&�s
FI�Gef,o
�O������w��A�wv�}��| ���xŞ�Y��n�v.:̢j�DU��X��g�D-�M���Y���,�$�BM��k�,�F��&CQw�Wk_�+�'&�$��Z��9�M��b�q�8<�,IǱ�=�I����,��8�ѭ�Mkd�/���@Էo_o��϶�l�N�Xfˤ�� �TH���>�	̖Ɛ����0��^7�Y�b�^����M�k���/��$�c!5��I�\MW�C��C��c�In2u.�u����h�a�pQ㪅<����4�C�óa�X�VL�|�$6�E �K�Z��'�E�,˚��jB�`���f/8nӋ�y�p1r����яflZ�a5�{9*<�X3j���ֺ�?4D&N�R�M��f�|[��;�q�,�����s�m�>�xյ�0A,��!A�tkw������UyiL�����7V� ��7�a�<��frNW�1Q
�e珁��"s�W�W?:6�J��e��p0���*zx�����K��I�@ag���aYkP�V�o�H��%���F�J�p�+�J�Kql�YG9��C�<�фw/L
�24:�k��ñ�`a���N�AY�J"H����4� �<�7.`x刖0v�L��L�� ��!3�ڱ%o'���|�;�\�]#ј�d�o�r�C�J����o�d�-h�L������%H����ɱ����cV�	[�8��0aL�00��r~tqy͇�V�߬�n�a?����^WJ{�XȆD��!�FH�,�KE�i�}��,e�����	]�6��c�l�vDwi���V�B����ɣ���d�6cwt!
v���$R�|z�,Pj��5�vg�6�-�[���8�]O�5����'˚ԣ�#"g�����$�Vz����=AZ�4��P�t2͇��=�x�S�����㏟��S�и���ܡ��!_�J�v�5���1�7�.YH1�{����#9��WC�����!������s��
@�G��ˋO�G��R>�Ⱥ�/������]gN~B���z����6t_��t_�8�=(�L�gf�:{Rlä�ːE������\ғ|�1gb��-*�;��gJ|��8,��̎�&&A�ώ�l�{�gk�x���#�ϋ�%L�� 4��=�b���B���5��T�����,@�H�~Ĵ�3�l��-Rlb%�0�fQ���a���h9�:*TMȅA�=f��z�����4�'D>��Ѝ��a���ig�k�'�h(I���}AR�"S� +������G,�)h�X=�Ii�ǈ���{o�ϳ|�
-�vlY��Dq�Pκ�G�����|W�($��.�5���o�(�����Ѻ10N��p���)1��l8�^N�j;��t����~��T�O��:�j�SE9J,	E������V&Z���G� ��Z��)�� ,�K�-�"���a;?�u9�Rĩapk'��>�f��o��FS�J
,��u{�i����2p%ƹ�h�!�'��ծq�_�-�Eb�㪐��{8��evT����׍���L��Q���9X�A�?L�LE~f}�>23	�'���qD��Mc�{ S�cx3vk��ڮU��Vtq0L
���g�2y��؎fb
"2`�����M!��[�]Y���K�:��t�T����
����J�8��b>Af�W�ӂ9�
�������*�?�f�<$�����?�5WFC?x�ceԭ)c��:�Qo��)��9ϑ�O��A:�^�򧥪�>?�S�eI^Mڧ����R��L� ����ӳV��sϚCB���F*�߳f�ٶo�
�'���8�������K6,AE��yt�07�
ά=����AIL#����#�Xb��z�-Q�)�7�D� 9� �`g���Ag_g�filu�y-�e2�=������7Z�3�-t���x���n/nVS�2����`s:��A?IWZ*��V� z�ɑ5v��9��K�UaN�ۀ�Es�V�.�~Ĵ]��M­��0�r�no�
ɩ� ���_J*����x
M�+�*$�5oE>������r{+scon��.��8u�����3�5�u�ې����H��U"%�g�?�l�{�������e�� ����:[�D�yq;q���S�����D� 2Ji�D-�8P����#CP@�{���lo6%��O��G���;�?� ��(�"H�:fk��uwX�X��=�tz��i$���(��`��Q������C> �t�Y\�6���ϑ���̍��b6^�"�@tC��w����E;���Ǜ�f L�PߧB۳Fڷ�O}9�2�wG�RT���Rk+�i�+��u`�@�kY8�A{T�r@�E�rmh�e9W�>����5�^�^��r6��η�P�E�&��nݬ�F��4��5Qb�����e�E�F+��2�1ۤ���^_��(U_#w�!��'uLۦn2���p8�H����7:�o*�x����wo_!YU�I�"�(N�D4kx�&��H�ڲ�)U�w��V���7��$��Ү=a��!0(�¢,f6�3�@�^��Î�}6A�К�+��=��'t�4�kI�c&�%��/�m	A���������\l�nQ�z�x�Kh�Ds�0ir�o¡eպj�N9<͚T�f�yno��U�8$CV[�� k"��ĺ ;�Ɉo�uS`WӐYn/�B5L��<m�\��,Ʀ$�����bpqÞq��)X�<@RzW��N�8]1�5�C��X3KȠT��G0K{JNUD f c�N���\���8��=����TABD��7u��@ �K�D�c�~l��e9�C.b���)x��Y2���Qڪ^B��;/TKW 5�A�{��50��Ƨ�uf�M��r����'>G��/��ٳ9��񋣌�E�����Ħ��r�49J4�����2)�Q�R�ļԦ�eh��IW/4R]�J)�A�c%�9�Ѵ�.E��%s����X�'���<�%R���m@��d�Σ�3�~�����\{㦙��<:ije���r�BM�1�=Z�~����/Q�����P�X���d��@�������a�"Ō�c���H����\	���ܣcT��O��鹌/6���}^�U�	4�豤td�O��	���H�m#��	vC���XO����n�]�de�

ңIL!�x�Rp�Y|vv�]�k�S���tw����{���h���j��1�;A�R�b-�lJ��!�����T"HE�`G��i�s���3=�;�9)��{`��EMۻB��~5'Q���c��W㸋c��_�$kK�Ij��,�as�B��NZI�t�����7�v0��56 R¦h��a�  ���݃��:v�1�=�t1�a�]�:B�O%�{WqPh�^R�R���	jw
�T��#}��N��EΞ�n��t�������ZU(f7�k鄤����sނaZ��(qk�P�X֜~l��>z�}P4��%ubu���+mԤ���l��Ұ��o��x�F���~x�|[f�1]�Q���<v���� YUcҢ�=I%�a��8]GAդH�ߚh��BCM����Gvo��?`�������d}�.Ο��@���6*fV��q��DZ�Z$Bԡ��̊'�q�~�o���+�D�d�S��^W&�/�y�����1Ab1,��y�L��4��D�}?�Q��� H��w�9�����ʏ X��(�-��-�
��H���a4�j����Xˆx���*���B�-t�#`�{39�}|���=:IH�'Ȥ����<z`�K>�=z��RW�'�`u!T[�XĒ�G��9!���(yg����m�ܣwzf�"��D�~�,ϰȇ��G��i?0�Ahhi2��}#�w���t�����+V��[�~E8����p��n!8W���fg����$���,�
��)����+���uC�Jc`��=�[ze�n��)	��[������V�Qނw��X^ ��Ol��t��>�?��'����������E���q���    hr�y�t����_o_n��E.Jp%�����uX��#��uMJ�'�ThBE�	1�{v�U����Nȡ�")T��Е5�����G'$)U$��@(P����i���e�b)P!����ō��=���淹Ў�Lw@���"��G�Y#���=�h���^�X���E�gC�]�X '�X��C�_������#6XW4���`j�GnU�p0�[F�*-�#�Ahg�r� ��Psn����Sp��Yyd?���x�ϞKoDqeE�+>����1o�	�Y�f��uN�-W+�B�2c]���.�G7�
�O�e��K!�|b�#��A,?(�U%qc���W�������� yE��QH��<�?�q�1�5����D;2����Î��*���g��դr#>%-��u��L0����`�-�m��xcn�����li��M4��e�.�tx��l=v60G����6 �8��i&��`�T���������&�����|���)m�*M@<b��"g��;@�~����t㚌œ�`k�&H����e����K�L�W�fr�y x	l[:�QAD�-�BS"IV�^d��pJ]�i����-��y��%�5V����8�E�b+�e(͆蒫��Gx@�~,�Jjz	�C���9�)�����-m���{#u�li�My���|���9vׂ)�
=������������zv����Y뤱g�QK#�@d���@ȴtFq@�M�{t:7�T�\[�2N����❞{�����:ҫ4U���	!�5�ⓔ�f�ѻ��ʩ��]�����z����=QI���9`�����˷D�2�ƔW%�Ȑ�ғ
#�Q�FQ��W��eFV�%/����q{{yv���������GO�g�gg?��z�i�j[�`����B�,C��m���cAsX�d?�XDw��i���Ic߼��P'$�#��8>�*@F�Ս�3�Ҝ��0�D�ge�kG�d�&�`�+�GQ�~J��E�\�眩��ܘ��Tt��tD�vE�U��Z�!�I�h_����(��l@�w������=?�Y���M8`�(���aKm�&�����X�|vT�b����̅��a}�\:��5ub*����9æ%����l��W�(���t��SM衍b
����N�֞��N�*����ώ�I5Qm��{��̫�eRں���#x�y��A�Wr�u�s�4oa�R[��T�
G%Q���t�D���7%�| ��o�K%�N��V�(�0Mβx��낥��1�`N�f}�^�eR�9F�S������NΦ��������n��ȏL�����wʛ�������#~���0nh�ȇ�s#��?RY,�dНv�`&^�"�	E��e�lp`���G-�u'J���;1��[�Fo�,2�_�E��� 7ؚH��͘`>�Dr���jG䉩\r�l��0$�B���˹|����b3�E��讍Ƌ�1�`�ʇPi�s��Gp�N�L':,��$�2@�L�]�TmeUnwV�fG��ں�K��@Y��aO��Q���o�	Vz�瓲�D�'qѵE?F!A���� ��Z�v?B�	��<���V����?�F�~���k�]z�}�.���-
��u�)�v֑��;VCn���.�e;�|�ZPb��Ii����ܣ�SR���z�$K�pK��ղ�s6DW�-e��%�C�Z&J��(jz"�7��S��%f�:�du��5奯���J�����ji'5�Wt��fq�?�G��1�S�G�|q�WHrrz�W1B���5� ze�}��|Θ���2u��z1Og�8��z�7H���jo�FUr&Zƀ��aՕl}�N6E�UT��8��C�oIU���*C�uWQ�����O�����L8FG�b�5�[$�j����2-�$"�k�3�`�o�*��'�8�<JxY�iNx �FW�<TR�]�w�@��"ԉ���R5��a�,1|���Y"'�<����J2���1�mx��eV+�dg�P��ɖ!$�03�V��*��h0��^7��������ey��$Lɼ�E��|��S�e!J��Ɏ6�/��8H�I��S��Z�����R���S|�X�2�8IJ����r�E�Ϗ�����j�|�Sj�y,��6��_;�o|�
W�	G���/�L��iTt�D�ʲ�����A�X���(���\�d��}c@�����Ac������ y0f���bќ���}��O�&''.�R�H��=z��ut��D�H��`K5���x"֭#j��oq(1	� ���
s�)�S"���1-ޛ�.x��sGc|��n�umm6�h+ݫn�����s���r(�U�~�N��8 �
�e�1E)���H\Δۆ�/�0��$Q���O]�ˮ�5 �=~�����X6:�6D@�{�*�tse7�-Zs�	à�0��	(L𛓀%v2�C�X�#��~����7Cژ�B���r���eb*SN�
�Q�+Z�������J��Ʈי��ݞ�]�%
-��N���+���3�kTA����F󗏵�c3R,󷢡���C6����E�IP@��k�i�����l���	Y�Q���i���ϱg�|�plu=�[!@ϛ�ه��a�V2��7kt�C,��@��R�q��l>QR�T�hd����:��3��7���t�c�FGhK���4rȖu����S�:�=thNb�2'Nd���f{u�Y�H���td՜[��q��![h�>�Z3�:,e ������������+l��No���ٍ�F���W�^ʵD�\���}�>a�E�-Y�H`���	8P�� �MV�$�Ec�c�,]}�����ѺL��h��N=ښ�|���H�+c���/3�&��{w��ɦ-[��1A�0�ج���h'�}��(o���G��/��d���0��Gڰ�e�b���v[�w	�������W���� ���$C����;��g�n�-��D�VY7���0ؼ�)*֮l������<��I!P���;ٓ�Xv��l���d�X
�F���X��F���2'����	��r5PS�B���/W6_X�����h��V�{�~�g/>"�ef1�7�Г~�a�4�$��C ٣�\P�ft�H�����_1�;�7eXy�VP�ۚ-"��ւ��!�!��	;���vy�c퟊��ZD�&c��18y��8e2(E�L�_��X�⟼U����v�\]��ןm�`��z����8o3�q�tY%��"�fx�(�"W��q��HZ�ޢ�1��^�BSK�&l%/f�Xm�j��0�hwc5�UOmG_�ȴi*�F�J�bu����yɳk������_<�����3��;p�кl_�Z7��MO���+�Un�ԕJvx��$���{u����A u��)��}Є��9���.`�����.��G��f��N�EQ�pˌ�:VH|1�����_���'���� ��d�m.����EXX�XF�����f�xV��ع��t �7��E�oJ��,.��\�]�#&�XH��$��Kq����'a��ߍ$�h}ab�0��4qɸ;.g���1���^�n����m�W�d�h��ؗ	�����a�K������i����9*l��L9d'�\ц5�(�ǓcZ�Z$TU���7U��wȡ�NBN��Z��#�y���)h_��s�@����4�9��D����X�F�/a}�˅����"17��Gd�4��,�V�e�����>%�:c0t��k�zƚ�V�ؙ�����aY��pd�Os{��������v�2{x�6
[�z����?{qv����?]���f|*���9��(�x��犈B�!ȡ;AIΦ�H��&zk���c�p�N���n�ʴ1���1[\�0��N"�V��$kA�d!�)6{��I1p����0����ŵ,a�~}s}+���z��	R�`���	�����$A&eCßm�z��I�f��ln\8"IE5�K�_�����Qs�����? j	@�.	�N�+3�"��"    ��ĝWqR��'#=V("7��F�(����&=4 
IM�S��b@'��Z���XW�Xg�4�{�*_� \�o�@�v2�jr��� 1�����R6�/��#du��ٌ:�o,���^��2��Xљ�80_�?�K�E��Ȍ){�i���%��6j����,V!I���d(RS���2�av_�yL�JB�q��B?�� kX���W�ĥ�� ��	��q��>��_�<�Ҝ��*�K�p>?�>߾�9�ΛO�:�9U�D^�U�9r�n��D� S� ��6���;t h-Ս�嶬��.�W�۳���2n<���n�QG�8;40*��%�JXD3��Fl�a��?�-	Ƥ	�X�r�Y��h+�ݠn)L�xm��I��P��va�`ԝ��
n@ҵsr������r0潁��!��M����i���-�4�����j���U��0�ff{�"�@�Q%~Mm0oly`�`Gj�&yS{�$u8�� �����7�B�aXq����K9�Xoe����#�eXXh1����C�ױXȡe+�c��h�BP�z�U���M+��F_��`�=�]p)eH��f���v/=�h+d���\'�X'��JY@�-`w7 jf��.���!���߾������?8����ļ�/��'*��PT�������9�dPlt�J���W
u��n|Q'Ѳ�IP�9�Ju��Iùr�Q�c�6 �6�٥[Ӷ�[h))��,������
�]��ɪvK��3hf(�Gw%�?V�I����~p}���0�:�u��*�A�"3L��C��-ab�P�GW���WK Hcbq<OW.y(f\�����̲w>V��e� ����VU/��O�G�*+��;���Jm-���C���VrT��!9�T�(s��MIʵ �<��ٮ��&��d�*���,<դ	�_�&h�!��������(�Fv3��.5�b�$���fr�C,F�e���������WR8?�i&�N�~�6n���F��b�Ȥ���!ӎ�hcjb}){���eض�h\e�3=DZ��|��n��3�8�&���AY�[@��G����.2�[g�i�V2Z��*OZ56P<r������;iۦsc*�!��A����()��p"Rw	{��uÁ��������qM�S9��i�s�������S�Z_5L��{�m0y5�5rQ#��B]�`�B�����V65�WX��'�Δ��Qr�&X�/YRi�X����WE��$y0�.��JP����N8�R�����1Jڑke�KĈt��u�po����/��*����݅�s~���B������� ǥ�Δ[v[B����6�1}�~��!�}��5!x~}}y`)�RTK>���(9�#���l��0���t�F~���Qd�Ҿ˰;d ��{����<�P& �z���':A�@�x�
ӵ�Ipv8�ӕ48��0Pu��c_�h�L�<V���X�>{0�c<��j냕z��ʤ:�ȟ�0�#��}vU�w돯���m?����CW��f�pL� ���38�w�H!����P6OA�(��W�h�r8>Ӷ���cI��(��Ǣ�DqȲr��LM��7��d$<��
�5�T�Y)�S�gmR�I��i$?�e���**������yu�����-Po{���1�
ϘX�X��/�N�#���f!9��j��2NV�}���������]�Cx{,kE6{�V,� �+D1�,��Lg�GF.=���W;Zp�Kئ\�v$�Trj(⇺j�C���GL�w�]��q�8@jn�Im	OZ�����B�HNY�pqB� �H��kk�$Y�D��Y?�8���rT�l
��DQ���a�oîQМ��\��I�!K'��C���*Ho�ⷞ��V�%W�Ya�?ջZ:A��X���T�-&E�w�i���5��<O�>�u�|2Z��y�!	�Q�Y`.��T��(`ji:��NA2Yg^yE-��-:���l������\�Ü5Ɋpժ�nJЩP��Mb��p�w�(�sN|�~�R���/�Z]L��=NI1���/���Ğ�iT<����lI���8��%��լ�d��mE��Ʊh�$v��eǶ\v��\G5�r�m��=g~������q�Ph*'E�����O�9K�1�����S�>��L�vQ�)U������	5�x�"
�*Q�O_]6�뀉�Ɣ@M��S�㳢*�̛5eI I�{sut�)ӉO_�u���Ű�8?;x�NI��m_ڝ�.h�wV�Z޻	u
�#�>����� 0��Cj"F�LXnls��!��N�4l׵o��BA[v���7�zi#v�~f����I��@/����b/g��Se �\���x{�3�ݫ���ĽS � ޙ>"9U��AB4��X��  �Q�mo����Y��!]�j�ᛛ�3Ka���,y�W�C�i�E?c�����h��������J����<���"U�e)
uÙ�I+�U'�\n9B;�>��jԟ�< ]�)ԙ���������-'8�6�Q�z��h�1�&G�sYXI��Ǔ�$w��0?������ O�皅
og�}��I�dw��bBk�����p�� �1M�uN۔��џ��$�� &2� 4���E;nc�@:0h9;��bR�%�Eb��1��F�M��G�	��0����8�.�ޱ��m�:���-:�mD�"s ͇����^�t��\l��,��~�"?�%��Y��䰺T`���܍L��nq{`I��E�]�p���~���d	^9�z}��pd��֏����yu��f�	5�����ᗨ6<�cOc�4r��ٲ�mv+�`��Ѱ�ʬ���Wg7�r����lk7k}p�:S�Q �?�}c|��va�܄�q8�R��[��`Ki9��H�ı��&�`�A�����[�}������P
�s|���������`t\4���Ď2{ʹ������VO#��.p�h�.�+�f���k��a˒���PT�I�ϒD^k*i����gH��\���X��͋�ۻ����Ì({LNu�e�b[���Y\vMU�R��7;���K ,�
�2C���� eQ�dbИm�8e�y������ηww���
+�:�%�gb��>��%J��{U��d�Q,�^{�����4<-}KME��Yl��)ux`w�[� =����/$�������d1���Z�h간��=�z_�e���`F�Y	��%�c֔�gw������˳�}�}u�_s{wq}�e}�^���K�&͇�V� "
�_Ⱥ�߯�_��r�>���\|��w۬l�c�R:#3����G˙1�^�=�Ŀ�	��S�����9` �V�#T
J�-�Sg�&F�Ld��ߎ�Ź���H	�8�L�K�_P���]�g�����n;�Ujqt�T���P$II%�\��]��p�����w#G��Q�_��TMhDə*UNz��W�ڷ8���y��eNT9o�eV�즏=�YU8�f=�ڤg�Pu{W�ԜL/a���/c��Aô����\Ph�1ɕ}]'F=p���׵R������e�mі9�J���� �z�KZ�ؕfF�����,��Y�� ��>�a���q���,���  ����N�a��vjb�v���P>��Ey�HSй�h${��Rj೿�'ۆJ�&��AIS�~ީ)6IVX�b�0�o���&&ТnVH�ld�HB���+۵���0� ��n��XHol}���C�|C�kh��e.Rٍa�T&��L��Y�r	x�4�EzU��-�9��u�'S:u��f�<J��w,�`�������w������s#��?n?�n��(�~�A;���c�. �����'�:V����oF4⯠ʂ�>x�n5YŐ��w>/|��/ ��pfrF0����0�9>�� �߬������N���R���|���.��>alR���Z�(l���׬�H:7���Y�s�TD�L΢�)�g:y�7:S]߫$tY'8[���j�ǽ	$SXfH���a����,RE��Q�@��>�ɣޡn�լ8��%,�Y��W/�:B��    I��@�rI��q��۫���U���\�yu��봇�0{��]A/���y���e�bʐ��2��C��.s�F��f�m��K�.�k�G>�6`h���h3p��$��a�ʣ��*��W,Y�˹�*��W')��z͜�o}��j�,���Iw�3"��{E`��ڇ��0��?���Ip����{qq-��>h1��b�(��]�_s�II�k^]1k��v8��N��R�L%i�*�K'{֑:؜�n�1ˍuDJ�:N6Q&�B'�Dqr;�kFm����Л�S�aH��l�8�l���/��/��ߐ�Y��������}�8���֠�PJ���f[��#fC��¬�����4���K�eP.�ʶ�T�ca���BAf�ٿ�5HB�ņ����RƂ�ӊ�}2�oq[^jX��g67�y�:���n��HRv3(�-��a�ܤ��0�U�׋$av��2	y�mOa���/���ɀAqެ��便q��w�N��Z f(%8 EGǜ�v����|���["n@H���*9�Ŗ���[�mujN�/gT��1;/+�NLWӵk�!�c _�8���#��Bm:.:�[�iF7Z���!�����O9,@���ŉM��X j����J��1�C��I�Y�v��~�%׊%Yb���+�c�(n��cP�Z�b�� �Y3��-'��l,f�V�s5�:�o��8��/��S<�~ss1��pֱ*+L|7��!ɼ8r2��������J.v�;#XY;�_��;���{ѕ����m�E�*�!���M,>\$�d��`G�����!�@��n{�Ń	X��u�Vx���(h�<��T��H�hS��5h,��^_��.8���H���;"�2�E��"�lt�{1��@�a��t�~�����*�?�|�����yQ��7@����(1�6��:[n'ɜ�x�N*s*��a���ql����:Y�?������6zݩ��)���_������2�(2 TF�NS�E��y�Z?���MoRK#WFX�K?�Ӎ.�`
%-�~����bh�Q�u��YDb/�A1���i��uJ@*Y�,��f����0��ߞ�\�>$4�4���4G��C,�q=�ϥ���JG�"MB�²��M�+�P|��:)�b4��S+�-�sF�\!�Q �z� %ݼH�!���1 -����b�?�³�
���T����y9Iƈ0�)C�MDi�QE.߯|1�+��]%�ہn��4�V?ɸl؊�y!G%	�����2��f55}�ݠ� ���D���DT��M> s,�+� 	`�U*��)TdUKVLy�������l��Jײ�S�r���$K�����6ğ੾`�1�����~
mi�bm�dKLd��S�t[���ޅ��ً.~��7V�wB)�C/j�$ d�|���'�%�Z�nW��g����$�����@:ZY6���￸����z�zV�7��d�~ɿ�?��Ǡ��d��,Zv�~2OrtX7D��a���`��Fj�F�����o9�j}+��&���з�4�G��NߞP�.�3G�dZ8ㆌ�J�� ��Ꝫ�	12�Ot[�I��2i�f�&Z�5�״�@�Z�,�-JP�1�Ŧ(��O�����y��w��D��uY]��[z�{�OX��&��N���x$v����L̯����Z*`�A�/�c=GM!VƸҟ(B/)��$���7�EX�t&�fKl'I�wz��G�ލ��XTHy,	T%�C��/���r�U��j9,������a�ވo�g����?�^ш��]����t�H��:f �]�8T=L��8���7D�Y��m"��ի}-������_>��������	LU���ND��~m��Y"t���1c��,q\w`I�dK*c���r���8qբ�]�d
ŢѪ���ޝ$�[lU+�bz�V@M0VS}�0W�gC^�#�#a�	�$�A����cյ��8�&��h��Tأ�L��\��v�������hL����W`dl�������sXγ��4lfŷ���y��j*Mv'¸qvJeR@���~������n@�$	�<y-Z�)`�0Q�ի�) ���˅��*WD�4�h+�Ne�@K\Ќ�l��8_W=�M��Q�J���lexm����;hqvƔg�x�e�}�JA��ȱ���������FS�K�JMtP���ˣ����bw�r̤z�D��F�U��� }Sa��י1�\����v�c���E �*S���u�Q�0H��fl`̟Db=-
�i~I[϶�iŝ̠��'P�.���#F��<�<܇� ��3"���_8�r����s��`�H��{`��3�����8OSs$+�,[,r��h�f����*��#V@}��N0C���^��'�K��TL�?nT�x;:/Eއ�����}�=�\�x=�K�64�ks��!���R�P�l}���d8�>p�	�$��l�Yh�ӹ��3����f��&�`��H�����slW<9k+a�yΑ��}��4�Dh�����Y*NX*���;�m�0ʲs�-R���ul�f�G��5V�zR|G�`�<��L1�,F�@:5��"Ζ�	[R��VA{vȝ�j�)�����r��bTf�%�"�	$N֧�2c��:���+��f��]*⬯5��V*��e/kZv���w�j�)U珹{�f�-�h؅�~>p�玿I��3��˔���~�X:drf���NU�xع�0q��&�$ϑ��w��-S�jq�o�s��(�T�kV3Å�:�W���F=�q�(�8I�a}��Ap��J�Jw�t��0������r�b�U(m(;�A��fl'K��ׯЖ����\Tġ>?ٚ�����Ǟ5��[�_�)wp��-�I����B_?�he_�\������ǟ/'�F�vP��?͵W���hw2l̑E�#���ƠjBd��E�B��/��6S�;`0�����h%�SW��~��ï���ӹt�AO�2CC)�&�>:l1:a��d HVޓ�z	��8�Ԃ�|�g$�d-\�6�IЄ�aޔͨ�Q����>H�EE��Uyѣ	�:v��jIC��FE�%��jI��ֻ5�k6��̼a��#��*��m��W�_�`��BlM�䕵K�����	��3<�" 	�M�9yA|�`�Rծ�WV���l�8`z{��v����g�9�y�#!�%Cɫ�!{�0�Z8�b��G�T���}
k:f�!{�r�5������K��EC��1�r��i
$�����#U[(��@(r���&K#[8l�X���> A�{UƘA�^��D�A�q����7�b}zy�=�9*�7kW�η7���rs�~���F�#����#l.J�o:���X��������T�$.��&7w�!'CZ�4�*ޕ9��H���>� ���`���ε�?=|����Z�:/�4�*e���J�҅�eOB�5-Nڝ��f��(�y�L��Iyk�t��a;"MR�K�aYYiƜytȼ���.��.f$%0�h]�k?L�w��;w.���a� �4rb���kl��BG(d]�R���٨��j �s���ge���X��bI{���G�I�1�;=���w�����_� >�9�گ_>�tUE�L�`�oLx��i{�҇g�������6�'�rR[{�̥�����l`��Ә�����3�C(�`m�e���7돘���n�$�б=in`-d'���IHy+H�5i=,�h�+i�>D�L���hZ<���1$�����=:,0mJҕTZ[vN�rW��\���O�����Y�*Q�`P	���uTS'k�ڂR�:��S��rJ�侈Q)�^���Ό����n�ęJE:��!�Y���j�@&Jjb��LH�\�� g)NO3h"l���4�k��d&P#��ռ��m5h�a�
���)�ѕU�s�@堏\�?��h��� m؇r�H��D֓0pΎ���bʻd���S���"%Xo���f&�h����d�I.���,�%j�|#0�n����&ic��B`�7����B.�D9�����x �  aM��+��_��d}Wz"�C�7��h��KL�����i�E�g���u�#6M.��,�u��G41��ڥ󾵽yyvu%F��P��P�\��^0���D�U�6�B&��t�ә��I�Tr*T����f��i������vS���\�@�<0�����v�RnS�a���v̍k��%ۜ٠*�P����M���&�ܗR�31�fM�J%�>:����N��c�����x�덇
B����u%'��t`Е���Q��n��|�-�q�������Qe�D��<,v���Irc�3��ݺR%N@�h��M^��������:�v�qۦ�f
��E��9/���.Ƈ��7t㌧P},v�=���!iu|r�Q�0��~��(�y�0������Տ���^�
��\�:�� ���a�k�d���i�u��?��#Z�`�<э���]Dkc�d����X�&5gj�R�L*{&��=�VBڛ��a�5�Տ�X�>�D~����E�c�B�.o�71�B�{r�����H�͹���+fO�]W�k������C�a�����5�8QC-�l�K���O�&бe��u��v�WN�E�ҋe�U�]z�f�y�m��E�K_���adO2��|�&���Ds�U��5���I���KBl�/��O�j��� �ǎW���g'�[\~�I�sOG�R��7�Iv�X%�#�Ƒ��@{�4+���Z�"��r�j��������z'G�e�:���w�DX�S.͹�m+LS�9	c3j$J�i�o �Qq.�qm+k��"�#���X�C���0s]���iO��N),��B��ji�FU��#7ۄ�勘p09Bo1�5�@ �L|�s�5[dWO��Ө�$����KOv噜Ye�D70j��+]��*L�q�%!�0�����4Sg2��fo_�(%`�웫��p��cUs��NH�+�bd:�b��VJ	�W�K��G���KrHf�r[��ۂ�rōg�l��4�/��ɍX/Xc�T�i��h1�	�S �C�U}\�������%#^ΑU3v�]g��^�4)IDE_pD�̱���l��W�B=��`��څ��X��0L��*x��-B c��E�Y���D�:M��O&և ���7=�zې5L�z�A�_���t/�X��I�NN���K,���m�����q�v�H�P��17ͫ�,�VI1��������,"�L!tV�Q����%�)d��2��:&/����p7v�����1#8i���5�7��ޞ_����e£�G��""P�Q�f�]���kr��@J�{M� ����[Z��=1X�Z�����KJS�ػP��D����bM�K?�b�ɤ�R���bg&I��WVZ�mO�l��ȱ9�[2�QQ�> Y��n�-�q��l�:�	,�M�H�=da��6<)�e�S7����6��d� �4�%�c����B�:�K3y$x���E��Z�~z�j�� �A�
�U�2[�Z-S�dJ���
;�5�v���?D$�����g��?cj^o{�UqiD?W7c���:;���2TI!��+�$�ذ����S�]�����!İ�)�"7�k1���f�c�CکN�7�uM�� $�qQ�����Z:	'��ô��)�-x�KMM�"�.K�������r��t��<Y�K�]���iÖ)��m���-��VM�	�"{�SޓC0�?�g��p��V[�9BI������TI���B���P3�.Q@�K�P��(R%SUj�>~�N��G����P�֎A�UBLr�K��($ɑ̼���5���D�"i9���
���a�B�#���-Xd�0Ee����,ԔI�tBw��RF��F�>>�}<놠�۷����^����9���M�$d��%�F/C�����d�	�+]���*wż��Fri���U�w#�Pv"t��׏�/_���I��r��$����:����4����׾����&��      �      x��]͎$��>KO������O�4�b�+X2t��驙�UO�lU�����Y�d&3��9�I؀!�:�+2�rk�W�	����;�w��VK%m�t:?t����_��U��_��5�FUr>�ˇ��T����������i�u���p�^�wߝ�Cd��WO������o����?O�<>����,���������������������??|�yb��X����}����;�v�ѽ���?�O��3�<��ǧn8��ˀv$����ݟ?�������1�)���ta:�v,,���L�����[X��K��ݍ�͸��D���𼿜�����ba^S��>�$W��H�8�q�7�l�>����1�#%+͹o����D���4`�W��g.~m{���>G��û}����o�q��~�׵����)ae��\(�����YƚJ\߽ފ����+��!g}d+5������?��:��誓\%", [@-\Z�U.�ҥ5�(�Yz8V��?=?�O�_���x=O����f���a�r-ӽ0�k�#�+��޴.���ҵ>��ו��w����h!]���i��)��O�J~X`��x-�I�^ֽ͂>�^&�:q[k*�����{'*�v���ΓO�2�5,�N��im�̑R�ՍdWqSy+�~^�Gɸ���=k+9&�o�%����v�­%��*GJe!(��иJ4D�o�D���PC�7ae{��>G��ϧ�e0\Ǘ�`j�J�+����?@N�������2G
B1����$i�^�F�V̪�V�
z7�_�c_/�?ݫ�p�?ְJ�?z����������xcƼ��w�������^�v?ߟ[Q��pzx<��=Dyܿ�~�?����Fd�=l��<KB���7x#�o&N������r�i��I��-/�w�����ݻp��OǏ�<�"��N����͑m�y��5�>�l;*�s��ʒR�W7�����z��`���]�V���n��"�ofVWX�:sP�3��[��awd/�00~�I�9��F&މf���1[��}R����x�0@�i��2�)��^���$����~��IdrE�F�^�쭈�h���՟z��:��p����M���݀DP�k�T��vm��`f9|g��k�a���9I���,�&��p�d����]���;e���KEC�p�9��'0�M��"��Hݤ�kb E�>��ޘ)�������D�_��i>_=�9��u�A���L7f����Y�J��ȸ3��|:^�]C%�����`����R[n�$�sf�g*�a5v�g+����t����\��=�Η�<-`�.����-J~�Sm��!��7K`�D�M���!]q�.����R~xgvx����"�I�S��� ��o�g��M(�5�G`��X�jab%���¸���N��!n��HJq�6���`�*|R� _s�oj@"VB���FU),l%ԣ"V��Ir{Uh:�nM�~�t�#�ƃ��yizi��eGIXE��Hg*�a1���+W�%7�LKr�X%"� �
�������ཱི�;�#���� ��)���b�*����N�4.G���-���R�˕�+�ZP*��'�Q��8 ��>غ�аJT鍵
�h�I��c�$�>"�5j��5���@E����DkH����iE�)	�P�� ��r[(8�YZRFQ�r��b��of��|<�\����v�IӶ�۠gV������Lv��]�_��IO�����^C�d(�	(DP���L�gsz6@�a"!���ͣI��w�9�*���j�,+�ҫ�������鏤�D_������wR�8�N&�A��zd;)z͝�*GzN�?�+�*-���G-|T&{m�U.G�i*�~ޟ/�6v*p�+��JH�4�j��ڢ�D�{?�S���u?�ӕ��"��o"8}AH�8�#L� Z+���
���:Pd-Y�_����z,��2V�ʝb1ܪ���\��?�.o��S�1-���5cL%ӫ|<?��mn��n�<�7dΘ�b�B�i	����N�^ji�ɑ�۳>{.O������p���V[�D�QU$S�M�Գ^�
^��i%����=r��(�`��򻕫�X�JV8�t�'*�%�9�R7��>1*�p���KG\ %�T�����9�k�$zpXmx�fւ���D4f����Eb&�������L�@M)y7����2crI2y�1I$�a���G3?^�'8fvٿ������hp�`�A��el�ɒP:����B������=��H�#����?eq�vc[�*�$���k+-��,�4�I�)���2ZΉ�v妪��:�.Oo�?�?�>Gynq�
��}4FI�r$�k���*���F$��^y�HԼiZd���"!Ά�v���
�E��j�9ɰ�$��k�W/V),lq5�.��������X$}�M�O����0�*���?��	a�7��^���;��e����1�mb���D�����<�%	;���2-�$|U��"�em�޻vB1ч�Rh�E��`<_�51P�m!�e���i)��Iz�y.�'�ڒ"���M�Z�8 �f��l������8nV���7����g�X��ֱvYK��
)��c���1U��<���V1»w�檸%~��J9	�J9�(m�sR��V""6�PԌ�*�nD�P�~�U0��I�)	�e5�#�JU��f��J�/��J��w��0)����û��jn_%�_H1]�<+:I�o�*����-}a��Δ��nX$��r>���鱱�Z��WR��zg&{Y�B4�Dڀ���鐣U��I�G;̔�<;���t�x3�������ٵLG���,���RHɼ>�#C	J����
f�O�c��Zryl�߅\~Z��
Q?p���ZǪ34�<Kh~�B.����(��M%P�Z�L���̐��ڂ�*��Vy�J�5�lQ��&!}R���j1*ƿ�����6���_�c<U
���
%0�i4�Ql\�ؠJ�z�A���a�e𷗷���!��>������������<~����o�&��"q���T�lڴ'*Q��FF�}��Z!����r�P-��虒�<��'��P�\t�R	Y�$���h���B�A=�,K�e�tb!��[�*a�8D=&Rْۛ/SH*�eYKRR�eT�qd��y���s$`�5*Sc��Y�Xkm
�W�]��x��t���X�[�1���Α�=f&�I_ɐ݉cX4_�h�i8�W0���c��7*��@"K�.�P�%)EE׿i�����:ưz�L�H ��Ɖ��� �b�Dr�6Z�iL��s�{pٿɱ�&~RQq�g+�=Ǫ���x:O���]%Ǐ�	|<u�O�O���-��+9O�1"�uo���ֽΗ��g�|����0��5W�ժPc�M�wt�����$ �zf�*���ܕ��d�.#3�iD��8if�v!��kiu�
Ht@t��2�FI8R!ە8�p|@�cz��:GJ���8%(Ec[ �XA�J���;�{���&r$�D�\&)u��h6�B��d������|[ZL�
4/7�A楔���� j�&���
e�z�&A9�@/݊8�����.O��|�G���u?����������p9�������4YS��W�;)+Xy�K�
�@[R� �~�Z4�1�MT%���'�h�ٖ>��E���_
���lY;]��O�(�+����A�S�٭�����]��jr\2��Aʌ{�I%vJ�eҳV@#���]��c��9ei5�;�c���p2m��`[>3$�k���W^d�
y����9��A�m�{-4�nL"U���eU���RG���Q	\}H$8����z��a�:�v�A���U�)�z����6Ɏ�+����S(8�!*��7JY�r$P#�����nuKs_����6����5=γ��q��M�M��R�����JM���2m�Z��8j�j���
,DbZ&���Ċr1H`�q:���Y�V� [�M����4���6føX��+q����Eⵌ3c��-�Z�	��V�|r�� +�mo���eHI  	  ��������~�Uȱn�9}��HJþ�U�5KL���v��M�\Jk�j$���r��*D�D/�y��#E�v�F��ơ�`�	�{#�̒�A�(�,4�sK� ��Q�L;Z�s-]�y(�R��P���)�"�ҧ��վ��U즲���p
�d�3��_� ���ƾ�f@�nR��a�q���R\$���Y4�4(Ņ���A�+X�+8�&%z�"Gū�9�{)\�Z�(v��$� ���mH@�6#�#,Dh�I0,�T��F�U�I�#�i��ֆ%�iס6S���~2C��Z>N�h��U0Aѫ�;��ˑH�v�J~�*Q��F���J4��YٺFr{�������H�y�V��ш�r4��� i���*q�G:���VTJm�mY)����E�@�q-�%-��CՒ�g�.���j9בn�BT@C����H]!����`�H/V!"*�M';25���z\RN�����}>|��������=l3�o"�+2�y�w��/�P�_l�	h��B4�m��3�:�NV�e���jO���Nߖu�Y��v���Z:{�)��{��i�?�f�UJ�P-����ϏO��(��txxJ"{�a� �;��� *N҉/;2Ƶ͑@�O�G�\��
��i3)���hP�O�6.��[��6մ`c�)��r��〝��$��*sL���1#����WrL����Mt�:f������Ȳ+��+6恳��s,^2^��J����8~F%?m�b�Z���dZ�@��hQ�صF��D%���c�kY�If!�� ݔP�B2K��&1�E��	H�4�h�����{z���Y)C Av>��ꠦ7S���`�Ua��R�x����X���J-#2�qܡX�D��9d��"��0�P��a�����Z �*�՛IV�J4�\o@��������%Y)*q��>qD���5�2f�p�5 a?^���T�o�� �r�(�^�	�Zio!+�P?�a�8|��ǲi+��8U�y�L��eX�~��J�I\=��N��s-5�& H`eZ�e%i�/D֦U^V��(DCe���%�⅙}ZL����̡[�Ǧ�m-�KZX,2��h�ǧ�\�D�ic����h��4k^��.�b~�S���Ӿ���ݱ{}|����o�qf��Y �~I8�LW*;����#3�;���w*||{��Hd8@�����bM��f��gW� (\oT�=<�q"�N�^��:GJ��j��_��������&] �$�7�V��XV�v��X�Z�|��Wo��
K�t�	석��;��;��d?�!��gˣΘ�ąBO������i���*_#%��j&����R��p�(�r$�Gi�s��̐@�Qו��ʣ���'M%"�Gi�	�8�z�e�Ƿ�'➒@�e��Au��P[��`��]쏕�"q�vzůR�]��#�-x�w�[��+E��V�$p����J��(Eհ�IH�J�#��زD2\�_��<�k��;T�G֔��8q��FV��'��kY���6�B4T�ZZ����L).$E���)vG��;J�m�w�f�ٷ��}�g4qb5V�_�X$]μ>�OSp�O�ҦU��qp���� G�)�H�"3C�u̫�8�Q��XН���tU4�I�B4�_�Ms@��d�Dc�-��
�w���Ճ"s��.q���ɓY5)i5��VM�bɓ�l��ǹ���_dX��r#���(�5X@��H��Y��i�Ѡ �
Mg�< �A�������V�s�4R�J|\���m�]#<t�|h��!v��LT���@����s��x9 �R�(���ݴacy6_�v��K=kE�*( t�H�%��
�R�<�|�5��4���a��U�PDh&�X��T�qB%v�)�$�(���}��!�V�:��b�D^�k�������D�U�B½nɈ�^x=�U��k�ko�ӕ$��J��'��t�U��q�2Nb	7�Q�S$j��'���5�[���<^y,5sZ�	��Z��
+K�b����X|� R��%���ʲL��Ń��g�0D7��>��j�Q���Ԥ�j�V������Y�栓�^�#���ҬP@�|u�+Ѡ@p;o]�JD4d������h�NL�/�.�)je�iU�%��VFm��:,x����8Җ^�T�ڎ��~<CB�
iIB����H$Z�����2$�0sT8�X��(f��d�8��p.H�iJ�Fu�B!�QhT' 	�������B�Q(ą2
�����������R��          n  x�EY۱$;����$�]<��Xn�q\	�4U�kY�1!������O�������C��.�Ǩ���O���m�ǯ�i���l�������c�����"ߐ��;}|t\��b�S��|�����6F}5��oO��e�����>oW���&_�_�i����:=��ʾ��#ץ�Gǟ�7�+�h��6[2��y!FFo��?]_G$�.����_���~Y�D Z�ku!t��k���I�݃A�6*���.F���s�[\�y�ϸ,��
;���ɝ៼��5�#�+yoGB���Y�t~sdҡ��Ao��l�!�����6�`L|2_rRaeNꍫ�D\�Dxy�>�_q�Ӑ�EO�5�9�l��������C6�d\��<�ry�<i��a��Mۦ�i\a��Z�"ܢ���p[�x�d�Tp���F���y�C����KҮ�.=#�W+
Z=ދ���cҥ9_� ̬`k�Q��7xp1���~j=.o|��^�ng�\ڀ�͏�e���f�H1����eI�����(�2u�I��(0C!	J���J�I����4�X���M���"�F�)?3։��%D��7�^�s�m��6��=�Nvb�M>�	�9	��6n�t$��Vf�fSb؅#�����KQ) s�"�j=�0煮��tK�;��~+r��M$R�CF}�H��A�'�'��P�ޓ5/W�����m�Lm��w����~oF�NV�@�pW��}X�s��uc��蛙���Kc�s:D]��A*�q�j\�N0��u6C���������Bn��n!�t��lY}X�?�ځ���Ԕ�j뫭���CAw��T�d�'޺�\m��-���O�Q+�H��9r��z�bi���a��d�*_;6��s�H��L�S6�	�A�EZ;>W�GQY�j��$^�`e��G5nEnp��=�B�[�G��1����Hn�+ǺF?-yQ���k�{�>�R������FXQ�٧��N�T��M
ʺ����Q�oT;��%�8]�jV��#��^!��*	@��V�],?�N�j�J�j�u�ZJD	>�p\ǂ�U�3�f4��bu�����/�UJڱ��^�,c^����J&�D�֐.@)�I�F�㳮��Вhf%]���f�Mт�BK��U>I�I� PE�^ �V�z���4�9�]dͰ�O\�O�?4�($ i�M�Z�@	@�p�Nz�V�
I�4��@R#�U�F�v{��+�3� �tf߬�~��5aޝ^{IK�~���o�	��/���P���V�A�9�&;ɸV!���m�^�SJ�YV�Q�h�R1F��pƂG-ҿ��ԋ3x������G	����Y��~���z�'�Vx��*��{h����* �f&^�'v�ғ(o!N���H��-��!IՒ8Ѐ��~/���o�o|�d��SfV
�ἻS|���ׁ;�Pm��b~N	�$bL��0��y�Y�~�Q ��I�Ӻ�m?ߦ����20��G��#@q:am�Q����>��{�Ϝ�A��jS��LJ!�B����>}ڰ�4<�!�m��&�My ��\�������>�����i�� %_���Zt�E��@׼z�/u����h�|zu��,��=H�l֛BQ�~أܫ7n�̨5X�T6�`#��Q��A�Vp�GB�c�NTd��.��k�9���,�XN��fG�$� �XA�A;c9z/`Nb�D�p$JW�}������ס�)P��J`�'l� �we5#'����M�|�Gz���Ay�q<���Oa:�5 z�g-���L�jV��R�g3�l<�ą���:�,��>F{N��N��G-i�^������0�ИB�6��������g+�u�чT�("�1����R�V���K�h�R�	Q�$�f��!�,ˬ����;*ܳ8��(��f{UX�J1����O�j��'�Y�l�z��<��\���yB4�}���n��ˠ��疿��Y+yM���^"�M��avB2�U�-��;�Ԥ�˪�oAផ�����Eɹ�����0ʱ,�����M�w�u��ݽm:+�QK(�}Z��sߣUe�V�@*�gzs�J�]]5V���o;�at�	E�ٙ~���i�����]W��J�+p7 ����grg��[9�$M�.��~���>}�y���]�]�d~/�!�$��fr�fY���z9�%�L�r$Sm��~7~B>�i��j���,XE�Ec��a���HC%2^�F���3���e]���(Pօ���\��ݬ5$�a�C��P��F�P�@k�E.0P� ����\ " ��E���^��5T�;���	6W\���W��w#�Qr~h��Iy-{��޼��d�(j?�\I?����$������̑Zj	F�4�O#�����.A��򬆱x3$���n���uV��̽�Ά.GT#���͂H����ג�N9e@_S�E�t�V��	�����)1�
"���uFԠ��
��/�X�M��S�`���W�蜍An��=n((g�t���ԘU�ڙ�i���&8a�/��N�%VKP�I�m�	�s�W�;�T+��xR<���^�9&%�W�;�Z�/ξ�# {������å�c{g�Q ��>P�5(�뾜��Z&�X�ݯ���EZ����v�a�r�y��'SI��d���ۏJ̣phgD��M��LZ}V�"J̻�&읟FЮ���I���JNoݜ��Q���(h��$�vH��@�s��8'�=�Y'��	 �Y۵g���9Ak��W�N&K�8`�/[�D�GRá؁�*���jዐ�t��~e��m'7�d�I��
�Y�O���B�GG�')p�t^�ڢ�LvZb��h�lp�R$I)�Wk��a��'(���}�a�$a�{�O[�<y{��?�u����i�P�Jt�傫��	�@ 5�#N� ��T��a�2���KJ0dt�ΨL��G�v{��,��G%33������Y�&U�0��&��4�k!
&�k״�ծM�d�y���w�1xI{u��M�DP��m�:�\���tdѮ��冀����Z�q,��$�e�Tj\5��q�������ه���>�
�. ������W��n���J�s��;lGEz�bR}a^���u��u      �   m
  x�mYK��\ל�/�
�I��1���/���p�UO��x�NH�H��%$���o���N�;f��*�x�x�8&ǋ_���Ͽ��������?�e�~1�N�!�,�@��� 3�/+N��d���&}��Y�w�ޢM��b)^�2�}��p�9�����_\/��v���f�s����`^���^�|��i_�f�ky�ꐼ͏a<&��f^��G���1��C��$d����v��b}K����
)�IQWx�Ⅹخ�9��cu�pW�&�b��8�jh�YSD� ǑC~iT7Rl�!���Zo��
?���")��4��Bѡ��8VL���d�b��u��>;䙀��i��}�uy�_4�P|W��:�v�ņ������#�5�<�X�]S�e->�4V�EE�V4� [�!d����+� �o�,|r�>�$B2ZJ(f�ڡ��~ZѲ�p��6�\���X�m]��sy���"@H���e�#a�Q.^�Y����yو�'s����r;t��"1��� -�>h����ċ��BM�A�b^� c��Aht���G/cNn \��5��(i�Y���Z@r;T��1O�h�xB�d=�L����?rU��/0�%�(r��D�DC_ц�O0�[mhx��(fh�F���-�a���q�@��C�bڡ�G,P�0Z��b��`"���B�D����9Xd��ʜ��Љ�,����1�����M�Z۹EZM-f��Jd��f]�G���2��q`8�$^ ��G��9�R�#��cʂoA~�V��i�1���=il}P!\�4cn��vY�ݦ�dY��C���$�-n����E7�i	F;�ѡD���
���F��*�� �dp�HRA�g�5� B�:��wbp,�ϚBs�o�R�%�f�DTD��Щ���Z��e�A�:tS��<�B�>!�V�lԜ��햭�P]~A��b9���c�ۧ���� s/� RPPF�8��"� 3#��
����O\(���em�_��;2?�@���y�����[�N��]��j���@�[#�ԜoR��n֞7J�P�~5�	a��]�����}�kJk����p��mL��!-iWU��C�wWB4�1��$���1�ʌv����΄`���"�i�_�V��B�Sպ�ORxh*�P�m-1Ԡ�_2ꅜ.�ݯ�[��i�
���9��5۹8⻵@\X�HN-g�@��h�\�L���%���hX;��"?���Zc�ڬ��@E�k����9G����(����˟n<WE�AU&���d3�5U�lP�	A09�H��q�ޓ߆!�a|s��\�P�s ��ݬW&�*y@�C��|j�`�ڤ5�b.���S�t�L�j��6ZP��dk�YE��@��(L1s�QHp?��� `C��A�D��3iոڅ���aF�%�S��HZ�nq@��\P@�AX�@y��"pT~�SMZ\���r�M�l�Ya(�Q
u��:�C���v��	a�X���>-�֨��7�C�	!���G-�Wac�DD�Y��4������3DM�ߺ@���W���J�ǴøKG�BW�u��|N5�"�!�::6{�Au*֞�v�Ȥ[7��G�H�药�O�m�;d���rM�Z�O��fި�!����P�xB�Z��騎��K�;&t����C�s�D�*1�)����7F�O���i�MV����i~Z�}�N�@Ttt(�10]��Wm�Q�=il:	ۊ?����(�FM�Q�#�'Ȗ�=C�C+obdyy�|�b����
1�9t�'��; �r�o�^��Зޱ�K�����X;v�UG�.�-�?���Vh�$�@U(�#Dmut;�~�Fס����>�Z��s�J>a����)w�<6�h�����ZgdMGZ�O��Y�
$��� ��{ގ��hd?����[�P|ў��UtJ{A�]4��C���hg�=�[�
ۿic���xBم��E���f�Ub�0���a+��?��h��8�;|�2Rc��+Nh���}O)_T*�ߏ��nI�P�d�:pB�S�Qb��j-j־�b�~�?�:f"���������-��ѴP�>;42�<���	��w�|��\�կ�Ǒn�,+V����^R�"�IG#���4�Q��������p��W��ħ�����yN�ݑ2kd�	A�h�VrE���'VV���,�ϸ��^[�n�+�V.�נ=��gX�1j�=��eM���E��#&��E���-��)!Cb>!I�j��_��G�����v����]�� /�L6m�����|�ɡ�����)�nPa���n�Lr7�U}�2sIt(�K1�*�����%:>��� �Ʃ��P�S���4�';�1�R��I��׊;��2��!�����<�e>~f6��y�Fn��Cf�_��K�Y3�K���3��U�t��3'��hk����k�yi����`g[O(��@7�������)�D6����K F���Q=x/ ��;YN�9�M��L>dm�c*�[Nx2DwhK7�_F[��/���bO�q�k=!Ը�4@�G���s�OM��.}@hə?$AG�f�8�Z�QL[��3�'�/�P�ֳ	f����e>a��p��/2����Cf{@����?���J�         ~  x���Qk�0ǟ��]L����V�:e�mЗ���jSSb��O?��=�p���ˏ�Ggq�a4�ħiNWy��x�d�j��g��u9;i}m���Gʪ�J���VBC��@Pk�.!%L�^֬kH!�|�'�k��H����@��R
��c�a]�˧���c��Áq=��_+`h��A6@��i�ޠ���$~��U ��o9Z�C��#;YT����*#��<a���5>���O#������n'@���h�����wأ��G��
4Z�0�p2ث�r5kx+��,�N%Ŧ��B�뵗�O�H	�	a����7���}ly��`��aGР8~�;��~�W!M�(��<��q�&S%;�����8 �M�6�@�}��� g�z�      �      x��}[o�X��3�Wf��H4ϕ��Z�eKi��H��큀���⨊ԐUV��f���OyL�$A�,�$�}�_��: !����k�d�-�/-NO7K�<<��~;�;��r�g���Ď��	?��Mj�]&wߑ��9��C�9/rw/���'�<N���>Y\\LӤp_'��=N.��L�y<O�$�⫳<���3^]�����v_��t�t��0�:�/v���?��k�0����\@̟���E��eIQ��q�b���L�p���E~F�"p�2k�����Z��#| �7�Y�(���
�Pi)��gA���'���W���������ͤ���A�ܗ�q:L��|ϒ�[��x��c����+���N��y����{��4������p���^r�<&�2_�E2L`����2Ϡ[�xc�6ϫg�_�qQ��Yb���y����x�@�<�%���>y���^>?||���x�:~�x�ɯ��ON3�/����$��K*|>�&�;��g#w��I��,)a����s7�N�KX�V`��g��i�=�p�?�u��������\NҩY\�bQ�����x�N�y����� 8��Φ0��҅����G� �4�"_�M�OY���w���yA�-�vخżLG�l�N]x`�0�$�q��,_���p�sl�A��8�=�>e�&<ww:u�� �ܬB��a��v&��4�8�%,% �����͋� %��E��h��A�K/�h~k�[�I�m鹯q���"Ζ8H� ��E��� VuL��a)ྜ�S�e:Of%��x^mP�sT��3|n@���Ml�̋sX5�_|�)�=�����Q��p�!V\��s	����I�|�=�/3�a@�|f�f����i�=���sT��-�L���`�t��ȽLas`�.�SX������<��d6H�U� R��dE��.�qY!�$C\�؅��v(-�QRҫ�$Q��,$�B�� 24]��ô��Y;t�b>O������0��&S�[�����.��R)�}���Ŝ��'2`�/G�'�2K��h���p�E4��z z�$��l�K3�,��$�s�*n��+����h������Y:n� �G���Q0߫?�؆y�3���=��cZ���U������Ehv�(����a�td��1��{�#�#$�`���ar�]��b���2��0ף8�J�>���K�f�z"U��$�p��\�qBb��8,a�@�2dD�&�: 	o����m,�xAK�ޮ&P\�#��k^�?+��b@��uk=�c�,A�3@#2$p���AB�@��"�@RR ��.2�5�h��w��b�طv�Z��Hl�lZ��H�pL��Ң��ӏ�����t��2$K,�x 6�R���x��"�\�R��w�_��"��	9`�� �(K�`ca+`�3\�N`�C���� �Z t�]�h���eb���j�p���P��G��wir0�ya�L�����t�%���)�����l ֚���JP�j��`�^�@K��rX$�|��`j�Sc��:��^X; ��h#RU��D�#��dX�t�ď��) %.-���[uBt�AdhP��$���7m
 (TN��]�9mN@���A��.p	TIx�_��U�'$!��@�F�/��`�:��Y��te�F�~$����i�$oqŀh'U~�M��!���q���!�u7�inE!��%>?��F�ܓ�,NR��ܢ�!:;7[̚�F��^���e���f}uJv�)���^(AJU��*�j���)GG�J��ʷ��H�A���
?Ћ�Q(%���Ջ�]P"|�wZo���9˯PN\��V�Q�a��bo*Q��mZۑ0^�)2�̄��'�(�B%$�!ڏ6��gg�&����W��� �v�L\*)t���Y`� n_vY���5��l��Z�h3 �s�[4֪�`.��~H�1!T�����H2:�����0�7�4�������g�[}�7�d���'��d�Ʃ���<��,��2~k~�{_M�yKi�n��Pw�a���ѓ�ct"#N����_�5��ȥ5��4jF�m��\ �J��xȕp4߄]�_�er1q*�A8��k��B��;�6� ^���;2�$U-h ��hG�y�@�������
w:����
/1������E!;��oH��ձ�!��/��}�aA3I�G�y�	?`�5i H�ɯ_��)����_�@��!"�A�8T7V8���2ˤ @Lҙ{>���ș��9 ��W�"� ;���ż�#��P�"���(�h��5�&�B�����e�� �h��ώ��1R<wf�DY\�t� x�0����0Aia���v����gǇ8a��h��?q_�;DT=�,�z�)���xl��,O_�p�-g�H�S�Ȃ�%I)8�6e�Ǖ٥%?qd�-ڕ�PO��G(�*���
��ZDUc4J��/
�畤H:Q[�B{�H#�Ց��tJ�Nk���_Z�]&��\P=�/T�\QI�Km��%j�J�I���7F��#	�Ydad�@�"���zM���HӎR�,9���^7y�6�;�!b���!"�V���F�y����᭄���%�g�t�+�ˋx���
w�*��(��w���Ac�}LT��D�@� I+��/1i!r
%�h�� �x�>5��}��o����}���9ERt.:��3n<���9Ӏ�kȟ���
D���bQ�vx�[jg��vݬ���U_�i9	"��P�aO-�uMZm�q?��M�'q;#P}g�����ْ8Xǉhy:��^}��b$̂2#�RE�uM�$�������ﻉ�9�G9�;b���y�:3��ԝ�
�(D�A��
���뤘��;��Y�U�[c�YQ��-� ú~���R^�A4oB� �Qk�dp�v�aꆄ��~La��F�Q�� 6�F6Q G2�}lZm�;:<铦5�N ���<_'�Eʞ�,���D����l��Mzp`�q_cG���_w�v������OV	�V>3�Ÿe�ic4N�O���*2^�a�V���&�W�^ {�:"^�B��w��Z�|��a��|���'�ߢ��p�%ŠH�.����#��d��~�ƴ�;�w�����f�~�ӡTepA������<�HW*�`f	�8����PA
"�A+A�@D ���.�m�d�4|�N�\����5Ս'���7��/P���|P3 K��a�~���,���_)����A�V8ca��+�厌��d�M!*�-�@t�a� ��DxJ��2�̀��=,�x�:�wo���@c�
`W��#?jl�@g�@��^����
��=�~����pn��ݽ�{�_;���7��3���3�@�:��@���Qn��d�,<J��� -��<�v׍EB1�2K�����xp��f����6$Y��FN��Hѱc�Q��w�>
r���A#�&+���w��8�Q=#�u��@��V���8L�r���8G� ~t�V�A,hozi<��s�j���	`ԋi+���%�D��dst��W�I�4M�E�aW���N��g�Lb�r5�#�`<_W��9w')L���% $�e�0�U��y����T=Aޯfl#�H�.�7�0�q���y��� �tOԁ@P�������7 1i��-��ز!��`A�)w���y�}���Xn��"�D����tJQ�j�dD@���]��"1F�I�6. ���0а l�KGWҚ���az�dV�bM%�	��8As�`y�<q ��<�/a�άK��=�̧�J�G�̖1�2ע�!=e��,�v�ǉag��ϫ�2�X��}���� ��횽ۂ��p�f8K�R�;��9��%��[W������8~�L�	��cx�h�fhҡ�\�QA[|���P*���<�̇񢤝�%�#BG:���΀�5!oY����k s� �e��z�i2� ?�D��즉���%��j��|����L@�Y�    �S�iE��ϊ�F�6�$���ş!�����қu�#��{0^�z��bdfo�p0�����ݘzQ��f�,�_��(V�ѳ`o
��1��� #�
�a)a��мg��DZ��&��z�
�H3Ĩ�$�oU���#݆�#�/S�H�3�Rx_ĩ��F�6� �d��e;ʭ�.�8�U4�{L�=�C5�t����#OI�C�1����B_���%�G��y�ޞ[��	���~Ƣ�Gc�&��JKe0���΀ŦNr��=�{�Z�O�R���}�5�:�����8����ny��5"zG�5^w��O3�q��4�o6�脊5Z�"�����k�i&{��^۟"�a G2��(��Z)B��&�;<��ݣ�;�_�LP���A��g��#� س�M8�i|��+���c�#�8nO�9͢8��_-��I݉<��[g�ͤޖwJ/�c-^y�}	r�i6H>PFY���m��e�5�|��i�A�Ț�c��')���Ӭ��"w�ӟI���?��<����w9���{>�Iyc'"���Sp|�ht�|T��� ����I�� ����#�9+G�ZY9����?>|��{�_���h��sw��{����T���x�l�����?!T�~���􁑘s�1��E�ݿ��ϻE���Ok
���ӘB�] rV��(�����_��[:� 'X�%�_�v�8�\@��i,�$>��� ��.�æ�����8>��'� n�Ӱ"�+Ҽ��Qp����kvLs����(�x�����x~�?�jXG@D�����T^�E:'K�����x��Ӿ�vڸ�6@`WMT�J`8�.Ќ-�=Ԥ*�o�&�JP��*��Z��tf�wB��	ɭK������5a�s��t���aW���P�DHխ�)���!���~}�:'�cO%Ƽ���d:ɇ�94���.��v>�@�H���+#��-���L	
��9�Ջ���\ p�jpPb���*��[U��߀<�8��G��'�k �h��wA�lf8��g&������ͣ݃�����0՞���~܃!���L����l����s[ӫ�����W��[us��`pѼ��K���t� V;��~��4��VJq�>��i����h����CϺ�ZQ[=|��H�*�A+��`� ��P"���&�b(��ɷ��N��P�Ž	i��#��;�dI݉3	Ir�<�0�k�L4WQ$(�D\g¥�.+A~,�	3�5�we�a�9-؎�L�6�d�����h/(�Űǽl���k�YÒuh����ȓ��*�m��d��a�1�' �K��o0ZЉ|?��i!)�o���19�w�	� �Yk2�#g� =���zK�����&�Pj�Y	��KGf ��0 �c���H���L�ךH\��"ҵm��du	��S�֘�Yee[�\�!de#�K��q�����	�m��V�kd'�4<�1���(���x4�d�T�MD|��H �x�%�z��@sS����s*u�,�cZ�L����a&��"�ES*�pB�0���9PaL)�!���WZ����լ1&�x/� �s�C?TH�Wp����w�-�Z��m 1�Tx�M��4��j-��W4v�ݸ  �	��v���f��S�]�}X7��`�VV�M�N��YS��.ͧ���	�1���E˒s��ˠ懌cԽ�w��B&|�:�P"�b(ҁ�zgD�(��9��x��S�֡�I�f�ԭ��i��7ՏJ�!���o��oa�n��r��,����ѹ_5*��a���sa������U5��}0[E�E7t�g���u��H|q8��Ƅ����ʷ����2X?ί�
T��9�'�2�t�n�)Xz�W��(�|#*�q2�At\C�؊r��a�e @0���9﫽ΒR���̄E��&�Δ}�U3LP�G��<-�����"_\tb������_���GqqgΔz��-v�(}5j4��>Z��l���>�������|�j��F֟*늌�^��J!3�R@�m,�Pv���̺����,P�����@��cXrLb���	4�P�����x��
� l0�)*��8 �������m%5V�qb�{2��ir�%�RY���|���|�D�
=���E<�ܯM�T~��)�5AO�HE}5��0j��<�u:�^2I
,<�E�(��K� d�e C�b���^̶�������@uUG�
�Gu��0E N����2���Q�o����?���܏~�[y��PF�D$y�PA���:��X�AN�X� �Ӻ�<��tp��نw���Y�� z��z�������;
d_�i�,�w�
IZ��W#��#�Ӳ�k�����K�	��!*�� ���_�ؤ���zI_p �`r_��Պ��<9<m�qc!:��'A>��<�:6��^�P쓡V�<x��ZhS#pw���JM���@�;�F�`��*��3,`k�M���nmr��fk��������b:��ցb�I�(q�4P΂@�ӥ�Y9� �x�I3c����ڑ�䞀"ÿ�Q�ţtz&����&�� ����p���`����1�$�6pn�Z;��i�;g��a����s�3Y���UpY���+)�hL6�$�4� t�hb��#��,��,6���2_��<��䤅�U��dz�Q8��׿�ֽ"��~ع_E�ߤ�Y����{�4��05�� ��6��$p�{M�*���>w@7ڀ��5Ap.0����.� .
(N��|ށ�f%�]q��,��O(�Kޒ1�4i�q�|2���><<��T@/�tA�g�����Շ
�jO�o���-��t�|b|�7��|_�Pu�#�o��@B���m_��C��|�kҪ)�9�z�kOi91ل㪢��!1s�i<�����B @(Ӿ��s�ɬ��P&��K\�(��\�� �ļ0d�c��̟�_k�:��M�d�D��f���'��t{*�D��7y�@����X���`�夈��a��q��',"֊>#ǯilU�� ~��jf~/G�`�HP�?/�I<�.�q�/tf� t��r�Ah�*��]S��	k2L�,���H�]n����l9��T���d���\�ĵ�g�k����n�7X�50�HzRcӶ���ZayB�YT�e�b2����RV.q���B��sPs���֮�|���/�AϬĔ���w�;��.H�����Ĕ�G�{t��҄� ��$͒�_��;<D�F�`-�0Rh|�-���)��3�Ի+�������Dޘ� ǋ�����y!�#��2��M��S_+\3��ǛH_S��b�nc�������q�Д�|t���5�}X�F��k@?��c6T��(� ���B�f�G�A:WX��(>(��NS���%�/�%W<>�rat
�+�T���)�vGp��%ݖ��ĜG�� �� �:y�!���BIJW*?
l���a��u���c�,�{��Eѽ�zw�ݺy�g�yEٽ�:��;O�r�m�f�H�am30����F�
c�V�Ov�g��p0��9�uSc�j�(���^�	��=ʳ��;L�@ݠV�����R@�U_(�<��v����4���xؔ���##5��F�QSJϧ(y!v��e�IG�z}����o����el�[OGT���ܯ�xs_a,ᦥ��̻Nu3>��F����^�o��կ�ߐXeD�H�~�F�ñ���#�I�6h�ޝ�>���"��,�D��X�0bA���m��"Cf0�+ͳ�B�&H�4E��p�oV)���mH�w�@C	�V�G� 	�Oq<H��?H0^F��@tp�9:Xɒ��S$V��0����%8m�g+�6�~Q��"x+	L�C��D-�2/ҋGUx�,К�M��Ǩ�ޫ�8΋N �%LW�׵vTL���Gm�+�etp�dǌ����І<4t2��d)=�B�6)�qV	px����V{��Wt�h��MAS�//���(SB��=I/��)X�k�jO���aR~����n|K�    mK�a/�f��ab_w�3���V����,yG���w���<�7����^�`Wc���f:7�֚.��p��'^	�6��6@
��p%Ze(�Б����q��;���E������в�ګ�h���3g�Σ�[=73����D��C���U��duՏ�=��N������2�Q'�Bc���XUM&�mBv7�w�)U$���d:�]gR�ȧ����.��`t��,��z:D���w�X�?Y(<�2Ҽ-���� �!�1oN5��x,ޝ������yy�}6�_s��@����߮���8>���u�w���e+7p?���w^�,_Tz����=0�:&� m(x,	�_�1q�	�XnCͅv�����i<�� N��^{ݓ�x��0:���e���ښ�%��X�A}x�iX�DJ.0�}��_c������^�՛x���pT9Aq%B_j�.6p2R��#�9�r��@*ᦉ!�1�FR�, �e|uĎ��<�F�b����h� Hf���� @X�C�O1�hs�8:�Z8a@��}-�N�"�R��I��6%������e���� �dfk�_i�=ngf��A�mJw��).���\)aan��;_4ќ_ȅ=&�0��ߖXMZ-��k�~�A�0у��'������˃ݣ�'�$����~0?. �L���r]ŵ%�]o���1��t��Y��)�簜P�5Fd4y�.�V��������
0>�~/��=k�Ol���M�韧s�[^��������A)|E9���ԟE<oF��j��'L��O�������W����:�����u��U�_?i@k$�n� ��4�>J K�����3��fx�	�>5������z�탍v�[�B��9Z�f-5��a��t:r!W#���ߪ�O���D�O�HK����-�d�W�¨IM�XO���j�LLUiC?����Y�H�M|6Z:*�5y�u�x6w��"�������0���`�,m%�R�M ��Ǵ
��OS�X��))a�@g�D��AN���O�@�I��3�?$կ�&�!��4Ջ��; ����ֱaU	h?�|Ε���0����*�T��7���aj��1$ b�V���>�Sv�c#�R�!�2P��y�p)�@�@�u3�%��a�8�;��W#<F�']C��Tc��u[����ɚݨo/��O�˸�'D`�sP�@Yǅ�ݧ���]�w�H��z�7����"ShSQ�%d�B{����&��	n���s�N�72��	�))�D�@jJ���p$%7PV���Z`}I�D����6�<��x@4�����׷?��ǎT��m$4���yl鶮��Ta���*�#.��S��F�kS?���u�P?�t�CO��?�
�s?[����.i
�h��S�JP>�A�����ϑ�؂�@z�&r��=��n��9����G�2zx��j�1aL�_1��U�;��DL2��@�� ��iJ��f�A\[�Vb-��m�H2ex|��2��^�T�3���2��>@۔�8@"j�<�5x6��w��^��
XP�5$�2��FX	��w��T�d��Q�(���@��(����LIC%1ɢ����E���ߠ�b(��eϨ���O��[��)53g��Q�:�4���6$S]1����{�)Q��C��b���
�8��8����y��I>Mg��Q�����?cF9�2�̪�U��E� �[���9)N:
4%5�=�o��W9��t�`��r�7A��b�~:%�%����;H���A�i����Z55���=�2�B
Gˍ����Z�0u�g�mыɃ�2ZB}�5H]�����������b%4MƁ�@5����UEn��0P,�U8�!���b�Q��/����htQ���P�R��h����"�=P�4߄�j�d@A	����fr_E@������U���E���r�Z�g�U�*�V�=�N>��H�T����(h��#�g,l����P�r�J�{��R�_@5��0B�g���4Tk��}u�q��:wN.��i�G�(�S��go����>�k������ê65vJ�(RTc}�(
"�?p �H��P�o���d���2>K�	���M�*z� +z���aZ�ܡݝs�OGIVZ��N�@�'�Ӈ���UgR<��Vx�R+���{_��ථ��MqM.�ks�ڑ���OnQ�[}g�֖�����C��M���y��CG���i�%�J�c��c	cY7�T?&C_���;�$R�4����BX�{���"�������D�X�d/s� �<P���2V%�lܶ�b�qq�G�6���]/c|P����{�����R��6�f�O;�{��X�������"��4����&��'��(�֓�Q�U�+����淴�wl~��o%����9�j�wx~�}���7!����*��=W��ia�����N�i�1q�H!=P�`b$^:3��ZF&AE����ݟ�E?�%4%��P�N�ĵ�n`l��h�NB��ģ��wf�z9�*C��b�&ؒlo�8zX�]֟\� @��
�/7��kUf�,�����F�Z�QKr-t�~�u��9���":٩���AD��9Zn�����2��;�g��c��J1z�"�s���'RD�:iEs�v���c+CO��tp��<���x�X�Š�ǯ�lZz�r�.�`�U��uu�X�b��s�b�݃n3�}�;�7�~*�q~b�o���ZW��<���`G��A$[%��ǜ�Zj,�*1��I>������W�	�:�)���ª^�_��[���d�{�V��|;i6ο���	�lbU����bU�
@�]I�jD��܍~/ᛯI���I�V�C� W7�E��U���4!��'/��:8|��z����'�����.�5���#ἒ�Ʌ��JS�֨=�E^��a���.P7qY�� ���x����A��9�h���2��U���I�j&A�Յ��#~M�a>ɧ�F��̨�%ZdP#M�s X��b1�13b=� ��P�B�P}5��t蒾�[?��.)��j�Er��(ILg�W�n�6�"A�-�'g h��4��J�}2�b��qT��k=�0�+s�5�.�:��n�91	�Z�p'a�J�F ՘R!�)�r�;����p�fT���ȍ�dET�a�ajs�h/&y���\�����-��CXT��f��H�$��=�p��ek�r�,q�bS���4KˎZ>Lf��S+l�|�tL��,��>�	�%&bxhD��lN��n� y~��M;�׃F �L�	��}Ȫ����k��:#;�<:�y�s_"x�wh���X�bL5mac�j��_�A���+ܼ���9���F�%�00�m�����ձ�����v��ic�����#�d��P����{���t��Lz��L�EA�Йw`�_ rlk���U�`��^ �HÚ�{P:@P_��-�fs��V��|�^C߹iWͶH�����
�1u���k��t,��#R�\$@8qO͎�IA��.� }�;�I���h����Zʆ2�.����]������ɳ0H��ԉdX�MkɈl6[*�C�1*e�bH�ژ�ʤB�5n!Tc�0��1	��U0�(�	cƷ1:H�"~�,�>�NP�(���ٌ�0������M�����?�6��ˈ���Д�ҽ�u��m�r��M�3�
 MP��mj3R��၇��R8J�V�:s ��~e��*0�9���r�_i�:ػ]�J����W 8������B�}�>޼������<U�5��	���;�U�,�腂	%zM�a*� ����r��Ue�=ؾ\�^��
"Y���M��M����)��Rʞ�M֡��g
��ݟ�b��>H��cd�X�h/ɀ�9L����C������-����Y��2_`��ɐrw����v�&��Y/�6�"%(����,X�.���G��+�|���:U�b�A�RzU�ћ�c�}.�A�>��|~Q�<ztyy���/�/1	    �.3;{D^�:�����`h���7MgW��T�Ge� ���ᙸ�uҔOGCGX
�kE�p�&��'i#$:��Ơa�o����Ƞs��þCQv�����f�*��O��n�w��"@)2d�
H�GTi�`�����k��W���IKs�� �+,���)��M*�uő�e: J]PȜD{�9	<�N&Xma�[+�w�}WW �:4A��,��'23��@Âu�ו��+R��8X�=<w}�{xn~��a�o�����f��
�}3CS��'R�,�$B
�hP�N-#O��$�ʡ���$9�.��O���}�^�!��^��^���
O�s���-������g��/�d�y/^B�gF�s�e�Yo�D
��e�����=���Ap���޺��X�E�&��#�o֍VG�	�ɑ���h�[ ��A�#X8:6��[⿎��9��uR�P����S6�|V�+���"�g�n�.�g���ðs�)Lc���Z��&]����KӬ����QGzS a���"��h�
mWx-  ���
v�٧&��H���<~���Oucݗ6T��$g�6��?���x~���s�y�T'1&E���)�Z����e��#�#fO����'/�ݓ��'�����ϾuƄ� nK� � ���whڰ	�&�6l��a'T��g ���}��G�//f�!<!��q����qo~�;��@?�E����whD
r��
��zJ+?����������������%��_������뇿s��G������������~��������������e�9G)U���~k;�|����d��,};������df$V&�����(`&���g۝������2>oE!�9
�Ma�::R��q�Q>~+�:�/���v��+W�g�Eq7����o�R����;���Rm�/rw��M�I���-����
M���J���6�������c w\P{~��=J3�{|���]���<���g����沬q���M�k`���n/��4��o� ���:������}>͘�}�'l��Mksޙ��<�J�=;�����ó�WW�l��^��w���#������a��E>�lߵ(���������,�O�����������u�/�@qG�� ���������]J���?~�_A����������/d��AI�gD���]W����7E1m1v<&�;�gf���)ÀL���0�ەL�M�	�@d�4�4!�2��k4�{�em�Kz	���ŗ�?���~k"L3��Z����N!���}���ani��O��-���s�a���!�?��D����3�b(�A��X����)\
�GP�1�q�C�i^I��>)�]�X`w���"k84Zû�/N����t45���o��3�*�W}49k�|S�.��s<�,�[�~&�aB�sټ@+9ܿ�S�4���MK;K0)�����ӥg�	�xy���������E�Ez�r R��)'g�@��/�e	P5u��b K��|i��:r�����|�C�2k8K�|�Σ�f%���Y~��ͼ�&wh�XAK�QF�ɕĞ�aW��V=;��Z l��X��A���*��"�vrTT�(^�'��-�Y�. 	4��4�Q׊n��(j,�zQ�D\�֞Y��iHАr>k�e�KM�pׅ��f���y냧Aa%@�#�fZc龑r�#��6�����8
L`P�5E�����xp���L��ٳ�;��l%&e����W[6��w��	 Y��Ռ')=��nqMnLj��P+F�2�-�g��4������I�i��g�E� �Ì�b`�I=�H2�׮���b�ڡ+�#��ƨ���5�aE{�m�k��#��X%ܖ]�֌��K��'��W34�=~C��:3KF�g��@ު�`�!5�$T&IyA��q��ge��xSě`lU�4���"7���y��y|��J�F�QZdB��}�_ �{k�jsvmrxE췀�s�������t����U��!r�,�Yf��(@60)�ȝ0gB�z���(q)(=��ƤV
ҙ�HƐ��B�Q$�"�Ո�*q��������n<�s��ƀ�8
77j��$ɈN5��x�7Ii.`��؃���P�F..�1e�� S�Pf�S$�8��p6��H���%4�zsL˙mWo�+o$�ǡ�X�̓,��I<�&�x��Q>U�yr�{��>����{�����	y�s<�C�a�(��XB�9f�����Rî���t�ģ	V��������aLi�)΅9|. &��wO^~��>����M~�׽�����J%�w^?�RA����N�z��f-"�*�nTE�cq7�(���Q��~�9h��Xmqm$��.8�Ņ�=�<��M� �שԚE��{ƴ��j���~�T��M�WV޳V�׽��w�5�L^a�=�ح��_ww}ԂW���Wt`u�q ���V�e�⌷���I��R�x��t���l���e���;E2K3�jYS���$Q������ڣ'|�zG�X@5R:�MƱ�)�Xc2��ڇ&L,xy�{���=������:�OY�h�@U�#��|_ك(ڭ/�v��*�����>r�txT�6}w9@]�߽��W6!Ȯ�RL2IJ��W�+��ؼR���y��[y�헄��t����O����争u��W)<�}I��;�L�Vr�U��/�P:��q��5�Zn�_v%�f��q�Q������d�Z�)?��
VByL�6�tL�% �i��"Bx�{p���=܃��#�s�|s }XW�T�)���@�p3�Cc�8��{�_�dfΌ�f���U B4�P�j� ���Z�'d+�xA�]��ϽL��k��⪰2��#ٲ5!q��WK�W��o��)�g �иY�qZdT��21G6$���4-'�1�5�#;f�|��;��ă9*��\_Sh�fȫn�q�~���<n�Q�ѯ��r�w��j Ț�]�o�����(�*Jdu�-,~`��ݬ���s�:|��"�%�u�M_x������8��
��'eX݀�^DLiG�:�|����}�/�KJ�d"T,�>� (Z$�ʝl�ɓ���阺I�9g�*���잰s�h^���������$�}Y���3��Ն���i��>*'^ױ����g6: �	�ͨ���l�K�!���b�л��fj�>��([fX�\�����qU�o\U�+((��~�}��(^Urܶ��H�FƦŅ���T���JL��ݸ���C3�xZ���j�N�%S�_\�5& @?�3�BO��A�2pMI9k���d~��4ѡ������U�Ķ���R���A\Nb`��w�=Xg�(�*8�B4�勑�fu/A	:O� �M��W�JS���Y:�#�X"��J;��%��W�h{ a���P�$
R]#��]�|����M��
���y����Ib��:c;A���e�L����4q�˼�����;�+�T�e�{W�W��ʑ�~}d�93Nؒ�:Ԣ��
�$�t�7TT��P�/�L�i'S�����<&�H�?�����6�mn�O8η�b���R�`⼍��vN!�]3����ψ����cm�n��o��&µ1	w�ku�(/��bA�4�ut���ܐ�8Ӈ����և�Y#��~\����U���{撠E��\��L6�$��'�K�O*I�-v�5�֒I���#���|��L�i<�=��^O3���A=�[�4q\��5������r�~n']t�`�lk�@�D��8�b���RE�S�]$b�^XySc�EJJɘ�h�����Lh'9�T �B��49~g��U�%�1�FN&�8���`�5�|���|��1T�}�=o߯��w�H5�m�7)A�N@}����^Az؜�<���ѽN���b���,|�c�,�G����iei �t����E����$D$��C����?����m��p˳-��3Z!��r,�T��)�~�>9J�7C�D �  qI2S�ד��>�
{'�0g�վa�U���)#�c��Yq�?I��CbN0�`�7���k �,i�+q�dV�%��2�@�D��X�I�0K�5�	j��������HІه����8�~�RW	����c���tW4GBe�8ke�$��~��oMw��ܽ�Y��fݯ����rs��_yY}x9b�1�&s���t����ر���@!Ɉi�AVqi8@wI��~�� �܀�?dUf;\{��Gu�RS�Q`��d���F��K��-�'s�A��Ô�A�uWG�����ր�k�}v|H�q� � �`9��:����0�t�t'Ŵԁ�?~�ΝFnj�C~��| ��ij]U���Q��� �4��<�j�VOauͻ���iTmP��
p{��3����ѪZ�bd�ٔ�J�A/���@��9�gx]-�M ?
0�������vo߶��UˮL|�D�q<4I�����]�`�ǉF�4
�(�Bj_��ƣ|�SQh��&(�=�=:|�Pv�L�,�I����i�<�k��F.fDĳ�j.�l�,�C�<ɖ݃vg����(k��@�S�>��J���q�wo����_��~�V\24�Јہ�O��K��pG�l������$,�U���l���N�m���چ��veu=c��PS��K�)�Z;{�9Yh;��pK�]Hn�3طZP9�~�����~�x      �   5   x���  ��]�c��B�u x�h���E�kg
.fB�	�t~�F���      �     x������0�k�)�Jek�KW���� i��m�H�H���S�I2�!�L`7�J���gD��$%LH.$ᧆP�Ɇ���%eK��r��4	A����#$#/��e��(BK]x���efRJ�ޒ0�rl���o��z�t�pL ���Ĳr�C�hD����#��(�e&� �� ������=X�zY�A�Z�j�B����@���=3��R����Ua?�u���m�Z��]��w������zx�um�k(�wp��xv>���ev,��̷c�ăk�C�۫�3y�|�޹��#O��q{4_]����J&f�����ګ-�)[]������L�����'>�˛(���ԉ�s���3�n܀���"�ô�)��Mհo�r�\e�L��kנ^��AC�`g�;@eK��4XR	�������jg������ҰT�l�4�:1��fA�e�c	O���ش�hΒ\D!���Y������~��4�q��MA��xm      �      x������ � �      �      x������ � �      �   M  x�uTMo�6=ӿb�CO���m����b�i�����蘵$��0���(��؅>H�hf޼�LΦ[M���҃�m�����b*gB��d�3�9�����/������]�~����[�2ɥ��Jr�����fI�eY:��JI�������j���<bL+�Ûݚ� R�7��u��׸��ш�D^ȼ��T�FUz�n@9-R��|&��YN�o)��}Pe�Ȅ`)�X�l�I#-d�H��^Wڿ��o?�������9p@E��T
.fg��y��L��"�NL���7���Z"���7:}َ4���h��+�v����H)jL0���܄Kڹg�MEk��=���>�[������U:X�����=�ёm	�ή�sMW,�%�M��+�v�lÆ³����ð1T����&������ڼ3�'!LaR��衱U�;?{��w;D�4�,�?G�GF���'φ:�L$$Ҩ�����u��I��gK��kZ��)��7��mL���������*o۸��������h�z�b�yE8#oW�6�Q��U
 k�rʡӵk/j�}�������PHׇʡL��/������F׷#] �;~kVɷ+��,�-ZD�x$��*���;�$��2ɔ�IGwH�T�|8���Eٯ4�B_���%�8U������tC徶m������I�A�2N���k;��
�9/����B�$��Ҍ>�ݢq[$��n\��a��nM�Ѡ�S3�����!P�Me��b=Ƒ�mm47vm�?�ۄ�,�zFP2��c �u-xI>N���y�	QH�=OT�*1=�����s&��d�L&���-��      �   B  x��V[�� �NW��k��_�u��iH�Α�k�� ě��N�Ky2��8	0!]A��zH~�q�3̛�TZ�Hٙ�\�qcO����yH�h#4H2Wa]2��@rI�Y3M5��Wl+8U�|�`�Y^A�N�ed+rd˧a�=+���T��$NMR!�B��*z
y'<Y­&H�K]AeS�����a&Qu��+(��E��S;n�}B���0���F��B�>Z�F*N#��0o$I�<�
b�Z���&��v��'ģ���_j�H��_���%T��gK�-��DAk(Jڅ��q1��1�yE��2gSh	�$���2_:����/P:���=Cn8��3�.!�9&�q��5�6̝���"d�XӚr��B@=�3�8���%��Nq�5v���S�$7�x3�^���N,[���ٶ����#Ğ�Ms��8���w�þ���§zv��"`YB�+�P�nS��/���L�!>�y�^���~�0(nWE��+����c��Tf���a�D�����Y��=
��7�O���B�W�S����'yf�����EV��            x������ � �      �      x��\[�� ���E&/��k����
��M:}V��"2!�lј?�y����K���J>�K>�-��#V>�~�&-j���%��-d�#�Q�z�#叄���R��՗[��ߒ�A8����I�	����%^"���z����.e"�|��sH] �$����@ȡ)�"{(D�Jq�|���o��Hι�;H|��X��Y�G�߮|]�Z:r�d��Om&V��"_�C�����a1��*���!I�7C�p��H��+zhH�Z��=�z�o��$j�\w֫�g`���#��'O�|K�Z�7`���^'[�T��z����I�A�h+)9Mz�ۉ��#���	�L?�K�p0�Պ3�z��-��;H�|ҩ��G*_uDc���׃���#H��� �X�*󭱯��GT�A�}R�K�6nH����n!h�@Y��m;E�
uχ���C�^^ޒ�=�H-s��t�P\�-�0�1��|�0m=�y���
��eh�]��4i]��PO)��G ݴg�y��r=�Ry�#�7�mZ�Hq�r4� "��`9�`����܎X����a��ܡ%Y����{��k9���Mn��l�0��4Y�v���E4�2�_�	N����;Lyw���<YDȀZ�c���[�^WD�uNri�(M�a&�)E��e�!���k��P��#�b�7{��>�5*1h%Y��z�1`d�A8L�Nd�����N��ý)��Ub��}?��9�oj\͸�p�?��mgӲpX.���K���'+�5En�ARb�bp�%���ȪǠ��f�B�������<X�LS�I�0��x�4K��\�*��	\\�A�s�E�#�W��J��}B>P7-R.�����<�����oO�����b�SNS@Zp�t�{fR�{қ �B�ѷ��,���p���v�����Ob[c�VB�@�f�n�=�r�r`�M7�@�q{�%�+�z�uʠt����ط5��{�6������mH)��FJ�MA�q�`��#F���*A���u/#u�ӿl�_��q
�8}O����7�A�2��`'�G��H�"n��$ɹJ�J���^����,�ݗX$RR�ЇJ�x��5Qn,�wZ�	�9V�H^&��!x�`���D@*Ή$Y��H�C�1�Bl���i]�!�y�<��Я �1�t��Ӆj�����TS�}�K5ð7��qp���NGM���0�0h-�
�e{xگ�#���B���v}�̧�V�M�Yd��Dw�����$#5�^q������g2�e�-cS�Ӳ��	��������\��>Ǹ�x���)��P
k��@�xy}���Q|Owht���M3nӁQ���B���+����,�;zvɘ�N��pH��0���Q��OS//>�J{��&����ـ:2q�xؗ$i�ږx^��D�,��m�5O4`�9XC�R��PsP
�a��נ�U�R���o���!�5?�� ��X�{���&��oW�K����~0�(B���i��᮫7&	��b+Pj�&��x�Юp#�����(_&\
�T�ګw�����T��4D_�N������,�'ùs���1n���t
(CF�j��:F��I��@�F�y�a��R�0LS�em_!({�K��2�ֻë�#�W�y�X?�����My�>A�MD�L��<�Z'��}|�A�åzܸ�75>+:��jv�ݑ��c��¹H3cw\z��>�5��	�ܑ������t`S�+"�r�-�L#��tQ����A�͍��g��ҕ<�����'���AlF��?�)̖D�/����ԃ�4D�-Ćd���e1�M�G�C�r��֗R�(LPJ5d��9�~w�&�4/���&���H�[�d@��$�3SƼ0�H���2\5ý�I�}I�̨[6 Z	��xɞE��Ӝ�5ǌ1�]t����	�
N�[`�zx�D� VR��T[&�|���+��b.��yDm>[�d ��ˇ%���3D�&uM�\x�4���0��TњU
̡9���\�	���En�o6����_ z�[�'�E|PIW���0A�����5�k�a�&�o����)_?[?Wc�x`Xд�h`C�}w%�JSg�@�Ґ������+9&��8��&��w�u�ЬūR+z�
�3o\��C��3y\�=�@���Z�숰e=�	B|xU��[FbMZ� ��*����:2T�1r-�M�j�9�����j0'Yc|�~F��r�bZhZ�JF�X���H�W��#�Y��$���!!qvݶ����3�=�#���	y�����%��HY��ԂV�Kܶú_`�.��G���֠Ļ���	_���z*1FA%伃��Ez���Ma��@𲘕G~#\�GW�M�B^���LN�b�8 ��o^]���Z���7��4�DEi�`w�3I��'�}o�
A݃5�"BQ~ ���:.0
��� L�/�:��ED[Hx��D���ۚwOYs=9�([���;���r�$ZGI	dҍG�5��V��i�XUIP���	�Y(b-��ܻ���)"�nqsi]K �A|�����s(��D��� �*C�����`u�ZK��m���Ϧ��q�q����(�~h5X�!�n?`�z���!�i�+mezE
6~�Y��9"�5�M��hz�I�&�\��r���p��BӘ�A̧=A�9�Z�f�,� v���\������ey_�j���FǪQL�F�1Rҳ��(W'�h��������Z�Nm��xa�M/}Un�5�{�/t�5EL�ȩ&R�x�j!:��C.{5�SM�._�C�$���w��"�م�=�98̬�B�x7�
��j¥��$��AJ?��	���ic7����ٶR`dܚ6� �[=z2�[�rp9�1Ya�<�������x��k�n�z�ȷ�a9��!|�{�{�e�Z���G�q���t���0��:�#��8ԕkl[����Q�b���-�3��Z���A�1}&�׀W�QS�B^�	b�6��[��K����T�`��dWO'MG�'��^:}V�%9,�t��y�%Ƥ�n��^m1��%����#)=�zL:��@];#��^К�������5~�7)�P���F�zZ#jHKs-��Y�C�K/7#<�V��+��U��ihMz��d����K/�}�Ps���@��'_��8��Z�4Vgʐ�z���&����Hͳ�e˧`[������`J}edJ���-�N��&��MS�����!x�F>��� �CR�u�a֭�Do����w������Zɣ��Q@�~�V��16���0v����1(G4�(T���Qa�_>MD�m\mVƄ��W(2�Ю�p�������]~-X��`yם�v���Eu��t��1���vD��{2���?��H�.�nq'˦��M����֒Q��%oE�."�/�꤄0�-��Gl��� �����f!5��c1�Hɟe�S�:̐9�Ũ}��'�Z��d�uc���n5���L#��X�+O\&� �ܘ�r��IF�^�!MH<����\�	�UHM��l6�ӆ���j>��L�&�6�-uT��A�&�
�h�i;n/�w��5���%7�Uޠ�,�kR�U�5����|m)���=�[FfG�v�������-c�`�ImkKS?�X}fU�v`V��>�1���P��N���*A�%Lx+�C������w縙^I���çly�� ��`w�*\&�,���OSO=�q�8�k5�e�)F�	߫'f��Ҕ!@���B0e��GN�7<� �A����2�Ym�q�|X����7�ZFSuf ����S�zRg[�MB�X���'�=,�:{�Z{�s�*i�A�,�N)�����7+��6B����/T�ﵑ�d�(���ƞN����[1��},g>!�)v��⍱e�T9c�S=j�d�����g��D<]L+��7k�+���9o[����B�覑�>���RS�B�L������I�g=t�����r|�;��r�;���N�D�~�0d{�;k9#�"S�B|�=a�����ZN�k�p��ظ^ 4  ��e$�'�<^�M{Z�jtX[��;G⬬���0�u�1|jߋL�2���z&H]�ε����J f�J/�ǵpd�;^RY�j����3�'B��4c&�B}BrHq	���Z����E���o2W��m{�S\r���YS��s����{uqzG֪������K��9�*w�餇�X;��Ѓ�V���A�dBkS�8D!��8�@l�`��I)�P�f1��;��B]JY��p��߂Kc+�K!�ʨ;�I�V"f5��� _D�d&5��)��^�5�bI#]y�pB��A;zcoP��Ģ24t�A��}&>�%�7�-��X^��KP����d���TͰ��#�a��-����}Ǳ%l�c�QsW����B�R�;KQ2�s��=��̓��s��$��~�n�+�]�~$��i�߼$������[��� J	��~����o|^.��{���H�o9z��_d� c����A�Pu{��Q��2c�䥝��C�r�QM!0�^2�2'[}�p��ñ,�D-M��*�8��:J/ ��E�����q���?��h��Vs��y�.�aω�?`�ֈ��e �(+pY$?�Ye��#Ş�Ĥ�M������k���1��n�Nѱ&�;�F�7���HK���P��O�bkZ�0�����곺��*����|9�d{6��	+_�������pe�Ü�n?I�3R]�Я�����k"9_V���X��A�f�'B��nc�w��T�-5ZN��!i���ɫF��e�v��Y��c��:�9��K�Η�{������d��iQZ�%�� |��ό�\[�R![Nq�ż@0E�u����Ԇ�3aFY
.�؄TI��^)1]ɸ�m#9�gU`�R�nWޮ����Z�!��Sʰ)��o=bN*k��%��f��{w=2������eH-��h�=��|\�6õc�5��K~���g��dh����TP��"N��w�p�N�6��^n1�>W�;H0(�X�{�`��r�����(؍C�<\�7���R~�'�4F�������һ[��ӳ��`��>P�PI׆�R��Fh&×�<ȚĲ]���~��}�m*      �      x������ � �      �      x�}[�rɑ=g}E�f��ؗ��$��$�0�t�.	 	��Pũ*4�I����G$�d��?!�f�{�EJ:�L�=�����+2%�>��@�\��5��Vh�}2�H|��6Υ2F�������.�:dZdGǇ�_=ͬ3�;�R�[�Pz���1k��/�<*��������?�jw^,���d��L�μ6a�}c^��K����6�bp�'#"�]�y�y����e�A��7Ū���Oַ��w���2k�/ġ��Ϝl��2Wj��B�y*F�I�2.�Y�87Ί`�\�2/`�jhU�Tl�)��EXh�0a�	^�!r��*ε�9Y���]��O���<Ra�	p��ЇfLcJ��](��ε0���K�����
!����b���]�^���]������LEr��L�3�U��R-p�J�m������B�����A�߬7닋u��ؕ���B�8�[�J�Y���H���AZYid�S	�%�\I�e̞�>͟�G��Η�E��,.���\љ�_�<�=�>r1�1-&έ���(r��[:�	�"H������b���Ɍ��f�X�˙��~��A� ���6~�ӓb���\2��$�6�
����K�\R�Q�C�^�QzYJg������w����L�h�֞��e�g��aX�6q����B̔X��q�e�r�'�Ej[G���k�*'��N�V�j[v���<d�=ԕR̅df_h�
F�66����l��=1oz��"A��d��<�W-�B5R�]�ߒ=�]��bTlJQiY�Y�l��Lu���; ����O+ ߓ��y�h�p������."b��K���E��p�����&;)��iy��l`�*�j`YϤJNU��4s#coy|��[��x]�������Q��5��Rr}ص�9݁4�+d;��ϑ�&�T.� �ȹ�:�����OQIƑa�� t���0G��k��p�7�!��z�E�����΋��Љ�]|T�/�ª9*R)���%M��@�*n��Mf(g�/��3绵+Ma�%�8����T � bt��
*�}��KN�k��V,��4��q��O��۔�e~\~Ο�f�I�,M�v]j�����|�S������`���P���'H�GG�Ɖޮ�2M	��:˟�����G��W/?�"�\�ҥ)�����G�}%�������ӗ�g?�O���h�G��;˺뢏;�5@��w�n�>���(����ZUE~���!s� R���}�[�Ԯ�qz�-�X}4v�F(� ���O֟a�Sfv���l�`VieΩ`[���B�~Pr�!;e����˃7��Ǣ��Ai�R�	`�āQ�A�	*�u��uX�bWܖ����\mЬݸ�[�#�nq��0{�����g�e�	I��*���I7�-�U�9�P��V� ��-X�4]���˪Y9!�t!����<�]�a�m�\��c֗nc9�GcF!�Y��L`oL�� >-��5Z�0�#X�*κ.�+a:0q��<���`�@�~S^ށ |@7� �נ��d$'�2�^��K�EL�(a�ȉ�	��_@t@!�����Q;>27��m�W�`�'��A�萭݁U�9�q�tz\]���eY7�jEC��/��p���}�<$��#�V
9�Be�����,�M�
]�&�,�)�� :�5})J"�b$hZ��-����Vz��O���/��/v��}�xS�.�3�ji�f`�������ǣu�y�*>�?����q���� FG����PUo���*7E�����wۼu�҆z��:��4�y?8*��IMh��,.�pZ����@&2?5}��r���i8T�'���F��i����m/�X/�T#�m��4}ciiJ��E=�L @}���C ��v|����a��g0@���n���p�ߐ���@	�Z�:mn��tf����ߡ�]�[���z�,�J쌋�N
���a��"�mmP6`�����#��|C��' �B?�H���ހHb'���u���li��e����0B�y��?�r�]�1�Lk�� ���+���b0��t�"Iۀ�RD�7#��I���ev�=RoW.ďU��|<��d��ٺAipA�K�y-����Σ;� �9�.s4���z��/�U��,&o�3ÒA X.�@�PmJhx^����Fv�QQ�?4��'µ%k�{0Ԛ��'�$���E�)0.���OH'�}6���e�˦�	M#X!�������iF#/L���y��e<5{|R��J�1Ux����z���O?W�������o�y� �8��z�I -Z��s���F���h�a��ye����g�Y=m%��sIfn�Ym��>�r�o�\��j>Zn�7뻛����-�,���Y0�B:O�il��N򲸿ɏH:�)�2>��L������
V䥦�F/kX׵�#Ub���S�<X*Ts[Lk�RMY�	��(.�ܣt�lf�_Y��I�:F�h�����DF	Z�Sq��_�m�e��#�Y1�W��k��5�BJ?�/�I��1�������c�Y�Rq�l���r�.ڈq����ʩ�$��o߿=;z݊�þW5a3(̀b�}�4����q$2{QK*����(p4���D��B$P�i�㋰1�aHy��?<^o.���ph�DP�T5�����ӣn{���a�l�����`{�?�����҆#���B$l�*G�yh�
Fw������WG���dVp�9�t�0�1��F�yU+��pT��w%�m~VR+v0Q���F�#2��[L�!=M(2�:� �_��O�>�=w�Ufk�~T��"��[��3������4�[���� ���s��-�O�M���ܷE?��h�׶�f���T�����0	I^���(����E�@ �*��Ӳ���y�	Gi�!d�e �$�G�Y�񲍯Lt@�`AF������)Vt��������F�Z�(�L3�f��/:P�2��:| zz�?|�TQw�\�y�ot��0; mx0�si�e�"҉�}V3��ߡZ��n�0jVjQ�N�aD��H�yƧ뛛��_§�3�;�!5��r��0z�Q�5���A���l���J3�ӫ5 ���Q�Нb	���GID��$ʑ0ͤ	lf������i��4 <�U�M ��aZ�c����n7�Ԛ�K���#��1�-�4������j}��xI�)���@���+�D^1�2(5朆�3��lyǑ�I�Z��.+$��V��6_ÒD��FR~(��eޗ+�3�D����X��5�7֠"1����Ar�	��Z$�1��*���gY�=1!ܷ=|X?��H�K�)�!�F*��S[V����1��!���|ͼk90�е�HY������>5i8��ue��i`�W��L)6|����Jgh��ժ�����FWZ����x⌕{�{�"p{�i��B�46q �)���<"����Zv���R�'�(�@��Pe����>U$�q�U�U�V�D�ڛg/O���I4l�g��S����֧b{٭�V�ґ=�+��-�`�FT�U�K�%����-�
�g�ҍ�[.z�`��ks_Ą����R�i�K�.���x'�^���ъ�a��<{��5]w!V��n���|���i#S�^ʞ���,Є� A��Og{��7F��B�3�#~��������f]�D�Հu����\_���z���MD��W-<�X���2�TO�`�c��8?�
�M<XXUJ�(��á��hl�~M<¤�͸-���k��\��G�F� b�S[8\�o��w�M&�h�r;��K���k�O-���p2M��N��CN����ء�O��.�ߠ�T�?F������4K?��v1F3�%C�
ȏP�.�B��H���]�]��	�Bq�(�LHv`�@;�~�ÜM�nN˫ju�m!L:���q��v�q�"���J���{����.b
**MF�
"ؑ�W���Q8��VE��Xf�pE�"F��-��1�(���k�yI�(�gY�$e, �  �Y=h��}��KD�;?�
C!&b4xyv���n?]��-���=L��K4#�K�2m�z��m"D	�����b��oh�ڥ{
L��ے4j�G�o-��}+SoH�*��hc�2� ��a�uz;I��\�����̋��y(^v�����4 bs%��:�oh.^�vsV.q89�T=t����e�C3���~'�8��z��dMrZ�f�$����q�rC#��k�����%&T Qk�k`ڵ��\G�������8%�tpɷA��|�q$����l����)�?��<5�s�0x�*����������p�̪Ô��D��ȐE� �[�+`�-�P���;�&ر�]��>$(F�1�I�z;2����HZAQ����L�'"�tif0���k�M�tV��tk4\:�1v�� �,=�������ت���U��1Wt��I�F��p0[)o�P�z�����Pl��b�R:��VCO���
�����C���a��Q�=.�\	CO�����'w{bg�ع�u�_�]���6zf�Lvw��J��y� �N7�D	�Bp�8�����j��ݵ��;AP�P����ԡQ��W��[k�6.�J��r�b�{zq�^/��v���:��i��� ��*��w�J4j��$XdG+���t7���j3�����,���.�I�ƅ�-�P���\u�����gl��/���w��%��Wy�T�#���X8���M*�ß�����~Ϳ���_���?��>���'Ъ/��?���?�o�������_�������~�����?�����:'�� �j�"�~I@�o~���Vm���ҍ=�%=U������C����K�*����=Ц)<0����&Y��s�=rg�pC���> /�{�T�f|��[��P��C�S�fv@{���<7@X�/y�&uT#���Ji�ԏJ�gG,^��J��X�fzC i�Ÿ+��͗�g�HRyДJ1m���M��}O�3���c�?bV�$�����견����RS��2����/���.M_�ҋk��5�����)6L�9{�l\���T��'�,�~�]p4�?���O֛U������<df1&�֮O�F�t��q��j�Dd�^]��=�۩�iuO\#U���jk��&�D�=~qY�����p�~��)rb�)�p}�4l����n;~���#y�E��֟�䷈��b��ۣ���m;
��k��^�W����'M`�J�Zz���+H�6^�9&�z�#Fq2�(
s8��CYU�[�9f��9���oz<����s���[h��4�O~�v	$O���ѓ��OO��×�_?�O��x��5 ����ϗ���:H�
�cYS����2'��A�X/�����r�0����x��Af�7�4���J���=?K4�{+��>5A���$�2L~V�(mj���>;[�f����{�-ß�*8?4Nw\|A�@���9��kK�؅H�kB��_
zЏ���t@Y�:Ysa5�+��S{���ַQ�5�{���p-� �L���'@�e�i�q���޼�]P�M��5P�*�wY(G}���ȩ"2|]���D9��WVj�TO���ӭ�˸[������U��፣[�k�0r�lE���O>��W�2FeĮ��_�����ß������G8}VT@9xu�utI�(�b��ү�Hm��{�"`s;���������f��vWܜ�ow}Z%�_��<�[ꠒT�8�#���D�����M��~\on�D���������	`���3EO��yФ�a����` ��{�=����J��`Z�Θ�e	�I#o�c�&�_��Q����4�﵍���7Z�aB;b�8�5s�A)�c�X��B� �����`}ӌ?*���߸�$�\�?�L&�����P|�:GJ�ϋ������o=]F��ZfE�e/[�GDT���xg�䛟^WW妛Ƴ��s�\L����l��_X{      �   �   x��н
�0�ṹ�.�I�g���K��"ȱ�6h��D�^���q>���OF�r�i�i3��,�������ܩPp������Ir2��:c}�u�r�	�n�T��pŌ@�i��Hi�dH,8�"��*c��k+�U�!b�m��]{�icg�}JZ}}K��<t�7#\6��hD����f&:��ȵf      �   \  x��Y�n�8}V�B?`��K߲i���&���X��c%"K�d#M�~gH�N�R��&5���hfΐ�#���]�S�ۏBT��%�����M�Γ�p�1|��a�uOÏ�?���{,�b�Ey\ݗ��w͊n�^��=�}��PG��G������B)3�
f�Ⱦ���+��$9�L����\�����r>�*y��"c�`JY^*d$�`d����ɯ�����/����u��4���D&i�La�����ɚ�C�w�7x�ε�M}x�֕�. ����a�P����|s���`pZh�m|� K���Lo\�.�!���_ȓB2fK��|U��)�{ӟ�;�ǟ�<��c�";�,1J0�K=I�Q�ȴW��_���]�{3���t  �\y�J$ÜO��1cŴǣ�Y}=e�/.�q?=R���Ș*(�"��HCX�;]sW�$�L�ók�8�(�Hz&
b�E�k�8�$�C�G�	"��-��� !>9� V�,S�2��i���r�<��������a��索1��N�B0}sdѮ���
�n]=�m�ȡ]��q�@Z.г�j32��5&���M�u}�m�n���2&e�Q%ؘD4Ƀ'��M������G(/���y��)� �ćf�V�zń�,Qt��?�u� �\q�_Xi=KK���&rG(�R�����|�쌂�C>!
j�2��K!O���(%K�D0}�=V� <?�`�����1���	5�L���������,�̏L��MT���\b��,�c;H�d-e��L�������wGEB�F�;����,�H��4{4]�m�����S�\��n7e3 T[=�0Dd�V��h����I"c��J�&����z��;�4�K� X �aѽLX��!d����T-Eכ������|���f�^B����H��%#�i�R�L�E4As��w���I�Q\��܏��1���ä��b�(\�h*Sn��O��+w��%�� ����(6\�K"4������(�b�"¦�5��1�>7�ۺ}qY��B��P�l��h5�"�(�*���vU��冪,!��w�U��"Z��7W���OP�OupZ�8�	Ӻ,w��޺�i"��I� �oy�'�	VRr�pv0A��u��{�'p͂�D��#V���L�1͵>H�r(zѲ���R� #����0��nRR}:r��B���K&<���e�ZWe�T�O�CLE��K�F1��o1�bc��	UT\']�M�#���vq����C�vDa��̱u��#֌Ҙ8|��j�H�`�+��<���ź-�7��|���ï2b�DR馱�_2���=�q����Q��\*(Z:��vA(U�u$�B�tӹᐿǉ^�x�{��=�sX&��gbܖ��D���Eӗ�Յa.�G���ĉ�5�exTF�^�����k	�����Y�n'�HL)N���1]+�铫��]*��b���ةK�r���z�2�Sm"�����}ǹ��nO��0�d \RhBn>(V���#9��D�	~�,��k^�[Ȥ�d�P���x��}��&����phu��>x~bc-|�6�|/��������      �      x��}[�G��s�W$��}q'�~�'6)��ER\6��Y, dwgwXU�[UMN�����ف�������`<���4�����Y��My��PŮS�'�\�s�gG�	y�~ܜp{"Mi���I3��g��D��9ɹ>���G��m񲮮o���Yo7ŋՇz�]֫��E���Vwǋ���G�
.ՑQ���yV(�"���_��e��I��ޔ�8弛��_|Y/�����,�uY�7�j�����^�x(}�f֬�t�k��^I�|ٜ�����y��d��p/���	/�����1�W'R�p��j@r'X�J&��xxu�~��ֿz��E�cBJy�#X\6��zq�,�]��#re3x�q[�ӑA!�햼`����Je�f��n8d'J�Y*��������ŧ�~���?���}���?�?���~�_��_�ێ�q���b'�VJ�-��L<X���)䬾�.cL1����{G�˒n.�@��zg�!I�K�������(P�v���D��J�^,%	�"�����o���$J�9�PP2��U�~�`=g�fS�J��t%��B�glgF�zrXS�/�'q'Җ����$!f'�a��aM�}6dsI���6cl��~6�o�Kc�3�n�>�񂹬�gx�G��Z�h���c�
�O8/��q٩�>�4J�P�R(�XP��^����ٷo��/�=M������s���xS���mq��qX>�*��t����C}լ�\��T'7�J�3:ёϽ��� �|��7�eY�N`����L�J0`�~�~�֖���	AZ��䉆�
���og�z�`u�6J�)U�v����fM�o����
�jO�#�76�'$iO�)����N���~%��Z���X�������Ѭ�f�(�Dx!rftG��m� ����J��T�H�`v͓�wn�p��3�Nc*����C<v�?i
vڞ19��H�0'��Z+�do
�{�vO�T�{pj?}����Eg��gzQ<�
���f�>B�?����`��/�<���Wޡe��w��9���(h�;iH�4R8邌_������x֬�W�z;��)v9q�9���ztS��S� �lfy�\������V��B�N�,��ք$Չ3NI��o������x\'��L�����k8��ZT�6��/��{�ɹaB?<�u�~0G��[��qeL��g�77�y�.~��skx������6-i�j�~e�vG|���0Kp;�|��^��,l}]<_7�7C���6 G�{%�ؗ��%���/Ebà(Zw�7�O� ��Üƅ\����U�����1�\K���5��q���Bo��[��u�����َ�})񀌱��Ѥ�ޤ�8��Sz��>���Jy��A��n ��j'f�y�A7Fa�p��S��Ж�O�Dg�s���9�i����� <���2��|�,�/��Öp`��>N	f��2�#n�����x����*���>���O�{�|�����i�����|~O�j����'uB�r�=g@��c��兆q�hڛ��38�ɚ(�,lG�v΄�E��(Izĥ���G�B���a�`1���նޱO�$�9y<�k���ǖm|���W(X�Xܞ�em}r��#G�M�}8̄-�1nȡ�>uI���_�.f�j��Zu��^�$b��Uu]�����YX�1=9�=!
��F
`k��>"�$O	���@���^��N/.�ۃ�x�Z��2�����r�'̉��9i3L�严��R�MR�@˙�@;�
�=�-N�o�e����Tw������ ���z��	<�+2aGP�c(�17��������u�1~�=}qb)<�����0#|�����6~�p3����B<�`K	0o��?�V�v~Q�����Z_��M���Yu>\wD�ʅp����4�e�P/�XI1�0�u��R��0��4���}����Ƞ��l�4��`iN�����>!A9)�i{��Y|��",�x=4����?4���ΛɸY�Hcs��#G9�G3ܿT����AHi�Q�Xe�D��g�(�Č�<�<�Q7|��5����n��񺆌<jn��ۨ �5�B�T�`�A���L��I��II_j��I�N�5���#C���z~^O	x&,�#ɱ�G���x���T�p��P����U*sn0��a>X R�	���hHQ��Zv�v� ?xd~"X)��m�;����Y]n�3�Yܳ�Y�,��$<�K9&-�G� 3�`)�&~����l�W�8�{���[F�r'�����@ ��u�Ic%�@e���`�������M��.f�����ebD09���3Ab��8�"#�V����;!��XX����F#hq��I0� ÔD� � ~F$Bc,�~���w~8��t�<=��A�2b/v�(�}UQ�`���7"N߱+P��̵���񷏿=+�����O�:��W��O��x�y��u�BgG�)��/��'+q�?6nt�~��(�/f��BA �Yޛ[��:���Q�o�����_�|��<���<��f~��&Y �'��#&� �F?�<�|��ףb��NY��w�k��i֘�V¼�Rq�Dߥ,DH!2�#�!����6�����E���)@P{5�`N	�Rx�� 𤐈��ª�B}�8d����@tIр*N��Q��A�e���������u}���ͬZ/'��N����;r�Cj�p*����)6
5��jg�d�~����_�̗�w���ȁ#e��%x0��4c$^*����`�Ϭ6I�-(^�P4��$;p�؊Q��P�����g ��b֬7i )'�2��c��l]�� �5���K�=,P6}ْc
Zt�0E��%��
{<�?�bk���:<f�7#S���9fr�	���J��~���*�s9�9�̯�L�[�:ɉ
�N�"��&�rQ��DԓO����?|�����O����]�������5�|�K��w���S�����?��_x�)8x=����<o��5\�]@�6���+�&��9.��ͺ
�;E�	e����M�J���q�v6���)�#�HF1I,��pY0a�u�O�(K P�2%9� Ocs �j�|��\/9*�"^z)S�����D*.$�ˮ�� 9\'ܓ_���b�כ�\ìK��V�G��̶~��/F#5(5w"����f|oCC�D�q��6!IN�N�X���v]/�Lf�:�<b���XO&H�|��Λ�fk��w�E#;r��^�YLJ�J�J�3��	�p��.ϯ��a��T�� �fpÞ���47��8�_�U�z"�d4��l��:L����}v�Q����?$q]R�.���Ͳ�Ŧ:�K(��=�ݭ��/���u���Ya�+n��O��"�61��� ��׀uO^�D*�qd�w3� �R���z�	N	�l�#��Ӕݡ�73�&*�ȒS+H�]�T�ŶYo��⬮=�į�}W(l�v�'(�fk���u\�oD��I���J���k����Pr ����7JPo�>K�(_���o�;��8}��˧�^<91ڛ�����Oޝ�`�髧��%��i	��h�=�#z	�k#�(��G��#pӬ�'7!&p��QD�@<��4U���.�A/CF<�Pp8����O�~jS�� R����(��t���?'�m4�|G�[����@??۰zXW��6���M�Ԅ5�V3����q!����j��rΌ���ya��
u��\ͯgT��^#��V���Z8k��~կ��~`E���D�B#M�R��'U��_m�`��R)����FR��N�W��+�ܵj�w��Q��ه��PNG�!�Ͱ��~����LlTP����.���MuQ7��n�����NL�E��d:|��9�k=[V��j=��@�(�{(|�����&��E,G��;B�)�u��b�kǼ��z���ݤ�8Lk5@��F(����pVݮ�!�Y����޵1f"��h�raPG�<    �zC���Ag�[3!��R�v��H��f���9��u~dY0��zTK?H���8O���<�˦(�x!�t�M	m. ��nn7u��njʱ�/Qmh���Y�.�1�m4Ț�o��./��n ���<�\[د�}��Q��:E��Z�u=���DY��`���
*��߅7~��|�������O�ȉ=w�H�u�^�ö�.����U��v����Xmr� {BA�ϝ��0�w�]��UL*F��}R����]�1�@y+9_5���|U�ݞ$����H�� hJ�YJ�37����]
Ϛ�10��5�Iew��l�֒�B<����WG�r�M�d���,ϫmq-���Y��0�Hq7��5�-.�qèA��95�Ͳ�������)u��'�Qu�SG��.<�R~z�F�YҔts1�(�7��U�}E%����uP�� �>6�`�Q�;6��&�pM���M� A(�璷=9��z��=�T��X�}����&�!E��]sS<�g'l�	��W=�g����H\�z���)�Zٮ�]���nԊSj�����*�$�Y���wo����kj�f�I(�zm\�#�n>^�Sxg�b2W�f��P�ÍԂ!�_�J�;5����.G�N�wmA:�j�sڻ��L 5�-c@��g*hӋo�\��q���8�/F6Ɲ��V������g��e�"�bs�����8cj-ς���CU���UX� ��gx�Ԫ���:rL��Ꝝ�2��
~M#Hc�B=�MQ~���D�f��Y�-�.	(}l왱"�2m�۳�i��w���*��}��+
"[u�aK,U��; 8x5��' 
f'�R��ô .�3�_Ç����w����l�����˝�"a��팶L��4y�w�H=QA��)��v�f"��I?�0E�lV�UVLx%��W�%Cc��΂uu.�RQ�bA�ٷ̂���TY��=��O�U�����v��cLo�KM�N3l���۪=�7ܚNv*�ã96�����;GMlA,Ոz�eȻ���<��7��4IbSNT��A�§����O?��0��gmRG�[�:��A%x	�*�_Jr!��%�_���f�#�e��`qG���x�;2π�E�O�%5�X�ȑa;�Jӹ:�q�t�e�J�"�X���=��/�q����ٞW���r�<" �=9�j'��ٔ�@�kmw*N�S�#�,�!��fuѬ/�"HZ"�~J`�#�9�f���O�����)�˞��ȱ5���O�Y=%b���K]{��io��N����PI;`���_����$<�=9���F��+�l�^�ꧾu�q(�t:.�y{���$��|t^����9Y5�1�0��u�m6����eމ � ���9����0)�����R!��p!� Z^����<C�a��6��>����ZV��Ca�K �sYƎ7�%� �di�����$� ,���[(�p��/��0���+��ׂ8��¨l3��� ��JO'��Φ�;�$uf�,Ϋ�M�3G�� ��aǊ�c��c�].�Y���EI��c��Rߨ�Va:rkz���PM�P+U�MP�2n��a�^�A�F,M;a�&����暀:rܷ=�Ӂ	�o�8�%VH�*�d�����]^%���Մ���T��NGJ��*��<I�z~WnZ�C��)0�2�u���q���ݮj�%'��<��4o�_x�nF}�R�aú�y`7aH�Ͷ���WoSc�ł2c��O��ݒO�ɰ|G��l^/��G�@#���Ú�}��40:$ H�ݶ9��wZ8�����`i�p idExGЙ>޳����J�����v��m�~
��eY��#G��{�d!���@���ٽt�UU,��2�Z������}Y&PuõC����X���z��dG��Eﻅ(����K.S�C�&��!��~�>��U������	Bb��@U�����lkyQ�����#})^95�$5tK�l��W�O����B��B���B�_�3��݌{I��^#�NdS�)癚��"'�zp#C� ;)����;R��r.��	������:�saZ��*�Z:�2.��)�"��.	Bfr@�#�-	j���'U�/Y8�D�cD��۷_�xR<y���d+����E��>X��ph�V��c=�BP��T��gtjײ8h��F��pa�5i\����W��{�⛧��_�J��Q�g��	t0*��,�ݼ�UK��-�jh�/�\�d���EFr���$SS9�*�����p܂���ҶM�L
-�ڮ�B��Po&]�g��Ԅ佧>w�i!����W���涋���<Fssx�=C�_;J�,y����钽��2~w��*�2ٮƖS�}CU�E(�����I�I	�������,.��A1�(���&�j:vC׮Y��wL97�|�f��u��	?���L.��<�+�.p�*�1E_r�!�`*2�,���~�����MZtv`�8���>G:z�%����V�1��sH�#@ݥ>m����jֲ%��c{}\�M�R�)0�i����l~��	��ju]j �����
�F�W�85�{��t�
�[�E5�yj���9g�v��� �aT�c���Y�_!�L�� �;�������8M��u:��P��~�M�.#��a�7��7[�ܑ��������gSo�~��o0�"&_>��!����[�5 ��ԡ�_Vʰ�h���(=l���S�#��9��x�����v���ٻ��������_�~�[��(���{���2�)҃���d���q�x1%d���>e3��@����丮�gH�n�����$�rH�4�����j<�>��G�z��.�q��Epՙ��p��1{Wێ5�Ϗ�[or�өM&z+!۬]Ydd[�|�P���
E^d�S�`�r��#N=� O����������z�9��:�W���
�R�-ry�9��>�N枮!=��\�o/�����}���*���F6��>�CFg�z]m|�.�G	��Oߑ�pX�wbʩ�n���O�I�w^�;���&��$��f�H46��e*|����Y�yw�6���
׬��1��2!E��������`�I�^���h�)��7p�H��R	�7����3�ЉZ��I���^��;�)�mj�-5��}���ZG�Z�vK�b,��'�v�� 0"�1T<9�1A�؇��A=�屯hF�{���Av�%�R��PRG��j���{������I���2����Vs<Ќ�t�\9�ݑ[a�(����Ě��q�g:�M�IAb�}�u�zU��<	���|љ݊h�Ы�}�٣�;r��}�H�pᅢ�n��\$�	7|�؜��"�p��~|'��K.��$Q��{zrˤX`N�]�K��X��b�Ex��.��zNw���ti��M�&��Nt�(&��r�����@'^R�{ �a���t8
�Km��)�7�z9��uq��-���5c4��Ç���0��N]�U�:ۯ�#����Q�f"��r>e4�eK�NN}�t��f�iX8c�x��J�/�|<ˁ�4�K�貳��+�;A��zf/�Ù��������>����ͲZM/	W�V���E�۳M��ե�J�_hb�NtkO؛�u�b2��뱒5@�������"�b��˞ܚ��?� ��--�V��B
�+�����V�l2ar������<�@��� ����Ng�4t(�w��v��-�_��_�@���_�|�pķ��%�]�sh48��I�:P��x�k��IL�rɭ�}�
WȃzĢr�uw�Ā�4ߋ���+�>Oհ�@��p�����="$Rs���V�@Å�A�a�ۄD{�K���U���IU�3��w7����Li!c\�//ޑ[)�k¶׫*�_2p)���~��������oՏU��ŝ�~��>��7D��:�PF��aw�ϡIQup�6ڲ=�o�b+��]���g�E�cO��,C�w��=طF�k�Mu�ȭ��a"��4�Ú�D|Fw��[� �  ޼;m}��hMl�<oY���}��]�BOn\�/[��'�p}�,��\��9]��S��7�uz엦}P+����muUqo���$�k�BOn����%�����bW#��= �^e�U��lRA��v�0���,�㉤>dp��ё[�ľV�!IM��=SR�]�n����tM���������b}0��7iV���E�F�U���3N�k(A��Iv��i���y���n�rN��D�0w�טg��\3��O�v;:�0�oL�?"������ �e��E<�RX)�Hk��X�\Q��ݺZm������1s:x����zYU����R=Թ|CTKn�����B]ͭ���(��Mw��Yu�|�p����@�!f�,��3٫�:r����/�����      �      x��\Kw�F�]7~��c����HJ�(>���|����I@	k�_?�-�3�J�m���f��]u�VuC��]?���~u��3��z��0K��=h��n���t֕ިY�����\7z6��:��V�{�!
���yi���B��XT%�,ԇ 	���r��K8;=4l�'X��>�Y�ps�?y�F�{а=�}��<������4p���!c�̬Շ0p��~����C�עy�埴a߰aY�����4{t�LO������RG�I�5�w�B�î���¬|/p<��x~��XO����&9�?A�{�T�>���燾�I���Lx�Vg�l����^�����A�D>��¬]Vjt��K�Nª�I �S�m�4���I�x�b���ļ�Xh���Ao��^�`+M]��<B/lu�H�;�5}d��W#"7{ݴ����~ =8�B�A0�+ۣ]�v���0�|�+�k�Fp����w�0r�Xx@�@n��;D��9>��a���m]��X����4t|�GAo�A��9�[�F`]/񂼃#o��rw�h�R:�ɿ#���;r���#,4��R�m��r.�J�Y��A��}�Nd�(��d%��hT��3"�ۢy-v�J_�!�$M�"/�"�Ш>�^4Y����^����5��<�%T��0�(�w#���*����I4BaI,�dϻj�i,,k���\���i�-u5��)��u����EM�7�%Q�Xh�v���hBY s��X���wl��F�j5���ü�ĚH�"�Z��Ma&J�@p�$J�C���Tc��9 ����&i$>�@�T4u]�1��0#a- �W6�����=G 
ZMa�,4����h��?�|R�����{MZh�/G�ԛ:�!	�K��O짞˯���P�r���7��s�t(7jL>�'�������z��Wd%rB��cd0a�2ޗ�$O;!��q覙�7+��1�;��y`)aS2�7����ګ��F���#�i�	y�B��P���c"��	�m�������n -f��q愼��䧰a4�7�i�ˬ@J�v��l<��TX��O�@�и�v�O��|GȒq�ŉ4s3�}1�*���A������78�#�C9�a��A(ę��u����aRL]��JE���5J��=	�1%-7v"> ��Mih�q�<���G]6�\?r�j-��j��[h��XG�n�)�Ð4:��k���d�d)�9�}6'
��B��b���� ,C�u"�Œ�W�W]�Q7��6D)dE~_�S�<F�N$<1�y�!W�Ou{.��\���t�Q)�tUˊ��ti1��Iʯ���L�D�W`$/3'�Wn�g��M�r�Q�c���ޞ"5�
]�.�guM��:��L?�V� �P����L(��Äx7OA2�2�)������ļ��a�
Tf��ZAX"�Nڲ���oDXxE���D���>�kj\S5�B\p�4Ab��B��}Y?��59)�R�����ч�?�R�,�Hŧ����Wx�4�$��ntS=Cߐ��RG��!�i�:���T7w$�3G ������ݔ��7Ӯi��n�!5	�B7��6��!R����)��B7MQ�L�cTwMn(CGH���7�B�ܪ>\��Y�Pb�A�g��
m;M�T�dH��9B'-�����&�(�	) ��|Y��ܷФ����b���š'���d�E]�x�����![:�Ф)
���� ��y7�6��Ф|��?�FM�g�7}{lz�!�Q��9�\検�c�籭�7�Lq5���
�n6M��[���do���*�ԋb���	RVq��g���"�uRaU���f�l�䁺O�礜_clg���&m�T��&H�a��nFǬ��P�e~���nՄ0�B�p2�I���C��b��+-��A�
��Ao�oIq�ד#J�vpa���Q`jMy�w�?Ƨn��G=t�K�[c&s2޷=�����G���He
�ո<_�.�?�#�ҐhX�Q�
Qh�ۺڶ�>��%M4t2��=,+V{�v���ng�u�wz�\~�,d�^j�A�=F34d�Zݶ�N7u��	b'�w��fRM7���iN������w�)2�G�3��Um���DM�I{�CM���l�St�"�]a��.�N��1v����tb�icߛ� j�ǌ���E���RS�R�4�s�H�ؔM�=�����`�+5]��,L��\V�����5Et�Hc]���C�S����Ω�Ð���-���GMe��a)�6��6�Ӑ��Н~�
�!���n�c��#[�^��qwmWZ��g��͖�����H�| �^�����7G�3��I[�ogi,І�fEu�jvM�	���7�b�U�C��)���j6%�mc�e����<�ЬFE���Ԫ����� 3L�hw��<��6��ֹC�չܵ��)���pB'�q�H�-H���6zh^>�3�9յ�O�[aH��o[�(Nj�H~�7e�����M�D��E}��?�Z�s���I�ئN-�g}P�;���"�� ̄�b�eݜ�d���
���\����۲dI$���V��P>?C��
J6��:��T�3�/ڪD]uO�B�+Ș����z(��`]�q���6%�qN��/$�42������h.��T�Cs�B����ٚ���b[T*'��a����K�g�=���j��: �Öw�	�$=�P��b;6�ip},A	��!Փ	�f�0�=�E��l�M{n!�����ʞ�"��H(.:���$���y�FU���#�{��P�YhX��� I>��_�; �p}W�A����R���D0�Jwj���I�.�����f.�ӹ(+5�R��'�aD��ZP���O"d�v�{��C�S��4��
����*-��+���bL
�c0:�B��,��S
��{s�FP�i�,�Ў6�t�	�6��u=)�X��G}x;�Q�{�m��W��	��`�E_�,b�-��i&H�4h�
A���v��c���B���eS��\ҋ	-:���r]V��mq(*����#C>Y7���J�m�)S'%C6Z)���A�`���F��	�K����v�ݖ�(mI]�-����P^T�� 7����O,��PhY�#���\}�Nfk���hF�,����ss|Iנ�Y%Q̶�{()ϯ]��1��n.�w����BJ3Ⱥ����Uk:��,b4ހe���U�Vo;�����V�5UN��>{)����Gٔ;+�ݶ>��Ȕ>>+��P� `�ZY{�WsRt�����IL��ރ�u��o�t��
b�N��o�����Dj�aA�J]N��]����[�<!b����А2����D�]��	���5W[�7IF�b��ꐅ�[s
���iv�,<�"d	A��]�|R��p&�F){��C�6�ټ�*-ƄL&��U�2�8�Az�Ni5�����V�Тn�	�/���=�z%�)��Z=H�R�2�n�4~���KzhY���`wwIRR*儹$���Y��,�yA1 ������ s,��߻�V�7���L�0`���Ъ6T�B�1#A'T��`�jԖ��hP��#���B]���sWw,��I͖����BT'Y���B��y�������,h�4�"�����!���>/�CB��%�f���l�W�c�1���Щ�|_�Yu����D�d�I&)����I�t��>��Rn�=SM��l�4=�Gz��/�����VH���%�Y�-�$*<����������gK7��0�����mUR�|M
Σ����G�����кm�ӷ5�Ĉ�{�D6���{�C��ZT�t��?1����G]��ܪG��&�%A^�v2�Z{�[y|�O/��f�^��d�nPr���4��I͇�Ȅ �<���y����T��N��'��*�J��B��AH�g˿�B-~�5Ǽ���3��B�WOE��Z���q!�� �������]y�   �cB�3���Zi��/������I�������ڢ9�t�V+��%��`,K��B�w[�7oe��i���CyIk?�uU�� HB� �T8ݴP�L�]Sj@E ���N"S���1����F(r�K,��MqQk:+=K���0�O�����'{i��/���f�fwy��g&d��ZhN�������5d�gb�	v�D���r�Bt?��1��Q��BR�Т~�̐}�GRC�أo�ރ���vW�)�X�OB�C�'�B4'⭟��8��ٴ�e)�S���BB��	��~�t��7�$��G�҂X��Efw���<Ԑ�ZoB���aP���A���P���4t$u<�7�`����)�Ci�)�Bk]�R��q`;?���@�6ބ	�)��E����CD��뒮޿	�5���?lN$�S�h�GԆ��$���`̜X�ǋ�#�#5*�B���K߇������#��P�p#��df1��T#R\lӅX"�Σ-�(7Mw�����t���1�z\�,��Ǭ�-��Ph�Zh��%U K���\�-�o��6в�>^�}瀴�T�F��.Z��VH~�;V+
/�\T����ep��4�}}4�O�q�U����4�P�'�e�)��b��h@MQ����*�
�h��P�@q�UN��M�W
Q&��,���,�`(�t#K�,��4�z���{]-��fI	�D�K�Z�?��U�G�Tc�dAȊ�z,QR���-�/գ�V@{������j�y�+d���
G�>.�R�qb����>!���.�`|&D��ſH�.~�nRӌ��ؖ�Y-�RZ��������\�悅�%�ɒJ��IP�]���!�N�\������>��x����"̉�鮊p+3u=�3�����ӛaBa![�,�ӗr��=�#Zr:e�(pr�P�BS ����A�R��XNZ�Ǻ�u-W���fFG$R�!�'�ag������6�L���?��cY��Z���=ϧ� F�I��@x����՜�Xt�ƞӘJ��:����R�>Jw���Od�����R���_������B�e��E��ajAm8�p).6��=Ȥn��7>u�	�Db3��V��t=$eMg�R�8����oO��� ���"UX 庻�T�*7y�Ծ�q Q��(+�?b��gTK��T��ɑ��tӝ$ޙ)^�Н9����e.�%�uMG�|>8��W&Ty�ꡇ���L
�`�f��R�/�Y=�C���>��#ݨ	�����8����	      �      x��\ْ�F�}��"GZ"X�$�~*��(lK.���$�$Ӆ�X��;:��0O�:01��/�{o&�H�K-�=�Q�BV��{�Kb1sm׻p��c��r���Y��� ���G��	W�ky�����7�u[md�e/�FT�H$o{^�U-���J����f�ڊI�ŭ�j�Z˚%���\$lST����j��l���i%xr��Y��Zq�[�����9��,-�[�)X�okvBV���iZ�/w���]�Rq'R�����'�Mw"-Yݴ��|틒e�;���LĻ\�Ԋz��6�1^��qm��y2g?�Y	?�i����i"{X]m�����ao����L�+E%�%�ڸ)���aM���;�.��"��Z��w8�"Y���$��ݒp�0h[U2n�6�����l]4;����1O�����)5��;�mv)�� \�z�0��yS�ڃ�oDs��7E\�j�Z�S��a�i�$	��(ˢj�\B�$=��I�sv�a�U��	$��4�MUdl���;Q�rP���W9�{|�ҧ��KP/���ous���֍�O/ ��qQ��k�3ϝ9�w��ˊ�e<��z7�
������ﳷ/g��//?���+����ς��:�*�(�C?��l��Bk�:g����t��UU����H;�*6Q�G����+���)��N*�&�(/�S1��X�yjiT#5�%-=�3���ՠ��_���4�gG8��!����a�t�����	b�_���ȅ�_�a���;��4�o��d�~4����n�7{�e8�ۼا"يG'����fN���+׵�ȱÅ>���2g��DV����^�"�by%a�f7���=��Q�5�3�X��#����-�'��ѕh�6��^��.a���zr��7�`�9�����q�h27\َ��:�oy3��2%�,�h�� ��!Cy`-a8��FV�Zf��aġ3ƣE9a�os�~�p$��eH��� �v�������I�j�L?������f�[|�F���}�QC*8[�b,�����[\a"+#t��:�{�=�ų1,�s�cv�}h�ؗg�.�߿�@�w�!>JD�n�������n�ۯZ��	�{�l��Z?|�'4��q����=�G��ӵ �2ڇ�U֎��H���S���kPp�Z�����^�x�[�B���@5{�+v�z_@O� 4t	��@�>���f�|uc�b��ߋK�����+�[y�a��:~�p0���D�ҵ���F6�Nl��"��6�7��I򇗗��߿��0��hXȕ��"���	��eG�Х���/��{��h��Y0����4xa8}��^��{�%XI<H5��q��"�y�<����0�+��+t����P�^y����KzF�Xj�g0��"�=��y�H��O�f#*�0�������OD���vD�p `)o�x7��"���X�k��n:ƨ�_m37����YY�a]?�ɟ�B&`� 
tV6-'h!�u-��쫢���h�T��+N����ݣ�h�+@��PX%�	�߃�K�{ 6�K�]�6�zk�nsM@i�78s0���)� �BC�_��ź�S�{�.sp�p���,�[� &�x���)P��w�-v�6��``ܓ���މ�XR�&��(C���Eu�!���]�^����T�L� �v�U��Ĕv%��3'<W�6���7�K���3bI[�\>���S|橻��ϳ��)[?��:���~�D֏��b-�s���Xّ����f�Nj��q��'���2fݯ����'��Z;nD^���1N�����J��y ��{]q��!8���sp���;ـϘ���3%	 �����bvEbX�C'�ӖM��5x�������kQ�׍()���߶%�1��\a$�p�����	�`��O�J�h���?�O�,3��G�c�D���XR�*�w2��Dǉ��!���
�l���?��L]�'Фz)�z6m۔7��޿ޏ	�V���n8�9��"��������\ݙ����H�� ��a��<?�D3�p���9X� ���������B?�q�1<���C4	i�KP�(0P�Q�V�tM��-�ab�&e�*�Y� �d@x���=����t��H3�O�X����P#s]N$�]���� w�s�3m��lP$�C���w[��r���4�J+�&���z��t��e�F�h�E"���%��ҟx���
|+���ht'|H���κw7o����{����$�b�1�>�c^��b����ǎ���sj_�H{�?�#��̿�Z�����8����ϩ|N��˙�#D�a����A���L
Xⴠ�O�G8���"xwᆶ7�g� >�HOÇ�G��Q���T�Ꟈ�c�x1��n0[3<yp��;[g^	 �D��)f,mh��
��`��`+������_bЮI����i��+�?;�7��V�G窱�id��e����}�!��}��9<;�g �:��۞���$N�n�`A8�
����>�����,@٭h�t#o�Vv�
�s��vg=�S��b�],�q�R�9� q��(�UGw�O�H�xW����"CFWv���<���v�q?���Jq��Y���ѥ���M\n�]��ދc�FAO�tH�<��ۂ��q-B��%ޠY��u]Ę�5Ǩĝ�Ze"����3��ą�:�_��Pa1l#H�W�5�wrKo��ĜyE�t��R��"�P��d�t�r5�}A�5s��Yp.��%p��8�r�lS2�5����}8-��i��g�a��qy^�S��9�.�!�=
e�֭L�(��oi���6��E��%�o��IO�g�����fߝ_FЀ
��]�{��z��7й�!��Ou�^�0h
O�����U�`���L��dug���K<k�َ�L�f�C��-\�~��$�����Y�cu	����y�7��g2g�#��؟ԗ�NG��V�Se�l߇�8��9��U �ŵ\��i���Ď��.g77/tU����.M#��l��F�%Uf��Z�ݤ	��6��G��n0�6���� ʞ��Z�Ul��!���������cx�}�������ǆkV3�u��p9xa�����b$� ��0��{�F!.��w��&�ӳ�B8({\U�XpR�9��gG�_���3��Z\E�&��� N�,�6���vͻ3SoX�E�Q�;	�4% ),EQ���oN�x� 4H�Ⱥ�FG1o��K�搢�޷������`X�H�?��(]�#R���@D��0�8y!0��-�A�D
�`$XϦ[�ku1|j �co0X.�ȏ����::�J�����0�����������0�壅�E�6�$4�1�Ƈ�V�E�&†'���{W��+�����N��T��@�pYp��800��>>|ać焵�F M�����[_�؋���4e�c�|�>]Ee*�1�^������x���S!��ҳ�h����'�O�7�~�a'��{?�O�1�Q{R���e����T +�`_b�5�F��(��iqp�2��{n��@�)�Y�����Q���p"���M�P=��mŁWˌ��V�I����qQ���l�{S�!X�4V�W��<?S�J�*�2#:U�e�kT��ʈ(�a�+�в��|w|�b���+�v��u�G+��Z	w{��>}�BN!��큵oCԍL��3���6O�w�*r��oʣ���"Mq�{N�Cʐ�Bo���S弢�_���H��,��������/b����Z_�e���.��P�_C�l�pC+7��`���%�πk�dN]},�@�A���u�ñ�����ڠ=���6�q<�g���y�?oIw�^�,-�[��	�DN�A~��*xqW ~�/I�/eb�0��4����=C��u�Z��3En�.�]��W�5R���ĘZu��:;MOݩ�Ʊ�E����O =~�z��|�����J�J�C��J8� �  ���"�^�t{��	��t}̻/������O-�	��&�O��D%t�6v�>_A�� Hgג(���R?�)G/�u�õ��y�&��'�5�]�E���\:���=���g"bu��S�@��^a��	^ �I�1��P�˺n5�CD���i�Ԍ�E���/}C�)&�[�׷�??�z�9��9y�m�����Ы�w-6����0����zNU�y�Lʨ�R3����͇֣dg\nn�;8�w;��aՙo9^`��q�s-�wl���P��V�b���'C�G�?8�F�{�h��,�`���v��ZK��̤�� �(���j���c�� �X��0�u*2�ɠX]@�Ǳ$R������)oɊu�t���.�%�9�,����Q��!7���{���S��:-�9�+I94�P�c\"+�$�q�9ӝctsQ�f�*�!d`���VAA�ab�A!��dq�h?u��l���������W��hU.��R03Y���r
�i?���}Ҝ`9Q�m�U��-�ہ��vns1��}���[�x���2���7;#�NϿ��s+�,�pD���������K����{}ľ������ľT����T�}|�nW���3K��w<�>*�&�����nT���H�04�ٜR���4�(��q߳��m;�"mge�����$��]v�)���������!?4�l�k����2u�#�\�Mч	ًM/Km^cA�
�������r����|�p#I fX�z�p�\�����zS
L�����.p��͔�b$��+���|g(������*mA��U|>C���~b�31�n�&�s�	���)=xmF�I�!�

��
管��h�Ɉ~�Tw�hz������H��J�{fϸ"(���2��\��no��`���<XءN�;��w7�<Oyӿ�������K~0�i��m��'��<����ɕT�vϳ���4����̨"H�J�)7�?�R!m�,ӧK_�2t�p��b� O�smE����5b�3�Ś	�Q�L݋��Z��Q^ �<�i��TU��	}63�"�0�]�P�R�6͇�"U ^4��}�7��ɝ���cN��"�)�����71Լ��f� ���J��t�5�/3��@g��Bp#N)$L�׊���_O�W�臱ho(�p"�
+"}��mǍF����'��ߺ������չ�ϧ�|�5Z�)^�4K��6�$v��_���ɽ���QM�Yp�,w�P�'%�N�P`���vŮ���Je���P��/�U��
$^a��SIH����
$�uE�b!Pv�$�_��]Ur3�����	���34$���xY�7�zH���c;�cRt��}7�9[�2nQp`?�?�+*�3���MΜ�G8}AF	~�^huLCvVZL��ٿ���UJ���iVU�T��ķ9})J�y���\H���mQ$:/ط�c	�;�e�D�l�v����e�2��:n�c7�����c�>.p x�Z��_(���X�����QF�x��]^��IU"��DB%�]\l������E�d�$����=����}MSW7��Z����WO�`�^�t��X��Y�V`/���l�冁.��������\�ׅ�}�����DB��^Q��z��+P�u+�M�v{<x%T�T	� ��iK�o�G����B[�Ϊ��HY_��m���EG%�b���r���p���o^�~b4���$�1��j�p�k ����+���]���I�h��~rN�+N�NgȚ;
5��DK�ڋЙ޾u1�b����,�\����(/�u �R	�����ŀ�pE]��,�{��)̊l>�x={x�`�@@t��~t���-w��CuY��H�\��=}�����z�Ծ�u�q�� V�w-���WU�2Ge�T�>�R�}�&9��:�٨\��t���(0/���ݛ�yX����;���\��]�5�� �3��A�B����aD�G��p��d�,Ã�"`.y,�@��X�j��I�]Y/���<�f:m�����n0/oiE���ץ7�V�q�w"pwLشϩ�nv��f��0c��GYæ��Q��D^��ݿ�W:j1aoLr��͏FL�����`|'³3�dD�_�:���iC2��w��>���w� t�3�g������$�� 9: ��䚣�҉ �u���9�g]��ԭ�x�p���Z�}����T6           x���[�G��g~�<���Υ.�8pX��P^:��]y<c��X�$$AP$���o8�/��5��>Xs���˹W����ݘ�e�ߐ�!Y܂��!O~�dw����݊��X}��:P�FI���1��[������n�+�v@qu�51�� �	�g+�[[�&�-���nv��E�l�_�0��#� 0�-�r�&�5�S`���!�$zx<<=����y f� �� MDCqA�q{��l_�n6VhÁZ�<#�bc���rd�����F�@�t;h��Ńl��@4K�_]�/ڷrӚ� ��\d�$g�	��C���nq�q�3�[�(�hW��ۧ�7�^�ܝ���dUk�`M\e���`�J> ������x����vةͫ�Q��F� ��|�ab��\=���p0�$RL�P� �gˬ�O��'p��Ӗ�i#+�
��Xl"3{\��#
8*�3á��]��u����LMd��`�r��}���ݡ�f珘��j�,Ǝ3����ۢ(�p������y���~t�)�m`���,Tx���8ݜ�
�������މ�4���q��jwjo��MR4���X�%�r�=m�!_�Ǟ�Qo:*�TܒD\I�z�-�!����l��� V���x$�f��8s d��ޘ-wvk#b��x+RÍ������U�
b#z���5^-��dg$�4H�1����:�S�����%v�'�A2w�TxA����\
�8<y*���>7t]���`��O󳦳��ps���������QE��xsc�b ��ޚt����:=�s}�(�t<�@�Q�$Y(�&�q�����?���P$M�m~ٞ�]6� D�\�B�Wꨢ�#��..���aC��W���i����m�ƃ�r3�O��2߈�S�������Fcexh�P�}A��d$�P��l���G�̌+���!����%�m�ȒŊh:PH���vI��6��,�Mf$B7!�8�%������}!zq:�NB�)��Um�X�����D��4R��5R����UD[�0���"xr�^��>ܿ�T����˫�ͩ��<�j���\���k^�e;�
�z"�>F�j�2-B��
�L c)�F�|9����w�'F:��
Э����b�<�a�68��}��xͦxm���P�y&�& uZ��l+�5A��lZ3�/�}�&��-�tA����:L,�&d3�5�$J��[��:<x����%�I��u�O"O��G�(jN!ٲ��4y�!Hx[%Eg�p�$�T*�3/7�f�K+�1�����>:_t�4�p����}��Q�T������
��,�]u �@�� 5=.�:f (FiJQ��r��\��X�؆r�f�ZyAR`At�>G(�Pq��� ����E�e�龟�P�G����{^2�zf$����$=2N}4��ܒ�'QF�rxԴ' :#�a�/��}�WC���C�R��ʫ&Q΃�7OCI,�S����[H~��b���c�>��0,�&ع�f�ߜs�$)D~�QkG]��q�r�9v́4���6֒�cWY�����$z��uJ<C�pQ����ND�9�g�h��M;�")�UQ���F���wN��]%?�|R�g�ձu!`��j��v�MVQ��,=VI1�I��6��3���� �8��D�DiRь�X�R�p�-�(�r	����(˨�j�N([����ks�K�i�c�%U���A{��g�iV	U{57��5TM{�P4�:^�-H��K���o��F2��~'��'x,��9���y? ����"��$˂�˾�̃��e� :I�Ao�'C��\�_T�#���"�o�=:���,��z�ݲ7��ڮ��U�$�ļ�_i����h�h<G
�d_�Ha-��V4�*�沱ۻ^�L�=R��X7R��oԻދ����xi�eKWiA�Cj��u4��%lf�Oj�P�Y91(��D������Ÿ��l�ק�]�����g��-����Xܥ�K�t����A����WOr�,�[Q,q��Y+��h`�ڲ��d�-˹��% k��D���S���z��ۯn��zs����o�ټs����/6�_���Q�w_ʿ�&�:��_�\I�I�C\�|p<�|�����m?�������o�McL����-�Fv�bX��믷��*�����ky���K�)��V��7}�xe���Ro��4�.�~���n�jR�8�>��c2W���hF��H�c���=.�3�������� �W;�t�H����������	��>�Ƀsj��
�k�I�QR�ZDqY�J(S�U��y[G��ؕP�*��u���6�E��Ig)?�:���W�?�}��$xĻ�u��;)�D��oo���JKӁ��X���@�M�Ϫh���N��/���s��ݗ�"y��w3��E���p)o��F=`;�n�Y���N�%Ѩ���Q�`С[M�� �:�Y��لs�4��*_�V�'/�nY4�j�f,7D�;)c$0��h�Ո�����Y�a�1��Dv��F��'+���0��xj_\?����T�=ɍ�5�EQ	��'�>�p�IA�!ӝ�(���ܶ�T��uif~Qڿ	Uu0�25��F�3��g[]���v�;�+����9y�ʰ�'�i�Cٮ
G�v0��;"6꺥P�.FT*r}�����{)e���r��f�b��x�LN2�o(u�4*���4Y�ImsF������_��<N7X) qfi��2�6b�iI��1�����ꤒ�GQ�����/����
�M��$��h��4ds�.�l��|��)t��(NtQ4m�����r�d��Gi�D�<r�
c�Xpv�����Y%���A�����1�(�
∪�w`��%Q�Մ�N�����s�U~qw5%^�&��c�i9T��#.�Ҭ&T��?c5!�[�,S���)���w�xL+� �P�$��C�F�ﵯ���4^�C��٭X*#c0vI��kIH��]Ӽ5��-t�w@�otd�عd'��<z�Ү��!����f^��`��M���dH*s���f��<��z�kQ���s�WM��@��(؟�7Ov�]�
����ݳY%�Y�5A�%yC�-樥��x�Ѭ�,��^���	�]��NI��[^�B¯ �Â���|6w��F��I�P~�ÃTŲk��!�qMXl��^���g��9�[M�?l�(���7�t/^�3g���ښ��(����X,��zO8��%��������;T��nCs�f��Y�o�K.a����J���P����;o\�N��O�&:��Bg�؂���ਔ��G��%����9	4���QB����e�l|�@�(	��rX�Q�U��M�w�E)˘P��^��x���h�26�||q���fOY�F������$�6z�W��]�D��'T(�So%p�%�T@���+_ݏg�}�[MY���:>xKPG��I�loÐ|Ybʓ�0DAG/����z��Qhcm��v��~N!4d��i�Gw��g\.[�؎�B����#T�y:��z�� ��������<[�˛!'NF��(�d��0lܒh��������-DsO�}�)�41�5`�@ʁ���`-��:N�P���qb��D�W;	r���lǺ?�ꓠetY|�D%sh�>)������L�lrl٣�$Ǘ݀���+��r���u�a���E�կxeW���V����FrU=�1��J�'��Uq�1G��J�9�4�u��(o�	9�ܣq���&�0/E�v`3X�7y|� �&J��nIT6�����%������~���L_|+�����f�^� �d�      �   �   x��Ͻ�0��\7�B$�����H�\>+��#���՛88)�;��"r!i��y�rU�m�S�؈b)5�N+�&����0�2�Έw?�f�`:ϼd]�m���r����Y�C�2�0��='s%���Wt�
���\-m^c���#Fw!zwXm��Z0̉%I��v�            x�}\��49n���b^`
�H�Tgۀ�-���bGva?���|-�m7�GbI�5���S��i�N���_�^�7���'�/��/����������ojz٤��{���z����|�2�>�2����w|~��cF�)�'������$�J�u�Tn�֙O�F�9]�><i��?㉇����T�k4�����ʋ�C��	�H���2o�pV���n'���AmlSZ0�1X2��ejL��m+�)�d��'h?Em�贍�����֚�	�Iu���3�K����TH��q�:C�O�h|�&H�	*�g��~�1!�|��e���/j��M8ΝOP�4�f߇���������R���&!��/wo�(����1�6�>o�9EN�Njĝ�y�C�6�}��t�����x���TΊcE�����G�s��_��S����H	]"�%?�7�L�y��8�������q!���ߚ���Kj�{;AI��Aii�h�{@�7?A���sC~u\�~�@W�*�v1}�����6h��r=�7(JXO�ۻJ�'(��'���9���d��'h�V�-;|�z�3�P$�%%:.Q��7��v�Io'(�v�Ƣ�c���2�T�X0�X�6�H|}2ĺ���ߡ�ܷ���/�Ů��W(�HDk{((qk��8A����TO�M�¬�P�	J� ��x�ۺ���H1H�O[Xa�[�y��HAӬ���q%Gӄ�%R����$�ulZ��,�4OPS��hI;�'l�$�Tt��H7�62Bi�C����b��,2�yd��	�b*����B��;��^d��'�/{����|w6(/*6(y�ݪ­�Z�D����	p�b-+�Y���@�L�0
ܖA�dJJ��?�H�Q�Jh��P�L�U4`���W����=B
�,\ ƽ]M\��2E�3f�#8u7+�r�vRR�o�hX�6|���Ԁm��	�Z8rm���7(�|X�=`�0��ę���D	</{�g�@��P''��C���P��rv=�e�M��8AEk�vu�TM�Y#"J�V�OPYA����%�<w=A�e�2�ßh��O��A�R�V�8p�0{Z��J�5@*�5p�.U���˰A���Ꚏ�+�aAI�$�	J��}��e��tA0b'(�R�O�����n?�g~����9dI���}���PZU�*��5�O� ?A�T�}l�.^�q�$)�`���-b���0�'(�R\�Ͱ��1q,[��	�W�����>.�z�?��v����X����J���k�ʺ�žG!ѯ������!�:�<>�a���DJAj��,�I�NP��	��]Ov�x�*!"�Q4��a�-���
eb#$L�qy(ߩ��
��$�g�=>?�~���&�Y�!O�P��p�B��_<ˑI�p�~m5�*�<����X?X�3;7(C�aK�mG�#2A�''h���c��v��-v����7(�?����>,��sKU�l�A���Ř	�Y,6�� Vf ��W�q�
1�8mׯ0�#��uD~�2��$π��p����P�Z0MӔ�歆�>�z�*����S��K
�,;A�Z�4O�$�]#�}��g�2�q�`��Bm�*5��jD��ZpM;�ڠr��A��Wn�F�y�A��Toi�<��4�glP!f �9��>	X`���A�� �,P2����6��lP!�B��j�I�F�g� 'hOv�e������݌����x�du 擗�Z�S[��_����k- ғ���n�Rr9A90/��iM��6�>OP�5��m��}���L��\�8?����X��.n��θ�R0c�K1ܜOP�;������
\U�B���
��[\�]Kp���&?yD	���չ��iA|0�%嚠L��r��Z<E��F�OPц�2N��d�'��	��4�.��g��H����K��F �G�������SoQ5�?Bղ�z��)�x�1e�Tm�G���I+y�����6�R��� �Mr�*5� �<則Ȧ��P�A�Ӽ<�1`������^K����;AYԂ�	#�2�ʴ i"y�E*�������Pe����z�쳲�PR�3�\���E��#T�q���ޥGU��TZ��̗�`��|��lP��Pi.F�)[
43��6����y�V�R4|8\��U@��m��O�����'�	Jo�^ޓ���Vg|���C�;���Ln�Gh�P��y�G��I��%Rц�Y�-�A����I!���o�8^ab'�Q�����N�ӑ�&����U]���! ���$"�18��lP"kʚ@#΀^g.�,�H���ԣ�x�۵��=B�� ;�����\L}�*T�1�d������Ճ�P�;��\ϔ�v���}5���`'G��±T��Uj��#3'ji�X��e�P��j-O�'w�M��m�*5ط:Eý�=��TZP<��-�ߓ�w+,X�J&ɲ�F�5�U��Lm����Y�]Ď�o���Uj�˲���Sj��mPjO��R��'E��2Y�Pr	�c�-�P4>]��mP���Ny
��ܓ��TZ�2�d)
����}?�Uj���
Ɣ�D6d�	���5�<EüN�-X��nqѽ��i�u鳒Z��0�J��&Bn2�5J�*5���4%2��4���_��4\�]�S�S[ش̄��bm�9]�S1R13K�Ujq
�9}�x"̳YֶB���`R��nm�s:ʲW��gZ��O��|���*5����ON�ƣ�OP�f#�Kw��M���)d��  s�-}lƥ|f�
�(1���	��JҖ��6��vW�E��FUJ?YԯP�6	g`����c�'��٠z���%w}z�ƣa%�=���y�nmq�`���I�i'(���%#���:#k�K���r�ؿTv��7`	�@)0��u��E��+��GV$�N����T%U/��?����$��7������H	�z$�s�|�
1��?��wgDx9��m��/Pʄ�eY����P4Y@'M=A5E�ĥg7:o#��'�RC�[閭 �ݏPj��K���$z>�����	J��v�,��O�q�e"B���h�t�<�jϓ��Ĵ1i��Dj^�����8�]��	JUh�Ė�[
��?���P
���K���yT(:�\�Pr���t�>ޚ�T�_�r(b5�{S�\�٠\��K���CIu�����34}o�����o'%����$0,sE"C
	���%���KC[oK���7ȗmB��0~=�A���54���_��1*���Z�
�B��|��D�'h[�s�f����l|�vJ`���}7�4���r��g�BJ?0�?Y��z�cMR}���)�j�$+��D���?]�_�$��bii�4Fĸ�++�����6��[��T���(E~Ajn��i����L���H�]K��:I}M|V(��Fix���/�Ӈ?t��l�^����R��⅛��D*6��C�����17���J�Rs�S��=��	J� �K���*v�Bk��(��v)��iyz1����Z��P���\�w��L9�G�T_��5�CKQ��qDtB��(���8'6��B~���/�l��O_G�����O1H���Sjw<��~�)؉��=>��8u�ܥ&�J��{/��c����ڠO��+�H�5��ǋ��T l�d=A��� ��M�U���|{��Y�88'��c�j�t�j˳������]}��E��*kRe���N�R��B��"��!#3/��
�=N,l9��N{�2����"�bD�A���Ez�-�I�@������>x�𥸗@m�����nl�GĂ�i�����!P����i�+�b�lU(�<���7ޯ��)&L����?��4����l-XWd���E�?
f*���D�	J[�k��5���!��I��	���Н��Cn$]��0}ۂ�����A���"̆5���}d����f�jV���Jd��V��I��1��z�޸c����x�Z�Q���R�PU�8KZ�ÓVnO��i��t�AI��x+���[����Jfi�x3E,z��h���
U~�*�,�   �WL9B�_��K_~@�p]�QJ��M%2(�hU�>�W6(YW��,���o���A�Ԅ�����|Y._Y�D*^D.|������D�	J2�o�;�?�U?AIS�6�.B���(�|:3�BU�����1�~�\�+����^���G�pF���~���~� dy�G�:j=/w��*A�(� ��Y%�<O�F(VTF�8���R��B�����h�wC�Lek+��@y�,?���}|:��B+!X
�<��ڠ���۠�t�KyA$Ӷ��~�v��}]���w	�            x���[��<s����'�<�΀$q ;?� �7�URo�ViF7����$D�SK��?��_������o���_����.�s���o�~��SSn�X�߿R�������n�u�'_����������A���[�/���?��{����;_s�$����5�K[�={KR������qzFxa�|�����V����on�K������7���j�ђ��x����N�/��V�,��_����F�y��<��R���N}\�������cY�R�-���"����~��j��Բ�y�Ų���O�Fd���2�������C�$o���tz�޷�e'�X�}��u׏
��N�|;���|�O5�bIz�����������h|nԏZ=������R]���_��xƥ~�;�]���Uo(RHi8����e��R��/���I5�l(�R��c�<yǏ�Zq�$7Z�Q���B[ng<B�ď��C�������شI��i?%t�Lixz?�-׍������S,�������ؽvIn�w����0�J�)X�pak뗣�ş��79~$q�{��_V|.�"�1�O�\�?o���/W	ɒF+����o���w�����[*����0I������>�ٟ�#�Uo���;���5�M��y��c���C�4J'׭�c�{�߹�2HK�vJñ��1^�y�P���X�(K� �2����l�Z9Kñ�?#�����S<^�,�c��^VJ,i���6�a��5�a+��?%��[�k��H����-�-#����6%5M��c:�k�s�q��� I,�c9W��񂓚J�}��ER˶/Ͻ�]���~��2F��S�Ws}��o�:>�q|Y�����H�3�}XpY��B���Q-Ұ��ӱ-�{�����{�{o�HbZ�.�rl���˶�9.�p,{����Q���oI��ik������F�;��Eu��t|x�����ʟ�2Ƒ�'������o��w�p�/C��dd�ZyF�P~��د~�v���-?�)�o�Z�4��S�_�Kh�K�s�|���fxJ�1�M��ҏ�LiX�#�/�<�>է\�!�S��ɐ^�Iut!N=�����)�L�6byIj��]v|]˲bHb9>�ϫ�ƴ�i$5�s�O���K�U|����}�e��Y�$�=�o�c��Y��x��2�񻾥a�O���Td�\�Kn��E��w�)�����?]����z�]�-���Is����\��L�����nIj;�t��\�KG��2�k��ikP����-��W�p���w9Y�xNC���eB7� �;�ߡ��J�=Z�zv��u�0�qߘ&��H��P�c��g�z��k��=W�7Q֯|��3�����\=�4f�C�$qM�7�z���1m?������%��S}Z\3�����*�ZҘa��/��.Ӓ~�+��p��An�'����zJ�/���]���$��n�Y��MI���x�{��z�)Ê>����E�K,If����-��_'�/��[��u):��crQ	?�-�\�|#�uť�%�8��4�X���ï.�j���%�z-������[�k7v�~�`|��$�����w�ec���5���-I�Gb9g=Kˌ��:��%�cA��:�ԛ%���r��AgK�+��Ĵ����˼%^�jI=s�o�R�c�MUO?v�����x���$���L�bmn�-��xF\/��3UK��ʇ�g��T%1ͤ|����F����ĳ�*�PK�$q��I�{�;���M�cNc�fJ�ء#~��'=��8�&�1�����g5�Z�lJb�Z���9*yJ�	���q�:)�KG}�r���[R�bz�o����Z�BO��
�ŒĲAK#.���)��+=�L?Oŗr���G�=��͒�ゖL������%i�ݯ�!\�|
�;����q���H�4�3�Ţ�����-��Fi�&�2�,��)�i%xv�eO��nm[�2��<!�Ȓ]\��]�	>5e���̓HJLQ:��z)�mt�E�ɷ{�|�5����c��[���Ӥ�Mw鞵��,U���R�$��~�t�(���?c��Z�$	�ԇ�x���˽KE^�(DX�ƻJy�:IЬ����f�R��OpK���uf��靇/͇�����#W���m�Ly)]/ˉ���s����|���_J���.�7A��]���Eg�~�m��Wie��n�Nx���7x��[�|�P�P�hV3%u-���hS�ɒ��U�3��q��b�Pט�g��$��� ���%)F�������)����Ί�̼�)I���Z�"J��F9>59[�_�,�!���zA����HjJb@Դ,�SR���R�*B:�#	�v�z���qut� ��&�g}����%���!��)�[���O��LVJ��"��3��MVsq�H�~��eZ�W�`P�4LK���|ށ�E�+]���1ZuKk%�1 l�Lrݒx�0�����3�$�޶.���B-;�H���w���)�o�$�>�?���Jjݒ4(�W�9V�ˎr-���>�����󓋤� ˈqe��z��,�AB�+�c|�0�tK탹���kݒ`��bLYJ�$q�[�S�D�NI�2F�1t,�@�K��Qe�F\l�$��Wy�;��^c�%)����.��Hc����稜p;����i�T2@�$E:@`��OJ)d4����	�sK�,z�У�!���F`(��7>̫h@R��ks�f�I,=e�/�.ն��E�@�-�+G7��P@ �i�7��u������G�H�R�w3��(�ER:� �0G����&�Hr��o�5A����m0�;�	>�,I<�;Ve�N�m;F���\7����}�X?�}��(cK_jh�WK��e��5|O���m�_��0��.oI��C͖y����V/�x'����(�˴�+���glzKb���r]q��6�rZ;�]�iqv��׍�xH��AV��g��ͲT��͊Ub�m���a֩u.�^)+(��	JjZV(��rb�.��p�Pv�Z���SC��Ǽ"Z�x���.�_��H�Z��r�a
])�����Ɩ��H������{�����e����k<��S�{])�v�]�X��_$�]����~�K�Ǳ���-��v�J.�9��J-�Fş�2wտުO˕Q�� D�)�w_Ԙ��Y����gu;�'=wK�p;f��*#�����V���OI����"�r|R3%���(>����Œ�=u�R�����-���1��:�e43.�p�\|��a|u�u�P�o�!���Zj����y�pwQW��m��"�p���u��5{��<�D�e9E�;�Xs�$�\f��б.W��O�OsB_,IA����	�,�AIm;�		�dG�%)���bz��-����Dm�[�^¹a���X/�ؖ�����.�n����ݒx��o���>M�U���l�;�lIZYaKe,K�RE��i���d'�_��#�����>;���H�y|�Ǜ_��NI����9qR~�tVS��o�Q�7�e'<II�g����[��&�8n��MZ�p��*�MJ,2K����N�,��NIL�|���a�[���<l��8o(dI�`t�P��!QC�Ē{1%mέS&j�jǖ����?��8� �,8x��\��l�3I��N��D~��/���M(Ւ�N�S��'�K4e���q�D UY	��$��z���P,�����7h�gDq�� ��;yQ,IB�G��� g+���|<��H�L�\��1�|x��c��-I �q�Ȑ=ԌI�[@ğQh�i�5oIJ���9��C�B���4Ǚ��5�PA኏�8��b5�2:�ު%)˒q���N���iS.������d;��MI����,��k)�$��J��$�?����$�F�Y\?�#�Hׯ��Yhtj��oI.��Зe˒MI-�hk�[����l��[O�V.�kx��b�x�$c�rfS��s=�l�N�o�v�d+&\�H; �8z���`�$�`$�e��MI�|vl_�\X�8�����1�F�U��������I����3���    �G�_˥���?_�Ƅ@~��!��t07�v�]��@YfI�G91�'�Ь(p�D�����O]����O��$��ܒ�zx�'E�bs��t�p~����'�%u�I�7��w�u�+��#��W����i %�8J��(�xz������ER���m،n�@��t&8�p���̉Fц�N�,�Z�-��l(% ��#)ـ��P��y_I��#�[�,7-�I���/ټp%l��MR���q.k_�Z�%)�P 0@����ʹK� $�'d�wL�����!��V�]R���$`CK��IQ�&�j*�����
� qCY6I{:�:�"�^n{ǺH�J�'q��|���c�I6��������;��/?	���|T���՟ ���@�_�e7I�(	Aӗ�4y(iޱ=�<�戀"�Զ��Ⱦ{6�@I#��E�閶�Qd�#id�N����{���� �f4|	Ї{'�_P�'�)
�8�p��7KҰ~�!�#v��ss���)iXgH!a��d�`I֟��WQ��%i�:��?[���(S`�&��z,.yKRV��R���Ng�E�?q�٧�< )"BS
�gJ�	<���@��ۑ�l���,'Z�$���կ�)�%���c��~�G��i����LInu9��;H`^���k:7N��� o(&�ݱ�t��5�} �4�cf;Kb�=[��]���?���"̊zvQ��� ۀ�[]$�- ��m��� ��G�QKi=[���^�/l�=X�R0��O+^2�A�Dj�ޔԓlŮA����9%������{�$��-	���/�I�f%dVAؓ�s�p�$�ٜvI�p�^��D��{���l�D�iL�O�< 	�BRxQeL���(,��P$J�x�A�����%IX�re��K���ό/J�ђ�B���$�#c�yK�� �MJՒ�C�x5�P|��Fܷ�^�O{��rI�p�Fv��%)��	�8ӕ��\˞L��jC�dI
b��S��$�;�_��-j$�Z����W�@�,	�R��7���I�;!F:GF�������|G�#!�"t�<���ayJJ��� L�e�ɃߒFV���k���j�G��S�}�����%�����4�X$璔A�l8�"����q�KQ�g��@�u���>x�{�i����E�2�c�`$K�:�$Ygrn��mخ��j�$u-�d���.����a�*1^-���Y�s2k3=�����%�o�F8���p�=�$���cHO�G���e?��6��}Ş���U���]�yC�)	��6�ԆZ��z�M�9O�W�y�7I@���2��4�)	5Ar�Rj��v �$�ħj~�L���z��.���)�.�I�͒� ��)8�yJ�,)6���Ysy�ظH�Z`��f��A�ERެ��6��\+eg�Ii��vج��:�PXC�4�S���K|	�O�@P�XZ�q/rɘW�,Ici�܂�N�Ŕ����(c���qh�"�%D1����S�$����,�H����(�����"��Ew��ĳ��4?(��Y$1e�T�Â�?R�,�He_��rݻ�YQ��EI!�+-IM�1Q�� I��7��B�'��ܒ�=���S�t���4AR�Cc����ܒv$�$��P������R��(.��h�1l[�쒢=�Q33_��ԵBn��B�U��{>3n�p3�j)a�閔
0_NZ"�w<�,)2t"�4T�DmK��IJ�����	�c��I�x&�;�s8%���3˼��:SR!��d0	=;ߢ%i�� Ƀ��๿pY���8��S}�e()������	!E��m��hK�Q�%u�� G[B�h���ώ���V��SRG$a�	IM\B�����!|K--Oh��o��z���DOI���>o=d�x;�����;%1�d�a���7	H��c���	cm���H"��y^#�b#.8	D�=i0I����A#�[[gI��-������]'H
wx
7p�#�[�%��O�7��6z�TlI� �u`$�r��^$�d[A81�91��#���7Ϙw
g�ԓ�(���zPRӆo{�\�$�Kg���\m���'��Pb��EKRW� ��-�S���I��ZK�R�F
%=v虋|q����j6%�e �`�2��9�%����Qmh&����$�L�Wmfft,g�J�_:����n��NI��F%��qǣ/�8bv��2��_�%�e�=�e�䓰$q�۔(-SS&��%	��g1���a�[��%��ve�[���Uĉ@(r�:�EnIr����L�h �i�" �\K6%����$S�bs�"~��Q,�N�	��-))���)l����>1Bo�6�+���]RL&2
��7ٔ����ɿd~��!2�JAW��Fsf ^��:B�����9�2	�c4%E�P�r�=y��$�8���n�_��7�atM�k<}���# rHƷ}ԹH�u�3r8��>�^$�$�9+�6__�"-�
�;&��s��8��u'|�ʔ�BŬ�-�u{���#�B7�n����lS�Ȱ$AE0�q�'
E��ΣI	�����$�>{��'���rK��?6EO@�9K����d2�<i��8ڏ�{���sf(�tΎ9Pc�]�,�y6χ��� +�� HI��xt��9� HfEI���,sPH��]�e�ٔ<	<a0Kq�@nfI<�R��	sIʲ��;#YJ	=[�2'	3'�c�mZJ��z���0��1�xg�p�����K�nVԲcK�S#<�w(i,ʓ�n��y��%�mX��܌��'	�nI�����~�w#��6{���m���@6�_�x&�{��6t[R�'�����ŷ-I�8�g�� �.�� �Lɘ^2GnI9����1=�")���BИ��B�\�6$�"�H8vSR�>;aX�c���I-�#�(��I�[RKr��WAFnIQVD�_�10~E%5�x�W�l�@R~�<���)J
$X��q8l";{/Ւ���݁�@#-�v )SJ\G����I�Zѷ�X���f�ĲgZ\\ɾ3�����MRΦC~� 1��y���H�lH�K<��YR(bD��X}�$=�4)�
_���-�z���ܵ���I��3㏉Ō��͒�),�czl�; )�-Q�q1��dI��,��7d���3%%c� ��i.~ʼ%�8R� �Q�-��$ϦC��DM(�m�m��!y����!s�����lIJ���E	�ަTJ@�髷|I�&a�I��(�NZmaz�@R����|���19��:� |E����$�NK��NquJ*$]�a[%YZ��R�X�-)x��þOj���#�Գ�(\*��<�>��<>[�2"{��UQG���g!��ԓ����I��I��J�HiՒԕ�Ta4G�Iʈ��F�\٢���������
%DD)t�ꖥg���c�!��M�%%D�#I^��{�$8��=m@��jI��pH'�v�`��a�	'D⑰c�d�����1��s2�S����>������9��H$�o	t��~�e� o�8�[O��7\�$�/Ҿl}F)}1��$aN�ъ�:I=Y�P',��}���$A2Jq�8�أ%i$i���;כ̵�%IF�s纉 Ȃ��%�,ē&�(g`q�B؏��rUHԎ�[K�.�N�1�
�\�K�2����Bs��K3%a:�DXr���ߝ%���-h�T]��5S��q �Sm���,�|�Ʃm}
�I�����.;OȦ$��I�
>�3$�$�I��=Iɔ��?�v_Oɉ?)ƺ�X��@G�9J(͑R�$�9�X�@9j���-)^�ND3��J�E������C3�9z�$��/_����&I��	��eI"sJs��=^x��q[�%�9X�����i2�ĳa���<^m��@i:5�혘�+�M.��r~0�bJ���>�x��91���H�2��|^ΉYK9%9'f���CbB��$	��\D/�����-it�<*�>h��1��C��W�n�+f�D�om]$u���,�y�e�E��>L�Hy����F�    $��3�z���1�d�ı�l�(W�7�;)n{J�$�Q&SN����$tP<�m/g9�ݒ���G!�\�đ+7q�!c��3�M�7պ��"���u1��\��:F�L?��w���,����NI��̄)�ߧ��@R&}�����k����� ��~>�PR�����g�'0�H���1�\/��I���	}z�i'>I��F��,�w���Q�2߃|�����SRT��O��!���:(~�{a��JJ�`���'A25ě�x��<t �g�NX7��dY�s[
�MRL$���D�|�/���H�*�e��E������`Jj�	}���,���.)yrlW��������'ē�xq-7S�I�³�<q
$5-�� ��O+���Uϒ"2�,,kLwŔԲ�׉/̱�-I��s���ૢ \��9C��P�us� ��I���C,aH�����}b������e�F$%Mp�c&a~�SR�mH�IOђԕ.�9�j:��,�r&eg-̤Ĝ��(��1I��ϫ��	���ɼY���5¡�|x()�ᗝa+=CQ����h�)V{$um[�4k����$�@�W\ruBI9�g��+�?{���\���_1�6��8%aVB��c�g!%�ۑ�ERh�7����RjΘ��8�tJj��E�7�(�9=�)�$΃���[L���� P�pŀ���$��c����z���;Ws'o��6�4�|���19�%�Vpe�+�Sp%^��q�-�����V.Iq3��Eİ%?�u����d�0�{%�_�%��ޓ�H�{���I��w���\f�$��?��	n;fg���2�܎�È�-	�����̹�OI����͐j��OI(�j�L�a¸�3��,	�3�,W}x�\�$�p-�&8)�+�$�N�R]X�N��yS�C��K�$�7%�a�q�<L���CI8S]`�$���Z$-�C�������Y�oq��Ƈؑ��%)���螕�#�1Y��$�i���>�+������(��ż��u0 Il�M�m����F�bG@����"l�rB���s��t�� ����������I���6�I8��$�{��ࠝL�,	pp��n8n�����ϯ0��{?%a���2��Z�-i}�[���'P��f�ʨ}$�G��h|���mS�&�g_�s��ϒ�̒t������<��ݒz6��)��Sw�?��2a���ޔ�H®D��<&s-�"�6LF�Ly)�$4L&PT\iޖ�]���@L�Gs_$�W�l16�{!X�%	��~󅆉?�-�c!/�A/1U�ܷ$<̞�Ԧa�;��ER&n� o,LH�q5���v��q=���$Hȴ�2)u���<,�$DH؈̗�6��p�"�#��)��L���4�[��)PƤ���yd��f9�H���3�Lrm{�,�� bE0�?��Z���Hj�q%�/y���r�5��|�'�3���G�%�6�a:4Iq���F�l�R�#0�-)��a��l��ɯ]�"4�A����;�����F�7�vGz�K׶s�6�Q��7����ZF��\Ppf� ��J���@@AG�0lA��L��8�'av��"��3����ę���,I-�I*�d�X��*jٷ�i~�������ݤ�o�Z8SFئ5:�����}���H�3)�-�s��	Ct���JgI���-d��Җ�d��r߾��B�fJb"F6����MIA��B�5?)��j�40>G��	���{(���\wd�x'K��?|�Ml}��IW��T�_@�}>%H
��cȌt�1���
M>¡G��KW�	���Щݒ����@�=�1����3atJ�J���tgK��tF�&��R�%)��AbJ-ݒ���4��#�s�X�",x$��,IxF&%XRϖ�Ga�)=���<NI؀��O�"�B����H�9uP_0A��G͒xƊ�'�	�iם�X$�|��c!M2p~�,�ggIg0l�B��AIa���&�g\��~����$�=���q%�,�==v��gE=ىTĲ�XMIL[Y�fv��0o*��b6q�C�gC��\	#|���X.��r�$�7�D.��9���Y�����x�ADd�J3���-"璡�_�F�61�	�Pi8F����F\�Ic�K<�DNJ������P,�IM4��Jr ���K��J:'E�nk�/���ҍ\��'�`�Zi�$e�%)�TW��O*~��uJ
��U��t�L��$�Ɣw�ۈe��0�qKR��wz
Qo��a���^���WbqI�Gt�tI����͒�%[2���x�fIA�=;�Ɂ�1n��H>�,���#�]͒��l�$�d��<�d���+ۧ���-��tK:מ�|Ŧ��E�z��l�$tgJ�[���#c��j�$�V�����c�20OIA�y��Т��%�x��O�w���%q��^#=��iy|�%Iu
8��R$uw�3�����>�י�R_ư*��rL}��$��H�G,V��֓l�D6���`ilnV-�XB��FJ5I�!I��W�@i�4P�������{ �¥Q!i@Ӄ�fJBC�Ǆ���c`��đ>6"r���o��8��/�A*�6nIx
�P$�p㖤�sp <KE���s�4HHfyΩ��E�0�2�*N���"i���-�{M| G�u�}�~�d��vT���#�B;��̒zIq�2I�����/��ESR�N�o��ǘ�7K�x>cMxD��`Iяxf��0_=��ߒ��	���i��^���^��Gv�9�X�Xz�&MM�rKb�)�<iB.;z�Hj	��Ҥ	���E/�X��ٕ&N��: iT���	ʍ�Aj(|���h��,��iHٔ�k8s侐�S�!��l8����LoI��4��a� ��1�H��(�����xz�,�A	��-�+>i���Ӊ̒�wŎ��p���%�{;�!�,��MI���$��CH���w���f)�9���GR�D�(6Wr'�%)W�i�6Ə��C� bĻ�=�$Ư�Z6��[�{h��ѾJ#�(�~�� �%)���k�,[����KR[H��u����:��"�n�3���W��>b�8e���/���,M���^�)�JVǄ�Fj�m[8�$�F��A��#�-�[��#�	ϕ+�Ө�ɢr��߸�ƹ��ط�
��4�J���,=_���R-IYR�1�ѥ�<��YR��C�����6��SpƇ�SR��$a�Ĉ��@R�
�I��KΘĸ%��o�+51J��KR�vt�68G��H�%'�cp���~���C���(�1��)5nI���o�Ԑ�߼��ERz���!	�ou������ �컚NI�O����<OG��k���3����dv=]gM��}K���Չ���-I=��ĳ97U�SQG�d���-�檈c�IT�]ƾ�2�$u���;���fI��lk�x2��ɒd��r|��'1���.�'N�V��F��Yvº,IWJ� {V痃�OI�
a�|�j�i!��k0���i
��/E�X8�~�K��)p�Y$��S�$�,�q=���|�I,aJ�W����|K���%|��q9���tĀ[�-n�$��Tt�9��-��UKf�2��I� ��G�D�+�-��TL�Yb�e~K
�=+�_qvc���/ݒpv�d!�]}M�K�5��R�n(���t��[��8%�*��ds'v6K�4���d�}'I>�n���e�.���K��d���V��$�O�O���&G$.�]��BFZ8��#)�D�I��q�.�BHgV�
I2aY����u�� ��)	��ZK`�TR�ђ�K[�7O�2�$�����/�Y�%-���<c��R	G�ϒ�|���6η�ԧ����ڌ����$GH9LD��غ%)"��Ea
eQIG�{�W��
cH�j��݋$M(���^�Q��4�@�0���E>�gX$�0� �=a~�R�.��Ji�1R����m��k�����E��BW�5nt�a��$�ܑ��$���_l�r	�l�|M   %��L"��8���XMIس#M�M��~���H��̗\<�h*M���`�g�xS�㔯�TL�ݒ�g���x:yǷ$�a�(v���aI�E��s��>�"��<�8d��ؤ�q҆CN;��H��E�x(��������h�Wd���x���=����}��&S(�h��I���T�bI��3�S�&<k�PRڌl����咔��.��c$�vIb�q�$��%'�,��f�!����kB��GR����O�icI�0v�e�d�bI��0C���|����ـFi��z7I��;�#lòMR2̭�7�l�R�*j�O*�5�~mU
�`bDX�ul�abV숛�Xz�KRr�a&��`!�G�̒z�ce� J���42k��s�;9+�+I��$5-��#�WJ5KRΆ��2�&���󑔊�'�P�f�@AI=��l�fL�S�$�K���Ӣ���m��,IO����1RB͒�YZ�+Գ+ٔ��<����ݒ�6x{0�wb�?wK��	W�Ӿ�B~����1~'���%���9�<��� %%m����J��\na�zI-;�T�!��P�%�+��=#���y�� ��BQ�gx%���z����rF,�ʒ��'�!�4���3"��v�=���8��=��%i8���d8P��P4dEp���$Łs�	J<���=��^�<u2�$�<��~s���:����2���[�c�k�$e�����2�3wJ����R�6'<:%��h��o'�G�i���L��
E���I�b��|wC�� I\Óy��sB1%Mw��xKx�^H��O��o����MI��D൭��S|$�Ն_*�t=�G�[m{������-iI%b�
*Ղ^�Gҧ︠����k 鍞�,�<�l@�$u����OٹNEK�$2^�S���_�)�E��
u)�I�uL$}��6'�J��́���*���&*��$�{���\8�,I�*��fI�ydo�����w(�k��ߞ�vj{��I�����۶�k�K���[҂j��Ҏ��J?��֊_ ~�et9Y�x�ۨۊ_^|��HѷJ�~�c���K�W����%���g��o�&OY��O��˘�ԟ�B���@��i��\�~R�!����:%�G��$�,��tv�|��Ы�H⊣n��7fKcJ�����aY���S£|k�$mM��U�><�$mP��>�Ҟ���$mQ�G%���i7I�+�d����%i�J��`��C�r즤՟��6�9�)i���x���Ʃ�)�E�U�3ם�6*���jJ��a��9�v�O�[�n~$����B�����%o��թMRς=i�j	��[�h�gM�%ڤ\�Ӥ:)�W�A�6=�$u%�Ǽ��H~��]����q��%m����ƚm�מ� �Q섶�Pn���8�;m�1��)�NI9�V*�,K�V�5�Pe	���ڦ��@�Fu�����K	7�[R��>T���J?*ic=.��j�!��-��B}5�o=��-IS����{��$d(i����s�W�$� p<�6����I�?ރ��~o���vw)��J[��M㔴�W|��;�I�wK��3�Qh���G�m�a_F~k�y�IǾ��'��v��[�FJ��d�'_w�F/I��NR�U�XMI�=޿���~�T�*�N���N�H���焎O��OqKZ�)�L�~�	��nI�>��G�	��K�����7Uߧ8�OI?P�M��ݻw�Q\�zv��V����kxIښXe��3ܒdzYo�������?�d돤���a�������+������M�m�%�4�V�JoI���K����p��%mM���ߦ��-�k�w�h�}�T�Z؝��\�������m���D%3^�M���9E�!!m�ǜɼ쒴9�I��f{����52	��)i���B֎/I?y4� ��5�,IǥxE��x6-M�Yѽ�cm�(��n��Jڣ���^{�2�v��}
#yi�R�^��v<��]J��ݒvS0���я��|Kڡ���}��|_�O>��~�%�Oʱ���Q�xǻ��=J"Sڥ�D���]ʾ��C�n<��%�P�D�v�R��K�$�R�J�Qz1�O؇��(�m��M�e���'��'w��mˇ��y���W�n�/��3F�!VKϞ!t[��E�ܢ%i{��W�iLi�%i}bC	Z�jhl^���}��D�>�jIZ��~�h�i
	$-��K
�~*�vS���$e&)����Ƨ�����s���)<�us芃�9r��$��f����KKia^�8%q���tp���%��-I�*^����wIZ����ת��QnI];��xE�S���V��쑊Z�k�`h���.��T��mسIZS;+\WS�9vKR׶mz�\�Y�����[n^��U����[�ߚ�ɒ�����T�	{ޒzg"����[i�#1ί3>�=��*�_�z&�I�Ӝ)HZ����W���gNIM���7��~x��_�VR�:iV�[���nI]�~��ʟ*���ޕ?m{���Ti��ߒ��1�~�U��Kߒ�F���kU���+U�p���jE>���u�_��:y�����uѴ�k�uꖴ����o��]�$y����ס�7w������ͦ�bIZL�~���4VP*�K����U��cH꙱'-�l�Se
+�VX#m���q4�UP�g4C_�%iAE6�&�4F!�A]��V<�b�t���.EK)�Δ�p��=]�ڒ!?+���)iდ,^G�&T��ߒ��~Iɒ�����Yt\��S�����*��K]@96I]���霋�$��a�/�r�Q�$��;g�e��)�g"$?q�5����Ե��
^<{̞x^�xv�����rꖤ�o8���ϕ�!}�$5-l��mݱ{�$Y�tl/��������ޒ�f�^������(q�s�ڣĒ-I^�c�~���6#�@ҪhY��*�%.�[R[V���h:��nI�U�͊T��v�i�Գ�JE�j��R�J%|������ԥhuJ����
��H�#i�z���i��O�T1]pm	��ÓER�g����u1W2H���fI+��D�Q5ǐI�$-z�ی|�s@,I�>�z��~��X᫤�?�����T�֎7I*���j��-��"�M�י�<���fu���]���E��T�@�U&?�� $-x�=I_�[����ϣ<�J����8%-���=.�1D�N i1��7E�Z�{�h���*�HiA���-i�O��؀'�H���=��X�/s� iA��K+�$�}00+ZR����,���	�"��	�F�<�8-y���}�)�MҢ��gmt�H�IZFs���(���6I	7Q���_�$-$O�S�i[ �;�l��Kj4�LI]��U>�#��Kђʸ�/�O��閴�*+}Ҝz��wIڝ|��;�нı��H��$�fg/I=�$ �gs��Qk|ڱ�EO?��_]����:d�G��L��}#�u���͛��%��ǉ�>����e_�`�M��Y$-�
��S�m��I�iF|UN);�IK���ge�֟n��UG����ڜ�Hj�؇��}.�c9n���lS��J:~�
K%-�=k�KID�&��{:�`_�d*j�}�-wlzK���*��KO�GÔԵW�Z��K�H2<	w���: ���O�mپpJz�S���9���"iK�3ԙ��u�/�n�>|�K���G�qa_�Z$}����R�ٓg�$}x�?|��ÞOh������a��-�>~d�4+�b1%}��U�rgu���T�$�_@,ђ�$��ѧ�}��"�Ӄl�/�)W�)��7��K����Ѭ��g�9���=�H_�>~b={D9KՒ��;[�`/`����[�x����ڂ�]�-����������X6      �      x�t|�r�����/t�M���Pń�Px_ߜs���ݎ�@%)v&k/�3�>����h�8���(�c�p?m+Q����a�/m����e
O?Vp�(�Q�����$#� =H����Y��.�ׁ<��%��m3�����x��e�~���U�+��/�u�������8�A�d�� � E���;ua�xA?�?p�x���o����]�7��&D�	�? =2�0FE)]��s���.���E"I5�g��4��^;>SJ6�_Xv��e}��Z=��ģ�Xz�:�:GƷ�W��T��2k��D!�D�5p?��TwV$'M�:Z��Z�q���;;��7l?�@�U�A"�%	��#o���Ǩ2'�Q���O����1���x��U�O�j�3�Q�e�\2�?JO%8�	����nY�RB��"��!�}�t��?%��|��R��`����4 ���@ߋ8���V�@g�U�!��Ԥ��� DbqL�y��E\�I�`4�U5�qy�C�z�P�#E����P�#��W����HWn��_�g�����.@�Q�VV{������������bݖ߆O��x{N-��&�Oi�P�C|�\Ԣ�[]�9�*�
΋��FMC�?�f��L �ƒ����ơ���č����>@�$Q(-�Ʃ�)��� .pj_�M����o���q`�9<�1��
��(��p�'�v�.�����S�6�+��ǳ����^
�z}]��nF���٥�-G�>F��R��d����ߝ���C��k��i��L<�,�Ҍ �4'!4G�'ǁ8�v:�(ϒ��"����Hu]�>@A:.��B�N�����/1�@�d�K!��]�˾b	]oN��ŗ'nF�#�����K����vO=� $� ��9��Fl�3'��Rd6\f~���#C�����"�
�r,�Vr�BA	@\<?��^Ig=��<����%cJ  J$!|E�/i��а��]I8^�n�E�8d��j�g��B:�tʼJn@�Al"�@Mx�e��E/�`�<*�Ή�M�R��KS��z@,΂8�B ��@Ө �8ǡ�`�>��?���P^I��l�/�}޿��⠥�a5�(ז8�æt�W:�M�tO��3<]v%�w�o6Y�����S�~^/<�Q�����j_۵�d���� ��++ϸ�����79�Z�F��I��R�����zp0�B,� Mc�r� �x�h��q� }�o9nE�'�3\���iGVgIE1<F�(�����C�R�.�����B����"��8sS�Z(bIE�u��'ϧ �눘Z����}��b�11d��x�J4gb�����@��eJB�ײ��	��-��1��7�n�^Wtcgg}�F��Ԩ�q�4VU�Z*���婜{| ٔe�eD1ܯ�=�S/X�ZH�+˘eܘQ�8�(��s*uRzك��������?uN��
��0����T��3o
B{IS�tzQ?�G#�&қg)0�*�dG�y�n|^�^T�-�/�����`�S�<C�ޗ�=�����s}�ҩ`x����橤�6��XE�3�����ͅ�v��K3��k�N9��X���kA���J��`��'A�y��N�j
���=(?�tI�[��<���	@f�5G��@�-���-V� R-_%�._V�����
n%�&���
��p.( 3�>��B�E��j;\�ݔ����H=��B<T$�	1nx�SaQ�N锍ǩ'��!�%�g<�LM|�����"�s<�I��[��GF�\?r��9��m���e�/��uH�C2����!�y-����A]��> v1��	�������8��t���[��ܟc��@��b�xv%�?�-�9�����7�R���#�Yh�_7��5R@F&��1���n;_��/.0~?�4��ݯ��xU9�FȬ'���3߽�}�k�>B,����7�VJ�#�������^I�A+�6��ky1.�2v(ɲ�ؙ	,t ﹱ�Vp�w7w	>���q0�Uo��m�?cy#8�C1���l�&�����$n	�����-�x�����n,�	2û~R��+�ֺ��;Q���%����h&��^��N�_�W�*�DY'Y�m����Q>�t�K�����9*q�u]k~��TU���m����c0���EB����6[����ǐ�~�~����-9����M�ϼZ�ލ(�$a�Eg6�yⴁ�sު�m!��fsl�-��DBk��O��fg#�U8�r;o�3�,ՁM�4��)1���N������8�ˊ���;P���f��N����@��*���`��oo�`r��W��R=�#_�/���`������=G��HEo]zL��!ND�P� �l�T��<l�y��3�����b�9Ey��bk[��G|&2�~�O�P�@7��!�k!j�����%�������_@U]<Դ�Q�CX��qpkp�,�#�N����e]���|7�:j#��]�FC��SXJ���r�W�.<?�K@�EԣC�4�j�J5�Īډ��	iY��.��|dp|[�,͓8%a������Kq������˺濻nk�~N-5���\6��ә�������$z`���y2�j��󮰤V�W�Q��m�˨������@�S�܉��ݻJ�T�;����|hqF9�I�̺"��GН]��t��	��@@I�
%o�@�L	��k('��-d=���ə��.h���ԁ���k;!(O�\b��q*�0�l:õ�_������LI�ޓm��X�.��T4o�rU��r��9,��RѸl�D	��Y ���&�?QK���w~�h�e9\ d��EN>rK5�]~�S����U`��#2,}���"�ۂg��ٗ���^Y��Q$x����{C�# ������$�O��]�.E|��Rܤ���^Ϩ��b�w��/Ӎ\�ɵ���D�3�Y=����: �p<K�$K!"�����e�k��X;���;L����J�R�e!02.��/o�ϼ`�˻� 1�Ik R0LgB�R���t&wu��;i#�,u\�.ԁ��Cې�k��!��9j{�S~�p��9�����A��ݞ�ӎ���2�+�%�0>�O�w���_��r�8��䙍��g�8��9v��79V��^��B�a̗�Y�a�f8R17�~�M="��݉����6^�A�85��?>=���3Ll�,�}���&A2G("�3�3�&����<��x��6�cV��t'�������Q�~KDG�o��4���'�w��OA�5.�U�����a�JK� �ߺ�I?�׭��]�u�5�qT�)^9����t�^|H	�O~,����+?��vs���-]�p�QgpM"f�e{�o��l�@����4�|��U��kbڏ�"����r�2�{��� �ׄu�	uF ��Y6����ҁ�Լ��6*�kw�)��9��Ìb�T�/d޳_/�_�i��m���WaaƓ4E04-b��6������_BzZP��/ҷ�v
�/5q���
���rf�9�����{����ld.E|�Qh����.�s�8p}c#qCĝ�"��k�xi�Tb)o��.��2���&?/_ �[n��ܰ�K!<A�H$�?�L�"Y6KZS�k��H����t}]������Klm ��A��zFrև9� _�;�V㙥�����ձ!���
���2��]2���t�䅄�U7Y��s��~���d���A�H����7�ϭQw���NT��� r�?�_�v�*�J��1b�����n%\��s��2����w��_VF��B���^P2,&0FJ�c��=��ۘ��h"���@�-����+*H͗������H�cya�����P�����F���)��%�ĉ"C3�Q�M��n'�y`��NG"���IÎaGWWa��|O��|��7�)���h%�M�Uy_P�[�4u,9Q +�K'��*����    z�;�Z�=��i]ՙ~0\�ɉK`�W�¬A ���y��P��^?�_V�@D���b*�o�?�4��\\/�p?�.�__ض��k�ǯӆh���A-rc/g�;u�t�����@*�x�.���`��ۆ	�DV^�`���l��!E=Y�#X_˕m)���#X��%~�&=i�րnVm����!�1<!p
$3<.�G�uث�6-�obθօj�t�~���ޤ�H�X!D��� �7�� �ĵ�cW˫wh�1v11BH�(�A��]�%��t)h�(���n'��M���Sʛ�9�z�� j>$�&g����4���@�>8�X� �-J�4@A$|B,�b<OЏ��"
���W.��aWU���)��:,N��_�A<-��)����\���'SnY�*�%5�U�H��.�'�7t�
���{#}iMt��������"�}.�+���0���,z�2ځ>��Z��I������3�W��DZ�T�Ȭ�*�)wW����Q�X��o���f�0X]$��9�2`��FGlM��̙�t�z��s��%�/����m$~.��|���f�O$ݞb��:�T.���9��'G}�d������0x)�ET�q�7o�`�_�Dc��
����L/���g$;�;}�E�����$"2� �d��~j���+�K�$X�VBj�WZ�_���+�u�zq�b�bxnH���sZ%��������I��Bp)R#e���p3�f�D��{�O7a#|�@s���ͱPq�BĽ�xr�ج���1W�O]Z�WA����FL�X,GS�ٺ�7T��aIʝۗ�5j�H��Ӹ��5;y`�*D�ܵ��3�љ�C�{�Q,�B_I|���5^���@_,Ap�||�a�hR!&k��&5�
�8���&M�fZ�9M�ke�@Ѿ,4Y����� �� 7=Za�:����ϥJ��y�sx�勵zC4h�ꜵ��a�ɫ{���ܦ�)6YH4�fvɴ�&L7���.����nE+wB^���o��g{4|���U�$I��*
�L�;f��<{m�E��ㅬ����Sr��� x<y�ؙ��v���{t=Q�I\{ ���g��3�Dm޳kp�߽�b̬̑旘ŝ��Ś;`������
����_����g.�!c�N��c�g�5I��*���

��4�A*@�4�:�e�O�����ˠ<��!�i4��x�<��n>/�N�
&!���X���D P�����	̲q�d䋹��g��v�AY��$��2�NOHE�_�]F.JU
3���BmC=��ă�0O �� O�4�
40<* �q��$��f��U/:���8�6�� ڿ�cdR��a}"7�|̎�ցˁ�R�U+1o�-�9q�PG�����A���a�(:�r���뵑�"���Q�L(�%	��
<^�t)�Uv� �yZ��iY����*v𿮁$�$��'H�~�#C�fe���4J�q����-���	��03�T����V��HNh�);�L|�87f���r��;S�a����\	�h�%�M���ۡ-�(Mn�`'^�1h��z�4���,G�A
Y���c����d��pE"I1.������^�icq��;����`��<�魓�Jn�o��;ю	�i����7{�����W�k&�?�G&�ͅg�y|a����)P�ּy�up���y���׾v��Y�1mM*w.���������I*�;���T����͌�S���]�>��@�r���9�� ���	�T3�d#MZ,(2���M���۵�g'�9\J�+0w�ޠp4��<?��U�*�"4|Q����g�ƻq��o� 慭1I;�ݻ���)`�xϭ�-�&m5��)�D����ֽΒ�7�����D�]lKYw�V0H&�p��}r�0�a�M�(W].����:6rA�Շ�k�r��^!^m�1��W�r��;彌R�|�̪�M%��C��C��PF�0��%�n{`D%|{'�s~�5H/(E��8(hS2��~���H�̶��}2�X��8�R3rxtg�I102x)&�[�F>���q�3��O}*�
��w�����B�FC�xl����K���͠H�@]���7��F���aV4�?�=;U5�����gQB�цǍ/�D�y���~�$��ƚ��[O%�UY��,E�x�y�񤘨�N��6�9�w��������Y�ge~4�t�Ad��(���މY���,_�w$���1?8~{��V����c0�Tz��\�'��E�e�n��V����Ϸq��ը����0o�+_{�淶D512���̄׋A�������W��6T����l B�<]@���l����N�� F}$#{F���%�Jt�����v��]��Aw�C DQw,A�A���h��6*"�6�r����RXJA1d0
!"�R��x%�[%p[�֋wt����
�#}�nMx�G�k��d[	�5,G��u������B4���Y��I>t�����%�`�D
`-��[vm�9�������o�$�[����Y����@�Ł�yY�o������whȗ^zu^w9�s�Ζ���b���!5S0A�]��������Lm�Gz� 5�f��+�i����&y���s���g�'<$�A�5�[�P&��Vy;�����&G� b"���G������z�߾��.�0t:u2	~X��ŗAㅶ�>�Lw�sP^�m]
CvuznM�I�$�"O��i>PE�w�9�����DL�o���<y��od���P��='k�۰�ݴ �sO�ϘN����%��E4/lC�-<���~�_� �8��O�4�d./�&�מ��c�\p� #��2���냢+ D}��M��ل
�;@��w��$`-�ͷ���Z�� %�%����0}鈏�%��&�0�k�~p�0��S1F�`z'A,~����;b���Ou<�_aB�Փ�;ؽ�=h�U���]�V��؟m��_"�l�q�wNO���I�M�XK���n��Ӏ��q�.§�?3sT=��rN�Y���b0"�Y}��D'����ţs�[?��u`����D��	|w��+3mغ]�^]���Y�_�|'��<&�m�k2���{�6�s�F>�_Z�T�g��"/�\f/n働�T���a;Ā;]�!�<��h�,]c:]o�\��E+��{��.�����3��oܞَ'h�e/qǫ���V���O�-�2��
�Jy;��݂K�7�wFrې_��7��c�0b���R9�wz���ߑ���I�T���T� �����⠷H@e�ZG���)p>	%�B�( `����oM��P��d�RhA��#C$+!Y�F��4��ji��=�$�|)�w<'v�DЋ+E�'6�a/ι?�iVz%�dt6"�qP�^xZ;%A���C&�ӷ���t����ܪ��+��8):������c�y �D��s���-A
�)f�a�ܤ�����u��i��S��u ����k$b�R'2����w�VK"t�<�V�jw�Q�F�dP����#�����{c�T���%g���7��~˯�c'�W����}v�*�=��ܑ �k�����h�"���w=I�9���n6��{�N����թ��-�$m���bD��^|�x���ɿ��C�F�;{��M0���:��+�g(d�22ɋ�g������KG����l�1lh4E�;�B�5B�OU�!��أ8L�a'��,(�x����Vu�X�.8t��J>�Y^ua�Yu�uĩ��b��X�M���6���YޗF�����&ҵ��!^�Z�m߸��T��F)���d�� P�f�sf�6i�_�~�U�1F|��y����mx��!���$�A�[RQ<'��X�;���nOA�L���r7���}�`�~�7u�f�
7� E}��D'v����Jx�����5qu�`�{���J7�V�dp,�@�熿Њ_�8s\����?i%����6b�}s�`��C�u����V I��=�͕���ʭ,���/Jh��Һ�IT�jA�j�Nw����e>W�=ޟ    $A�k�2_}�R�͎���6(h|
��0��\`�J��h4n���1�aE��'�耗���	��,&'�J�>��?��ϵJ���gЄo��Kco(maA|�`���S�����4\����{
L���Dd�r�T�옊T =1���W�bDZ�']
Ҥ$�12�MTZʉ��E�j�ө�����eE���#.L���� g1 ���⯞BB�1��8'�n�"͂+7;[wj�
�t_x�[�����nS��4�������7ځ6�F0aQ3�g,�9_�ɞ9a�m]�t&>�k�b�j��U���q쓜�#�4͊�� �z�2�Ky���	�3��r��C��an��a������G�+�B��]�%�3VAͿ��*��JK����b�Zt^@K�YF�e6�MK�q���p���҂���Փ���1΍�X ����V�lQfk�΂:5�3@��.]�
Ĭ��=xi���?���gD��(��)'��<z*,�.@��������|%pGȳDV<�	������j#(.�oO�v1�b�g3@�x*C��u��g��Ȅ�iF�X�iX�fl����]L�g�6�ll��2�.3cC�/����]�����5H
�o�CB�1���"C�^*/G�;<f����W��K\�N��h����q~�?t�S���z��@�̗�u����`�&�Cū/py��`g@�{���gG&�+�I��9�|��w�l%G�/�h�i�t:y�\I����P�E
��?_hFܦ,���^��c���l4������nT��E���)��-M���=�a��ެb�����g	|�n�c��i�η��p|)](k������s�(M����_�f(�]����|����,�V�D\Ӓ�ּ�?�^�����"����������i���b��{�=7��6G�-� |��ߞd���p��H%��ڷ��+"�z�:Z�*)tJ�I{vǦ��)��ɽd_��}���iz�U躰	,*O@���Z*��7kU��ҋ����;F�4���I�n�Do�PG��3���w����wו�J���<�n��r�N�>.\�r�4M�	�ҳ���µ:'�{j(��V29�A^ ��y��Pυ��\F�"?eX��D���˳հa�C#�|6���k�)�
��#���gu]Q��Xr`�>@� c��9��N�Y�Q���1%av�r��fΉ��v^a�@t_J�K$�GsU+�d��Y��%���N���p9u�m+e5�����b&��ak���+$(���+��%ow
�8���r̝NI�)$)�����eG;��j��Q�k3��L������%imW����fa��x(�&���nH�٧�����^��+���vdvi,�#�CR-��`в+���F^���<0M]��F"8~iKVM--�Y����?�"1��	��~$ٲ�QU�n`*�R�F�o�w��B�3$��o�-�nЅ�ս��<x��л��d��Ml��V5�&�v@,�uHË29���@E��z-D�ِ=�7�X?��� 鲕�|�h����q���J���&�ݮ8�Q�Cq�ɟ��ϧ�xk�J�	��~�@�?�Ħvm���2`oD^)�xA��gq��{��HC->��{Y+�e�z�;���򲟋;d���djY�9���+ ?�5�,���5��BbQ,y��
$rM	lM�?ح�����s"��a2�3H��v��6Zl����%�OTU�q��́�M��-�E��4��4�j�.������kf"��s�~x非���g5l���� Ou&8Z ?�
�&U�F菾_��0%o˾�('�_���Ɠ�11#�� Vd�m,���5�Er��чe��'Mn�ٷ��\^j�fIZ�G�@Z��O?iF?|}�i���s�W�A�N�W����#��x[B�7�a_=�+��r[�I��{�-1��q��BݰS�s�Foy�ggK�~ }@��C�S �(�R I��
���Ȯ�KϮ�{��h�|c�ob@w���Pe]�5�*� ����U��B��<����~�X�؋G�mw%C[]�T�3`�60�[B��яd��gu�δ��7;�WG�;�K�ލ��Ъ ����zPğ�un�E8� 9@!��B� G��8ɡ�#+��6��j�|�T�h�=��ME3o]:?��f��8R�N9�oi_��2�³]v�����eZ��)!��p����3ٶ��,]<U��J�rzɸ4�?K��3d�a�N+&�-9T�=�"o;z�翎�3��JS��$��$�*���2�^-��@n�k�Ss2����PV�BY��[�t�	/���.P'�/��c&�xr0�g�A��� Z�;?AfQ+9�=�kp�Q���M1(e�,)�Q���!}�� �DN�8r'?��z*�������A!l���h%mc6�/�gUaW���gp}^�x�MRSs��Nz@|�Jv|�2�k%V����T�y#c\L[�l��B�ڱj�>��J{ܕ� kV1��X�9�t̯�@� �9�o�-�����/+�7�_�p�Wi��O*�|� �}���DhE��$�em�C�L�4'w��(y�^�<Fy2���x����)T#����-�hrm���@�e;E�s��
�6�����'�g���sKN<�{�o� �cX ��h@�H��;�٪ЕD�*���%e��Q�D��a;}A 1�j�,�3nxCu��8����i_&�':$��N��}�-s��y;�|���G�\��(v�IR��I�:s�ߚx��@�K�3���߰y��y�-ɷ*ܙ�rO���#���#u1�p �}��w{�9K#���q���F��I<;a�i�����;aj3�g��g�5��^�_jg���c#�����+e�F��X���#�x���&���e��	�Ǆ�+�ٰ}T`MBz�ͅ�	�y��>q��p���\��b�F����b�;�h�������v���[bz��G!��nZ���%LR}?{b��C�*I4;%Q�<�_ C�xQ��]���I>w~vJ���pܜ�>I�H�S43t��]�R"إ!��J���"��?�$[@Bc?Z��F���<�B���iEG�X������M�u`|I,�]�rfT��'��H�5�b�xy�|��y��'��t�ޥa�%B���u� �/��~.���ҩt�NfP�r�W7��@��n�#$M� 0��T h�D����@���;�vh��n��֙�t�����5$^�Al�����ʭ��Ы��-�m4<v/R%�_�'����ɟ��)��-�����[	�M����߬�%��6=���\�J��Yh�j; 
����e!�	LPxG��z����C G�� �W�QH�^C�ys�@��־V-��Ǽ�Q���G�~�&�1��f�:ƀt�~Z�yoD5�q���M��I]���iVK���6lM��r'}=`���?��������nQ��jΑ�ז~*-@iE��	D�l��{j�Gh������X�`8��W ���$���˳<���*Emól)�e즌�F�+.����N�4K4�$|mV���Qu���m����%���slg3�Z��yV��t*��%-4+E�jê��k`��D��9�8ƪ{�*�9����yT3�|��!���"�p��PF@��8��i�g1������3�Fc��F���\���_�0:�x���[��]-��&���8��=���q�V��p�A5Y���b�a�F,s������3����3�Ɛ�el�YvJ��T�V�wEJ��o�ס��X4�	�O� rꦱ�x��LD�����S��%���gI��/J/u��p8Z~�9Ѯ�����ۋ�p�z�D�I���5Ǭ)u���1e�ᬿ�)"��������9��l��@�N�JB^멻��~�`uH S��PI��fO�	*&i%dB�n��x������#�*��"I����k�[F�����[F��5��W�t�/sv,�{&mߍ����2�R\    �4EpI���P��Ս���j,��PȎ{����4�&���ҿ�0����`��q4��p��
�#���,���0�=�J��1�l�|De��]�8��L_��2��y뒈���5����݄O0LX?��t��M|�P�;Aַ��,�[i&���K�������<�r�v,<<�X_��Ę}�!TQ���$�e{8���$�_�v�c<�h��V��>�����U&
�zE+���@D�|�?�q3�*�z�k�q7<h0Q"~�lz�H�{��Id�s���e5�	�^=v%T�5a��
d�5��!ii�i�(��\3$[����|��yK5���{�&)��9�?a0��N���Q8���?��$��o��˪�a5$���.�PPπ���Y�1X#.i�:�Å6���jN&]׈�?�� �����'�O#��]>��_�6�C.I�rG��:IʑsF��R�1p���2AE����_m�B����w���H��8����?���A�fU���٦|I����>^>����,�T��^���*��-�vv?"9O�K����XE�n���<�������pC|�s6*�12�t=�e���(S�𽥿��l'H�l�kN�BH�8�� ���?�H�8����Q���������L7�-��t���kek[eطOՁ���wW0K�kaD\#M��4xά�Յ3(�ZKxv~�=�( �9L7�K_�B��&�@d�+`b�7�W��Q��%#8W�RY�+@I8ѥD?D��W�����a�ù=��.�b�G�2���_=��/�uб��kp�_��v\��=�ϋ]L��p�W#�9�;á9_���\�<��PR���6i�,���o�`>>��k�r�t�O��'7��H�@Y�����;����!��q����*G`�i�;�\@6�G�S"X��A��ʞ�rv�n�^�-�lotPqA�w+i,BPX2���ˇ6z��F��<:@�K0�Ƕ1c����9s&7Q�&tEWI�[���.Z���U%��� (��a��(ȓ0�����3�A���M�������{�6�sт���@�̝z�Ջuc�K�du����߃<�b>HpH��"77��<UHotWџ���n1w�k�_T�f�0�L�">���x3F*�Ԥڹ�7+5�ăr�F�i�[��:�9&i���^�}��[��em�X��"|q��-]|H��L���-;�����:�&Y)!̀��s��-dڍ��R�({�ۭ_�f!P=��S�k8��!��i�2s�D]�#���ݴ��g��Ί<�B=#�Ed%�����ʮ�Ix#�<����+�w�58g3������1�z_�kܗ��I�$$��N	p@]%#��)D��{. �	��?孱���0���-��5N�}��w�f��q,���K����т�^L,����9�<0L����A�ב���f�I��-����-M0�lBŪ�e5��(,?��x�����H
&���ь"?]�EP��{�-��`>,����LBQ���z���+��K��N����z��q`��'�d��T3l���g����;���|����WVLV��~m #�5)S~��G��;i�>}�Q�;;�>*�=��\8��'ݢ՟.j2v�5�29��
\��xi+�0�$ ��c0�`f$��Y��'��8�t�B���ucT������3Mn���L�[�-O�ni�w|[�_`�#m�����[�x�$[+��l�v�
z�Q
�ag��fr���^N�%z}�]���d,&힪��y	���	>�Z��U����_F������)*ɨ2͓�TGU\O��Xs>��q�h�/5�{�$���ǢXw�
L�G��K?w�:����{�F{Y48Wɷ�4�/$��f0@+�>]��,���h��p3�<r��:?�M��ʨ��t, B�����fA�%J3I����O�g�L�3L�}�_%����w������9HE^97}m�u��7�#Y�������`m�6&,�|"�������ZJ^ME��)�\�a�b;�恐^��#��jx����W�5�v.��q��"8�C�?���˱ �y�k��3F�p�[I 0(��v��=��Ǫ%K����Qx�[;��Jf��!i�T�W�b�A`SM�DW�
��9z�]�ں�~Mg���2	y�'���y0B��B*��P�B%^�Q� +�����a� ���Hzo�_�`~ �8Z��P���#��CH�?�N�"N�x��go��p�Gϭ�_�K�jޓ|��0x˥O���_�;�kԻ���V�P"'y>ǒ���~��$MO�q�֕]5�%vnу�De�a��{��t�~Hѽ�/��VE]hU�{�"���|��(ӷ�_��\(�Ę������h��C�S��y���j�C��(�(����~��%����^��ii2�Q���%��M��r<����<�S�&UE1�[��C����]�%0����f��G�x���"��g�ᅬ=nGk<MY�{�����Y`�N�X�{@}����D�@�&���ೱ�V�v����.�[���6>��a�;���"��,�;"�.�X�;�(�;ao[Q��ň �	<8�y�P�����L�|/%J=�m�{e4�����|�^rLGZD�^3
j`}/R���|�c���H	9�S�I\��m#�� �4������v�Z��#�?�1.��FޓwO��H�����4��da��ۺ�o�
v�++/;�
CA��> ��N!	�R��������H���6!��n�kF�m	I51����C0�ϒ������jM��Y���/���X��Ŏ/ѡC>6C����㾢�o�����0G`7��>O��K�Wٍ��9�(V��>p6�"���&]�{|l^�.�y�o��B�"vֆȧ�n�#�ҿ�O�\T"�iW�.��8�ܨS1���4M}a�E`��0�bi��H	�v�1��`�%�@	��?�z�k�U��etG�$Bc��.M�?=�Z��s+	Pv�M=IO���J?"O �������0t��>������UK�z@P�߫�+�a��^D�Z�y���lXk��c54k�����Z�Q�r0! �J���ʳ����(E@`��+��O��̒�,Z�����V�ʿ��U�u�@)Hh|�G��1�Λ��U5ǿ=�>�L�.�@�Y�������v0��*}��ƃ�O�3��^���DZ�GNh!W)����'.��1�ErK.6������L	�`��dQPh�S:�b�+��)�M�������QUi׮q�"�����V9ۃ���X0k���ݓ��l�X<asVQT����A�k�g�m堑'��Q ���Cd5�]OB'�8��\������)P�N��z��`53�����kX仟���wːc ���_(0���}U�Y����#@��oB�e�X��B���I�����Q������/������Kqc����3�wd�N���OH�G�V�5���[�$��ME~�Ϋ����ꢱ.���lcU�����>�t��-b? gY�=B�	�V�*���o����vX;F��F�Bl�+��k�bA���c�j�C��L���#�W�|�Q��&�x���?�}�[��i���M�߯��R�n��|�`�^�d��� ��PcIsd}0��$h�x����p�iL��!�@a��^��.Q,��u��q�=m����j��I'���P	�n-n%�2�3pݩ�����힌�6w�4_�0g��ʉ֫bڽLt?� \�-0��x��UC+��ζ��y��BEjN�m�Tƙ�yu�%o;��0]��_R|�C�ě����C8�0��������B��j4�%	��(SW<��܍j��'ጝ�,�sԷ�=W�c�}�s�gsM_1�������k,V>)��xK+�)�k	��U�$m<u�ǝ��ؗ_N��?F�K��H|u�@G%"8��E����5a�=��6��R������܄P7�    }i�Sf������@Ş����!Z�>�)�F��j��jh�t���\d��ɰ���Nk�/Ԋ�.Y����z!J{���_?rͤ�>U�W<�nJTv`c����K��N�"�@S�Lђ���ӧ�o���=B���K�ׄ��MenB��ը�2����|/���Ɓ{j�	!X�KD�S��ϻ�� c@X~/!;+�er*8b����LKolu�m�������i��1�����J�ŷ��~���
��O0���(���=�ݼ'��!�|�:|�my�JAO�ㅜ%+$3�;W��Ѷ�����%��J�������0��5L{^㛷F�M�H9'�@���W�H�f���J4��Ev����MT3����x�'�B��/
x��2��PX�u�a7$�9T�H���6aF~���������C�
/��m_���pQ4����tJ߼Ҧ�s%����so��S ����)�j!	$�|�D����d��^T��5�yW��(��̓�j�|,<����5�Oꅉ�S�8ņ��(:���'� � �y	9 g je]�hV$�ll������i_��J�ǿ�[�-�
�jׁ҆wcn:z�W�����
	~�k��'8����EA��ɨ�w�S]��l*����և��ǧ�tqZ�V�A&��A�)�i���N/S8�~g�[��C�(��(�q�@r�������oϾ�����_G��	P�3��[2���U_�BTtk���K�����7I�1�I%Wܱ��C �Yh�zS��M��ꭔ��׼r�)�fI/�ϫg?/���nc`�A�>#|YfÕw#�E�;9G��i�f �K��$1�8
fP�0�����D~i`�k��nX����	���Z��$U�}�H��5�}�Cm@ GD>�#jO���[�q�=Љ�'�S���5	�y�Qti��DC��� ���}���i�ص�cס(�2I|�{x�(�6���p�N���@��BC��O��J?%P�^���]П�v��mW��&�	0�M�m����hi"���`a���!lb�N�F��CBH� �Nzy��]͆YX��?I��|e�����*U���j�Pq3��0|����#Y��:`B���a(�ˬ(A^�)\e����C�(s}�;g�;A}����E�<(�P��Ugy$��H�����%����ev��/�l�M<(�tL�eo���͒�`W�%�ᅚ٦ٶ�<�Ix�ӆ�!��@{{\�4BD��/
�շ����y��[��2#  $)��$a�����ZV����uδ��E�^8E�X�����DKԐ��U@�푣Ukj��:��UŬ���r��ގ��Y�K~S�����+�t+cb�����w���"l3��b�l�D
��R6��M����pQ�e��	��xȶ���n�/H�!�yտM�'���/{�$����l����ȣz�d=����Ӿb�8'��:(hl��y�^�<[�#<�֚�7���Ǔ̠ �g�&M�Ƕ�S/���6���>�º�Ǌ�"u�!h�1�$���� lA!�B)AD�d�<úu~�vQ�ݽ�^ iޥ8�1 ���i�C��,,,�?mdv�Ec��:U|ԗC+��~�/s� Y`KG��r3����:Ȏ�(n.��j��Ƅ�l��tV)���k��U@�\��:N�|�pNY��>L�~�Ț�~��~����������-�%4)Ɠh1��E� �E�[�o��-yR�����,�]S�R{����H�1�Ы;N�s�8i�w�V5��:h��V��89��y�?���Ns�6�v��`�/��^��(F���� ����(\Aq�%$�&Y �w�"o7xkj��ڿ�g�L�Q"����%� <���NZr/����ɚ�V��æ$��K#XP��M}'F wm��g� 6I�nҸ�A�P7�5 �G�[��7�.��*:�ح�<���)(�׽�I�I�`�`� !��$F0Xb��'_O��9 ����8��^���4_�����ڸ� ��EF,;�ͩ��Ͷv�<�U��\\��$�)�]Ƀ��ٮ�4/"a)n��uZ�٬)I1��娶{��[l��vKA��M���Z�ӧ�h�#tm2܋�PF1 � ��V'����2�D~�"0�0h TN���k�Urb��w�����.y��?������0�2��]q$Ä��pl��TmUT`	�L�1z�D/��&�����M�{߾��
ef������X�@bF>�D�������d����qO1B�b�!�E�/�v�$�L����$��Yũ�}Y"7TľO{��.'�R{_����0��wzD�JU�����������"L���sy�E�>��H#�z��0R�ȥq<�q!k��7�HBd$f`B�!�d��+�Aje���7P��#(��b,��S�, �0�#Xh��Q%	��)w]B�Cy����-�_4��?q;�F5r���~�}��2��E<���V=t8d|P\�a�F�����ѓuN�����_=�l���LS���y�]�Tm����Ņ���ݶ7U���f1��xP��E�o]P_$�s4K@J��R@�C�H0�#0�O�(Ǔ�?�'�R�n u���J�.fzmuϫjID�������-���@�V��68?���!�
b�5�$ M�c�� ��Šʚ�1��}������y�;���)���t�T��ֿ���1 @R�V�?XY�)N3��)R$?9��̅�S�[Χ�Y��)�×�;������L���`۶lau���1�O(�lt��6��r�lG�����S����<��m�?܂��=��ꡫ���	�yeȃoɧ8��kF��.��fA	�(����h
�4�1
Γ(�P��l�\x�<���0�������#dg�|��W9߀h�w����mt#��ԜL���{����yˠ�Pzȗ�����S̞�Qm�����`�3�������II�����O<���v4T! ���<g�̇��{h�TW�.ɘ��&Ճ�sw�E�\�J�ㆍ���B#ؓ��=-�C�����B�ˏf��g@ 7z,��u�23�8�ǁ�����j�.uŦ����Jj�Yy�\bH<�{xFߍC���p����&�FR%��?���W��O�P'/��M���(?8��ѹ�b>\��"J/�.|��ǯuZ��UUHQo����Џ7���[y�RPf�q� d.�6��V��0\_S@��D�;�z�����Bb��9Y�e���C���`��wa2�@���p���O��}~��L��1�����B�}�E�t^�<�����M"E�V�5�#\��	�g�y|�K��bE*!�ft�Sp�W�wl�?��T����;��<f$X~`��?_E��e!O�k�qd#�_�	�X��#F��E�[Q�!������uy���sU,���0�������M~�����h9Ԫ&��C���P�v~1f����	�:�86Q��&��g���c[M���q{wMM��+3���J|x�T�dm2���=��N�;ާ�>�
0!���S"/a"��W�҄�/B,,	0-�+�?e���K��.ߵ���	��r
�ȨF%��g�t����fu��c!���H����!�}��R�df�"�c�`�^����"�N�}5�A�������C�T������}�������~���� �8h�S	>2�)�a,�����]֝1Z�����Rs�B�4������E���q��P���x�zR��4�8]2ݱ(w���UI姎v���;�^��R3���x&�]�L�M�)��8僷�s_��!��W�-��a��4r��N���`����Q��>C�[�|���,V�_���"YL��ߌt�޴��7�mJ�Si�;C�ix��9��o�-Š]Ƈ�H��8���mZ���,}2|K�^#�����RiZ��v�������La�-� �E� �GI
c&�$g0 �    �8G·�L4���:co�&�!�y��n�([t�o«^��_�q?JK���p)پ0ԕ�PF�p_Sk{�Vrk���C���u�rm��9��`�1<d�϶�X%_�0��Ȣ�bq�Z#�l��`��`@����8�1	��)Π����=e�Ɔ�{�5�Q6��yD�Ԍ��M�y����YRb��ꡒ:��:�N���$l��ε��n���k:;ɶEJR�Q�vM�AY��"i⡘!+-����F��2k���}�Q��J�,J���x�<˅W_��ٯ��g�$|�:#|�7]m�Iaj�Η����@ʣO�Bt������Y�¾e����E1ݖ{y���n}&;qL���cc�ûQ~�
�~GRV����*?F�PX6R~�47�by�PE��p�0?9:\b��6/� lŠd4�|�M��` 5[*V�I(�?k�"X�e�Eԫ��jt�vGaFò�"�'w�e��^���
]/kZ�~�[��)ķ��֠�5�g�Ĩ�_�m8"R+��=���G�컝F�9R�(�"eIf�O���x��y|�9���G6�U���{��(ʿE�f.�r�>I���U�JN�q���8}INW[���|��+|$�i�ue��4fk�l��k���1�iH`{wv�&�̧so�]?��و����~w��W��'.���s�o������[��N`+�����7r���-(^q��5=�^�I�����Mm���`c�Y&�5��3hK�w�t�^R/a��3v��{�g�(�E/"��ä��s��ED����!e�:�{��D��!K�&1@߾qR��R��~�h�;Đ��M��������8����s7jq�4�K=
���E����二�s������JJ���	tLK��y{Z�7(f�$ �#�
s��������{7�����K ��65���$E��'0�SLe����N�y�S�e:�׿���jWqR��X�f�L��s�:+F��P�v_�3��f����w���Z�8��H�^��_�G��s��E3 ���D�U�MG�z�����1?$|)�{H6@���H<��<a���&�!����0��MV�(��}���c�
3k�P3?+K����V�V����H3HE^��n	Z�����@L�rcM (Ҙ�j, +��+9�odr񑞊�q�qF��1�X����J-���D*FE�IZčU�i� "h��0��HH�0 �1p!�{�!QNb��-ɴGE�9�M9alסX��IJ)V�צ���iݽ|�
�`i�g�=�<����s<F�5���֦���J�7��4��H��f3͇�Z6}��A���{��OE�F)�$Q� ��o���	9(����߉ð$I$�����b�#�Ĳ&�@�{�:��nϤ۟��/e��k	�!�����i�ma~�k�?_\;E�:��ѕ@����(S/���%�1�HG�� �
[M���uii�Ugur�J�Y;�iq���<��}����{f�ۣr����s8�LXo��s"28.�8O�OQ�v���&�lQ��s9WC/�e.OiraCJ��d!��KaCT���-��*�1?or��m������k����s��� 7M���	�(��kzd�_�-+r�x��-���z���/�U�O��d��I`�a�"Ӭ(H��2��)�f�s�FPh1�#���;�Vs��F	4�ڸ*�%�V	��5^O�N�f�`-�y��;��SId!TK��v�y�p�&Qa�j֛	�*��ߦ&	���j@YD����C!Q���/�T����b ����$�(P�<�b�n�	��0%9�cDpY�Hc�N�.b�H��j>��+c��C�ae�w��^95&�@���C�3Eظ�aJ����]�T�q�h9�SA�I�aU���0���&�D{��^Mt�G �lM�i������{��]���4#��8�N� �H���CB
 \
�x��$�&%����������f@#_�xc6({�������mL��`�⏕��b$�k���aJ�?������Gf�˦��{���✵f��ԭg+��PfyX6���zٯv�Ãm���!;�hr��\O�
T�U��1����$Ǌ,�ǀ��(�=�k�	���,�.�C"R���<�O����,��[��M�n"ј��W�_h� ǫ�hJ�x.�7����s]oC�[C�hn�W�=��@�n/�7ĸ�N��Xg���a�����&K��Ҙo_N��r�D�����m2��q@^=�;Y��@��-���?@f�f$t���G3�E���u�S)�r��fzg��ث�>�x��w��̼�1u�MqǛ2�@1+S��3���d)g�~z휣&���cQ!�����<C����d�d�QD�Ѐ��?Y���%�N�p�^�FLο7��5ѷ�NǾ��vw?:��b��Xh�;�1K'q��0�N�UՅKK��¾S�H��ͷ1�j_�x����Wྏ�_��������"a�|ˆ����,�@�rEj��`�d)<��2#RN��γ�,�i�J�%%o#��b�P�7s[2%󁆁Ec�BU����@�о+&���������i�^356�y�F:ͮ	��|�Z�I�Υ���fԣ�\�
z'?�:��H�O;شX�ү�; M
�~pfYx=Fp�"b�rE��T�D�grCW�9�'6y�Z��E�Uuô.�{�zS�zj��`J�e�T��$յ��zkȘW#*;( D����ER��k�][�ĥJ���*~ߠP�S�} LL.i�˲�p�#�Lq����V�1�g��^�%�������ʢ�;h[_3�ֱ��|\��m��K5�'~���FگA�X��C�R����,XY<���k#\�y���V�+r�:����K]�c��۲k*���դ�'�����s�5��qXKi���:]���8�!%�!%�`@�"
� ����z��tB�^v#�{�L��GXs�[�����X�a��D���W�j�!F\Pȷ�Ķ�o�mg]�V�k^t̬3i݌N��I3�<6M?C�	U_^���GͰ��G&�*g{��4%���C���9����$�L�B�	����7���KX�D����i@ ���LG6V�@햼DE�t*��K'��t�}�N|E��]�i���qw�σ@
M}����"��KК�p��J3*dI˹s���WK/}s`BHߙ_��H ������3&)Q�$�ɣAY�S���]⍂��o�[y�͘PV?t���i�ׯ�ݢG��I1�����z�갸~��Ӎ�\Q�p#:A���^��B��!̸	�PdA�Es��㟃̎l`�Oi�uwD�)��mt�AuU��EI���gc��q�4/p���s)Mbh�2��)��J�������b%$��.��n|w������Լ��>����ey��~�'�(�r���z/6�UlT��~J�s�"�f0�v��.���<�d�܍���
~Q�<����YN�y�%ߗ�~�}?ْ�G����3v��/.7Į|�x]j����p�b�B�Sm�G:6��}�@Z-̌��0\��	�t��8��8x)ޓ�SU��Gl�Hyj��$^��=�o��U����]��! �'�1�U)���$��~/��w5��>�}����ڞEj:��Z"����l�tB�}kD�i���	m��7�PM��"u�Y�O�s���>���?	�^�����B�C���Q�6:��1l �(���#L|�S �"'a^���wy@7�����o$�"| � ��8�H($2�,�@,G�G�8�P�p�O�4V`u���U��Ҩd���)<��A�/�ݐ��q��[c�����/��������WEX\E�v��1�\���z�z���B���t��,�W,��5���t^^� ��^��S��(���mT��p��LS0Jg�Gu�S5�t�O�DV��E��YC���蕻?=�}F��e�=��3���Xz�;�q��̼�%�l��    �⧹y7���hvc�1;���.�hq�\�9��
c��U�
_�[X����dn�	�L M��)��L�h�2D��ў������8���S5�V��~��~������X[v[^a�\h>)kE�s����v@���\�����۹`�����h�T��R���M�jކ�F��L��	�q��a��>{cgc3�F6����e���e�`h~WlY���B�ۓz�~��2���*ɕ����^��^#Bá`�]�W����:�t��Y��y-w����eň ���t+S�B�}:5�*�"�mx���>�͘Ķ���J
U�����7tE+�ǆ�>�h7�P��S�����J�ugr��Z��)��fMg~����r���9T�<�*��ow��FL���n�}7$z'
�cF�TX\�S�X���>ߔ��eI&�Q�L�"-`4e D���u��N�Ga�ۓ�wҬ�%d��i��5��G�v��i~�!��gq1N�š�Z��6�*�`��P�[��K<�|�ץ\c3u\:#K�ʇ�Q*%�Ƚ#f[���yV��r�Ԩ�b8���9J�p��	��Vf?����+S�w!�
Ҽi��{�ⳉ�e{�z_���n��S�I�A�{N2ڳ��<����y����r�a��E7�JQ���o����ˇ��U�;꒎���6m�F�c� �k�aٿN��(�Z`	^ ��x�P�I��c�G�(��?�U��������-����7�GhD��>�)=�j7J'����~V,í�3�Z,|�w�]Mf��v����F�Ք�\������Ե?������?����'��.d�FL��o��`�'�W.��(����%MPd�~�%s�vM�.�Y�N����<k+Vz��"�8%i��R�U�]�����pRa�~�q�S��:-ƻ�����{۔����Zx��	�b�ׂ曥4%כ��b�C
����U4
�F͢A�9=�1՟o �W]Y���0�I@���ЏjF���� �mz@r���]�U���lMl���
�+fI�f�>��=��Q������e��DZ�V������`��a6=j���H[�����GZ�X��9�٭��	�x4�G9�R���������^�u��*��v�h����@6���Q�S�	΂	�nujP:��p�2&??�Q�t�冟boh<c�l���evĻ�y��9��<�GW�ˊ\u�!���>�L8��#�.�����m�f8�$�4ߦ�@��`�������Z��c�I��X�z��k�&�~1��#8Ӹ(y@�3H�p��u�ǻ��u��k[�^|�#C�w1�w�j��Q�R+�6U��~�:�D�F�}.i�=�}?B�i�Ru��#_�O�7���_
��MF~���$eH��,��Ƙ�O{��]�4"���5b��z����K��i��C��Op��j!��M��%�S�R�&�ɦ4t7Ա3��e�QC<ֻI�����Sy�D`��j��8�~T�?����8����&_���>��Wy}+�)���a�"����������흦,F�0��̔��t�vN*��]�a��qc$���s���A��+{�\.�.;Id��8FC�<��>�G8'�ʄ��z��֒}X�N���R��&���aIVN��gkj�|����6&�b��-��y��y��uv�0�
~eI��o��)�bt"�9��7��U����r��KT�G��hkMQ��6U�=�^y���zB��
jc�� 0�kb� (�N2�4�tqJ]�G�>vj7s&/�3��v���N|��|�z����.�<t���	h'������bI��4�cxB ��Q¬��
�#aR�1�58�Qy�@�P�Tn��N�;\oOq���J�`� o��q���]��A�~�$�&����Rڏ~�}-�g3�&���!oO�]axs��O��h�����2/	�}y���~��$3<�h meI� �xpIOҐA�b�V��\qZ/o��J�Ĭ��7����v���ݚ�~�ش��Da9�7��Z���ϑ���{��=�7�$�R}�'Ie�I�{<��y��)9,��Q]a�aAބfϫͿӗ��4���A�@r0D1� 4 (�����q�'W���[Ӟ��ݤݥ��ߋ�+�\�-n�kY������d+�������l�>�`���E�������Fc�<6���T-=���R���_�y���v����h8�w��0ej��&
�Ԓ����%����ۤi����+ۄZ����8&��O%�ٺ�Թ�?�mO(<���^po�����$c���п����{�+XA)nE���}�~�����e�����3�B��N+���<"��x��nkޣFy��	�=�N~���a�@��i�����gE��˝�����?�Ľ�4;|�͚�A-�K��+%�v�qY\8�k;bq�։�C���v9���F�m��}׎�\��u�� ��%9�l�"�1�d�ӟ�������'8�	=�ޘ�ZkA�*I�A��0YG�c���g���8���qZ�e�.EbF%XM���zj�n�D���Ô@0�!:���]��1�9Lx|	2G�]������ݲ�o
��Y�g�
ʬ�6}Q+����ir7�Ń���`S5�����lb-h*��.����$�U^�����9N��zۋ0�z�E�G�:����Yи÷0>u���K5�i؝_���Q����4�$V��xT`6�~��xb� ���Ã����݄�r��j"��a�6�F��8(��T��^<�=Zm������˃��d������n�Ľ�	� �}~Ocj���K����J������[�`L�Wjl��5�B W4�!I�$��߭/�7	.��Nu�<�#��|��a���[��S���V�Τ�#b7��篈�'��C�������M�6��P ���.�@��, �����r��Y��2�͋�(��@��!��h��� �1�GBx��	�H�;���cO���1"s?ew����"�<�(A^g=�{Ӥ� B_�5�R�NSg~�zR�S��5�LJ1��{��
%�[�K6�;��	��j�L-����L"�8�4�r��$�}u :�Q`����� �h���fώ�
������Ωj��nY��t �7��>�RF/^yk��goq/l*��ȶ@��3iGJ�&&E��C�>m�c[��^R@����̶r��=7��>�0�T� t�~�)���*�O�¸/(K|���/�>}�0=[ʒ�/���?P�w���I���Oɗ��D/�Ek4�)��p��¯5�$F;!T�ǆ��ɻ��>~��Q�R5i!�/f���nq�X���[4�́�H2~,��z#̰^	5h���u�27�HP���R�|��>ӓ�9��:c�r��F� q�d��%J*��@Q��Gե�m���9ډ����|4xc���-;e�;E7�{ّ��x�Ky�� |�p�Ba��U���>��������Y���8��[���=�
8{�,ӧj�d���^(�D�'�}�ƬqR%Euu��5Q��6��5BY �d��F@&�?E�Շ�n�`��i^F忙����	]���U����:�.�-Һq�!E�M��zc�ꌨ[<Ҏ�ߕFo���E�M�G%\�2�^Y*|\���a��h�C�� ��}�j�4��r�����#LFU�e�t	
�=Z&<U���ֺ����RS[7o�7k����+oܱ��`�L�S��=��}"["\Z���3$-a�����k��[���\o	�鰓<���&�̙}����G9 �����W��/�u����j�H���;y�S�������߄�����sc����ۧ���vk���9�|@�;<z����� t��~�M�A7�!@x���E�9�n-���q�Rp �������\����ل���TM����}Y�c�C�����K aC��ҦD@�� ��B����7�գΧ�:y�9�鿦	��ʊkk�1wNw�    ���>�Gc�f���)���
����
"M�8�j8����C���=��[H�/�1gI�7���fX�<I$[	D\�f�w|t|io0�P������?CU��i�!�����U_PH�a	&p
%Y��B�Ӌ�z>�S�+���.��ژLRN��Zd��{����@zQ�,Aw��$�Qj$;O�\#V5����a�
��!@$O-��/ze�e�C�I��sS#@���LV
�����C�HA �:��0�`	�����F9A��DX�i H�7d^#+��?Y�NR���a�ị���@^������N ��Ɏ���#����7��>1]��#��Ѫ_j�-7�{���v h��IYJ� ��H��xw�]�T�[/�|����������<������"9�CH����C, � �E��)� ��8٠x
��;�cx֩���°81���
}S��߫���(�L��yd�d#G������!���j�s��uΔ,_��Y�1�H��@��E��av��������/���Ñfo'r\��)~���aFk���
܌���=Z*�۶_��_{ys���{A���I�՘"�G��_8��7���j��ʊ�Hơ�c�/�;|�u�-��?�����©�N<S���p��\���Fr]�)�rz��>wh��E(���R�Җ`H��i�knƊ�""��D\�M�*n������c�}��V�ԃ2��M�{)��Խ�_F�$+���lcC]��z�ߊ�%���v&Rp�]o	רiZjٶ��~W�d�CU�l��;�Z����_<��z��9qhS8�_�F�7K���c-Y�$�-7Q��?�Ҭ%_�M��_�.t?�!ƞk'���QG+�<�qC�ў�Ow���=�"����n�ņ{���|��w��4�W�i���,2:~]��N���̍��c{�=�]�L��H�����4��F���P����iN�(��,�-�$�cO��OMq�q��#�}<� ��wwlQ}�� w��(��u�|�p�� �ԆLcG���_�.�'Ch�0�!�'۷;͕㫰ꅿy�G������V��"o[�"��	5�_�vT��&(lH���Hs
�9��I8K�4!� ��`�S߸I�H�8F� DO��#�1�eJ�WU���fp�H���y��Ֆ(y���ܙC��z�h!�޶e�SJG�����MX�R��7}��mjsI�j�Íd~�ϔ��9Rg���eˉ�z�k����h�0N�L���L�|}WE�Eh
#�௵$
��!A��<�1(�P?�k����w��J?�h�g�!F���)J�t��a���q���^w�I�ݲ�ǆ
�d�|~�1$�0�H\���ͥ�$�{W��{,}�h t��i2�*�V�mC�Kd�Q��ǽe>�`I�L~q����t���*r@wa����2�b�XOE��=�C;������^*��V�R�ս�,OX�:!}��z��Kc2Е��/|B1�a֍rL�n�NF/�m@�[�t�q�6���"�Y�Z�5gQ��Q��"��a ��M�Cg$Y�5F��Ov](��O��3��v��J8�{��k�R5˭���,����w�W^��1|�e�]@>F�����5�;V��WE?+���i���Kv�OUw՞J�,����m
��t2�q�Ӟj��jȘ)�	P��47�d�!9�|���d?���L%�#$�G�|�|e&`ӯ����y��6�,�;���>H"T6�k;Ȣ��dh�㌭>'�X)�n�a� ��)� ���!�5�|Ra�H�x�C|n�-��ס�>�ݮ�3B;ԽJ�iۀ���m�)��`�A`�$��19�΁���Yg���TX�	�����Na���m�����< �P ߅�y¡��g2������t��S��(�<���%F�(Wr��ʈ���"�c��p�B���9�������Z�\px���G�
0��k����E�(��Lb)���Ke"�>�	v�N#�wc�ڟd�cs���@u��#�Ć��4qC�;u�M �S֮p+a����Y���Cj�t佲w�M5BZ^�L�$*����"E7iΡ�� ��Hz�:q�5T��#"��\����Q�h��EN��#��z�>P�6>���/a$)�w�Z��6Q�X'��_��u�^�SJ�;2�v�_Bic퀫����u�÷$Uu�xqg:�����P���YÎ��m8���z��F�s�<�y/˽�(i�c�q�������,0P>3
/� ̐�u��f�	��j�g+�3c�=�1�`
%��k`���?����[H�%4?��ݿ�)b�P����WFB`�X���$�Ƅ�����P0�~g�4������o��Yz=FO��=HCT�A��z�|�����A��4E�N������6R�8�#������!���H�3�s�oF�H2�Y|v[�y��P�
wh�IgC�a��E����R�
��p:�8�Q�{٢,N�'7f��P��т�����eʸ�.�[ȼ�ҩ6;sXD��Gy�'1������2ó����� ��NŲUއ�T��ʗ�;���s���? ��|R@�9��ثB�Sܙ�E{\	�L-yh�+7�/�8�כ��LҼ����ݟz���~%�m��nsc��We��3���-��olW U�[�/��Dď�pE��xH��Z�I0q��V�P��)����D��؞��gޛ����/B�
:&�_��̵Y�" �o�O�R�*�"���1�����~��ݛ�@R�v�$�.��g�H����u��R�!(��Y��ÞR��E��䦶Rx��@"�b�n0�n�?UIa8SW������stv�&�1��`���ߔ"����{gv��@ti��dׄ=�=)�c��`Yq2��U�5���O����8ңeQ�[����r���lo8�x8��|�>���m���|��~+������ݮD����$J�$����78�U�t
h�Q�?1܀�zH�˳�i�\�d�b���(MwTٸ���#Ȁ�W.����4ٗ���g8�z��bE��)u�9�Q����s�5�+j;�eS� 4�{����uN�ͶY������w�T*�3�@K�ʿH���}�3g�G~��пv$vv�~�Fgc���2a��V6�7<#���������J�U+ng/j�{��=l��Y�vogH*�srB*���"����*�.�o&��-�����e�{C�o���ᙯ��FgD^VLI"%(@�O��&M|.d�[�^:��3�%����̽i�-y�n$���~�D*~�Z�J`G�`��O��ev��{خ���a6�
k�aX��3#����^4W3Yk�s���� �m�vR >[���'j9�p1��P�(��ΰ�QtN��w2�2"��=]Z-y�����G�ˇ��w(�;���+��\�h�I�e��c��օ��]�b4N�0����{!G!���&�!�e㸖��}[;�w'X�{$�d��r���L�֏����r)��dT^Sۦ���Ml0Sf4�]�C��OI�gb6�'��Z�t�U�go<6�M��ԩ>&�����Z�}Z�{+nZ2��x�m�=� ����/���W� a=�"�`�yݐ�-�\�:��h$��De~a�9R��U��y�yj;ܥf����/`l? �~��!h'�ƾ#�mh|��.��: E�gtR����x>�7E��{��X^�W���sV��,�h���IV��'��6�#��x��a��Z��� ~��/e�L%�M_����;v��~G?�ؓ�U }�� �A�|��5�PXU���u�}E�L��8�0�c3�Xe��pD�"E�Q�0�����B�w�f������NRZ�)v��'\������,3z�ҞR�H�g��+���d�Fz���4̱Ԏ/�Gi[��D!{��̯�SN�eΤ����oG6ƐU�$QLM"@Ġk�J��Vh�Ź���j��{p��axo��c���ڡ}ƽ�LgQ�]
��i3*��A]�
�\�n�^Q=0�`���"��" Q    �%+��~=}���'�Z��l� Sx�<[�p26=�ۢ����E�XA�5A�$Z�H|�.#��;}�\����>M���/���`��R�R������k�c��K)KJi4���U#��!h��.��r@��r��,��X��Ѥ�\"n3����p�?�v�@�,-A�N�M���6�Tj��4>���-w(A�JaY�&���8V��N��	�W�F����`��_��sc|��ޤ��w��@�W����$�|�v)f�V{x�&ZQ�������T+{���]�����"3�������axn�yKչ;Utɷc��ewW�=P)������h��H�$�a�Om�u�9��A�Y*������Ք�_���t�P�bԪ�k7��N��T\/`f�Rp��\�n(�=��������k�I,wA��F맆��x�L�G�*
��!��Bo���{B��'��)��$����E�hV���5Z����<}~t�M���Hhz*��nδ(?&EG�]{�$�Ib�S�F>?����铹k,;(�{~�V\\�q�Ƹ�s�����=y�q��HUl �8����R�"�.<�&�:��Ўa¹�^b��}dA���S���:����8ĥ��Ӧ��#lv�g`�ῐ����s�n��)}V�U��'Bӕ�L�,����?�r�-��^$��p�n���~9ۖS'v��B1���Ou$�e�ى�E�9�5��	^�Y�80<\����y���3�?4N�T�Jj�6���M���8�#Ⱦ,��J����p�2�Z����y;�ހORW��! �JV��X�uoGL�\3��@�d����'D��Sv��;�{�I����BI�y#:���T�sU+�;�qrb��b��_�?zO�|�,����&+���G:�!t� 73�Ց��&}�yȯ�k��|J����-��F=��{#:o�y�Ibp��W] ek��J���=��w�B��%h���^�T�}\��na��� �M@��qe?�`�f9�^1:BG�L9������Px�e���h]"$�ת�V��Pǀ�Dv�W���_���<�M�0��Mtv+�=��$2�R�͠^GɈ2��OEæ-��'C6�' 2�pK�x���5O���Mfg��64�A9�U}ó�)����'E��L�;�hi0��/PT?�'�4V�8Z2$��XF�?ū���m�S�H�~T�(�����F#_�BD�lS��D�熅_��o�d��ש?H2��kx��*B�[�q�AŠ�mr ��-m��J}����'ƹ8������a�֥D�w����� �����u�Za��\���]�s������g�9r|g�����9+�����6�vQ��Om|��Ă:�����2���܎q�����B�y�g��H=������-�j����T�&��D	J��}Y������a%�-�(�M���}�2��!�p��Ԫ7�|GG�{��y3��E�j��s�H�iY���!}�TmF��jB��
�a�p6^���8ޙ���<S鵛��B�9/��������xK\oz��%/8�g@O���nF�/�J5�@������K2Eb�w!!�}o�}��А@�O��/L������y��閺I,���=��h�;��7� o�W�i��� ��PO+�v�R�[VoE������)S��f4����S��.�|�V(��ͧ� ]��F�[����&���j����t.F�`$И���@3����������΄:���D�MH�F@��i�Kh��l����B��<��2� ���1PO w�C�=�	�:�Ɇ
�Y=.�x��Ќ-���1Q�0f���Dv��&��bD��h|}�)vv8<�� ��@�h!9 �@�aGp�n柪~�H�&hq���<>�Q}��
ax�u=g݂�l�1o�\�
����7;Ņ�3�j��n({;w�8���o��4^l�A�@j	FP�l��!lf����H2�¬����#��U����'fG����lQԀ�}	i�l�S��#}֋Cߕ͹�J9���R<���t�����0��={v0���Kg�:�Zv"@�����$s�zB�H�GYԹ���y�<����yqD��OS�1�K����e�#}�^�o~�щ��O����/�~�11����$R� ለ��AҐ�(Ρ,�
�O��V:���.{��\2ÿ�J�x��aC&��Z+[~O=8��C�&B�n���53(���D\����~�-�I��Vq<�&�-�� C���L��'mĔ�J��{9ۼi�;�wk?K֞gnԧ������`"/
���@����AYǵ����7�H���=F�z�JO�b�>�;^���Ĉg����U<�t�����a��a������iJ�{̿iW��D��&KqV6�0�B|$��~�'�|4�~��)Yd���b��(���X]�y�pE�B���Woj�Lnq" �5��̵�z�X\�vX�� 6w�e�D"�5([)�X�y��)u�X�
ܿ��}`#rQ����α��#�	�N�T�_����R���_[}^�i��E;Ҕ/T���J8��شg4�A��xM�$�Sv�mq���fc=�d�z8`+s�*9�5)T��a%7vCWk� d��5�Ieg������
��a�g����)�8/H ��i�\�b�z�������վ�7�&.׋)�OQ����*Q��8`��]�5I0Hl�V�ɓ*���E��f�� �>=��!� �sO���[��hO�����iG�j+-�)�_K�Sw��ŌϘ�d�D楫�Gdn<Ӓ�����œ��Qj�.������LN��Lz޻H <~��d�Z�!Y��-�0*��m᧿�̒0!1'�_2g-!������R������g���ג�����^��W��>�S�t�9�WW�!˿��y>��G��2�tm�-�Z�q��e�O��U~ͭ���CX����p�2�yi�ĉm�7S%&?��_�5��,��(�B����Y�C�K��P�ӏZ�k�PG��_����)���1FM��U�2��ٹ�@���<�G����h綌�my��C⛷�U��M�M��ݮ&Q�����\���?�����6���FZ��3�}���i���x��ٷ��Q�u]s��\�	ݒ�1��oTŤck�ԇl&�_|Px�Ώ<u|�L˵:@F�����:8w���EŁ�G��1~�B�z�*�h��h��I��H�H����י���(͊���r/v��嚐o/㝅����NR4�p(/B�Ġ_�2bp����%�A�~��"��=Ery%�z�+J�S<}'�>���v�MN�:ʸN,ŉ�h�;b���6&b����k�q�Q�Z��G�qn���/���v�Vo���t���OAI���vݿ�)N^����韯o�]Ď�D=ጀB,%�@FQF �w��O��d��[���)n�[4�Ͽ��fWA��g��kfl�O��������tw�h�~Y��2�<a�PU����_��X�3u���dY|q���p��o&e���`}��Y�p�X�^�ذt7���A����X��d���������̙V�9J�W%lO(��Z���3�[bu�a�މ�V�

���bo��{x�tU���
� 4%���au;�GN-`k-v�ׅ�K��%BD=��V�6rۋЧ�9���	1���RZ�A��Hl�o_w�:c�
�J�yNV?u���2�}t�u���?���{��%Yn�<WP���j���?<Ry��e���@EQ�a#���-���7.�="|�O��F,e�������j�oУd%T%�R�Υ�U<�C�9
�ퟷH:�f~����0�D�ad�}A�`dmG��{���<����N|"t���Կّ��l���|�f�X�C�Y&�����C�{��t�a틯�ҧԒ4zϹ���>/-\b"�ǱM�V��P��yx4�%��8y�@�H�E�2ߧ  �)��P �5�����2�W��!�m�ן�1�m����epP�    V:���G� c�g�B�6<�@����I���\���٨��y�{X��`o��А��Kײ|�Ƭʆ�y<��*Q����1���������5�]���|[�l� ��	H�8�� �$�GP������p�!z����DC���;)d�1��/f� ]��P|/}�/k�����N/S��*�/�����.O���͊>dZ��!�XX΀��L������Ҁ#"%�Z�E@�c�3O��7?\2� ��CfTY��gS|����.瓁j*Bn&l��v��@�UM�x��B	]zwosA6+�P��>�}�5s7�"h#,��'�ʛ>U%5f���E�[ceg2
ktg_1�?1��S��PNM��#e�4ޞ�f
+71wPR�� t#ϱ�e���o�&&��RN1�0s�<�v�M�7��,�$�����T�YR׍��O��YK�N���v㦭]UA%�9Uۍh��{N>;{�1e�\��]�����8�76	 E�s�z�?)�h7WZ����_m�/�����.���q� ����B��#n}6;�;���}=[	��O1Bm�'nGV̽�v��yG��P�#y���I�P/_��Rl�v�mI�>V't���GS7u>A������9����Q�M0��{KOj1�k�h���k��ՙ5��Ru��m#�>����E�I{���t��j�:�S��	�e��\��R�C�B�@=Z>y��Q�Kp�2�7ƣ_���r���F�P[̅��)��u���m@}S�\ozyh�˺�B���x�z����cJ�?5�����(L�?5[y�:�~�m�Ĕ��-�=p�=:�;����>�ն2e8���@(��}(i�O����ƃplπ���U;�%ߎ"�/�w޷�j�����D�s�;�֚B��-��}�qҍ�+/\ƕ�3g@�R a������0��Q�R���~�!�AI�O���91%r�n���"�K韡�K�??bբ���������5{��3��.�Ed����&'4���>���K;��I+;��[6������{r��ht�c���[1�~��|�,&�d�W6�;� ���)����]���w����D��m��Lo������^�g�lJA���lI�&"��8�ٵZ�F#ڠ<�ve���(ܘ'�����V�܍[��=n'\7t�g
qQ����8>�fV�Y��Ͼ^��
 Nz�/3 T<@������j9\��O��|�)����p�y>ʿ�}yi$��7'�85J�/�^[�3��L�;^�c��*K��7�r�R��@��A�Je1�X�{���z�(�l7�"�{$���j�N�%��˄��|-8Pk��+I,�b�a����n�f	H�h�0��#���'�`���y�)�+�-rD$|�GG.��~HF��ss1�BƎ�zm�Ռ��֧��D	���b�s�f��FCR��F�H�-�]7�X�-�ڨp|�i@KcO,Q���/� ��/���#4BPH ���� � !p�c(������.
	��@���Nn]�o.^�1��vBK�&�V1D�F�C0U�l�P�(A-��p���\�9���c0q�� �L�z1!��^kF��8�F+\7ܯAV>@�T��y�-���=����!?�ݸ�H<.H�ixT�p���bH�0�)J� ')�%\�V�s�)^I�i:qO7|YpiX�A��E�_s�%A7=�dx=�k��d�	�8ɢ�u��ȳhW%� ]��)�E��d�[�D���ٗ�D��qr^�a��S������.*�M ����m����c*�ݯ۲:Z�W��Vԧ����xQ�XNе�u|�����XP�M�H��K�ƕmw���jf/������e�Y�e)U��i=O�qY�ܥϙ�
|$_����H�������S{����~�AP��������\�N���.ޔ;��i�e�����y�ehRH= �G-�"�+F�r��$��;2���4�dGV�,$�Zߏ=��^��Ey)rA"��:���..���\!T��Z�����±��h��]g���tXb]�ſK�`��W�M���C���v�]G�&�Y��R���E�����vx���D�V!}_��>�����d�O/K��Ř`���ke"y�og�������j�m��h�ˁ>�@'+Y+#�$B/ɰ"7R���ψp�D���?t�WM�h�S�&��i��W����8?�:�_s��WLi�'Ⱥ}�w{�JIF6���,o�.�鐤JkE:��^��L	�"lpS?�K���{+�%zC��7Y���MA�����t����0]��g��ޛŬ��/�����;�iJ�@9�`꿝:0�k�Ѹ "��"�DpA�a�|���eӻ�9_q��e�b>�5�/m.34B@�X��,N�Ȑ��^j��wAU�w#ɫ�e�J�e���#��<})֚u��54|�x�a�\�E�JB��ˬY��Fa6{ �<mv=~�% gſ+�k�2Pn����ӂR���9�U%A6�UPE]�JO��}�W�p�Ұ���-���۽̼���3`���/ZmY:�2c�DՕ��˅U!k16t���|�e��V�N���J[�"wR'uT�5�?ֶ�z����������K
΋�)~�r�N�����v}sҿ×�-*�������]�>��Z��z���Ŏ���@b$�{���<Ys}I��������|��ג��{�Y�E]n̝�x�%�1��sb����X�����H���Ŵ�J�����N=�����S3��h��<�v#�0�&	tr�(�R㺨�!�а3����6��cf���q|k�yP��뢗�դp�}�=G�v����5����$��2�d���\�L���"o�MN7;A�[!k����b����mRCp*C�����A�	]4O��Is%��q�o�tR���*v�WM��w��Mq�s��J��Hu�"�;�oY����y�^�15E���}4��h��7�55s�$���%�T��#	�YS=M�a������6b� lПo"�*)�B��������2W���������?C����.�ߥ�>CB�w�����>7b�]DL-��:�G��O	9$���cI���V>�
����hB ��){\ZtlLuӔ�ebK��8�k$�f�������8o��/N�?�ן��b�|g�K��r�QC>1�v�a��&��I��Qp�t*VygE�To>�x�Qr��U#� >2��F_�&1n�����7�����cH�3Z]�ƺ��/��"#7��ΰ������,8}qE��6����Z1;.�#�O_�8gY"���!�y��EA �bxP�&�Y��d��z�]�U���O�(�/֝��E�ɎҀ�^�Dگ�6F5���*�����M{Eb�Sr��u��F����D��f�~�M0r�4��jÞ^2����Н��m�En����ۚu�)���/r�u;�"������_Wl��|]�DH&��^����uݥ�gɋ7���p�'P^?K7�T��11&�ٺ�is�eJ�rDE�D��E���t�}	�ZRF�?bU�L؝�}���XY��q���@+���d��oW 3p7�ϱY��w! �Z��װ�!!!��0B��@��O��r!�� ���!C&�*��G�)ř�g/���&&\E|��
Y��er�O�{�|j% �u�$5g�V�&��a���lW��#��뎯����`�+�F�3x��|�#L���p)5uV�߼��|D��D��pE �I��Q"0��x��i���t�THiD�_s�yB���u����
e�, ��.��F*sT�PH�_��[]:��*���j�D�*�&�9����]B��
R��j`�^z��V�?^��z(Yq�n�1�\/��/fS%�+�P�)�b ���+��������y,��3[x��.�bC�$� �s����:٣;����A�z} �M 0�0�����ԃ=A��T�,����%���g��u)T�w/�پ�}����8��p    �.ǶX�&Y�٧�5P#��q&��=�ԶEa����Қ�!p�̻gB�+s���nlnuh�uF
�9��dM9,���n�B�,��� �r�^�	�n���ym{��,��i��������/�=b��(�x9�q��TY.vϴ%�����5����n�;&/~o��p���DQ\�}ݮ�0�E�\�%p��mY��rN�Iķ�<[#��̃�&A�N3��Ig�ab� ʖ����5��|~0=�w_e'b�����/��d�6����@n-
Eo�m0�˙���@Iq��>��J��lO�Q��3�V�ٱ����Lx� �bw�.�O��Z�El��o�0y-���c_�	���w���h:y�Q���p�s�eƊ�2� ����>R�y�)��S��f����	�-��W��SO1��琕/,���yH���A�Y7@{�מUP�}�Ȥ�i���&a%�qP[yJ~�m��S;���4U��̘�{���4�02.�XƟtQ��H���g�H���ƹoѧ����T�g�>.�#<��i��F�Yq��5�Qd8�T�A��[���)�b���w�۫mO�ς-9���8������q#�k��T�)�?� ~�[bL<�`�i�߃�����mR:;O���x����>�܍�̼�!R�������==ظ�v�{�kl�>�w��Zr�����Q^6t�)�)[� H�1��9� 	���#�8�D��� .���M����0 ,(��P4I3x��hB�(�2�G&���oD���Z}��-�%�f�׈iNs����,r7�|2�&�ũ��䠴&�D<�bw�����ym	�(Y"�����E&�����bpM����w��d��WQeJ�a]Ii>tǊ�R`Fw܇�(��p��tL�X���O��,��ϽΛ��W��o�0��%z��/�4i��o�|�|]�T�����Ө1@v�@�p�4��H�]?�΅`7
>�i��xa�l
����F|����	�i�#%�����5iņ����ڜ�����c(��`�s���-0� ~�s"va�9ń�`�Z��y�hu��t(	��T���x�'ʄ���iC�YW���NqiX����g���0�����P/��o�+bn�ս�I#��<Vx�Ӕ��;�{�w�����Թ�.���1@m���
�@�"��>��&�)�z�������UN�ߙ��ҁ.���CV����c��ٛY�R�5��&4��;~W�x	$���BJ�Ng|�C�L�ٸ�{����k�f���*��W�"����5al�HŃZ ��ȟ�F�	"s*C��2*�7�h_��{�Ψ�{���y�#$J�ۍ��H�<�k����O'dW��QV[���1�iL,��z㘍<��s��1[���=Ď^4�6�ĻW�^�`�F����g���ɢl�Uw?*ɤ����;J�9��gH�xA��}�s]�ش����[��6����]���>δF6��������ރ+<^���L�v� �ǃ$H��K9J��?Ϝ�m��l�m݅���r�qUM�7$�"��f��Rw�7���׽}�����o��o�Â �οg�1��~��l�Ij��
�[Z~�U*��{�HG�����.�d�l����L�@Ľ �>���D���v�������)��
�#�x�v�	�ét�*%'|?m)��M�fZ����ت�j2����<� _�=�05`�`������K8�ԇ��_%�μ�0���m�X��4f��ԙ']�Zf��HW�����YƠ���4�J! �F��J�8oD����~ּy����9Y��5gn���F�W�{x��H��	����Do8`����L?�$�����Oao&�a��`t�"���9�Jz0VJ�u�}.<}0RHLk�ɍ�2Aerޖ��0��`^��N�K��'g_����A5S�5���[)�r���c�l��gO��-�K3��9�`����SgMzk'��Ϸ��(��EN�d���O�EL�$�k�y��=qT����b���WC�+[ڣ�I�yǋi���i_
H~�|>O�8�|ρ؜�JaƠ�0�w ��N��[	�&H�K/�گ��Ì!���#��7^�B1 7<Ü#�f�Á�޸�c
�(MӜ@i��ɣ�7���I���ؒ#��zԦ�l�ND�\:��ثWP;ʙ��Jd��{��w�����Sū�gs�P�'<o�MV�9���3�1����N�SUD�o�z�H���z��Ի�׬K��%j����v�@��!3�DRǑ,ϩ��y�aݝ�<h��^��E�]>�%5w8�$u_��+�7?}y��,���2>��g��8�؛:�7��G��zUVQ�q_ ���_o����ғ*�%�Gx�=|l�{�b��ʼj���j:�I�?���M����Q���KR��q�I�cA�Ep��� %| �&��W���N���[�'�^8i<"��8����N�D|uI�=���S�m'�^6�[��9|�(��$����NraV'"����)ss�w[���P����^�>��E8�}�~�Ro��-cH"�	 )E�O��]���̈́��CI���*�`	9�u���]C��|��t�m�<*��-��ۧ�@F~<ݮ�G'7n�wN=�Z����d@�(2�׮�%i�nW1�1	�s4UF#��}�Qr�,-h�������[M6ŋ,AN����H o�;Q= ����F�ͼ���њ`�t��z�u�M�C�����Q��ѡ�]��:#�C�����3x���$���W���!'gX��o�¤珢uō�dʂ�$����>�?������)ͤdF�F%1���þ�N�^���|]�UŸ�������m��.�s�x�����dn�J�B,�X�A�f!$^?R�!�l�a�ݏ�-�"4���7:��ZEt`t�=?aRK�qg���2�_I���;�O0�߳�1NaA�q#Է˟�.i2kn8������`����s�o�y���[_���~�Z' �K�}7咱�,h��g)�zqԷ�	ӵ9%��)�&��<��������<U.�&8��7��!��ٚ�M�+�z��g���`� ������P���R� �!	A@aB�VJ�H�Z���õ��P����l�K2�/F���>������X�Mv�1�B�zk��kͣ����w)���gXj>�?������͍>�U4I	n1�[ʜ>��%�B����r����o@tE����JGR���gF���(���-|**N��Q��S��7 ��:3��خ.�p��,�����T���]�jk/K�r�녩f�\
߶�o�5�ލ��~./����7>��'/����=Fn�%���w± �o��?��kT-T��G�m8� ��8�� �)����~E���mn��l�>���s3ij��'�al��V�q$������t��Ux�H���]Iw&ks=�k��S[4me�N��*�TIRq�~0���t�|Y��*$l���O�`�܃<�F�@26�~`�Ab����i��O�5�i�7�l�@��w�䯯S\k�~:d
�����L�rK?V������"��n�e�Jβ+�L��2t��	:x�O��I� �ӵ�M�<Sw��Mw���w;}6�搣�qʣY���h?�0�x��qJSp�d�&?�t;�ǖz�%�/��p��I�W_˻��D��a�}A�����i���N^`p�1-aC��B?��Q�I��*�=:���nw�,N)#�����廅�u�C[��~��3Jྱ�M>X�e"&�$E�ķ�%�t:�
2+(��=M��.X�s����`�و`�9�B"�ט���/v��7����'�w���KE�B��頉�ˢ(�:D�$����D�M/6��R��r��6��|b$0��mQ��vc�Cvwc�2i��{�'׷1P��Ɖ���d)<P>�py�2�#�W5��@��w�A6@,8���T�E,�P�G;|������^�-�+S��e�$�    �x�;"[q�kR{5�;!:�T�#�9d���g#��������6h�H������k�?=������H�@0J@(L�N�ߏ/�^��ĉ +�8��p�q�Y������[���'��4԰��Y�nJk�F�V���da�ɜB��%�NW��˚�Oج+3*�J��-��,�H���/3����Z�%��[ڋ>I옝ɐ�pΜ���)J�U}�R5��5o�Q�r�8�#��J	Q��;�ǂ��Y^bq�d����3��Y5xϩD�ԍ��q�}.G��L\Sn"�MΊ܊[�k��t�qӻ���}�Ƿ,��!`��i�_�`��Vҿ��Z�M�v��Qy�H�m�[�6f����3�� ��"���k��ˆ:A)�$���Ӕ�)�k�Entt�B^dXTq>�Vx�O�n.�0[�$�%�{��&�߆׭�-��V&���"�[n�P�}�!��<��H�y?h�4�S�,ә�xV3���^��tzh����қQ�
��4v�rr�J��Cb p�A(��x�!'a��껼0I@���z����RT�j��m����?���L�y�1C&����ZVu�>�>��t�����ц)���]+Gd`�Ї������qE��v�L" YvVL���R��D�xo�t3���8[�Z��zZR+���o#%�!�D���c`�aX]��u���^hs���=�� �vq����J�ÄD�Rҳ%I�`�^r�W�����y�t��L�r_%5~ p��Ƿ�<:]<l��iL��u-���YUK�s����Ӷ�󪚧M�
p�u0�!�8=�3&G�U༘y]r:E'���(�o~�p�޼Dv��Ȯ۫at!����P1�N��=�q݄o��^�A �����p�B���<-߮"��-�����ok%q �.g�&+�$݆,��U�U
�%�U�h �G�w���C1��@	�mM]�'�xq���Z��k�^~�@�W�����́J��S��Է���A�擏|��eW�PU�H7��Z��A���H���]�Ǟ'�_3��2n{��I��#�)uǘZ��R�1�u��ݰ|YR���0����^~����BR��~)a\ �O6����� ���f�!�����\�"P�
Ał��<_��D�>�P���W��F�`)��j�b�!S�Z�x�k��kO�|��H�!�׬��|���<�>+լ����'9Zߎ��c�����A���/G9�#H� �1̷���c�Ë���{]�Y4�w�Ks>T}:[�b�N	����B�9�O7��x'�˪W9�蠭�=\�7*�*�U��ϯO7��I�~"!�^#8�٨�*(��M������(�tD��8��w�5���n��F�8�1F3�O����e�cY���'��_�p1�Uހ��g8�[�@��1��M.c��μ�}J�k�8��̱�끃.$�CS�%��FK���;;���$v����&YdȰ�u�l��6*+/�f�8���?���ۥMNr�(4����)�hj��K�`���f���r ��&�ڬw�\�VMwa_eJ$$Q��Rܿ^�S#���;�.����ou��(�ho��C�D��!���m�.��m��-o (�+|�XY#`�@�ѻ��̀�^_�0<�J��M����2��<��2�>\��W��X�רW=m���s�a#���	4�<W�Lي�ǽy�1m﫧�ҷҜ��Gk�.:��9��u#�'��6.�J,t$�j(���r��@�BS�t�>��W��p^&�}�
Qx�o	g �9B$�1L��IL$vX�$+�q�}�a�9�y��X��I:z-吋f-r�w}]6�z��:�V�;a��q�:���oU3�ns�ν�3Pf�o҄��,�;��ʱk�IeA���[~��N��#y�X�[s<�vG��$�y(#����g)�Gy�����];��|�_����8z��5�����>y���8����q,z�rx{+��A�;2����{�W���v����LX���8�	]䠨�Wx�鶇F�}�>
���*`���S5[$L� �2,R 9F��4�s�']�Gc��ב��R�y����6��ˉg����?�3���s�mE=�E�>��A�T���m�ˢ+���^���Zh���5�F%WA�V&Ķ�z-"~ (����A>��q]IH7�p �I��#``�hd�c���w�`�O�|vvfE�rQ:�r$��S/�^�m�Q/��Z�n�������̾�����4��U4/ҷ�2ﺀ��M�K�]���2{�:g��Tīظ���o�k�u�9��*����U.d���_���T��۽�[t����2�:&�OXǔ���cDա�y���"�*4jv�3t�mT�T��>qx�[���R&}<�'�k��"ŷ�̰�nz���)��7��[� �)t*|Z���6���������pvg��ل�#�:��L�0��G~��&a��P� ��T�-�c��z�>�E�%��?{@7-��}p����4/���0POP*R�Rkt��Rt���pTh;[n���"x|8���iϐ3YeǾD���Wܲl�������7�i���4���_~]+`�@��'��E���Y?��x�7]A6w�#s1��3�R8׼��:��j^��pʹe�E��e�7X�ײ����D9 {b�Ur���P-��ⅲ��|*��A�:m�AL�Tx� ��4m��[*Vp�F��*h���~8�r2��ȋl&�����y��'��S��ˑb�Ax��P�% ��۾�;;��D��zB"f\��TG�sx�Z7z�E��fޭ�]m��q��1v�.����es 	��y6��4j�����\�g檑�C��G�����)	Icp�)^cJ�a��_L�;/���w�w����)w��r5ߒ'�T~j�pE���v�y�A�Q�!N+t�һx�FhR���߸��y:g���k�{��c;-?�غ��$�/�o�T���A�p����P��@�b�F�?F�o�´[�ۦ�\-�ŵ� ���}�@���%}��1W������Y����]�Am��6�c���|b-�&��|��g>�ZdZ���O���չr������S"�������m�-=ĭK�8�hv�t��"�C�� ��(A�Q�k����"N��`<�d�s?����vo����#���@�Kz�2'�|K�l���cY��&�B\\�d|%x��u��Q!G�E�O5�w�[81�����E�T�z���/�q� �䌮��2��7��oY1U���<�� ���c	��Np
���l�0J��T�m�+E�vQ+r^o����<���Q�
����3h2oǆ�.�s9lq��<\�Xԭ��{�'�5Ae U�1�4��Ϭ�_<D��1
�p3���[�uPL`Wv8�+�z���0������Z����Pgi̗j�u7����xzc��(I,�B������'��!
D�~�?�C�
ޮ����K��:�pne���Y,��+U�P��01���ֿ_��]$F��WƀH�Iza�)�!���N�t�d��<���jQq��1k���^�����]��u#�� ԋ:�&�������v���kgnl�Y�Qj;�>���v��֒nى�T9��N���E>G6��{�t�J�
ŤM=�}&��^���6W� ��-p	�MB!I��x�IJ�?y�|��Z}X�i˳3"�߮�
�&q�E��@7��,��(=���r_"�Y>��j��V�Gq�;�N��%�UQ^�F�M�#���y����{t��%�0���Ϫ|ʧ(��$�`���z$���[d��k�aϻ�|\7��uPpu���by�w�hGϤe����9�-�W�6pڴ��e�ܟ�����>]=�ڷ�9���W�o׷zK�Γnz�9���w��Q�A�}��{���̝]G�h|T�m�dM��·�f��h�K�������N�ߣ�������d�Ri�(�O��ټo��Ɗ��R�}ȳ�Zc��³��"�n��    ��k8	��GF�y��E��L�f[��騐�x���<�`8l'���p��*��� p�}�w_r(�h�qq��!c�2���b�b~2�9�#ڻ
�,3�k���C%9��r��D6_��7��l��]G���b��k0ꭽ��1�2F2�;˔E�2�;$�M�@wj]�]�N<HL���h�q�G��d�Y)��W&���)�3���ȷ^���	�����TB ����D���v���w�K�G����>�������5�^�0!�"Y��w:+����cc��"�O'O����IH��=����`�U�}��r���,�$)�{�c�,�� �M������т�O`.�����ax�[�Tp<x��K���[�~˯I/�6��ź�N���D�X��������0�NE�Fw%5°�}������)��c�I7O�S������z_l�fI_Ȑ z�����_D��B ��p��o�"��� zC�cE�9E0q��u�}�k(�<�|�:����Z��dv�r�����S�b̗��K���z��ݻ)��Cʼ�{�	4���;�y`:���pף�uPVr����!����⼷��7�]2�6���0'�H߱��:��e���,��9LfH�}��"P�gGо���S��xi��\��cW���v@/*�O�Vb��Z�E�;����%X{@�AsCЪ��%�o�7nǯ @A`ڂ�������f����)�J�B_�5���(KIܶ��o���@�uQ@� 3�1�P4��i���_�ps��"��F�ͯ�9NO��R��2���R�@�{!�ʣNM����m�1��Rd��K���;�����T�A�d�A�QE�S���-ek�-e�1��ϰ��n�Xԧ[YPn���R�Fp�%� ���h!!��$��9��蟢��؋fU,�^b����W٢�v*�ޢ�	=�~̻ǗP���4��I���E���y���V>���了X��mC�.���1���6.?��}�Z��w����<
��us���K�z��i9�=`)�8�����1`���`��'O��q������������oc*�kT+s5����K��κ��p�yK�rM���2�+L��MD��~�X�o6�T�m�� *�LO���6��G�,�)�8��D�����.�-�}! ����H�S<�4p:��1�"�2tB%0��G;���x�a��~�����5���'"�T�Y=��^=R4N��a��ވ���n�*mu�
G5ꝲhM��gA��#��\�-��'�q���=��2�}\�L�����2�!���'��if~��v���,S�#)UdNdߚހ� a�O�?�Ҿ�����-= Ś]�)~D�9���|�"KFN���@��%��M|q��_�9���J$����2���-(��*S�n,Tn���k+Q`�U���;3E�W	��-fHWq\�8�|� &�<!�<C +��@���hs��ɽ�JyaP2Y�W�~j@|l�9Uߺ�y3�
"P�+�X��;0\AQ��^L�d�y;��X�J�5e��pF|���F��y�Q��>������f�99#�eE/1AK+��S�B|��kG�;��X��$�|��ӎ�;k� x�����;�0\�>�����&u����(����̌ ��+�`b6�G�?n�'D::Kr�Aqѝ�B~���&�i;E��Gϥ�i�dz�Vu,ܙҳ�������J�߷�L�-��ܷ� C�&X"P�P�a 'c��zP����'��}R
�߈Pz|
����y���ĘZ��(^��i��ѥ�SjW[�&�?��л'����[.�[ ��6ed�a�.Q]�HJ�˒�v��7���{�#��>�8\f��f��طQ+A���H4ῗ�  s$KA�a$�xV�؟�-}f��WG�n����o��)�2�	����|"V1=�]�A��m���
��=��S7���|����R��`��oQ閈8�#����kJ�2,�D�ܦ㱴L�3v��^�
u=�q�K��lޅ6 y
�� q�ia��	���w�g��:=�h-�����(�*KiŘ����`ܳ��Se�ƢT�9���'��4�<���J�"�[F����Rj)Q#��_^�{B��\-4ǜUy�������݄��_U=�ڛb	oh���v�(%F�$���&ς �ƫ��>?��\��_��hISl�~���c}�Z�H�Y����5�x$���$[��o����sy]���`}�ߏJ���5��SY��3(n0�{gǡv�gE 5���M.~��T����|p$�1��aK8�~�:�h'�6 ܲl��_���q,�n{v/<"5ǩ.Ɨ��WI#e��8K�e�ac���t+CA�g��6l��nFņ�3Sj�lEi��^��o�Ć�:���-梂��hQNHW�'�pz<��)��t��4�)�a�,v�H
��{��cP&s��H��/jbRx�N�5ꨆ�| ,�d�*�0��W��Fvx�T�	��*��[,7ca^o�z!yN2D )L�o�2���b�)U}᳅ts� q�GG��D��㛙�Y�?���b���s:M0�{��[�7�Eq���N�&����L��)�%�P/�Q���Tcd�+��ҙ���(��S`]���Ap�	YKV*���v��q�L�l�M�\
ay︎��FA�M4u[gy�&7G�1����1�-�\��v��m:��HJ����#(�S���)���0��v����{��e��6U����E_�"�kI�{���-Xq;�������� P-��Ǫ��ݒw��T�>��~50!�!�w�^��.~z�{��Ө$=p���m1N�BJ8E/bl���K���~� �L+�� ̧e�L��>����g�������n�v���Pÿ#�;��Ag�X��l5��^�����X`X�涃[}�D�)�]uF�{���u� K�>���D� �J����3!�G�k���v�"�J�o%� ��O��'���Z�P����WT�y��j��Q��&t�~�Oa�j�eZ���ҨY�Y�Mݞ|�_6G���ٶ,�_��i��g9�J�C|o�<��,�}$?�вu��Ț���R,;�-��M���G�"�h����{�x7M��C��䡛�{S&�]��c�|ܟ+�()?���N�	�x ��+���^�՞Ȁt�4�]_�����>'C0�Ue�ς�+�8��\3x'6H�;pv�G?i��D�W-��x�� ��	�� b���ޟ�3O�X��a��V�|ʹs���B����	�,�b���;��?�^Ք���DU0�cw�C������k��>]��'��v��}�?�1�{�E;�p�.VNM�^M匷lp�n8��+ܩ�V�h����G��N��LJ��%9A�I�rG������]ȝ��@�`52��^���<m�;s�Z]C���$�{R59��&.��h�Ld�C��H�XJ��iaM����Hԃ�����E{k5�{?��
�n�LT�6�~�|���@�:�UשZ�&�#X�x�'I��L��A��ٔ)�;���ۍڽ7�7^�����y�01�<l��ty�|E]��bV�����Ɂui�'q�i<����T��v]]��2u?�3*ҥ*�Ҷ��ע.J�'%#��%�!zes��F���۹
�v�x�!X��8��"(-q����?yp�F�2���qh�H�.Ŷ<��9����Y$57"k�̩D��3f�u��u�d�f��<_�`�o1V<��p�E��i}���
)EO���
��oN���M�v� �os���������D����E�NȂ̓�H����9�-��{�2@!��ܿn��CH��(Zw| ��XE�b_�r�O��v�1��mv\-�/�RhAdr�ظ���X�p������qۅ���x�����;��'�r�������iM髩����$����|�f p�$H�����'�?�긚��87j)폜�2�>)tؠ�mD|���;�8�    a���G�%�c#�G��qׯ��F�Y�A�b��wLm[�L���<���W<�x��>r4�u�B��TyOߞ���k鴤cO�|��Bi
�)'�4��\�"���-�0�>)��,��CxO>4�R��1�i��X��~��p|Y�t� />ou�!�
���9G�^9�j��l1	��k�.�)?�g���j�By��>)���w[���h���"��t�9�G�x%��!	�i�$��FJ�Gc$RD���������.[^��{��YY�*�b԰��[[(8�I�=��Z�4x
+Y��L�"H��3	��vhk�'��oY	/,��9}�9F�Jp��5��&Z�a�&y��1}1��� �&���x����nW��a�����"�#,���4���\,���G�v7�u�S�mr�?��>e��=\6Yo�WRw���hZ��VЈ9;Hrd׷:�o�)��#�,�xiG1�#i��z��O�G�E�xt�����fj_��mf��ϸMX�4����P�E��!�e��U)fP^��9P&VD�!}�����O{�룼%��Z���"����x��s��_�"��3��3��CRa/󜓇vۆ�+V3R��hG֭
����e�p转{��ϟ��[����H-��2m<wdH����$A���bY^EgX���Y@�{���sLN4��2�{�\��{�N �'~�O������Nm�6�_}m���D��^�������|�cI�;>�9�_=��[TE�v^+�/<����z��U�3xE.���}���?�x�1t��G�ߥD� 1�T��	�ζi��#Z�������A�
�����.%��8�S0�e�p|,�΋�B��(Cu�?�9�z��ϒ"ao�bZ@�KR�{^��qC������v�P� ](��6ȩ�I��,�F���,@gz���/=~k�P� 
K yA�XT�!����$`�ğ�r�]�P]$�O_����8��6�,��ㆨ�c������<RpI�cU�x�!v��A��t��;��	����ْ�-��-i&�G�2�e�W���b��T���#�� .��|��"���<�b;N��"�R���G��w�n���<0*��~� )Gon!��Vɮ���p�3�mxl�l�)�ơ��}J�_^ۍ�V^a�H�C���&I�m?y0*b�nl��ͨxN,�.m�*nw��)_m�'�Ї�T�W
dV����	0x�'��[�I�h�'d��穌8��Qt��n�ԅ���8��S^�aH\�f��:0��#�t��Qw;�K���/�͑�{'�BГ�)R$��[z������4fJ��Ȉ���XvvĤ�!�ް�kR�q�F�ނc߼t�Y�=��k>e8���#����Ƀ�D�PIޯc�aI�HϔBxf��w���ӊ��Q��@� $S_�q����6/l�\d\�խ��?f�:�M�D������Q����9=��ٖ�y	�=rd'GC�f�srC�+*�V�j_�NC�n�)��r�B�2��;G>���c�y{��[�:鍅!��C�� � �7 mꪢ����_����`�����aU3����g遚a��� ����r�!6,r��c{(�Л1��3�+�YctE�&��,Ǧ3�(��(kv���vWqـ�<�k��I���pgĞ{��;�U��(�8���Zag98Rn�߇_(B�8�� �%� ��S�P�j�aX�bY^l�&�R��,L���A[wҕ�W�D��;�ݲ�(���c�Z�T��T��Q�QU�x��Hb��(�9MqRN5[?k���pOލ�=T������Ɣ�-b*�ب|�������%���e���C|9G��@��0�"����KX�d_�Ż:��dI�,p%����"�=����ڡ]�v7�乡є��~5��,���FX������F���BTT����y�8�����](�.�Ʋu|��Cs��;����Ej+Sz�L�e�"Hb
$���p�k�STtU����I;�쌴���o%�yT7)A"]�24��g��kȗ���Fo�W][LtyO�'�Uu�ש� B��/��n.o��u�F"�G�G�e�C�l7�?s��%C/0�,�X��/��?9NfD#��%
������O�@p�=M�����D��IK?�V�Msv��d�J=���d��jT�����+�V��M"�?u�L�+i�󓒸�&+UstPNd6��l�Z"]1o羈��,��������.��������3/�
'�,+�
���Z�XU���gL������Ȋ��:����D�$��X��a>\x�FYfa�ur_�VybM���?�x��n�B٤����xԭ�(�q����}�Dن���� �(��l��a�E�$&��*)�Z�U����;�0v�l^��4�n���V�F6�(|����CX-ɻ+�7l����V|�[֟��"*q�������J-e�4)���N��&�5qbXt�E�:"�}�S���jX�8�|��#�y,����*�o�3Z�fɈ��J�	g�CD�Q1����	��}&�6��~iz�w�~��{��5�@�x���Æس>>�PyB�%a$|w� ��m���Ǝ ]�c�� �.��� ����øۚE������@�` �Q��$�/����%V���I��sͿ��sy������/a����)�C�xOۭ(.�h��{)�'		n#��:g��J���ou�[�%��.G���.�U�oȭq�8��&:s"06�� �k�;�&�R�Y��sMŌ��ϡh@6�k'���d�#E�3B�1��A��8�­p迌M+O�\aׇ�t�	O�4�uӦ)6D��`$V<]MlA�Hc�ms�ZfQ�����F��dB^�`Z}���36-&���쐆�`a�3���ʆ�y�h}w�̕g~e`%L���l�Y�?�[{��F���|��
U����K:��*��!1gC��b?���tjbqr�f	� ~����I�D>���D���ϮQ�ݾ��g�?��m�r�!Įq�I�����sI9;(+��RorӖ�F��4�����2"D���C���O#ΰ�O�
��8.>��<���Ϳ�+��hf=�|���
I�h��ӏ����'|ֳ�ޔ��i�2�6�}En��SB~��&���I6Mk%��CQ?k�޲�t��H"�Y.�QQ(�R�d.hKQ5bA"�,,.CI*ǉ��E�9�6r�����W��_Mp����M��X�)Cݗ�����@8�pמ�4u�.��4��}byq&�'*AR\%@�\i�
%M��'H:Dr���c�C��nB6!A���.�vt����U�_��i�0��DD���b�!���CY��@=#	��)��2�T}���Jm[\���k�2�c��� �hCF�О����4�M|s��y
�&�{,u�{*}��=���*�ҷ�:�ߢ+.�g��ɠ��xd�%2��#�`��h�\c#��-^�qMˑ}����}�ݠtj[Hvo�.毘������,���|(t%��Eyd�6y�o���ԡh��.o7���rӣ�]�a��&�=�y��v���ijf6K��g ���l��t-�Җ��撦n�{$�}ńtx�I`귢�0��8U(������k�p��7�R��w����,͇N��4�ݠ�11�ߓv���R��톟�����w����h^2� '��>���O-�}8B���=2io�-EsC�O|8��̀�6��hN��FH��3�~��1P
��a� L���OU���{�ֻwT�u��l��͞�2��,��W=�Ùw�q�(���� ڄ�X:����b�׹��Nh ?��[9Q��[�p���071��Q^�Ƽ��5剽���zq�I��x�W�f=/��F�����w�gN�0J2
��mT):t�]���h2RoV�=�{� ��ۃu�0�V���&aZz�6��͕0@�����ë]_F� �;�Ĕ��i+C8�o5���ǹ����1��    ��jvgbsT׍��p]*F���'ֹ��@@-�Q:5��5S�F�5��>���{N��?�O��e���|��[+������ѫk�`
%�d�Q�^c�T����X�q�9��	w=�����B�R?��Y��<7�	�0-�Z�r�9>t�
y�����=.���_�	����};�?_�LF�e�����O5�KW�:e�f�������mU�k���ɇ���|�� ܞ���[�Rw#m3�f&Gm
�2��l�[�����]��yIW��d<91��hfQ�gP;�k�E��Y&�	�m��)���ͯe�<�2�x����YC%Ja�O��xi��qa��<�d���,���|�(Y��ǉ�u{=�ƍ���"F�=Sz%X�¹N,2A��C#'��x���!Er�v;<SI&z����x�o��y{��|�%���t���zp�TG�^��������=:�Ni�s��fr)�H�h0=q=���<cUP�=��V�@| ��o�pD�yt�����+"�N��_��*��*�����)���V|�O�P��!��ؤ=�,�8��$n�{d���z7�U��;7����4�'�;C�~B~	����B� �rD]����l���b@S|�iN��
K�3����J#�i�<��u�X��Ӣ^�;gZ���TZ�vR��$t^�f+��kt���ME]6�l�:/d<�M���O�͑����Ęw�e���%�@�|��E����A!q���#̴��?��RBL����o�w�S2���|�؎��piL?#�4�Z2�ȭ��^�����7�w��¹J�f�|p 2Ƥ"֮�6ح$��F�]?�:~!�ؐV�W򖹘��~�&����	���N��A�ӀobP�H���Ϯެ��S|���������Y)��T�u�r��v@n�}��en�Vww]ϻS_7�g\O�Ϭ��q�a�$Y̅WI���[�(�D���^ƶ�6���6Bh���$uR:��c)o�aݻ����<b�>^р�1�h���� ~���/��&7���w�rh�P�P�V���9�m�ˬ~�63��D�6d(vT{�,��Nl���B��p�ʗ�ފ^@��#�kq���,˛��a2Zt!2�v�#g�R�<h������x�0�eu� _;�h ��}�Z�f!��S_�:�CR�H��R�g�j%.��R�mo�S��rx~<�f����y��� dO8V�Q����(♋���!B/=f��X���Y^8��}�d��)���`�t���4D�(X<��P6L��"E0�j�V,�Y~�y,B�%��ڬ�F�ֲ�W����ݴ\۶P�w-~�rm��!ۏ�:�W��vʭ�A7KxO�F�?X�S��<����멅�m�����ϴ�{�L�i�����"-�«F���U�����_oa�Ɂhω��k�k�V^�~$#�Q����X�n��7J�^��&!w�;^jE�&򣺠�һ���	i�԰�c�1I�q���1_D^�@�s{/���F����돛H (sf��9د�"�d�J�y�fCܷ�iXn(���{��/�P4��Q�LF �S�wE�/ϋ��`��]r������O��*��?ە٥�䞇����5Rb���$hm{7�6Q�y�7��4��ѕ	(�x�j�Z����1�hI�y>�U	�������$9Y��F��rCN�k�ߓ��xc�~��������Ԓc�A�D� �7�7��5q$�2@���=*C4�����q��6��]��<FbG�\�߽�'�L��$O|d�y�}�k��շ״SRR���˞���F��������jn!��y��5#_�oCl�H�����)H܌�+�,�����5�]j����F���Fݵ����oc�T�DB�j��k7�$-s��������Lf�A4x�,�	j �b�Y����Os������z�$c��ܺ����E(i��Ͻ�)��H�r�C>2~�G���j5���4�WV�?U��T}j�N�Ys���Ni�U7�-|�=Y���N�'HK��>��w_x]#	W��a�n3�`�Z�^=�ܮ�Ў*^1��F��r��������Q�F{W,c�AE�<�x]��`�x�Z��d9�gF���w�����Ȼ�ر��1
���6N@T�F�,;6�{*T�Rs�}7�M����VF�-Ċ���z���PH4��`���յɗx��E�ź>��S����c�>��+�t�+)�ؚ'�J`癟�(Q/ H2(P"@I��OI[�m̀�9/�K|���{d�:^�!Z�o��xv��=� ��%r���5cᱢH裐��E!\P�;�L��U3�/��2���,���t��5\?{�?�C�m?R-d=���h9.};�}��N��h~=�3&H�*kPe���~���w���{����<����g.34�/.���)�>�?��o��]\&\zF	����l���+\֏���PGR9~|Mx�"�h�W8T���pTM�7�.�3�m�v8Zc��# ���澋IAE�����DN��-+@����b͙E k�eTU����	�"���Tw^w��Ȩ�oS�!�G"_!C�D��@����@k�9�^M���*�j���⠗T�5+�{y<��������S�$Gm}�~Fw
Tۘo��<���k�#$(L�9�S�Myf�=�G�>^�w ��Rܣ�!W�1G>,��2�l�����	��Ս�����@��*��+�����ft8<�1Q�3���¢�ԗ�xǊf~���'��N�v�n�qa�X�fٖy)>U��;�����1D�Y�Z!�����]�
=�Sw���׋�n���s�,ф���hNV��r����^��f)���q^D�D�xM��z�ʳ��[�0t��ke�)��&Z܉�h�Yy�R�t�0�BX����e���]���씡1	�[� �L�r���0e��	$%3��|�N�}���]���~��&M��VX?���ҽr���P	矱P5C��d~Aĉ���~k�7���%4�@e*���͹��bV
��N��R%}%$.���a/�9Za�9��_����*����
f`���/Ls@�:���{��#>�c�C��і�q�쉛t�X�u�	�f�����B�(���`<�9�T_UE������وk�G���w!�,}�2z���-=�T��cC������YV*���q=i����hK`E'E��8�Q��X��#XA�!x�D��Fߊ6˃�!����:מ)4���u��A?X�w9S���"ӿC"�Bm�z8�a�T���/�^%��ȗ��츹p�WD7��0U���6�f�&U���玹ߏ2t�ƨ#�瑬��/M?��q����j
* �$��xA$��Y�?�7'n��N�z�T��H	̉�d���ACFI��!�yA�;Q��!�"���f4�=�Ї ��=��;w:����z��駓��^��-qkR�[efT&g��!툽i�+o%}Z!���=����~��q�h�F��)
�s�ʕ-�O'���eF�X�5y��(�E���K?Ԃ���B�p�o��0�5�a�׼�#��	~��{���2���j_W`=f�����ڸū�MM��c>3�2�,�tШn�����y��OІ��q>��%�eU}H�@j���A�e֑�L Ǌ��ʫ��-�}�.�U'�R��+�W��E���*v�w���N������}���<�K�ҷ&��m΁�D�'̖m��$�6�|������*4�2�h��+mw��_� ����,I"�����7��\t�g�'B���p�A�>�:��+q"�D�QxRLtٛ=��d����L��V�9��V���n��%ǅ���Ϭ��5���8�	����Bͳ�搯壥����o}dnR�1�:�/�N�'K� JdUQ�$Z����)�䷝̏����o��S��;�kk�t�;���F:���J��+sO�2>jX�C��4�ۆ�1K%��P�9��t�R��T�Z{��    5÷	J�VhEan�sySt��n]��h�6�Y�����R��}U!#h�5E�2M�},�s�^�z�ot��>�W�¬��ߣ?WS\ZX�or�3t̰>�ʲ��/���ٝPRʋ{��kD��p[��◊?���!;�>���C��������
^Un?	!ze%�֦N�y`������dh��Y	�%��p\"�K��C	0��0�SWCwyU��9�UF���;X�g��`�6�@~}"�-�׽qyUcu~gLv0�-$^=1,����h��=��3�
e
"���#���⇻���tcr	+�����r/>\��R4m���m�^��5ETu	3Rd5C�ovu��^�����K*�:=�h�\�5|ď�S��i�PyåO�zpn1���#�|�6,`�y�ʙ�n�;(�趖�R	����/D��S�\�v�ȓ�%n�l��Sie�xh���~X���� @�gU��Y�d0��?5.��k^aG�:��x6�PHz�|���9����q��k[&2
#��f��Ta4��3�I�y��D@���.�"�G M�6;0e�ߞ�$�f}N� +a����AYo90�2��I�2�H �_�ׯQB�!ط��(0���璎	X���1�_��$��gdA��{�6�!�K�z8��_�r�ݬ��F�VC�P!�14��?�����BsW������뙳���\���Z�\:�ȥ����1�+;\>T�<�������}�J]��P�s��������o�%,#_$w�k�f�`�M���7���޳1E�g��<�4=���J
)���Q�2݊AY#��������4m")�ƕ+�k2�c$s����!g�����)'z�@؀]��N�@�a�u+2G�Oj�!p0�p�wdE��?͂��|����������p~�XpM��%u��~�cwr�Mc��\���*�6�ޱ.������|��oy8�3+j��*��S�M��VuV�h��x&�`�/N?��XWh^WE�c9�m�/��{_�e��l�F���2{7�
7�4�����F~E�����3����F��2~\�����mC���ͳ�T�Yl$�a?qi��@�ux٫�ض�ƚ���W��RZ����[(,S��w� W�g��i��'��f5��Y�T�����ӽ��(��-�����P"P]陸J�s�ޫC��h)���,
��ƈ��_r��V��s�o�Q�1��b� 0Tv_g0E��jg��%�㡹hx�0���1i���O�����%�.���۲��T��V���wT�>hW�xzޢ��{�����9 ӥ����n���[5��{����!�{���a�̂X��q^�/ΛW�n�Ö�D��&5k���g��K��h�+��%��"�c��u|����)-�&�(O�c��Y��_����˛�b��V__~Yq)���������]wNyX�[�wX�¨�Ř��7"�@CV�h���@� '�Cw����l�K�G�J�&4���'Uك,�����
��$2M.ޚ�4�����#��B7��_����[��qB�m�é�=o	�Y������y�àA3/P>V��w3kG�� D<����z�&��Vf����(���*��"�֎�mf�wN.�O0�e��̈́qD�cf�&���T?0�EL O�f��b�啀r�	�2
�S��O5[�"�w����*:s��
%ˢ�F�%�����vpC:0bj�	���?M���=��FA9o����
cMǦ�u+��������V���^Be���K�VXG�EI�c>J��c�ν��%v�ubM�|[��3��p���z�zߤNyS8���@�3���-
��Lz;�h��Τ,�`��|�j�i��J�&OI�����������f&��6b_��CS�l�wU��6�ݪS�� G+ߌ��y��f�?���YH�_T'=KR(��8��0`j<�|��Y��peH�%��e]��U�IK�Cj��Q�0,�f�Gel@X�Pm<�=�nO�h�P������z}��=���h��^���U�`4�e<��C�,��OgWuљݤ�L��_d D� �ı}��E!��W)���}�C�|�� ��� 	�$���P�k��&��y����c�[|�j����NBu��t|�F��W����,$u��@���Ǣ.��y^;1�&[��-M���wK���i.�uI7�g�9!	PL�6�,Y��+��q�#��y'8��E�14U�dF�L��r�b/���A�8���*n��>�{k�Ir��҆[�fC��X�J�Ə(�Nu����TX6���(�N�Ps�~�w.������#��yb�B�KP�8X-B!�y�X�����l<X<`�Q4�9^0$U�?��]|�^H��n��RQ��@�Fd�'��
Y�>�=r�W;���K�p#��m��Fܚԃ�d��h��k�O�п��N,�~>
C[8���ti��V�\~Ƕ��x	fj��x�O�~RUA�_�D��[jX~{��v�aVz?��|�Q���=��1u�oR��irh08CH�̈X���ݶ�u��-�|"�(�5�v+e�aD�������I�ar�� Pk5����'̃S�%MV#t[8��=ڰ_@Ib?4]UtNd�J�e�S\P;�v :�֙R����p����?��f�P^b��k�H@������r��o�A�=�#�m�e��aN��.�T0���s���Uf�^F�x}ev��3�+{�K������x�i���M�.DX^gR�0�	VŸJ.��gk;��V�?�Q���CZNz��g_��j���:��
���FX���<ᆍ���^�ӦJ�!f�5rTg��s�Di���O*7zKq���<��⻘��OZ���6��%_�c���|'���0Z`d��X(�$�2=�	څ ��V�?��{'�</������w�{?����9�{�1Wuގ����7��Ǜ��Ȫ��	�D��̩Sj-L�X#O�P���f�0Z��h�����IG��<yt����پeh�Հ�-���諸�;	Y3�� n��ܘ�*���6�ͧɝ�{��'��&�9�t����/�Q�=�^ӹ�]*��Ku{.s���E�.�Һ*��V�~;���Ԗ���>ޒ��=��<_d��̥T[�\]2(<T:<X�w��S���S�8V��S�GIʽ�'|���1���5&��uE�C³3D�D�ջ�Q�A�%`��B>�}]6��*@&���_q"d>*�����rË���1�9��Ԯ�p{�pg�g�xm�\�~i��6DjL��af#d��M.��!_��@ͥ��Q{��P�n�̒����23�%�d(��dYj+e�V읎��G��(�ʩ�-Pom_��JEk��-c�q�{�����Moo{Q4��y�ӈB�b��$sѨ��*=�ڠ��LQ�	��G���@��;�&j�&�ͳ:� 9�����_�eR�3��٤��r�,z6�n7.���h����x�c)�D� ���Q?)ZE=\��z&5�zow�=Ԩי\W�^�)�x/՘#@�0�3Ay�f;]���b� zt�tI���<	�	HZ&�:9[1 ���n�E���2�%��D��?~/zUܕ^8U���lh��>���J@�ft�r�@Z���2�h�W�9x��c��[����dȬ�R�Q�����3�T�]�D��/�[�!sŮ?���͗�\ߔ& ���y �S#p�dYaEI�5��ЫL�<|tg�� �/�nҐ�fv��r&'�W٬y��ѱO�?(Wŵ���	X�=��s2�j�~�2��I�i�P��Q�}A�q>E��C�E�$�l�|���A�*�n*}��ld�	%	����>��)>Zg4J�?��(��G�O"�ͪ���d�s��|����������bO���%�V�t��� @��;H����M�k��}?��b�:N��Su;ūf
�>��O��%�MsNoކ��FI@�h��
K�(�3L�P����    ¯�OȔ�餣o�k���ky3_�-(E�T����=��]�dRʶmr�üY����k����1�""��7Au�[�(��ÓPJr#S
�Tw�z,F��8�2����	p�c!駫�����諚ĉ����D��)�Q4Đ����|$���&�I�(��D-�3����SV/ry�Ԓ�ǎ�k����Fr��@�+�*�_�7(�
��26R�տ�Õ:DCR.���ޕp�/���K۩�4�ً|�d-2$���߯�X1Q���Ԫ2����S��V���E���'�#M��.��@R���� O v�爂J삲qDKX%\r�;V���<c����O7������=�*����ps��v�wS�4ͱ���7:��h�^2ޟ�x	(�1�KP��bIUeUe9���9��G����Ώ��*�u���O¤����5�f���S]������j��,�N_��݀-z��0}V��9�G(*��2R�e'YE)�F�xdc�����
D#g�HU��oQ��ٰp:݌�0Z�l�=D��W�:���$\���ߧ�z�1��1�*�4i�������l�n�{`wS�$R��C;���8�R-����x�<�Nw��*e�E���=r��f�>����K,>ntI#z�zJ�fH��=֥�\J�����p�@|^`�A��/P&���a��i@xj��n�=�j�U�|��y�w�&�}5\e�^��]K����rW���"v�>GO*J�x,z�y]�&��/tϜ{�⧟�O1�f�[Tw�o#�.���a��i ԦMU����?�@%<����Ń"�l�aE�0Cd��@H�����<�����1��H�)Z��l>�m�����P9���=$��ҸN�#֦�P[<�����W�I��ȩ�,�����fc��z7��0����)<��M�a�°���L�p	3��,����ۥ��W����ՙ�𩘸uA:�+�{�V��}��!B8��>c:�❧�_�����Ą�L�^��;2^E��ѻG���)B���b��k�����\�u/Ɇݍ�� ��9�to��t�¹�$y�EH��?�`��I��j������m ����&����2Ld��*HA�	f��<~���Q������Dh��^@�xE�o]���n��1��m�n�͖��@c��8Vk�d��2L)�+M���9fcOy���Ѽ×g3{�������oo��	�fJ�A�'�¶F�P�K�L� ����+�bCR���F�$O���iv	:�_�<����=;�d{̥�����a���+��G�>Uv���@9 �r���1�w�~�Y�f�bXfJϞ�I����I�������w�4��9�+r���d?���g����e��>)�?���γv/��0�� W"���u?vQ�X��ȃ��ή�{k{J}56�nC�l�I�:�9�4�>��+�>���2J�x0�x�=�!���>�;e�Ѩ���H�*@��~r8��~B�0���k-��S�2��l9��wv����<<5p�ݴ[&�S�m��?���C��ւT�Ga��?3�xpM� \��u��j�7�
K9JE\�{n�Y���(�Q^*���l>�f�&k��1����dA�4�Q��m�4'˯�Bi�O}۫I-��:���9�l���T}&:�K���#<��ѧX���u�B� ���q�#�b����l���/���U6�0=�@�Q-z��'b��A�*J��Y���5�s��v̻l7�Py� h �D��a�Ka�$��+î����9~q~��<�a���TY՝��fF�������;�J�:B�<̘�0'Y�m��g�Z�x֥�(�K��Zn��#�Ϧ�x�zZ|���m����j��j<�nZ�ǝ΂4�}��"�K]����PL��Sv�#!��0���X���b	I_�"ˍQ	�tW2e������Ί.{�G?��N�h�4`_*�JS���IhZ�����b�Z�A��PОf��7Bo��d�_�&��q�C�(����{3!�����O�~qG��]��|�A����ev�������Q|�=P)@���⊣�S�^����a�I���+��:�f����uEch��^�A{C�>.�����-�T�t�5��g����-����%=�	j9Q:5��a��cn�8hlJ��Hy̮uJ�v-ޅ�i�E~��wG!��c(��^�����h�H���[3�z��#(Y(ӛ*�{Y��.u�@V�S��d8�wVϷ�Iym6�k��c7�x���/������/�1=/�a�;G��S6 �J-a.瓘@�C�$"�����+��(�m�% ���K���KGp�;���sg}{��>��;M������V�A�е����/wũJ�|rLr�t�	�뒰���g��0J�'�|��=>��f^���c�$ƿ�O~��%��,��	a
�o
�;O��M���0([�Ϸ���*�L�"�J�3���~h����q��?x����»�Eū�o��@��C���*��acx=�B��Bᮧ��hвǶ��	�mH��1(ƒ�[��6I�'��z���Dwkr?�X^��`�!� w�??��/�/��ז��a��]����'�s�$��ڠ�]���-^@��j����p��{m��_+T�&�֡�5��M��Ў�O�-쑮>�X�@���F�}�wo�$)l�U��k����H�c�d�$!�_?��Y�<�j�M+�BwW��9���9�ty���Ci�-E;��۪���g�A�w�G�RK�Ef�'��q~�]��'���+$���_�;���{�x�g��✜a��VK�T�ڹ�o�VM�,�U%J Q�I��m佱
����?zk�٬�/��E4,|����rYU�][d>����%R��JvѫXƊMaQhz���r��%���\<c�~��0pX����K��<'��OI<�i�"���I��vz-忩�"��ri�D/Vp�����9�ge�s�2E��&��ɜ1���'A/�g��ΊR1��E,�m&�~vf�#�!-J�	��A^,��v#����e�'��k Lg'7� ���%���� ��J�>pj�w�Pa���-��md�S�g x��k��~���onW��a�B9�s������v�X�6X��D�� V��zw�+~A-x�V
?Jd[�3S|d����?.V�v������.��fQ�C����ER$�U���#����v��EƐ�$�����ܒO�qK����J�~WګzJ�G�ˮ���x�S���B	҃F��\��P��ve	?7jyO����Y�l�{�i�WM؄-c�Q���k�*zێ�d,O�����W)�r�"�-��Y���5�hvw	��)E/��g�,��F�~x`�M�ߠ�=]�*�yj��}�3n�c�@5�dr����!) 2�l�vK�*�j��Q��\s�Ȉ'"�����u�^@m��C>�*�/���_ ���	(F�;�%��w�%�
���6J���D8ҟ"��J�ͼ������h�Sа~*�g�睶(��@��i}ru��4�S�����"^Vk���U]0�K�Z3bҢH�?(�ӇFE����b�B���ֳ̹�m~@��r�oJ��B���)�)3�0��͹?�����6ȿ�KYyp�@�	s���	!M�=�E[���NON}���	ĽrE'���z�n����C��-f�1J��A�eD�|�j�g�E�l�W��H�"֮�3X����k�=CsO�ր� |u����|g�*�j�́��ف�_LU�W�&#���h�qW��y��5�+��0l�A����n�~U���t*�'�y�j�� ����K��qH��KQ(���C;�+c�&خ��?>�ِV�gi��%,|���qF�@��^6���*	�;���Q�N��� H�|���~\������Ӈ���!��k	���Q���T���F���u�N�ZnP6�z}2C�����N4ȯZ��[Vz�	��5L	I������j�q�cl.{���    ��� �~U����	�b���8�����$�$*��OY�r����v���Э����b ����<��L_˖~I�L�����SRi�ΐ����@.VN���� ^$�C9�"?�RT|�̺W��ـ�8��w&nq|��z?x塤C?��(��
"	"�C���E�,��'�SC �xc_�'X�Aj��W�\w~��5,�^/MT���6p�>z�����30عO�^���GӲ�=�ʜ�L�����(�j��^~M�����x�T3\�O>O�>�����U��lz��Ʒ��K�����XUbxV9Q2B �F-.�z�{��Þy�C⟈����8xIj�]E��T$�lhIkO�`�m��ʂOMʪ-�R$C�
,C��kg�dby�0)��1&q)|�(�>�~浜����`��$pA�-�^t�B��/� �"P�ST >^� �+xK�(/Np�l�u�_�|�����"?>HS�R���}���-eM��93��匏=%�e��_�l`� �NZeudg.5��|��]��tl�M����"���*#'�C����W���Z�����Wˁ��� �F�T��Rb9�Sl�	���[�Ck���Υ��y��>���HPo�V�]�<�:Ι���n�ޫ���#�(��J�J��ai�%��w�8���}�-l�������L�l���ZF��#��i�WX���p�6��W��� �	�&�g�Y�n���.�PNd�K��'�q���?VB�mdPJw�qpD���h�QЃv�v�QX����vL^!�t4���.��iS��n�u�s��(8&�c��hݸo��#��G�	l["��x���,_!ܯ0:p2A�H�9��$����{��3�u��O�N1��.}�9������g���Эmy=��bz�۫7ʡ��&1�|J�Z�A�g���N�����]�����m2�qѪ̿-�њ��oIۧ\{���ǘکga��'e�χ�������3g�2d�Q^��O%�٭�k�w����f���]?~�#�KYO���m�	n��&wy6#:��4jT��H=jN��q/�s;Z��f�7�o��A�x�Q�yOr�m%�T��Tp�Ҷ��.��TqkǭE�0�4)�?�v}Uo韯�ObdV�pf��r�؁�w��:2j��,�w����&�3 6��I԰�%ܵ��2��=8�q�Y�u��ȮY�=QO�P��Q�Ȅ�3Ƹ��RU-8��ʇ��wS�u�F�&J~�\h��˂��H�T����b4����[��+��!($�����}�����3�-������Yj�*RW÷%�:��ܽ'�L�FA=QdY�$2�GBAE���g�F7���w�F�d!�Eӧ7�x�W��f��#�8S"
�N�s�'[#C�$�o�*]��
.Z�8A��}ikf�i
�}��.1$�ߵ��,�*��M`��v���<S�s�����T��`��'T�~�H�Q����7O���\k�K	�.�8�<�RJBIU]v���I�Xq�"�hօ�-ޗ�+���p&pVo P�輂�,���s��k��?���"���ҿ!6RԤ&�.us�6�.�h^���;�w&D�����Q�6Þq�h�3��4}\'��xNv¶l�:CZr�c�h��K�*	/��
8ٌLx��=�F�R��ȓ)P�M��"W0H�e��E��y�T$�S�}1�e��c
 sS�w� �Crb�v��)��u��'�O:�%�
���fÕZ�^A6�b�&��^Ǆ��N����)[�{W��W�l��<�*�Τ��AHܑx8�kO���yڄ��No��T+� � ڐ���u^���U�d�O�푝�w���x��Y`��wn�YBV���غ�����\�Yt�E0������Z
�����k?���B�ye��H��&�C�q}6Ɇ�����G[<[����X}���K(��7�2�ݱ�e�Ӗ~��:�`2�j}�,r������-��p@+���[�d"��:���!U�͖�o���Ӑ!��i�D"l�F�r� w�����P�_��@�s'�B��M�:�v�����jTF��\�e+����5سi\�͠���F�ǿ���_�F��1����)� vT�R���}j��Ͷw��o�!(׹�3�N
�k`���63t�(.�"�Q"����A���ez��#
	o$�*nw^f(]�}O}2÷�<�:r.�'�V�L��'�50�Ʝ>4: IL	(y���gI0^~���i�9�|\�ڟ�Ҳ�_��+�>��]ώE~�c��隈xʺQ)��*���L�B�A�c�ܐ��C��pk"r�$F֣9�Rn�W卓	��]����<�թ��q+L����]�"��}EbIm��2��t�aY��wz��2�x�+^�R6�W�6����N}9\���Z���8���b���w5$�e&}sU2�
�-�܈��m��ә>W0���'��&Lz�^�ѥϧ��F�.=�&"Q��6)Khd�5�k�܏�3R�/ES�k� �ju�s��&�UU��U��_K�R�~��R�s_��i�X{��J�E�!XAK�轲˅H+�s�87Q�;�kv0���}�=�+ݷ�}s%�(�
N-���Q�4;����`c�쉕2�q��ҳ�ο$� H�|%���Xv[��(1�;7�+y咳L�>F���H/-�N��<����=K��^&*�S�h�+����8�Z�U߶�aU��:�E�D��7�X�k�-AO�Ynn%M��1�� ��#E��`��J ��i�y¾,�����O���fL�jU�p�3����hS��ApW�==�z.!_nq[�4{��2�Z\���YXj��3d���������k�	-g����mO�eC���.h��α���$kbe��`��>	v՝9<a�ҋ��_��J�?HI�xgdF�$���W-[��NxH3�7ǘ�W3*�'m7�jvj;�#0��Yӝv�")�N���\�����ʓ����	�W���:��5$w&N�M:&%u�(��x?3�UWS�?�ݺB����/�c�:��{����J��U��\��Z�݌�{������p����v3,���4���9xپL��b���tw�^'������)
M�fj�#E�&�!k��G�>�4~���;d�{�T�T����ԳH��D����`D�m!�{����TL��e-x0�͘�A�ZگڢQ��0���t�b������j}�c�;�0q�&Q<���X��.�a�(=~r��~�Oؚޡ7T�-�H����)�o5^C��v��-�r6zaK"��tt���&��N��1�%�eI�q�q��s$á�`0���s��~�?��|�%�	�ۓh���k5d��,�s�W��S��H"�����G�H��8�QUI���H��侕Mg-Q�0��%�'^����������/Cb���Ȅ�|w�r�-��V������{3#5E*N���V����K�J���X�o���緬^����!�
�j�X3ćPY.��yi���x.�����2�G}݁r�+p�����p�S�ͣ	F@M�m˔���6/td4E5��/��=� ��DwO��#~�����ɂX'@��`.D�I,��Ɓ�&�TSC��)��~���D���k���-������/Ƀ�dj>�����z��t�����=�T�W�4�"���{RN��v�T ,_�����MqF0{�����F}C2��������/�D�OP
e%-nE��0�0*���F��d�r��y����ᮕy�T|��F���"!�#0<��+��'=�t�I�:����E�����q�%��r~�- 1՝�����yV�Eo�ҘU}[C��r��E��Y���΄^&ڤ�ݭ�k}=�0["�$�|K�xI��Q�8�4�@�$I��8,�_��o��{�$�����P��_b�I�;�d��\������0CJ1�$���0EM�Ċ�^
��'�_��1;���jc�d{����+/g�;����W����6�\Ƥ��b-�dz�R��n$����    	C4G���A�q�z�C	#9��J �VgQ>}{��A
�J��I�r�g����߂��c5P�R���S�����'J�ÙIZ�%g�x�Q�\�eo.� Jc7���KP�J�\d��<���s�5�(�v)��mϊ�dm�X>������(��
��?�0�P��|8�ÚO�
kE�5��4�c}�';+EG�����&�g/A���_�m�*���( ���UD'�G���T{���.ec,������g+�̡���=����%~J�J1�/1�\]������,�����_}��DIg<� �)dld^n㘛��	r?E�����f���|W�&o�{\��o�\	#߼��d�
��T|a�=��C|������ɕ��� �qR����X�C��W��߰{��9��5�P*����($��#d��_�V������Ը�	Y��~�j�����+���(����� e�\
_/Q~,�A������*���m&ʐ�UBx�"��������x�xggI׽�]��qLJ���'���|��j�C��h3]�qO@F;_Rdx_�_G~H��Y�qݦ��d�B������0����؈����������`�V��r����`=0�Hb�	)��dOW��͈CmxԡV��-���|��8�R��2�Ո����*�m�ȤH��ld@��ן�p� �	�SSH�vyM���Z%3��+����k�64��%k,�3)A0��Aq��u��񮒶���8��8e_c��a�?vV<	a����lyWh��,�=�� O�B�df^��j��l����7�l���ё�
��2)Q��obcOR%l���L>8�m�a�AW���h��i��Y)�c	!HD��x�I	��	�$E
�~��(=��s3�}����m��sH�-͔|�n.'F���hs��Z-5V&��l��/��F���gZ+lá��r �q��l��?�%���7���� �V��ٲ <�W�1�B{��'[�\�<������#fv�s2�S�<ˡc��&�{����]�����-�K�����)�Tf{Ϯ*0�p#���R����4�h�f�fK%��za�tq��$O�}|dҽt����d����3������>���c���� �̀��D�Ψ�{W���[`��㧶��N.ѡC>1��������|�w����1$�e��A
��7$�ȭ���N���>�B�򣆣�R����{�~('E�7X�>h�g�"�oY|ïPc��zc\5��Y���ޙ%�D���$�2Z�����_q�!Q���� P�J꧂i����á��f����I�fϵ7����E�6j,2���_�|�1^��:�&�kLy`��0�L�X[�kޱTXp�;"(H��a2C
L���8)ȏp��T,!�&�ͨ�wzr�љmٟ + �̐?u^�4]��W���p\7��r�r'���_M���4Ӈ��+��%��x� e�hyho����)?<H{�������WD4R�e<;T��5���u{ߝ�*DDoh:��)���8��͙�o�Mp#b1�5��rG�L�B#�� h�|�&E� �p�)bp�PVd`�;��(�aݖ�p��WkG�����rϑ{��M�u��pa(MkCk-����yX��}��]�G#��O8�da���*�T/r;�#n�X�����j��=��Udes_�|G�@Q��y:����/I�����'p��XE8�DZ��u��K$/b���O�p���?��=��M����O�M��ݘ�V*�>��UR����� h�0	Y��]^��+��3|���	�ӥ���c�F�i������:~]�rY�lR���G��B��Q/�D�D��=�Qs���/�.S��0�T8�5�ҫL� r.��_�-�k#{�]cG���h�!�Ȯ\���8�k"�V����o�b�810��a�qC�bN[��v�����f��zj��k�0�I��7/�j��Є��F�e7'���T�e ��`�G P^`�=�(��G�W���%	^Dx�W�b雜��N��g�&+�?�Fϟ�l���w�y��~�<J8H�3��<򤒝���� �Я*"�NF��<�mvĺ)��O�<E�X.ʻ'���w�
1�Iy*h�,j�H�=W��?H��=�9����b�WG��n��Ln�L$��~�ӔN�1|�����Xt@���w��-��y�u��ɪ����͎:�a�����깧�o	�u�|�����t�{�"�_O_uB�U!�a����}�7������KS�R0�G4��WL�g_)`������HdF�yZ4v����D�h�0�d<-Ľ-�;��$,���(�2�*Ǳ���$�A��M1��B@F�)ܲ�4LB����!ŸC�R�����mL�n&V�Ng	�����`Y\�c�y&X<�}�g$�f ��x!�hH�I�x��02�ﰰ��z���ſM4M���ܖ*���;�U'E��>������9�dPY7��oF<	�]�Ȫ[2�I�5�����Sǔ!ʅO�=�Ͳ@r��O��o��o̾��X��6���t�-�)�yPTA����"Ċ�:�s�#0��-e5|ؿa$^'ߠ-<i�nu���#@��CW�5R��m�jW�͜s�bmu���p�(7�ם>��I`:�nZo����^Z
DP��M��ϔ�UJ���X��3��#rӫa�(�0�0��;�.`
+('���oG-�H��e�O�4ҧ���ϼ1Y!:kx��<L(�N|³"*��}��0]�������$���փ�iD�xW�з��E�-�W�2�C6tF��@�,��Su���2ֹmI�ż�$YJ@"�f} � ��	���h�[��K�j'́kO�yʝ!I^cw��=^�@�Ō��|���>5��{�4�,Cm��I��!G���}ꡝ �
Ngϑ���1��e���:o&q2��/̿(�#ptB�P��AQ$����"�KR��s0&ꑎ��O����¤�P��?�7�V����lbiG��I��sG]1\u�ۺyg�}�y�Y���{�'�aR7���G�@��T�n�:@�X��j�bS��g�M���������d��x�7_���_$@������I�,k��J��m�^F��#'���%�"�V��͟K��~�x/�m��		Q�����O�D�*�^D�;����}ik�xZ*c�
Ge��,�0�3\PZ�zq�5$0��{�ا�to�p�v$g�����#A��6���O�0ʰ4$� ��EA����F
(���O���e"6�S�a��;b8JVՈ���.b�k�͒��xq�Q�m�e�^<�CZ�ǅl�}|4�U�Y���":�U�H(�mx��4���}x��rI���d�ca�_)�h͇Z
��y��S?�ҀeP�"+ˊo6���U>XD�E2af*r����Wvw��]lM�u�Uuzl���Crǫ5��χ!)��a��5�dc���k�#�p;�].$�6,'4�P݅q�ɼdx�)$���}�����mp4���*=����S�J��J��/����# H�� ��	1�C�c��J_iS��d�����B�m�M�ϼ�gW����diLo&�P%��#M<qOaŃ��S'�`�Z�����{tF��%@��)�����fåe��I7�EY����r[=46�!2q��~�6�޼9"bӿ��P���B�k�!h���o�C�>�b=��+�l7��R<C5�f�қ�_r+oGR��=c'u}��ވ�'���
������~*�e��P ��V��R޵J����bya$қ��o��tfl^�<�f"]��F"���Ȑ(���+�����wvD]�]����xY�T��[��
-4�"��t��$z�Y����W�O;�Hl�X�<E�G�]�q��q/�'_-F�`Pp]k�^7@ԙB
��w�:+�(��M�͏6z��D�� �j�@�i������Y�I�^��I{~F�id�W������XWD�ʬ���@��kY��p�u~1�,�&C���^��I��O,I�Jrxu�r����प�    ���qx�Zv+r�4nn�j(I0$��v��B���d�Ã5���
*��drJ�R�a{���D�� !�/z?_��o�>�#�s�����-��XX .����y	��g�x;pu]�ћ�Ȟ���n�<Ǣ�‰�̐~f)u��g��!�]�J�A.9����N�ı����{y&� ����t�H�p��Q�Bڲ��U��!��\��^j��&ܓT�����=��XQ��0�#�� �0�
�:���Q�>��à��Z�H�y��񔗪�Z���W�}?�O-�����H��|)*g;�R��]�ϲ�%"-`nO
u�lj)���ãʌ�)x��BD��4AB�_���\"X8�Kin��1��U~��}�t�B����w�&����� [!����h�ƣ�ٞ�H�Z��_)����C�#���h)!��)�H�"I�aS���2z�+��]����>�VܫP{��H��� ��N]��e��Jk3�����כ,�1*����ǏV�����A���q��bH(���n�~F�c�8���r����t��`fT�p�?�3��3Ə��8��`�	T?��4?�ë1�	%�)���J�Y������S���ZJUҌ3юW�>���9.ީ&�v�$�"5��<��VT������j:�jr� �o�����c��cZ�����q��$�=���l��(9T�w�;��~j:�r�]M��Ӥ��;���D=��\�l;4��I㤓���O�#��I����g]�A��ՎoLp�&���]�Z$0��,=�à������}4B$�{oq,�q8K" &�������嫡oŔ�n�}m��Ǿ�ό��)��ӧ]��;L�at���k�'܃\�؏�E����+��7K:
�򛨠�ܾ]�� ��'l����lDX�"܏�I�7��<�-R6��0#�8�,�2(�K6�AВD@�I�O����_B�7��~N�ߵ��;�3D�9��Qm���oC�`�ԤU�����+DZ���u�6Q�U�]�Qˏ�P� +���� +XӮR�qja$���_�;�-ԭjԞ�d���ʌ�\O�e0�'���k�N��
���8D� B/
ȹ ��)J��I�������E�Q+J�c�'����U���,�ܢ'p�ݤ�)����U�P'�=S��o�^�8oM�F�$��*5Qwڥ� 8��H(�F"l-�s����oߎ����U��Hv
A�i��"!���f����{�X���$�Ku�<�4�'<�|��J1�D��U��X�����Ƃ|?5�_x]�(
n:?a�Ӣ�]��v�/Oo��C�(Q��S���ZC4*���������� ��`�R�%�ʎu��vZ^Xejt�D���	����o���
R��D�a�@��Z�U
:?�q)�"�VG����І�}��W��J5�(��0��k�rg��A�Ғ^~�	�Z�+j[}�g=���S�O���TUAK fچu��E���Ba��3��
�L� �ċ�A���_XB�?�$!�b�W\�y9���wQ��6[�5�I��U5�n/����1��� (pj�A����pt�C�c]U��خ�`���+Fpx�ad\��ƺ��	9����MHR�כ�<�Y�-�����l�y��驲�k�e�Q��I`C�$@*�p�x���i� ���X��%
AE����j�sUvI��YB����#җ�;�����?!\7���3����Y�ϓޡ�Y��eF��������eV��%�z�"�-H]�x������U<�Z@����B4%5U�ǈ��kś�K����0""!8�@�Hp�bġ4�18���.<�<�i���?g��Ķ�oOiX��� �\�>����?nw�������Gu.SX������;A{Pޮ#�
�2��k��T_��#RK�rܔ���H��_�Jh�l��ܶ��\_I�;v�'z��~���C��"a��~�bL=F�&CS�O4x���Xţ\��C�7�sڟ���/���{�`lE�sU8�Q�+��5�~Fq:05&ʉg�6�D�x�*�m� 3��y#��Y��9t&@��!Z֥���B����Y�����  ��LN�XT�����C��F� �W^�w���Yv�d�ͯ��î;�(�W%7� ,�2�����l\�>i\�A��(��E9�#�Õ%� K�W7��8!�i��ν�������&l0�g`"�>�x��{W�x�!E�Q`+(^�ԙ`s�=��q����Q�$�U��$��,;��vxB���Ά�͕b�R�H�9��V��8���A���n��^Դ�׾</���W�(*���D��S����am~	��v\:�|��)���Q���^(�F�
�i�����������1V4ۄD����H[�w�FʱyoJ���R��0x;���Gk�pU���RH.�W$8��/Fls �F��4si�J��N� �^#�M�J�..�e��'�s����CvJ�p�]N�=��M�X�����A��4n�����92v�v�+���e��C��:˩
�����*�!���
؀�����(�j�ԭ� ֡��!�~>�kpo�h��{�f�8��bM�yJNS��(o�3����$ �"9�VY$I%���� hh8-M����zD�������i?o������yq߽7�J�Ӽ �.o��������D89y"X��7�+�M_�S�+����pŮ-�Ie
�ꃬ���d?�������e��n�M��N\C�#��4�
L|�*ʂ�1��*8�
�L�Ѣ�W������ܕ�ټ�����ޕ!bt�ZfU:^��x�`V�5ܝ�j0���y��9FhZ��F�G�t�ZgQ�ZH|x����q�%�>�s��*8��s��i_� ˵G"��c?(�F%��w��r�*)��T�ce?����3�Q���r�ެB���=�G����O�JIvk$o��ޕ������%����.���Zd-5ܕ-'���|���3�ULG��x�n7޿�6��\e���ID$�D�B|�lR�)�]��w�4�ñK��~y�  u�?q�(�<`��u��I(r�b��ʞ�/z����B�\�}2Nwl��muQ!޽�f
�:29(��m�E�S
�}����J���c$ݐ-�ѕi����4|oM?j"!�Du!n�z���" p�si���_�~���eQ(���\��$��`G-6�r��8°t�%��bG"�گ��;���tb��KE����}F\ �eė���>����M�����������Ai�")�`  8��\ (7�ȓ�FZ�p��RL�'�C6/��KS�0�����?��:3��l�P����l��uT�����TTWqR���uФ1b"u8JE�ݽJË=�г��������dL���d���p����=��O�ܞk:���2�=�߯!�'E�/� �|��N!m-���B����g㋕^��D�2�u��ON����HE2y�e ��!���B�݊� ����9�r�G�ˇ}�dD�!�1ߍ�m�wEL㙙�`�����Z���-J���'�r����r;c��qZ$�]	����`Y�\�����|��۶ۦ�jM���4fp�4��H�e�4��x��B�Nz�$��Z�~�\)�r�7.�V���aU��B�c�.� �Q!�k�k5�G��Q���4&:�4����J5[dٮ�7`����ݧ���uӽ�8ļ4~��C5'���
\�ô�Y��+��̿4
 )�� j�ӄ@@<0�o�,�0)@$O�B�� �Ry�Z�)� &�r4d�AV�'��P��IF����|�v�YW���փH�� MݱY]�sp�F46����qm�%7��s:��s�3�\�đ��P�Q�B�F2E�٠a��?%��.z�^��������&�'(pO�*a���gV@�ٹKEU�+R��H�Z��fR^̼���D��P�� �ڻT�2R`1\�����*(��`�}k�#���    ).����R	IZ�e�}G.��]�#�5<�:�:�_���s�G������j����ʌ�ː�Ϸ(
�(�`�p�{���CI���H�)I��^I�`�q�w�^����<��mq��d����k$M��iװ#�[��[�g^�u�32��t4���{�]ǁnKs�|�M��Dћ	A�D�)����_ȼЃ�I�I2Oì��0{Se��������]�����[�`��[m0���-�z����~�@�,�dxΡ�H�K�ɼ�?�������gVa4Q�iZ�9��BPx��9׵�bw��Q�?@@_�Y*<�����m(�aA6�/��k�����	X6�b;0tX՗����=H�(��./
f0�~fL�aI^�xFO�@���ɩѲ=��3\���HE��o3��`O��ׯ$��4gP4�nez��H}��wu"J�8���U��V��Z�R���Fn���j�S�:�a'`#��I��hR�c���_#��L+V[�}�41��w�o �Mdn�HO�r0�������_�8�A��c�E�-u�=��?�?��i� ��h����
�4�BÐ
LQ".�ҭ�D�\`S�C�� i�T�a!�ӽ�b{�\��CҶ½���DOܠgj�}��h�ݤ��z|�I���`=�ۘ/�f�P�L5aE,��{�F<˯��?�����ѕ�p�6<�G�6y1f`�y�����{�n<�00Ncp�S1�>��QN�y�9_{	fIL�awn}�U��/l��������F5F,��`;o����/�5@Xv%�hs!+Ġ?J#_�FK��w� �w�Xa���>CJ@.�KN7[Yi��(�������
��a��Er*.6��j��v`��(`� Q�����(A$���"�J2�|�	F�V�����G?�ߤ��IL�n�il1��q��d����K1���E�������fiCK�1j�*1��s��������+���[���]=�r������+7����μ�_��D����?��QJ�X	GxA` �3?���_I%�C(�¯��E�w����OV��ـ�e�#7��� ��P�hY��O']k�6��Bq���Ms�aӰ6�z�j�92^^G� �v[]�5k|^��,�DN˛�z�[�(y�ASz� �:�����jh�8>@=���h	�	��`&��,�@��H���3`�p��C,����ݖoa��$���E��z��}<�P�]9�`0U%>�y�=��W�E���в��$��)�r�&��M��f'ک�o�]Ż�h�k����SB|�U����rr�WJ˦���� ��Y^���n4UQtJ��F��(��ʹ��VFD�v��ƒ�S{�yxxw?!��^p���7M���~��A����0O8��w�l��.aUpL��Нx��#98�La�wj��y�1c}�^��H&��$��o�b1d����h��� x������V��q�(���\�t�����_m�m�0�Nt�k�Э��0b5i}ߺ�ٵ2Zr��T)MBšL������ؙ���K��C�h�Om{��ĝy�o���g�ӂ��q:申�>Vo�'��t�T�o P2ͫ[��>A�U�
�������&��%8��XIe+��GZ<��)�� �͈Y�Q��9"�q��VG��Y����kZ}���"ïz���:��2Ӻr�Q����}��}*	4�PÜ�Xp� 6� 6���QY����]P�-~Z}������X�n�7���}0�ʜ(���_�	�ݴ�'���/���*�����Xe��}�FF%2$ء�>ު���x�=��@VWBZ�p� ^���a��`��-��M�!<���r�����? r �Cn%��E�YA�%�˦�#�/v��|���KJ�L快��Ns�@�i	O�E����~Q�MX,֕W*Z�M�1�'�\a���|�GŻb������O�*��)T����>z�&�~d|o`�6����^�e�f��������A��E�_����s�VV�L��Æg:^]�k�/�)w�+vO�6���?!�.�&��BOm��2~>ʌ��U��f�!�U�-M��ZR���`��D���Xv���W���(�&��y�m���v�J�<�J"���>��_:񇡀 �̍!���X*���1�/"�keo�^uCCe�^��O./ϑl��Í����am��FN��rW�Z����ԇO:�:��V{�Q;�
f=�_����Җ��L�4mEEʂM� ��4vf�iv}*��ݸR	������C���=��q��-�l3Kݹ�����B����[߭{g�uE�Ʀw>j��۬��Z�D@T�v�8��%�D����TGKne��Tb�]}��N�r�틞��%��>S)��Iܑ�]M��=��4��'���Q؍�@L��A	���[$	bD��B$CD��1��G��\�N3��,%�^�=U����w
Msy.��!ݭ�#�!v5�7���3ڷ�p���}�͸�\1J+w�]M���)�A|֚��p�O��A�}dD!B*�8x���:yfw~��Ҟ:`?�`N��7��30�ҪD~g�-7�zʐ����^i�_¿���U��������|��/_x2f�95u!d5���)[8k����P����E��^�PM�-k�B�8�U�c��F�9�O1��m\0v�uh��~�*N>��ʠ 4���� فu:I��3Q,��@$I��(p<lzI���k氱�_�)�̿��K�ς]�3��-����V��,�_a%px�W�5���"�s���ܡI�bx_��gB��Q�+�E���&*oM�E˸��~���)K�̐-h-�R4��-�Ǔ���|(�T4�"E^��b�P���� �3*L�W�K,�t;1eQ�J�p�,ә�i�x��B��FC�>��a����BO�k�$�7>���5޴�n�>С�8��Y�Pgo�GvW�k��S��l��N��!;���CD5���"!S�Z�XN�
n4j�$�T�v
UB�.��yԶ)#V��O������Yl�yYA<�v�$K��;��,��Tx�\�fCw|�2���F���2hm�yZ�%�<�w�C	9�<�z��&'\X�ZI���
�2X�(�V�8���/t^?*E�j�)�N���
��e�Ԟ)�>�<�)��U�S��[w�D��K?��i�ҤzI���OH_�0�@u��F�Y
������|��ɹ�Q�A�c����.3��v2z��b)����������
G����)�V�Jm���':e�����S��5�P����ꈔ�rv�{�I����r��;C��gc#�S��Y�,T�_r�C&�p�j�������Q`/�!���s,�Ͽ|$SX��C�94�#΀�������)*��QRS�Xԧ��8�͒K\�������3ۏ��2��P��r�Y�?��\_bc$|ǃOV6\PU��gH������Z���ɝ��mG�x�1��/y����3`�t"3�Ǌ/��{�+�_�x"�?�~5�SF�Ͱ2梠�z@{��6��#F����X�Rk�e�ձ��T ��;|,�\�ѽ\��s)��9�q��74�%$0��F�� �;{�� �^��_^'��3�U|ձ��a���"�)AN�AN�;�X�C���FH'�e�Z��$,+��!Ch����-�,EP�Z�'�J����A�ĪdV��f�[�TUfD)�޵;� !��џ����郊MJ{ϝ4��I�\F�hD���	1���1-������U}�#k2��w��}�itḤb9��x?ٽ�I�48�
U=Ƃ�п�9�	N1��$[��!W��������u]�7�I�X�#@��)����x�x��y�"�ǿ:�HX�[0[O����M��A���L�R��*e7`����@���;�����J�C��\݋��T�%���pp�`���f�	s
��|0��X�C��e��0V["i^�%��U�>6={!�R��ᜑ��`��f^��+��k1���栕�� ��'�|ۄ`_1D�G����X    ЁL�nD������,,�	)E���fV���?�@���@���*�f�� �c,n�\��x�������)C2"K�f6c2��#;e�x��/���ޒ�A�^-evp�f�}s�q��Y[�=ڊ�o���z#���3��t�O�z��	�>�Q�(|����;h{볨��;��4� L]q '�ƞ!����8�>�Iwƈ�?`�_J��,+ 7�ː�Q@�Җ}�� g�4�,������"�|�B��Kw�zmk){��}]����8u�B/��Nrce�:čѵ�p�eX����"0hOJ0��.��HRUYEE"eox��|tZ��E� ��qtzQ�P�/�X�%�)J�)����Uj��Vъ"��%���7�5��}�]���gY�k�}3�R��}9���CG�z�����-�0A�3�T��K󩬀D����VjN]����3���we��n=�G�^>��/U$��>��x��n4��K@�(��Y��U��nh�C@E�MjôU��E�,ht1i\+%�52�����@�p�{(?�LG������<%S|��}�Rl���/�É{w0k'���ڇ�䪐�0��X1����*��ɵ���^!g#-�����&������`ي� 4�%q��p
��Dx�%���y�N��bŌ�;U�`��ǯ$�N��A�y�b������khL�8�q֣Il�`ڦrL�:�r�A��Uv�J�y�+Ϻ�4F��h.�>i��ȡE�VCB�����Y�G�%�F7)�������W����g��V��[����q���,um�����dP=YGI�T_��(U)es�|���!xY��P��U��$��V��@������{7��}�7�C�3�+U�K�����%�N��FV��W]�'���?#��6h##��𻗏�~�)S�鄧0E^��[S�Y�%�Q�������w�N��O�E%2h9������^�T�`���[��}�Fĩ+��{V\'Xu��F�ư)4��u"]�qH�l��Cm����9T+�Z*��֛�=���2c�!8� ��\���A��JA�)��$/���f��>P�{W�ʢ�sm�sM�L�-�~�[wAk�9�[R��T��U�*pZ�"��u��H��=X+bf��+�c�WlL6u;��=�k��r$+g��^���V��ا��L���3���]�;GD�"�Ѵ�i��S�6x���ئ�Yd��و �����K��񔰓��t�^�����7�4�?^�
%���>,�Du5�l�.O�z����H���T�շc���#��bT=�6�#=�Ҽ7�hַ���į�h=�/�CAR�/%R�,�J��u�����,fϿ>H:}��[���T��cԏdԪmẁ��}U��.��sC���	�>����XQ�$��}�=4����)QPV��zI��&{=0�m�5Ej���ްp�2?�e����߃���	:�򠔁��2ȍA(��~%gF�.B��䴳4=1�����n#�н�A�=�Vꦑ��W�V��D��O�1��yB�6�3⍨�����ˇ
;�\YUu �yE�L�$�3�h�i�����6�G��L�=�͈�\�8���l��c��6��Z�i��Q��� �5�p&2��Ez�O��O�e���O�z�f���rl��~:�{FK������)�r����Bѧ��lK�	���%����ډ޺RM�+>��p��-��רnzw��)�n�Z�̴�Sǰ����'?�D�8
�
~�^+�M�0�S�(�B�"}+�ĵ	C|{��'��4��9�;����q�&��=VW��u�W��*���=��&8���g�Z[��B��F�c}�U���q�,@�֞���j$���ʹ�|�0(*���_�w��C�7W�� �q�F��uJ�X��E^"xFc!6��E�,���۫Rھ���M�p��י���vQ��#�����!�n\+r�E �k���#�����I
�9��)�"s�q��M"���YM��[�)Ehi�/���o����g���%ܳ�n��F�W���¿�=)�V`&�:�e����j�3��:%�3ES$#��e��X����a���w���p��~7d������S�ޝ��4�AX�gt�"���e.��ھ�
�崏��i��d�&�]��dB��B�R�<�����Q�?K��~u�Pe�#3�`*�o�MgV,.�osvX����D��ϱҝu��A1�F<'�����ƙ�7u�x��;�ʁ0�߭	�6���^�{��Tt���RVZï�Ք��=zܗ��b|���:ǰ�u�ᳩ�QW) 3��+�!���8��p�)�0�P��~�cW�~z�(�E�wq�.�>���v)5ʷE�25RI8����`�B�jB��w����+���/Ű$1�LR�r�)o��Nw�pô�p��:.'�+$��Zd�ü�X�{f��gԣ�H��3���p �'�[^PY�0 1�,���V�n|W#�}�gz7;B�R����ݒ�a$�J�4���i�ُ_�N��ʽ��I��"�ڥ������P�>sN�:�W*:�O�4�S{���"6���R�?�?=î�p��
����H�,|��#��wt;���j�p��!��P�E�'E�X�V����P=���fb^{��#�+H�e�O*cQ�?��[{�+�*��L��5�	Gօ�C��9E8W��|I5�e�f�P�R}kw�!�ԡ�pr߻\�>ra�ţC��z��2{R��~�a��i�,JB<��I����O	�ĳ�D��-�^!'X������pR��
H�{'jݒY�!�:d9ۄ���aHE�����'��M�"��,�U��8W�`$�n\@v�}�{Y�5O�U�VT�`Y�^�4~mq�?9��q
:��ĭ��������ղ�_��!i%���`����֧��rA�_��!k�,&�F+����v7�'jΜ�8�}kh�Qͧ��Yr�.�����ʊ�Uݘ_QsK��lÎ��g%�{��J$��pK���R/��:�'ǂ�|����ր���������C�(EVEY �)�_�~�n=����1���p�����)-)Ĭ�\�$�;��岔f��Y�q�W��e�<�����0�e�$�����f{�Ҩ��|ӄ3?;q�����V�N��G���%��*�e"G\>�=M�t�x�L���Ձ)��'�sI��n便�}���|\�1vf�������s*o+��~���P����%� ^�����A�{c\4�!�'}���m$��#>Ԩ:C3��-`��l�񽹯"J��)�[�+|��x���0����)�F��,V�B0���%G����bxX��;��0᭄�}�Q�?�_��џ����4sa�����T�_��K����BftIx��V�G�}V:�uJ0�[��tv/9�pC|��?/�<�C�$�KP�e��!>�F��)��I�vّ|����} QV%��T�QDV O\5&F���!����n.���./�a枒�z&0��롌G�(��߅uj���Jo(��~�.zD`,��eՌ������Nx�D��-�]�!
��t�URޯ�ġ4�th;���K�"����zˈ��QMq��_q����q�u�!Xׇe�<��o��_�<�vw{Տ�������㬬�g�%uY��69��މ1~��,#��"L45Q��h�d1��I~X�'�)�:B��G�^4C�r��s����ikr��I�����Y~��W�?U@(�����c�
Xe��3�&A@�ۿX�WCӋ!�������b�9�\�X��XN�y�Ξ�u�[�1�h�]����N�_�w)(8�,B�tV�1eq����iM��?�Du�:V�旁��>�F��NS��*��30���~�,���<�k� ̬<�Kkd�T8���%b�</�M�\*����vgTG?�e���ݑ����a��-t8�&����:���8��D2b���:C�3�1�F����A��zt[�s��� ���f7    C�)�1 |0,'�[y���)'p�v?��ÿ�9��ӻ�^�;�Q�����fP�m0%��L�H�O#_󰚍��k���f����e�����Ɨ�?u�^l'��h:~1�DBi�J�޲�Vw�J4`hU��~�������7d(E�ƀU�� o�+P/�V�MV�(g��~;��1zJ��ػ��w}��#D�9HP��GD��w.Nw��Ѫ$Ǜt�U�ϛ9>߽M\��ˍyI-Ǯ�E՟m������?�ƪ\�W��:������� .�`��y��%\��J��	n_38��e������Ryi���&����*�~��윳�"7�Ѻ��p�ų��Y6��H���K�v���bvԱo��P���H{�O���{�Ѵ6�絨|"C��@�M�EH�џ��&Ƴ2����=%�[�{	�P���V��|�q����Ãt����7\� /Ӣ��N������ �s�tٞ���UҺg×[[��^}��ķ�|01[}�aZ�O;�K��h��$�G{C١�=�(ty�ao���,�+y���r�؀9�{�M�v_P��XH` &��A��*�"J	4��Nŏ��{��������c��Չ%����ѧ��b2�_h���.�^�HL���.�����ʅ2�U����C��-U����DQ\��z��|4=�G��S��:�1�����3�_���G}���n�;�<����V�%L�*퍲��;�I��Zr1(�灸J�����lPL,F�-:��&$�t��0���c8$;��MGg$�O�G���I���a���ao�
^�p1~|�?=�_�(��nc��n��m[������o����� ơ~U]p�Uc�p����BL )��a��!����6{KdE�VO��� ҋq���z���ӏ���QΨ�W�${Ǧ&a����]C��^�e��!D�����������X�ln>�=�h������-�w�mp]��W���]�ɼ�eC%\`N���LE*��s
�P�y
^�[�T���=��r�e�����ɵ$�Ct�|�'�=Ƞn, �20�qZL
M��)#B ���5+r��/�_��V	9:"�LG���a5�~��S0�g� �!�*9�h>H�)G?=e�U�=���6�����p୙�)��ׁq���A/E��O�V��\X���˜w.S�7(�4X��-�7y�~���e�l]���:e��-!�䟕i}]D%�qV���BS|:����.o5���qIS�om��:���v����� ���Ͻ#��7\�P�b9C�_����w�&I^�HF�Yk7��E}=����67���" �?���s��G(����V�w�9jC��[	�C��ݮ@�H�֨�r�I�v�>�1��㆗ܔH�_�2�#$�^@�4ǂ����Ә֦���E�h�HF�xG a�����P�1)�+�N�_�3�HsR��-	W)�j�-��2���T�}�M�G>������C<�F��v6	ImǷ���v�L�Kk��^�k%q����e�>|�ְ(Θ�췘]ތ"}�0�z���נϔ̛<��_��U����0�Q<��}UT�!HH�H0��7�#!�Ek"���� ���\d�3ݧ
��0�H�!�J%����Cb�4z�҄�S奩~�B��,K�̭��8"���Hy Y�gI� ��O�`h�W$G"#j�E�F�%����ql�D�Ku�b���")����58�K�A��H"� ��{�p˃�����%ŗ1���)�_��y fA��sm�R�3G�Dx�w��xb�O�����~~��� �����q�|��'ьk�sF��i)"��A�B���7ԝ
���q^���v�R7�+щ�@��ۯdA��e
S0NT��ȭp���F��yjM��a��N /�{�g4{>�S����|��|*s����j���C;
�|؟8�-���?w؊D���L����~d̆�Ia��c9b��Lk��#J���3��Z�����	��Ft�nXT��8�t�3��y/M��V�F�*��Z�����E����xr�m��+;TZc�o%c��r%���̏�CQ��R��'D�K��--*A1��o��
HK�oOX�xJ�O/��r�Y>�e���k����_��T *��qT�@a����wW���*���7���e�>C�v���S(	���r�i�X��~��V4����Lr�~�����8�i�i�V����z�Ȳ�_�ه���w���rLE�AHiN�1���KBp0���h��
��1�������9��N �/rJ����("藡A�ŉ�ۓw2K�V����5�-��Ls�5�L=J�e��1:7��a3�l����=�;?mV���0�_��X����?��Jx�V(�͠�){�>$����S=��4JB���=��0,� f�!�6�g���b_4���+rV��Bǭ*�Z��Hb������.�����,gF�-IY�(&f���y�Gqw�l�N�c�T��{��4�HA�< W��:�O���&K�/��_	룡Z0�~w���`Dh�yȔD�����3�9��}�}Ɔ�zO��)�S���2^��З`�'����S�����`���#s"�Ѭ�ƚ�,Ӂ�}쁰6Ba>���/et��i}��ݐ��H��y�V���D�4)�l�Ë,�M�+v���f�[<�|u�%r�����
��F����4��C�]~����R���X�Z�?����8�"����):��,�)~���Z	݂3�K$�=y��ԼJ����_O��]JX���+܇a���8�M.�פ�+�(H�^Y�i��4qh,�1iF3U� @�J�~���p�R�.�:��X+��/�����\��k�q���'��Z/��w�O�*�1�����S4f޳��Q������y�^����׷ ɻ��j�o��}�}�]|�bX��k�kHbM��r�����X�&���_��D��%�������22,^�s������_�P
G�A�ǔb����cZU��Q.1GA"���i�"�ͅ��Lr������̦�$1(��%��d�ziM�m}��u��l���f�a`��|$ا���i�JE� �' �DFUY�WU�1)����9�Û��ݧ\����J���ww�E��n�p�(5��W���r/)�ezD�����m�,�d���:8���{hm`.��'�I�[Ί�.�bZ:)�"���Z�<������sz�!2ۏ��O�|�6h=��(��Dr�n�	�1�8��Uw�m���\�u�ѿ�1��l��H��!.V�l�E��T�x���7�r�1ȱ%��?����h���۫g��{oSp�E�{˻�g��5e��"�;�N����H�ĵ���QK�LF� K����W��H��]m�D �,*A�o�a0�bi;��˯��@�=��*T���oQg:�u{jВD�3�����	m��T@�<����En����]�"��g�@�5>t�/��˿�oԡ��?UKZ5i˄�ő�`���o�m�λ�er�c[��d�o�Z�8��ʩg9\P`D�[^=��#W�1�jS%�A������6<�ع��� �E�fl�A�(�c%~� �欺�*ǖ?
��b-| "�ڱ%=��en�LqqKX/�u�2�%��[�٢� ��i�@#�KlM�i�g^m�K�����P)SR�k����$v��W=��ٹ%�}��]���_��V~|3�2Sg���/|(bq�r�a���Ŷ:����p"������)�b��� �Z��OS��LvU�_�9���1s�2%��t�����F��8������R&-Ѵ�Hg��V�Ap����@�q��z����	�,J>4'�ť͉�A��m�;�0�%��m_��A���  �W'Ɉ��6�%Mœ��I�)�m7��4��u��
~Y�'�2�|O_v�N�`�f����K锢2�Q�Bs�p�z�:�|�N��s3�O��Y?��=}΋ƨ�z)�cT�.OI�ƴ�}���j'    ��j��C��YFg�=s��p;W;DJ�fEJ!H}'��6��9�_����4V]��S�@�y��w��k�I����@��,'��
���m�V!ԉ��������t�
EoCg�T�<I2����R f��h���.�E�3!�"N��ٿw��C����jb{+�=9���]D3;��`�������մ~Ud/�S���7��_�A���s,�_�$���JrY�ܵ�9%��e��?N$Ƕ�J��w�x'�".��|Ł/&3k��V{Z�o�$��=I���[��`HaE[�0/����ܤu��\G�@!�)>L�lf�$�%�z���O0q��q��
�Q���7�4��B^��/r�$��@�_������g0GkNB��˕���=�W�3D�=�J�#����)ݗgg&�N��}�����}��ө0������@2�D�1X%Z�@�/>�2��B{qV��*/���m[07fhЙ$DQ8�3�@��a��04���]���JY��u_GRO��W���	*���^��Ü�h�\2!�����Mn4c�,��]�9�V��ޡ����$�f��B��a��8�[8nΙ��o��k�{��O�w=�%����|n�|!������O�7�ƪG3@�4F�`!4�Ƭ��T������:�ӿ�l�]�߸T�,�G���cTi �w��Kn~u���a�v�C
�g�ӻ-q-��~����I����lT;΀��hs�j?Y���1w�|����X�=�pK14�8���x����B�(�WU��%b1s+�E����zy\2#ϣ�O�Skb�g�
>���T�|qr1+����^0��i<����(R4��H�t�d'{xa)4_~(��;у��q4}�=E�����}��n��-�����v(��&cX�|���k!-�<�"�s`U�[�N����C%�Ŋ[,��U_�v�����>�W۝q���Ut�O���Uev�A1��j�2Ȼȇ��ZF�gO?̺��G*�2�~^g?HFS�̪�������6z�>%j/JQ�Ahc��4�y�]�u�f��%�f�Jm�iFD�q��m����U����Y�;~5C�� ��S�>������?w�P�t0l���T>�7iT��&V���������v��Hgrh���E6��VK�M9ˮ;�,g7�fpBz�.�WT�(G��A�A�؍��<͋!`����#詹S�Ȓ�����L�o�%���rC�3��Oи��uU)���Wi��~$���4��,�3��{m�s�%��UP!l"*��N^�\g�/ 흙��y>��P�(�䀎Aq�+3N\.f����w��E.�bw +*�e(
*��_�_�,�ܹ+Z��o��_v�a
�S<�t�@�$4)�tsi�@0ͦ�A�Q�.�ｷ�H��W6��_g�|�rP���i����@d*@������11n���r�Һ��M?�F�a���z�w3�bD��$�/G2���
��Թ�93V���ꮈs�1T�vu��5���6�|�zHkخ��.`�F���P8n��;��Y� L³2Y���͹/����T��h�c�!~�"�.�{f�����;��)���ѯ�`���Wu��,���Ŝ ��aI�`�	�"�&��~�����z6�^��T]�U<�@����*���Aa�)�p�C@z��y��,�'�;睢��tٴ�%��S���2'�Gz�����\o� �9`m(t����Cw�����T�j�cՔi�buJ\���oYPu��wH�e����z-3G��Q9�����������gD�1�(�䏼�w �bK�^ʼ�WW���?�[ "d��-��0=�GtsV0*���v�i�.������3��c���9,�6Z�����;<s���!R��t�woŁ��
�I�kF]�q���9M������5I�s2�a"���}��\���4���CV�V�%���� �����\q�X�0��^��_�����/����P�X�b��O��� ���,l����9u��}_��BL�t��+@�Dr���p
Ȑ�ζ��'K+��/�ۼ`��6� ��(�T���(�(�"��N:�]����?ϝXC���&=��e�Z�._�l�#��0��R�EE�C�A��hb/-�b�f���r�
ir��D�*Qǭ��͵{��5��	�ͥ�;F,|e����m�̹4~+�rp4ϊ��B�kF��}V��Y�)am}������'�ҁ�	Vc:"_��QO��?��H��|!���w�9$�L���t�,!ʯ$���\��ښ�����+ա@���Oc�b.C����0��k�&�A�c>,��}��ow����0���~Ó�ʾ��W�l�{�&jk^ۄk@޿vX�i��m�
�W+��a�o1J ��	o}���/��R���X��V�``K�y9Q��)�v\��Cj���
��Ro���RT���<�2j:��T=7�6IyQ�I����|#���7F�����Ad{8e}�n���i�/RF�5�33}f��:F뱂a�G��ЗO(X�gH�cUɗϴ�P��f�B�56�C.C��&��k��o�E.�R�M+��R�FG}�-}n��Z��/����-���-�P�@
%������� 	2DA<E��#���;0��ܗRXY7�뷖J	�K蔧o��N�2�ǐ�wY�A�(�$�󻲊L�;�ھw�ٺf�A���>3?�Ƞ�2�v:	ۥ�Hgu��șd,����k��G�)���$�J�F>h��@"�������R ���Dh����Q6�ҶAY
�������0)L�t��'E���U!�#U]]�NH}�V��,�d��
W �>Ļlبs�o�Vk�"X��������*U��{j£�U�D��@�}�DUɜ�\yC�}���	���L�����9 �1 @!��3,M��cgOX��+��il�\�����uO��	���"DߖD�1�MX������D�Д��90�q��b,n�`��dJ����yk�9%�dg�K/m.���U�B_��C!�G� o;�+�(4�T���������� q�w�ȑ�G}s�P��qH|�m�=����{��M��A �a��\1@>��J�����@O���mS�[�H��k�dm�S�v�2T~Fp*�v���͋P��R�y���t]��w-�*e%�UPy�=��]�� *M@4K`Ar�ܛ���ۺZx���ѽ��V�u�K�#a%La�DC4e�<���W�RW�Q�X��jv���Y��+?�Pb�V<��w�pK����6D'��R�W�����<��$��ɔƘ�Z��!�w������ӿAJ�o���MF�d7��4Y�]��oB�#���i��G3��M�v�]HLY��� �A<^�JD�-�����I��=��+�n`h*y�	�����Y���WSO5��O��C�H]�H�~o�h�� S��`�p� ����������w��"U�WgJ��y8�-EP��	dq����%{��i����ѦI�d6Ͽ%2�D��E��F�9�-Z�̷3����
�Q,�������ӹ�|�ד�����D��L���f׉J����/G��W	Vج�}�����#aC9��*?�u�$�+�_?�[y�D����8R	�>��V�N&�������Z������yAd�����VW�Kڲ�74���'���-ֹ�-���Y#:F7XxPf����҈�x5tn���(K�v�68�|yy�l��� �^�p/;c.-��|������[���8'
S�c��	�ȏ��D�1̘?��}�����o���ly
(�'V����/���ߵ�-�i�o�6^��<��T��l����T����
3�L�f��E`'��00S��Ԅ�Z�o���w�%^�A/���%~��i���~������&���I�gi��N��#���p�=��_n	���2Pj�k��� s9:�1p�^n�b5�`_�LAg|��đ{�v*/�藝�_W��;���>ߤ��    b��mC%�O�σ��Z���	~�(���k��dm���A�7�-#ȄL!�� ��(�d�g��Z�����[��YFv�����p�?�1�@�A('f�H3���oɌ���!�{{,cYp�,S���·N[���`��PXF���s9���$��V�eZj%쩌1��w�/sn������7�� ����x�q��չ�XcP��4��T���z��e��a1/&9[�;����*?V��sU�C�0�I	�/]�|��?���9"�ט6Oջ|���8�Fš�%��� 5D�l^&m�UIܭ�#��B���~��ԍ;)B�FR��E|3E�q�s���\}���jBU�9i@�����]��j�,n�"�U��(V��P��B��&��\k K��t(��?��e�Etz��F��;eh������񲉗��>�:�@4������&Po0��{���&���8�S	��IJ�fQ�~,����T:�`5�gބ��g�Y�Z�>�Ϻ��h�ϚvA�v����P�����V�.�T=��r�Q�f��a{�@kP�n����vO"��-�:C}vtq����2tF�a����V������W�S�ȋ�� �n�B��mu�!��P�\8�j�����o!-�P
	�?N�\$�4������#�WJe��g��b;�e@�= X6(+#��S�����F6�R��*�aH���'|m8v�N|_��\��`�7��刐�����g�S�R<������X� �΍:gM�M��&�;��KS�����YŋG$���8.���Ax����K+L�U���楫CQ&�,}g����¿S댒�VLLsc��1���kf����YϾg|�P�@j*���_��*�V�+���ԣ0Q��~+�;aIzy;����h�E�+^�|7��]��v}t2������Ψ�y��f�"��0X+�o����Q�	�y�+;�j-!t��Х����������S+kw�X��O�ȳ�E����5	=�4�H���x��f��x_ɯ�k|����g��_�km/�;V�#�_�|����ԲO'��;a'Y�gDa���O�Ր*�q�^��N�︱Jn�-%�u�4�V.���כ�]�T�־���f�4�z7\=�U{������pV�z!E��� ��c83^�Aw�������%?�|�H�ŖwR/�hq�a����!��,���肅mt�����ha����Ql(l�����5v�>�9f�X�iZ֏*_�}*_�`�z�v2��A��_��J#�EPr�h�����}��s��MW6V�D�Q���%^`\hn[�d��ƗOL#.J_FW��~Pc5��8���Vz�ҁ�ѐN���@h�b�c�wɝ��
��hƤ狍��1�8`��߆�t�T�!񆪿��`����X}PJ&0X�-��^��z�n��pfh�T���V$�x{����wM��l)���7�qQ�A��
��\iF�{a�Z[|�I�x8��IY��z�FUx����@�7��Q��kh�ְ�W/ܒ�4)���N�N7����s��m]ne����@�@2�����R��>2�zu�s�x^Y?��*�[��Bn��3ʜ��kو�^�X�I#���J���'�\�o4���d��o{D[1��G��V���%�9
M���h���X1#�yG��ٙ_�J�����ņ5X�@���i����\�@�"�����H���O�s�g7|��\��M|��� H�q��WP�B�S�[������s�t?IS�͍%�=�I�Wd;��`.ݮFBq���J<i����g`��ٿ��_�8|!C�����B*���k.�W+�}����xL�ĝM(�0�=��FSx:I'O4��m��������ԺO���p�_���'�kk��ͻ�d��zb	v_��D]�$�K)���/+�9-}Z���n�V����f )!���8�O�e�C����Ԯ�]?K�ܕLA��"��"�)*��GJm7������ܞqP��j��~�*s@����S_BT�/��|��$�o帨��T1Գ+
����>����p�a�� �a~��ݫbx�Β�4�qL�E�N���3���˃jԀ�\9���Y�o��r� ��(�;����
��B4͓4
4�H�#v�M�����Н��д���4B�?���^d΁�9g�\��(�|�v���~B"�;��_@"&�/��qrH��Œ|�����ѷ^<�+�+���,Wz8������$��h����B���H��V�����6�;���/8�;�)DJ��u���$���Y$�oL<�G�ɊI��K����N�}�����z�Z�ٟL�D	��~�y���C^fU�@�h8/e�J� R*����6}/�]������R)�C(���]�?r��@���|�|�X�����i�ށ_V�A촸/�V|;���L<q�if�[�����X轫.|��%��
3����`бsK�8=���B��^b�F��;�� {�f$cw߫�Ti��!��l��`��]�9B$T
%X�CX�>�^��e���=D����.�e�<��_��〟��WQ}�kc�L�a���'ۛ�	k�^|�+zfU�M'3_�i��B��k��!��� �����oIu���Aqrg3.������u���JQ�/���S�#O0�-���C�#c;{��m��Sџ������N���6��@Hʳ�S�j�3~��Qgc��Mz$���V�!�
���� ���������p�p_�-��h���#1��a+/ݚ>h�M�p�(� �"Y��P�_��y��B� �!q�X�6 3sܒ�Ug��yC�W�`�U2��TO��.|)�##�W~�Ʋ�{x;p2�-]�%�	�9 �zz�E�����>�[a 6�:�R��%�	����H�@(�*�8뉽�7��~�����[��7B��0"�3��8�����gv�[�߽�C�㌩^�(�IQ�`��o��W�L���^����\ߣ�1�$���=k�U;�ێ�4<�i�C�^u�uf�zVx2>V(��	�A�Jc
��n���>Bz�N�e�M`� Y�@ 
8� ���)�A �<��0�2����ΐ�@=���j��[�F��iZ^N���j��~���vT�o��5����;�k��_�Q���<�j��� C6�t�Q��B�c�.�w��=���������˽R�����E�[��$�{"�q'��I4'��=Ha*#Y��+:���ҙ�+�_u���¼�0v�<��Gk٤��VJۧ��W]Y���o�Qw��.S��j2���4�Ɍ��"��3Z���j����Q�M�њ͑���E�謹�j��E�ů�2E>P�Bb8#��8'�-Sbޭ�
{���mQ�nA��
=Y���7�_n��3���G�Ǉ��D��<�$�>.��h��fk����WJ�w�hQ;}o7�f���d
��mE�C=d$�s�r�r��R>�Άj�P�*;�S��G~��$�R
���7H#��cM��TÀ4_�~�пS!�'�{�+�Ԝ�k�9l���U&,�|�%��[��lM�g�u����Q
G�/����9�$�:�����yy���l�`����J�|ZP�ysq�W ����c�=� �O���g8v[�[�-{`����}���}�Q���O�E�Ӛ ���}MWΘ�;7�Ş ����?um�K����!�Q�GJ�?��\y�AB��z
�V"R���؁X�kF��>�ht?�����L��u��E��c�Ei�fQ �7i`h�G�J�@�GN�38er�mG�Y@���O�	��Iv �}V�f���y�i���'��Y�Z�hܢ܁��v8u��E"l���l6p�:p�&S�泪?�e�qX��]O;�3Ϥ���4�sl4o�
�熇���]���n�zK����!FM+�˴��؇]�U��'���ZAK�4����E�s<r�y�[z+%��$�s��ӀM��2    ��N�"!�9y�D�Ke���i�F�m�1)��2g�����kgd��q�M�l�[�#�OQw6�؃F�[��x��0	�(C �� C(��<���#�M�C��Wo��0�CI��rv��_��|>�[�+Rn��nb?���UΘ�72Ԣ.@�$z��v�5s#�,���嶝��*�,�����}O��X��3i���R��������0�}C(0�Oɸ������
�8q?�S C `N�����O��a�p�Y����KC�w�1b��yFL7=;�4�i�D ��9�1n�حw�1>,�P�o�j����Iye�Ж�ΠZ]l'�NEr����6���+I��+�>cHЮD,�}����r�tA�=�˰��g�SA�"���4y��1���S��{����1oW�rkt.?�'��o�{6&�wb���{	{R��S��.���V �����p3h��d���6w
p�?Ga"3���uۮ�}���asԓ)5�W�$��ҟ��^a�� 1��FAP�����X�æ�uV�BZP��m|����q���4���h��z^�v�]��~k8����]�ήG�"�YX�R14ɂFŦ6��֜�H�'�V���ӝ]���2�^A�I{��R�S�.{�V�_��ꀠD�0�b��Rw�6��� ����Q�������[�|�u�%�����Y8�3�,� ����/X�\xJ��r�y��.�82�nȊ�h�_����K������\� �X�� �!Jv�q���ixk�^�sg�:v���2�\�r��~�q�D=�8�Q,�s"�s�N���N��w�G4~L_��v%8�={.�0�O� �7�w�:�Z��X���'��`�fryN���
�s$��-���1�*-}��l�Bã`+%�A����T��6����+�>s�O�:�
��X~�ߵ �4G0����Ȋ'~�-�����r�z�@�A������ܪ�Q�����[ڑ2j�]�!	~��������\��&,Iם���
��Ov �3�~c�?��b{���olcxP?Fq��Qb�9��� ASH��#$�� hÆ�ߩB�V}���C�<�b*`*y�	�8�`�&.ೠ�Av�Σ�*����h��`Z�����C����п���F�����cL���m��Z=�'����L��x����̑��A<��%v�2l1M�C�I\?Z@�{�{0������M�@��I$s(���%FK/M�Z&�1�Zpj�y���k{�ZH~'{�"7rS#S�Ch���:�ڂL	Y���5ׂ��f[^�X���`�X��!�cA6�*�{��R��d��f�qZ��\M�jY_�x�AwB�Ű29�s@�^�HR�a� �@Q�e�x][[�8�g�����KhX%9@�����K
IN'Ы-_cɐ�7�-q�u�Q�}Vc���k��bP8s��}�������AP��v� �����.'�K�Kv�u(��$��D�Ьj��jĭ�`��R1�aP��TLB���ۇ�Cd�jgs;N@�c�7 Xl�+[g�NX��M7B7?Xjͣ_����?�"�̛$~�i]'��e��h;��0�j~SD�:���:v|2�z7i;��ͥ�Ѣ��r&�����,�kM5ϕ��m��(
Ï"C(�2��?����kd�,�L�j�b|v޿�AT�% �~�B�8"�ۉ����-F���;�_D�!�`G�{���DY:����\�QT�S�!��8��e��nρk<�d_	�
� U��|#���	2��>���	��	�xQ$F�:�ÿ���^��Z�gK\:�B��7zl�HGZ��W�����W�Ŝ���j��Ab`"W߆l�c\~���s��]M�O�z�8�(�-��('� �u�	b�N5Ss8��� Tv��� '�]�Q��
޾�eέ��kQ��`y�%e��G����)"��9)z��迾d�H��-L'��:��Z�b�`7sZ�DI�4����&m����j�A�����S��ikf�S�y+|�O\����#�{\�]H?�Y��c6<��H<2�3���`�&����gw�@��1�@G/��k���\�����k�>RR�v��E��B��*��D�Oю,؃@rb5K�d=��#R�5�>[W}Ҥ�Laq*�:Ј/���kqo������oh}����I��X�lR?�©��ڈ�x#D@H�8 �I@i�Hd ����k��GЪ؀G���3-e����$���~j]qMo� �C�G�Q��G�*��ˌс�h_�$�@d� �Y�'�n�c�K̄K
)]7��%z���'������Ks+)@qI֦��V{Lcn*��{"��E��~�� �(���6�9»���I�s"�k�^�vtD(mҺ�r2����n��1n��M6���&t�)�j���.�f[拰��lkE%@�wD����^������{4�==rd>���bm�ĵ�LʍZ}�_Ӡc���ψ�o��-!�M�_�J���P��,�8���h��
r���Ȼ�:�u��kX���B�)�j�pun�A�Ϭ� �)��;�зp�3Kj�oatr}��q�M��CY�üN<�.�|^�����m�~j�R�S�.��H	���~_�fb}`��魰��ԓ[�f�K!�uDU8�@��v�1���;j0�]3[�;�P�C��&��`�W��q�YtΔ!Y�����gY�-~)w}��+���<��`܀g-W@4X���"��R���`�!�	&b��n���$�߫��$��>�����܀D�O=7o�ʍ���?8忽� ���Lg���u?�����`w�pY�Ҵŷ��ZO�>!����%5��j�%�4'H�-��~⦁,!�s�>�E��JL�dy�cv�[/�������oB�9z'=A�q�����ȳ	�cm8_R�����,P�Q��� )A�Ԙa��F�H-�_4�B�/�����Y�e�GV�]����=Ď�Ġ�eA�ۈ� �HF`��[�U( ��3;U /������ R��LR�ת�������0��T����z��<j���bq��HV���߼���%�~��%��JO6p+w�Y����b�/�}�o�1qe[=�k���w>��R�wB�R�y�H���i��0�
��� I���~�<�5����;��7/¿w�����$&P��0�g�(���I�%*�9R�K9���($�����a�A��>Ht#eϗ�	I�U���S�Yec%l8҈K�N �&���3�([e��,#����I4�.(���p��D��X���S��OW�b�m��.�7�!�O	4+(0EQ+~c����]v�oEr1������1���f�h�h�10��']�=�>�|..�v�$J-��B�g���-�`�d �d�0󳍴�����K|6���!76o~�d�=L-M%��So�[�����o^ �PV�q��E�ߣȸ�'�nq�����I��Kڳ�c�	T#"��̮�\�py��:U�3����]�m�$���0fFq؊��IOG޳�@CJ�T��T�x�ARm���D�$���.�_�5V� +==*&��p�z��G��(�"��R(ͲGZ�I<L�9{�����_7���h�#���s�4�[�	��"8�w�QtFX\)�P�D�i�0�W�u,�n�Q��S>�S��p��>�&�r�]z����cW}�x��1N8b��~�8~E�ZB= 8��o�MP0��?dLޱ���/=p�����(���rj�vmt��%P)80�{��jڡ<��H78���ܗ_��X�vz(C�~c| uW�7cDغ���Ω�MЭ�y�O��ٰ�9�9�&k��U��
i�m������
K㠀��@ah��\@-� ��G�77 ��#Zا(\���xΥ0;�;-�	7��XR�[��^RҾ���ŖW�?�m�nw�F7�����#0TԜ �h���bd���^{��B�=�����y?����e���Q�\�@}�J�f�u����RI��9�=�ۆ�ޠXJ�|a?�������p]�@a �
  CL�;���U�Px�@�<�	���;���bZ*�i�P)��'�@h�T�zć�yW����[(_�$)b�u������ξ��a�~}u����j�&����J����4NrI9�z�(;����W�2��;�>��0hZ3�f;x��E[B
׀L1WS��]��UdFq0<߾��Ww~��3��g���활��ܻ ! �����T
�%�����W
����$����q�v�����H��VDe��o�!
M�G�k�*��:�;��x���8fa���y�$Ŋ�/"�TC� �a:�6.˨sa~|��Y��8��̬t.w� �K' z�aYΩ�[o���!�z��3=�4��^44�����Y���cU���Q �n;	S9�'T�E��N��s��XjH�=���T��p�U��F���o�-WϢ��:FX��=^3سg�-H��6��`����|��bƙ� {l�D�%
�%d�IC!V(�8��}�"����e������� �߽����Mrg�f���9r#���#]7a)��'�R���0��X 
a{�R�
���Z�ezy�e�y�z�:w��i蛗`e6�R8�Er>��5> �\��(�ߎ����;NF�Km�Wsn9?�uP�FUy�Hv��oE'E�H�`��7@>͚��\�sG���+��M��M���kBQ9� �t��<�H�����3ʑ)Rأ4D��88��ɥ�֘��:d�(��_���i���=���a��-ū�|.�-�t@<�q}&���u�0�6�8����JH�E�P��˜c����=����LK���^M�[ƴ1��{�^h.��w-&�$g�ea�H��yZ���Z�������8�:n��Q�1][�c�`; A�ggy C����
a��9�	�����;BD�����'�_�;�w�������U����|A��v���%�:�R��ʭ���ש\B���i���~�n����y��7�|w�ח
�t?aG6���N�/�@/��.��f�;���3��m�����c�[��F�8v��&��w%���"�m~���� �$��7��4*�͠�#�����m���ϲ��v�d,԰;$Hh����%�"u䕖-����;˯}���f��7։Gi���=,�O�T����V��K;�y1�����41��Q^$��^��j`�@�qR��5�7�����s�z��m`�����d�>�b��9g�TХ��]���k!U
����]S�z����_K(}`fﾣص���y-�U}�����|)*����0e�s��B�z�xι�O
B�J/a�����K��ɽ��Ӧ�gR���{S�������(���m��5�XH�X�GdEn俆�Ra4���=�xN,�t3p�� BY�̭j�m�pSԥK~����W�Kꏩ^�H���˽�)���1E�wei|��}�/��h���J�n\ؒh�,_0[������]y�1�Ƿ�@p�7�z�ts��i%gO/X������y���‍1l�5i��"���v�p�e8�g����f�c^�ٔɻ�W�y��2��C�2*R����?+z���=��m�9��~��#iU�#@^�o�����&+q8N� EO3 
r�M�8�,��$ $K��b���
�AFom��{������� �ȇ��: ��X�W鏡�3�mT$d��3O�<�E2o�0�K���!w��*�uj�.�lCI��A
�E6�Sz��[
9Z�R}ra!��ڲ�0��ɭ������˒kgBÆN��g����}�_�����*CI%	F��~�i@a��)}���*��G�3D�R���/��)�;YP���
R�׷�m�w58��*�Q��F��cRt�uE|���X�xq�4C�L�@�]�SNS��..��I�;����JB���!c���#��IO�����#��c\�����L������`3S����ɑ�JVЕ)~��&�2v���-�E8ڵ�B�B�yy�Q
�G��Hc�jQ/��v�=�����c$�O��%�5�`e�iٖb��吝5�"=b�3j��נn��/R��4Oc��G���u����lmM4g���Dk�\��٠���T�O���[��į-t�_���p�]TO�ѱKV�žo6~ oE���[�9l���Sg���﷍��R�z��S��F��e8|�8������wƀB��v$�~��AI �o�F�
 qc(/0 �=2RY�\G�&�6���NE��J�xvޕ'�6#<[��oS�h�9��4�tM�Ŵ1�tSqf�;�!�xB���Ċ.�ͨ���q�[4�5x�&�v���uv��=��qB�8�/��� M�F1�����";��+� �f�U���[d�/0��j�~$��"�������;�iL��F��E��#�ݴm�ཉ�K��5�sz"�ș=�x�S�=�2y�.�%�wp��,��Njz��򡄋�+~����=�N�`(�:���V��)�"����W�Ş8� ̽:O��TJө6��d�aZ`H��ky�ĭvcĠ���x�pAGyv���~��MV��v�i�� f�P^3��xX� ��3�B��RI:�[��г����������?�2#�      �      x������ � �         �   x�m��1DϦ�m`��3fkI�uG�r�5G��12j7�Ƽ��ǝ�,l�!?#��lhG��Ȫ�������%/�<��.K��F(gwő\��mEZ�<����l+���(���j}�ە�*h���9�Zp���?r}I�'�<�P��'^�^LDo�b?/         �  x�}��n�0�g�)8�,�^��cc�g(`TC�.��F�-R�dy��n�HJ�E˧���� C�er�@�[��0��9�w=�/=}��\��A�I��[P�2�B��C�އ�Le� KL�9T5��|x�m�y�T�AD
`�[&�8W&����;߬?���&-�J�٢?@�&�񱯻�Vn|Kq���*��;I[
�#�}�;u����L	@�J��l_}8+�TT�d����s�Ka`��+��Y��ٻ1/��l�� &1庣*ԇ���\���X�Q�B�Cա����8c����*����֣��.��J�ȉRC=ԭ;�_�|2R2G��c��0mm���3�.��R\��\[��N�ɐ��4D�TЈ��-P�O���ޢ�5�P��O�u'QN��),��'߶������]<w��l�@����ta�      �   �  x��Yۭ��nEqh�/I���l�qܢ�������`0�S��,j�e�����������ǺV_���֭M���/~X�����dL��J�{�M����tX���ʺIt�@%�@��D���������j�	T��L?D��F붒���K�*@"�;�/����.�A%��Z{��ۣ���W��y�<#��@�!>_�5?�p�t�TC��|db��X3ʾԀ�L 0�S)�"|�h!�f1�@ԇ���e�f�����u�ɿL~
�����j�5���3w�X�z���ږ��N �(����H�
~#�.,b1ɏ�}��]߾�9�D�6��f$�?���PP�=��è�*�^]���Y
���p�����L�lڭ;~!SXd���^�(�/��v��7kZfY�ŝ�t�,���&g�l����@ ҍH��	n��R�jL�3=�I)�E0*S'���$��6Zm�&PQMo��O�ޚ���`�ڴN��;<�.<BH�4F�����M>��F"��]D+Ǣ�b2�ࢶ�H]$Y������Sߙn��0�3�C���=B%czL��u	ת7��>���:*ʛ^�{�
mL�����a1���L�����㱪b\�_�d@��W�#M���T���N ��f�0Gǐ���A�'���4��n�91�͔���V*_y<�1t�9��/L����v�{V�(2f��l܆!���ly��g�Q�Ejo�'�(�c�9]��V|z�h��`���䋰Ň��y��	JH�b�J��Un�U����A�6�>%;�HoE��/�jF�*U��Ʒ̖��Jv�tC��:�J��bRG"Ah8'��Uh�@%V��t3�M��x�Q'���9�}lm7T1R��S��5�`)���R;f��v>$}S��lk���3T8E�ƒ�
�9ã��Bt��`��?���,���4���L��B�īm�r���H�~jo��x��=����3"4����i��[���
C}䤆��\�o��aB�>�
��ӏ�ꕨm�c�L6�
�zh��#v*�4;�BU	��*)I+�L�LG�Gi-�z��Hi���X�D#h�{ǂ��z�@�"��D�ӐD��?�,h|�	TZ|���r�l<X�*���h� ��^���z9�L�
Y{F@4Č��H�˷����u�"&P����Q���TnA��a6�J�W�O��&�m9��<��c$��TT�ϒdm$��U�k���ܿ��r��m�վEt�@p7f@;����+Mm��b���*PQM?����Ts��$i޻��	T|��|.8��C�ͬu[<kk���#�;r���O�⃎̆3��O���U1+l�<����Wv�6�
�\�]�J�S/�D<8�!�q�~���BT���
T�N�T=�G'��C��U����1�SP�*�~]��0�kjT�uX'�T��hY\�X�@`�C�����P>�ɶ����Q=�D�g���Q;���A�Ұ5��@TR�u�i��ghk4�Z�*�<�����&�uo�ow�������>�k(�/����������KF�&��L 0�˹9i��>�sE�2�@%'��v{����T*��WOƕ	B���H'��g�;�l�`�PJ+�@`j�9?�s�o�٩��)ӣ����ze�7�M�`Y����_n_�\�T��sl}�*^^��T�+SlB$ߏZ�>��?K)����      �   Y   x����0�b��-�Y���:N�`	��=�Lg|b�˒�-G9�r����+B���u�T�,u�VGY<j�ۆ[u5(���'���0      �   J   x�3�Tv5w�p1�tL������2�Tvss5sq�tI-K��/H-*�s*;9�:;s�&e��d楃�c���� �Z5      �      x������ � �      �   �   x�}α
�0��9y��-��$�ɬCA� 8u�4�AMj�۫��n��;,YW�9 �u�I�Z�2?ŠW�ڒi�D�im���:�.L��-�[�!A�y0�r��0�B* H��;�ݬw����e؊�<�S'4���W�#�V;����\�����R�;};\      �      x���[�-��%�}r1m�����)��.����Y�S@O�珶e��7��N�W
�#_��4��Q�%�?��*����ڏ�^5e-}^���ʯ^����K��?~����˟~����������������������c~����?�~dy)���4ɏ�^=�^�+ۇ���?�������1A������r�-��j�"��V\�/��Z�j7������K#�U�Kkoܾ�[v�-W���WS.%��;y������j� ����T!;M��Ҷ�m׮,�Wj%���p�/!ឿr�n�GX���E��ra�G�Wá�і�n%�犣��")���d4�
�V�m��_z����d߿��Z�K�G�'#���qoNA(~�~������K�_�t.���v��������RÏ�f�U޷fK��)���յ+��_RvO8���>u�����\��"��R}�T�З=cN�#��6��2�`��Fh�5����b�ݨ�Vm���e�8٦Z��q�H-o �G{���T���)jK��������.N���a��_���+�q�B����d����'�F���������3�hE�y����v)�j�A�%�K��b|����}D�z�[���wA��VW\0�jϢ�|��q�c1�8XN��-�	6ۍ�q5�Vȟ�%O��[^�P+��w�RW�+�%�q��P��QJ|����/C��_������g��j�L��a�-7m���2�� j�ՄS�=�K��8)�bq��n����ոO��˦R��Z!.v����t�,�t<��ѫ�6����>��:��	�S���Ȥ����~�F�L�*F��Zf�����dr���n9�6� I��k���3*xײ�--��	����IVX�m���~�v�%^��#�/��6CU)F�U��o7�]�12�/��?�8%¼߬T�D��*ն���.� ���h#�C�3y�LQ��������)B��:���d�%#���L�m7�-��B���󿨦�k���n|f��d*o�8�ReW�v���D틻�����Ҍk����[�����5�ZI4�2T��δ}��:��1�X��^���Eg�mپ���	/Y�������y_,�했sĄ��r���ƍa]�����_��?V�x�&*���B�1�̤�����5>���X7I��W���DýC�4�����ryD=����������⁛1�l�d?�~��sf����ҲT�U�R6$����T��S�{6䌇m��B���!B�759��/p�a��¦�yӎ�Sژ��x���*�{�U���:m�[�\�U��!�4�c<{gU�\W`�/�S����f"����}l�d�Κ�qiX�͊i�,�U^S���N��[#d�S�Y��"�I�l���I�7 {���� ���Hf�ĩ9c�]`��\�n����i��,6{!f���������qj���#������لf��η��J��ޜo?��*�F����a���5;<����ޜ��[;]�.�RVX��*e0Q��;��".�x�f��V\���0����-n����l�Q�R���$��,m���b�ES��fA9m��NL��椧W,.�̢�l�kX�2M�a[j���+~��oR�>\ԩ\��� Lj��);��z������O3n�$�:�����OQwl�����O����9e�m8�rI���&&�7%_�$��R#��t�'�`�ΦoSq��7o������C���6���a��U�Æ97<�f���^p�\*X0��pꑤܦ6]"�xX�/�Ŏ��ڦ��
��aXw�]�PtP�M#�R�U��3e�z����5�Ag{?�&<��?�I�{&��bBtqyB���l
ۍ7����	%���s[��:f��6�Μ��9BW<�B�T^���5�
��I'�D+�]T)���lƁ=�����1C���6�@�Bz��Hլ����C��Qa�u�<��f�ALׇw�"p�޵��x��O�-�H-�B��Ӥ���r��Mj
����]W`{��MX6�|ä*���pPbM�pZ���BkQS�u�)r�|�%������7�E��^��)rPӤ�Ddc��W�Ԥ�C��$EVd�� jiy��
� �v���S$b�ڣ�����
VT�+6���G"�O8!(�h9�:�����e�<{�%Ñ*�e��th��H�>>���2uJʫ��,$�Ey5�L�@����:��y������bw'�Sib@��6�=3�-�mL�oLa	�	�4����Q�g�	JP\���:[�w�K{U�������o���\�RDm�~�5T�����q<S����Y�o�ș�bi2z��&��@��;���5@<�?HXrh��ѥ��[�~�%�@��؉��	�ȗ).{��ݿ�	�8�:dZ�q���E`q_<x�.!�䫦���&�t�O�K���
/HټhI��z��/�6Hn�լ�܎�M2� FFˋL:����ER)�@�Lhm��t�+�a�$QӸ4\�Ÿ����w��<Y���=) �A��}kֻ	}�J��I|���_�heK,ϥ�c�/ӫ��O4���N�1[^am��Tc[2cy�ɓ>�֡��?��4�2�r�b\�w�����7�@��)ַx�?$r�{(���-�o/n2z��cb���L�����aQ��;�Q=�lfi;�&XcT)��Pw��=`=�ֻ�K�n&! bBn�,�5{�ؓ���/6#Z��B�N#��(�m��Sv_v��U��M���#����1���ڰ�~g��ۗ���6V Z�d�q�7�v�%�^f�P.p�*K��z�o�_g��Sk+����d��޸^>gw������`�
����χZ��Y�{i8�K�f:ݜ�?�[�����4�D�>-���.I5�N�l��1�� ��ǣ�~4�	�AsG���mP���C�ir�V\!�9$Iܼ�y�%@�kۦV��"#���y8埐5���fo,�ӀF ����(ܑǉ/d��+���ř8���l�-��=2Gd��]3������.ɋ���ﴽ�yw���2��
2o�����8��5�
3m�nL��J�&9��-���Ǟ�f'!"Zq��-������r����Yj�����I7�6����K�u�^ok�UėD��"��~�gJ���3]��Ѳ�
"OTa"��w,7y �y��k��^+|����7�i�&8S���UW_�tq�u�a���jhg�������y'S'v�s����K�ʊm�x�_!��?���g3����� ��6�~Ǖgٍ�ЀK�׼B�%��~�#c�r6`�G�y�f����jo����:��5k��lvZ6�0�}g3M{��];������t�>�[3$�"����y��}��c:�rm�L�m�qD#S�ʬ��cJ��q�J��o$�f7[>�6׽|=�Y�� �D4���;��:�5��dۮ=��M8����6��!�LI����~k�P/�#9-�`�f�u�����om؍�̚f���D��(盶��fir3Z�u^��=6f�|u~�o4�ݍWk�H�.M-f��!M��ef�ͪ�7�1��9m{P!}�i��$ag�g�O�ȕ"nI��Q|n��|��rߺ?j���Rd��Q��8�mf���R�ǨM�Ş=�6�&����0ʙ����X�&m9e��������̻�+Q����v,����j��"�=͔�v��$Ȱ��-�aAvb�+�n�������"p��.mV�e1&hOF���*��ɸ�,����5���<l�Ld0�FVy/+����Q}���v�T�l�d���y\�v�;k�߮�8�<���B�6�����F�"+j��r�n$Ua���? � ��˗�/��AF��̞0�g��F�D+_���K0%��n�>*7{Y�R.��y)r��B���
쎕�K���bћ����:P���&�"��^-`
\�������g2�Ծ�d�6�bX��7��@�^��g��cF�����$�:ףM�.˫C΋��m���I|uy��֘�#v'�������H|un�H    ��\��}�ph�R}��G���ngek�N�"���?�؆	�<G�ׅMt�6{�w�ɢ��������#�y��[K6�%���Wӝ|&�[wG���u������[��}����k���PcB���Rv�r��]#6����<����f���7-��x ��������-u/?�>������hӛKp��K Y�.�9�FhO@(Oqi8kT:����J�v�-ۦ�ŶQES����INk8�ˈ�!#v�6���K��#��-b�D�%�׈��
"�H��9)h��[��{�?��H��b#e�#��)|>�	��<Fy�Q{�0n�Id��Yy��Q��	<n*0
q�F��u[�JH��+�������D󋠣J�T5�zհd
�)[eh��=�//�I�<p�g-w�u�EE��Yj_H��M�q���vQ�̅72�-�����r�����8R�r�g��m;�/��ϟg$��J**q�=�a:S���O�'n+.�MM�����E�3:D�H�T'�u[��.���٘hG�0΢�%���i��odR$#f��{��Q��eF�'qkX�LB��.����L')��Hf��I-�^��j�P>��ݟԈ�G"�V�K F�1w�!�v��"�w�Y~�D��!Y$����ȹ���,/4�H�3�5����͜��b�8��9J�Sּ^�_o���&�Q�*��q�\�]NnR(^ 2�Ҵ���9��j�)�6O�5�����a��D6�l^�o��(ROU�;^>�W͝�B���(�X	
�;>_}wۏ���a	��.JX���&��P?w��j8��Q��3��H!�]�I[D�Qf�j^���
g�dj�="{�	T)�x�19��Mo�o��I�&�(�(Ѥ-�1t�-��cQX�J]v+�+�%Y��]n�#A����h�b�f*w1)oe��nx����G����!rt�7W��X�MI��|�n$a��x�U$yF;q'��q;�A������>�T8&Y��K��ޓ�|���BHz�+�Y;�F��q��K| �����,,�V{i�7M��F�OĀ���)�� �XjH�CV�9���j"(��~M5�g�7��ȴ"{�β��k�L�#���yy���M�i�i�\R�a����<��tV�r��P	�f�&o�b��ٜ)�s>
Ӽ��d�x'�vH��^�KcifeW�U�B3��#���2�˦(�f#w ��Z�l)"�ҍ]C�F���E��c���2�d� �k�{����3����4H�"a������m)~Z]�2[&i\�	ꆚ�"wc��6�[�i^y$]e�B޹y�ֵ!��͌49�#�)K�F���&_5OI9$^��w�A��Mt�>�y��*d���r1\�_�<sK����v�q=�,���\OmB��YT��9刬rA�n^�	}�Y����ӊ��,G�9k&+�!���41�f����ꦶO����(Kqjk���\\.��&k�lZ��q6���{�\"r+�ϩ�od#���H�A��YW�t�S��6�B�'� Qo�,�y�I㙍Ȟ��(��(`���;Gܣ���B��"M�Q�<l�"p�J��S�@6�UQ��Qʳ�p��xr���7.��*+�2!Qo���=��`�?�!6���޶�X9%g��u�:�\��^����ݿ����f�<��!ޘ^a��_����_��EL��nxf����̗�0�]��jo����c��f�ˢs!ȱ���j�%G<)|�ŉv��;�ɉq�t.N���������������_����������:7�)��rD4�)��s���߹شi���M��ү��+0XW<�����k�/�����;�K�k�
��Ρɫ%�����`x!|�S?K�k�F����������SW��?�<�Bߴ�i��ҟY��'J��9�{,1lf2��Nf���i9��eof�b9�C���3,�e*R�����c�ޞA\9<3t�;�N՝�6�)�p�e/���m<C#���8�In�OV�麸i��ɱtj��x�����e��.Op^:��{�37[VSvoHv,�z�=���Cڃ�U8+����+u	�Q�����OO�d�D����Mh�`EF������3���AjdD�:/yt@sA��Ol���G=�'k�!��K"(�A,�Ȩ���<��@�vD���=BB���&=�)n�<�B�Kޖ�:���v�˷�5�^zj�¢����H������5���({PO��p�e�c��S����rq�a��ˍ�Z����� �ſ��S��1��7��cq"�|4�9�"0��J/�	����[�$��ԑ�|��y���г����`_�Uo�<cǇ���ى�L��p�����7�&��Mp�:�
ǂ�N��[���}7ˊ,����u����z+��v����Y���?���F�G�ͼ���hwxm[:��~l����w�E�������c��{������}�	=	��s�X2\�%��b���I���ϳW�I��R�p�$Ai�֞� V���/����F�T����-H�xs-1�Sr��z����Sn	�����WGb������G�3� �|�-"{h��t82�K^I��~����#��=
#��#��r��uzn�E��{*R���2�܉����͆'V9�8��{P��Jq����L�����O�O�aS'R�-.U��jB���gp�e$Ŷ6��op�J1��8Z��ʫ�T���he�Yo?s"�e�b!��F3����+ĭ yx}~3���H�H�&�K���ie��g�����t=�.9,eb�95c�?q����r�����ƍLq�ƍnԷ����#�91~x\R�PC�']���w���o?��hւvه����9B�Tb3��
M�N����}���@=t�%fi��=��G���rDgp���F������3�:�(n�Zgd������{f�ƗP�b��x��3��W>u���sػ�pEm�ϜǬ���C:����%�e�M��;�aƦ z?;�K��=�MF��\N~4k����ގV�gh4�hiϔ]���Z���K��~�!�5Eh�m��uט+�F��k�X�|8C���DR"�[q�A�r�#a�n�Yk�_]ˬ(|C�9!3�������
�(Q&M�FW#�H��"�Ca9S�а�L��G�D7(^����3��{t��SoU�ai���K׻���Ư�)��|�|��|ON���G��.�4�LCKB#�*#`{WG;c����OMKrL�@��Ώ�n) �C4
H������pG��M��,z�q�	��p�F�T��a�$
�7%mv��SLl��i|��:�����M�Jd��7�� d�Kj�^Ò�S�(��(&�m���3h�B{�����^�u7���
��S'���0���Z?f��n0�*� ;������)5i�����m����&�x,i�J���m��
��1�R�q�3�+	j/<埨_�5�{1��/�I=���i�'�f�ف�� ���B"�`<�����xr�g�\%R�h�����}:g�H��3h���m�����h?�9��G� �����V�(����@	��]Dk�=wci�w�*��'����]�ѥ�&u��$��YrE*��Q�a�^"�O43�|�/߸��X*��L��#�Ε��c&MK���a9�q�&>�.ES�[�>7�d�i���v��
6�b�=tZ�Q�c��L����j:q��͛�`I=���4�<�o\��~���_�Ö�H�JM.����G��J�=t��=�I�,� Ӗ:!�<A�9���xC#�Q�e���IK FÎ�2n�/`ѣ&��*�v��3ZJ����BP��66�񥰷5N��r�nR�݂֘�<�E|(�xo�Y������Z	Z�<�9>o��1�س�W3�C��<Ƿ�=�Q��L��7�2�B���qњ��'*
7[��ѐ���F+��Is�+��~��^`8�<���#�&h?�~䪟�7^J���+W}�v��u�7�������J(�k�8{����{m�ZZ8�r    t�2մ��4K���J Hԣ+h�Z!���{�]�����lZ�}��i��X�Mg��^�j3�Y&���6
!�Y����
�bJ���WUF�ӆN?q =B��~]�Gm@�P*��NMؔVl3��%�/�H��4��ÞB�(�7ޤqI}x��r��t���1T�|Zz� 25���Vg0����Ah:�K�+0|L�q�wM g��Q'j*��TVhi�����~lt.�"���3��g�t�B*�4�����B= �'�j)�.��,{˝�6�3v��^2���g�i`���0ǜo:��5 �O�+)�z� �Y{Fxw�g���I�e*S���0���~�3���s�1VxEƜj��޶��%b{=V�j_�Mԛ%��b��8g��8�]k�q��0���i~��p&�	�4�Y��|���U�q{'��?���H-qJ˒�>����;&|���Ƶtz�����' �g�����s�*�J֏r��߃t���p3����9�sBѱԆ"�fi��-~���kM˟t�=����7M�f� �H��>���ݵ���u��	x�v9����.���2J���ؑ�V0����Lvޚ���Z�����p���C��R{��榃���{/��U.v���]-�d��t5S9�oʀ�u`��#��$����C�8���-����$�C�@�B䵩I��ז��
m�;��{t����;﹝>�����
�\OG�T��C�^�&��=�L�*�Z�k��'�'^"�	Q`��z���Ac�k1]�XR���Q��Ge�^]���A���3���qę���W��}7f��k���
t�	��i��I��Btl=o��R",�����V���U3���y��˔�p�'�P��3��|T)j�F�>u�T��qDؘurK���c}�@޻Ke����6����s;S�0L�6�3�s�����Uy�b=Z�]�Y"�'a��+rm�X�O��e�3�eLؠ��3���DAǣGo��g�a���Ȍ��j6K���s�Af.1�=S����|c{���aѺ����|�,�=�'�.R# ���^��z(,�FA���o������Ól�x��a5��p~��TJ9S�O@ʞ���Ӱ��\c(�{�.��Ȍ!ۭO1݁<t��:2|�&*Q$�ՋA+-B{�����ِ�) �QnB�@�~�0v�ELr�m�K�|[�w�1{-&~°--���W4Xv�|�2c��/��ڧ�JN�-�/�����T�zؘ�K2������?ᡨ���Ph�u�����j��Ǧ�
�ho��쓣t�H���Y%`��:0F ,4�`����}��V��޹�h7O1�742%����D�z�R?h�uDz*}�n LB�!=K��O���AL�&Z���R͠3~��k�Ю,���f����ʨϼz�bS?z�� ɜ�����x�����9��r^�����`N�|w�-fp]�	UB5�ܕ�d��]s�����H�@�DIm��G� ��ѫ֖ Dx�O���>cAQ�"v�#�بn1Cf+�iW�p��$��j́#���hW�� �:�ʔ��7�=3nݾE�vLN�G^0�=�7��9��\��6�J�D���CPa���ܣxX�n��̠o\t^$��0���w�f�{Tg��q�槙Fږ�z�9n��=��	��Qē�wӊd� M>? ���kP�Z�t�0�as~��)md$.�w){\��tF�iW�I��}�)�������:}"���ﴫ)�6E�r�h�6z��7��T������&��C�@7�����l��?��<���\�;d"�yڶ7�#?��Q�%�6㎝ј����.{���K��{�p�&@��q�\w�#���ܶ��q�2����j��u�o� �Q��\���v�u:
��%t����f{��'����*:"F�OMK����֩Y�oG��	��R��F�qe9�|z3��¡���vf��`x�Q���gh>��w����3���������-��e�A���@��0�:&T��U��3Ӝ�i?&�{/<3l��DΊ>���ȷ�s����L�&	�c>�U�dӳ������5e)+�Y���{���9�V�dJm�h�A�j��4��-�-5���Fp��Ńf���?fW�-��юnf���|�n���b��pŇE�Q�P�um��~LQy�򙩳�ī�z|nd��L^5�}'2̇SǶ\�q6�e�lkJ��;ٱO�3�Ln���u��cɳΚ�?����7Q�~��t~� 9�{̓�r������g��z�J��q�Q�9�)y ߟ��1͐k�U#�7��?*{��	�
{;�z^�4��.O[����5y�������K]Q�'���{��d���}\�D�*O�-B��ĤQZ�qp�c�>A��B?S��,ޜ��+y��= s���.3QI�ZdL��R���py=W��=�J�|�LNO��bk�zW���2�u��>v�x���z�m��\��默�� ��9�#��]�f5?�q�F��0gny9]�N|#U&����d����BqX����=���G�Y�e!��J�Pb~b_��1�����%gHb�W��p|�J�#G�.���r)�Y�O��}�"���'���W��w��˶$Wu!�T��g��J��K-���W�kCJ �	QĈ!,��%���
/�p��_�\tOk�3)1`H.�Ͳַ���e��)�O1�+�,$oMa&[O�������Z�U"'EM��I�\e@q7s]���ؿDN�u����#�@�&Y�OY�O�_"'�`����xE&��J���Ϝ�{�r<��<<^�f��k{�!q=����Ϡ�
�3�$�I��Fh�Y�9��C+���G^�ѓ\��B�����"�����}ғX��ŝ�-gY���@�D�;�'�"-Bcʶ�zXD�:W���� �#p��Ǩ<]NçQHOZ�
����@���΄iDOZs��������ݏΉ��Y�&�؅N�(�Y�·#wa�fKO\�+̣;h!Z޷ϐC	�I����P�+tW�#��H�H?0� �BO�C�+��L�����l�hm�R����`�ҙ�Y��X��HY >i����pbM�zD���d� ?����������rI����&�=�{���U1Jx�	�`԰�
ZޑȤ=��uL=�i��p�b��x�睽<cS�qc�ȉ�c#��j�ZzG'3x�(�8��P��(=�ى�$��<��(s�Ti9����Q�z�Q��>��<��``�Y��#Vd��L���]�����WJ��ZH��F�*�~�k��AQ�1� G�NV�O�{�3x[�a�K�dO��M�2{�N��5r$��'�a㮵g�g��S(w�i�d�d�lËm����q2����Pg�G[�T�ܱ%��������Ը'���Wl���T�/�^�Z�������j��h��¬7������1~����cD͂ϐ����]ǒ�;
��=�U��o������:�`���X�k�>˔�d{>�i72�l`B���Z�!n{�:��`�\|�� ����	���tL������։�.����~�ά��{=N&��S��@vg��S�$��\Æ�$鬟��7���qvF��ZD�1q���}���*y0ң{;�ik����&�;�=��hv�9{h�x
&��)����;h�����(�rL!�9��[�8 �F����-�!�~O���Hg�q~kF;- 8���3�N�*��u��dAA3Ճ��
9~d���j�f�jG6L|(W��=��P3�g]g,�=��/A���K�x�iv�����KV'>�4Y��=/E�V�:�� O}XICPM}��DX��<*G��q��������3�G�2�S��T�����5�I1����M�� �Ѳ`2�X�f��w�I�w�v�����<��70j}3F��v��f�T��N �1_�z]8�;�ƉٯD/��)%)S������9��[D���|��=+3{u�(ޭ �ل�Y�����i	��l��&c�@V7~�W����l�9"7o�k*Y���0�q�OE������T$����    N�GF�f�)B{���r �K�J�>kC��s��B�"eV�Єs��U��)BW�"t�@;�& Sw��`���U��������1�zU0�3�敩�|>��E;�`]NvdD�Է7�S�?��#�z������sj�>��ߞG� M��`o��������ĝ�y���H/4g����J�qE�$2#��3�W��g���d7&��x�m����M�vA%�V�����>y��L�'>�Ր���U�z�V��@�y�Ŀ� ��E��$8�f[��}u����N�h���_�P��#:�m�����N�pE3��!DJ+8R͵Ϣ��l���2�<��R�;Q�wO��٦��*���	}�+���R��JǨ>3�<��Ol�5B{�\��ԺB��R��I{���H�k�0�^l�l#S؝I���x���[�;�5�oh�ˢ�ԭ����H��AXA���"�@}���7M��~b�i�����C1���m����F��yx׾���?N��<4"���j`�@>*��Lݪi��j|�}Һ�wL4�5��w�ڌN+zB�li�]z;vS᯽U fp^�M�q)E/F`&dW�oU���������]Ȟ�CӇ"��|ޞg
�d�̘�?���l�߯�I�Q����M�)��d �z���3�D��y��]��)����	]��Bm<:��3S�h#f]��i�����3�@MN.���u#���<a\����P�X� �� v���4�aw�dԤܚ38p�V�Z�,࣭�$�<~FO�r4����G�*��[}�FtR$a�<z4�r�)K�@��E���+0��s��Sow�����{���'��s#�P��̇Pɷ�.��%�Q���8���O����qԈ\�IF�-�AP�u�v���t��������GfA��|IO�=@�!�z���m�\tٽ��<�,�YGH�@��jJ>���MOY��l�r�U�u	t;���{x�_o0�_v3�]��������T���;-}�X�ީ��f�jp���t�����	f<�8�R�'h�� ��}(��~[D�:L2�$��]��6MO���\L)�O���t�ZQU��?�M��8��4*����~>
ۆ��:���-ڴߜS�AȘM��Ǫz�Y|��]JK���i�SC�GU=k��Oz���!?"#��� 2�-k�
��
c�;�9X�;�r�ţ���J$�-�=??�+�
��	K�7<�%���p��t.��?�����hJ��cȎ���JϞ
˞6<���9��$���~�K�IL��&�E�4�h8 Y�
��wh�`���1�������UJd�B��������tB�;S��@<��%�1]��|oXM���#�-����{B��0�׺?��'���9�[ڨ�K�C���SF.�:E��pK���r�v�v���}̧��2�|�QI��s�YOs��S�	kx~Jm�q�#�L%d�����i�O�z��{X�"�t]V��Y>�ٮ�f7��GW�$T#����i1�N"W�7ܷND0��O1S&�KCʍ�Z�+1�����,��#��t�I�f>���}���[l筍U�2����1
�4	�Aȉ�.~e�m~ �7�w��y�&�4t�� �k��ɓw���?!Á��1�r�%?��j����ikr���ݧ����ȋA��"����?����Ʃ-��j��.��0#p������Wh�q)�B�-�F���������W��{�kvg6^���C�����(ι��.-�h�m��^�3U��^h����[�cӷ���ὲW�I��1���g�_�C�q���m��)G�s�,#D��8��8j҈�k���odP���3����{��
Qs��H���
=Q�'�ɧ�{���<B���[�]�C�WPz�ʌ��;�hM�9��œv���ye�����Cnn/�1r���R�,��>(En18p�BJ8�Lí�Y�˶Ѥ�ta�7�>l���G�U��Vh��0G)3b�'�[@���5)#@_��y��~�}�Vd�r9���6�f��[���s�f�RХz��h� �]�Qo�����z�!�\G�Yj�v�!�'��򽉲s>!8�3�zg���%n�cd��c��=m�1�Y���ɮ�'I�%@#��M�j�����IUY����d��>�m�O�'��|L�Vn�S��Gdo,ЌI��GŭJ���`ݞ<R$�h��K���C�)+��/q"�|��BM#���\�|n�)��&0[\�3��6ܲk8w�q�DF>>.���r.��A�(�?!HVpk�'e�܈ӌU�By�����h�������R�}�|t�����ٺ�1Qv9�� z�g�=���7�o\d9���'w/�h��S�~>�,\3/O��mh1ь��V>�x�F�P�{|���`/�K+��#0Pw�$Fy��y"?�=H��Aݡ�xs>	�od��%�Ra�+��%�K��40GG�1}*C{��Z|\�T(�+�L���l�6]"����왁���n��'��5@#ƻ�S���_�^�4�w!Bsy����+����
ޫP�{D��K�r[�A�L&������^�,l|�DBs��e!�#d��zI��Y򊌤��ty+�Z%�~՟%��<�����!L5�@�ǝ�01S���>1'��d��f
��H~8���I����
�n���?�O���1\�{�
Ԙ~������7�H�٨�'���7�Ht��I?�L]�a�@�w�
h���-����>��~&得<ğ���Xz�Ug�����\̝��)����d*�Jy��Z&` �-�h��՛�y���(z6%���|K(�����T;,�V��̽Ǝ|�iZ��z!M��1FU&��(���7��̧ڷ<���(�R�f{q�=/�� �g�.����T>(ý>��C_�ghx�Jx�ĥ1�F��� ��`F�o��ωF\3�vFv�@�Y+��&��|�����j��)��H�R�� �"����NF+�Ѵ]ovhz���g��D�]@;�������"p@c$���%�����g7!��:GhO�ov����^%��C���}� ��:��jGBL����=>���I?M?�+��X2�($�Ö�}yü���>ᝑ���zy�s9��K�m�s�'貞&�0[�X´����+��3�G��K�Rj�Ҙ˅��j��4�kww8�2{�`7���|�+�2��]ܮ�Ls@�1�G��
�H���'l�'e����S(���m��p���7����t��^B�0Y��	��|���b�I;�����3;`f�О �0=�����!N���/," �1���&��{ʫ9Bϛ��ĳ��ك��.��ĩ+E���r���e&�g�����7'mh]�9�ǂf<�*�"�t�'d	ȣ͏��,�QA8f;�]�W<@k�����4B{�	xxʐ�� }&<v#}�Y��4�	����0��ki)"{[q����R��¦��k9s@{
tc�"�����:����!��X�yҜ�Fm�&���	��>�p�f�����gs�gX�!�Z[��Y�7jm�VA�)�l$��n�t�ި�si}>��7�ᘬ�h8S��<Z���"XG_�3&�	�;�a��G�V�J.+�:Â�{{�S�M���f��
��Z?�#P�U3	!;.,���h�Ddϡ0��ud�Udzb�i ߞH:�b>��)������ZkʄH0|$h|{��ϔ����nJQ�+��p75	�ȷD�S����	I�����)�ɂ�� �#��-є�A�Q惴�h�䖾��Q�Z�Q��i �w�ZVhu��I��ys��Yd+=@� ͂��>WhL��W9N�	:R{��i�YE��p�;7���U�!��,�)��m�%��	8��d�{D�^u�{��@�_))�WÜ��n)hO�x�6��{C{�d���U{���ʽ/z�F��b��l� &��}���<�c/.�Qw`���$�~x����hoA?�J"4����L|x�-i��1��8PdN�b�������[*���iz)^�z%�c-Ȱ{x�-� =���h>�5���    ��31?��6��7�/|�3w�9bu��+�L9�X��^�l�6S��`�}���\�Խ�O1�S�{�JÑ�K�<=����*|�����nE.�<&�W>٧�m2ƤO�	jy ���y&�X��-���vK����"���T2�1�y�?�hю?�`P�MK����L��z퓁@=_p��7�����b�"# o@���æәY��1��2�T��τ0��a�y-ߣ�^���%B����qE��^�>'}�Mz�Xx$�����k,��}�|��!�&��X���^`�]J8n�Fr�������3�gxH7ަF�]}
(��2?���	�8��lC}�"������72�ъ [�E��s�ޟ+Ɠƥ1�$�7��~�?�Ja�v����h��-lZ��y��=d����o�c�!3#C� ��m�Rֶ@O+��<��4�BS�&���9/�����>Br��Ť^�21����&~
sec��}�%7�a&�t`h>"��3�全��yĶiV`�{L�`ʦ$���}����� �v��5K<+T���ǁՇmOy �=��^�KP�<��@�rM���墊�����li�{�����{��I���W��X"��lR����t�e���3�M����}W�,�/�;���5|���^3;tR�0�UG���C������KD�ל'��@�n���(������{�~��9�7�w~j%�����[Dvz6�g� �ȸ^��L�7C�i�����p�yT��kDLph+ޟ��~�zޙ����3�����'��l���]����c���b�)�;�1�i�^nN��r�o02��NK�	]S]n�
�s���x�F|ɠ'i1��[e��h�^U�OLo
J�RI17��L\�;�2�o�dr��{�5ivs��P|!���$V��R�)$}|�����Ȍ,S���F]�+ oe���2Ki�v�������#���o�Vd�d�,�e��V	MvP2�i>}�1:u�xi�O�w?y�h� �wTZ��X�i7���g��Xr�!��+��aw��k��W�F>��p�d�w#�d�` ���;�(��%8A+z�e���dL��&mo_��9&V�V�5.y��Z;�Rp��,��R�^1^
V��4J����
<X�}�j��Gd��d�k"2h���
'���o�wv�ޠ+�O�m9���;�4%��⦯�_�T��Loq<��{e�����4���U_C�ᄙ>����.��<Jo:=ZoN�C`���"���N�^�e\*���P4	� ��ɧ��2���y/yjQ3�w4�v�;�-~����x��2c(" �~�Þ���v�T=�5�����<o��RD��%8�Vdt�6 ��Y���'��8
��<�DX��ew>e�������W)"�H�1?32�"S��~����	�t�7�O{i9fh�������7i	�t��|�2��3�fB��V�(-{}�>���H�M�?��X�I�Ŧ��������S[o+�7Vj$u�
"���&}�9i����F�1��9�go�����&�Β�����0�[���F�9�M�0�j���x�x:�m��oh� ��BXL���f��n�%I4�����D�����M7�$X����J�G6� �/̱{&p�w�}��g/G����Epu$��#��6"��K��1��=���{D�A�Fݟ�	Y���<����@!i�G$���i�=A#\k��+G}��>����J�?mO��w*�=U��6��?~��#�O�6u�G����o=a΄#�G��.�����#�d!���?����;�eZ�����"�}�v�|��(mk�-G��'b&)��,G]��p�bZ-OL�d�\0���~��І��}�P�`�웹(���jl������#�ԣX������k ��^�D�
���+=f=�ӷ��- m�����ʀ:Xc/eӎ���K��<�͘U0��~#���h���Z�t�κ���SQ����zΥ�y&�v�R>k���O����z?��h�d���+�o��͞�c'Pk$�YF�=�h7����#��vK��Mj?a�8ً���gfY?As�f����Z}TxR��I�kx@��q7���p"�[�_m �'d� ��LtD��U�_B��<J�0�+�[<Zř*�L�#�D}��U�H
��ՠq}�f���,����]{�O�����s���%tTM �Of|���}��h���(�'�ᰑ�WgJ-���a�Dn��?QH��LA@�Ƽ;�lT�J��+�S��6�y�m#?#c�i.B+��%HS��=�*���"��G�?�C�&0ߠ��u{2�k�V��[0`J׸4lM� (p�,���.<uN?�*�%w��� ��:��)Y�gA���j�``-��k�� ��gΌz��ދ��|,��B&a3��%���������)�%�F)F��j㯎|�i�����g|$�_b��Q`>�y:�?�|ݍ5׮Q���c�|�H�G�/�^��FH�Ʒ���W'��T!ꁍ���d��<�p=�ǯ3?�Г��k���~����v���fu9�_6!�3�UҲ�_�f�8n��^��_��.�������9]�u���J���y���/�ǌl�C&D�����AV��Fխ]2�!��]��>_W9�	X�~ #��[E��LӮ��k��xn����I�hv���p�L��QZ
�= _�ގ�y����%)l�}�[Ҋ�Q�PR��'�9!j�p�.cr$�q=,�ًt|��Oa c�G{�:%cp8�q{B�d�'
�12r`�eO���:��z�eLG��~W���4�i��*_m����>@���	�k��}�p� n�4�z�K�j�� ���2�����A9-w6�����#�v'Z���Q��F��`� F�tn˒�O��8@#��3�`~qJD���֗�Gі]JAoѲ��Wєf��X�1��k1�t���CC�^���%�6���>MO��M�+s�9c���rho`�\����2�e�| ����r�@F%"�)"{���\:Oy�:��](���O���K-!m�������+�v���;�@5ݩK��y��^@�uI%�"�I�������e,�Ӊqh��?���C�4����#����4��V��a�������P��=�^���r����qk�ȧ�%�q3���d�H0�#/?�N�0�(.a�P����ݳ��|�N_2�Ӿ�|�l5�Y��	9����J�=4�����=��<!�dL"Gy\D�>Z\2�����3�L]	 K^Ps�S�G��Y.��l�Y���LA��0��� �	� ���i|���r����6f���~y>Y�`t$�%g�ؿ0�/]��;��3ť_��{�/��)3�����Q��AhpرO�E/�ɫ:��G~hO>&&4�O�6�i79�����|Ls][�]Ra� �Wm��޽Kf#Z�]��p{>��9�	���*D�al�v	^/��Ne~?�'�����q�%vY��-������}MYz�^b�6�hsi+��;�M�/����pg^�D�/x�H)��/�y�VF����ˍ�+�U_��g®j��Y��̖WG�v�|	}�8�Hz��F	 �쳂�����4��p�$����%�z�d*�{���?�x�%��v	�@~�O��s�T�v��TwK��'�������m�j��A?�PD�,[L�(�� Î �j��,!�7���UD+̦|�n�G�c��6���Q�#}`�ǆl!�G�d5.U/1N��e;כ���9bx!zR����)f��\�ϠK��z=1U���CBy�7臣�<�)�wɕji�St[�
�'�0P%��搧{�9�+6�^��[Gxcw��`�U��	[�6fM�Oޞc{͍�	f@�aR}��D��c�ff�`�?�t^�z����nk��b�'�f4���h���1� �d6�����j�����Dƛս�����(b�{��II$cL떽]�)��X���y�'{�D�#j���1Ƅ��%�,��w���r�c��ƕ������>E����-f�bIh�l}"\�VX��>�&_:R�ҋJB   �S�1�q��q���C��A38Z!Ԃ6�H��M�9'��R��>�w&l����r��rG��/2+W/����F�i��t[�M)�k.+��U��B�Á�M�0�'0�?�9-�����8��q��L���tt�i�Q{T��i�Y�_`��Q�L$�"��V��y��/d�@b�[l'o��C��g��F��,7/
��뽟y�V4�P��|�'p��]� ~�ν:t�����eCIZk�F"`�2���<����Sv\��!�+8b奠K�Y$\C��M&���)�ۇ# ��r����R�/�w�1C����R=q�g���p��@�B��v��/���p��Szj�.���"�W�K	%�&\?"w��i�	Dw�o���:ZE��U�2"�O�r�L�J��mcj�I���ya1G�=��3f�vF}m{~�GT����ݦZ�i��}R/O�>�^��	�].�+�~�ϴ��ޢ�t�<]��R�9��?���wm�FBU~r��ݵ���ġb��V�|�x�K��-�������m��Sپkܷ�-���q���5��3qi>d�j����z;��Ľ�6�	���L&>{?�?�Z;�óO�*����D�>����_��`༂c�����]�Y�"��:���cA&\������*;GH�r�ӵt�5�����Ϋ糔{����陇U�ŒW4W7b�C����+|�����pM���˲�1A �R/�QH����&JO�@���~�6���]d�+ G�RR���d^��-����7s/�
���04���Ɛ?��gl��leٷ��� �M�9� #	�i����9����}qa�Q￞yhՐ!��z��t�r��;c�+��e�]�����o��o�?�L�      �      x��}[$;n�w�*�o̅�/�+�o����I)+ER����0���Q*S�]�.|M��B��k�r�?|����˹�t��s���������|���S���	.����J0��m��@��	!��J��>�B�W��"g����)*���g�#������/��	�?{9N(-��`�?��o�?�,���'���?�qƃ�D
1}|9����ʃ�\R�cK�\���'��񡎅�=��{�O��g��|\w��q�O����/�?���ZϕK(y|��� �_�,�5���w�Ǹ������?G�d�7����fa����77�Sl�s=⧘[��Xx+rB��2��[��X�>}�P�'�*k��X!���2�{���N��x��|CާV]
c�����<�h���×�ݚP�V���PSO��Q��`)��G����|b���7�Rri{���u�,>jx��X���|,�c#�Ws���l?��OT9�S�c1�<�j|C�}�r�|8�s��!Kr���������(!�NK=��Ƿ��j�"���gnı�c������|�>��;>WWt���ޕڛ���9b��,����t:%����8V�9]j�9�?iX��Ų��i|�Z�X�mU��?+�q���p��.��E�����%f�K#d�*އ2"�}I�Sh��~ҥ��B%�_�8��E�
�8u?<��҇�:Ʃe=�T����W}���R�0f��/��P�?���1���l�G�b�f��\����N߫�W�x�o{�|!*��9y���s�qDǼm&�]�zc#Jg��P,���:!xc7Ȉ��	�q�a���\hxc������>��k�F�_P���$t���M_�ث��#���w�����ԽQFК0�u�o^{c�pJ��q�1�-�������`"�VJ��J�� � &��������i�z�j��8:2=W�sf�@��P�rX���]i�v���=��xQͣrMc�q��(���]j������Z�k�-���XH���5P�J�%u�`Fn���>�����ö����QF<�`�U��x4ژ+1bp6�~Bx�}�5���#��g��?Y�׺�ib�ȧ�`�[������~�#m���&��}��Nw�vK��`Bɍ����=~{������'�G�#ƪF�yDp+���,	R���OVz_����W�?k�!o��WT� ���x�NG �~���~Z�3a���E��5��0�.�����Ψ���O�m|���S��-�L��y�����%Z��_"�J+�y=�(?��Q�?�X�a4�iȔ����9PH�@jx�Fc 7����o��i#�nu��ղ�����Gĸ->��hk�4�4*s���^��NHs��6�)�!1$�-��*�A!��G���8e]u;ؔ�'+�����ƭ=��|��? �}��s�q�F�ҷ�/��b�+�w�����Z0]l0�H@{����~ӣ��JY�$9���G�w��Ҷ@��Ʃk�����3����4<@V;�fIbJēq�kc��E�׹��0�_��x���C3bE�O�q�)�!���~q���I=h���J��Fj���h�������@E�dƽ���b��h���/�o���g:@�������s+
�18���T���/V���Ӯ1?s��A�z��9���92�9�Q��s ��&^���@�M�r��ߕ#�E��WՓ~�ĕ5Ε8.}B�-Z!3ZA�_��MZ�؀�ـCЩ�����?0�_я��_�d���5<D�$ႅ�Uڹ���7����k څ�����I���HnN�.q�� ��X��M�
}ssL��X� Y�������c���rx�a���ߣ5���J�o�a��ߨr�W�Q�j��j����j%z���@@o�EeI�Q��%>4�����ak�Ȳ�N*ۋ��V��V�A��m�U�x����-��߃ �J�{�N����p�̴j>�jJ6lU�����Γ����dQ�d��*�ds�F�Uń�����q���:GI|�u�ϯ�(Y��Υ�璾����Ǯ?��;9$��o9.��	�M9�(��6E�����y�[@X�2�yz!�<�u.|��MA?��V�o��Q�����m�W��,d�,���x������B��X�=�Wơ�_�S��t9��8��8��)�W$�w{N�g3�6����_�Կ���8(R����w�A-5A�F��r6�ڼ��c�k� �I�*����HRq�!�`.�|���q��UyW���:'�:ߞ�:�U�1�Wơ���<{�'~=x�ȁ���]��!���+kC?���H��7�ԣ"��n)1�8��w����qZ��m>�4���מWƁ��{���p�Ȥ�lB�)U�KCJ���F��)�  (v���~x�id��Bv�+����C�n��.i���/�����I}GN}��iJ�����H�S.�z���)�n�@�-2D*��&j�sjOM��!QZԞ��
���uA����%��Sg�2iH�?�
�(�a`���R��949B�#�- 6��	���'βr�R�	��� gI��8�tbE4���ỳz��N�	S�Q_����z���+\dDYeNY����&��A52&�J���V0�O[�e����P��+���P�ud`�q5���Ź�P�?hy��U��5�{��V9��Kpt-�h��$��ܫ0��4Z�4��b&�4Z�+|կw��:l�L��ˌ���¿EK��[�U����8�Z�qZ�p������˵�������]Zt�q��ep��q>���yf��#�4���\g�k��#�-��q�C�=�@�v�@���ge O�O�]obf�@Ba7���Ou��w ߀qF
���M����8�*������c]�b�҆Қ'@i�"Q+'Q��A?+M�Hˍ*2���,�2
�R����&-ˆ��IKbQk����BT��ǑK�l��S%ۮ��}���P������C�>��>��ܧ~Ak�J�P�����������V���̬[��7w����K�MP5�k���i�Գ>�'�8
1VD.�p.�pg���ʹ��Ѫ~�9f$�R�)?����H�7> ����;�a���U�d�Xh:Y��Yf�H,3���r2֠�F2vr��Ұ�-�5N�:s���!�z��N�i�'^�>AJn��Aau�����Iˮԙ��ǡЊ��W�P߄V$��P������1'�2�}���85�#*��uZ@i9��K(�l�F������:�����&�F�����p4��e-�B�^	���
�u��EK]�R�Bp��!$�7�^aғ帤
�K��������f�L�øYE���U��-b��E�Ni���P�{����a�������ˑ�V�^}�T@;��;l�.�cl-t͜n�^g�ϥdsK�k���+���
	ȑ�F�����f%co�����AS�x$2#'2�7�$2�o�<���_|ˈɃS�{�!� ���+��C���1tܻ%���7ki����X[�Y��9	#K�ʍ����ͤ�^�Tn4�i(��MDA?��tZ�Td�*�6�8�B`�=���� �*"�( \�C+`&�d;c������4�
�������Q!�&�O�V�F���O��OЏj���'Lb3b���I�M�@��ج��P���R$�r|<EB��[���'�z�����50�X��}�{�h�+F����j�ڞڞ�I�{xi�p�yn��u)����l����Oym1;60"�/�A�X��A���=V�
}���5���q����>vrH%�>��� !�GԼY�7��po�5�d	yH�~��%���%T����9�n�Oj}|�0J<T�vd0Nmy�_(6�l�Vu~粭�����S�5zu�L)��Vi��r#�~"g��k
�	!�S%�s����O��ϵ���9N��XjN�C"�q�^���A�G�8#as.�j��/~��"�U9�ߩ���U��SH6���/qNK�6n4�iG���ʑ    h���vDN+sN�Y��r	�q.A-�,jt����H܀��N��O`�ֽb�Z@�T�-��6�T����S9��/�*���ҽ����,�i̔�P��L��`j���Ji(�0��ԙaù�XOW!~!2�r2J��!�Q������S���b��� ����_�&>���U9�ep!A�kb҉c���0i�)��)�4C�7)�����y��9x��X@f6"P�����DT�q��'�H���@V��L�\m�`�$a?:�~ַ��-`�j��Y�� T>�7��7_�o�X��Y��Z�Y�I[���-���x��}
�P��|"7x��&�*���ff�g�J��bľ��P�M�&���"KUM�jo��6 �ߙX��v`�S����O�7�~1����&d�5r\~��0�P$�a[�;���h��s�V�dY����A�Sx臢~��V/~|B�S��k�t��#b�Ib�6|!b,�s5P��x
�9x�a1��W���ț�m��U��K��r�ug �&��a��Z��Z�``3W��%�w&"��²�f�ed,yQ���8���If�{�q~s���is )z�q�in�/��/�`iO_4^Fft�؋nxӂ냄��W�c��P�x��Ds0���,�4C~���:�5"ꚨ����{�W�����-�?+�tKn�YA�h��k��	����m�Uy��I��:@�ړa��\�Y�6X��X��@R4(��}� �� �� �m�RƮP��"��ŷq�� On��l ��iVׁ�����Y�S��=b�`����vZ����si���y�D�u�U��E�8:�����"R~īc/�x����r��W���]��'q�G7:U3���x�#���r=������`����O-q�,<mJ��-m�]�/D����'�oS�qΗ��C/�Cu>*���!ѫU�>�����Ƥ"?;L3
HF���*��� ��������yu��&ْ������-�s�^-��7Ǆ��=�K�D5��rtO��k䂊��qh4���8�s�w����l㨙�3@���(� )�,�gy"EE�B��#E�T��i���D�=ͯ*��mE	�B"%Q9%q_�@��l��߇���	���ű%i1�rl��됐"ɒ"����"AG�r��S��%0Qk�����>@˷ō5΍�
�ڢ{��{56S� X���F�K���Kw�.f�T؜�RNpևq(:��V��~�}��N�T�č,d�,�~�9�м��cg�c�{� )SG���B�i��.7��M8N��G���!�;I��~��cN.=Jn�T��䖓��Nz�h:��|2���R��!��Ӟ:O�mG�fC2�r2JOĵ���Q��Q���$��7A�TTs��Q6��t�ȴFJ���Sz���I#T}_�+��N�7�� x%il0F"��DJ�ս_�W�������s�ZN@������9�>��!7��ꩡ�?C�0���e-�<Y�@� �w�V\E��n �Q���z!Bo9�Z��9��V}!�.9-N<U{-�`���<����1���z���}u�4^��l6�U�~���5`DgD�[��/#Z��95�,���dD�dD�K>��h��RV��}�����ݵ�_`����!�8����UjZ�ƍ�rkj�H����k��V�e�CU��jt'X���d5 #��ƭ@~�����������?~���k�!ݗd���Mt��U���jE/V~���)��zj^o�_�4tY]5L��g��_3����	UAD��&�������ل����U�NwD�/2t�~y3I�ٚ��?��fحn�ւ:���Y?���ߵ7F�<PƢdH�4Nݍ`s�O��!HT�w�8{�ad#Ξ��M��I[U�C�����'5��}�<����'bOH{S
��鉴�	�Ϡ�΅U��y%�A��*��<
��N��NͲfa^�N���h������
� �LıT�\L,T��������>�����{�~��Ӗ�qg#�DW��F�t�e��l���$3&��cc"��9������q-�����L��}s�_�&���{�ԥ���TcbF"cF�U7f$���3ַ=����a��C5!��	d[��w@�	����_�LUU�,!�.p����s܀q�E��n;�$����%&w`%����z�O_�Tz1r�ЁɑY���ӃN����n�1Bͪ2-|q�y{^h�>N=N���"��>�2���+�39`��!P9sR��̕��q~�&~m�GUa�T~M�kJu�zl��O���ϼ_�_�>�]��,h?w=�Y��Yڧ��O�Mg��Y��Y?��-������;YS0F�*���'��,!a^�&Qh�=tV�t�}�⢳�E �����
�%������*R����E8J�:�!�}H���^��
�ӧ8*0��-�������M��6y�Y"��	��Pg�0u�k���=f�Y�� `���	�	*��"�>@�8������G���㼤�K�5��ő�r0�Mi
v�����6>F��H{Nc\;Q�XZ�er3��>#5%s*0g��[x����8�R_����l6���/"��#��Gt����y4��7�a��\��@��GPW����gF -���`N�K}A�] ��L���&
$�^���\ ׻����[\-��e_ 0F��h3�����z��fTO����D�۱�4Nߘ�i���_���V'���&��Bᬂ��4�!�@·!ф�q�=Q~�J�
A*�U����'�I��
��ԇ�H}�Sܶ�6Q��myR�t�����$����.����4�0�p-̡@=>��؀"� m�w=u}�=b����R\߾Q�A��XF�δ���L�������`��$dҟ�Ic����ސ���ҍ���J7�}r���[�P����h� hC��4�\�&�>	n�0 �Y�O���T���6��o���<#=1�q�8&���.#d@�rz5���Ty�̀0������]��T�<i�
Oz�!O:9@�M��&�|�~	_��),����}�5(�y���2�۸w�I��88�"e$O���?�ɛ�Cl�_f�-r�rB+�ѻ�m�:�64��
N������9������� �(��K!��� Ӵm"��
�[�aʻ��{�qm6O�%��O0��"�>��U�����K3����(H %A ݟa�q�W�h�]7����I�yA�i���b"G/�h������H9�\G�rT��HgW����ĵ5ε��N1�7�Bm]�.Dm�@��7nFvOt4 ���vҦ���� 
�
Hӌ莚��d���l*'�bJgJ,��b5y+�y84���B)�������(���K¥���Y���E������	��Q/Cu�f��A9A`ѸŒu�H��66�'�<�J\DR�D���:9�����uݖ���LІ�g+�[Yl�l9f9\�m��T1��e���U��!��j�Z�I��Z��:S���w�%���y�#%�J�GJb��� �ރN4�1xv������UfC-�CP�0�±d���._��ߘ�x}�*·X�o���<k���z�8֩w����C������q��F0Yg�^��d]<�m��|��������'�0-*2�M�m��Cr�$,���}�X�v��
�[�m�حʎ��W���*��R��P8�<\,�l��B�fq��4��hN��	����ۛ���+4��L�LŰ &��g1��d]�;1�� �(�ImdNmܛL�1����	�g�C;9���Dy�9��=\��w��Y-�;lqN!I,���Ktm7�<K�wbܺ֨�-�Ҏ�	��'*�Pb[u.����%#C6�W���dК�_;�� �H;�uӜ�DP[GD�.4x?�����,����,��-���~��3��
ŝ����)�E�� d�ZA�i #��`���ǒRAN�Z}	OC�d��U0�*/�����EC�-'�e>���á_�+=>������+	U��@�>���f�ȈЦ	�A���    ��AȊ��dkF��%2���MZ�nܖ���"���+�*Y���x�Kd|�D�}���O��Z�_4b4�Ů��S|�Η�4����P������?6Kq�c��Md��O��Rw�� ����Q����>�Ii��ѕv@���"Z��k�;�\m�&��&+�i�F�q|>����9	q�A�"�䋮�Y�&���y����ކؠ � �(^оl�b3o�e+��U��U��߃����)��ªk�Y[i���O���m��I(�Y$I�v���!��+������������U�������tVV�p���.p]���TrR�Q�TT�����i�"�eS@��������,���zAZ	=�duW��;�Ƞ*M�nl��;gݜ��ԝ[�g$g-�*� ���m��Л@KfY�u��OZ�X��Y.�K�\ �c�l���f�Ӽ�hRѫVOZ���V��iszJ=;�엊��'e����+�m4y�.m��� ��o��v�0[|kk /��L4���	i�e�~���$��߬��4���&�n�{{Q�y�
�x�����'^�8%1����)5�)i�ٙ
�N�JW�۝�щ�Ӊ��o:�]�}L���qǓ��)�ُ&��@�)������OO�e��X���9�voL��d�`�ޕ�N򋽫N�w���6^���Ux�n�	���x��P�h^!&-:�g����lk'ԝw���q0����A�\�#$�f�7s0T�f�����;;�q�"� E�j��$$h���b�W-HiU����u#x�X���B�F�5(m3�o{l�A��Ov_H8�D�'�Ҽ�BO,�D�e�6��)�NJ��=����4�.fd[��8׬p�j�x�N���\.����\���ް����3M;7f�+̤�d������(�n1*�#)K���Lo��i���mE^4`�4�-f>i@�n�%ζ����� 8M_�3��
Sz��M�6K��V*�Q�]�o���'�ǘ$�vՏ���NN�,������F2�.�E�ȱ��uHQ#�=F�z(��P�MRz/n���)��%Ǧ���ٛu�N�nj�y(&\�[r����F� l�X�_]�GRF��-k
[v�®���lh@��1�Q�7�<��y��i���%�o�}\��ah��Xh���F*��<䯇`/-�nGR�=z��[B��ń���5!d=g���,8r���Lh$���� �̛=��D�g�9�$����R�&��Ĳ���<�Uq@��ɖ��a��_z��U�#��P5�dݺ���9���VP�k�r~SB�or�7'/^R�HG�'/I,���խ��DrJ�:95����s��p�c�]l��ɢ����U�U�q�O|*�
� ;�A:&S�XK���U=�'_b�v����7BX&͕������Te����Yl�8�D������<�� ��;_V�D�=�Mzۭ��ݚ�$�8����8�x�$y����iR�f�I���(�g�@z ��}I�Wp:]t��3s�kB�p���W��(I@M6]�c4V��0#R/��I-�T�����S�HH��~�ҁ�mF(�$2g�A;�c8�̙�PcD�q���\w!����X�&YEU����GQ�W�����|3sݩ�D�+?Nچ,�X*�/����2�=)T��\����J��ߵu^���/���~�#�[���^g��n���P��
�3;4WU�e�J��N�ex_e�����PS(�[PxZ���UcޚW�[U��[�ċ{��R�����X;S��� S��,7qY��D d��Qn�Q6�S�(�s���K��wt�l
�U�i�E$�%~*r~�>`\�2x�pQ�:U`��L�R��R4����dLxc�M����	�����|^^��It_$��͠�X��0����Z�3�P ��t�&$.;�N�^�rS�E���ʭz�j���A��Ajö'��<
��Q�F1Z�A�@/���Bt�F��-�AƢ��(�ckPR��0��W!�%���ԓ1�؇���i�7ԑl��z��z9����-��M�*1Y1y�:��I zvןS�@�0
�]t^4(���ߥ��
�NO���Ƙ��_�L����Gv�v!Z���	���u�@�0�$0�>t(ƀ�ڻ�]9­�5!H�cU0��wO㈄�/�+��C�� F�!F�4{��ƻg��z���8��2�r��>�C�>��NJuA��C�z����mP��A�Wǒպ^�|�u}��������!���p��h�(��Խz��j�B@�t者Ӱ�U! �{U�w���jD��Kt�_�IK*X���*����|�-[P.XZ(�~ �r=8ⴰ�tX��C��LY���w�)C�����r�Cc��H-���>��� 1I 1�� ��2�Hc[̄�ss�q�6^tS�qF�2��mNM�"���p9�Ue����q�"�2�6�_d��z�]�U]��U��4��[� �j�ɠ��X���pL��w�!�:q�J/�,v	�]����[�:5��Lw0���*��~��qd��z6Ɇ|r������g1�ܕK�l��5���`�O[�,%(�Z��ť�B9rO&M��[�Ӑ�>�x�L6a�'��'3�I$���B��}0�Y!�{�U����_�ݥ��T���2&�>᪚K�S_�����3�ͿjZ����Ұ���2���Mf��_UnV�(Ɂ�~w��(��p���&��#[��P��Q/KW'D��l͂l5�g/7� ��Q����]l&��$�{�O�&ńi����tñi�߫fל ���)<���R�(b,ѫJ��
z�o���UѻV���[�Ҡ�&�M�6�Xą�$h{��O�� �����)���'�' 
�y-" ���M�dc��}!��#��.�� 9�"����'�%B���]���h{���t�։�ͼG����k��\�{|W��&��s��  ᠜�w��23_�j�qpg���^����ܢ����0_�����2��+4�og��
�Bq'�q�����8~l}����s���I�����j˧8��L.jx�^��[���D�q�����ر��;���3F=.Tج=��w���M8r�EJ����cL>�1�4��Ǉ�*K�2�b3��07b	�+h
��9Ɖm�U��a�!�X6�B��w�G~��$��}��i��N�o���ߒ d��`��5����5���2���c$�fn�s�H��	V2eb]����&
MvM���Y��*Hb9�JR~`lU��Mr"IN܆DNL�:J�"�S��Nc�L�ow&�s����UI��[L[�r�ϕ�����\�m�~��f��qt�q�[��1�n�`6Zs=j/��Nꠥ�2�I��F{c:�D&6��˜��l������x!�w�,�����ݫ�ց:���ώ�I���d��t��t��\}H�s �p0���-�N�2�e�Z�4oU�C�B�kP����@�`���
r�b�����`�|�.f���|#s>3))���8��T��N��)`Caby��z'�W�@�o<��2(2'�4���u����%ݍͅ���La�pK�-BS���������u����	�o�Q�l���o��om�I�L8^������/N L6�uͨz>#�U���"�0Yd����8_d1CX�>��uV���R|��D�T6Z������U����j����cq��:���n�,�/	�6��2l�7�Ju�>�q�� �I ��L���z�������H��(�h\a��Z㤽�\{��p���+{K>X%ǁ�ԉ�1��g�چ_sV�R �	�(��yO�V���_w���zjՉ�j��\����h~�z�����^g���H$I$]�|"�p�r��V��+�GF��[)�q�,>2)|�-�?�Hw��	�+wW�>@&�4�����}��D.�qQm)0�ըbk؀�  ��[����dI��ɒK	��~�F�}��4}0t� ���\D�����݇����hr�Ue��WF    r�Y�`,	�H����1W�9?T" "H�*�4�t��t����J�}�@*O�#�A�e����WM^�!� S��<�	��s�^�9��_w��*[w����p���F�!����ԙh�����'s�I�����3��=ֱ�5p���\�-Ѻ� ���h,��3�3�TI"f��Dv
9�~�jO$'�y��`Cc+tث��˸6"�dz�dh�-�ZGZ�S�6���S­�MP�C�t��v���iQ�K>��he����z4@�}.w�TC���&e��m�7� N�4�Pϲ���_�`S�Ʒ�Ug�Da����xWNxQ9Q�q�a�FߠU����-VªN�Nn?�v$��0�aR�O���y ��+4Y�X���X��N$�Nm��⍳
Ɓ_�$� =Qg¯z��|I�&m��D� �����}�r��C�r��Lm���H�����?|�� ��ܝpd�i�����~�Ce�E�~�?E!����6+�yc.���6�$^�� 䅄R��ҭz`JD�4�C��4;�⃍�5n���^��`}91u�Ĥmy��l"0Y��D�<���O�V��x�F����K̍~��m�|dJ�`Jl
�w�ƭ�t���뗅����^�z�8sc4�~��07ק27�,i���B��5N�=[�q���cb��`��8ez��������4Yʴ���$"��2;1-�Ҹ�	w�`�Ƚ*͖EAUnU�K�q1�5>n���m"�Hn%Y���-*<I�	P�QUt(n�ˇI���g�a4���:uU�"��Y�{�1���ǃ��1�e��_V�/�x��nw4�6�l?=Nz���^��x�6+�l��?����t݁{=?���t�[�ljzT�N�k�$�Q�_�*�;N����_�Ծ���	���
�{�wl�oU8_�U�/6M��5T��4ǆ��҉��ڃ�'(�!s��)b�&���8���9������-�	l�N{_G���c��P)#mB�����b�~�)��e�-��~�UG�S�q�ۉ�������N������w�7�nġRp_��ئ<Ro2�\3������s_Э��e��Xυ*\��X�� ÙbU>���?�1P�93 ЦJٗ��T���_��=*r���rE�((5)���tJ�(��(�&S~B�tQϲ�#����j"Y7�#Q�#$�����Ɋ�k�H�Z�q����x��R'�<�/&���� {�GF��,\�N)R�\�@�Ed��7F�=�wE�wZ�}ة�-��\�,퇿.N5�>P6��4l�;@8��
���"*���*�\D-E�om�H���:�D�� �  ����M�@&�"G�	����O7���q/��ۃ~�Nȱ���6�R@���sYh�Q���!h빲Ԇ"?��ĕ�6H�-hs��4+T�s�����>��0��W,E�L�B�)
U5���GR��vȭ��#��v�x!���FP8@S�ʞU-���r�.���m
5��A�	�%�C�������P�x4IT�"Q���Q�:a%Q�>ǆ�"��s��'�ɁNI�\ĸ/������N= ^ �EU ����P�꬧�кe�8��8��8���ٷx@n��(�F���!E����R̮��}��.�	GA����W��U�$���OϬÀ�q�'-H�KhR��d�M:	MZ �@P�������9θ9��.�\�q2�S#���H����gCNȶ��9��@;�q���+ 8��w���'��âJ�XU�|�ֵ�g-N
��r	��7������q���پ�D�"�'���\���G=��|���v@��� �9 l U ��\m��x�C|�� ��@�	�#~�~g��zɜAP���@����-�"�Hi ����AL�FXH2Gn�.�tg饃�4�3���>�����Ej�oQ�i�NhPh��@Ѡ	�W�ߗ��U�I��-�6��{�H���2�:ёk�ՕV�z�j�1Ep}�� `�DT��c�#y��I�N'�;��ޮ#�����`G���"��"�w��"���l�m�^յ']�>8ܡi�����0"�1H����w��i�� i����2�^��H(Q?`��.5��w��B ���"�#���h�G-����u��N���Ji5�e�G�N�r�u9���ȿ�+��焤8'ܞ�˚���Aԓ���K ����0d�������� ��N���͑�,������h����P�E�o��~=g�S�:r��K��|�5BA�d䏚,ÿqޝ6	�^
���[5"?��\:�����QpЂ&��&�U�&'��D�^�3E8�!���/���TL�1��^�X?���yLe�=ն���(ڀLD�"��D|ꞨB|KLLB�5/�eD�6QC!�^���q,/~�&�I�^�n��:�L&����B��B�"I/�"���2HzIPrP�� @Ɉ��eW�Â�ƅPU�P�_��,�`��t1�����mi 3����V��ڐҰ�$�k��Wb{�����f9�&9�KTkD�C D:sD��5t�B�k���W��{��. 9p �H��97�9p5���kL�w�s���j�aj�[�b
��+�u��X_�m���KO�҈#w�T�ɼ��O�M��q�S�ǁO1B9U��H�g -zc��� ]$ m ���t‴AC��E΃3������〴 ���@��=���1�$�6�������O��_��>xM.`;I`���!`��c��s�j���)]�zh B���l_GфlTڔ޻��9��^	fO��oT�`K`rU���s�Ɉ��g�_6�6s��E�������SOŬ�� �=�kU ��S!W�@�* Nm �
�
��!	�����T�g��',��h�9��m{]j���Fi�q��(ٷ8.|P�\}A���Db�qʦ����)�9��Z@��;�[��H������4������ik�M�<�S?��9[Û}��`�lFM~�n���s�����X��bb�:8�]�c�R;b�� � �ש�cB#g��FWW��u������VG!�T�#���Ja�^b���a�H��f�f���[���N����-�l���Y.<���[�z�Qݺm����9�n��x�֮��� ����v��^ӆ��N-� 7G4i�H����n/��y�'4�+h���`��&fP
!����BP���"l�������f����U{g�"Z���6�wq�Q�%�|-|��+�]�+R��=��L���[K�mRд�}U��!�U��S<B;�} 5`(��:jKu�����۠�΢ �	�]��9@�</�35%��l��o��4f���*v�*�!�����a��MjA����	%��٩���=`_%�%v�?:c!?��	��Z.Kx)���L�٬*�M%�t&�T���`S��<J]�h�&#�] ���,6�,�AB�\�e)���pD���	�8�qF���u�����.uE$��6D�RV���GH� YL､�O>(B�,��*=�{s�$[�a)e"��C���x��4���'�@CU�@Gy��Y���5�:ќ�מ�u���s/o�h>�S��C��y�y�T]�T�!�l�|!��߉�\WN4���U5&��~"��Ku�_��9���] �:��T,�dyU�׽�(^T�b���U/2��v�r���B|g��i�Ҙ(�ZVMw5��|t^k�tg7��w�͸@m��FR�| ��L+�L�	����õ���i���v�'��'�M�^2��	�^V�������9`������^0g�˖wQ��Ir����ƽ:.��>��n�.Յ�q
Q}��:��͋���������ڰ�H�����#<Y]���}a�8��t�Xg?��&�^k�� äǢ��nI�I��p��'�Kl�i]@<Xu����BO\�`$/T]�+�p!�O����6���ԫg�z@��z�V;���?~�%Ns�|d��N�    =B���`[�����A=��B^<�a㋖�08v��B��m�,��q9���y���v��q:��l^�`Y4�V�Ū��#qns  ��n󧧈�&���-ִSmU�+���T�@=�ػ�)JL��mFg]�z���ޫd�)�@��B�sB>
���ѹ�@�-�7u� J)�?��2��9��Ō�k�;/�v�v�?���Z#���^���|؉�S�@@����� /v��G�+>�CD�x��aQ[����Z���I)��x�e�SJ	�`Vj��-���_d+�t��g�EAA ��k��BS�_�8o�`�ȠM+���$��ƍj?�	�l^�+�0&_��[�r}�lNu��]�sɳ�(� � ��H�\�+Kז'#sz@Oa���r�2PuGO����6XXE�����C
c�vp�>-��ǌ�87���b�%��5�a��6\��I�"���	!G�gTP�[Lo	<Q�M=�T�腡y��iȅ���Њ���U��A1�8�*�ּ���X�4uC�
�ڒ�-�x��yD^Ө}CGJT�!�V�f�y�hY��8�X=�dI�=h%�*H��4!�`"��K�,��q;/cH���&P"�6� ���w�ą��j����~����A[���u���#�a���}3ŋ�k�������Ò�]���<Π�,����SY������@C=�W�%^s���������=�WV;���@���Il��H�܂����ф���p�qu�q7/��k{�H�k���U��DU�K�u���=��0��6�Ϸ#	�F ;������l"��r��_ �M-�m�f�\��*Euږk�, Z�5� ./�X�}gm-��*��TS���t�T��ә��`�Z�6�� X�~���f��rm���� �,M ^`^���ԡ�^,����d0Ђ����z1�&v&Ѽ{�щ���/_E���x�=FЙKt��18�:�=j�ڣv�༂�]g	.b�P�H�Uy�ڌ��v&85Cpe!�m�0�D�^�nqG�6@N�C�߅��"jT�N���n�$W&��q�m
�\��4�Y"�I����gu�1J��	E9!}�3։���<���XY��x�ٴ?�Q����F�q}�}��v���]��כc�� vz�I��Y`'`�M`��vq�Ï�^Q��H�
Đ��Ŧ����E������S�<��Qm��l�4j3aߏ�?��Y�}ɯW2օRV�RD��
P�Gލ�W�Lu��j��x�:[�0@�	�V��Z�Խ�{'�U�Xy|�h벃�&�k	i��t��6�.%���8�Ru�U��RѴ�ZG:�	�o���t`�9����/����8آ �-:6��X��Fٔ1��x0S�m�v�`0TYP�b�Z0��L��q��V;�tݜi5�����lE�ެZ؉���� o^̮��/�S���U�^��H�/Mn���{�*hrI�κW���(�V���ɽ?ːN �a���[�r
C�����6h�B`y�"��q��� �ď 1N���R���[�&�pK� x��M���l�'d���O6�CU�`	�z�l%,x������x�ߏL3�L�w�bl�4GL5���6�F_�m�
�}y��P��6���);$��	�\{g'5���&�s��"�>�P堻��N�/��s�ۢ;$�X���O�{�H����X��:iu��UA&e�k��.�S���x�KO�Xbg�`{X��ٻ7�pŌ�B*��W��{^�x9�m޲�#���Ogb�U`�����.
F}
���k�*�U��������,=�]X�D��
Yͤ'2�X��M�?#¯}�_���Op��mFo���\��7�1���g���y1�=��G[�y�{c�)����;�5�����/ew*R٭.�z�!@��� X/ X��� X����KQ�\��7�f9�"M��%����jb� �~�,*�z"��0��m�,.����<2+~��g\�K��u�GXe~-m2#��_�)�����q��Ld����s�7d�9dj2]Ȕ��ͯʎ,��	���sz%����`(��i^Q?ޞ�z�@����M�E���(��F�6[����=s�mg� /J~�o�q��sA���x�8'�,/�$��a�� ?y���^-��Ԇ���7,X��8V޷�jlR�][ش��Y`��M�\8�l�	RF���_c鉹ghS1Ύ�>�{)g�ʋ�A���i>eP��0� MU�[�,�ܚ���t�˩�Lh�@�����H?l��W�~�:\x�'x��"t�̴�U\_Dq�A� Ĉ-��W�i����Y��0(������O���}Mh��`U�����z>ν3.�}��v2�d	㔵@Q,�N��{���U{�`,�P	-Z�JZB�A���X-d������%JE�=��-�EKtFK��z��@G��Ud�6��c:�0�5fdѨ���0V0T�Lc�!��4�j�y8���ye���8��sXhU�H�:DT�Ҵ9��B�<�~�)+=y "&���Wjk#&���f�3R異MQ���|�όr�gd�̏�P"'&,���m@䄂�Y-�� �R�| �x9/�6�ο�r��}�˱�|���kH�e�?o�#����	�q%K�
��#�������3�`nQ�oa$�s��>f1�IA��fba��0�="�ȷeη�|>��5ȿ�,��ֺ�#Ĉ�$⼔IB���^A��DQ�;l$'�n5��������~����¶�%!�RЯ�:j��Y4S�=qk^l��bpy��Y��oS��#g�?����{q����i�}�rgK�V�
����0'ld��G�NE�\s�L�^�	N�M&D�L8��ʌ�� �\���|?�#)F:\%x�'�Ɖ��L|"7tC��{�L%%ts����מ'�cse�#b:8PY^=D�D約!8'Z¥�&BG�+��CK1l<$��k��X�d7
g7�%H�7����x���o�����LM>�m.N�4�nc�M���r���;�������/R?�Dq��:Ջ�K�T'���P�:��@f�sf�|�0ߪ��O��""kPcƁ�B*��Tܟ��,���hu��B�����j\@� hR�9�zj���d��D���= ����u)�v��<]�%]g��U�gWC�h��f� �1�RGs�z��+Q$+q�?�D�|��7�����3�N^bc|�)]A��H �I ��I �+��|���~b���i���󘕈�I6+cTǌ��W�Pu����w�]��Ķtie|/�B�3B�EV�Y�g��'��9�qo�D�ƄʛT�_���ӛ/��k���p��<!�MA�����p� p{�l��1�.��Ka���p�de,<�����GҦ�n�ҍ������9%ѫ�����ד�K��nonfKG:��8M�s��a�9Mu�v��K��:�x��1�.�cy�9���_�%&onUnD.����`� �#����2!Ʉe�ݿ��@T!��GޅN��^ �9ac���~�������x��i�1y��-����p�k]�풺;��H�	�8\�,��GX*%ބ[l�Y��;Qr���٬*%��`��\c�%��)(�
�r�q���bZ�´��i�Gm{;�+h2��~��p� G��K�6���2g},~7��[���Z��fk��֨i�����aҁo��̖�L��ŌɌ]��Č�ع��Y���`���T���o�=�#�E(�F��y�E�פ�b`�����69��!!81�@��4�q��-f�������I��6��
�$q->d���s�QKQ?�5e���n�F崆���Ekt�F���A�}�P������#�wQ��N
�&�9�q8��R`4�F�ʞI`��3�˞gB�z��_'t��OF#qFC{�Cwzb4kkW�DU��V�c_y2�χV��'�����J��c��0��@�-z�ğJ���;�q_�w� �
  M�C&72�D�.�#;D�顶��RlH?�ëa�{U�ѡ-���p���?@�Q!! ���hvL1M�:i�p6�b������{ą��I�DA���NS�,�?YZ���;"d������[� u�쮱�Xu����Ȉ�O�7�H�m5�8L���!'	��'�T��]_��6��`��,ΰ�=}��㚆:~�5	a����	E����770�s�цNo��u���6A���J6��;�c��#�[��T������ez�W��,�-��*�(��XZvJ?�$V �ԍa{/����?�'�34����������' g "�]��{+gM�jP�7��H�o`]��[�NH;9�F;ҕ����=F;L�o�G��x���a�YϞ�;R�E����2,�8!tp'��
��b��Y��YM��0�����^(H�&<*�[�ka�G��<j0'����ʩPKm�ⵕ#��vzӬ�ռ�W��&�������_�.:ɛ�򢀶�����#�&��X�^b������ ����&m���Qib����!DIY����CF�c���ktR���X�)����*�mˁ=�dTa�i6�X�aW�'o����C���s�>�;N��z��}Rj˄�;�����	�GQ9bI:���u�yǄ����9��[b���4Ti�)Z>��b�Eb��A�^g��� ��^��'�?A�H^�br�n�5�a��+|� \!u���6�c*�]������� �֊k�C&�@���[++#��4PR�g#�@#t���u�'�z4��K��������9�cAݿ�(_c�6���^$`"��*�h��Ь�����(�.����F@mg'v0�J��K�S&���������ơw����ILd���BL�֗�
��f�T&�ג ��'��^�}i6����g�
��

�?�#�8�gh�C������mh|�	A&ȋ�,}i��;�'�ӧ�����M��U�VN=�&��8�c��$� 8�8�~к�>���+|�Z}�4 !�$����o��$�)�?��)D�X�|9��9�m�P^4b4��䠂�0r���H�3��X�/2I���� �Ɖ�[ܒ�@	�F퉍�n�b�,�P� ZnW��j���w��C�;m���Oui�Qyʡ��`F��������q�:%�*���y�Z8��Ada�ط�I�����$qEr��&rD�g�=��=�����������5����%~S_��A�7lK-�vneO��NRH���^�B䤂E��&�B*h�U;�6Sy�|��N?۹H%H�r�9#�Tc͓�K������ǵ�9Y�鿍FȂv�M�e[O[�Q_�B{����lϫ�X�]�X�a��OP�#�z(����X���aob�f1�yY�'��X��E��b���n7D�u_!�lÈ㍳u�E�%0�/�JU�5�<��qs�:P�T�ޡ�}^+�����l���J�"X �0� �
6"/ظ�g�-P�Տ�Zlb�c��b_tBT��>t�����x^ `h��
  �wR�OS#�7�Bo���Z��􆫮��[X>��fa��[P�1N�w�8:+q�z.`*�~0���D�;/;�_�:���:�w��ψ����Ŧ75mxa�Y@喜cA���%m]B�����Q�]_����&�<I�\�9���V���~�^Xy�X�=+�V�W���-OF�+ tC#�nu{�9 ݀OCq���oΉO�������ch\a��ce8�{�n����A.!��-��,K�rB:���_SЈt��y-�x��a[�42(�7��Q-a�s.��EluQ� �RxcZ���8y�\
�
�U��21��`n*d��ሹ!`������G^xy�s�h�q��ƗG)
�?ث�b�-��KR R��B�B\��� ��Kw�km�r�p�=�}_��$�،�"�xep�Ҳ�!}��ml�g 	jn� ��-B��b\({�(�m~:Qv�H��H�W苑���_��'���~s��T�e�7�xc,R����b!
g!,<V���$��*���ғ�ʱhm��r��E�L�	���b�d�ȃ����9�����=�G��>�!w��Z@1�Q���;�V�^E�n˺׌b�黺F���C�N��hn��@�s��5*o0)����%t�����;��]@{{��&�K���9�n1���������#��1#Cu�ۭ_<��� �`"��#���滺�3�v1k	|��v��h���E�v�#`��{;�eЀ�+��9N�m��WY�J�w�3)b{hQ�a�E�D"-Z�qP�@���B��h��I���&tAD��7��@���-��v=��$"�nn����� �o/�L�ʲ�kSia���ߖ�e���s,Y0���U"QY�����"A(xMGZ�nU$ȁ�3�H `��~� )a� �Л���	i���2�h�?����"��/F�=�q�Q�Ez0�v ��ʙ��	�K+�ﳨ�Y�N� ���7��_�e��ӄ�2!-"�aR��辶v���o��LS�"}FxZ7��x�poW��Bl{l��;�����.����.t��.���H����A�����ϟ��N         �   x�}�1�0E��\���7�W�����ظ�hA-t����=}��%n�;��3��XkQC��&Y�+���3�\\(���B����%�� N�5G�B���h)�߾�UW�k1��a���
�&v�-��0����6\�����䜗oe��RCKZ����}\s{�=�'DKH5���/��MӼ�]      
   4   x�3�4202�50�52S0��21�20�362346�'e�ifh������� ���      �   �  x�U�[�9��]?f�r���f6�H���Dy���Xi�[n3Y�}�� 0��;e�S�@����F�)��
���K�Ɋq>Ǳ��e~)��1���6��()��\s痎�nJ'�8�^�k���%�� {2:���H��T�8���T�R���!X�gpN�%��i�?�y� 8�NJ�=:e�?sY�n>ŵ~���Q�M͟�l��J>����AhR����T��ZK^�ǡ��&3� �����_2��1���4��XS� ��+���$�q8��C���U�Y^�2Z��~��!�9Ou� mb��y�C�q��[�2�ű#�g�?��Zc�������,cN�c��C�,��������"�m*$��QK}������a�(`3Rl��b���Ǵc�/�oп���QN�a<���cH�Ho�[ٖ`��?�tu �	Q||��s�ǭ�ԌBM��"��5�_���i����9��c��u�Ү�ҕ���=���.�N���pVjf!�d�Di�U��>� mVq&�3�.M7� mv5�SR*�<·_ix���έ��
�0p<���ye���sۈ;
��R���k��!��+����v���E���JsZf���_�����y
y���&8q���k.�>�z~L��v2и}��YC�"_�"��=}yܒw�����?+\�      �   �  x��[[s�~~�į�q߻g�d!"�@��JU�������X~
`[��U�_�*���6�ļ$c�� ����3�;=Z�f����0�s�;����-F��`��?�v6����6
oa��g��V�40R�~K��v6O1N�g��Þߋ�q�F4HҎ���{�n����Ũ��V�A�O�~=��%�v��1�,V�6�m\��v��L���	S�$�"aX�	�G��;�M�?�v[I���M�N���H���ݴ7� �#%�AW.^<���ryck2�`:�>�5�kRL�p��7��ѐxJ����v�i��s�6 �q+I�i}��Z�����Lp|Ӌߍ��	�NL.��~m��P�SQ�&i��aq�,��#Bi���
���T@�$B����x��x�?DB(-Bw<�����oF7b�_=Nn�hQ�O:��޾��K�~�_�^�䷟���敍KW�|Bk�3�Tŝ�J�iv��r���N��~��Y^)�./����X�!�ԣ���	�.N��څ(j$����F����B�����2�Fa��$
�����ˤ���A\��sc�݌��YF8�a�I�?��걿�����T��O�/\rn\��v��wGǷ���~�G���o��~�1{���`|_~4z���p�p����1��K������p�����G�G����[A���}�������{_~=�t�u7>k��O`BA��g�X��1���GO��~.��o��?Ĺ��'�;���߅������`���B�� ����W�%��#���Jg�FARo5���VҲ�s��մ׉{����.��B
�����&-Oj=�+��k���EAF�!f��B=A�|�jt���͸~�ǉ+@$���m�to�y��"�7��Έe?����i��h߯G�&�(h����W�ZL�FK]cb�(c��0�A~M��5�A�M)���C
qkc��v9`�S(t����D:p�Rep}��#�s� �bz lnA����gWL���"�ٿ*�A�$�Q��E�)�A.���(�'L:�*p��sy�A)|tj��� �����T+���hz�o�D��X��Hl����_c�Dt�x�� ��G��k�b� R�;@�TD��J 
��y���ᬣ���^O�}ԣ� �
.��"�3��T�$D
PJ�$R�ӚH�H~{:�SYz("�2��,�Z��y��	'Kt�9�5"М���/5�r�A'	�ijBJ��1����OY��c��e�D@��]w��K��p����4�y\f(�8�f��w㸃�J[`;O�gk�<\�2߹���u���9�X/�����8	�2�����$jA�{�^�٣�Q2H:��������u��i?�v:��Ԭ�b+O��A&V̞���IE���	�DU`4��+ʦ�\r�#�`���S�!w�4���"�k���DjjAFx �p M�~�\��-Upi-�<c�_�ķ��jPȚ�uөݙ(���!���\���׸��r��lQ���1�Y���v�Gk�ዿ�o�? f�xR����p���
�|����|81�p�C�#�~��7���yv���*敕~	.)PRr�BP�Q��F�!��q|�Fz�L�Z�כ�>�ϲ���*
^%3n�.⾬�^�}s9oZb�g��On4�|l�˘�(٪>���?z��|	s?[:��V8��j�~��s�#@�'s*3�T,�In/�$�$+���8ŧ4G�Όv��^[��R�܇���U}Z��Pn�m���V���x�
�34mi՟�Y�80�
z��Zo&y�"�b�S�Y)�1����m!�p	_3i�,�5��R
=@�̍k��5����F2��o�,���m��nffz��P��]���@L0˸��敵��sd��<�ԀZ7酧�������;��i���F��h�܇�%��5�P��PA���&$ȋԓrQn��A�6�V��>|ֻ�zzA�,h���b\�Vn8/�^%���^cC���k�	9z��P�HX�%��B
mB]��O��Q�xC�� z�"�aE��!��l�SoǶP��� +��
�="Tjq�*�-yl7u�5��"�b���J,�l�@
\/��XsIOCB�R�(T��Y�ŕ0TRP�p�&)E��1�����:5e�[ܩٓ���\�����*|���)��`M���8�j�5��Wmuc�Z,PL2]*.�>oY#Pp~��+�[Wl���_w:�A�~'�i�>2e;���3��J�� 	3i����,B�o�eK��j�j'�� 拾���BR��JeH��o�Up76p�'xq��I�����۰���*��	����35�%�)�#d�ص�� �'Kl�d��g�C���`Z��u�qw�]�x�Rn�#w����|]�5���7�@�6.�du�D&��!e�#PzPhv���g���b"��Q����lW��xS�À�J����>rClyg�@�2Z�5A��1�5g��<�ʭ����r-j'P��o$��q�K9����xHB�TJ�p2�i{�E+���X犚�b�-�g�p��T+���4|���ZdQ��r��YwZ�V�� $6�aU������/��G��V�oǭz
R�]ߦ�o*q�:CB���)H��q:;g�/���:��n�@)��r�@�B��.*9�n���B�/��D�ô4��H{���ʪ;�y���
 @�PW԰0����V���"l¨ͨ�_���t��ѪXxh�l�Ơc����Gv�w1h��G�؊��������R���[�~rc⥲O�u Gu�� >k����^�� w�
��uIQÓ**@(����/��x$A���c��D�⹸�G��������=�\KE�Ά��^/���s��I��ób��=S~x��VQ�߸�_� }%��t�`��|�HJ��f�Z�\��8�QD�	��V\��5mNR���T�.`d+��s�T�º���~�p�KU�
2��>���1��ӫ��E�a�(�����@�Yi�J&�n^�6��O�=�#(���W�^�8(�m7�)U�Lƕ���HX�['�gv`���v:ϧ-Գ{������/��W�>��3!,�TrCܺ��G �V�f1To�R�(d����_Jo&����B����ʝĹ��I��Wy��=;�ȍ�t��0|J����ō.��Y�iE�7�kGu%w5�QV���~��oE�&�C> qF�RǄ[bۘ�P.ĨtB��W�-���x"�XfV����H؃=\	��$;�~�4�~�P"�RF �Y��\�=E��}\�%�v�9;*ׇb$���>(�r ����*��K"�9�����Y��-G��_V�ʎTi^�Y2��z-�����Ih������[畛Nd� �3'Δg���@Etf<
s� s��h��?5��ʨc�3�E�3\�ө�p]Z��bx�2!��i���#륓���\�/c1�	�6��#Z���kg��_�_�ƽw�p��`~�'�ю�J,u��=�C������A5v��䠹n�q{����q���p@��f�6��>�/�x�,8��d
(Tb�I������xP{������� >��N���Ӓ`~0�s0�J/�d�Pz�ŃR�8u���Fa*����:ȕ�QQ��?����	��i��Be�~�^V�~��:[x;��S���7��      �   �   x���Mn�0��p
��?�DI��F&��"��5"J�߁��J��l!8W�`#������3d~̑��@��몱k�\U�j�Un��4;5J�˅$-W�rE��+Z���3$)h��~8�Mw����_��f����t�sr����w����� kվ����>�3-�����9ZC�su�����
oPH)�çR���T�|�R���$��ۈ���DR�O��(�~ ϩ��      �      x��\[s���}��/�%!��<�v�p�A��Su
nb&�����G����˞�~H��c[ �wY��'���/�����IҞ����la²X��E���d~�����+���?����;���%\ w�s8S��+�hS8��c$�Q4��D��� ��S�[����텗��j^ ��XN��{���a�Q;f��#{�\�Q&�n�9LP�t�Q]Vq
FTp6=^gLE.��	 ��)+>�>���;�|T"�2���-K3���Y)��,7�"�PzS^P^DB1�Ǔ���d��?K����
���#�]��Tڹw��8%1�A�)�O�vX�������\��f�?]�3�C.�1���Q���S�ҡ�x�}���%�8犻g.n1*+�O�F�� �&w�<ި5F��+<|�����������w/�5���6H�������Q�oD3�B�>�J�U�سPҜ��eՕ�U�I��𜬈S�x~{�!N'%ߓK��S���ܙV�G��>����|怯�y�_��w��G��\�|k�Z�b3�Z�L�3�5��i�2xN6��޾d$kd�fR�1"��j,�3h�n%�)�<
uL�hH2���Ҵ���)�v�H��^�'��_}�/���?�q}�J����6C��p��F��?G�Ϯ��Z��ը�/���B����=R���׹�TH|���'j��~);o#9����=��~��Ļiݔl9�7!��}��.�/6+l�iu~���W��N����zo�&T�?Yt���w�~_D�5�20;>;�6 ��c@���I��ձ���k�0>*E \p	�J�=6���&��E�c��c�櫣�}�A����}[��4������c-\-���}�ϋ%"Lm���Y�K&i���I�O�ĵ�Z�a��PE������^�bs8���#��?^4�nj�H64�rl���3S,VE��,��͖� Z:�J)���K�@�QS;��W;��~�,} ���e�s6�i�,wsχ��Qz�Y�3q��p�o��͙3����#������٩y~.�ci����t��O}�`>ԇ~��5�����؏������sq�;���|:8g,JciBw{�PdA��ɺ�� � �)��rP�:���جWwxIN�,��z�������R�r�ɚ�lM�Y�u��`�p�����+�c����?C�b�X�w�����)�f���* 7���6�a���6-��c3�4����Sf�S��B���`�UP�5�p!L'�O�ǈ��Y���9EV[��!�XMt��!��n^/*������i\�n�岩�B�����^��Z�o�C����W1`�~���3�T�����Te��4 8��[��� �4�k5��w�.��C��OrhU��Ͱ�^�|j8�jD�&4^���:ho�u���rC_*�R+��z�k��އ��toE��ۤ�.�z�_��0�|hs�ȷ*�.k���|W�֘�e��ϗ������@��v��U����c� �-���w�9�u�S���K[�}��9�?� �f8�jBK-���˘Piɵ5��ҘG�O��gk2�Xȋk٥È��h�
��ei�XO���
�DƓZ�0�o	��3���ń����Y��+�l��<��	}9?�k�W��"}�7cT�)s������dM`y�ݘ2�Jj�C�ĸ����
�PJ�7ݘe 8*�\�O�Ĩ���O�햫G+`璓P3w�Tu�+_��J���l����z�Iм.�bW�r��t*�@;`cӷ&��s��	���y�)��Ր�� �zW"��.� �ެ�S^���C��.�����4Nϋ)���V|����OC�t��A��8�69�ѯ�~�q��\s#�k�[��z�9�	VI��t)s�,Bq�/���"�{�1�	3-�x���N;�g�?�ԛg�N�^�,�^�0i�C��@��'�������
�̭N�uD�/�?c�U��M����vW;�EK�4������0J+ox0n�+) 0�u�!�Y�����=Qb���<zډΕH=��0b3�0BE��|�!!5�?Ѩѝ}�s�J���0����~�f���e+͝�4�8�4Ll���E�$�#�]p��*Q@1{ܣ�Ł:��M8%���^o2'z��⬠�k��5��%Qn��sߓ[&R�Ï���ߠ4����h�ƯS��e@�:b>&eg��]�#���%k\�@�����.����/�C�[�-����>�^L|o���$��-���_�\�'=a���mD��H?>��6�ϊE�k`��*.�<����>�le������?�9�r���HA{Ҧ�u�0~�{8$�r�^���Y�M�ױ��ј^bAtk��i:
9�)t���c[�$��f�!�z�TmZY��';��9�u
7��"�dé@i���t���K��Yo��N�DZM�>�Khx���}�7�Z���t��Ga��sӛ����^(y+qp��;��*��� �xX��׸��[9yp�-��" ��jq-ܘ�K{r�tǻj��4=�VPم��A�*먫���>hs����Ls��Yt�d40pp����@<T��X����[�nVS��.Gt]�㓆j]2�l�+�����γ*x�8^�\Zy�tܹ�����*]߇p X��uU.��*>�/����L��p�;�?@w���Y[>?��+�w��.�������V������R*���vGXC���<,)da��C+��ё��X�tK%��<�՝~��6,!��|:�Wǔ�0?Qt���vO.��:B��VB{�o�T�b�-��`�:ί�P���x]c�I���鐺�P�J���2�-[!�(�"�	@�ԐS�� >V��Ln�5�ĳc��֡)�^�j������o�3��(p�4�w�RK־�R�3g�Dg���;�߂�A+PiB���5���D^:��)n�q���Cl�g%�?$B�kG�ZS�ON,aY1u�^�24�f��Ѷٯ ��켑;�<�჈%�&	����
���l�#Y��ip��(��ǳ,1��C��C2��3��Xw�p����#hud=Q��c�Uo����;�K��=�X�'N��uGT*�#�����6y�*��=�/ .��\��@_��C$U���p�z%���U���߇QX���A�7!N�>�(���|�僺���sɄ��bJ����1��L/�2��MdV����9q������ky������k�!e��1�+#��\t�9݅�������/��i�q�Yj[�M��bP;�����&ҍސѢ���
d���o]�n�eA�>�Spt�N�R�����Z-Z�p�Yj����}�	��ߝaqrgz�Kn�� ����l�l����ꉄ����H�9��".��9䡴AY�Փ �<v,����"���>��G'�WI�G:�lJ�4��,�h��V� ����*P!���+ջ� �����"����7g���w�~�s0�`>����s��Si�-f˯mM�����?�Vڐ�K�ؚ�աa�d�1T��>�%l�՟s�ò��6$/����Ǘ�|<�>z��1�~"Χc�Hi?y ����^�(ˮ+,����⢇��qo��қ�9s�j��u0��x׊�u�4�u���B�XT�`�����D����DzgtX�C�MY��$�=*͑��g݈8�Y�L#��-3+�r�)7�V�-7�M_���
��t^�˅�����ſ�8\3&^	�<�9w2`�,�R��44l+յ-�`@a;��B�!�:����Q�:4��R9z-�OgK�r�eO�#q��}��v��zo�k�K,ϥ�F�-�X_���%\8|G�;�ϯmB_��8'����Yap1�6鵡�έs?n��<gg�+�q�� ~�xK��<p�&��ݸ�!r��撷��I.��C՝P��ɦ��@�j�6�B�=��������Ծ���WK-&'�G�b\a�b�$,KlBڝ.�3�T@������4e��B�y��������(:c�;��*li��x��� ��R#NT�k� �	  ��Οu�/ x��}G�������K�(�$���":��x��:O��\�v��'Ise���>w$א��Q!� �U�iO{-Ϥ��\�H�/�4e��hl��m�h[:�yq��&nܹ��n~(n�q��K�h�W�!<���=+��$�������,7>���5Eߦ�e��B=���a3Uf��t��z^�G��k�3G$�
i@)�Sc��P����u�y��� �9�ۤ쯻_T_�UG��J�k
0N"�n�0>��d�j�rb�]�h�9*@\`����hGI�(9y"�;&A�q8^�>bi�7ܱ֌���T.�ߠ�G��x���r���!�S}pR��A��c���-�}��/j�;rG�fקl]�X��88����R�G�� �!���u�b��1�%G[A
��o�Ņ;CΫ^����\�m����юwO��4D�ܯ���Ƥw�Q]�ZvGT�[�!U�Z�:4���>��J<��j�7+����Zc��[�rq*�ߪ�b:�P#�T�Vy��qǭ0oXDYx3���[��xϋߕn8���uCA��X)�"\c]f�3l6��U��n�c�ƛ���jY�ڎ)��k,�v��H�
y��.Q{��qC��T��`�b�5�>�؎�Go���̅��\�����=�V�_ۦ��B��a]���4#sbHf}�kD�D�Ǌ�Ď���%�p��Sh�Y�bJ�U�}��:X�zG��u��r+���7ۂ�9G�َ9��_\�ܯ;3|�.�|����2l��o:R"��
�8f����2f�{�ޫM�6,�cQ��+�q��2�zT�rƃd�|Jy`vqNz*I��nj���J���Q^vl��-�Ɵ�@�Ey��=/~���Y�ɗ�۽(ja�Y��i��@�����s�ց��RI��5}fR����J��E���K3�(�Kݝ.V��lC�,<�R��3�)$����ޠ���/K��|�w�G���v^Y�)����3�m���1�i��	y@B�#�Q�����I@���G��ӹ�qT��P�� ��E�Q�m�w����h�o�A�-{�p溯�Z�g)�^�E|=?�V�_�F�q�a������x[�n_��w���4��U�wL�v��5o?�=�8@��S�n�t�@���B4��ꆃi�:�4b�}���:��d�u�?�8���P�k�X$�W$��|ߵ��Qý����x��RW��8�ro���8H�f$�skaeN#�o���XàY��Vv�e�yʺ6�r�+{��J�X�k�P�T�f�@��� �;$�Er���\����6�C��V���Zq�!��\]1&*�p��0���j]]��Ԉ�5�������
R��V�\�Z_ǝr��|��)Ýz0)�aad(��l��t�G����-� � �z���];~�$!��x]�ƕp�ݨ��f/2pI�q]C�8ƗHT�~�����j#��b,� i�B�e�	7�c���+_R9�������]a"������$����_�tp��}�$m���_�*t]o�ǒG��1�N햝Y]{*��
�f�3�F;!��f��W���8Fݘ��j�^J<>�>8Y��,r+�R�����0+3����ID�B<�\o	v��K-���-�n�T���v���ү<����4�w��,K���o���	w�7����} �ba)Sh˾��W�������p�Q'��4�y�՜������ٷ洿6!0fiї��P��95�R�\N,mj�F�ꮆ�]jl��P/��Џi�>4���P�X�d#��hiYb�w�A��3,�N��(�~h��(�b����**���b�Ϳ��B��Ʈ�!)�U<�����K)uAdwʤx��=,q�$���I��ܨ
�=�c%���ѵB6�9���-�F^&`��"���Cq��f(�7!�[C��"����Y\��;�� i�{䌾��;3�V� �d^8Yށ�;j�H;Sr��S�^dg�Ԟ�$�x�/���"���b��7[�~�9�/��^�锬��O��S
mJ���?.�}E�wgsw��9ȁ���$ql��d��KCBGX#}������nj���H��}�xs��z"����V��v�`dH8���1V�A��k�yj�?'Y��
X9�s�G�,���$�́���Ү����H^w���/HRfs�"�]'V�TL���5�82���t���R٦�������d������ũY�y�3a�ԡ�b�2�.s��`Slȥ�Q/[�z+��l���'��}��C���]~�����T�����F��Q`�l��s�N�W�0��+�ݤC�%����u����P8QZ\U��$��l�*dn�\ӈ�)��P�4�o�>���]�?C���<1�20���	�:%��Eѡ}�n ���ȥe/��\�b�H�^�� ���BR'��	$y�c����(�+�y�b/>W�H��o���������Q`��         �   x����n�0Dg�+���&m���X�c� �0�`ID�A�����0Px�9��q�%|`�C=H�R�����;	ӥ0-+MǢ&�"�b���=�D������o A���
�9�dЫ���%E�4��z��G�$�?�G����+�4,t���5����KBk]O��Y���4��_\K�SG	�#7Ս�ݍ2ӈ׾��$������I6g����J�+�]"X            x��}M��:�ܺ�)�� ��-%md���v}�s �I�tGE���XM-���$�֥�7g���	�p��6���c���"+Ȥc�fc����7���?�$�c럿�s����O(���gb��=/^�����������������.e��d|p+��m�}���#�>��_b��~m�������?���5?6�����FY �����~1�R�;o��C旱����+��F%}���?����*9�_����o��w���8#��|�.���}������Ml3�#;2�5���r�\���ˏ�����ή �'���TN�G_L�������?��>�ϫ,����U�/�,��7��j����|:����?�� ��a >X�B�Z�,���@�8���W6>z����|��4+���D�W����y��BL+��r�]�^�s[��t���ڿ�K[��E�1��\�7��_5,I�hJ
v�O�W_/�{���r���6FOߧ���������7z�W��mK��c}]��hS�����M����f��
��c�[9�O�M�zb���uOr���;�
b#�����[H���\[J��B�Rwa�
�˴8��2�M�ܴKh�77���g�q�����O{���x���1�seu���x>+�w� nI08b�8��w��^�~?E�ݠ�/et�����/Γ�ޜ����ɦ�h�~�(�����������F�*�#}��d������^��e�#޵S���==Qg��ũǝ��n�Z;|c 4�x�w?f���Ks݆�7o�:L;���YBܼ�)�����#�?�R2v�!8��3�mn��}q6�-��ޭe��\���	�C_���˰%�����˥x�W��=��w������'#,y�k@�<�w�עgI��?O D��;Zѭ�@�n}t��4oj��{YA�n=�w%��SO<����X�WH�;9���fl}����g�Z2��܋�i)�T�Ց����θ@=!���7�/r9#+�{�_��e����G�5!�m���a*8�r�Sw���b��o�[2]�+�q#W^u�hѸoD9.���^=�X�
:7�r_1���	_��`SXA��\�o��7���艨~q;��q��ˏOu�WvѮ��A8f�es��{�3�su1��
:�&��n#��8}2ٷ��-jZ �q�w��K�^�ZLB�P����D����#Cp�1���)G~�����7MV�r��F�&�˧�P����tw;яX6�7�ˋ��?��7':ò%��~��C����s�Ͱvy�hP���|�2��O;u�WǗ�
�o�.�Xv���;b6�	|���M�o~!z���'C,�n!�
�w�����G����Ⱦ;�؝�Cn�x�\�[�W�!���TRoM���(Ow�<;�o����@h�e�Xq+h_�Dqh�XA���ځ�-x3��о�D�Ih��%�/jD��Z$�����XɐВ���E�Q[���=	⬍LFw@�~Ӻ=�͐,+��/C:	@�f\�������C�f�Y���㔺	�q�erNe�������-�&U��/��q�i&m/����G��%d�H_�!���Q��nG7��<x=��)��H�#I¸�{	������{۾����m	����>j?j����n��Fj?j?N�]�}�7%��H�'�	M~�1�t`޶lh��<B���<ؤ�O4`�&����+��x+��nH��Q�?\7��2��TCZ�.�4O���)6wm�Y�*���>I�x<�Oh�*a>�5�P��c ��w��ѣ�b΅E@�*@h��ȭ��YA�:�(�/������4�7h�L�����X�1H
S t�q����2�d��x�V�"��,y&�x��!��|m���	&���b���%�|4��O�{��#�\��h�y~��1[��ȕl��\l��Y�����Q�`�ΊB:���2�k��S�%�����3Tr��%M2���B�p�W��4ym+h��^<���L~X���3�E�	�mdc�xf���u*>��,aY�dr�r�!���Q6���2�P��6���,�q���7h�V���8���Q���ӡ�i�hε�J��Z�C�}�舘�-�M�3�'h��g"l�_/��6�j�;W2	1�X���C��t�-prؗ3Ѭ�m�'Z�n���ǌU�'�o���θ�@n&͵��WP�=�cS�H�T���O`����EUH�+el���=U�B�M"��
�f��������t�ɣ��l��+�4�|H�x>� ��\H�!��
�"�0��R�L�B��7׽R�D<�!�l�� c�#���,!�ov�
���7_Zegį ���Бo��K3\,���R�L�v*H�ٔ��j��r䅨���2.
���R�J?�ْ���^$��)G�os�D���D"���F�%};�C�כ#!޴�7h��R�zV�[k�u:d}���{a���\�����`��X�6RJ4_�=�55T��r��F��͚���(8���(5�>�ǟ���]�b�,/�6�_�$0
����V'�Q��4Ri���~�ߘk��v�i2���7���O�D�ֺyѻ�D9����I��H�fz}�I�R�m��P�R�Y���^�����QjĈ�4�^FqOݕ������e��HD?����*����ݱJ@�l���tS�����qV��k�:S=��K|kr(�ч8�\<!ݐ`��1��h"��'��!�%ﮟ�X�:�n�7'U��v���Q�й�d<�O�ML�r@�)�S�Q}�g��m�P޶��a�9zf{ء��/���]AǢ���%�q� �}�,u+��gbx�8�c�/zG���I�b���VB�g�j�?.s��0<��Oh_�£����De�^;}OǕz�)�$��������\�19YAJm�B��r��e��
j�<���'������"!�2����R%DIf;]� ���Ar�?2I������ G'm�7%�+Kh�ȉ�%Q�;!�r�Q�Bwf�`��&f�8��=�X����^\ Rj)��Ǘ����	@J���̠�kKK��ԗ"�|�,�^bǌ�b�z~����b�������@_�S��8���|fR����l�
:�}�P�����\�5�=��hUY6�{RJzk��X˼;�=)%}c$�g��S?��T@\?e�5���2��C_N����ע/eQ�<ޘ:W9{߅��C�q�'�!~f8��=�������^�.���4��.�<]p�E��g�|~Փ���}��F�\6d������[7"�q�K���c�`{�R���MK�����%�� \8"5T%e"R��-K��o�!��K~d��~�m�i�f(z��l�'#�������.����8�i�O��._���v�8CJ�;��n�����
>�iꙀ�uh�І=��gߓKN#����(��&����fť�	�a���(�A!!z�ud�������4%�>E'�Oh&I��(I�牴G��>���!�="6�d�o��M&B�y���4�D��9��B�w��&y�C��Ŝ�N��) #�C�r�$!��� +N燽�M�R2��}��r�5ʁ9$�k��)G��0G���I,���N7�L/[�c�>�TC
t-b�c���Q�6*�x�RAܫo5"..��2�I��8���8��i��N�g�s'ۘ��!E���\����� �	�?�����i/MK~��L�rdzFK;��{�l�:A��-C���du{�ѥth�.���xbx�P�
٨�����u6�qk	���s�DDz��rƪ�ڨJY?�{?HO���{�*s���d���tH)�X�&���nm�qᄐ轑D���F�إQyS�$.Z��"� ��S�|S�H�>k�)Mu(=#���P���S�Fd�PC��C6h�d��/C ����Ӆ�T�v��'y�qB��Ry�����D�6� �ȟ�N��Ϙ���6*]�"S�����Q��}�4�hQ
�n1�J�@h���`�Om�1�}����l$��    �ţ��I����&HI"s%аLMr��@��{2%j�`	��+���L��U��MK���"�{B�'�9b�QP��'��*�@�4��B�����>�����[G����}/����M��w	�M>�R��[m>:�OVM'H)��kc����P3�;�� �;��)��%�DR�M��YZ������+f���);r����Cʑ��y�}������D~��B��ʭ��R�L��i8p�H)d�)'�q�'w;K&
�э˷�n�V~$�y���	~"�#x������N��<!Ո�Lr��R/CH5"lg�~��c��R��|0Fv~�l�b�F��u첒�R�d*vt��.�g#�jDT1?
z��֧U��jD��#�:_62�;�J����3��/�����tC�5@��a2�W�C�!���
~�S+�g��tC�wR�K�n �|=!ݐh��S�Od��V��9H��+�R�?�\#�=>/H �ù(?Ӽ���YՖ�J�Zqa��*��s���oI$���~�����ԘT�a��N�_ݠ��LZ��e̙�|i��ŗĴl�+;�y��wyB�!���\7$W�nH�e�_׷\�
��vP�e�n��� �Z ��}�[1�!ݐh���n�@�O�tCB�����b4��F6�S*Lm�s+h��;�Y` �L���g��nv��Nv����dR2Z� �Le�ߎ���
=y����L�OH�F���g�wH����lL6k�$����¸��7��kfOH'�K[����"B����|�ǖ��us���;��㍟��Ѳ�!��ImF+Ay��%�ox�!nKX�U���NB�+H���کR.�δ]n^嘸>�}� N�#tm#@�=:���=�^�7�U�غ@ߣa�+N�����u��_^A���,�%w��׭�(iYM�i�uM�l�� ceȐ^���av��C���~I�u�������W�!=�n]��D�!ݳ�C���|��<!ݍE���uc]����X8$�)�x'��<!ݍ�C���-	~�'���(u������R�~%2� �d�$'�{�pHr]g�[B��v�ݽ���1wH�+��}�N&��	�%�LK�˲��2y�%EO�e����I~��H���n�6$Y}��Uk�!ݳDɮL��o����pH��x+�#sB��Y���]�;����m!�2��y=!���C����y�Q�"x@������M���K�T� ��C�W/���;�.䧴�!��C�� �J��P,���[a�d׍�M��VX8$Y{r��̬�^T�o�ړk��tk��=�!CvH���!���F��vH�+Q����|���W�!�)�:�^vH7}��������	�� 6Ύ���1�{@�e��H2Sۑ�Z���dM���X� �m���o�R�w�T�5���~�*n�Fh�kK�?� ]>V��S��������i��i�ݠ�%�[pp^�	�->��q�%2̹��ʘ@�ɝ�6�+nw��W��UKh��&�g����N���쳸�\��mE��>�,�������㓡~!O���ؑd/f	��w,��������WФ���y�h��<4���ia�V�����$G�NǩK�ұȈ�q��S��d�+h�oU`O��@���[
]C?��-+Ѳ���d���e>L��a��1��E4R�0��X����ˇ�#1��nd.�M������r���Fۗ�q��%�d��-�w�zG�,~����F�猽5B,9.4�Q�wh��)F�h�6K۽+�w�퓻�%�2���Ӹy�FSB��b��"u�k�F�9n�=1��L�!�Ѳ�m
��U.%K�8��F�6��1�&����䇝���Qaa�[��
����:�'�I]���� �	ݢWqf��Ȱ�6ڞ�)���Y���Rڞq;!f�TF��'���i!6ű�z!G���h����z�$�%�t=�%�s�]�ǒ�!Z���g��!"����Ѳ�t#ϟ��om�a��Z�)���~kq��<)x%�%�=q���֏�ӧg��W��=�	��p���*~yK���;g�.���6N�ES-bz�L�wS�	R��Q˱�XoCXAJ�#�#�j&�� �]��|�,!P��pk�p��#BIۜ#��;� ��#┺�ˎD�!ݐ@��2&cɯ쐎!���w|�S4���ژ[�����N}8�и�l���C��ꇗ.9����X���o��.^ڗYvt�6Rր	~&x?���
�(m@qϚ��O��|7dю�ɢh⥽��Oh_�5�OY��+�V��?�Ry�#o���zB{�1��0`P�ڧ�@"?7��8�b��h#]!���c���%�R��!]�3��HJ�sH)� ݐ��<a�=՝w�%�'��ɡ���\�#JIaj���6�>Z��T!4U��Mr��@�BgFn��ۭ��'��66բN�`C�da�;���i��	�[b�����r��{U��1Y�)����P�����rd��Hn�6L�b�*�,�翠<��r��%Gh�m�P2�rxv�qDRѡ��e�J�DA]S$H�6vN�ݧJf"�1���>��;��֮��QY���H�p\��_u�%��h���G�q�E�W�
��B�A$�8��wd�v��5��;�Beڨ>X����؅���=����_	q)/��i'��S_����k�u0K���i��~љt��3���xB�k/C�,�Q�<q��2��CJ���L!������R�䋖:���n���K��\��{6���1��(�Ӧ�
�emdT)��L>����"�dT�[�9x��^uHٳ�N��چ� ŭ %��{�x���c��+Hɨ��lq�|j|����tuՐQ%�i8�'���IDǘ�q�9!ՐQql<+�C��^�?6�}B��?�%�Ja���	��mHd#���W���\��H
�;��ť�qM���e�=����O��ն���
�e� �z }�����5�k��n6'v�*��{p ����+[crYA�@~��g&ih�>s�3/��T�"����V���E��%��<32�y���P�EG�����#���͛�a��?B��1�i��U�Ȑ�������HJ_}���쐎a?6'£��;H�0�w�<̰���_.
V���o�.2r�+�&^��Ӵ�/l���>Ǌ�-�E'���4y�<&|.458�������sc�7�){B(�wm��ŝP�1��d[�W��6HI�ҎEc[��
�B��D�TR�#9��"�C�J�8%18D��-����i��U��u�$��V #�R���!$i[Cy9����'�KcR�� �|:F��^�~r�~B�"�h�n��K��9���$�%I��d���$uh�$	��<�%��M+��e���$�"1�	F�&��'~)Y^�4�,Ǵ���" �B���Ws
t���
w�Es[\A��YB��`����@?�~�1S�>'��Nh��3�E�8�2f�Oh�����aSt�p|���ӷ�����%�Q�]8
1LH��&c���W���W��0m�m�ͧ��d�಩���Jߡ��S-F!�=ΈX�,С}��X6ϙ4lF��7��
��z`�5�8��� , ����n;�+�}R�\^Bym�Be�b8t<7�y�t }O�NM'���5ަt|DG$LXAJ�7E�/_?2n	)%F�qD;̕A�
���8��B��$��0��t)�*��MV��[3��4�b�֥����"D)���t���!��NH�)�6��u��O����W=3���sfc@�!�W}�Cv{��L,���R��&R�}Or�i�A�*H�t�4����8۲'�ŸHJ�3���g���t?5�g=F�xSБ�Rv�/�JΓ�4��%�O�^��{l�c��+H'� �07��H�b}�#�C�T�)U(@���<��C��ƾ�s*��~�ߎh���	m�ЄY��?K��L�q��    ��R������(����;<A:�x1�C�)2g��A�������Ũϟ�4h���X���l�XxrB��F�Gy��Z-Spth�Lu84D�D��O�	�'�@m����E�.xOh�Lj���n�~���R�A�1�$V垼V�A��/WŇ#*�h�F�7�V5>� �1�����G^B��o��.u��N=Cs�ZB�"/8�L,V�D�ҡ�R��J�{��
ݓ��O�]�Ҙ	�z!��R����1�L&�]�H�����6
L� �SO�d�G�Cel,z'gL|n�`V�N�Ű������!���6�<8Y/�z�i9�'�	l�xp��Ƕ&M_. mIpqP@����D�rB��"��C�ֹ?��(��s�L!���M͢�İ����t�p<GL�����%�����`#�|�༂t#g:Ӄ÷�H1�)�ҍ\��*%&�tS��	)u�T4`����zy�[��d�rXA}F���YuL���H�L�I�P�R�ǔ	���!2��(ǥ|y���at�7&�=3��F֚r���~5�/#/)Yk�pH���a(}��rd�[�8�cg�'�=�%�ep�������~'�s7��<N,�uG[L��>[��:�Y�����J\�������l�@�'U��&2I1� R
P��Udv���L���> ��Rx��t&ilx��-�~١��gCvH7$rK�[\�-�1R�N���RHU�IS��	)E(l2�D5��H������r��~;��D�����������)�V�۱|���B����$u�|�G����K}�5֋*�m����#�tH�s�"�$R�ol*�@;�}��l�0�}IS����N��Q�.��m�n	m{���`*I�5���O������%��nо�[�H'_7	�М�F�Mg���&�[kK��0�u%\A�zs�7�ٿ����~�T�s��CH'��4?����?��3W/tab���KXGrB�T;@�PF����m ���S�\
sPig����7��������v�F�X��|$f6'�O��5�H�Xw�����޿C�>���(F�,)� ڸf;�ɱ�ilҙ���5��	9޽hnBWC�:��t���m�ȉ���#1���FEA bb��6mt��������C�&a���(����դ�%�L2e?!%�B��#�F�gk�e�	m��i}�ź�:X�8��1zބ�W�zh3�j?���/,��i�����ldӹ�%`��z4�kNhc�T�C��oo�l�r��Z �̃�*�S�2?!%#O�Xp�7o3�wQ!���R���<)�鐲Bf��7��'=z��R2�r������r��CH7r\�`�}�{����Kc}�QFRV�P�/��<���]&�)e	��#S#�R
B(S��1i/�
F��Gp#�HFN�%ұ�C���̤7�1a���Y%��g'���'�j'�1|�غ��e&�S0K�{l��_i���t��*�����MaBkk�W����Ti��%("f.�V�R�C?9i����,�!tH92��?[|�iҞHi�Ae!v�OLb�,3gu�t�P�@�7Z&�C�!Qavt�}��L�R��B<�+��]��O Yr�����jv)�yT�Y���q�(�D$b�_��9�E��R���HExK�b��ڧ����4p1G���Qb��w���k���+ ڧ( oD(��B���6��}�<;>n�)���}=��}�J �U8��������
fG���YB�x�E��t��c���3X���<�[gM��V7r���c6el�#�|])x&�z-����>o
��2��^ �X���rCO�?�х���	�c��K9��|b�ί e��������������	r�k�U�X�С}˘�˘�;��A��BOwh=M�����0}��о����_�:�ˏ�/o	r�q��{m�z��^�Π��!�KH92}C�A?�^>���n\N19���K�@K���ǧ�]��1� q�Z�r�9����< ]E�m�[��P\A;���Y<?ۡ�8�vj�h��Պ�v��&IYA�s9��6���I,bv�(�)�4�y9���%����Dk5���j�V����S����L.���rdNo[�����_AJ�����S�(��%]gϼ�n�Ĳ�CJ��w�>*����16���Y=L��ىؔ��8Ĝ�L�Uu�TG��u�¾�u�4	�[�a��))���S)��> �Ȕ}��B����el\�f�{nhd�X=~HbW�Ff�����o��u�^���+���
��Y^��1z�)�\�Y0.Kc�ld�������a;��Z��� u��'�3xVk�	
\���
������Q�3��t@{B�B�/�ڷ��s�CJBai@H�sB�m2O�����y��������t*XB�{%����;8�F:G�1e�^�NJp�u�D�P��$�\`�Y*�&�=���B�
}�ͭ/>�ǭظ��#S�k�?�5�T�g[��u�Xs��>Np3�OV��x�I��iL�h�9���(H�}|<b�3�Cuu�JJ=Oh����g-�S
֓ʿ��V�Eh7���e�;��@HIG�]W(wu�[_Q��t�^ �0��p�db�С}a��׺1�ZLf��xB�眙��Kpc�c �} �ܤ�J��d����`�9md�%�����m��na�
٧"@�NQ�L�$nM.!�R�^irP��\��e�'��>����~�.S��?�}_�D��YF�fd�c�>�u�o��Nx�Va{�� �����HP�=�Ѽ@Jj��S���W�$t�D�N�d�U��+�̏���hb�� z�^�3?�	��"Xb����
�}��2z#�<�=�&���t"eT�[��f�5td�.�w`Ľϛ��^�C���_Ѻ.0ׅX�RJ(�e�!	����X�~B_��>�6V^.90M�)�y��n1���YAJj�W�;���{�>�T���Y�}B~HH)]�*�nM��x)E!�l�F�W[ϊk�N�$�� �]�V;��3���kGm�m��ȭgˤ ����;'S�G�!O�t���M��C�s%�g��/dGѡ�;
^\�1��[A��O��	1�O �a��'�d�j�b��2���>�=��}mJ.���c�	kh����;BlB�4�l ��ܓ,�Ѓ�9��`��F�=ء�{
1�PB�G�`N��a��>�����މ#ዘD�����MH�k1Z����E1�.���?*!�b��_��代E�����O��m���u�bc�؜k�h�6*�h:'�����؇@����rH�5���p�K>�NM���2޿c"�E�3��`h���kb"�Iƕ%4�k��?�琶8\kQ�Y)�
�R�?豳���i�ڐ)��ȵ0�1�mNH�]Bn��Iܥ���>�	��dbRK�D+ӡ}RĈY�z�v*����;�H!X]���KvOH)�`dXS�KDT�~!ң��!Y�>IIb�+�	�����PS]����8�}
�bEs�$oc��b��y~�/�,0�T!F'���$v)XK&!\��'<A=1
^�[�Gt'ڧ;A�� |7�Ȏ|fOh���nX����l�:�}q#AW��6Y	_�] J��֊`qI2bI��ک;��V�_D�����|Nh��$�	�xԃ^&��Q�"P.��w��o��%tH);ᥗ�y�-I���R�"P�����.���+H�<�ڍ�:vL�K}�n@�'���`�9�X7.b��6�D�CF��q�1���֠����tK[��RG�6��Ϭ�wO�h���]���H���S�cJ�	}-8ZNV�J�>��D�yP��0�|f%��>� ���#�n!��Ci�pB��ma� �uR�)D�!������>~�|4�.!������n��a��\M!���H\��Li�뇤"���_FL�<��`�C5e3������wV���|J�s��d��}S���	�. )�{�ꯊw�����q�h���$k(�~"ߛ�T�F�l    �Ĥ8� ڨ7�K�}�c���6Fϵe�n�t>����o&�k�7]�٧f5�����<��\��"��q�R
/h�A=YQ��$�{B;�t_.ڛ8$bߏک���?��C��x�W��{3�S]�r*D�ѡ���	���I>���@;u#�S�p�"5�)<!�x���qh�cz�6�R�NVй�������b�1洂�E��j�6��[I�]A�������m���w~MB�\G�N�F+���e���e�&��i�1�5\����T
��
}�]�s^������tC����bk�D�!ճL���E|����6���	=˄�x�d�@�_��e(}��I��À�R�DS)���h���	)Gf��3//.	MuH�˒8!LxԁL�:Oh�Di-�]P�ցD�z��ID �]�4�+)�YV��q�s�;ll��b=Kc�퓌��*�ޘ��'����{���7��
x�:''�^(�ܟ�>)2�"�����%�/ldm��lyq��d�=!�@���e.�P*M�'�1��A!��H���J�n6x�M��@���P�f^%�F	+�`�m��E�N"��;�}�9�sqj�n����.�F-FYA�x�N�t�,�+�9�]}%.X��T.�5Ȇ�r�}
�ˆ���m�J�K�毤��yJ���W�RAt��M+؝�~�}ƞ6'��MQ�#g�v�e���'�7����U�K��)2��n�RN���i�	)�Z�5{�\?֠�R�CJ�"����C*qR�E[�
R
�h�jj�=�������(��G��z��e-�s@;�VT)y�Ǵz�:���ٔf�;4�Ϧ���e<W���Tb\ �qy�o�ս�J������_]�� ��T�������n�c/�Q�W3�^�	����^���C����~bfD�����,�|���
R:�����{ydCH)F��T̿'�~�ϡ)E���T,w\���!�C4�m�涏4w{�2��/�gw�'�9�ߜ*���1\L)G�d��L���*�=q,�x=3&�����c$�Mc��YD�G۬'�SHvy�rִ�����)^�Bg���}]�"��b�����?�����w��;m�����+5m�:57��"6�?����u^�	�g_�v�. h4����}x+����W��M�G�3��ڝ�@i��+�{�R��~,�o�w�n7A�5��a��ܶ�&��;�Qָ�u�;�}Ʋ��������a���~BJQ&M4�`���G#���'���ka��������"g�km&�k�`I�	��vGO��9[�d���*�e'�S˛�e��t��� �S�i������ƈV�C;��yO�S���Oh��d^S����OH���+���?�N��/5*용 �uH���7{�\���EM�tC+GD}��7s�;���z20E}b,�n��J.�гLDGr$��tCBn�Ξ"����'s
+�s�ϭ��''�?�x�\Oeέ ՘<��[;�<Q�_����}`އ�m��3����'�O��YU�v9�'|B�'���k��G2f��{�D���֘�=f�2� 6���t
,��=�R}�1��R�EWX?��o����>��M5�-<k�о��<0�Ik���IR�\wbI�؛}th����.Rp�����
�I������q�!��}����B�$ƘH�>R�z��Q�C�l�"��R�B���m�|��-!�ȴ��Gf���X������/����c�g��Fq�]f�0���#���9���zs	hb�+>NH��᪞��&"9$<�	)G��9o��d�oR�z�o��mߊ���CJ}�|y?t���R_C5TE.Ӗ�<�~�I��)���?f�^9��cPc HY:��>�=&����OuH)�رD��+lo�!���{[9|��|IXitBJQ9
Q��`G��'��P�D|t;U,�#ӾtH)�a�K��|�HPRJk�a_z�){+w�d��t#�lj}�I��C�������i	�T��?�cL�,�
�i7E�b9Ll���
z��{W��`)R���p�'�1���kGL��X h�"�1����Ӟ�i�Sļ�����O�z�6�Q��ڄY']Rr+����jβ����=�I������|4���cӹ'�='T�D��;�QYY��֡�	��\�d����a��wf���*���F	}c&��<.3u�)%L�<�	��狷��@;u(���b��^3"���N[��
��/�9|�Ohg�,	_g �����g������_�{����uh�
�+���1���ţ_b]��CZB;ç�'Xl|��V����R�r mT�Qg� D&�<+�=o��
2����>c�I�+h�����Sۜ0G���IHwIq�:2�X�>���=_���3��`�^�t�<�=�C�|���9*���Y�SBvH�+�ю�xH�5�yB:�!��Q�.�l�x�C*-V�9����fr3#��s�4-/�]�!��O�fPظ_���B\A�sJ<~�އhW�N�ǼY�}.��1D��!�&H&��l�&�s%�%���!�э�;��9D� �&�7[�^�#_K�}�	�S�����5y,<#��Nh_��li��
*��qU�����D�Ŏ6Xk�оȉ��G'��W'��\�o�6�I�]�fg'�Shx�ǘ|�Khg�TH�y�r#Diwu���<"D�!F���C�i`�RE\�u�'�QG�}2vț��Sa�v�)�;v���`�ƀ=�NH�P���/?j1!��j��!����'AuH�P���g8�^�x�Cʑ�Б��q�xOuH���Ϲ��X�vBJmډ��\l�������
5��K�q9'�Hu@J���9��Kk6OjR*��o��}~����	�8�YB��澂O#7E)S�y.�p.۸�t#Ӧ�u	4��l���y�2 �M��[@���R)� u5%VZ�S,D�!��;&f�$P%`Py�q�Nj?{BH92��Ժ���D�������<��I�g��+h���B�?k��(�6�K��;��Yu�\YBۤQ��x��p|u� ��mTuz&Z:�)c�m��o}�]�6�Eo�3���)+�vi������Ziq����i�q�(���])��"m�����r�Acp�ֲ�ס�n��j�w�&c,D��!�l꾱[Ho^M�����R}?$��'�/�19Q�v����[\)�Q��SID�ҡ������ i�"y������sY'�%9%,�8�����fK�!~k'�1z�r8oX7u�2צڨ���B�5!���mOH���żqX�&a�P����]@�{2����=}�q|��F�a4�{B7\`�5.�%��K���/PqCZx�0&� �3Cn_�_+YCL�D7 l'�z�����t�=a;Ql�&�f���	錷@;Qk,���ƪp 錷`�0��C��B�9!��E�s�tX �D(�d�-�X��HO�,��Ȏ-�6��s2�O�-e���k�<�@��D'�o���{\�"��Nj�ƴ~\��F��'�O6�6/pxMa`�����/`N;�G�ۊ��4�CJ���UO�藐�+$e&i�[���)Y:�XZҫ�[7�>!���]�9
-��ƛ���	)=�(��X�����X>uH���~G���u��r�۔%�;g떐�~�I0����������Fyɂ�#M���ؐ��C:6H莢B3ֽgN+HI3"e�U�uW~�q� H)
���l[$���9�]���0��ZG���y���R
B�	�kL?�{��q�ni�j�fo�A��s�RB���&|�rԈ/ �,�*����E2�-:�(���r.�flG �ɀ��]2��+��k�G�{�o�_�і���p�vR윤�E&}4���^�� �8t�2�{9��͛�Ǒ;�N��U'�ͪ&bU�	�/%��r@���Bw�a�rұ>\Z(}�F�+�u��8U� �h��yf�">�����bi���E0�֑��	�    �0jFB;�V���v��0�`'��p��`ߕ�I����B-H���y��$����y\�Si@iO�nr)ĝ�C;��|��u�3Nc��F��/�Sڱn��gNh#W��Cꤙ�/M����\=�\���n�	c|B�n�����	r���������d�1%�F��פJ�aM�:�s� ���Rn�SKx��s荁m>\Nci�tCBoұ�٭�&Y�yc���u}���qtH'�M�ܕ���%����1 W/��uE<�t|.J6��@}f�el� gN[���QUT�JbY��)��hV��D4_a��!�}�V+ib�.rܧo�!o�擽�K���++h�l0��qxV\d�zC��ma�nd�G�:�b�
Rr׋�Wl&���π��#���]��8@J�u~��Ky[��=!%GF�!<�R�V��dR�d�
�ޥ�0qwBJ���sC����!�@F'��CɰV���<o)k�a�~�rĪ�ژ�oep��42��`���#4q^B9/���{Sg�	ٮ �ȴ��U�{��J6/��^�n�FkڱO�RS�D��iv�_  e7���8)��L�=��?��xa.�n�m~B;g�r�c�'�DZ�th'�J�l�q"K��G=����<z�ˬ�Iv(��F��GL;��!SOhc�5k���^�e��H��
qVKm�`���C��Y�I3}V*�qZ9R|���dƑ�� �J5��_?E����H�r�s��YנR�X�W)I��'tN2��5�[wȏ����e.Xu?Gį !�����0Y������s\�r6�����h���1�pp'���8we�_]���	md�g�0w�����ȼ�����"�h3)�����y�\�!�����)yC^i�9H����O�)D��dcɗ�B�C��{_����m��L��u6����	�X5�79�
k%1"�C��bXtK+k�'���U�¢[�+�nX2��퐎;������w���@R�'�L�Ӭ��뼳�>	�m�וLИ�6r�t�3y��`X��i��T�-��������vH��	��	]�� %�H{��@�J��.� e�1��Ƒ���'���U�C�}��x�Nұ��r���Yb(�0��U�c�v*ɻh�&�]B:��[E���ۗ�gd�����������6>��#�"G���y]S�@�S�.�BL�;�\��	��+���Bn��ѣ:V���7���$�TEp�ڴN����%s��{�!�W�^g�!��t
��?���&�.�#�Y�	�iNm�\S���n"�4n���h�ʞ��\���=��7�-Y,�33m�ԃ������d�|4���!e%����J�L[=�����Y^Ʀqw4��IL���N
nQ	H��Q���,Ђ��u�u�z�a5h#��H�b�:#V��X��~�*9���r�$�m��rb�C.m,Äw�]�	7��F!�΁(Y���rd��m��m����H%Q��$�} %�Rrp����r�CUI=�8�e�Y,GY��P���;Eh��Åi~.uz��R>��۸����n��dHN�CsҔG���۔�K�������C�����@3�?�>��}����4>��ΤQ��t���R����1���7��g��EO�}�c��l
~,'�1z��c`�9gC&�	틞&h]
����&-�}��QI8�+��2>��M �^�ɜc�Bo��PC^��q.��ؽ�� ]��ِ33�xR2�!]]�C&2��D�t���4�%j�Hybo��'�!%�C�%\�i��J���;!��b��ao=�tV�
��w�NS����1-!e���h��G������rY�d��WXB:.V�z�05�}B:.��N��@X��#�T\�+��a"�>�OQ<�Nh�U0!$���)�vwHI���B&fҰ�#�6�ü�0?vB�/CGN3`~�7���M�;�ޡ>7{��.��� ��ɞˑr~:!������|A�!�/�̏0��+w���.��}XAgZ�ߓ9�~%o~_}))��ck���j�~ ۂF;�rs���C1��}a�Eq�^�z"t8��vFw�Ė�V�9�Gh
��f�P��6�y��	��Hb* }^�;kyt[Z@ʪB����0���l%JRV�����V3�s�y�2?!uF��t=M5}�t�N�b=p�4�n����E��g&6��K(Ohg�!-G��a9;������9��da�z�F��7��`
���M#9h#�	��ڜq���-�y���ಃ䄋�3aP���VJN��v�kj�5C��,7	c�F }��&�꼑�1-!%A|�׎1�~p����H�o���r(�s�kO�{T)7-�X��1xqBJ���Σ#F2��Ch#ٸh����dL�|�C��d�(�+�� m�J9]���E_^'��*]����1^��==Zd�"f�:����T�`�9�R�'Tc�6��3R,��%�hH��H5R�@qHÐ^���D�����վ	1Y<s>���y�<�@;�| :�uG%�^]6���	�^ґtʐ?�hވ�s�P����xeL�Π���������ä�dr����퐎��t�b��o2Q�Y)�쐖�%�9��˽�qAHI�R�-��u�r�4� ]�"�?���L��OHG��	m��%�z`����tc"k�@�vb�k*>	���C���`�Ƌ&k�R�4���Cv����쐲���l3�|�R��RR��>�[���W&
;
Y;~XFR��7ܭ�}|�ܧi��\t�DHa��!M=k�f���ffSp��	)���ȸ,2x�]GH92��z#���|"��)W2v����|�Tܠ}9X�!9%G��
�6�K�`l>$�I~@�Hra;|Kc]3��G��Yq�	w)<�OhI��Rɒ�js��+HI5�V��"�.jտ\�� B�)YW�!1#����ݗ��4�3��տ�4T�h#�JK�M�t����8a��W4͛�֔-%c��ϸW�CeM(2'�M#8���������A��ga�,�@����b�t| j�E��'�2���
���ڂ����-x&�йF<2����G�\^^��ѭ@ʙ�y��~s�|�r& ����9��G�u�+���@���)�X��v%�W��7;C�%��Q6�g�|G6r9��1��|	�l8��eo�`�1�o��'����|�)0��]J��6rQ�Q(�Զ���E����X�P%�5��]�]����uHǈ�.t��_��%�!E}G&��%���uHIQМy���xS������3t\�y��f�OHKQ,������Y5�[-��(5bH��K��=!]��mV
NbKv.���)���G��#w�ɳ#��9���!�1a���%�q
�.߇�K�Nh_�X��-+�
)��$,�7���#��x/x�A�/Z��r�z��_��)l��s�׊OڵGNm�оD2����lL\B��`R죲�g�S�y	�K$��6VR%1��sB��Fl�c�����}�d� Ļ����}رq1qD��0�!;�+0Gb�0�x��t4�[@J�����|vů ��T�su�����N��!�2O72��L�^d)�	�������@���
R�|�2U��!�_@;�	��Ʃ���Bȉmt�dԊ��ڳw�(?�.������M�~��Y�E������@H���k7��'��ML8�{Bʬ/����1� �f=�����Hm3����X�Y�:�#(��E:���I6'R��OH9]�D͘$h�ԙ�R#z�!�39!�o^����&B�����i�\p�F�I:���'�1IN_��x��h"I�wh#��,�WJ�)/�6�<�{�u��������cWw�g�\��2�NG.C���,�<��ytn�o�d���@ݥx��s+h,Ir�����8�{��$T+|@�ҕ�a������d�;�/rC"���&��9�mpf`�;�S�־B�o��B��+B�Ul����:�f�r8�@��,U��<��t�n	)�Ӵ����0#�8uhc�$<� �  ��1��J���q�2��l��ض����uulғ�a��s_��1���1J&ZR]�!ev��P��TSg�q����pk4r�ث����`.�;ۑ�ӏn��1
��-��79��/h��X�]_0{sB����X�uxV�pB��F\٭���u�H�;��)�n[�Z&�q�퐎�c
����yc�X9��̜C}
�QF��6�2ΎX����$�;�1�L��ѓ4r�3�|�2��ս�Ȗ](L|�!e���c �O%�!en���D�d��M��] R�y#��o�d�tT�.��R)�x)��\i
�A�n!�'�\�m$
�)����D���GG��R����<�u�$��~ ��|YȘ�q�bN�)��9�:�������#s+��Ӑ�6��1�Mو\pv8g��Chcn{!_'�a��;�������R�A<��CKh�C���*��i1�6FO�}q(��~OhJ��Ƭ<ob�Q��z/�0�����R[�"�9�^"��7D���-7c��!�YJ���)s��.�j#1���p>� %@U���l��[!t@����=I�G^q1��}q�v�)��u1f�w�2�M_i���!�䵘,�� �e	�{������0�)��,���uvL��G1���a^�R.��1�Ÿ��5�6&i)��&��HU~�lt�%!N����T��ik�����/�,�c��sR�<= ]�gQ���,��4턔��l�bp�Ql�$1yB�R�(�kHοމ�M����r����c+�[A�R��`���BJŰڃ��T�&	�X����e�g����i~���V�s/#a*�|B���o~�[YY&����1�뢸����o��w����}Brc|1z;8�hc��.���-��%�Թ�Dr��Iu�[J"��2�N3[ސ�r*Y���<Ux���=��q�����k�`r���@J��k|#΃[� } ���3$�lR���r䅢_�ys�R�~if"�./-�!��(R�K��̯1Tp��AI_>�dn����ΰt��/_�`����<.��ʷ�����e�ا��~/��7����c,� �/�e<���e�nߋ����kf�Et��~�6*�j}� �d�h���y{�C��ѡ�Yuޠ��Z���MKh#���5@��3�P��6���|�L�"V�ׄ�-�}�&��oi��i�2D?1Ǧm)��ٌ�nZ�oNl
�{]���o�;����>N7�N��0BS:�7�T���[7��l��;�@�\5KRr+�U��oIu��
R��y?i?���I16"AR���ȔmO,�>�w��u�����d	)G�8x���f��rdjMn������;�a��i������1�E�a RRI��(������N!��NF]z홿�9\�!m�6{ǜv8m���I R2Zl=+gZ�b[ӑ}yzԿ���H��C��F��;�H�gMv�������Pc+$OB��F�EO����<�G���<I|RnБ}A#g.��Ah-7u@�(��8<Eb���pB��)�b�Ċ'�]��̅^H�5b)!>z'�/lh|뉶��0�`sB:�A���Qr�52�X�tHIpz #g��i %q�3S��*Ħ�Cʑi
�eL1���X1��6��C�rb@C����y@�ˍ�?�>U�*ͬ.��?2q�	��wB�5����{S��5"�,�C7о��TP��k���HѺL���ׂ�]�%AN��} ��*����3�ӮdYBߣ�9�����ޑR�F&�I%'B]��ҞjQ<��W�]F�7���9��0���1�{B:�oEx��Ka�r�ttj�yFtj�|�A����#Sr�^���s,֮ %��	UFP��[M+H9�BƗo���q��yE"c�2�z�!np�H��Y�I�X΅��ud#	K���o>��2�C�_�tA����
��l,͢ߑ����I�	�C	d��#&BC=FL���>"t�ڛ��,�~5H�}��m�aܖ�{���l$`߾mn��f,�Q�n�x�t���`x�D,���'�QI��2����-��U*��
���Q�.&,2�Yrbb��(�Xt7�-LDlb����?u2��7�ۘ�1�BJ�W���O�N���Q�3��~M߲'�%\4�������J�9?�ٜ~�;�q�S�Gr�K�Q��rս@H)����2���]kⰂ��ې���g�M�XWо	K3�a�4F����R2TM�l!s*;R= �ɶ�!Db��F
�(�Rd�� �e�e�Zh�̆.Y�i>ji��B8'�SfC?h�I��*ڗE�K�F��0��0}�l�c
\?ж�5��dn&ќI��q�Y�pp*Z8Յě����$*M��p��X2a�:��ܢ�?�$���0r뀾GnQD�VaM��Gn�<���'R�+�o2H4�*�QX�D݀�&/�yR}�� &�
�� }���ҽK�R�"��D��~����R�jt�Ąm�L4 eU&��	_޺�אrd��Č>	�j��<̈�F��:�*`�,R
&c�#�j�#�GS��N��̥h0�uB�ZP�%H�9�ꐒ�\T��Z��+P= e*�]� �4�6{4>���Sj���L��?��F��ᑭit�
��m�P.g\��|}C��F�G~�
6B���-����6Rqt����Ä2��<��՜ܟ�#G���;��D"�}T뻣�w���W���S���}���c zd7Z:���ޮ�>X�j�7���}96'��lW�nH`e#!2�)c}�6�/,����M���h=�8H�q�ϭ�L<�%0���6R�����^���D�+hW���9���ǫ�+�ư�E�{P`-�9n�w�{ ���s9�{�	���ߥ�ћ�����9�5tϚ۩��b(�%� ;���F���1N��qyо,[�?۩O��P�6�@���b��]|�1��6��
c����o�3��cͺ��Gv��Hk���f�x�Ac�g��0�,�s�M�r�s���>$����se�ݨ��0B�xX޺4�K*v�Y��8����B�f0. �>��Ҳ�D<s�wů��M�P ��,KH� �#l�͆Ȓ:�T Q�6�Y*���S�7���i��q8�u@i�[��kH��j�� C�7�6j�f+��$ �&Ÿ�vj�䬠�׾�]�<ڷ|�3�yߘ{�M�C~W����l��O߬ H93�Ҋ��aL�z��'4M�"v��hw���B������]G��RI��^p��5��r�i	}��朩'<qk��J�HY��(�'ms�*2����#/|�1gj\��,7H��.����z.4KH9����u�p���AJ����G�G't )G��|J� �±8R~�!%cKף�1;�c��0�������
�a��NH9�+&�.�L��䊹k1�hm�p��U7H��&�kQ��A[��:!%W̋63��Z�r��8�vhc�)b�D_�$biܡ�l+/:���4�bI=j�6������db�ܡ���.����l�������
R��9#���x�پ韯�����(f�O      �   �   x�Mν�0F��yD���`aa��,��`�$i��'j@0�#��p��
(���А*;�ihRS,��sD'�*{WhG�|��ȣBq��U���Uj�'�L���C��۱�|�'��S�QW��V���[�$��\&Ƙ7G�=�      �      x��}͎�:��:�w?��(�C��f=������R��%��-�ʪ
��}�E�_�T��	��D���K��D��������������_� R��~�������~�ʆՇ����(��p/�T���o�Nb�"z��,p"�%�O7PJ_��쿶A��dӥ/����iR6'���_�/�
E�sb|AI���t��Ks�m���#������UmF�=����_`"_ɾ �rN�%���FI�	��*l��	9,~%���V��M�J���Y�b�!(�����-��Fp~��R�R�/,������͈XV78vu�
����BB,p�-ǀ���"�e�X�q����ț����_�����?�����-�ע�����+K��)�}�2^0�HY�������1<@���E��w�lk�9�o��j%�I0<����}ؿ6N.)���d�bH��~�����)�͊?�U`C��;4>��9ߑFi�U�?�
��nE:|	}%ziJ"��RF���C���ˬ��1׋���A�5��U���I��9Eɛv�09pj�NHN�څ�I����C���~/����e�x��l�Q�X^, �rr�tK?�x\��_�
vn�?�S����A��)Q5m:)�/��Zp���ǔn�s2��-s�C
�~���~�s9�Ҝd�e��~�\��uN��P��ɜ־����P�(�ϫ��m0�;��&/���� l9"�F�5u�Y�f�4ĥ�����&��%��	�"�%�5���[�6�NY`|SˌQ$Lf�OX�*O'�5�H����mZ����:X4����X�i�S���M������+�&V�����jP#�p�S~��7�8R~��F*w���<}�1̣�k��(w��?��8��n뚡�T�H1c�lL�h�m��e�p���p��<V������zʁ�fLڨ�	v��x=��L���E���HI�{�Q~t\U�`ɽ�d�8�;R�5.,�8�Σ�x�sbl�9��h�d�$]G3�UK���$�,M��`�м�b��H��[Ͻ�š�tɎ	%�%�2��lB�`��n��"rG:?��	�	O��|Ob����=�-i�L�Fc�`��y�oH�a}�M�<�ƪTV���{F�M�<\��4������-��e��dL�9��ިx�-��h��z٢���}>Fb.�<oV^�'�u^�@�WQ�����ϔU.[4���|:����j���Tf.H�V�����h�u��zYQO:Ђ1�Ӗ���\��dr�ޒz[����<f��s,w���˸e��&&���@�#�@�B�-_�]���М.��I�-�B6��<E{��]w�(���m����Ʌ�`�)���w�uP��oc��[�[$��4-(���ff����^�aq�⨎�>/)oe����+bBf$l�LU(&�l�L@�<�	�o����$����,�����(��7���Ln�K���TA�G�g�mT��\��usN�iI��<�	N��\��x
@o����+��Q�em�-�WN�C���޸_�
Z��3��`�V�;�)�KTC8%mE�8l� �93`���E3�Jtk�Mg�v��?B�ȭ�WR�Atz�Q�t�7h�S�W��`�2��#�lڱ���<F�����g֩�S��W�d��2�YJ!�p�
��}\d2f��893e~�#/�@�(M��t���qr+��c�ˉ+<-Uc�������Δ��R��mq�^�'�Miơ&�Sy��~�j��T7SS\�|S.�\��];��v�J��|���d�}e�WϾD�(��z�Ȥ�w7pE5���)|��?3�K	J�ϛ'8�6/��`��3�diȬ-E�M�Q(���߳ڠ} ��}rv9t&Ed"�6Q�)�X3�:�G70ۙ�e6�\��I�ܻ5K���S:Q.�	=�`�z5��<�m\W<�p�I_Αj
#q��~����Z��m��ԬY�rG�\H2��r����
�}jb$ߑ"�IsI� �IhU--�-��t Յ�9~��$��bǢ�$#���3�^ɥb�MG6�4�<VgU��t!ág1&Ξq�����r�RI&By./[���[RCL��A�j&T�͊W�&I����/*��1���2��N�S�0R��Ƅ�S�B�O�4��v�S��R۠#݆�� �3�H�H��$���Ù<�T�oI�D�5�7��'���{K��O�2�������!�ޒb_Ϥ�Q�{8w��E�D��>"��d������+L�*�?�@�Ó�H&�
�}���Tl?)�)�&눦ḹ�b�;RȪ�M2(�ǫ.<�	�4/j ��$���ތ�� 犗��S-��l�*O�yͨ��Ty��Rh���$u�pd淝��L�X���2�Wv��5ݒb\Av|�2�����8��\a��u<)/E��f')�~��S�'������W�����^a٤v�^h���Q��Z�H��ּ�.ĺ�W�)f�������?_�f���^u��|���r,�G��{i
�>J�����H��G��x"��� LP@��JS兾3�=������c�e����]tl�ܔ�����զRo�
��yJ��H->ࡇ�p��Y͚pE�Jh��v�M������lN'������q�kS�'�-�IKs�<�S���V��Y�jN�}�[R�	|.O[N�C�P���e�f0.���͒|�ص�Y]��8���=�s��!��;���\��Z��Ü�J�������K#8�p�4�j�c��j!P�Q�i;5�� 9�X�_I
ߑ����7gM<9�V�+��z�\����݌Q��.CFp��K�b-d�NZ����B�2�\��Z
2�����������J� ��Ľ��-BFp���Ku�bd���K��Zd�NiyS��T��SZ��T��SZ.�z��;��Ma�Rd�Ni��%.@Fp씖�ȯ�?FB�~��R��X���SZ�T%.�?Fp씖7�-U?Fp̹.���#8&�E,�$F���Y�^]S��4�V��ԥq�q��1�_�W�-(c�w����k���(�wU!��(f2�P��d̜��y��T���v�7���c��BKav���]��߫3	o,
!g�+�S��y���cK���jM9��)�`���F`�n�x����-$��u�	y�1��~�/��0����J��N�j�������RF
{��[Z���������6b�V���RC*�qj:e�&dW�V�[�j��A���4�*�����WU����-�)d����,��R�`��4�F����#ۜ��9�<3�����`4):�`8��G[���z	I/�Q��#�x������VipL��)�6���{��q*!5S��U�+w�3�X�L���%����ō���I������"AMgx�-)���-��_*��q�N?��nj)MT�zG
��|x���.eϢ��J3��n���	�Q�&���ظ�Q���Ȅ�܌�b0�X�ph:F��Q�\��ߊv��|�Zu@1��ʌ���l���
ދ)]R,�,ʾ��a�m�ڽ(<�@��[>�5ػ�~���c08�kyYL�ʽ��I��t�rxi2���%�B`�k�\<�t�;�f�s�wb���:���ME��R�J����� ����m� 2r��d<ϵ����! �V<���C��L��\9�Z29/0��Z2�u��j-dȸ[�"��R��Х<q�2T���r]����*��XyS��T�+�������7��K�! ;��MM�R�c�l�K�W�C@v`󧥏�sd�(w�Ů��5�,B�����0��L2d�(��H��j����ф;R����˼�BKr�N4d���{A���]I�%�X��C�sI�~�L }W�����8r���ݯ�PIoI�]�3���p�ӏQ+�	�>�S���؏�Vߐ`.{��dD�RO
��iiG~\�)*��t����������Z�ax��+����B!S�B    ����*�:����9C��l�j�#��f�����a,sx�2��s��C��f�R�/�/�A���2"��ȝ�v���y�̭V]_ƻ�b��H	`3�:aC
��hM��k�v�C�<@����`x�W��$����^i�$�c�^1�t�y�h�Ib�k�x�����PU7r"8f����/4���05N�;�[�1`B-?F�B\�i۞j�Khj�t^�㍐L�\�`:���Z��
�CB�C����}s�[\�0�XB���.í�STα:P/����<��xJ��+��..��Ny��^L��4�<���^^��1{4�M���N�K�ߜ���s۩j�{LЁq�,螻N�X=�z}��l�]���;��[��8͠�"�pLAt��W/S�J�C���N�KM�
��U�R�ʑ֕���C��w�P��Yb$�B���5g�O۬������2)1����F�[�:U)f�T�}��,Ysd܈%��k�\�+�Y��&^�L�eʒ�X��d���0R�/�%9��@u��T��γ��,0'"Tw	�T�H �b��3��",2��(S~�#���F�"��@U)vϦ�$�D��cO��X�B[ɝqS}�nw8�jw��Ȁ�Ec`�Q��֮�w��Sv	47z}�*f�@��
^�x�nH��ô�$�h~	�+�h�#E�AH�=��oh,.�����YoI�V�`�#�3E�"��-�ډ:i.r�Rh��p�]����7H�_:ny�?����!C1㼖�L��R�\���k�	Q��ZK?3���w�жo��Ez��;$��#����Jg��o�1�(�)���ء9.��#e�	?������[N�4Tf���D���x^7J��9�k��gƾ�r�/B*}+���?�?�Ȩ�}܅WF��X��
[�ѿl��_k��H�&���
���w��ա���8'�_��xtscY6�Q~��-�{6���':�oo�	4k-���`HF2i�9�(8<t��{5#^�cO
5���6��C�Ț(���������v{Ivm1pO �IR6�"* A%cH8�,mvk26�Gt�ۧ��f�$�\L�\A�+j5T��?���.��ܼ`�24`����]�.�)1ŵQ�+_��cxø')֊��v��X^9�K˯n�Kon�������w��e�������l�~w;J���P{0�=j$��8/x�bF,ny��3�^�J�%����V�~6��ǿL�����a �a�;��� S��`���������5l/�����_u�Py?!���c�P�=[>�lP���&x���l���gS	VU%�\�0������q�"�E{������\}�E�Rr���l�c��&pn�v���� Cu�/�c��G��W=�ȟي�\n�u�U�oI4N��)��l
�g�RH�:�Σ�M���&WR����e�P�5��m�=g�_���J��h6��G8��8�^3AI���$���\�|Z��2ɳ(�I���@���L��l��"��p4ی-I�J���;Ij2�ga�
Z��u46��|G���j �P�59����K^�)��]R��L��<�U�ВhfdrM����Ǭ#���*�!���Z��X�Y��:��@
���s�E�*ThM4��B?O9��(��y~�v�RhI4KV�u��i>`)�vjP�^�B���@oF#�t	ܓ��g:�"�V�Bk2�|���^�s�l��T~QZ�u�8���T�A>��x��W[%M+�K�VHw��y����Q��!R�'r�:|d�H�;:��29�IM"��d@��־�+L�eƞ���f	VL<t�_��)9�u����Z��C� ��X���ˋ��2@z��;��7��MD��1�)��9�7�0�ț��j�<�jx��I+����Ԅx���@���t<T���_L�H�B�L�lX1�퐃���ӡ�A2���`�1���������:�I�M�O��m�����A�@��J���V�B���%�|�Kۯ������Y��U�������-�x�EF�lguOE�tn̺Kf�Q����^$%�������ދ���`� ]S*����__U/US�VJ��`(��,n�m�]�U0��Rr�,��I�C4$#I��+i8afȚr/DWc��;��-��t�4�3=��JoNCZ�1}V��B_ځN[���XO���"���S�8^w�GO�K1K�+�Anu�M3����,����YټA��0Է����iE��Ci��c<]����ong�򥩙���n��؉�l=-iJ�]��������ik�I��r�_�|d����:�Qze��M��t����ɶ
ӇP��r��魇�[�sU=�oIg6�]�7�M"��9��6	�ÑZu���j��|��,a;|�ӹ���f^����,7� ���2�UѲ?�U���s~���O��.���2�x���sG���O�Dd5O����7g����]|͌�+�������+��7>���.�_1�-�T��9��y��|C{�?�hF���C�}�i���_s-�аO{����eVk��d�d�~��n/{��וO��ۆT�-XK\�+a�����+�$��2�
ݑνZx�
?�:�=�sG��nm�욗>��Z��Q��_UR9�q�51������~-�ﷅMq����G535�~T���׈͡3��mSG�o�ګ�N��&6�z������?�k�#�y�N.�0P��V��5��4�?'m`gGtH^��`����qM٠�Ӵ U�e�h>���@sg�PJy蚰��hf���h���~^�#Ɍ�:���Pnނy�}����T)G��GV�tqa�Hg�֑(���o���BQ�]ئjH��fo�?K�i���KWE�I�ר����\�xL��,#��Lc`��^C�(;p2��]������.ʬ#��3TQ�*�,ʑ���Ё_��3R�^���wpQf/�|���(A��'ڑfF��l߫E���;�T�S��#��B���ގ)�G�Hޝ�vp�a�g�&�ift�%B/��;8�P��Ɍ���4L���{��Ju�'i���^{(z~	�d�GJ����l�|�|�"�ؿ�E�Ls�|���r)�u/z�ܾ#���(�kD�!�_� }�9/,��,]��h�=�-Vv�����,3:Y��X�s�*}��B*���8��g6�����6>���3��\�8��/�(�L��}=�G���T2BL��61�@�.�I��o�y4�%�9Z0���O�0�=��{��HtE��L�f�+�_�D,Յ��C°�]ؐdFb��Ϧ����:�����	M�r#A�T�PIg$q�Ȍ�4�|����}�Ak��[eƭ�T�H�ˠuqaM�$����ydsZ@2�'���l������̙��ǃ��;��"����d�%%,zv���&L�E��,�<�r��_c�pyk0��84i��g��\���<8�Տ_ρ.'�x|�L�E�zz쥶Q�chn�#�iB�ϓ���\���7w�I#�d��^ݨ/�[L��B'�lMi����� H���Q��m����_�y�a6Y��\�c0"fH2��ǍB/�Ũ.��:y���*���=v���a�J���.�����P�3�}�R��
l�upV̼Q)Q$��C�8u�y�C��R���+J�TT�c��(�{���PT`��j�h.Gh� �&d�`(Z)�����0�b�XE�U�7j%e�(ءГP��ޯ:��w�]*����Z�U�Q�>[���X2�����9ڃ�:�z���� h7/�"�M���s~({(ʼ�[��D�fQb2��5$�a8��ԫ��E�@��h:�#fR`I�#���,7��}��0X�����hG�?G�~������(]�iB[��I��T�G�T�sp�zWء��s������h����]0����:m���U�Z��|3cL8P�Q��dk����p�x![�H��z&�Sn	�����K��_o�uk
������e�.��wnI�bH�(�q杮��1����f����ɠp�����>��l��*�U�{?\5G)��k��i����ڊhj��ߞ    � ����3u1�K�,����
z��c�o ���(�����,f�Ǯǚi���R �w�v3m�z�����Y�-h�xy!sLf���*��!�T�#��;O��b�`���z��PɬMD���2.sN��P�@��ϋ2$����aP{&�b�0"�3f�O���-}P�&}j�ֱ��"P���g�%5a����O�����j(f�ʜ�1�_��8RW��rK���-���_bsc�<,�����1��冤�����&%l�x.�݌�I��P^�ڑh�4�B�&�����{�	��X���m���26O��}�2qn@�;@;�B��J)t��
��vww�xeI\7�*b��K�ݶ�p����Q�)�/O��y���s++�MR
#���;�@�Y�
f��ф~��{�v�CV�dKg{�BQ�*w���rbhқ���~T����?�G��M��PέqD/ZŪJ:�ֲC��,կ� ]>_��K�o�`]軆�e�	��3K������7���U>�������Z~w;m���yW���E�~-aWN��4�j-W�T����f��3�X�|B��i�Q���]�Qؐ8��c�PE��bBqptW���$���b���:�`��So6�ԫ�$�>���U$�5v�؁�^4.�@�}٩_~��㙔B�F�2�7������Kj@:=zj��7T�%+�l�4B�W�c�i�ڹq���I{�Ǿ�6��>�(J%�d�=�VL�
U��-�mFjWEp���+bVDW�y[)�c���ή\x�"���X�r.�+�ϴ$��ә��a�<.�x�f����SJy|$?/�!uzi1ŀ�?�`7)9J9����\o
�9����΀x���֣�.�9J�F~��1��/n���~��_Oiz�]�aN��ܗҝ�`Ps5�3�7��	"��`X��$US�j��X~)����vʛx���Ԫ�9��	��a�Xd'JS˛��>�IW����VQ�~F'c�-0\���(d��U{��=�� e�@�g0�=
yf<�*���I����_{�8�����T��rܔ��4��E�3�k�zǎ����V��1�BM�<:ok��xۓA���)dn�
��C\�G��Na$��*U؁(��w����C����Jv�F�ŧ:�����NZ�!�T�vb��2RW���6b� ��ԷE\���8��Lzǌ�i<L�>�S���j3R{�M^Is�|G�����۾KJ̞�9�ߐ"�w �/�����zK�1h�?�x�y��)�x�DA{��۬����[Rx"�*�@�5����Ԫ.(��
G��-)�[.��!y���.� �K�����V ��Q�f�d�B>$�:T5�/w �sM�S�������Vc���8�q�X�����Fc]�P�T��F���p;��/Q/�"im���F_����V��'�֑4�`VӀr9�˽��7�O�����W�q�r���ǹr�G����?b��]��M)���Ű1u ��(�Qu+�7��s0�11o 4vt\8����PP �(�qd���<~o!���PAE<�$1�E���ЊGg��8��@�]�g<P]�٠J�v)�iс$�I`Q�g%�4J��
��I�{!�����HlU1ш�������{u.֬�o�Oѫr��hi�\[�0V�{�ہ���i�n!�5쓀����ݲO��]M�tBo� q��x�Q�y��E�l�tK:C�WǊ�0��B��@�6I3c�I��)�$1��!RhI��h�P��yO�-�d�^潈Z��i4���c�<՞r�� U�S�>
��`��w��"�K:~�\q��A�
<Hj�t��q�m�1�Ѐ�
��W�i>cd'ֻ\�KZ)O�jHF����pd\�.h�{�s�U�ي���,m�	!�(��å�2�$W Ok�<k
i9�v�.�鴥M2!$9���;�0���:���E�ڣ��~�R�S��d�nɻ'���A�V3��f ��D��؂a(�`G�H' ��Ɔ�{7���o/K�>��W+T	C�R�$5 ��<�^P�Y�| I{�������C��P9\ځ������0QJ�B-Ԝ�����g�EMQ�Zs�c���>'ǿ���Y�>�oI�ʬZ�v�RhIÒ\������i�K��cw���=mg :�P�b�q������rG
=gDɾ4�P�5\�\���oj���S&-�1�X��ZHleC��3�Gs
�k6"A��\���|G� a�2�i4�h&D�"B�7����"Ŋ��ؒR�N�D���9l�-�k,(C�se���~9�V�DԖu�<#�1�߀`j5�s�7�/;e�D�\�q�b��V4i@]�v�%߮�z̽���ߟ�@�0���x��߿�[�z���T�s���0��1L��XZ%�jϽ�/�S�Z��
��Du˅�@f#q�����9��J ^� tF���_{��:\�[�e�����3�Yc�h�4��֓5����@�%�%m.T���s��
�5�:��C��9V���ɏ���rޒ�l�󒄊!�9ܞ6f/��!�w�P�����;����K�rC�����p�F��*�ЭL�\��+QoHxvC�.�����>�!=:�_�jĂ�zA*��rȐ���5�:���T���"�r��ԧ�?1R�)��ƚ0����ǌ�-�_U�6���B�+����Ň��r��ʊK�OmU�eM���8���5�Bv΋Fݚ�k@Br�s�*��thE&���6��&�Ƽ���Ʋ�^�b�;I��RҀ<a�Ŷȯ�T�CAhw���
aa7,O�f7�4x� �;R$l2w�γ�!��E�y�����,�L��>��M�X�:Jh)rܽ�&c�w�����`/D��~̢}��R�"˦��e(��0Ŝ��W gR(����R�Y�C��)�u(4�=�&�	������q=pkk�C��4=e����"��Ic��ph��%/LR3]��Dj*���k�Ǜ�h
*Ģ�g��t/����Ԟ��W���ڤg 0������i�l8G�n�fn���#�R��H�{��&Ts�*�&�z�v�9a-o�5^��=Kh���P \�e��P{4�L��з�s�y�����!Th���D���)��N�]���$D}Tf�4I5$#	H�}��i�@��Z��t�B��ɡ.{�ڦj~�i�~{۵�:�Y�
����IV��e-y�fC�"	$�U[5 =�N�o#�d(��	����Rۣq��l~헯��V������ ��A9m�����n�DQ2?�lkW��&�K��L��z��z���;^�b��^�l�n���b��b�HL�9P�3P]i�r����t���`)*�24����0�ţ.�����jke/̾#��ǮKٜ0}8�P��;��`��y�@n�E�~	�SDNK�@�G��kV����:��O,/����š)%&E=�@g��;�Ӻ��`�#��~f:�[��`��{���Z�Kδn//����2�#T��):P��%�ŏ�7�V�G�=����Mg��h>䞄���]F�ӹk<��y-��A�� �J�P�������H�h�$�jJ"��;<ۘ���j⪳�>�B�l&&�&�*RȤp�����8<�J�FR;�<�5����0�ޞ�xU�9��@��>�x.B���@�њS��^��!�_�Pf��)X�
�Ɂf������\?^O�-�(;�r90�P�59Ѕ�[M���J^�I}lʜ�ȇE�К��жLJ���q���-G�5O|*�&�X5��Vy���Y&���Tp��Qr1]�c�-ǩ�k���ߌ�|��������~��뺋��;�G�*9	ޑBE�Bՠnǻ!�L5�i��� ���u��s�]�vϝ�׸�YͽU%E�l
KH���M�P�i ��I<#Gt���N�1y�D�H�;%��Vsx��~���U�|�Ѓ�T����$��h�%��.oH!�l�H������u�T�I�i! f���,Co��(/RP�P�}��\���v>q��*����촃{{:oH�ӽ�&�xR��� �  |�>U���}x�B��v�����~��&C1����
���ͭ�F�9�;RL��T��41�Т��õ���jG.��I�RQߩ�!�ۧ+~\�!U���ǫ�%�:o�@
=�0�#����s�ZX�c�;_�-��c(�ޑB��L��u�!��/oE�.mj�j-���oI���e+�#��H�́��z���wy�6�31��Q\�|�
"��K�y��w���7�NM�!�*e���\��
"K�n��ϰ��-)��5�f�� ��d@؍��G3�b����������g��ߐBi(�n�w�Y��D�)Ģh����bH�%����,4�Ж�K���*,�֮S�oR�����_Gj�e'���`�r)4Sk���]�֗ɡ�f�D�ZH^�4��v��0R�:����Ti��;�W��ީ��2�=8T�C�PA�!�t�����I����e%�Q{�p|�	�c�w�Xa��[�������*�ح�L�h{��J[�9�4�B�f;3*eO���?��IP�h�#p���D�wP�)���e0��)��!!����{����C��zL#W.�R��/57�[I%<'j/c��@uj]�́E�y��3��M��e�ǭ@�ϩo�;P�N���)�}P�mP��E5�8�z�gyɆ�G��p�r5~Y��C��>��:�\b�!�u)�h�� Jp>���/�[�c(�}\�Aɕ� �� �yk9��Y@��9��U��1�BʰU��nc$�.���!�W�� ��a-�kߏ�%_�I=�3uV"�L����"o��\�)��H��v��臜r��C�ӳ}�>a�ϯ��~	�.rz���<ǞW9=)k|N��`�<"��z����{ ��XҸ&mu����!��]eJ'�M��E{	<�C���}��
9�-�kT�7F��!T��p�2Z�)-�L��@
	�lG�́�U��Gؐ������-)T�$j����B��!��m��.2�r      �   #  x�Ց?O�0���SD��P�VbaK
C��Ăd�ΑXu����c�D+�������<�J�Zfͺ�I^s���h\q���2{"\�y�?��D��0�E�|�KJA{�Q���[Za�G�T�Xˑp3�F�N������]�cN�G�4mO����Q�1�{�N�辒D���*�lԁQc "�=���}p�E�Jʝ������<�1>��)�R
m�!��G�27k-#?��o�(ܸ?����ޒE��t�4��zu_OdF�M(�=� �u0�N�r�<ˑ��ʼ�<��4}�7          1  x����jAE׭��qS�~��p�F�$ٴ�<H6������3�����ܹS]�Hn!ݢz���R
XJ���ݶW?�O��#�aL��	;DqO3:h�@3@�=��m�ax����1�ͮL]����|TD��V�@	AR�,������&}�t�S���O�"U� 9f�zX�oVV̢�������C�l�p�
�ʯGM�U�j	�R�k�)�<e��+���E���ƶ����ϝ%��\��������U��$ ��j�<?������ZI`�b�|��lS�=�X��8,�C{|އ�bL�L�L_�݉lCWE�d���5=©��ZLB+WXJ���[����0�#:�o�?	��a���1j��:��+���U!��E������KM)�1�1Oc�|&�U�jH
	{�~xl���j�DR�h��q��x��D�#��,QOk�Y⵿{y\���k!��:�$�+~.�� L=teG~����l��A
)�"C)�9_���ӧ3G��m*�ڋ�h�6~aˬ-��w���.rޅ2��0���ܪK,         �  x��\َ�}��
�G��K���$2ر-1�O�{�t��dQ�;=��2�@Q���S�be��8u��������ݻ_~���o����s����������������~�����B� ���K�?)�帍�m@=`8l[d��K�c�t��^�K�u����-���/��`��K�u���!�.��~��J:�}��/>�?������I7���p���v�\�(��%�����K�K�Q�i[���(�ö��(�%�׫}�����`i"���i�;]�E�U����O���% /�/`c�0
!Z�eK^�����e���SYvF]4,�N+�Y_��n�>��V���M�|��������
�xLի�l�K�z$� ��d�ٵe�ewIF���e?��i)���$#5=Rkݎ4�0V4{��8��jV��*E�r*����Y���qHy�n	fb	K�M��,^�o����D�ֳ%|]fV��+,�KNWZB̔�%<�~��.1�����B�N0dݺݫ f���Yg����NKU���F�����(�I�]�r��+�H%�K�t����)����)Y]qt-rQf��� i{���=��G"_����n�<�u�YN�U�V��U��4&��n�0�-��)9����vfa�׌��� (��w���&]��u��2U�k�N';S퀙HX����۽^���pm�\� 4�'��N�ˆ�3iE.�tSq̈́��M��8,��;� ���=��j�hCT��f:cp�%$�ògvHbRߐxY&���Al������c�.%���kR�+[#�g+[��n�{cgCm�&%�$�C+���2nwurnEhu�6�bwU�)����,��,�r��ȅe��kA<�����5&r	Y�Ѱ7��U�2�S��t�&���tVu��u/"�|،=���@�#	��Aj%I��(t%��QD>M��N<�tA:����
EJ3P	��p�`CiFANʽ��P �l���"<�X�7�z��/*zγ)Wu�%��:D��θQ��Ҩ�R����kB����ǀzTColA�	RB����C>��iio�&�ď�E��[!F�Z!d�L/7ץI�Y�g�N��;58Tx!����!ŢW/"A���D�@Ju�m�C�m����	�ܦρ� �ru.�l��T5�m�:��:O�m��,쮛����m�e���vbO���^.1`(1<�&?���fvQ:cmY��hk�>Z	���mMZ�רT⁫���Z�.M�#<�����.�W�p�jD�'�o}��� �%QO��z�O�{�M�2S��k�DP3�}�
Q�S��q���4yo�fa�.Xr�g��{��$WX�L��i��x�oy��@��?.���Md�#�Z�S�^n�s���i�9QD���9���u�+�hj�pt�˨e��w6#��<��D�9��T"��D׷�2�P�D�ߑ�QgA}�o`������f��n�"�Y �����2Խ��F�a"�����p�I}g�́n|�̈��KMK��m}@G~�֊��4�#*�3-)�S�`s������������e��4MX�8=��+��$��r3�Vܱ�)�_����$�Z�Tȩ�߱�Y��h�����v,4�\k!��>�؋(�B�c���U������'(��n���W�E��Kk��Ў�"��b5Du���v(��t.��b*�s���H���*���nZ��F�T��w�۶�E�c���6d+�YzMy�6�::�$,E.���I�z�'��I!aq�����E����n0gQ��,-b!YG����2&�*@���Y9��ҫb��'Z�O�	�Ò��k��TЈR���*�c[�{��Q�F����d-F���E�B�/��b�����A��\���܃�I�N�� t�a�Ny4��u˶���܏ [�6D*.Z�Ҩ�o�I�Fd��hyPcJBb\0���%��$�P�Z�;lG�h�y�5�g	z�T�9raQ��eb�B�=�]�"J������J��"�*����ՍXhK�Z�t�}�@*D0HP����h�ؗ'�j�y(�g�:8�G8�+��=>ʟN�V&19$�̪�5�D�j�����'J�v�J"(�fZ�uB7Snv����!n������W�,������३Pɖ���CF/v;��"��_SЃ��6r����\�S7)OX��嗣�\NR��\Nb�E�J�ՠ��GO��K��ڛs<~H�[�- �e�eq�)q�����pg ½��Ch�5X7��x��d����z�E_�}�vamb�R��xY7:n�7x��)�z�i�)O)��:�맵�:�x��	v�i>�K���a!-����t_Ȑ3A5�<�]��:H!���=G��:�|��Q��Q�����͒exs[a�o���Os+���* iPl�R`�X���g��wt��Hj��>#6��`n��l��y~�z��a�j�����W��t𲦇ē6ɸ��,I�ej(�

cԽ}C8�
0U�}�Wa;vl�F��N�04Q���%5K���-��j6���<1~��j���`�!��j4�BR,$؅�'�zMH�/��m)�!��C�&�y�z��e�.b��܎G�(X�&�8b�v@�,���si�i�|�urݖNk��*q��0˴��������0	2�39`�R�1�,k�ʐ��.�n ��d]�����D��,�Q33�s��EI��ׄ�mI�z$��;��ѧ����37���v����ה�Y��)�%�።5J��R��Y��v��w�H�'̴�B2��zm�Po��vp�M�yV�����5lM��PC+1�#fu�`6"��GE�Ҋ�� ��$>7�ƙ&Fn��,r�NI��.Q3���4#�罺k�Wq�Ϋ���3��J+q�Q+�Q��9�H߉bM���p������6�q��u�ULܟ��Y�0�-[gӒ�A�^�ޠ0���+ú=x���+r׶����[�a̩W�l-�g���M���mL�)ʸ�n�mX���__�x�	k��      �     x����n� @g��W�lc��C���1s����:�H�r�d��?d�0��ϯ��<$~����� /�v����x����k�m&�Ag��}[o����f�Ż[6Q�E�<�@;��s�=�ʵ����k!��Ϸk����D&/Q���H�D�%J^��%*N"kQ'�Wg�Wg�Wg�Wgk�����Ud�*�p/�<�^��HǢtY��D�˶7�**N�GS.qE�\������<����Sΰ�+ғg���)_��Ek>��3Аӓ/��4���      �   �	  x��Y�n#�]�|E���\����Q8� �f2�80`\��a�����#ӻ���G�$�A6��oRu���q��&�"�UuO�:URZG���S.�R�阋	�Ɖ��#J�W�ӓ������?���Fo�<��ˤ(�:�X�USG��M<�iUF,R�F�FɻͪI}5�<b�፤`�[�E��ɢ���.�iF��<��ӘQJӢ���G��ʙP�&I�U��	4��^�;O�6��sb���b�ؿH�(���כ�H��
��X���ЄY��5qc��ݘhzr�2~s�����et��)p�҉2�	�!ӓ�����>�|���ū�g�Ϗ&�E���iYIU����z����>;ט�"&�cRۭ�y������l��i#Z���b΂߂Pc�҇!19n"(�Zs�M7;�+����=X��݄�	���T��o�2-�E�MR�'WM�>m�:���}�,����e�F����{2+K�� u3_m6����$�� �A��*" $��Ȟr��`x��aE(|�� ��IJv��ܟ���vJc� �I���||z����L�� [����:O�����S��5ũP�ǍBp��PU�)�탪� ��1FR������tb̄�)p*n"N=2��"��(�"%u���yE���s`���?N�Д�{����P3�h�`b�����Ð��' ���\J�����Zb� �3Ս�AԡqI�+֥��$����~�4c��QLh)�W2,f=�hn���&���*��^�� ��4����15���rV~���y��<~�����7��&c�;+��jU��$/���W>O�!$<�T��^��%4N%�9j��@����y����	�U��`Vf�T�y?O����ƌڶo젟�ѓ�׋dnG��F��H��� �i���tLz� �A��1���Oj��*p/ԁm"�m���~~�����ϯ	ih�E���úX��$��f�ƥ�L�T�\��UG��L�C4`:
$�� 	�-�k�t�H�Ojh�W>˒y���*�)���Y�&덯�lb?˒�)c�4I1���|m��q}'��o��;l�b����Ŕ��11.F��b����2���e��Z�h��1Hh��ٮ3�J}N<���C�ʘS�>L�1�r<t�+n�;f�RlpL����8��)���C�@2=q�4V]��!�Lo�-���׾�}V���r�W�.��OX%�9fꢩUt����[e֊UO�O_���Cq��
4�]�Ѩ�Sj?K*r]V䦬���H�m���Aù;f�����vǮ�kv����c4�e����"~Y6I� �<��ˎq+R�gY�>9H���b(3�DG7AK0e!�]�b5R�Y۟Z�S+I$ h��@X��7�/����vP �� $�A����s� ����L(v�B
L�H�ǀ�����o��.������^�t��ݷ����?���۟Zۿ��/��}s�ϻ?��ﾁ�u?���_���#Ԋc��{:�؇F���Wi���I�taT����+��̂3���0�);�X����2��rUf�ҦeqUV�$>̀HA��*����k5�NdF�8'I��>-6�e�oAU��`�
���������I�f���ξ��.��i�(�E��Z�v�x��K�,o�b^�EM��@\4�I�"���� �,>�o�CO9NBc��O�u�Ã|QE?sЌ��~���G	u�t|�b������1��$3j�V:R��u�z�k���ɪf�E֚���F*wR�K"�(��1܀C�
���^��)s�=�z^�T%ȸL�2��o��h%N�ar,���c��oA��Wj���i�T\�a�t��|�~H��r܄Ck��Z����%1
KK���H�"�Gwc�Hs�P���w�(A��)s���!�Ul!sԺ�#�6{��!Edܸ��.AS"��gM<�5�bQ��Ϳ�����=n���o�_��$�ߧ�C&���j�d�: )�1�	�z�����==�����M6'��D/�eW����N�U�n�5eo���]��W�t!��˳/}�I�4��ˀ{9V�e7P�3u��bdKI�[���iW �g���ӓa�4��vˍ�����!��ر�M�=����r��B+�r*�.�bDīe��!�$���)������V�֎�dZ<j�x�AK/��n�%F
�W;W���l����o`�~Z8��k7��Z�]I�q��I	�9(���n���}Z������!N=)?/o�p� 0/���~�P�+?�}����6ǽ�,��b���(�=��90�c�z�*��Ƙ�	H����[ �h�]��9;;�/j��e?o�@��r���T�Z�!Rp��Hw���t��R�g�ɓ'�Y8F      �      x������ � �      �      x������ � �      �   5  x����n�0���S��Ο�����N�v�hՀ�Q��ρ�41�U�~���b#���[��A~���mE\QD��c�Z׎�\�T�O�(��^p� �Ĝ|���ލnH��c���7hdr"��������g��I!y�K�V;&C�I�����4ߍ��s���ߔ���~2��l��:����ɴ[oq������m�E9�E���xsgŜ+c�(q���6:K�,�,QH�k"v&(�l>�w�e�r�06ǯ���O� ޳� �O�U�4��,�6��(L��)�9��fS��W�p�ޕ�;��EToZ)�\~�v      �      x������ � �      �      x���[��u&�������~����I��i��K3��UQ��2�yP|�4"���?0os�5i�ٕ�8�kz�_���9�����Y��Pd�Zl =2�����%���z����j���R:-����|(`H�JJ����?��'���v^߹�Wv�ܮ�C!-���;�'ɿ�����<z���?�?~_ج����:�u�
�P��9ʹ��F�F������E��Cn
Qj�W�!�P��R�� 09�L2n�CfnF&i^��0Up�P��̔^
&'FX�ԗ�i=/T�l5{[m��O��Og����y�^ϖ�5~�n}�b;��.�����A^<].6�p��ȳ�ÿ�ݦ%�CϹ�z��5��1�s�3|�bT9L�U����'o�j�)��j�e��CX����ܻ����o����y�<ő PB���.�UuQ7_b��E*Y�Z�ūz�>�]7c�	0�
Sjm��SC����(��^a���}�����)��Bv��t)h�P��x�4��f�<�-^��t��+eMW���w�^�RPdmi$�<�M���#���+@(K�k+)E2��C�K+w���|�\�0��"\�N�$*��0m
S�2��X��ăM3#��`��0k�N�Ir8�K/�c#�+�pB�k��}"w��J�0�,9��i�!�𼳜i�iL�w�	��3��Q'P�/�p�R������	õHa�hv����=�Y��AS��=��k� �~���h��L>T$��,;�>����^�N�&?.L���(&h��pmp�9O�p���cX��A,��I!�K�i�UJ(��^v�|�k�/J�4�N���7����N�LV�jQ�ŵMa�.����Gf�w4�4~Ʋ-~��^�6	:���4�a:��N�Ye�t����vq��߯�ŋU5[�0�o`�+Q?��՝�-��I�(N�u�����8����hg���wu��~��T���l��(�2V<{Zlf�9~��Y���Up�f/��S^�Fƭٴ��w��*}hf2XOR�L���N��<��D��rq�S����C�Jf�y���|8��)cO�B�t���AK�����)vN��w�d��C�K����:�셽[�fw��������t��,a��i�ɽ�w�O�;���4h^Ωl���d0d����e�ߪiN�ݱ��s�+�#Q�a'���|c�ӧ�?��ʡR�ȡ�Ô"�q&Puc�0��B{�n�P:��uL�+˕��|�\a������!���@P��E,P�+n�ʴ�[�����S:���>#�t�O�����M{�0�p��~^��UpB&8(�128�`�þ�ښi`��;� `��y�и�5�<#p��.�WГ�>�N�3�x�9�hݒ`�bZ���������og�
���������^��W/\������x��Qq�y�]Tş�
�����˅���I�jyz�r�W+����:��hN����tb@Z�V��s#=玹썅��iiT1>)4W��uͬ<og�ĳ��/4�{O�L���R:��̧E	�Y��"o�\:imF'F��^[|�ɳYNO�H'��m��H��9[j+��#�Z�.�Уί�[7�[g|݌N�u���K<���gA��Y���(V�(��Z����(JB�0b�1r4)�x�w���0���c@34�� 1?�ÀJ�(ʎ8�x�x�n�������4���H�"v�N�)>R�J>��Q�)L�5�����js�n��+@��Gj��T=�ߨ��{8x{�B94������jq����h��G��촾G/���+:P�����3͕ZZiU�.%>�@5�D��Ȥ��f�z�]��x\W'��O״%=�vשqxݑ;�}��-K1+��rf�79faJ�n�L��0Q8w	�Xy�NpM�+��t�,�ӆ�,)��!<	��KT>�}�m��$�V�%ͨT��� ���������,��ɜ1��c8����m-kL��G��b>��wuzge�I5�c���m@-M��8���K᝕�s!8�-�Is��l� H�����H�����7S�b�YV��3]Z& ����$��Vw����<?�y&���	?�L+۟��'%Χfp\���y|��&~#���w8�\oM�
���a�gb� #Q��HŗՊ�7�b��,1�c��١89z��D��8J��Y�-�":���s(-c�e��`"͓��&��&�f��A�����E/is �����m�ư��M-�%MƊ~�����Rr!&�d��=��V��'����Dt?�X�Z:�+�����f>ľ������9obѼra"��{��+%)iJs��?޾߂=�3P64g!�lāʍ���W��JXaz�Qr&��×v�h�{ӿ^�H�����`H�i2�A�l�8�cî5v���%(<�6;ϴCA���6D�i_/സ�e5?�'�Oj:�`���l�('*}��!�����M��I$|X�,���m�w6b4�_ѝ1�Q��'��h�����=�W�U��v�'�j�S�@_*�4��E��:O.�+�G��#NI#R��lQh�S��Z�~�\�N�����m��]2$=f�hed�-c,�1��zCgKHv3����;_ROK.:/B��W���l�?:�b@WN��e]�@:�=�֟�D��M�C�Yq�}�����d)6��/��7�kR�BF����Є,��L�/];
L+��4?x��h��e��Xg�����W���*^U ���8�Q�#�7)D��4K�K{LS��i������t�nq=xB�����y�YT�7�'���1�a��Sy8OV���E��u��D+u	��&)=n~�3r<�%����/ Ul�A	� ��V��pMW;U���@g�7���^��[�'p��qX�d @�FY�ʔ�<y;�R���Y�NM�J����#�ʫ\"�鲘�|�e!|
�|���-bLvD?�s��$�,nY�1��\����$&�W^L%�C$�^�WNP�F.�c���'��/׹�M*�gR��I�ə�1����ʂ�!k����G��PD*w��o�㣙�V�r�IL�0ym���d�Ϭ�Sz:[��1��m��-X�L�l�����c�6��1��jo��K�q��:�Mul��G8<jLI3R��������p{'&v'X��E!)�$k_���muXo4��Bw����q�X���w�IV\�%Y����~��JkK����)���z�f�A>���E>����?Xت�ܩ��-��&�i!�(O�[��-�B�	�'�}Y/�oanVzu�]F��9�����^��f��ǐ�jSl��:}[/6�U]�\<����^`��5
�+��b9?-�]����ka���1�Cz8�A�q�|����0��I��̗4Xg����,4��y���DB�l�ܼ[�޴� �.�{�+�3�� ���̋t�9�k�����f����>[m�0�{M�~�Y̫��&%�F	=X�ŋ����d�}*���8n�;������+� o ĩ8��Z����C�T��V%���cC�i��0�"��~��Q�Zw�H7FUw�0R����k9�7����:҂0��Ф��+��Jx�3���(t��؉�S�zX�`��gT%���.�il$�	���v��?4�EN��X�aK<F��R�����ѓ=�Ep"uHV�2�UҬ@���Xן(�����c�D�i{-��5�a>�\�o�	�^X9���UX��2��cd͔]�k����KpiENI-�r��}ǳQ��7�Ŏ�K��E�AL�r#\wX�m�d�.u\6�/NE�9���QՏ���.q\&�/��<�	.$��%�r2)$���CKp�����<��<ص ˬ�&����0�9�q�D^��k��!`�dn�x(�Kn��M��g����/~1+� !p�:d�M90yA�B
f��P
u�T�އ8��q9߂=�����>�,曞D�H�
Z���2�l>���s���:��g��k�]���r�9��2�-��zZ�U2M{�SLd6L,J�    &6��k� )�"͂7y�
�l�:5� K���	�չi���iKo0��J�ˁa����S0����B=�)./0���o\G:��6���wFOM�;o,�C<�$�nCZ��`ێEjt���ږ�b�h�����ߢ�w�Sط7�I����
�`yp�;��J�G����oڟ;���.%�C؃���O% �� w6���O,ܐ���/�>˚�Ĩ�ƚ?Ǚ���g����6�¸��!*ea�(�e $�1�$�B!>�rL�A��T|/�v!73Ѵ��<�f�(,t}Y}"e֑٦1�ά��S|y	;y���jF���Ն ���"����2��K
�R��Y�Y*���$����l��WE���i�%`,�x�ZlV��-�x���t��~����/����\����P�pp,N�������\�o���Y�.\��Z�N�7x��%�{jH1ǯ�����|����ӫ�tU�~�����,��P��jv�n�����ۚJ��<OW���+r��+��q�������P�0Qt#g0L��;�����˥��A���X=�1"1Qʠ ��]I��N��C)�r��f��oT��p�v�����n��/wt��B<�:�(aXQ�q�8♊'���S�Ҏ帓��Y���}�7>�A}�]gQr�ۓ��Uq��n�i�vG5�m�g�O��=��[��g�oB�	�VvefkH���b���	O1�C��	u��.�%�{j������"ɢ�X@�����u#�E����3ɾX-�z����Ǫ�L	�p��ƨ:��7lo'�L�U��J��yo�X��%a���?H?Db�f��l�]]����m�.�g����PU�JGD�� �1
��t��L]���LGP��l'Nq�H�&8aʹ�v��j��lnD���v	̒��%?�,��<�-5q����y�\-O�&����"$��`�
�ρ�	c��߆-@K�t�a��� '�"�?İ��[�AAjx�gU��в��!å��K7Ug;��]p��EO7f�znҘ�$�>nݴ��1?�+�ׂ4 "�tLjǧ�����4��x��(���)�
�GM_n��f<��WI��#���MNZ����u���� R��t�͹��VR���L��@TKa���?�t`q�ԉނ�ؤz ��xT226����h��������&���g�N2 k���=L�pj$�̓F���n_�b��-)9�ኳ�x�Xa��tvvV��R�o���g���N%�]�yT*���<0ϼ�#�����m�8�O[��K��ޝ�[�Fc��`�u71�p�~N6`���N|Q-�-؍����z[�w�f��X,�d��mp_��u��Zm�+D�	�#��Kf�sI�K�t+7���^,f���IuZ_SR��Is���qj��
���lȑz'��������lH��1��'v��8dM<�X8����X75�<ͷ�����G�W�`�!���'��}��	Ʉ��-@��~jh���!��DCe��X1hI]�"�*=�(�*Z�OW`�ly�0Q	L�(����:W	�cFÁ���c���u�� =Gd\�����\����^����Ń��y]�'J��n%�Zo`-�I
R�ZZx0,�������
v����ls^l���Oנ[�墀p�/�Cp���,5��Ё>
�5��졼hf�-�[Nd��=5���8S��]���k�X�æ7�M�}}Vw�ާQ{����,���a~<��%8���y��Ƴ���?���3Ar+�L��Ɉ��14��Ĕ�c�19o��jy~V��w����<	ړ<��%u�DFTym�XN�&�G�<�*��?��;�UA��6M�3x�����C�(~�橀� ��`G�&D�hh�A?�55P��Mv���P�싫��ʊL)��4�d�>|�ւ^�FO� �c�D����G�U�?	FsI�8W=Ĳ5��k�}�c RNMm�x�g�aQn�L����)����4�lv�(����5'���C"s����T��Kð
sj(]s�/f��x� iL�C�h�r @@��qi�F3�P������g�l�f)H�C�#6|?�"�xK.�����!��g�rѱ�F),L�vϰ����;5�K(���ާ�w�r>)�*�D����t�a"u���؃@���q�!+�F�+��('1�V�!�)�n�#:�mD7�--3R��FK�*�r�ӧ�@��n��,z1�a03 K��:�(�;�[�Y�󿘭�C�1��Q)��uAEˊQm�P�d��VFy�y(՛T܃�:��NyA4d/�(���]��bX��枅];UN&�d��TS�8뷘s��甞�(�����Wu���thz��}��N����D��#B�2��Ff{G�d����o��ZmCz騰��i�8Z!R�\(QmGHaMx�n��A`�����<��)x����f�A�y�׻HRڔ`��V]�,9J�ñ5��x,��R1-qgL��%@�x&8���{r�d|��=���ډTU`D֊�H�:$ezB��=�� y�n�xJ����\�/���N�џg�n�4r��S`�ȕ��L<�Ko����E��k/�<�o���W�&��_���],$麠jq����vɈ�D�3:�����-ZZ���9"�vH{'{�<�j1"�aF��~����fV-�����tv��)���Cv�m7��c�̛COG�s�f��:�m2c��t�$�f'���h؟�IQk:9�氉%L����f�`�Y�����O�٥��>��x��
��9�o��:y��U����2!&���ԖAQ#��e}�!�����d�i&���"Z'��)h��A���Uכ��l^�� K�i �2G�S���9b�&1J��,�������O�8]�HG��6eT*44GKX��=��-){Є n�)��ٶ����p}��I��puP�3�T��.�n�0au��y2�_�,�Ff��b:S���D�/��73ʭ E�R�Ɛ�� �TXP�Fi�Ɏ@ڰ��X�}��;L0�HPA�{�ׄZ�;��RJ;b���Gqq����eК(oG4Y�H��x�l���#��6*/_i��ӌ�������	^��[����Q"��8�r����l��2�q\KNA$��s�"�T�4;0�Z�4���gO�R4B҇o��_,)�gIE��.��z~��f���ۺ�<�Z�.x^W��y	�����Z��zu2[�� l Nj��j�~S,ϊ���r*�)\S������rSS�	�[�7}^c����~1��.B"~��xu~�7�S�Ny?�:ʀZ�ŋ�٪�#BĻW�-���v6�o`_���b��;\To�bQ�+�V�zq�����b���zY�m_.���q����l�>�&�F��0���#k8���`�U�uHͻ�O�F��8�꧸˔*�b��@��<	�s�7��vj��$�;J���yS0َ��(e������!�͔�S�խp�lM)�`$�Y���O%8�a��G�aA��C�i����;=54���B�����X���`lH��a�����9d���$���'f���B�}q��P�����`����I��g��P�� ��2�I~(:&���	����m���|/JŤDE�u%횉���UԘ��|L�H���ǶK�i554�+xM���,""� mP�A�$u�C鋮Vx������s3$5S��ьy��ٌO%O�))��<s���.������l�>Auڐ�2w1;] K�ē$��CM�1���Rӂ�=�8o)P�~Ԛw���o�{��LN�T��©�2+�� ��W�J�]'�5�%�ΘK]?�ا�R#T�v�;��:413]��+#S7���~޷w���C�b{�n�"��@��F�|X��ln&��I�M�;��tKR��K.��pT�(=J{4�R�������r�
�O�v��`����8��8쩒�����};M��>*��`�*���L�^�!���R�����`�z�5%�Ig�ɀ";e�4�yVJ�����}���]�1��<�nOi    Fm�q��A���>fio�VU��q���~��q��k[j.L��r"m ;�&��`�иݰʜQ
�.-R����/��y)w��f�xnߎl�l�(K���0�T��eRF�^��ަ�G{>� �Z������l��6���=<Îˈ�2YКC}�:�����RD��h{����l��v�b),�d+d��°�_�\[x�/v �([��tn(;�
�4G��Ko���)� �2̻��6@߮EMP��7a��o�ټ����y1��Vo����iX\��vfp	���v�E������G*)�<���jAm���'UC���/���w���='���d���i�r��H 렛�~�\��5�Rv0�ϖ�����H�j"���$��E�~�U,���f舅��#��ҹt��8�Fh��#��	�mh��XC�{x���N�8*I����/�����(F�|R!5�H���%e��:�9��	3'k�p��F )In��i�vV�&I��R0�c�����]�o;��V'��u�v~U4�M��4ag���2z��f�6�o��km<��iݐF�3��H3���)4���2����kL�z5�w�27�6�r���oa���L�Y�+P�3����g֣�	0�h!qFb�����[Ǵ�fɆ&��P��b���,L-ՠ`N4l�]/���<@�Fv���|���䤺A\���!A����g��|ճD-4�J^�zL#��t�a�.28���ŋwK7b��>)�U],_�g���r"{0_����/��E����[�#����r�.:r!�z��]]̗o���`���պ�)���<8��_B��x,b	1��7��89�V����p!']N�V]^�/�[�����X!uߪ>-_.�{5�1l���C�����ߊ���o����v]��<�[̷x0���j��3�`�ssӌ��ܣY],7-�Fx���0��촹�y�dg��zC�}���j�SD�.w�?Q�J��*WjG-?��?�cW��@��-�����_�>������5�� #Wm�O�S������/T0P�j�x�f���G�0=N	�,�G,dRk��S�4`A�I ���
��1�E�J����Z��W�?
��L�<���"*Q��H0MS8l��ȸ��������,b���>N�����0���FR,8�Wyrk3����T)LA��`Z�0��i	F���t~}�Y^n�p���x&uv�?
N���?E,�H3bI%ghS�#0j�rvD����eU8�[�mʪ��%:�I�	�e2�^G~W��+��6O�}��/1N	g!
���eu2v�Qb	j"D����t	0�:��H?ۮ�ӥ	�)&����V�}����M�N�Nz0uc��]�ik=���`G��t1�]��rz�17l(1�;��(N��Y�w����\���
T|{�����U��v�
ƳW��uMj��rv�N�F���������p�G���U�u1��բ8_�C}+��t���a1��\C��j
1#�>�Z͖[�4W�ˁ�9_/���W��5oT�p�uu�$�Ĉ�eK~3���ס�O�U q~?��|�����f}V�Jx�vx�Wu6G���k���YqV�I`/��Z%ouJ�dY��M��V >�o��q"���j1�����q�*�������~�z�܆�?ŗ�����Y��t�Xoq�ט$��G�7+c}��� BK��*|Pl�p�k�b�v����,@�o��l>;]�ӢnQ�V�8	/U��@�]���NA��������˺>�6�S ��]=���u:> Ʃ��P�SQf��D��J��7�(�.�_͋�_T��w��$v�n%�{��F���3Ңj�$����-��sz"D*�C*���jL �Lm��G�+�ʧVK���Þ��'fr���WS�1��n0��t�v����;'�Nj�SZG�n6�p�Q�/l3N��E՘�L�m�"�N�6m�p+r&�0d!���֌��n£H�t9�~��P���i��'Ւn�Jm�/j�c�m�k��D�k�f<�&�/^Xi��w.W.��s��+.TqLtXe�	ի��	��/��T
�zQy�w�s
Hd�-�tN�~Kn�,(�O�R��e� �>�
�W�M��`�}S-~��GϞ}�����Z�A�JR_#˘��
(�8�Ԝ�c��ɾ墈�/�����ڻϮ�	f8/�نs'G0c\K�s[��vG�r�X~��`�lc�r�[��]HX�¥$'�����J	�cyN�Q8�!�!�.�.��,F��4����%6�ɶ_���+��/��4G�b��w:"vL귀��B0)Z*j�.b���R������� �����@�bs_R��HA$����vb��	�=�V������*���4��^��k�5�"AK|K�t��L�z|$4�kG?�.�5RĥM}��g��bR� �#�iЍ3��!v���zH�Nqbǰ�X�W���6��ޑ��a>p5�{��n��;)uv�i��y��&��XfE��Hf��T�6�u�ؠd=!�R�'��}�E�~v��!js�M!|��6/e@��q>$��c%S�96��B��#Z'�u2�9�8�>c�#�K%]�s�<�ɰ�C�sF)�����.cd���<�M�ݏ�Ks�{�E�5��7���+^*t���I���nf����yg��f ���^Bb�!��&�H�r���{U�r�;�����C�U��u)�;�W5���Ú�ਜ਼-ڴ��H���{�8�/7���*�z�:�X�l�z[/��y�� r��EG��%�H|P�c?���M��9%�g'����~^-^o1˚��QNΗ�u]�\|�NV�����й�#��-�xW ���	*�T��?{R�6����ߝ�09b]��&��_ԧ�R^]5��Ш��z�����+�м4�z�d�XoV��i}?$u�C~�]���&��>�I�i�7�ͮM��'�'�ɝ�"�M}�Ibh�L
��W�f3�k����rW���3(�h*��	�e!2D��(��9��%���$���Vƭ���Rq��pd|rh
Y0��h������C�;!b.�|h
YHg6 u�3��L>$&�R�0�rjh
YH�3� d�a�����
�廈L�t�E����z
�a��������HLM���\8_��i�ȴ5 %mB��>�=�\���\�8׶�L����6�0����[U4ܪ���w:�3Шȇ�v���?^�a��Q]�)���H?�7���A!�@uhEg.L@��VX�Di���TF��i�r6��m������/u�δ 5h+ql��M��D��T��A��(�l��{���t)J�����o=E���i:GJ�nì�eZܢ٣쫭8��KFI�N��G��,W	V~��2���Y*�o1�tj́%d��j���O�Tԟt��!��3PON)q���^���fd4��q&�!hC�x�X��ק���j�댟>Y��P�n��0L)�Qf���^�ůw]%��"�0�蛹f��ε���9������F�J�ܜ@r�^�:j!@M=$qa�"f��g�.T%h*�z�]�cG�=��]��3�����V�#�M=�<�ae��M嘔�:��4�J@O���,e�C�"�!~G���65+�ʼ!3��_�9(�$Ċ:���39b��ec��-d�䦛�������#���P7�[�4'�T�y`��#���A7���=4�7@:D<'�2����B���X�����j�����NM n��Ȋ���..1�ڿ�ѡ֣ٛYJW���p]����.���W��cc�$u4dd2o��L��ˆ�;ԍ���۽�ڧ9A��9�y:DՄHϐ�~�͈{��ܣ�EI"��(P�`�d1R��$����گ���C�z[F=W@����H�K.=�f"�B��q�Y��ݒ��no5�%V8�%�n$�%�;!!p,V!S�D�o��Wu��r��o�8}���,B�ȱ{: �=�i��y�@�����r�"��2�9�DH�e^�+��|Za�"wh;*�r9r���V�y$.�=��9�F����]�    ��ڃ�K��a5ܓ�H{Rx��SC����=)��I*�s޶G��E���Uuy�q����3v�\�a�P�'�+-�B�*sM���y[�.�/���'wp��(��)�x�a4����HӘ��o��z;��X�G��X*�G�cQzŸ�G4�V!<w�}	*Y�tw���̤Z�������w����kH �������P}�8JM�;�Q_�47XȜ��Zu��{�WfQ`R"}�G)���C}S.zX�%2�)*W�x���:X�\�t���BI�aa���L��+�&�G��9�xQT6ș�7J�
:�<hY�ވ�G"B7^n�Y@�3�ֹ+F�R���02:R���i��E7����q�8��J����]�7��v�k�t��*�l��o�D27H�M���\`���/�G��Jo�M;��+,������ѳg�w
$�/0Jzy�\����z���]B�vn� zҀ�@���0=ְN�
'��뢿�m����ԡN~�3�D�����+<*�7Q#�`ѳ-Q�2�j	YH�����}=?پ��܊v=�����S�AS��i��U�	]a�2���6��3j��l�ĭ�G.��{qyq�9��		ݤ�a̜{��.i�$\�{>�zs�����K$u�[�����b���Y���C�Y/=&�)�v�`ԛS�5�t	Z��\����;���|�
��)�%�)�_GC��j����S�r�
�v��E��X���r�c������r�|?��k�W�|���|����jA�;3�@��G0����ⵢҵ��:/��b�g�Y��x��T��{X.ӫ��[�HTԃ7���9f�Hl�!ϓ�y�!�wl,���g�� hg!�n���r��H:�a&�ojb��Re-R8q�hsy�{>�R����=��~vʑ):l���0���&�_9gc(Y�_=�����r'�ٍ�_)��lt(�֖�ͫjN|�(c_�ZaS�9�i&9�b)��4�Yړ�R
��Ӡ�x:�A7�@�x�\���a^;ţ�괾�T� %��Eg?\��ZojT�~F��r���骮.�V��(e.����"��?z�p�H�F`�\��[��)�?�WW�
n�j��=����-eY���bg8{/B��WO@P_^Q��hR�A �V�Y��}�@�H�N���|� ��[������'�����E����ۿ�N�nc�ږ`��vSC��v�4����wQu�"0�ځ��ީ2���`�g�p㧠_����"n�0�@�4;l��"���^:0�5�PX1*h_�������,a�����qu
b|�j�2�<Q���ydd�ևL�-
�B�9�xI�'?�	C �B̦|��M�p,u--��0SC�x�hw��-+Op�av*�X��yDh%�o%r��[�k��3���7Bu!uw*x�!��Q���AP(o�l#etҫ��=2uN⦾D5�Y��)����~���"���/���M'�],���� �0E�]��'
���~��r��u_!�H��o��r�����5'@yͅOj� �?��/%�=#���/C��LK�@��[�x�rN�1q�o|~N+�ї�{�����v��
��������*����@K1����0�_V;}t���:�%���[M����{�@��^�e��6���g׃�7^��j�H�5����n��n�9ǧBۈ*�
�)s��7��H>�6�ȱ�67�0�������B���w����M��S[�Ɋc�\y��S=ӨoS�#,��NU��ə�[J,��&���+,�"/��� ����C��#����P����ʚ6<�8�a�<��k�Ĵ�[�����M�(K��HRA�!O9茍�UK�(Y��nq�}:��tU3j��1^��EPT��.������qU�N�+\o�cUS��<J�!C��
�c�G�\�@.�G{;�#�AE��PJ^��l��RA�}y�1B�f���f��� Up5�4G�o��Qp5h��*���!Ls�B�L��f�_�W��r!� �k���0ďu���EU�	�l��rFl��y=�o�Ț&�I~�<I�����R0�N<Ѡ�Jt�p/g�3Y*mF&�_����v�hZ�\,{7�H��R�V�KM�d<?�
�������Ѧ�;�y�'�1T�)J��\P6�|���<�����Pի��0����,���
�a
m�}���_�!N�(�DP���r!#TZW$)�Sx+F���G�֏NC��N��r.k��`�lX߉��4]}蚊��X��W;؎�4_��"M��������~��W�cU��V�>�m�E=^��rQ�څ�x\�Ε�y\i=���(.-���>���^��C��^����`�5ծ�9#�M�JkS�l�U�t�ͤTW�����2���6�Ha�,�8_�U���n~��M�T����oWKx��N����n�D�ؿ��r�����t� K(�ތ�c0q$6>-^n���ƿ��_'�E,�)�,p�)��B�0�i�������>������x�f�b��E�}딾ռ��<L��J���a��{�M/��9@�p�z�ŝ.����^_���I�@N\������vќk�y4��'4p�(�BcW�hD*�[Q�q�k����E��G��{�xU}#�6;
��E	Zb߻;dGQF���*���=��ݬOr�A2�b|�,�8�U�3�i`K���;A�Ӄ,E���syQ��$6�"9aרK�'u� X����u���hB�HפH�&�^&M-s�.�@,�y��n�����3b���q��ԋ�����*�n��qʷ���𭎟$0	�-U%H�&�4ꖴD�r3���	�׋�9eV�vqZ����7Ii���1P�q��I8�j�Jm�z��D2ퟐ:��-OV���o?���|�U�Y��>�x�]^�B<so��y��%�&b�(���3d�2Ί��'S]�m�鷝�<�u�����b	o�ry��W������"�J[���:��&ϗ�u�9Qp��o�pZ�ofi�i��8��N��]�m���砌�A��S�)��k���������_�����w�K@��߅<�F� ����FG�?%�I�Q����HJX���$e�p�\�bC����dd�$;[�b�I��`�W։a�0�٠+Q2�;��4��k�փ�֍���O��|��I��Rp^���=�_&M�j�ƅ�,k�@�̖<� F�%��4K�ŷ��PHU��&? ]]��Ym��$7�����Y}�v�+q��N�A�vn��%V�)��T^��;ڡ��v>�ëD��6L�*2C�D�Y0����4��k}�Z���NK�N\��������D��} �j���������f�^���P�UW7ڪ����q�y���{I��D.�W4���7%B�'�-ET���J<�VgE!�TX�	ը(d7w��E!}�TT:�Y,�
���\#��g�+;/��c��*e���8�
��p�Ch:)�*��α�8*E�K��H�C����`2Bvܷ�����@#�����~���������|����������?��ǿ)�~�[�>��������ǿ��������W��{Es�����[�����������E����s�>���ZR+i+� {���z0�吨�
3��>�@} $&r�1�K��D��i��Rx��FDp�HLh�����;�m�J�4�>x*-�D8�� ��s&�0�fp8,�K�����R�Y�����M���C���!ye��tT�]��1n���z���2o��4R8�B!�QRH	mO�f")%	W��s��	�)n�=�%��������Kl������ٺ�L�Hs���C+Om�%|�)KX%/QY�Y�k!���������t�.]�zdauE��F-̈́���B�;�� �w�"�t�6q��Og(j���c���w�]76�C�����\�@A�G\�%u?�DN��A2x֘!��	������^���ha�Лt��-��ի�|��
����dC]�.qQ �4����jꎋ�>m�G�~��   Zc���W����Q�"���u߃��I��^|���b��m��k�	��!�?������V��4��kl�����'��k-���d9����m��X]�^Ͷ� Xpgg5�B�6jGR����(D�k�3���v���s�2���a�EK�<��J��.vȶa��k���g�`�6�yxA�����]�%��b?'��	��6=��� ^�'5Q�fx���KH��(o�_cc:r;�K��"�|{�-����jc�@T�WM��.���ʊ�UF�x\�J���x�tpm8�S$Uq���D�2�	��E��5�
,�W\�ia�y�� �]��d�Q1<������k�T�Rr1Ҭl����0qHm�f}��7�S�o�;:� ����Ez��.*SV�lS�� �;/䡠���oR��՛��J�t��F�p.;�X�{�?�
l�_~��d��@�|�o����p�����tNި��k�.���o>�{x��������ˏ]D�mA_��R|!��Z��������߄�~����k���ۏ�����O�?�w�𯋏	v3������.�{�;��o����5����V�x������������wp��?5��]���	U�{��G�'z`���Y����5�X`r�a0_Q_�ݕt\�.LZ�\�������Jh�O�	u"�o�A;���r������s�:}�(��f9]N���PD�f���M��[3���|��?���o��^��߷��0CF��3��A�%�^(�����k�� ���[,�P=p�����u�#�I��c��(5"!�.aC��7�7K�>?��]���#=o#�{X�>u�s?����ƻ��ߟ�r`2V
�����P(���=����J5�v[�,�B�i����X>���+%|�Y�(��g���<�˸<�{M���T����}2�lK��נ��]�����~���L��0E�L���*���M�����U}���F��>���7�T'o� �xK=]���7�.��(�
�؂esZt���b�Xwe��nF32�"/(�|�dp���n��~[���b��݋H���/b�������׋������@+��T�qDo+�W>�o4v��Nۜ�ao����C�i80��������z��30M_�Ȕm,�<Ϣ���aݐ��������~���a��DU�w�*�~�7m��Vs.@u�K�f�A\Y������%���_�/���G�ĊW�j���M����Cj�(Z�a!�P�o5?:����c�ؙ~���e��^.O�5ց����m]�s̄'�<t'����M(O�^7���6�{����ɬ�wu���Sp�|����U���>��r�7�sL(G�P�4�j�D�Y������\�5��½A꼥~��(�m�L��ˋ�7�ͷ�Wa�W��$��)9�`�aR���$[�����Y��B�b[B1[��D_S�O.,��@���fIDN|����?R�Z����U��)�{*�^��P
���$6EH�
�c'N35�<�g���a�l�:ba���qʈ�)*�`�I�����`�n�x�B�>H��
�Iڲ�!�����G�H2U��$��J�`A|ɸp6�����tJ͑�4�7I�L��G�F���u'�;�W�#'������V{E�F���i��zJ��j��İ�檶�+��&��c x3�bk^Jc���Dv��N�D��wrF��OM"�G@&"im�%�E������\`e��"O� ]U,;(p�;��Q&�0ԘZx�٤4R�	�ϙ���'O����0����e=V���\
e��H��e� ����+������/-O�w0�pG*��Y`�:���:�CL;g�́w��$�,h�Zy���{�M\J�$����Jn��|Ǥ��ҿ8&%-z+�Sa5���q%��Є���y����U<�>D�A����W�fպ��T⠤�t���A_"�*�Ka���C��c�xȬJ6�u�\a�.�m>$XɘVyǱ�]�un�O���#]�A:S	ʹ������E�PQ%4f8�#��a*TK5��'/S�����6�y�[J�g���g�=w==�9��
Yj�3�"i��`yeJ������D�Jy�"�Q���9�-�&�E���L�?&}�����3o�l����l~���vn���܂hgś�߅��e��>��?� ځڤ7�0�fi��R��d��I^J�y�^\+8���A	��l��l��wQ�w��K{�6.r�5C=�`!�T7��̐�,�P����B>4����Pd&�yE�~^
yn�6�7�����[��Ȕ��}���^�H� �z	2��XO��+ʙ��s�N�k�v�9y�}'�V�_5Lu��ߝ/Ú!�󳾬�ϗ�E����[�K��P��C�/}��%�G�{�c�{��m?��?���۴�7��=�Ĵ��n�%,<��[IA�;B)v�q+MQ-�����Z���N��r��g��LH	�r�U��zT�-T� vB��'��^�ΰ
(���;)B!i���CzS�-j'�*VY}N�7��4��gŦ��!rO�_bI]kX���ϓ��m�Dy���t�f^1e��#C�4��f���0�攳?�IU,�9$@�zdR�uQ餐y�t��ϋ�0��񴪮0��=�u�s�&Ӫ�[	/�u(��|�ߑS��G_a^&C:м31R��$��>�����?�E��|J�'N�g}鴲�%C��((�ɫ�1���"�� \��CSo�ȁ2�ʾ�'J��>��'�D~R�*���M�o�O�\�f%;�SO�������-�~�{�jB@N	�N�������ȐE�G�C��|��~���j}�S_����,�C�!2��&O�����}��x���.iZXy$�v�*�+�r%�#w9�0��>�h���t�x��!b�3��nH�q�/��Z_��ˑ� ��Ɖ��Id: ;(�H���E��LO�L�2G�e��!j}/�����P���r�^���-�Mw��,�eU�+�ۣ�� kb',-@�S#��0i�s��1L�>wx��~�<�;�����|���̨�m��#�lϘ�>UN(5,l������Ypݑ�ڕ��;��"��'"���c��=$��:R�\cq���*���!�'0��t����܂d8@��<���%,Sq��#��S.��,��")��Z���������0C�u#"+hdh����uW�SV�0�Ӕ`�ȉ�)\�\�i�&�u0�%؍R�(�qdh�8�~�#��jxz9�wSC	�A�Al�z�\k���X�����[WhLh�B��6�<?Ƣ����d1��aM���DF���C���F��`�ԴO��y���g�2��x�=G�6z����_u���S@�-����շX�+��#���gű0�s��,s*��$��\�]ؐ��V	&O�`S<l��q#C�@i^�T$h��j��L��Ra�}uQ�0kg0��H(e%䂐g.E9�e�F�~���L�Ry�2/L<��ͼ0aj���H�mt�� ��۩����I�ca��I��=��59����z2�$�t�F% �r0Y�izj(A��^��V<��`�����'���J��q[���s��R���I�w�'���y�9>`��� 	0�g������_#)��YI�Q�88u���s�BT��Lp`C	l�g�Nѣ�հ���,>Y�/�A<?_��τ�Cs�*Eé��z���`h�ȱp<�Í�Xi ��J?������7�y=R�͚
�e!43#(���Q�'��о,��O���O�HL      �      x�}Z�RI�}.����W�����0`���y)P�T�.�0_��R^JЎ ����Y����;S���g����ܱJ0!?p������R��<ׂ���%]9Q|"|�eBTZW߫�П��?���n�Y����������\N4�X�������%6Qb�]#���j\2k��,��y�j���z���}��u�M�ح�ݺ������+��	W���琴��f�1�;%+!�fn��3��|�}�gt|)&�4�{�D:��5������J	����&��N���EW��Ĺ��x8��&��5:-��$`]4�{�+�g�ߑU�=<"��O��M:5�5�&�7���K���LK;ѦA8�®VW۽U��T����[v��#��|M��-y��	3�P�r����K�*��Od4.Uu;_��n�N�Q:��_]�-��g���rI.��ri*���E:;��������g�b8ES�1�0�P
ZB��)�q�De|>���E�n��e}��O�լ]���Q�i�si���p�P4��Z�;�6�pϷn�i��}���WOp�c�[m��A��,m�$��[g��ِMf�4yMi[�\�p��5�z�x�yv�y㕑"�Ն*@2����H�
)�.# ��?Ϸ]=�ϺNN9!D�Hυ֣p�s8�����:��(���,1�T�<��ަS��oRX ���U�%<�7���i}��ۇv��O��z�kI��g�o�����@&���LI@  L���t~&��v�v��w�����(K|6�3/cn��=>,�Fy.�9�f/�Y�i�|h��t��W���Ǉ��n�s����|N�.m�( �P@g�>�e�� <���CW�=�"��䄉F�Wܕ�&H�*Շ�^VܨdZE�BU׻ٺ���Z|�n6�s�	I�3���nIٷEƅ�n療���e���}���f�{r�ƪn�
�b�)�(Fٚj��>v�ˢ}�!��Su�A�vښ��P�nR��ύ���iã�e��}mmM(X;�q�Y��ܤ�� �ʋS˜����~v��_���Up�"7�p����l�6��k��Ӿ UK�]�|�����K}>z&�W�$_�`DJ�ef� �$$$*�3���A��h�Z����d=�=u�������d�hF��V0���	S�a�mFC"L�O�R�"~��`]���)�2���pF)2-BN�S�U��f�p�,���\�4ҫ������� R��:2JVw��s�^�����E��e9�N��-^1&F��ß=J�澨��|Ϫ��ᵞ��/��#������ '�8����¨F�&��Muw�qzv<��rw?==��?��3ǆZ�h"-2D�n�;����S����ZpRИٔ��I�9᭱�F��C(*��oк�G1ƨ��v��A%S ��FE�T`x��GOi�0�"H��h���`���kML�٭��g� ���RL�~���; *%��8~��G$�&	��_�fE��F!(���rU�*� f��m�J��;�'J�T��L�L>��`��o��RfBГ5Bh���pd"��N2M(��N2Ϋ��_���/w����Y�dV�,��<'�7��0�ù��{��ΓŮ�o���"MF]	鴉�@TQ8a5�����+�2Ip��n�����*�K��({��+|bB� -��S�/�$""�_�Y�J�[}1=58�����i����L����O���U�������n��H��>��w?��Ɠq5�!|�"�G�������J@l� `��@��c8֤�����������Kؓ"g����Z�����t�� ��z1�<5��q��3@�3f� �u���}-��	�E�52�' �R%�
�4��b B!3@���@	v˗��z���m�5pf[��
B���Z.i��Fƨ��QqP���i	�(T���G�fk5�CЎ�� ��Ж�<���G������G踥&�Gq��%��;�h!�ghT� �r��)�ȿ-������V����1�P����� VV�L�. ��.CZ1��8�ڡ���"3���ȯ��v�ϐ����9�Q�-�Q��kf����{<+�a���]Ͳ�e8�*C9꥛d�ZwE�B4�k�>�������,V�舊2��A)�,� �q,e��ᬨ>~���tySO�8�vysQ��l) �aР�N�d9�쮲ԩ�`����]��`".DX������ ���>"�3�t�>u-�a}����)m	;DL��B9��Ⱦ��<hͽ%�ɠ�" C�����yK�sm������ �葎��`�f2"s�N
�T���v9�m�B�a�p����V�y��(鋾���GYQ�nܔh���� zH�@�C-�J���&R9���nCӿO�nS
{ZKOS�i +�@Nb��n-M 30�h���f��b���� �C[4�#�M2�Ѹ�J��)��MbY[]~��/����ЏP�Dc[�L1�3!�-��+�`2�c4Q�j�=�+Ds��CJN��>b&�����Fsaʜ�"�$ܰ	��gD�L[}�;��2�&EW���AZ�G�b���)����'M��"%�*�ƾc�es�)��\�5BY��1�纛Q���,(���%�␊���p#�c'��D�JB��{X�5�"OH";�rW���S�b)5"K�<n���[=��>d��	;��� ¨D��e�+��XGᄠ��@����]b�4+�C�Tp9�סz�!5��w� U�f�� ��/w/O�ӫ?Nsǐ^&{3�P���D��1y�w����9Ad(+cs�L�,p��
5QE��n/��}�f���ݶP�_M^Ry �:t��"��'�����������"��&�P�F�?�Ә�@Pe���M� !�o�5�����糈=鐖n�h�P��gxt���Po�$D`�O�Ο��hQPb��ʱ��{��x v@��)S���r�@&^�Kx&ׅ�9�CY{)SC��ۀ����G�t_.��:A��r��U�2Q-��h �]���~"p�������)�M�E��M0MM��.�#%�'�/=����mW�-Fn"�'��nܟ�}����F@0�8t����Ņ n��4i�z������0l�c�gV{�OQ�0��QH�,=��K0w��Y������E���>��1��"L,�˨��D"����O�z`�|��0(�E��Uh�9��dbᲀ�F7$�:�Pش��$(�v��|��-ߝ{pjȆ�4k��p�n��=]�h�����}���9J�aئ��i��U�ސyͩ@�{z�%�Y�k�7v�D�4�HH�GK�%zct�Xr,�-d�&X�'�?�W��z6�O&a.\���*��kthaa	�M�W}H�ǽ٘�q�u���$"F2גQK�=!\5o�2�<�<�n�#��w��1~n�L�I��x����p��~��H���P�'����CN�6q���� >����,����cFwg�pM1��.}��D���⏗���+0,Z�ǥ� ��Ǻ��������.e��C��-h�
N� �Oi<2�嫫a�K�wW4̃� T�C.�O����܎/	�IPi��\!�� ���_��J������Ϻ�Ϯ�ϟ��guKZ߅&�Q�j��B�@0{G����"���?�����[(���F�.�F�r�0��Z�=�oE��R��Xz�Oݺ��
(��9B�}�H�-� ��<w�ƙ�g�D"������_������hB;E�O�A���2Տ�����L����`󈚒�C���]���Y�븄��N;L�,�a$jEHt�F����td{��x�}n.�F���p�$�+g�aIrKB ����f鉍�!�U�]�����H,�6� A<�Hp�
�F�sX�uOG�' �I@��x�XAX�gR��D�����|t!�0D�9{�\��j��ۧ�1��pG^!��f���?�F2mrW�Qs�KEW��z�.���c��k�r��0ƍ�Q����1�X�3ɾ���`�'���6��%� w  ���5�r�t"�e=���'�58̙@�f.�o�Y�A�*�����wT~���J�;�9�?̝�l����r�j���d9� Y�o��Z��?��B���P��C���І9Q���(�4*}��U����kA}�,���@ʱq7	m=���FZ�e��4=�[C���A�RѨ��a�=^aT��H��)6H�,�m��a�'&�VtY�/��Gh�����3���0��IF�΁�>���j�~mgm�	�%$`H���Mmwм��y�=�Y��-,�u1��
z�d-3��	ZYQ�7�n����cIݠ�����[�~�!'�`�.��ĝ�YP�%XLԈ��N��n7ԝ�N⪆{��芆�����=��-^���]�1i9���qE��֭:�
��e��Vh���<����[����,L2Ks�\Û��TȤ,�2�������a��~5��ܧP�xjn]����>N�Z� ��5	��ǒl�+Xu�nW���z�h*2Kz����x�B��BqT5��&B0��r,������:�en;*j;h��<�0C5����Q�a�#:�~�5zT)A%"�h$�s�Y\<*F�4�����_��������I      �      x��ݒ��u.x��c�얫@l��n��gS�dVSmyz.P��J�2�T"�����eI���#ΉЌc���9
�ǡ[�%�o�$g}k�ld��I�R�-Yݝ@"7����ַT䍞��Y�4e]����\.���yZ��QS�_��b��v�
缮�N�q6��۵�����J;��u�q���}���'�f]_�����v�)ֳŕs�>�����"o6r���{����H�H��t��(�ѽ�n�~t�..��{���/8�/s�������'atenF����0=yz�$��}�{�G���Y�l����*w��yR�7�i^N�o:�2��P~2�G*E��a�?��؏��`���8�����Xy��n^���-_`�i:��S��"��w�}Yn�ζqr�����:4�W�4�r�3�G��yCz�|	k��X_9�ǫb]դ���l'�z�>���AE��{����#Y��ce�T���3Yl��3'����h[�O��uY]4��u��7��V��}�ν�n�Ւ~á�����ɺX�qSn���G>.�r�]�K.��8�b�d{������ m\���;)֛rVN��W�k�h�aZ��d�G�,�1�1�_@�Xe�������,M��K�x�I�*��D���Ŋ�Э	���m.�i����ni��MQU4�4�/�M��,ˏi-��#����N�u</��X7zF65</�����!/s��n�SL
=�M�)�Oj�E�:֜�@vu@��L	-�N�'�w)7��0K��$�^�(�J�0��`��`��rrqVLo�MÂ��9-�$���j:lo�v�FZ��G�弤�5��geEߓ�i�&s��F^���A�FSZV��Vv�mb�EN}�'c�)�q�7$��K|�ld�"_�Lѩ�K���&/��˺r����-�d��m�[�-��Y=�3Y�/���9/6�s�s6/�3��r�O��v�hH�n���Yn�ɂ~�\��	�9��.�+�yQ�����^��p�����F���r|u��n�� |,���)V��K���T���,��vj>���L��=�}R*�Fq:��[O�|����(�/���D��f>����<G%'axfn�i⏕O�&��/ڟ��@4��yΣ{΍�'�sE���v�=cхt6�!��M
�W��D�L6$!iGl�e�����n+>�#I��	�9-��� �JG�X;���Y����tH@��!�A��qR���_�Ba�b���M��9�rV�
]�S��cR33����!�y7��ĩ�&;ɠG�JH)����BGe'*���^��X�
 ��j1I�0�xt�\o�POh�^9o;O�ڙ��~�z}�W�'4��i�ִ�I�.����;�o�W睿��<uj�V��s]O&9$!��\;g�׵9��/q�Y�@}<ȗXv���,�M^V�2�cT=�n����w���?M�͜��7�r��fY7�9���N�\-����i�@В����ק�nUU�e9Ҫ>�Y�畵8$.�8���$����''*v� �vi<�Qd�x'A�*�$8U4zB�II�?qN?����{���qw6�������-"�=��^m��e���2���m��E\�0ԏ��vg�Ľ�=\�a�Ԥ��q'$&��<�x�NH�DG��|��_�c*!�5�G$F~�e��g	`*r�(�Ұ��$V�O����x�Ӗ�F�����s����Z�W���N�l��6E��JR*'�u���^]ח,�٪җ,�D������!��;�O����jHo��I��nEW]�O�I�٥al�P�&G��X�EaL
>9��I��#U�X����v�a~`��;rf�$6��H5�+6%^�V���l�$�5fnJϠ3#	
���CR�s�)֓�'�\O����h=�خpr�-HsV4�K�8������niB�.-��H��-R��F�����@�ʴ�5�ɷ�F�� 7�]��4UӜf�gs�铜D=lIy���q\[��k��Z�+\d*_�7�ѯ����H����/�N-dV�!E���7�e�>��z�Q�eI��K>�׈�m&_!�~�z���kD�j7�O���
�� HƊN��Ƿ���lN�cMҮ&I)�]����1��)�t;���<��F��,oX�Qz\�8���L��p.���j߆,*hR�<�l���2�j09�bVhm��ِ�	��'�#��*`��aɝYN�6���<��"��mm�Pt��8��#l���"o$cE��.��I���b�y�(NFa��(�_���x�6\?C/���67�2���>�]�~�r�e���F�eih��$p�Џ�xK�����
�a@{�L}2��������[�W�Ho �Z?��횖�M�A���6-g�����u��V�u����4�QL�>Nw��8#<BrU|ߍ���U{�b��$�K*�i�*IGOH�nĜ����;��&��?i"h �\�s%�.p�k�=��1�c��dוb�(�R�F�j�=OE]x��$O�d��Y�d�Ž!F΍��Ŧ�+�7;c�N-�sw�t���b}�&v1�|V�E��,�7I�S��v��qN��&?[�GZb�����MM�o��;8�ߥ`o?�s�|x2=*�6b���NH0�I3&0�.�,ۄ�b_
ȇ!O�M��OI�E)���o������<��p�_�6�<�o}�i�mF=]��_�IA_!�h1��Ui�eMvV�lWxGˮH��M��r��������sg�np���*mcl��ϑ���?�,��4`�叴��?C��?�#l���]�"����+��~�;Ga�����O��>&�N�渇��;��Yj�䈎����K,�EaԻ},OG�R�р%g���6�ĞG�2�V>$��Y�}�Ӳ��T������&M��O_���_���o^���������O_���OvC�x��a���)�}�D�|�q=���cr�Ӂ�dȦA1��nƩڑ�0�#���WL�>��Os2F6�R}�sQ�x����(���j��v����36-�[�XVE^�d��|�������"�n&��l,\"˙މ$D��p��"N�Ao�[�My��iӆ�r	�6��(�n�]�j��v{f�^EkX��6�� ��n{*�<F��t:����]�,�K}<����4�E�;Mm�ۇ��\�aE������y���@�36��5-(vC�"�;/t�R(��(�^MR�^��-����GhC�a@�Hp)>	8�A�Vч�d��_Mb������iO���>���4|���I꾒7���`�4�I�Ѯ�e�������S�K[��q����y�����nG�Gr[F24���8��$JHnq�?������:I���9��Um����!;����y�u�����b; Y����y��\Wd2lIKަw�r��>~�=c��<�%YkǾ
���K���Q-��O�[��ر��[Nz�&tVK�ӷ�J	�h����-���B�Z[��<i02,}l���b�N�a$�4ȢN��.����$|���wae!�4��e;���/��F�'���o�Hy�����n�zKN��"ǻ��X?Ϲ��J�.7����|=�_�I�>A"?�s�������s�r��f�����X�6����%�3�����+���;��(#iG�L4f�铈Ġ�Q�?�Q���z����S23I��r���[����tF����c糿��������@���b�!o �Þ��#<K�f�
�*����#F�L�BԆ�t�d��{,�� ������|�#}�{�g���5F���s;�5�BS��ķpm-�R�œ�s��|K?��kr�n�Q���w�������hw�fX���GV��,�r���~LM���� �-m��&���b���#�z�uJ��.�?̑ߒO�as�͌��<���*�M��t�(�<��-�)��b�"޵Ix���9��5�¤͟�U��|Oɩ����#8d��e����sO~o����o��#35�������ܟ�ܯx���t���n��x�K.�w���$�]rd2��d�x �V#:�vR�l�_�XK�Z�ܲn6VD�    2�ntQ�ee2�O��� �q�s:�|�������Y��+�J/ߌ8��<��(���FQ2���'��tG¹���O��0Ͳ(�iP�[զ<�C�c�x�c�)�֖�N5U�&.�A��d�&�n
�-�}k��th�h�����E��*x!.�Z��pɥ
 G"��u0&���ɦ^m��e�@@;7�l+��&�p-��q��Ⲅ؛9��''�$@�жI�`6sķ!Av,���������|�`�d~x�O�9I�{dϋ�b�:��b���S~<r��D|��y�B��ؑ�<0�)�+�M�t
��)�����^�]��'���0bHt��Vo �䩳g��n���3'X��f�@%�>T�K�����#�a�����ѝu�4���{";���ː��p���[�����I��
��-��@ ŴS�@��4�S�  &xA�Y����hњ���%[s���� ܯ ��I�+�!4%��S�'����G�ʍ����q�Jݴ��|Nv"m&t��XI>\F�DeC*�u����E����(�ׂ�����9��c�_��h��f'��5�e���v�ܘAN-���]��|�	�!���a&bD �$K�!��A�j����Eo΂��jY�ot��F"ڿ'+��6�1a�8IfY�+<L[��@���q�k�G+ 84�`�i�L�բ�c_�t�5�̑�gm
|��́�[�Hp
������i�m jl���k����N��ퟦ��O�����gH�9�HHR�0iW�.��S�L��u�b��]�N�_��wެ����(��� 5��'�TQ��.R8�GI��=���� �,՘BAm���emU���D��S��k��u�N�M��L�3%�XO��*���E�=��!A6��#�p��[V����X�3찇&�^&��E�hQ�o�G�m`�����vݛ@�	T�3
��9�s�	������Q�G"�ⱢGDFp�|�a�X�ާ���2���AS0`��$[b3F�½Y��f��
8�bY#����s����7%O��@��}�ѓw��B6�>�6�+8�� �1=��0��0H3B�ȏ����/"׋�f��x��fE}�z�!W̬]x_$Q�l��+��o�����fN�ٴ ���KV(�A�aVO$;O��!��w�4�7&��O�J��5Z����c�0̈Z�!~Ӈ�ȽlȂ��L���s��u/[Ϯ&�z6E���oE�'�� s3���!��d��'��n���ڵ���!�y5됍�,�������ړ�둇��ʀ���Ӵҳ��	g�W��
���W+�+hg��L��d�W�hl�s��C������Kz4x�5dǤ0����$��?a��l3��5����:�hV`����l$�ށ-���v�F����<t�e2�Z��!��/q}��-~ǈeN��%?Q�X����?e4p�����?r�o�HB���bd߫�SҮȂ���ɫ�hpH1��C�:�F�>I?/�b?�G��[�Кz*��d�Ҧ"�>/*h�.&m
p������ ������#]>�k�ᇿl��>�|��V�mP���2�
^6�:�s^0BZ�A�{��]U��F����iFŔm�	Gg^/��ڲ�?��؋#�q`�s-(Vn���3��b�Fƚ��%��cxR+���+��{�fΟ�x_箼O���5��M�g8J�Ʊ�1W��'���~�_���Bf�ͷ. :�
��M3�D�J4�>x�Q��D(�,ɔJ����m"�3�8ȵ,k��`���(��Դ���@������U���XGM��0e�A3�� �s��;/(��,�D�����)B�� ��)�bÀu}�U=�����^I��2�i�wB^�w�8P!r� 웆H���f��H�d���/^��姯~��Ϋ�����/��y�)}�>E4?�H�����,�+Z�[��<_�W�\_&�,/׵�������g̔�[�  �t��V&�*I�o:���5�IINnC�u�m��!��j�� 4�4���m/&�.�Q�'�'uM2��{˦�6:�,l���Fh��Fv�Gl�I����� ��B7��.�k.��#�|r��1|�o�I=^�}����pE���f��=ʔ.��b�E�K|]�B: �� n�O14)���B/
�Jg�Y��H�N�B*�tvB�ě
v�:X8t��r���:+z!D�^N�, Y8�i�#88���f�%Y��[Ĺ�������<��x�B6xC���U�;w��@*�A��Q:�Ii6s` ��-����d��M���u{y"�<d9�j &�0c(�6:�ij�2��EI�}��O�9��>nF �r֬�b#�g{`��E� �k#d�H�]�"2�.yn����d���W5���!�^�kNh-$�K9�G�6I�q��G�S���Z���F�Y&���������$���~��y�uک�/�H	��i>>ݷ���_f���,���/��)Y(4n��o��e$��A?�������RsTK���-�P8C�u}�o�V8zZ5kR�Pȥ�؍��2��y����n�ϲp�g�̔&� Jn��N�wj���z�<���E��2�4*t�9=�o ��(�N��L�r( [Z�p�w.1�9���#9�:��IL<�Ly�g����>�l�˝��̚�^or�+?�ؕ�/Hg_���u�۟�_�����������m#5D��5�L*n� � ��!&q��	�$��T!�\-���.�J�������v�B>�ZJvq�����b��O� h¤��iM�#<�y���m�	b��iB\��>�v��@�N��1���*����k&������;l��J��[�o
8	�z���^b�"	�	�k���O9w�<���-5ĝ�u�m�mV$��^f�i���-V%��q>�!3CT����K/f��G"N�������(�Y��D<��r�$��dD�h����c�J�	Q(��YkC�)��kF^�HKsQ�6g��%��[���Vs��\Ȳ�v��_�U�Z�:Z0� ?�_�%������D>�9�4�KQ,U�Y/������q���?��֓���
����r�[Womh�#�:�l,��?+��v^T6Kkr���c�.;����Y�-��P��F�=�֢И���!Œ+�� %8��˃�CN��g�p�Ϳ��c��q_�I�Ŀ�Sؼ���5��4��R�����H��i�'�M�A��s����ѐB���}@�EH��J��t�@�l��"������(�p�tĹ0��;�r����t��Y?~��Gр2�^9j#h�/�Zn;d�/�rٖ�Au���9H����p����ۚ,SJ����ڇ��������b�����Q��~kt�eg�` ;٭�'���X��N}ߕg��Iݔ�ʭe82�
.xi�\g�"Q�寀�A��,H-�UU#���UՁ��@���i�|�|�4�����x/o�b_��I��;@�- \��}���o�Lo]�f�
�C��3�������Z#A*���R��\)�n�d�~��jK�f���Ǣ�@�pX�.�H%x�u��A�h�}Ɠ�@[�l�&���f��b	P7�"�Kwm��Z_Eq�����̆{h���̬z]f6 {9X^WYdgfɕ�h 䮧�[��|�;׀�{�lK"}����)P8 99y�8t�t����\e��v.��4sŐ���g߱u�����������p|�.�i�����$�Nc+g��z�
NK�"�׏F�.״�K��s�q1�]'�,��4!~m���e��jվ����� ?-H��gg�s��V�S������6�A���ȋ�I�k'��"���bH"~Ċ�ȑU})��"�(����ͭ<�NR);�T
yÆi{��=0
=N�HcT�ݢ%͑3»X�)�n�}#�����x�J���JE\B�W}��q�W�&vL�C8<�C8�_    ���&���yN�
����8D�1�0����`R$��8R��������su��!�6��l�T�2�i����K*?�&�Ţ�KTu�F��+$� ݻ�ε�dY�%#���r"A���I���4ӥ�7�F�VU���_~��7�&v�m�H���}��vS7\���.1H��a&mz� ������;��tt�k>�,�O�Β������.�����6l��5l��Y-�#�d��/fy"i�6Bș=d�V�eo�M��V6�ы�5���+2��}�0^������+i�����xt������L<ܼ�����uu�;cb�_�@�%�@Hy�A��{Ֆ�P$�<����y�E�j��%ND:��%����i�����A�;G�"I�������O�|M>�zXQ6�h1kRLP�xw���n������1,��N�A�?�B�����cF1:�ut�6Ol=Z�Ư�Jzr�1���l�J٫"gq6R�y�B&�1� �M 3�t1hs8��O 'Xr!��&w�W��\~���Pp#��яf�U^��w;&j���\��>�@z���FМ�SoY��ܾ�[�+��g�[�۲����-D������`��(V&�'�s�|Dҫ*�$�r���%�Ą�d���+���߮��Z�x�t��c��y�`�s��.�c(�vĤ g���Ey��Ɇ
�
�? ��0B����
��{m������+C5R�X��&�Ky�GvT���-V?>h�ᡎ��E�`ٙbDG{ǍD��e��7Ձ̻���w�[9���	GP�a�֠="��H�RC*��H�gb����8$}C$@R.x�G{�ɮH��3<��G���!��n�ĊI�@�53��Γ�$�^�/yϊ��`�+X���#����Y�[m<a��H�aQ.�~�_(�D���'(��7��$P��"�9C�,Rs NF϶�����W���#Cm(��\tW�b�l���V\��&d-'ɮr�~%�0�!0���)�\U��0	д��dn*�@uww��7z�&�k�ڎ���t ������X���]�Je��¾S~�'���vS�`�"�}�^7�i�(�{�ϭN6��C�� zx0�0Z%*��K\zO
 ``��^y�w����"�p�����Gogs�>c�R��6gpp�2a��I��9A�^��a8�J��v=c>6�h%�E:�-�)� D�*+��F�>'��i�1s.Z�L���%���SGA*v[.>o6H7������fÑaѓ�H1�5���|�Y��)��k��%tuLn����i}��Լn=�Q3��H!�U!o/�Z��gE��/���~�<xC�G"$�	o�W����f��p�EB4@i�L�>Ch:�UjS�&ԓ�I�qF�"�$/�w�p���7��J~���,Y��Yd@G��CYv�"ޫ�e>e�6�*,�%Y����$��z[U��y��G	���N%�/��uͥy��;��d|l�&�m�8ɪ_!L�H�J�����b�O���b6+�PnzU�D`O��[���� ��>8��m�e`�Iv�3�؟I�c�Cd��Y����.��u^ڽ��])cF'z#�E�Aε��&-����Y8�)���x03�x�QJ�ű�5�ּ��d��Ϊ�K�`����{�o<����ϸ�S��,Q�L�5v���};e��бF6*x�[9®�1s��q8 J���~���EŮJU�❥��s�$ T��=�	��UZq�^Y�
w� m�l��#���A�K�����9�L{#�o9�<_T���� Vv�#��<L:��0�����n(7=��PМ~F;}��!
DC>yWi�|�E,%t4*@�V��c��uܫ֞K���0�t~i^�J�Y/��|�:V_V_s�*��}.�r�U<T�ki��F8��I��\.Ǆ��-�Ҹoq��B}5h.��X��X0wq�Rv0�
���Y�1��~�e�ZY2&T��X����Z�'���]���d7�V{E�q�t'�ɦ-vI'�u�ń����
8n5�(C:�+1�9L+3NjS�e�Jv�&�w�D������;�R�^	�*���51my�#nqd!�a�h��պ�|���3?��$X���`hqty�	�WC�l
����n��z�P��s��JFk=#�v�v0f��D���Y~��c|||�ٵ�6dG$��l,0���</� ��AG�)h�P�!��{Q���wX,?�:C���K�8�ҧ�:�>+�4/�כ=�>.'e�x��v�2"�?۽��E��٬Ɖ1WR��p��������R��u���=.�f#�!.�w�� P�ox ��I�l(YC�� &���p"�7��gBl���S.��p3�gj۵�������ڌ
��p��ț��B�Q�#�?hn�m��_Xp7�{d�Ыy�� [
ݬ"��;--�<��l�N-$�S�����MC�ٕX�à����$l4�Y��v�,����/��Vc���lfl�#�*j+����|Y.�5�lQR`�+$V��h>��-6@_	��S�7;��
����,�}(S�ZH�]!y��z�
�݄�M��ܧC{i�_[v��fW|�xך>��O[���U�`#�v�j�0a���0���'[��EI�oz�-KS��p2KWG����oZc[����*��;顖;4��@�)j��H��(�Ơ���t�~`W�&<�	��J�z��ڰ��A��K�d����QἋz�j0�^=X�H
#�0}^j��p��?dG��$�8Hz1�=�Ź�F"w�L�?��2�Q]�_}�%�-g�t��. Q$�|?�vM�J_�ً�>22�42��lq�_i�8�YU�6�sV��MM�B:U�Ee���J��<<D.�7p�f�E��db\7�@��G������7�n�Y��/�IdM*z2ϗ+H;|������� �M[.Ύ��������=�;bA�(t��:� u�52��j=^�v�����R�� �߃�-I���G�y����ӈ�J�jG��P��91u�¯����{�U�n�ENǅ����}���/�nfꐛ)�d�5c�%���ۿ4l掞�8 ��%6`U�Ж��7YUOG�b����1ؕw8 �a��B/�P��Cr�3/��.���n�V?V��:ne7�0!k6��U���-���t:+6��ѿ�U��?۞c���)�k����L����RJ�^���%�W$RZ�p�%�w����OJ��̇P(A�n��紷��6=���h	z�13�T�=ɘ�_���(��d,;w>�\#�C���!\_�+ �Y�O�\~��q��V�T5#�����Hid��}�+���޾���������E��8�F?���,-ؠ����J3V4X����`#�J�LH����I����T~�S|=z�wPg=���t)�b��0j�oUIO�lֿ��U�$�� ��B/�f�H�3S�(��{;��|�b7��~X�v˳��tR�F_�tk=K]`�@�������䭇����l �K)TQ@G�v�U�rd��L���}�8��T�M��۳o�V�k������1���D�s���]�B�%���u6V���c����K	� jldu^�_S�v���˛�l2��v�$t����]�:d��j𣘻F){Z{E)�j�0�AvMs.��j�m:}H�I�W\t~�dl�ȅڤ�ܮ�|D��ߗ0J�
q��'�����v����-�����^��PA��L�M1'��T �a�����iY��ۈax��Msvɸ���l�X����}֕����@�ޓy�A0i5���_�I&�P$:I�����g>Z8�)��=��Xŵ��"��#%xG`u�ɨ��K��'I �;��˒q�δvU�wX%�]��}�f�.�#d*�� -�?zZ/h�>�]V	ho �8��gܨ�P�
����_�A��.�A��g�<f_��?,�1��`��ܘ�H|�x(��X?�A�[���2�L����5MB?ޕ��c��c�c�����Iq&cvG    2f���N4����m2)$��4R���:��i�1���8�V�}�bc���c[� Rױu���謐$RY�2`ϫ:�H�3���Hs;�/C��n�eھ�ǡ" ��t�t��;�=���y!()����ܷq��d��k�Խ8ud/M�ۥ�'��3IzT���9�ӅF8p<�o�Fmd�V��u��ُ�:����<�_�Bi:r�0*Iؐ�4٥�ŪOX��Ż�u���H0F�Z�E��
'E�7�����:� &�]B�,ْա�F���oR��F�@'����kcD6�=���$}c҆�`��S��hA*?�X{ʠS�y�%���R�\v����l�R � �	�0��2O42&�S~�̨n�p.���0S��ȥ�,���.��i�Β:�AЁ����Ʌ��q`JGL��'U�X\b�۟ZȊ>�5���G"p�,Ӑ�)ZAuL	�"0pF���l���V��~�<�_�->�;��)o�����k�l�'~��nD�M�4b�e"M� _�y�����Ot'춁
���.L��F���}XQG����ɥ��8�U�a
8��4Gѐ�~$�a_��L�\ڤ�7a���s���#!gT����WL�S�������־�c�����B�(xniH�s���e��,����1ʅNp/����`���W��ǯ~���W?q^���߿���������W?8�O�v��/_�����߼�n���߾�98��[Ǫ��/����C�����1�����k��?�����I_������g~~�����`~t���3��O_�_�#��4���W)1�	����������{�Ky�?�����c��F�k�s<���("p�(�c�6Q[��$n���htS]neQB��ѳ|F��
R�;�]+��snr6��$��Px�|�0�tLU8��2���,Lv���Ѫ&�� �2	����mRi.Ww�7(U�X�kԄ�L��hV��j��1�(hOS.cx?w�y~F�=I�Ԗh~ز�^�:�nE��&7nr�)\mI�O��Cs2��z}Q��c�T�ۻ�Pb��}�E�ɀo���Ƶos�E��&(���X]z�=�l�����J�!�ٷ;�s�)G���:w���ĉ��"�y�;0�h�p�x�!���7�Q���
���1�-����ъ�*%��hU�����׃Y�>z�Z����y��.��)��`��2�߀cu􆃯пf%pQk���LZ��0=��@*Q��ڐ�|��l�u��h� 3��?��.�&梻������@�tMp��p�!G�z�#B�']E� ٭�N����؀�)��A:�BϧE���]�X+st�Ӕ���{�9 ��F�Q���n�o4|�����7���
D(��P-��s}]ң�.�m���26(��a
1�	���؀�,!�ɖy&�i�É�=M��'%ޡ���)MC2��l��J�Q�x�ect/���͟��&�����N���5����B����p��Ɓ�Fw��
�~ܻ����{�{��_�u�X^$[����/�a����I�('W'�mH�}�yG�.j��ːn8l8�����/�V]�1�'	�,��v+l��Jl{�d��u~ fѿ����W?*��2Pk���j[�m�m���[&U	}GV�B��8<:^�6����t��@H�6��#M��đ�En0]I���C1mL��C1E?a��,PA��J�t�U<VIk�w>�JI�-�t��ЙK�w�C��M�/y)x����%�F�[�^��Cq՚�猯��EO�E�\|�-{��0���v#���L�J�b9��C�FbÆ*E{��M����-�V��q#��7������t��a�a-I5?$��J����ԣZo3�Q'2F*�I��b���ݬ����˓A�c2����F?�N�m�?�t.��wT"{����
��IS]Im�8fB&� '8J�1�ֻ��g�͂@�@[c*���VKL�9�3f~�D@Ǒ~f�uvP�?:�2�sƿ;.�Й������)m�)(N�J����Kk|���1�DSj	�96m��\��&�?/W��mDHALlG�"�6QҊ�6��lXQ�ŊlD���rn����ř�����k�䚂?�\��48�k
b�3�0��rM؃B�e	�-��.�o
��c��*����e��kM7���%�cn����fa`{�$Pq��Q4N��'���̶���TL�ZС�u�:�<~��ǡ�z� T& ���cabW��3`�t�A�بA��]nH��7�`Īu�]��q�So�ԛCo�Ia�;��
��U*JQ����8�3:���� ��=�1"A�Ҙ���Fi�p{�_��¬�s�zU�\Ҙ[���Dti�@i����n��8]"���"3+'�:ߪDFڙM�hg*H�o;�����m�� �M��6ctt��bxkY}O8��(ޥ��@:�8Kt0zB��Im�����	p7w�����7w��6��λ��a�W�/�v�el�M���30��agZ�Gw��K�L����
�S!S�W`-���<�G�:JҠ�Xk[(l�1�w�zJ�vyх��N+��~�L�Y��ZǺ&b閠:�f��Z�U7�d���$;��\�L�M��KO�u��Jص)��%agNFE���z��E^l[��z�[�x��E�%#�Q��*��k�^���~p�!���:�-|c[nl��-��m
���L 
C��|D�v�����N?�)rjt�$��k��4yo��ذ9��p`�c���έ��F��~A*��]1���VӯϢ��*2�y��~�%\�l
ș�O#�;4>�2�H�I���hv�y��&�i��#�����q�*���g��V�!��*w00�3@�b���yo�y�?�>��̍ ��rWJW�D`��2�
�d7.8`���q��O��������':Q��O��̋�Q�آ����%[>Uky�C�)��n����>H����_}�f�_ᑾ�#�y⑜k����F��lHy	1l��Q�)��cp��=*�ǀ��ΧK��Y��8���_^��I#|���}�+���ڰ���H���9�H.��@5����R��(�}��D�9G�c��N�n������k���7P5|ݨ����/�3:���^`{�(UΫd�b�n*ϳ{>9z�"~�e���-R�8��I�/�֛qZ��ң��3MW5;w�q��V���O�A�-��~ ?'M���"_�\a���4��1����z\�sտ�t�+ISyz��g�nk^��n~�g���<(�Aw{&��ˏ�sK�H�ʿ�s�nx=���2�Sx��C�{�2Q��s�
���~} Q�">#,37N�؋v���.�'�g�8�/3�ڃA�tD��� #~4CQ�����)¶.�"oAf1��Sn��v_|*�vV:�!�:d��a>�AP��\��I�$��*��1� ��q��H,g����!��}E2���o�s#t���r�6�.)]��ݿz�9R���ٺ>�E�ԡ�h�+)|�T��[�e�Eڔ�NO��֏Q���z�����Ct��{=R^YQ涻b��'������s�p;oh-y�t�]�Y�s@n�(g�|��j{�=� �a|m�VADLZN�$A�~�`A�����o!<�� �~� Ҷ��� ���ė�"8���J��Ԁ� �x��,�P����d�YN'���Ư���FZ�4<�V����a�}~X�
<�^�к�jd�Ot̲^_�����5��ڧ�m�7S��l�@�j�|�1h�yȇ����k����\�3$��ʄE[����7D�r�Go����vh�E��,�AԲ����#ګkߓ�%t���*-��;vC��6�H��4�=�'�{�A����8�ݩ�g��=C۞�6Ej+u-���2�WV׽H�B�pm���1X���x�vfŪ�������
��{��&�N�϶�c�ٰDLID�z���/vk�P�@5��L���q� Q��S��q�XwWJ����    f�\G�AѬ��CG���R�K�u��#�&!�����;AEfhZZ��:�p�9�)�^:���h[�S��PiS�c3?|�����9�Z��*�^'s�}�M�l
liV�P�I4f2e]_�A�\�������fW����GSI�dٮ��N�O��>�#2�ʋ���q�L�ȿ����H��@T��"A�`�ND�|��Ik���4ډ�!�ƒ �n�c��-|B���Y�}��kt��-�G��i:���]�DH���Bz�p�4���\/	�],V���>�;`��s�����|\U�Ͳ��8��F��"��SR���,N�1�A� 2�oY}�x�e�X�����3@c3Ė-0��4�}t��<�Rq(�u�� ��[[�_ڊ<[��s�T��B��D&;�$3Sm	't�j����9\�zY�tg�c�-`Lm���4O��ǨFy^u�(_��y�_�b�#�F>ɵ�|"��n=�d_y{�2�1Gq����ܨ~\�ޥ���~��>��d�Ƈ"�%��a��f�s���|�Փڎ[Z����-d�/��3б��A��f��ݟ̺��$Ž�.lx�%&�0hۚT$�ҥ��R0\ω�H��Q�=�\�m'�p-	3�0�w�� 唏���?��ikX�t�xc
~�Ƨ�6f5�.͓iO`83��7􃏜Pc�gD\�T�l��1?�v9�Mk��[dZ�� m��ֈ̍�ݠ����F'�p3}�rM�&.tG3vT��$�������6��������X���������֬������i�����i;_�E�*�]2���㒕t�s���������p��h�f���	�K�0̒��I�SO�r �!���ci������o�"��=���{�npy.j��� xp���M@J��Kj�R����-u����BmdFI�.57�b2�i&c3U7n!J��gL>��ό&<�Ý�eRaP{�q�n���M�����}�U���y�y���ˎ[����v{`	��9�;�E�E(D05��4�����$�@K�)΄}� �����[��{���yᘜ��ʤ3������p����Gx ��ynJ���1�KI���w�T�q0�f�����y`�
��8no ��@"@+�ZHI�\/\�Q�p-6G�I���S+���8��x ����aH�)���a���DA�yf6?��z�
�xѼ3N�iw�d�b����_�;e����W����r��`'��6>�������4��.�%�>�K��O�a���hJ��p�_y2��d��������X�iϓQ@h���9��ct�ޅƶ�0�-������
f����	̶_E���iD����H��(�i�@��u]y*K�1�(&��U������ф��	�9�
���������`G�hc׏rJH�?.����p_���X�v���A�F�0���1&H5�^D�=���ܸ]_����3z�W��?>$�?��C�/h��J�GjL����r��|��7���>�c��r�4<..���'*
���c%� ���P$6���o��f���z�fi<m:���� c�-�ڪ��ڪ�Hx/�2y*j�&�����>�)�P��-�;��1w�x�jéC���6�p�hC��D
Aav�-��m[�I̭"-�f+�ȅ�=�,��G�X+��V���1]��cD�Ŕ1��1���i4X�i�+X���q�Fs��5��E�.�
�
���z�"d��	f�Àb�/|?��tgɐ��$�d63ϸ1&�a��0,X�V��G����'�a������
m�%4�����ѹ������G�o�eٻx�:oK``#A��a`�Z0��p)����1� ��KC7���S����_w`���v�"�$uLI��dzb���]�^���%�*b7��8��7�@0{��VN{�LR.��N�f��[�#m�T���RI���*fS�f���T4��#��Z@ѿhSo�_i��V+C���g��E�;v�f��(�|n�:L. �Z�$�,����}��\&W�4u�~x����h�qת1W{��dpk��U@�x&�@�u/�U~���iP�l��I<��	��:G�?�Ց�q����+r�&��� :�<���b�3�Y
�xR=�p��?�30��	���A�N�����T�.c����X;���Zl?��j���t9vxd����i9�0�'P(�h�:�"%��Ք����0�8���8�F6���B��ѰC�DŹ,OHꆩb^Eƅ=���D�����&$>aI2�"�P�ӄ����Ds�t��������_H]9��������#o:�K��M����n��'�}]�@C���5Э��	9*Q�K�d
3`h�i�=¶��ɻ�	7���r%N/XIF�_-$66����� ����$�«��T�V��l$r=�u:� P�uU���� ������2f�h��P�Y�� <��D�T���o��m��ۋ�ldc�T���q��ecJ��B(��zvU.�������B�
�zF�n%������`%�ɗK����J�Y�ɷ�V8~�톓O���ԡTI��L��s2_[|[�K�6�� �܂ÿE�6����
k�F6�"_
Np�ݱɫ�?˱�HZ�L�k��@���g�h�
o�2���ٚ}�������YbM�x$U2��	�C!��`1z�ġ��(��1y86�_�Uu'A�I�s�m��Y�X @�{wM�[�.if��i��x�F�@|��ԩ��kzU��d���?��j��F��JD���b'��Q��p����}&��:C'�v���M��l���2��Ѱ�j)����\�9&�vc�~���[���su�(�%[+��N����l��n���d��^_�Q�8��eK�fUN��Dw������?�Ll4Q�tj�}t���i�>���A�7��~�֖��3�h�{Ev��񑁆��Ԡ
�.c���R�#ޥ{;�|K�Zm������W�̝�.�
R0p�jZB�^o��r�O��ޣ���8r��,w=����Y.��2y�JLQb�ض]��Q�߽sz�`S����mϋ!+����ɯ�!ۓ�U%.
Ek�ڞ{��m�=�L.$���l�D��yIg�0=S�;4S��+�~�P[��B�7����{�I!tɲSE�5�,�F�R�����`ew?�S�B�2���hu(,���7a����d���pj�y�p���si����"6*-�-AϮ�����%�@nl���L��d ���5��f��	-�SKTX�^ld6�q�\xG:�!9q92�Ō%�5t��I~ w���X"�N�u��>���M7[��k��w�}1Цݿ�{�[S�0uHF- 9E�����;*�ux�Z��*����4L�5d���nqZO��+�^��R�%]W����}00e������~o�f���n��1��PR�z+�^.L�r�U�ԋSJEN:E;I���R])�-���]�4�'y#Qs�D�K���b2'W�Jd�%���b���VV�G�=[�P�����ϮZ����U��4�rr��m͉������?MϢ���_4d?\����{y��{׺/��O�ܺ��%L� u��$�g�͎O��P����r-��:�&92����EA��%[ ��B7�T�R�8��w)�w1�:trA� ��`7��5wayJ�SՁ��>�I�M6�I�=�t�v]~�?�QNߠ��д��3N�x�<%�7��
u����7Ș.�#�Ƿ�N!#g�܈n����(��3p���a�p)lZ|�B6��E}f�i@+�'�a�$�Y�O�����a�љ��_9�*~����A=ɫb18�Y�T����B��q8�q6��c/K�hpE6�N�)y혒/8�@�MAqΒ�8g��4(T1	� ��o�����N�H�ӗ���f�k|N▽}�1nx��){�]m�=���	��95�$�pYk� Ď�����J�N~�b�j}�n��-���g��&�@I��VĠ3�j;�����e���������    p�#;̉w4vI��v�n]�������q��wu�%���Ū �dc�E�韮-]��	"f���kL����`���n�����r�{�yl�X�6,E[ '<�p�}�s�?����0lt��X�� �<��0�s��0�4%�s��Z����<�Λ�@�ʘF�G��U� T�f���[�����]�c�L�h	���뢸����N��r���O�	����!T��?�J��OL��	J��7�����T�C�1�;t^~ʠ*��F�@����sLk�&��k����N��4����ѣ��v��a�Wh��N�_~^m�)h1�X�8w�O�E�#�&mf�������9f��C���Y��4��`�KI;���/��k��i�Y��f�7�9]!��M�Ғ�ӕ������� �����<�*R���
҄$`i����[w�>ܩ��.dߔc�V��B�&�F�x��#7�̎|�����H�Gq��@��B�vי#m��W�g�a���l�#����T ?{�+�����_e����;��'��J$�u�іX����_���ou�_�q�Y?l1����|�㗿���C����Տ_������#�Ч����	NM����� �x�o�'/��0������li��y <Z�ϫ�q����5~�m9�^�ׯ~D_���xo�����������[����W����-���c�\���n�^��~����_��m2��-���c\`p�W�!M��7xƫ�9�}�����O��w�F��5؝L'�)��4[<�?�wN�S`-M�,ݺ�7�����Š���'��ϭ�����&�G�G2��Iȝ:�4���0$2���A�}r�O�#�����7;��+/1�$k&�<đI�G=z��\�]�#8�⁦��&��\M���>g��� r����f];o2�@����{��������٭��L�&�"Yr*�Qf�-�0��h:��2�� B׋����4r�G�= �"�J������yVa�Bj0����OB��U��p�|!�s�-���|�I���#8=�J�:b	O���"��jɜi
`�.I�Ҙ����x�ǭH��*���"Qz�2�X�iЧ���'B�UI�$���:Ru��{��`�YT����F���:�͹�|�@�7�E��6�a�sb�4��aFzÕ�/�^iG���B�px�G�; �4�����ĮD���~����_�k��(�Z�����\���6f����R�@�r��Kd�z�~�3iEy�"к���������W��l� ����nMI����G��A]~U��U�߁z?�Gլ��$\����_�j*�0�S���~�'���   �b�W�,Y�X�wθq��(j�M%I�(�#v�u��1�sآ:��[�:�;(����ҏ`h��7j�$�L鄄�c�a� J�d�R��2�#zÈ�u�o6ZKf�N����s���[�/5&/5�J��|,�y*��{��~~���=â��cg��*%!��PE��譫F)�h=���n�H����W7I	CR�!S�%����4I�k��w�K�׽�qE7;��g�Ẉ��V
�d_�E�!,�(���KZ�[ o׀T;�L������|1s���H�gqƵ��#H{�!.m��J���e���λHs��-+���� m��J���,QuN��� `c`��|ZDl8ϩ}F_fp5'8LGNH|�=W�A���Fi"jxvt>sE"J:[i�I�c�ў]�ц�u	O���Ea������5��]�^����&����1��)�ӆ�;c��ɵny�9h�]�89��h�0��g���%UA�+��R7�?��n��z�n
���IXbfb�Fq�E�r��X;;[���f��~r�v4�jcJ����9!S[ӵ����)BYĸ,|�-�ѼM��[�fw�!p�z٘�i蠀��v��U���+��}s�lzY�ӷ���������j�<Ө�U/���
=�ě=C�i��:w'L�� �4��,ڱ�C�V$�S���[�F�n�������/8��������t�^��GϬ��	Jy�k�>�|�|� tS2)����K�V>���"?��PLWvV/v���s%1�h����9[˶��mx�U&�K#���=ԃD��x~�GAo�	Ρ�Ȇ"�����u�]���1ld`��d��E�&bA�z@߷6̏)�o<�?�h�֝:a�xD""Jȳ����7��\u������������+k�%\[�N"�����[�t�'��A���̄T�V$�s���I�>�[}�W��5K���,��}��Ra���$y���爱��ژ�$j������v�Խ�-�k�)�˫�BMVX�ύ�1&[!�Ehi�h�\��ַ�<�S3A��0)�#�Ym�H�#��|����"��1]��!ܼ�������������S��e�C��iϴCa8M�?��#n֔E>ZŨ,A!8*"��'�A�	��Lu#��7���1��"���1#�
�ҿ뗯���'�ȦX��l�8;�zn�{%Q�!Qh��}2�Cү�����װ5���P&��8g��t-�Ѡ���L��$������-�e�k���f�ֹx�3Y2�V��RBM��ʹ����ty�&\���9M,��5�x�a����$�`~g����.�lOIr�npXIz�Zj��k)-E�&>�1F&�;�)�s�ДN���Mi�uW�6{}���عn.e��rn���r��;ߤ}���}�7��yC�&��:&₅�|ٻ�����J$��ݢX���[K�_Jk�]�"铘�_>7��`��Sz�:v}���A�tH*��3��v=��k������^�E�����n��̏��ldȃ{�]&n-�j?��Ҽ�s���4`ɰ�+�Ev�2'�M��1٬D���!qzt �Q�W�D�:�A��[�D]�v��X�{V�i-'Ұ 8������ph�{x��quž�ߵY4%o�gEq��	�D$|�I}.�?���p�Ψ%89x���0�2Dm�P���#p�	! :QY��[�j�q����J���)�^�M"����&z_��>zT#]v��C�;�q�9�s��^ ��/��Yo�<*�/̜�%B]y���l	G����=uii�K���rz)xgV�͞�BtnT��L\s���Z��%#9�(&�x�dd�H��b��8���f�q��t@��*��;)�vA��7��bjt�LH/v��=8�.���j��ؒ�$z"�n�/�5ɍuY��N%U�qӐ&Be]�\�&�sh���C��#�Ƹ6R7������tZ��a��5��V��z&Hv}������C���L��&�s��}��!l�1A�K8:º��)�l��w�kP�N"l� 4�sW��(ϥ��d6Jm@=^���O���J�tCX�U�A!tg�j�i�f���A��H����g�Ab�e֣ۚЦ���*`�i�=���:����Ԑ�/�)HB7�B2�K1��ޕa�W_6B�pwW����*y�����@�zM�?�8�T�Ye�w�R�T�*I���
���P��x���|���:t�X�z!'_�p�]/�Vh��1�z����'�4i�A��J���=�.�m�G�ͥ=�tp���^A�f��Ԡ^��*��&q[U�n����K�xL{�.c�ɀ����]6m���Յ(�[3��=n!�s)���<'�a����� ��$=�񿗚K(�G�h�]�׿/��c�'ʸ�����"���v.�@"O�=a��(}�%Ͱf6'�����G�"��Zw�[
�������\������k���m�;��a�_�pw��I.+����i9���M�)���[c�L./uy1����,
���O��?fV���SC�dt?�/�>��lϠ�P���gz���V4��0/��Xt�r�ׯ��M�3�Y/�y`ĬJ1ƶ��t]KL��y7en��O�=i4�]�7&��V�2}Α�)����6�� ,  x|���C����K�'�#�=�3]�8>r�#��G�#���/� ��xǐO��5�n�i�A��@0K������w�r���٨):�(�Bx7ޕ�1�]w�����x���H�fY�'c.@�p���w���L!�VNt
'yr dx�klg�3�7�vGۮ6�,�����؀������Fڱa�i��9�&�-k�&�,@2f�W��c'֤]���(A5�)�	�@g�k��[e>�$-C֘l���k��&5U�8B��,{h�v�t�kma�[][��?�@�t��K�[����ή��o�4��W�i�_�*@�ɸ$TE`ϊ�>��x�o&S�����-�X���eޏB(�+�����_�ޯڌ�$a����Ah��_��O<�F��IFD��(JZ�:�}��p{�i��0C��u���(�@�OGX���H(D�=�b3�fz)xk�s�Ej�uN����unu�����5$O�E�H�s4𛓭���C�Ffwօ��A����,���ku�̜�5�&KT9���y{0�K�h�I4sͲ�A�k �n�v��0�|F=Z���s�P���e��P�6�(^q�LkvX� ��Ћ�s�6�2���^��Yd#0�6�v *L��Ϣ�;����\��)���m7o�����6����}�G���k� ��2�4��l+�駘� 
qB�$Q��b�85S9�@�+�\ g���]��������8z�1G�Bwm�vA6B:bI�=bjBʄ�D�zio��2�1i#Q��Z�2�E:K�&� �it>I�&<s��r�C0��N�t�V�m�)�)�c @�V5��mpE�Wb��
�~ (���&�ϓ�� �ֹ�'�E��BA�Bӧ����E�%�@y@,��w�a]9�|��ݡ�}��L�xw&Un��LW]�x�M�I9~/�-IK���W�`��Xo] ࡛Cv���N�)�0q$��6�w<7q��`��1��`X�gd���,Ye�;s�R��d䦙���h�n�u�%Ka��.�vD�|'�ֺ�&rv·t��2��!>�:�g�,i�8R�K�A6>]ʲ1�=��I����/�ێo��V����؈�+ϊi%��ǧ�f��']��E��[Ai�b�o��Lo�Y���#�����"���^�"`������eL�rT*;�@������?��Z�ž��I����H8=�&� ���!۫�ϥ�!:�|[ql.Jb�#�E&f:b�;]�N7:7Z$ t�o�bz��fkf��G��1�m�7�8�~�m�/���w��� [�B*S��|��ߑ��\�ԙ�̒�2��		�]q샊|X{��F	�,��=a�2�Z�Y�֔~����k Dn����7�ﭱ/r;C!�W{W��DϜ�����p�)6(@����[.�E�"D��S����\��c�b_%�f����{�pP��ڕ������B@W���Vj>�鐳ņ�7���1�c7���[���n�6�|K�Yj	��w]V�$@~i	���4��)c����y�WmI|^S�s�Ҙ�	��� J��4�4��;��Fzi\�aR����[U�! P���������w{��O��l�0��|6��	oXY��]*�%�Ч*
�g�B:����޼o+�"2(^I8E�0��#S'R,R�J�Չ����F��Ki�r�a���{��J�{��KEy�`ͫ8W�\�j�ĵ������IWXT|D7X+V$�y�f����wA)����Я�j�!m}\\#z_�������஻ �#�?ޔ�w ^��7q�DB���iB�����Cv�Ǧw�ў��//��n�;xZ�#�D������b���4�I=^��eg�ؑ5e�7-w�xXBm &׽�-=�u7Rރ�������
PҾ<>�m����)�S���G�P��W���n��7�\���xc&�8�)��<�����.�f��kV���㦨9>p���i�d�4Ʃ��b���j��(�o���k�hX$x�s��U����Ö�3��a��wՍb�ѯ[�q!�le�;q����?��f�|mɩOo꿮6�֚��P�*��,�	�����j8�`�MM�jVڨ�Υ�C�G-��(����]�k�ɜ�N��I�cKe�:��1�HU#D���%�!����P<�U�֣�xl�� �ۉ�8�gCũ��ȤB�I1����A�GI�u���N��A���
��R�"�jiwBm~}`~������u��; ��!ьbV��OK0@d&g\�΋�D��I��Y�)�|١�Cv��1�����*.UW�Z�,����c=�!�@G���V��owo�;�0F����y�=�)Ak@(�����tg���笔� �����J���<���kUZ��vf�d�:�pNq愤����:q�R�`�y�O.�i�54�`����=��{��6���Bh@6IoՉV����C�R:)FK��������P3f��{�c6� �n*�B��et�ӵ�Sh��S����;���`ŗ2��|��R4���"4
��r�@��[��*�A�˰*sEGDS�r�MvA/�Y>��{�'�/r�&\����[�w��Wk���0\6��l��@"m��Z���o����5w��]O�(��(e���d?� ��=���s=rx����'3��8���-���c\S�cʪ�I��WF�ZԺ)������ �٦�٦^��n�W�4]n0J�A��|j� ��^�]=��3e��2VM��e %?5���0!�23��"�"O蔻�~i�)}�bo,@z}�1���Bg��K��B �4�\��Y�V� l5G�         ^   x�-ɱ
�  �Y�Bܕ�N)�GZZD4��=���P �7��r+��-ѧ���g"�h=-��e�q��J[���-լY�f����J)_�h+            x��|�rI��s�+��cD^pyK�1���@���%0HX\�� ���/���B�5Y,R\
dq���	�o���D�dM��UwI�dFx���q�������؟���?�?�_�g^�5�ߦ�,�B�#��]�g����!�~�������^�O�m�����Ϻ����F����Q�T����/�?ޟ��C�y�i:f+I�������'�3�����$i�ʫ:�	���x���ï�qόK�����!�g�믧3l'�QwX*OO�9�^_�]�a�|�+��A�������>ޛ,3;�ȓ�;>�Z�e:�r���;��GI��`�
6�g���W�et���������g���iV*�8�D�L���'��5�}J-3S�R������W�����3���ff�7��3H�U
 ���>��^����� һ�X���M3��������o�?{/����KA�q��)��:��fĹ����`���~�y:�þ��p�I�ɘ[�0C3���Em�NDG�	&��j��\���{R+k��A��fPɟ1�`�Բfw�J�X������{�ޚ�*�������gJ5����>�Y��MK?�3��xic�k��حg�g�e���l'|�"�L���e�}㖳)��Z:��M)Tu�012��T�YȻ�M�w���՟������J��|���ͤe�)&�올U
���n��4Ӿ�RfDK3n ��|F�)��36��������S����IJ!�yV�����O:fJ}{��ר��B���=d��oze�T�N
%Ǜ �+��c�Y���RY~W�:6h�бh�G��{o�|�oZ�G�9�?�����d��<hMJ���ksn���W�eX��t"�U�dJ4L�V)�r�:�Z.D�6�d�Ū'�~��Nƥ��PWؖ���d�RT-zNu[+M��kVP��)0�s�)�Ed�������#/̸S��#���o�^m��hjJq��[ϔ���;���Ֆ[�
^�^����t\��w����1��bep�	�#�ӕŐ�-�k~����	�ђŵ9���m��\�� �i:�W�ߛv��ğm�]jڥ�*.��YV/�e��_�k�\ ,\�e���q�9�?�	�V����vW֏�s�����)U�KӾ���dR�Ղ]Wll;�O�Jў��ﾍkj�z���Y�:S~3���NŸf2k��K�,�gN�� NA���W����Nw@[/U*n�7ѷ�^��3Ywl�R�j�)�
�F~�k��Wjn�>�w�;ۚ�:�R��kX>0�/Ӓ�J�ݤ]��>n�-�Z���p�U���di��?ְ2"���b���O����R�:�������_���+�����
��Ⓐ)U����Xôs�a�U+J�D��8j���7f�bvu����b��N����+��᳤�����.������V'͈o�]�e�J��&� ��n��9w=�vje�m,\�,N(�\AB�ͤ�	R��`�T�C�g�!���Y5'}�����p\+D�c�8MӭR-^(ĊNq'Q�<�y.{�끧���Db��97P"E�y|ހB�'p#H�L�ȱq���3�l�2G��g\�[��Yc��4��)խ����)�'�`�|p�J��D#7��db���C���7~c{0-�#��-��h��12[��z�h�(H;�	�^y<���n����֫n�����dȭ��~��]�v���k&�*�-��C��"�x{�x)�X^��]\��򍁋_u8]�N�ڍ�a0t�T�_�ee`�۲1����߉m�H�� �}5~4��N���M�Q�A-��J���J���/Q�|���h�?�>T4K�(������
��O�L��y)k_���+."�>�?������Z$C��춇@#2<��m:�/�ɲqHST��#�����R�_Q�Wv)S��E0����{��t��[*�+O~���ƭ%�^3��dY~'[L�������N���
߰�bѭ��c�Rw3pv4�#(-�.�d�=�TWB�+3L��}�(�WbXźmy5�"�C����l��hdH��@�b?0��lw�"�1��E�|�5��Vk�Q�$��-u�6�|4 t�HtL�s=z�le�:�{@���_Z�<�,��pz�}bޱb/�����I���/EX�-@E����ٳ�L����&x�ku�N��o2�7���������|��"Mk��qD�,�j�D�Bm�e��$3�8fD$��@Fȋ��̬sC��c';ƴ�������t�0'��.����b���z��:��y;H7C����$W��s�w�O23y�����=��u
���Ӯ�B��G��DŰ\�l��G��Ζ.5)�+~2�,�_�)��g	��k#+�_b���a/I�eB�e~���Fz)Ē���f��+3ຣh)�
dBځL2^8sM&t����F^�~�,=��=�&A�I�x��bͫ�Ϥ�Z�J4����=r���y?�Ç~ʚ%�����K��N���ne����tm&a��9H'��LAn�Ny�t1��*̋L���7C�ك}�c�Izot�P k}��]pQvA�ܡ�O�jD�0$ќ�L�rv���7��`�(�G1@a�4�,~�t���W�l{�a�9�;�Q�L���ov��a�|G�������&v�%(p�*�5z�E�v�aK�2[�a3"�6g��W�&���zM�`�U:� ��x%�y/��m�e��G��
u �>�Y�: �|�-��o�'<��kv�0Ĩ@\�u��Ec�k ���iN"�А��N�0wB:㓚�{0��!���]!>2-}@�c��E�[7c��J��c'(�g6-���/�-����_f���&;~nn�3�o��|���)*�N�%�i����G �M\�"��t�i�3��ǁn�%��{�#>YԲ�(��8��͂�/��?cP(��X\� R�~��bƄp�y�To�����S�%� ���".n�hv��ʷ�ڷ�6�h��&ܯ:c��W��Tj���$Z��=F����d�$+B�Gt���n���S��$b"�3��-�� �p^�g�� dC�i0�vS�|���w�^=������߆1����@��c��r�1�=�ז�� I�7a�p����jp��0����gՈ�:�4O�$� wq��Eq��H�|��)�o��pM7\j���$��V�?D���8�BO@��:�"k���P�A4M��p���2|���G�Mv}	�0�<�8�#��S$D��K��pgd� �dm����#�!�ONW�� q"����#W�����kZI�Ep���Y#��h���2�&�$M��0��=�nB��:��)b��g�/��߀�#�ɰt�DO���#�	�������@`�}X)2}v�����;�&�u��C��4�������P���Ok};#�G��E�����>d�t�%���7�*zT��	g��f����G���EqN?\�Z@#��9X�R(�o�����`���2��_}!�5�4ڭ���9Ͱg2Cg�#��J���I�S�C�5&�]0C�=@�j�ϖ�uGB��{��v�-��%p`��>�c��	�0t/Q�[����as�ɋ��+/̶�?���}bo=���#~W*E`�ȗӕ7R� ��u~��W�1���3XF �0Zi��~p����C��馰2��&6����m��4��x�3a�O}YՍp� $kp���8~lv�b*����<�6��+���]�7U�?�*����K�K��˂Z���x���t���H�"ZImI��;����`c�Y�9=,ah�M�W1YZ�t�?��۟"��hr���a^x<v���T���'�.�ڱ��Q2��%V��UT�kz�Ѡ�k�c�(�.j����+��S_��R���/A��%]&4o�m����p~.d(����m��L��jK����j>����a_.ȃ��Ha~y��L�i���5�a[E�qτ��g�b�t��;����]�1��V�e�+��m��H!0:ܠ��3#x _��������Yc7�    �f�c�M�๷	K�e}�'9�fN-j+�,v>Cq��`��P�Ak<sɾ�f-��ʓ�''/�^��W(��$�
~���
%{�C�f���� !�S��۲��ݥ �+�sw�t�8$|_���dG�9�9`|�&YL�^��&QQ��ϽQ
|)��1ԋa+�l'�!ɳ��fC�h�4X��'0�6R�����R��L�<Uum'Lb�wT%�[\��r�?�Y�^1Z�_���>���>�D��`�u�+��q�p�:(�c5/X��tYKJ��*�=���+��srQ��4�7c�M:������.t� 3��ڄ��o�cM�I`�)F�<�K�����->�mA��`�K���scQï.�5��FW�Jx�$�$�cy�%=5A5��2�-<s��D����_��oC�1SZ�c� y r�ҪK�Њ���/{���?X����
�X�增���e,2xm���@�m�=	i�G�1�-.v�8ڸ�3�YO�7:Su�,mD�`I�M:���Zn��qL}x=Dc�5�%�ƕKr�F�%A�����H�hmvH�4!y�f��$#6���&02m�a��P������芴6	[|n��}����4�[],ǕO���j9�U[�Κ�*�
�6�1��BWn�|�B9��a9�7,�S^��k!��lʷ��u�$��Ne�/��ivw%~�Ű'	T�P|����B_�xa_��5[�c��/����]���3���~�/�T&�B�`�̩���j��x�BHK$��M�ώ�2s�%�ZN���2!j�S�6ͭ��I��&���i��dc7��};��;��*�TaGH�S�BsG�-XZ�IK���4XX����tE��_��v�SAYxv	��ǣ�>�`�7o&e F.��a&,�0��9��$Dukl�G~�y�ƦdJ&��=���,31Lv4L����T|��a�_�A#���E�)T��,���zٹ���u)+5��`R�^��6�#�&�?��y�d�f�r�zI$9_���XY��Z����V���I�itȴ��k�P��b���b����F�9Q�R�؏�G�,/���_z���rH�b�S�T�����& �{��'�蔩Fgs�4�fz��T�K����vj��+�T�.T��A��6�%�V�He��C�uvHU�`�vS����:jA���޿t���`�»�������|/�;e�Y������"5��.��n[3㦑T�j�or�唙��V��pf��n;`o�����0���v�b�nvR[�XI��As �����Y7�
U�o�6����7�՜A���vLeQ�����VV]�����b)�T���a��+5'�l��޾��'�)�s�|H@A1��^�Δ��v�a�d�!�֨���v�����3e>l�[R��ެ4������J9l[�GWآЁ
��%~�^�¼�Q��l�b������i�0�Hd�>4��]��� ��s�D��h�dؤc&�J����$k�Cb���*6v#��k�e��۰'y���iJ��I��?��<-����t��l�D��R/W�+ �����ļ�������]��u�kR`�M� �����9]�A���ޕ����r��o����h��_H�@�ҧb �D����x{]�
�+�Ů��(�db7��+\3R�����ұ^��
���P����X�hh��E���iC���z�,wh[+��C�T�-�ȱ��&Ǌ�,�,��5J1��sˬJ	����	X��P����pf���xk��	�gB�c���U�G��wjG���e�y5�V.
�"����FSE�q���]7��~�NZ�w�R7;�a�WX�����)]Y!Y��K��st���-�&\}X�<����7��92�PX����`�3%<v���gh��Sj��(�/e��w&��Hh���K�z zv~_��n]����Ζk�xhg��q������l}�${G�"U����D��O=� >S������e?�����CR8�K�D ��+9�T�x�測:�쫒|�+���䭟%�o^��ז���y��y�W\+�)zm�icE��:�\�.�'��G��1?Fu�/��xc����4�Ui��O��la��`�b��C��`z�H�c_�r���:\'#�(&u�\��ƻ���Lȥh5~4��i/ 4p3+�f���N���[]�+wn<^�q�����������Q_�`���!ʫK_U~@�_���?��/<�P7�%�#ٍ��S�ȋu垇4��E�8�P[[�!p����*���0������y��地:rM���;�H�� ��$-M ���Fk���I�7�{��	�R�����E)91etY�W	��:���GD���v�a������it�δO	���ekU]�}Q`[�f6]�����!�I��	VDB��s�(:���H�>�Q���ᇵ<����Ә#n&���1]z<��mT�""���E���5��v[�7�"���.<=�y?�[1���ȗ�x)���=}�4���qď)�s�B����%�:i��{l��5�����βªr����H��˒67r���:��(,\�p�[3��?"��9�� M��H�Y��5�[K������}+��d���
�ͭ�y�n6���1�J#fD�� ?i)|qx��0/�<HQ|��?�Q�V<�s�}��6`@��eT����	����Rv)�}=�BD-n*y25��kLi�ޚHR�*t#����Ȓ�^Oh�BK�B&k�*L��pV�b���#��j_�贼��7/�F�i�^���������S%W���3�Ӫ��0.jβƊ�:/1a�f���$tl>bU�_ܧ���8�(�N:��d�ʪv�J #u��!�T&隷;��Pa|��<���f���ܑL? � ;�l�Ho<,�i�P�{���7/j�n|u�{�������[�Q�Z��?��Q���e��Y�u20�Hl(ȡ�`�����[|��Ζ��U���l`@�Ñ��ق�[t���Ќ�.�W�3���( ���T�u��l�Ơ�U���ٖv35���=�jK�Vx�@Gc>��@�y Vm�pU�,�{�!��8v�ݴz^r�?�ܔ�u/�AG�(�i%���4�Ѯ�@���!-��Z�ke���K�p���8_ڙ���ңRT��~�ԯ��78�T�W�3��x�f:w|^�BV�-��P/�l1Mz��I;+�A�}�Я��w�9�f�аP�c�ٵYLp$�^�	{�KqT/>yr1_J��8l�/�e�#X���ZW����)H���.�5I�I��{���W �5:���wBjբ'��g5�.���e��r��D2ɷHn�p	���P3xˈ�u뛘(9��0����-.�����X�k�a���<�S ��/���	E�k=��೚#P3�b,�Z� �8�+$/��ؐ��!�P���,6�6�k9L9�^�:�b=��zf[�m�	���*���R��ߋtB���]kL����k�#�� n�HW�:����A��r�2Y2�T�rM�*�	_�S�E#�cW���qX�ь�8<�U\��B����-�"�XnD���lA�u���d�]��⪰�_���'�����U���Rt��#ɊP��.���r��*���tғ�5m9M�k�RvmaV�-i��u#���?��JQ��1��!ƿ#y�X~���k�:Y@T����y���)�u�+�+��/�]o�����f��3a=ҵj��wF�׸��dX�j�yj�d&.��:P���R�m��spxSl��\��z9�Z%�	�I��3�-��S�J�A R���w��|��nJ�/�FH1��яH�T�C4���9�5(J��7�⇥GJ[����׊i�mf�v��n#
"זn���d�W��s��!R�z~�Lx��2��M�.$*F�I���c�[��,�esqHC�p3�d�aq�I�S����\��+�f��y�7�E_�˞�X�i�8I�C�(s!8�E]��8^4)ޱ��xĨC/[�8�j����o.��\����� �  v�\k?��c��yR�/�6r���F�\��n�O+�Q=�;p�AoF��K��]���l	�ϡ� 1>��W{��2c4퍃������Bqg)�]ɥ=c���8�v�]�Y�Y�B������J�'��g�k���D�*Q�hǩ��\[����V�7V+�jf�S=
�¡��-�%��8�WIO��ꃟF��+wj�Z�<�5R��_�t�&Y"�Akq���a���ON{JH��G��M����_��	�z���ˠ�2���k��6(A�k�T��s)�� �%;�U��n�ޮ����M	$�_K�h�<��q����3= �W8�L%��hN�1���$�HS�zJ�\��fd��3��e�y�BʫQ�4�ܢ��%!/�&3�{,M�����#=�1	�\��`s�`�
^�p��U�j�d�k��^<&���5�>�t%~��`�^d�9AǞ4��OQ���3J0m���|d?N�'Q�x��hҹS�׻݄�,X�9����Q���J��p���t$(<��=�5_F�=	2a�d?g65��жP��t^�24���o�A^ګ�3��� M��6�=m�"b� �S��74l�~�fҬj� o,�kߪ�*��ո�wI��p�����N9���-�8%��zP�ƈp#f�����d�8%?����-����ҿ�c�T���[E^      "   �   x����J�0ǯۧ�t��Ygw��x�F�VX�r�9D��&�+jOa�����@%_�����S���׬��� �Vy��}oW���t[y�C�Ϥ`T|�$W�\�@�2�?�?_��1��68�҇��<ʗ����;;��cn�_�^���٣�*,���2˥���}�؏��[��y���n���%�	�"�E�0����Oū�&�D��L	�D�b�S������$sQ���<��w
9F蛇4M�z,�B      �   f  x���Mj�0���)|����Fڅ��MK�)������@�8DS������FOB-��� ��0�tl�Kf4�P:?_�����~�?�@B*	��MZ����yyIp�&,w�:�vw�`(-P��31Q!k݌�Б:Ac�� Z�UA6�6�t�-3�V$�h��`����΄]<Q�"\�DR��@�����u�։�U�[ҧR M�>b&��8j>�L͠<a'EIkZ�\J��7g���مs3!� �����9�ޘ�{B�q+�A�Ū#�ag,]|���+[��j�u�v�֕���?J$��0���жՈh݊~�g_E#)���'�G�w��M�^P.@�A}�B�"��i�� �/�      �   �  x���A��0���W�ioD��UV������J{q�+`�Y)����TU�0����o���W�O�e*0E(+)+�o���R�H���'�1����J���d�B�+CL2:͎BD�e))W ʊ�J��R�,pEb()B��\�e�"1�(�y�W�\V*
�s�B�Ry�"1�E�x�~Ю3u8��0κ��X�L��Z��v����J�n�t�c����[+Ly���T��[�3�"1�]��F��
�3���Q�H�������nzh}��3��SJ?_{=³��kg�����ڱ�Ǿ7Wr}��n�]�~1����2 U&Ԋİ vL�f�o7��G�h����M�ޯ]n��鉰Ѱ7�%�ه&�Ŀ����Q��{��w���X���(�a��h^7�8��G�[!��2��m��t	..��LS��x�,�{\��Ybo��o��0      �   �  x�}Q�n� ��Oq� ��ul�uj��,�ҩ�!�q�fcH����M�h�&�����&�k�C�=�Ι�0.R�A8ᔋ��\0���4�T�9e9��ԥ���/_�����h�hTY�eU���Κ��V��e&	[��x�.���\eK���VjX
����%����Q�P���
��U�2EK�'c�םvȳ�Nn����3փ�-�g����3�l�1�0�Ztg����u�w�덇1��`�P�'�Z�Sס�z�C��!L���a��:�m��;�
��;�v�����^�#����LV�������3(n��! �)��	=��}�0�_�(j:,>Rȹ���4N]zz��\�)?�x^�o6�o?n��)B�Y5�.��8��s��Y��@3��      �      x������ � �      �   4   x�3�4202�5��50S04�2��21�3����0�'������������� ��      �      x�Ľ[�$�q&����<DYxܣ�fp[ 0��BF�cq���g��3 �$�v)<��R+#�FQ&�I��~�>Ϫ�����S�K3����>��{�E�����m�Zo�ݗoZ/�>o��x��הTZ�(�H���B�2!�Gz��������_3���/R�?�=:1����x�M �
�\�ƙG�ZY'c CRJG����?~q�O�2/�}A�@�43RxA�Ti0t��5���{�>=���Oo��F�����=|Q�:Z��9���Zy�������o�o�F��q�%��U�,��Y�Ҭh��&m[,;�>_r�^�:�}�bн0� )��[��Z�K/�2'��V�6���Y�:����Zݜ��p�ά`x%�d�N�8���>�ƼPt�FYIϐ��L-ږDh��K��-x�}��g?c���;���iz����=����-��ĸBr���ƹ�emEĂ���\���d]u˭����'^ߥ?}�O��{|Ά�>gq�uv��>�`�]���uk�	�V�2��7�^��%�k,��d�e+'#HM�-�֪ĥ�J�d��^5�nT��óX��ӛ���������~����G��<����C�)���|���|�HV�Ԓ������&zgŀ-�G��VިHA�e�3�L��������,q�
�j�68<o ��$��bƿ����H{�QȵI����4�w>}��|����ie���|(��a=D����F>�t�r�|��Ň�z�~����{��/�h9���v(�~�,��Ç�~��`�_�?���/�����|��.O���G�X��J[?|����7����Ɛ��I�Kv;/F���Q�b��"��O `�D#Y����pw��ik4m����ȸ�����	E�C-s�I�Ք�aM-V������]��RҿP�
�h!��(d�GC�BA�	cX-i�ERZ{���B��۟���~�޽��/��H�adU=�wl�|��&��HU�И]���f�4^�U\r�ڀ_����$�E�2���$2^#m!gY+���R�3~���J�Y�t;�fS�_q�7������7�#{�vYY�O�5K��ɳ,����9�R���.2�����$@
�s�lX(�B˃u6(�#��z	7��U'.Ց���������}�G?9���9�i�C �Nkh�4N����Roa��s !��[ #B���Nod�v�t7g���$J�V攤�A�sj�&���I�ZC �9��v"*�5.�Q��ʭ�:�zŏ?��	"����}�$�5�vi^�BFƑф=�r��t� ��Z��Au�᫇��s�L#���o�IZ��3,�>��#B	�or�)z�{���J��)�
��)��U���u��́J�72�Yz�^�o+/��|p�?y���:M��;a���'��H!2PM��ǖ� ��+�PtkN��9M9:<�����)osn��im$��!z#N��҈H�	�lh�ؠu��sv�L8J�	�X3>�aDG�G�!;Lc]26���RE��
tbSt����/�5�q>�����0�'7�x
�+�����]�����\�`���R ۃ;�L�E���	��%�×	
�gH)$������I�e�7�R���{�T^�W�l�e��xO�ƾ�@*xI{�Q�Y��J���6J�x7t���h��=ƞ�t)�$����%�����WKwD��`]��z����Ax�J�NZ#�`jhB�4��m�
�F@�����8�/�9�oZ
{�ѿ��-��M4���g&�
)Mlʛ����N��+�����E��|��t,S�:���E�Cx��8 ����X�<i|���[a7r�ݞ�A|���B:�������u�l�r���>8�ƿ0栢���D�]wd`��-3��M3T{���ik4�ś�4�M������:�Tn1׹��4COZ6���M����#�[w۽�֙ͭ��[��xT[���B�U�~�X2���(pH�P;�b򾚻���(���g��ǩ4~쩴����7�I����ӛ_<�,O�g�Az�A�X�m��;��f�H����e�6�k��YQog�<�K�IH2�J ޴�G:ϻt�[w�R��~:��D+�+s�!hH��a�A���8�@q�"fasT*bG��k��W|�S���lkR��DV��`4���XKݛ���7��G��o�� .�
	BѬ������7~�20�����)��!�q�zK�V��.*��Oo����A�3��_���Ёm��CO��3�\�N�?�r����6�i�R(QQ-
�:�)`�V��"�ٛ!�w#�l��bPp��o��i9@,ظCY'@fX�"�
�c�I8W��k,�V�&Ů�0�N�����w��۷�?��/_�W��?�~'�jo޾|z-�|��7įZ��:~��/�P�֛	�@;b�����לEW7�>���������j{5V�����=m6�%b�����M��O����������O�;�����w;LEo�S`X�O���?|��?\�b`��Y%7v�HZ�%�4?��G��{��z"�hx�V�聂q���[OU�&��DW�\p7�)������)��A8���q:����.d���$Y[S��z��r�gٟ�7�������7&R������쁍��F��*i�nk*�];�ٌ��O�L�^�6��+�]�t�{�3K�ȿ��C������$6\��<%�]y2j�X���b!�"\��4�8�ff����B������� k6R�V$��a�XS]�Q��t�䗘b
���a���i:G$%|g��@�ul�t�PF�o���o�z�<o�㦱x�n��˃��4���6�5<3�=6N}4��H�NRs��B��/j�Y۸)MNF�a�2���준������ŕ�R<X�`�χh)� �b�	�T��iK���L��J���^�1�"��F#,] �TT��r5Ō�vU��R[���3��M����7o�㛗���ϯx"�m����j�2���D��V��?�0�s �M�XG�=�j˸lTj2	���D%�郰���/�o�v߃:�4�u���<��A[R�Sm9D���6���p;�c\�2�i�$l<����r������=o�B�+��)�����N�E ���E�����[p�z�a>�2J�
�):�2����t|�e�E~��㥘�gͤd�Qr|MX%-q���p)X�>v�#X���]� �����Im��t�ݎ��6X{:p�$r�^�����df��~i�\��T&ΣH�&�]#M;{�먡 oTb6�m�?T
�H�c�$��j���`��*E���*j[p�KNs���:��@w�j��u���UP.�+J:;��i�!5���V��Z5y�r���E�/�����$ƛ����q�X/���cAZ�Z
Ə��{Ŋ�KMP�Vw�R�^�4�!���었K��/�O��^m�%�o�Hk#�����Cx�v+� e�����t�l�3q~����V`�y��r��A,1�ݣ� Z�{�u�`vZ>���KG��#�-4H��#]�׌`g����]3���PVų9~��J�E�G�I�Z�lxF �L�R���=F�S���6�mU��$�*r8}Ƭ���z�z���ޱ�n]�aૈ�M{�;��к���k'#?`�f��Oʀ�>��#>�o�w��o�?�����~�lo���1�$���b&E���� ʦ�,bn.������y�iP�-��4�$c����$-|�6Jc����4|y�o��2�T�Y�F��5���,�9�WfqQ��:���w5L��r�F�m�l�a��i@����?>�������xG��c��F*�z�́}W��  �=�+U%�Ew��F_{tF@���8���������`�򯉭%i���+��� pRD����m���X�z/���s�r�s/d8�i �5i�k�	}}==kM'��W~��� VN`�}KR5h}�w���`!;�3�p����vnϪ�m��    ����L�/ <�2,H*��m�/}���Y~�<����!�OWH�
�������*6*<j�pX��O:�:?d���}�\Q��5��P$t+ק�l���j���G7BA
/=I]2n�����Սc�t.��4fW�V�OA��@8�5fڱ�ҳ���%ݼ�w0M�;5jz��6.HZ�vѬ=��to������� �N0 j�������ƨ~L���#'D/�< ���F���~�W�QF�3j����m�-��x�;��Fʉp
�0��l*�E)1(��8K�]��m�l5���5KF֯�`C�Њ�D7T�@B
��=:s>q�T}�i1k�L�
E�����.P4R�z�N��j�y�랲��bH��g�\ /�"�6������ PA��NC�Iǻ���@ܫ
d$o�Z��Q z4_Z?� ��Z����Y``��Q{0r0��a�a�¸C�dD�G���|i0U�I;����X�Ad�� W���ٵ��\�+��&�2'~�����Ј`T)O{+��f��13��OZ4�"�؝������zAp���図E���a-��c`�p���~���[7�Z��>b�&Sk�+4���^DL0��b�䶻�M�GɜTZ�Oe��$YIֳ|!�[׃�.Q�p��-�P��*S�ޅx�f�W~֪�Wȴ�b-X%�
űogf�Q�DW$Hj0�q�,s��k+04S�)��tʵk:���g��G?�?èc̽ ��
�H�!E��F�|#؏D�OƷ�u��l�E�*��A9�-�����VW���u����yz��a�D��-�����e�qנnV5�9c²@�Z�̭<jsv�������/����x������y�Oo�.�3,mM���H�n�;���>�a>�9@�l�f����������l�����������wظz��~��`�>�凿|�c����q�2^��7���q��x!����ᢾ@�&/�3�'�:g\iQ"KiCk�VIxq�L1�2ߘ�|��Ca��#$�x�$}��q\��H�f*-��+���t�ч��CJJWu]-b�m�xv�3�Y{�ΐ�wO�|bk��W��x�WG��p�dBb�i쀂5��C�.��}��gL��w�e2���Oǃ�U�soJ�E�� �j6��j,����ÔD(Z���`�J�n>4F�nz��u-��/?_������	��h���l����;�n���G��� ��K(�� lb�'GA6��B�F7}�S�%�x�2p��۳��_>��Ç�9���3��<D7ڸ�;����V�n,�,�$���2�>5�S��U{s����&1	M��u\Rtj�s�H�A�׶���_S�I^i`���k�X*3��Yr�Xg�_ǎ�}�t��A�b #?KSH�9J2���"]�9n5�+vm?��8�=|�+!Vnp�@�XvMC����[�Yt/�:�9qyb�1��0ޕ:� G�������&�fH�6r��t^G.��{���.eS�d�3W��P�.ΰ���-m�IwL5��^4~�6	3H-.Jk�;�˹���:�sNV��PCi	�s��^ưC��>��(5>�`�-Ǟ=��[��� �����3����NK�����>z����	�� 2�U�Cq��Z`�@L����o��@B5(C�a��,#��H�!�����&s. G�D[�01(\��a���:R�1�� ��^~��7�^�j�7���7�Z?y���(�U���K�j{5�9�����Y�2TC��U��J@������d�J�,+ ���;E���{>��Hp��|@�MG'�JT�n�k�՛�	���_�5����z������&�����Vu�p���~Ͻ>#�}<p#m�#�S)kWQ�$���K�z�����Tn���S�k��+2��Lx������ԅal`��=���P��v�	�Pb�-,��:�칈����qZ�� �_�������Ç?��`D��cѣO����Ç�{x�Ϡ�5��߯E��V[���cf�]��S2:e9��1��n��2Ͽ*��堰t�qKЛ�wR;�������Er�_����x��):��7.���'��vJfX���Ma�4�{m���+v�[��Lw2�!�uh��� �gI�}��?��M�m.��˟���Y���n��=�V�s8?��9�.䜴�b��8!�������j��с�t�*
�^uR���@Zqɩ����~�hDn+���⛯u~@F���o���l�G����lG{��R<s���ؖ�͈�";RU'm!�m�eǃ<:�ί��W_��z���=g��6N!_=u\�\�<C&�\0��^���w��������fCXls�	�]��OoҚ#;.���Quya�fz���WC*��\SYJ9��5�(�2�q0�IA�Ƥ��w �,PTv�*������o����P���ll8�=J�HW � ��WGi*��`x�FW�R��{�1z�����n���~x���2x��;�`��=�<�Ha!T;�1{y���~�tiF7�y!�R�h�x��d s����df�T��c��
�8�c�t��]�K������=v �Y�*Į�!&9���.גG���ҩ1qNE��o߾|�U�|����7��jb~Q~xt���4bV풞���1��+9 4���BU;	XVc�V�����>��!���41�*�9���3�G�vw��Vq%�4J�Ax�����ܦ,_�����4�_K��aFw��|��9Z���Ʒ@�h���(a�Sl¨N�Gn�2Z5m]�~�Q�ݧ�yq!	�@��Fq�u��.,�U�%�x�36�L4��V$�_�ءG-��N�|�d����FԍK�w-z/�k�iη���I(�ip�󻭧��L�����{���١^�u�\�B҇"��|��c<��vF���8��������E��Y��]����Ή0��O�gN�c����������b^r�����P�*��I�XU��^l����Ε{��Vu� ���皏y�\�9��rŇ���A!F߬� \6s��0��>�\�{f��_���HIe�v P���LX�P�͸V�j����`{pMe#���Gi��n,���l?��F�����XٯgĢ��6'_@֫�n�~���B�yN��z������r��+Mh�;�����+�>w������/���WO�f�H�����ք%i(Y�����a���m���F��V� �V��2�5�3=Dq"��	�b�,��?6!���H����+MI5+W�j���Mc�f�ج���>�P�A{��J����LcC2r8�� aa�VRbMk��H0;n������s���\oI�����CʵT5���2��̥^���c`ْ�Њ9�y)��p����@ym�Ф��`��bD6M�ҫ틴%���`�D�^��@���S׷�})���H��&����:�����I{��������(�[�>T�R:z)������\I��Jp�w�x�g��X�}S�n�jj�q���?i��X�G���I�ꜳ�0�����%��h�]��C^��\v
6�uVIc��Z���
�У5����$J��
I�7Ѯ��J�؉T�V S��;U��9BΆ�n��N�aռ�(�;s��_�%Ro�4n�m6�c���@���Ǝ��$�\)�lۣ�\y�5���!� �n�\�����y7�蝦�������۵�#͆�Z)�Z�eԼH��L=	#Ճ���&\j���\bxu��0%͆�ra*%b�VZ0�E$�B��m���'�o���xU����_}�Ͱ��^9������,�i띋Ov_�t4��-6�sK����ٹ=um>�
�o�#i6�εg���˒dX���3��^�i5����k���bt -��>�Œ�eoC�"�'jFY����M'a�ܱ������*w��$��G�s��s�qf����	qlo�m��\�\���iڨ��ܘ�    �o=�#�P���m���M�N1�',��ƍLu���](t	��+��b�W�o-ǜ��rz���;�^G&gȜZ�H���Dȅ�G���9��uD���ӏ�6�� *C��s@�p�ƞ(s
׼��bt�}��.$� �P��u����፬ސ��o�E�Z�:��:;��s��OZ��J);>4Hl)���[��1�Pg��o/���{��y��=.vc����z'�Bø�!����ۋ<���1�:Xi�-M�j�0KTdqRU�)w�Ƨ��%�<�wΩP�9A1�Eࠪj�̶��]�k�zy��WO��jǻrr��P�sԸ��G���F���^uu]�N+���Y�2�V�2~Q���b�u�����k��Qu��qY�ʥ��E��^����E�qo��zA2jp��q�ӵZ���C����m���N��ѯ��#�?^u���KK��q�T���.=��]a[|m#�w��J��7ׇG����L��1�4k��cPF��f�n�,憶^\�)��C��:�!`��;!^µ?�����r�q���髖?_�i_�l��*{��9LHi��G�a`*��P���N,e�p�ٖL):���4�ʚ�,����~,�ФӂE+u�{����rp2(0�A|Z7�kr]�f�]��_}�3r�|ɥ��r�t��$7����j�t5L���`�+ʾ��Ž��0{��*ʋ���z�P�3tG�c$����Y:.I4����|��|�պMŦ������Y��P}�U8�1r�{����걮�뉝>��V��t�RS1zME���u�.3���ݚNb(*�B��`�����ҺR�����Z\�=�p���X� ��[��pf���=N]T�%p�(\�*u[�5�+��[��jlP��'�������?��Xh 7t��Jl��x>�{��� �\��yOf0�w7+�Tji6��(1`FW�Z��+�V-dL�H�ŕƽ~�4"W�2ᦷ��B��2m����]��f����1l�=��t$͆��> �v>��as#��޸�j������������0�(����R�l�4"��k�GW*��vM�n{��b��4��ԺmNIyc�H�!�O\����0��c��`�����.O_�Qz�髗}��K�\ﵳ{��(�<@�.��h��bs���)�k9�S�����u���1���q��%uT�F�H34س"r���?)�Ee�>�u����e(:5����<�P�2}k���M��t7��� �={-WlZD�-�hpf��B�k�,Ki���cNCP��p�B��$U�k�m�{�o��nZ⌑��ł"������j��Q�*OЎy(	�U�X���޵���H֚o�P<�!j񨶽��ĭ�V��UÜ��M	[^dF�RR���%�slI��Q���s�}�R�}Snx�#��#g��=���NY
�D5�j�\.�՝��5�U��o���%��?o��yY��ݗ��O��޼݈4���4�I%VG2{�ѫ�f�+��;��S�N^�dX
��=P��~V�{�{�1;r���o��`��a�jX��gD����älU)�	�Ĥ!a�U�N@��Қ����7o�V=��:�~�C:�p�I����8$��";n"'S�'��t{c �����]_�H���ø0kk���`�f��(Mĝ���(L�r��x�F�N?5�k��x��I˺��:n-�_]�Z����n@���U�G܀]E;��'.��/2<�T�L6m�OO�[���h�6l��a0W��f��I8��\p��0�O?}z��P��7�Z�g�۫�~�F_ެVI#�Y�|�W�
?֠�&ZǺ;��=�&aC�"wC�Ë3�5�$`{��dZ�I�&,�7Պ�N����O+��$�$LD��l�'�;�����؞���Gн����n���p�bu�cM��ݿ+���}gY��?��_�z�?��|�b[)y�Ń �S���I��:��^�j��)��3�Ԗ�>(�K�}%�	�Z
�.�*����4M�иb.�'�,?�˝P�9��K��=^����� aف���jH8]2��T`������Xa@��n�dY9��V�^C*r���5Wv8�v.�z�ƐЬh�֡�4�O�/�8���{�QS�Xz�<��g�̡�j(\*u�
�72\���\*��nMt���	纲�� �
�xk�e�v�s��� ���B���o�( �<����ZN�	Vt\��ʥ�*[�FjgXXɣ�x=)��Tx9�>} ���F�^Z�P��X3m�2��W�ԯ���3�s�~��č���q�����J��k�ȉ�� [���vn�ۑM9g	�����N�6%>�ˌ�"W(�\m�\ǙT����BgK&��<�m�dNuN�Qc�TW��S�hZ����7�H���s%wX=b�"���#��I�l*%`����F%B�X���s[��X�f��Qd�Y��R}0���@f�
�"�G����ى"���2K��[���p�8�}jGYn�͞�A0�o�I�u�tmC��k0rQcs1���)�)\���m��a���g\� ��~�� CZ��t�$&�p|�)��T��]^mN,�⍑^��1��㶿�VQ�gH�A��J��@��<�ND��]���x9��}ί�J�?��?k=��?�ٲ���@��s+�=��8�;�{kLD��A��Rz1V�&���8׫̗����6��㟾]�K���A�G�]��HW���j;E��qc%�b�B7 �`N}��ض
c�i���\�'.����m�!-�ä'2�I��=qYAgR��^���3z��_?��|�����ʨ�7�)i>��l�F��eD�q00���kMImv��o�D�i���ި���||�4���H�����\,����ܐA��i��}�{yZ��	&�H����,G�!<�P����Jq�ˁ���㦂��
w7�lp_�\�D܆ҁP�D�b\��X5R4����=7>���#�9�aC�{�2��8i��cf�Tr�w��f_(Gg�q1���m	qa�=��C��r�!m����-�-�u$]Se��#��Y�$�{ĒE��X��T��ϰl/�KU4��ղ%��U4�0ҝ*r�z�ӊ�{���1���e˛�%+��2\6��3M*�X���6�`�pC%)%���9RjٙeF��z���i�;!CB)��!&rU�\%��/����X�6`8�cj}Ma���.@�w��:`�0��r �UA{z�CX����pvP�~�s��Fq�<��Y�}�H�!2���	0$L��*�R�]��\3���0������2jN�{A�����1��s��$L<����R��NǄ�Y���;�Fi��Z�H�!lȺX@�丘G*�m)��g/m��J?�(�ޮy�v��� 1�;k�HwO����qHqΧ�"��m��;7ۂd\��ƌ�[�6��=�����c�	VW�7^q��^��]w��k��		��s���jC� nѴ���5�����B�v�F��A<�@Jd�Ђ/W��S^�2��Q#��/X>,j�5%��;�]��im H�wF�\�v�Ϣ{-U�!�e�� �K=��36_�d<��7�S�(pD�i|I]�|@~%'r4�/]xs�����/��VIk#e�6%E���ر��o���'������� ҁv�g]�_x!�u�w �#�5E�	4���8c��"�oCK�Zlڴ��e���I+�����1�� ���n�t���_J��s��_�\�@A.�O�s�1��O�b���J���Eo��=�l�ܛt.Wѡ����l�n����iD�V�~�ӰX��k�V�{���KlY;�� ��"����w2�ܘ=^G#��u?{�&�ko�N��7_}��Ua'6���к�D���F�l�hI�rႿ�c��P�V�`���_o�o��'�U��&m�Lh��-LAز�$�\�IǞj���o��l�USz�$�����)ik�\�j�EA\[�$�KIw�԰3�M=��Oc��9V��cb�#-GqE    ��n0�����q�%+�Ǩeˑ�O����j����ת�6�=��� 5���m�.�)@keHt)��9�[�{�_{������VR�2��&6
wH�!����^q�/�Ϊ&�f��,)�
����^��/a�E�M�칖׶܋JF�G���a~��X�$�
l'�K���,��Y��yt�(҇o�7��=�~x���j��[��_�N���� ��������\��Y7��j��r^�G�A�|2lY��Yre�d8��6�-������Y�}�ޤݣP;�OK�t�j���''.E���F�\�����F�^N����U��^�Q[�z$������W�d��
��t�/%�J4=/Z�>�m�qvmH�\���ֵH�!*'���PCڤ���}ET��f�&�� �hw�<1�ܗ��H��i6��MC�U>�{^$�)���&7yw�˜<~Fɛ1Q��CN��O}8cc��� �0s�����a��w�	K�LWgΣ�AH`Z ��B_��m0�x���Qj���0p��PuX��R��Ë@��١�5AUR�BH%��B��"��4�^��� s�6z�~��_�z��?�y��ٷ�3�Cls3ϸGZ��fU�S�5�z������RN�v�g�֪�$�>5�pL��K��+E�+R���R���s$�4���:�_N֭��Q�qH����X���L\��1�݌��u���!���+�$j��zعO^dg��=���S_<ϟE�F!~�c�f3�(E1,�܌t�$%R�9�p�P���"{[C�%�E*��z�n(c[�;�t�ة�Q�f��qseeL���y"����N�}IW�3��\�>�D����r��<-QEc���梠{ѱ	�ˆ{a�N�Գ�ll�k�J�A�*=��#ǚ˨��8�I���j&w��<�$݃k!��\�bָ� ^p`��:>2oW��{�HC�Z�%`��qe��F���ȭ�r\�%�e���F���W�`r;���R36p�1@vb:Ȋ��@T)o9r�1Z�t>;���k��:�����GZ/m�i>��9X�U%W�m��P'ZH㓬%����۷�?��i�y��M��\��i>DJ:�ʩH��:�"�FZ5�,�ͼ୍�u?O[_Ͱ?����!͆�ɦ(u�Qm��t��CЩb�&ԛX=�g'�g`�><託����-����T�����ph����"�c����Y��z1�������l���h��O��L�"u�ieu�9rW}Ϟʙ��Q
�č5��h��4�Ǯ��A-=p�sj"rQ  N�&89�������:�Ԛ���( �7f�� MG�I����;vJ\-S8L�6����17|3�ތ��0�I��#���ΰ� ��|K�^sq}���웹��q#�R�ow�c�~��#��ӹ5���3$�y����͛֡��PJ�.�������A���t�yM�;Ӡ�ڄD�Ɉ<�z�
V�<��Q5������m6�(̳�5	��sZ\�VYt����c�~l�$]���qwt���J��&N�=��S6T�4 ZA\z��W��\E*8�=X���	��4�c�T'm@��w&�"�~�פ� T�u��(f�	�c�K�D]p�}^�������=�u�f���n��}3���wH�!��.i7���Q��6w��˶�V����G�v|a������~��V=�����eU�)em�꽕ͱ�¹�6�%\:����tcv�f�QX�����?�w�l�Z��p3��H-�j��BN���ޜ�R��ː�&����*��-�ɷ����|��U�Ԕ�6�)��������P�娕�������=���}"_~����m����#im���� �5�[�?2/:6=�<%}ߑ����;����p��i6��2����v���% 3��ʤ��p��ء��~%��un�d�[� ��.�u�lb� D[#n�ĕ��xSd�teS��J� �����Ȁ�N�*�S��g#0�*�c$+Ng�\8��3��$�p��?���P�3�9?>�l���=IH79K�"�"D��� cx��L���NÑ�3�bk*�K�4@#�9��"�u;�gyϡс��G�j�~̎���=�]SP������t�`���8�s�\̎�rh�y����;�����_���o��2k7�-]�+z���;IB�J~�F;�{��t�����2;F�m���֨Lta����WkA��B�QeS�
���rQ�����(Uu�fٰ[ww�)�����!t��cE�~4&gκ����;��f9���Ozqt����Y?7:���9�yҏ�B�����|�d��Wn<WY70��U��ps���"gn��[��hT�L�T*/����U���^ �����M.$b-\��Uݩ�Z<�n��;���Z�;r4��gA�q�y�*γK�g �7`��� ��pk_��Z�V{�J���k�R�����r�w"�0�I���*��	���
��*U��*�=��:"җ�9ٝ��UY��?�g@8�T%s;��@͹��XH߳M��A�$�P��s�/1'W��w�E�%�r�E?� &}\��@y��[���w�B0;�Kѹ
�"�K����nI�^�Wa�W�9�g.q���Ը[lOF$p���&D�cZ)ܽ��&)����n��q?
+�ÇM��)�ci��v��0)��%NZZ�K`��/�!U���$r��%�h�3�ï���K^�%�m�+0)���z+Y&a+ר�P�I�О�YW���p3�F����'k��Cy�eV���Ð���-���s�����ejr�Mc� 0H#�;,��d��O�� TM(���+�:#Z�f�N� ��<?���Ż,��n�T1#���@�)"R/��t��	SZu�a��Z�o��l[��Ǒ&WO�S��#�[n�,���]���ZМg�#+�E{�縳Z�Fg����� b��Fёt�4�_��+*'�s_5�k\�9wI1�;3���T�/y����K㏦��WH�$/��ShM ;�ȋ��:w���բ�v-y������Igv~��C�!��1�J�ɲo� ]´�Z�� �K��1�e]Ξ������=��,,�j�)}�� ή��{�y�u�������pS��^\N���U�W2���{���g[�UWK�.tc���v{_y�3�6n�W.����uh˩�����i��-f��U��(������!>X��"�J��h��n��uD�n��v�_U虒�$'lW�<ñ71G��5س)uF��Rcӛ��e}�ND����q��7q�4@�*U!��Z��y�V�D��rQ0��r��Rr����W&��MF�$�%f�� :�����8��0߉R��d�odtL+=+�Y����#m_�c9�Ũ�&).��Õ�lh�:�ta�}�2K�CN ,��"&b|ur�i��8��ln�mn�oe�4eH_U,��學[��{�8�\t�&�G��^D2I6����YU�@�����;5$:p��4:������Pr�.��mk���9L ���Z�]?�.�����wk�-����e���{����H+ו�A���ܞӴ" 4�%�>~��*��УOF|����M;h\Q>b�إ���(=��3��В��y%�Y�Ϯz�$����L�Cjs՞;��#&¢��:���6��S�6R[pR�zϭ�^�B����O�ʫሗ�a3{�4�S��_l�8*��Qr�[ծ5m!@��z�62i�R��g�A�N2A-
�/HwMѝ3:%��h�UG�8�U2��,����61�w+d��XV(_�g(a�G�k
��\�`��΁����2ge�s���1�|�gp4���8k�n$��T#��¹6�Y>Յ��̒�yΒ�A���%ˣ1�Ȇ$�=���4�v���ڏ�U���� �@�.�A�|ƒ7c��,�Tx�(����Lh�t�y	�+dJ��}j� h���j��=@jqr��s���c�vr�3-�3t�U��O�+Ս�f�����!���%aN��k�( .�W�t���۱�����I�c��(����F�u��^�����    [��RQZro@��oI\W�J.j�JC�=����t	h��g4C�V{ioEç�\l�s��ځ8LDU���S攪�psW��_�~��Cǿ�M
�bZ0,a)�BF8N�=��:۾9����r��xM";dڕ
�&���S�5c��`��ּ�?Qf��[���[��lҎI�i2 72,��ې�3m��.T��V��n���I�k���V��>X%�ik���I����j3�c*agMt�h�}��+�rk*l��χ�#m�&]'�`X��I6t
Ǵ�L%i�]m��l����Z�#m��a+��Ѝ{�qCN�$B3��dKX4	xn8�f�@�*�r9��͆�d�L~\j�u�Y���7�=7�$q[�^�]&��u\�]��fd�H<c�����j5�jh��!��#&
Q&�Ձ�T4�ΐ���2����n!�..�e˟s�0��_�Nm$,/s�gPHBo��#�)�-�x@J/����$��!"WK������2#�z��ޔ�e��傂2~�t�	Z��E�&_?sL��I��
qф��j��w]�3z$4#��f5�WH3Q��j��v�&��O�S�'Hφ;^n<�c���"ק_�~���v� A6�=�l��J�� &)�k����X��Y�q�nf
����'cc�����j��KOV���U��G�%�苵A�.��?�3G��5�Sm'�t���Q����el��#� ������)�h�əd�8���~`����yv��.�(s�j��v��\��JF`���b�<�fF�� ;V�%\*~l�M"��	�I�ƅs�ʾf\������s�g�J	�2��p�Z��u�-Q� }�+ѓ�d�H�z�D����0��P��6����V3\fT�/�3���,�6�\x��gSǏ����]5����2��d���$|�Tm:p��J=/��A���u��ώ8��č�'����|������(�H|��E���i��T���"���j��T|l3��������u/96ͳ�0�r�]T�N-��q73z�̷p1,���֧�\��ַŧ����������~Ba���8�׬j�*��P�U�h�+\GD�����T^�z����|z��M*����������O�i��K�Һd8Ō+8�+�ifY��Z�o�!��*��+�纅���}�g��G��l5����e��{�G�
	kp�n��kxr���p��S��ަ�HZW�S�ǎY�C-�6R�Z[��[�7'7Ɵ��mT�ߐY��Ļf��Ʃ=N�a�����=h�q��̽�-��K��q��[o(��z&�R�Aл=�Y4�.]�vr�~���oW#m�|$M{nUh����6���:~�{L��c��̢�t���~��߸o�e*.�H^չ��F�&�-W���~�s����:ߠ�包b6�Mi�;psM���
��	v$�9	@<���yʎ;��!�SŚR9�$������%��k��ګP�)��I:@L�$ �58#���V��t�-��vu�����A�n�Ɓ4�����g簩�pC�h��*>��y�uG_��<\��F_�sS��mQf��Ow���M�����7�2��;������x���f���X4������O�P	�l)n��8�"\���t}_,���s-��s�FlDYři1�=���D��nLz�G2ʬ�O/ߺ�n�6��n��6R.�X�6)%�T�bq X\�ϙ�4Y�_�g�p�}P�e�H�6*�N���*�&�L��{\�x�{����;�uy�����ޤw/�^Ͽ��k8������׽&�_w�J���]:+�RBc��\[v����?�U�-�z���ne��s��!�~�>I�����Qj�o{��z��}$}�D�)CmK�E�6�\ν	�_�<�Tq7�b�t��GN?^��u[郳{�������P-NH4�	�B�%-�=�nGcR�p̹�ִM�9t��X������"MI�ݠ:�@���,���l�$�5��c5&-#�ϡL4Jf̥��Ͱ�f��J�"{��&���ے��8z �թeٜm�G�`���?������#Н�W}>������=�3b��*qF�M	�"��q�,���
tG���Mq�����rC�퓖��R2Ɋ`��UP�>{���	_���oG�]u�n�gs��"M�=s7�F���R��9��k�����4Æ�j(L�Okl�ŀ,��*��)L��w�����J"i��q�v�7���McaQ�V}�X�3�gN(�^i�4]�:H�۵���t�4��4jˆ��G�"UE1dJL7��iۋ>�ȗ�5������>���߽������!�Lr�l���U�Hci�5�]��ܡ�lP�+-��'m� �MXV���V��L�(Z�z�1$.���7����������jd~�5�Ho��:!�5���̃�w��ąU ��]����\��g���n�3&�=��0:f��;��R�,t����W�e�z�J��[����Z��k����H+��$���5�0������CC�3��㛟P�"�Й��mWa�t�4Zf+9��t��a�g�*7o���e�W�	'�C}�"<>/8�R�۔�'��^�L�9�Eqh���@N�����>�b���"X�w;�ˡ�h܅`&��VH�����&��K�<K|�iᒬڴ�]Yho35���`s��<�u���!�tR��� � �G�d� ��/FQ�N���ndx�&8_�c
�~,��D�G�b�]KY�e),uE.�;��B�s��E��3�N�݀�I�9��v��n��/7��W�S�]S8WdW��0A��N8������Fױy=O����o������~�޶7�]D�+�G��j�Ռ��.F���\uHw�L1�&=�.;����y6����� ��.?O95O~Dd��;.�����j/��3g�:���5�R=%�[�#?k�ѳ]���J���Ԇ^%}�D��̭ܴl�k�6�E8��'�`ջe�x����ݔ�?�}+��6��:��#&���s*�P͵��j�qe<���E��텟��Q�:7��3�vlQ��#�?�3��t�m���G��Z�V	j�F�aJ`xiT���9}(?�%�~W�9�$uM�ꠕ��xW�$F_|�
1��6��\�Pp�:P��K?� ^X�p�;k���t��*K`�
�C����K���_ݛ/9S��K���ï�6�0ƚH�����U���a�t��q*�e��gZ�������=ٺ�h���M�!F~q��Rs.͗�A�*�i:H�x.�K�w���Y�$j.��C9ޣp�����v�m�;w����g��'��iF�}s��J�C{v�'w~���7��%U
^��u�������}���7�~Zi�����qKO�ڐ����"%�����r�N>虽��ɱ+�۩��z�Ɂ4����8��A�4��!~\����c��U��1��鋇����� k>�7i���,�Ȝ�A)�~P&��Aa�=�ٍ�u��OLW�~��=>���m(eĦ��>�k?���x�Y F��B�&�.9P�iQ�b ,�"�ql��VuI0k5¢�����%�`�NI��	í���ݻ ��o<��	C�4`��R� T|�8Q�k�;l[(���y��6�G�n: 0�P�� 
{�(O����X����l2�cw����i$�}���i��} �Aaȓ&'���ػئ5���fl[n��s��=NB1�W_�.29��k�D����6l��)�k��vHؓ�[��N?���(#�w#7���BW����E��<s��0���g.�(����Ø���؝u��_��vM��U�
��b�#t[�91a����������*��1����(��l�~q*��X$?ԗ_�|��z���[�N���J�8mH���*i,��1J^��EvNQ{8��i8�H�o�}�Ǧ�">����+7�+��r~�ȷ�S(��zR�c��8=M����8'� ��K>䩥��/�N�����W�ʩ���?m��-�r�նǟM.��X��8��+q�"9�{j:����    [��N�Ξ�Ú�:�v��*&����a�����+1q��bt���1�k�5o��c����)�CNf
�ߔ�ݳ%�s��`T���7���rλ��o�d}�޵:�Q��QY�����2aI�,��"z{8ðSu8�ƽ�;1���Zu@-k�o� 7�Ƹ��.��>�핁r�:i_��hh3ԑ��a�I�\cj�^�:����f�)*���&y ����e)p��"��(�&���F��j�c-oh�<K��r`m�6�S}���b{e  8X�9F��{P�L���C�:���$�M������qm _C�֘Sg4nژ]HB��M����� ��,8�3q2z�7#�X��
�I���QTNhGW-j�>8E�U�������*�	 qz�>9�r�'�b8�7�,��e}���f�Z��f�����i6��u�C�rqQ�������h}��6��x�wvs�<�a��W򠯃U��5f�#�,c�f�����O��&�2sIO$pǤ칓��:R�z���;�|�����ڻ-M��a��S�W2�"~��ǡ��b����h2�-���4��=3�/%I�[�jI�&�ux���ȿ���̨̬������wEzdFx�{��KM�[�SZ4L�s�f�M�	�#�[�w����2��=r }0���%V�b�m�����������F[{$Z����dq^�b<xhD�|�]���mV���u����KAKȠ�S���HU��=S�^�Z>c�	�Q�Ç������::SU���y0����ɜǌ�$jle��2^m�O˖�(u%�[�;����de����(�r
��kh+m	���&�O~���?*��+��~�� i^�*������ʍ�d��I$�G٩d\%2rpC/s�N�������	�� ��Ct׭L�gI�`��x4���g�Cኀ)n�9��9j�t�t>[�Cs�|�˒|�������_���������~,���_�˿������ӿ����s_�c��~���_��-��6��r�'�x�7X��3O�ߑ�%����s��JJm�@)��3jc��K�:�����p�C+�jG�3��!��#tj9����<�7w�gf����'4��t�A��S#�?ݺ��������UQ�[��:�Iں�4�f�����6v#����1�{9��̛.f�G�)}YzCg����y>���.���A�D���fxK:Z:!�u���\��W�Õ�oV��J�c ��\����v��{���d�1*#�����g��86!�7�Yic��*}'(=%��P֩`�c�8�ON��.jO�ˋފ�7�EgOR=��y�l��|2�∗6���;�c�=�g�t޼99|�1�7{:_�)���#�2 ��
o@����(>⇚�;J��š��Ҁ/A� {��]�m��mT�}��h�-�;�d�Q2�k1�n�V�G�Mmۄw5��p\�&d��-�٭㟱���E��y���Jѻ&�ۅ_��y �~�/�6�@k>XXQ��j�����<Z_V�&7�����2R���_�v �ل�]�k���j+i�pGM�����`��M���Mu%S��0ݺ�2/�XQ=Rs�@+9� �a[(We{�?7pP��:jP5���G�����E)�?D�
��D�0!�rl�4>��<��5s���������!�8���(�,T����Ht3L�&���vM.�Y����J�Z=�I]��6)u-��RSk�O7� �U�آ�ǭ�YE�r
���;Pކ�s�������϶~�F	�UV�B]��M�x��碵�����ѩ�O�)gfи9�.����l��h���R��ro�X��䌂%6� 
��zo&�j�N�����0��4����߭�xh�W����x$Z��%�kXI�&
8�ȁR+��&� �.�[��x9M7P�U�c$Za{fo�=W�Y�������~w�}�(=T�h�{��SN�����l��$�J>_�?]��V&ܩ�_+�K�oR��e�����F�:Q)����v��n4�Q�hJĈ�G#��ؐ��ٺ�rS�Z��4�H����*R����a�l��*�kwM���j}db�tRY�$%^#^6�%���7����cb.���%�Ees�*�!�$�R^t�6����*�Îf��������_JX�9ސ��,#7���D��^�`�Z�6K�摉�B���/�t]B���g��Ǻ�><��5Z��hѩ�yۇ�_�j����7L܇3�M���P��ť�z�hM$�h5D
|je�)����p�R�"�lK⥆����n��\�T%���1�̑h5Dn1yr����"zF� �{H������1hbpG�����9��	�f���RDϪ��Z��IM�RS�r_S>�>��p�"J,�7 {�u�%f���:�q�	M#m��������NG��zз"vD|�07��s����aw3p0*R��}��d���������8{����H*c6D��y��F�A1G�ʃ^aӃ����Iv�u�g6��8��iV�j�㑦�!��!K��Mت�CH�p،g�*���� ������pv�& 4\�Xs$Z��x��O��遺�:,l����Si(�?����&�G��}Eū�D����*:��j
�9B9Rk]p��R���B�}��C�� ��zw�m� �y�*�ԉ�VF.�������F�(˽�O�˯�,NF`��>+E�	p�@h��8�X�H[��1��0N�M�r��K2�&��::�M�ϮP�a�5Ňf�z�=�tQz+�4&S�J���c��E�y�'�U\\~�lC�0N��k�z��9Vڪ����9�l�X�w��մo�Ț��,O�ZjI��$[Q������UhS����Pj�.�Zm��h��51S奚�$��y'���qN��D`D�W>��A��/yP�FX!�D�Hq@TI
=ʞ��+��c6����j������?�[�z�Y6�z'�pm����-�s ����Qx��v%�4�{�� ȏz����W��_���-��B�9�-�"T��/A���5Ǧ]`Kj��Z�i�i=�����E���r���h�h�U�������Жl�k��8wI���j���V��j�	W\'�/�� n�V#���\� Ï�CD+����:�;1�o���A���,�������>�o�����5͠�Kj��������k.^�(o�QD�K�Ğ�)&������N��2���oS�3��N|����͡�1u�2	\�]���W ��͞6���ߖޠI�^I��(Q���kp��~`��Jj�@�>%MH!�&8,	U����o��mzeg@�ݯ '����!�'v)�I���(1��G^�6X ��<�be;L!��n�oP����΍���O��i�%�V�\)M7E3�������zD4f�#�zY�R�^j�E/��D�5O̍��Np��Qs����Z��@����:� c�l a^#-|�՛\*��JZ3W..K���
nw��f� u�]Vub�/I�c� C���:�k5w�\��5��K���W��|%��hk$���&���PiǑ\�X2�J͝�p~����	���v=F��#�J���^(\	�m­���}dK�����9�|�{�o3%�:-(>��S�O28��i?�ka���m1������"�U��4�n�����Ėj@�kF��5��J��є@rQ�ޫ{�"ھg�蝎hop�ik���ag<��!/R��2�G �jI2�_t���ť�d�.b������������N�X���A{7w��x��2�:��S�jSd{�f,��;h�]�;)#����x��&�ә�	�}" �bʱ�G*�ݪ�����{�9C��Mɾ/��<n��P����dA[�h^J
%Q��I�z�O�E����6�ȭ?��w]�m�P'D�6��Z�E�2��n�7G���ُ��<���#�T�m@!��K-�#nE7I����n�b�pH��т�ku�8�*sؼ�Dw��gPR��F;:�Ǉ��䁛��    椆{���sJ�K9k�nj�z5�̺R�,��=�F�*�e7@
��kEsA`mJ��]�Iӛ�\����^��H�"����7���f/��.0���*����(�;w�UkKx3�����ٷN�٠Q����H��I�D:���Y�����Z܀�[�a����rC��3���fA L
�D&;5�=t5B_��:�Q���(/�їY/x�
��V�:�a	�]�z͹�F�ᯢ��[a�ZM���b�l��6Gpk[�j���x�	$Q�C�;��KG��I����]� �s��Sp-G��%p�ũxO��\ {��{��.������k�/E�%��*�(�V?�U�o�g��(��&"K��W�]yVC
}��.�rfN,TG�Ƨ4`:��D�ω�kS5�ҿ ���u�'�%���Ʒ��{��#�����BN~ƭ�����S�`ju�N��V�FV �^� ���7}#:�Ѩ��]��/0�G�>�us��N��#(�O-�T%{^��d�k�_k}>��Vu�x/�R:z����ز��xQx_<� "UL�7$@*�PZn���A��(��A���@|~+p���K�?ӊ-D�"q��d66l:���2+L�Yn�僥�+��*|��c���;�O�$1��G`>�zoi\�j	8X�]")+|��T%v(�D�Iw��K"�˶W�L�a��� n�1��eڬ0_�����l�>9�EU(s�1"��'_w����:�
Ǔ�[�"G�B���lܦ��X'ߐ��ȉ��p�¼9^�[���j�)��R�+W�]}/+�:W%;�&#��5x�Ú&^+A�P���n�����L��Y��5�|�	Va�K����҅-q6�
�)���҇=h��qc���᎖��7�Ķ�+A������f͔*��^��n!�,�V��V��њ���3���eQd�-��4��_����>֨I��Ic{�0�o)�g�O�k�֦���
���E3W�Ջ�CL����z�{���R�|P�se�<u$Z��gՂ��W���X߁P0�gkj�:�B'���d	�7U�,USa�q����F2gg��wv4�x�z�ʇ�ר}�����h5D�F�A���W�͜^��O� GT?�ٛ��hߗ��������8�R =ur�0��d�|h,��!���GZ- ��2����]�<H��%��F)S,��� �t6�m�#��@�,?�dt��	�-*�,�b$�+������5M�O�}h[��c;�Q���8d�z��t+d�l��(�}�*}�
5	��e@Npb(��^:�$�͚zJ�-O~��t�˼���8P&
�G��l�bt 䓢$�xR,�?�4��s�7�?�ߤ�>��}�1}o�MW�k`v{4�#��٢����T-М�7�A�p�w�%�2�����5͗����fz�Y���X���#�<��6Ap�(����I���ȁ�b�r�r-y��\���[��kK�@���ƽ��U�)�9}���A��U\�V`��@�φV�л�z��g��*ɕ:�̈́��lz�!��=}��*q+sT��W�&[�y�gB�W5C�����PI��D4�:^��հ_�7�%z����Cͺ���P�"�!yMP�4\qݛ7;3c��wH_����co����) �$q�{!SM,�t�� �wf�.ie���D�K�����G9���
�'���?��%��ԾrNZ�D���-�lD�~�]�(�I�+�|��g�W���-H�����'�x$�TD;� :сsƞ|����N��*�9?��LffP��-D�	KKF�"�CD�ߚjm&�E�e庂�H	$�]b�K/�K8K�٩��U>��:�_=��W�8*�"��o��w3
/��[��qP�nRF�:d	j�Z�ݣ�Ӭ�\c�um���{́��:R��p�в����*�O�+�a�l���H�����:{	�-0���H�`:P�, ����n�}@/�_������o?}xQ[���D��cS+����J0�Lo�	��Ӈ�/���ɹ�h��P��3�q:�n��s�\6����wvO�ZPO<��
���벰�8u$Z�eҍױCJ&4x/�Jٍ��!zg̀�z��F������G����l$����
�Bּ��M��V[yR׹�H��*�(^�PI@>\D�%[﫥K0�aG�QG���G�����V�L�PT�|N'41��Lq#��\>��f=�5s��U+OXa�{}C���~�kEV��Z&��{2h�k�&�x�k��5�8���Y�_����O_�j�g;�מ���z52Hw ���
��=n� /ۚ� 9���a�
�)(�՛WV)�$�,4��sx�����VP|��ag%��'��S�3�s����M(�=���2rzω/�Z�E�9}�P�lN
��F����F����x�;�y�����J���Ҕ�lO�Jx�7��DM�f�����^��m�}�o�n�4ޓ�����GV�2��#����ģ�q,�^J��9�ù��$'ӧJ�̎9�tY�4Ƕ�~�9u|�BI � L�v����D� 7\�#�S�p�w�d����h�f^���đ|���T��&c���MP�����
 �=�B���ô�X������R�}��˞�2����'[9��a�ݟ�yƀYt,l�c��������΢�al��硬�	��O� �cL/0�k���A��������r�P����UW�rSt�����2��BH�}���m=d[��ݺq4��4����q�����ӯ��}]��&
����j,E�(����%�@ʁh����{�8Ĉ1�m+�?\������~��}�����7���}�WV��d)���P
�|]��t��{�^i>a�C��W�\��M+_�����S��O^I{$�ʴJ�~C��x�1�Mk���RI.��4�sß[���ξ��Z�D7�H�qG��W�R�bP���S)y�er_c3w���ŝ~6l�����Sz�z�i���pm�*R�p4T78��,��Y�����
��J[�;{����VG�� �x��.ٗǹ,E��mᳩVY���s��I�/���P�s� h�Ndsk�h9B�c�(��T6���Gǎ���B�}U�W���ĖK}��l�Գh5D堅�;-Z��j�Cg_���|����J�-2y;�2���#�鷸$1B;^�4�v'P磣�>����es7�܎�^6����^{$Z�@�dv��2Y��&��T~�1�Z4����Mt����a�-��3?���[|�9��.���G_*���nBx�-�_���o'o�&�F� �����$�8�-p��Cm񙿷ֶg���u�֓nV{�4/��}e�����R�úb��7���xH�Fߝ�H8�dǞ�󫍃�f_[��}�ct[��^����� �R ���9d�c鎶V߹k=պ�Wү6�,Kۤ�P�G��Q"ug/�?ذ�4 �m����r ��k��� �H��������ep|��\�_�~J�����S�ȧ4;hj5g0��]��Kc��~j��+۔��}v-�d�p?�Oq��9��|<��9>Pv�x=<���n2���g��@�]��8� +O�Q_a�T�%S��`w���> ;r%|E��秺s���#��`7hn���EW�m4�Z�:q��J�s/�C6��c!O��]wUG{Eg���j���hI7�ޙO�}��l�Y�(���g䏈V���e�!a&�fc�oG���F�bK|5����&É$z[�J+�6D(7�zW#���y���h(>{���S�gE���?�[e��뜀�j�-�k���j��7mCt�pP]WB�0FV��NY��rh�ta���Η�g&��J��Uh�:�~ۚN�P|�Ҕ-J`�\��)ˊ���vN͜*z�����խ�
S{�L�	]TǢ� �t�}ւ�R��l�%Zcdʩ6�a/������V���{� s�3{`��u��bE�L%�%�N�&P|5Ǜ�k�|��� X}X�3i�� Fم\:'M#
���<ӑh�    �آS��z��w�����ِh|n�V��M�fDB2�ڈꓘٱ�����R������ jmv,iudv��7�4�o8,���"f�+m|L-�V6:$g���S7�L7;w���O�*��*I�N�?�S�H��cljFN�aJ���&��'^Y����'>Gs�s�v�r�n�հ[4Qvj���[��+�� |"DP~��@ޏE����0+�������i�ܴ�ͽ�v[I��a��YG<����[6��)��ӵu'>QU ����ؗ���4�1O�R���w�������8�Q��^�jRc+" 7�c|��U�W;F~�������̾�위EIɶh(�Z��A�
��8ltӄ�Y��Q,O��[���tk���--*J7DO?�a�p~��� ���2k_d�q��ݪ��-e���#����~�Q�.�H*�5���5 �+�P���9�aN�9�/���DO=��x6��[\�h�@�W�\�h�+�:�ԍ�v^O;�[�vv1�D�@���r��rfq�P>�*���;/j����6�W6Ġ��Ho+�G4T���該��6���A�H���fO������K�~�L��1d�D���ZG�'�N�f�����J��?�S���A�M2��N+���z�}E��DI�p�����m+V�LV*;�Z;�y�|�H��t$Z�QR��P5�	X9:��2�Z�t1�)�Ӗ��}�oɂ�A�M����K�� �_����<=� ��㔅�0���GU�FJRIE������f%Os��\�}>���49�^ Ul��y����Q�H䌐�׹�k�x� 0���9Stϙk`K�MI$���q��F�xk��<�0Qz�*ѹ ��ۉ[)G���
F�Lyyu����O	� F ���"���z���(�
��@�2�H>ܢ�Hk���D�a��i}X	���
�9u� 4!wj�5>j:=�Ӏ(��D���<�ѓ����xϏ�4sw�V��0�Ou��g='0�Es$z�1|�����������^Ka*��eW��p���aQ���4U\)�Jzs�禺�N���1�H��c\t�������ʒ+�j!r��S�gLW/��������'�GVI��qS�z���&&9Z:�;�:PL� ��U6ܩ=\d��>ĵZ���Б��!��vʃZ����FכΥD��?�'/���ƢL�c�76��}�ڛ���F�X�ݢ����`v��ƼJI��#ї<)䮤3B+@���o���~Z��>���mt��6�rܛ�?ױM�ț� 0S��F�uM]���)��GqF�e2�5��;�'�^1�V����������9$��2n����0�B��5�RPǡ+���k���4�%�&RtƲ;*B��%�5H~�o�%�]b��ҋ]��3�l��d����=Zo�u	E�wI���>�����~���ϟ��hg��D7/��f�,L�L��n�ct0(t��3�_\�ϟ��G���=�l�sY�9����rH�C�5#�G�`u�({q�r���K*��K���k.��Ts�#�$?2�(�A���,,����O�ժj@�
�w?Y6��+���v ��K�T;EGFE�s���K��TQר]�h5)&=�[����l�us�-�n��p���#�����Ԡ�Gաmfw��n�mN�!���v��6Y��n�=;?J�G~�˛�)*b�~$��%�D9G(�� (rYDb�`j6����|ĸ��s��~��r ��筕�t$�����D��[�<&'ba���I:�r�/���τZ�g����P�q��_I-8�6E������$��
:�%��)�9�M�y��eo�����}�2���^�77vku�V��#�S�0N����� �.z/"� <m6�ʆ4�g����H.s�(��wr���F��0h%:��:�TKYT�<Ha#�W��9m a�Z��)x�P_�~��M����[J�rJ��"����������������@����h��&K� z0"����ꦷ�����}ˌ���k[�h%��9Z�}���mA7*��Q���\��u����zȄ�}�kn�	�J�+�ar��ޙ�I��VJ��Ӑ����l��K�Đ�~j����н���Ht�q+I�V�H)��;�YԠ�8O��i��A�~'Tm@4\���b�V�,����T�8&W�7(+5:Q|��m5ci�]�~Iy�!�	n�D�_��#v�-���gᥡnɐ��)�����Y�")v�sĕ;�N}��b�V+7i��$]pW��M�%6r[��1#8-4�1`�fq9>��su¦��,:�Ơ� [�`��֤bu ��E�5Us�&�p�H����Qdf�P�."�T�A�oS��nyB�o��:F�ܑ��D���)��h�z�p��E�4ChA�����̘�_�R�K��q'�D�3�.ʹQ��+��V���+�y��Us4��R?CF~a��i&���u�(zxx^c��-�Fn0s��M�R�*������ �x�_X�}�Z�ܑ���
Mj�z��g*bNQ
��z�-�'�h�sQ����381WM�Ht��sB�05��Nw�+<����3����m>��6e(��绰�>�Y"'����c^醏�(8&惡K��3�*%h�;ZMTp~��x�L2+�s;��D�K�-F�k.9~p���XyR�	����w9�mkά��4���m�`A�* Hذ@A�d2oR�]	���Gs��_���Ұ
��= ͷ�� ��8��7u�K��h�X�a|�DZ̴�.5\3r�:�p_b�ݪ�{S�~
�������Bo�Ԋ�s�:��O�h�U`c�G���)\>�\n}�L�Y~R3hgƪ��ho���3�j�x���6y�k�r�Ա�=ډ�3P��`����&q�)p_�vG˥����
��n9.��A[l(*w9��wf���y��o��UAǷ�}����q	���o����j�;��ٿ1��#�[���ޒ���q��y|������<����vzl�54�z�p$�(������n9�I�{�=�t*~y�z���|po��.}��t�8��D[#��G��U�$��e@�l��b�E?��� ����m�?�k����8ꝵ�_;�Q�G��1���H���t�u"g� S���폘��f���~}�m�M8���:.��7D�<����}�A���]e���(IYE�q���q}yگ](�����f�کb:��x�M pG���	��8�l�*.�8jp��gi�̥���?������o���g���X�w_}����������$}��������8t��|5� �@�x�I�ha%��'�����7��^�H�^R���(o�D���m����վZ�x�3���۲�����)RG���x��@�-{q<�d��m�r1�:`��^7�0���g���y=-В�<�R��3,����	W��b3��[�*Y��l�}XR�VD��ɲ���K�,z�Qu��Ԅ���էF���q���Y[�<4�������I̥�K��,Gp���c��3��V��>��.�?q���&��>�Њ��#���I�EY�mU���&�|#	�}ʕ"z�Ws��e�>����`ƀ�WG��QJq�&%$���n�J���B �Mxj�ZΑ[�J\�s�d���5�Ck��][�:רY�w�����yo�����Y�9"�[K�^T~�LKIȔu%�Urn@�T�Ñ���M�2�SD.���t�L��9�=3��[^���e��[>��}˨��=%@����G��o�]�Hn�*h�`0')L�DFv?r'�9���}]N����YT��NE�>E_)��e��>�Ts��R(���=����\.����f�^�9�S:��F	�4e5P�
��j*2e��o�f��j�ӞD��V�N���vR���յ�*��͘p9�NK{Ӯ��>ԓO޽|�>_%[���3�M�;
@Z0�����#/���'$�*e]�	�D	�?�'�T�Š��]������]��A㨴vG��qx�y����Ĉ �rt-C�ՌzP��    ���\:vh#{tn�1*Js$Z��/���e�úF���Ul3G����4f���~��2g��ϭ�������׿��_��]�n��᐀��  �|֚8z�.sD�)yJ�~��\�o^�"d��	V���l�K��po���Yt3���\�9�n�2�X��Y��m=���]-v.����txu@�0G�� ��7�I_,NI�4���.u>A�%�j>Yv���b�#���>ђ=��h�$���  �Y��������G8�=e痪��n���te4�-G �.��`�hi�̵ M�#߱�Zα���t�L ���Փ�R"d��ՠ�I_��-N[Pׯ��z��c��q[�6w3�j�鉂��쫡��B�,���Z�!)̹9ٳ��j�vBdj���ѯ�Tt$z�1ŲC]p��
6�E�F��a�o��<l8w�&�6�uw�Fm&̑mTG��!��k' X��=��9���Z����l�Yz*k&u���n��9Aڃ��E=�vo!t�$wٴl:�O�n���KR��]_4ߊ�~����Cx���}���42@u�ȼ�=���ܜ�KJ���v=����n&�ˬ��c3�M ��zt�ʹK7��^�-/p���h�y6��uBUܮ�d�{P���vQ���8z�/���N6E�Z%�5#]�T�,٣��kԬS8��j�2������K���_��ʃD�Wi{�-�P��Z>��$$;�Y��Nv�imӀ�icY���O�Ht�qW*�	�DEr�:�/Z���I>��#�]Z�͝�S�/HZHkW8~�F�&8��#�R~����x�⟱r�U��g�$[�U(�'��r�j�r��w�K��U��R~6�:;�T�c��1�ə��Z �x� 	/#��1R���QIVű���֏|٠|�U�I:}�s���@��KQ�P]_��R�j]��{rg�]��y����J'������,qH��!YN{���}x[9���O�ׄ��&JUU֚��~v'x1��ʹ��Λ�7�~�Jt�q��'��h��[9<
�9�{5@�L������J8�́r(�>��k�:G'�U�SG.�e�&�s�������ˆ�]��z)pY$Z�#rhήTh&9j9(@�E�4�>�Gq��+�'Bn>$ض�	��ؚ-���N*�(�������t�8���lP�ٛ��q��ڏ��I8shUT�]�F���ނ#K�x&w$����$�!9�6����X\��T�259�������y"u|�l�8����?�T���p$z���|죳����	�&��&§'{�xԋ�46Wr��� Or �F.�#�zUd϶��'d��� �M%4���j� �)�w�W�C��F�E#>��>��c��U.Z�fQ�l"�N�.�b��`�?���b�4�F�#]��P� Z�aKC����GX�Ef�x����������f�+�����Pg=��c4�( �6K�ZD���[�W-������Q�M����;f�$z�Y�����;���d�]��,W\� (xjs�:.��*2�w�5��H��#O`:͍	�&�
�;\���������(�M����I[��x �1��C�
�e\˖Du�bo��w�nCk�{��P�� /���FRȕ�K��F�T�4D$ �d�Rz�Ei>��f��4)ܖkii/�'������巿{�����W/������KgvĪ"#���H4�v��=�+��6�m���ߖ�˼L$(B��p�??U�C���Y�n�B�I��y��̾uP���#ۉ���G���������_��o^�?������?��?�!��V栝ޛ�$��VS,aE� ʨS ��C�Hu�[b3�������������Ey$����V�m��e+Oԭ��,j�l�\�jɛU�ߡ<,M{1:32��������#��a�-��E$�v�s�iV�<�ؓەX�i��Y����0td����6\H�>W5�	�s��*S)Z�N]�.dH낅=�;�q?��Q���L�D<p z�!夑� �dW̔����C�D�tzb�N͐ڱ��
o��8�>r�@F�yZ�����%�֋`C3%��+{�r���}��B7&�%5�w�l�Ix�w�#-C�gFp�/�L5����e���}S.h@�������`���h�<�������I�a��^r �����~KZ	���^�)E=8��������6j��t�70�K�r�DI��ٿ��%]<-�fɅ�&P��vn��cb��܃�8(��6�*+4m��q&ޞVź�{��G��Ţ��%�VkscϦ��#��[h5� `U��2.�˷v�oMo�����\�w�]9B֭�GiQ���I9�����~)���u嗦{���Z�]U~��6�y���{�x�{�-Gh��Q�ʨg �E���au�U��=��.���Ԯ-/�
��i���#�ș��N�@	 J1ySE�Ȟ���<�`A^uM�N�@>^h��:M�"ZWT�H��#8B��z����Q�����kd#��=��o�J����]�@c�+�7{|�l��+C�6 ������9����ܔIaw�����Ӗ���	���Ւ��H�uP����߿��gsHʆ�(dN��{:���&�i��$G���h9��]���AF��:���(�7���NCr�ΞfM�J�M�:1���h9im���1�ы?�"d*-i
5ޔ������]��_E���_j�Ϥa�B�ΆP�������0�#��J���ه2�-Y [9T���M�3��$�9�5�Vo"�Z;7�K�Q�#�
Ћ�m*�v��L��ִ;I�ڏ�oK�Ã�5M%&v��� 7�}Sg[ˎY�2u����gl�p���o|�#�i�!\j6�4�_���K�L�$zx�`3�߳p�{'����R)�{M��9�̧��M�_q���[��L����#�j��!��<��h���㣰Q�:�`�Pw�gD�������ٜ4f�n�l�������
���������gG?Z�[=8����c"}���<)oo������8���:�?�	(CUs\�L�W��1jY�f̫���L$��DO=B������S7�P��noqT�����f��g.�P�rl�Z��z{�g�S�@��6{̀�٠0� 5�c�V����^��be pL���G�&�ۅRV5�Lԗ4� ��P�����f���+A�(d�%�tj�,�CC�]�M��DI��LV�dyp���
�(��ZkɅ�Ir{��D�0LɉЀ����TI���ZFr��I΅�ssOT�o4,.�[<^-Q�ȇPq*���ę��%d�b�[�6Es����C��eB���'�������Ht��N��Ѐg���wR���,�҂ˁ=�g]0���g<ёh}�PT�?�!�����8cJ-�aI��%�����G��V;�8�q������Ι�*) ��T��DO<�y��2Gd(��m*��9�,�W��j�*����X��Q����W�n���o�w�����?�`E�}U>}\�Kq��_�yg青�҅$33��M[/��kV,�����c��I3��p���J4��x;��/�KOl-��S,�-fj���e��4g[�ۊ�Nz��4�1�Jt3J�=U�� 0�P`�]�x-5�xX�Ty�q������j_��[ç�'0i
������D3��VI��7�¼�݌�r��7���_�<�%72Aڞ$�����|��+KRT�R�؇�,?x�M%;홗o���>��-���xO�Ht;��T$$���JaL��&4t�9����w��;:��c��Ґ����(�>@��v�g��n���Rq�>��Ssׇ�^������Q$��Л78E5�ɞ�S�f�}\V[ފ��A���r(HRXu�m���Zq��'�3�l�۟�Jr�豜�O�(�w(xT��:�����LT����2���ti.ؔ�7.���9O�cT�Ui��[���h��G���Jv��D��}�&�稺���M�!������͍�����k?�Q�DKV1۳����i����R��b    �����aq���ˇ�k"?��G�>��'��D�J�X8��s��+��	_�Q�o�­˒�yG�0�+��h��]QI�0�!Zv�m�|���FH�;G!ǉ��s�1���.��zǇ*@�z�x$z�15E����(S�b���(��E��M�]�\��63�<��>��2jR���*eB8=��BU�(Q����p�Uū��Q�<�mw�|���/�� ��N ��V1���I�	ds����h�@Z�aI�U��CU���N[����`��C�Ll3�}��r�����K4���L��	�zl\�,(E�j:��.z�³��hGYLtG���@f��z*F�]p�E�`�k�X�|���컘= �K	�Ǵ1a2�VC����� (��>� 7<z�c�ƴ�����rv���������G��*s<Z�t��@��~%޼|�i)Sz�󸣩�5�[wt��=1}$�Ũ�� SA���7��(�|��] ����Н����e�/-�t��&�w�OH��Ht���V;+�,�z/��k!���}���U����-�D7������=�Y�x8>��}~��|���˾V�k;}$��Q�.���M�vG�� ��o4��?~���m�����D������$Z��s7���|�ot��h���B��UJ�ZP#�)� 5q�O�F�YU����岳��yIӳ(xKFmjb�q{$��zr��k�|�dDlo��)�;j����b~�U��t��2v�\�Aɱa��%�Ut;Nm��f�h�i��Z��v>�H76]���*�,�w��o�ɟ������ݎc8��u�cUh�5~��g�t����-����"}N�}��P�H��|��@-R�B5��R��5�I����O���@��.���;��u�W��=�<� ^4�*o��豎XE�o�F���!�ph�A�{_��?-4Q�p�N[d�DO="�n�����9�
�k��)|8�dO{��?���;U���������h5D ���8�vS�� Ȕ�:�[�:�ue����M�\sMFH�~���Y`�:�(�� }�B�
-�?�^�����{օ�ex��҅2�F(�S������mt��������H��������Wr}1c�oSfҜ���N�3+��H�w������[�[n%W��-PKG��'d�`o$+_�&9`J��G�Z�M�U�-Wb�G=���9�gxQ�޴�(=� )F��"�e��ep��YaW�;D��D_�J� �ԓ�p`
5�5����m�Κ���~��Ͳ�j�ڪp y|t�z��K���f,brJpp�#u
~@|8� ��/�� �}�&���_�����'���}��\Ap��Wi�����j+ۡ�mr6��J�6�����6�V����S��9��\u���B� ����j�wF�������O�������������^~��������<���������?�o?�׃��#�*�b�&�$�ԣ�%V^�
�|��T����D���_Ni�D�.}-�������ǯ>�e�r0��0��)�=�u![Vߖ[��9�6=��"\e4��D{���؋�N��Z����y�[�)��Hͱ��ӵ�DM�g�X�5cTng'��hΦ�@g$�[��-��Ji�T䛑8xr�<M���vg��D5| �-"�[%�u��4�F��-i잻;9"v�b�8�:�;K`�[эk��͆�� �z	Z���G������g��mU�s�h9S�_؟���/��-�߳�?��߾(6��������?���>�,�$�t
dK4v�F)I.ԕ���339�5gO
4*�J�7$ټ)k����*��M���֤�Ұ<�#ř��+����qP�~��!�G�� <�����DaM��x���=1��(L�M3�J�i���^cM��ƿS� ƥ�D˫]3��P�@��9�4 �`�〻|������/�o�i��Ze�M_�J4����q-�FR�H^�mY��YX_����&�*�Y�u��ɨG���h�y��r0�ؿ����(�)�K ���<+����+6�jmc'�f�ϭ�K��!Z�U��'�6
�Q���sP!D�����LB��1s���c�r���\����Ǯ��]����R���US|T�Q�O�L��_5ܼs9��9({W����j��jdg�}+zi�$��W}$B���]�e���f�|ulq�jMG��ьw�e$���n��P��U1�w�Hk;�h�BW_�:9'=�$�3��ho���/N%�1�VS�-��u)Q�et��0�;�M'�f lʁho�b{�*� ���QW�� ��+^�)������M�"e�	X��F��Dw ��]ˆ;,Qd2{e�Ǔ�`����R�����Xǹ�I1�:j$����cL����=E�!X�u(�����5�W_��c�T�f�-�$����SiUl�h%#�σHW�̣/y>R��H1a�HQ�H{$Zad���(TD��D�(ʺ�T�+���ޑ2kjV���lu��t Y�r��-�(���O��k�I.K�)�ػz.3�ȋ(%��
�/�{�A7㵤#���������2JȘp`Z	C��v>I��@{ɝˍ09�|r�A�5�������~L�j7MpDX��9�uBf�+�{��v�y��P�e���,ґ�G��n�9u�I 8jEyY�G�&Ş����W)?Y	ޡjݹ$�{�Mh��:v#��|źrnEa=�.Xg8B9�,+���nC��#����l+��l�jd���&�	6�c
��UH}�8�)��u��h��ra���ū�,���:�^������R����<��Ъ��M|���V�3Z^>��ʾ�'o�x$Z���*d�B���9��Ɇ�oS���:NMC�|/?��͟�W�g3h[�˱��)���� �0�ͨ+�)lѼ՚MO���mĭ_��ĀF�}��X��6�8�}+�;�XZD�y����w�\��|{�&ӷ�\�X+�8^#�w��n +&�u����ݳ���a�W*h�ȟ�J��I`��V�������S����Y^M/ga_͝YPt�HtcR{�MV��Q��c5Z8��!�����\�����9'��Eg%aԙ�T[@��D�=#u�>�[����k��{���8��_NIr�|O���tU���srqQ�!z�*�F��)����h��J�&�����{e����0j��O�0cϡ��N��-lJ[����hA¥��^�g}��N�6�A���Y�%���Gt݊D�}��9A�M�F9�t��R����?~��i�J�sf�3vG����k�u>���2{�aq�Z��s���������q*_��3�m�Ͼ��>�sw�&7BwT��d4����Ή�$sI sL5ǀځ�an�.0� ��%��&�KG�8&.0�p�<:�u[9<+� ��==<|̼g ta8�O4�fE0V]�	c���s#��]��a���GM�N��8p)Q�b�Ȯ�P�I����^m�����59p�[�L�ޘм3�	��ܬ���?��߾�O����Ç�TRm�ө����BJ9�%L�%҂�~A���@[0��n��������EN���8�W�D�G��Uv�*[�4�we�U�R-��ok�L��;��)=V�r��}�"G��Ht�m�\ �  Ll�Ud}l�9��V��ﳧ�\O��$w[�fW�r]5��)�:�?���E���p�K"4-��6[!Em]yXQd�9�~���.�T��6KtPG���l��S���,@�<X��2����w�.�9D�� ��2@�==���J��	�Kl��&'��R#��Ss���)E��K�����Z�)�?�Z�r(�dΐl�'���S�a&+�����ӟ��/f�@\��*}$����L�����8h�k�ɺ:�Q�f��s���F�#Ѻ �F'{n��O�l,��}�hİ�VTY�3W��Sy����6�ew�$�
]��Bp3��[g�շE:��4 k�(݀�h&��С���F6�R��26�d��zB    ���QW�t5���P��!5��'T��-v�m�Z=�'�9���ϟ�T�wrIśz�y0B��Q�p����2N����S�Cc���$�n�~:�|қ��5*wB(�t�׌4�*�1R9{$z�1(Ĥ�G�3�p)>��(O�f%MQ\���I7\^'}x�nis뷜�ִH�l��~�d�a�I�J�TΕ����K�|નʃ���(U���������}��	cޑz�HD�p$�����MU��~P��8�TY�b���u�wo,#��l�1�)ߪn�?�zo�؍���]�@�`�A����������ՃS�\=ˍB��3�ܟAd�0V\�D{�G��
�zņO��%�s�i�tE����sZ�RMWc���o���;9^8ڏ�+ї<(��*��������� Y�׭st�ܼMЇn��^>2��3�=��cg牽�h��+�2����\#��=c*P��y���I����~����1E���W:Jv����rQM?5gm�[���@š6�t���[�5ފVC4U�L��	�N%k���%$Vh]�4��o�챪�4۷����}�>�ݧ��IR�p��g_;�$�ه@�Bd7Ϫ�E��FM���yhs���j-�$9
o�5'a+FD�C`ۥ<���8�Ssq�Z7E_�jzc�@l�����M'�o!I����&�$/V��V�Dq�@��j�+��H�L��o�sO3a�Nk��Q����N�춃�?c�۰�4ͦ">LFD��I��b-�V1�f��r��=�V9`.uJR�ϑ_�m1�R���7ކ�����,&�4�����5�X���H�t��Bu�Fs�Q�bze+�:=�������r��I녪:�{C�B�9(��k�r�g��$��ܑh5/���B�8&7�s��@5��	?Ԝ���K��HY[;A�i�3�υg�<\�XV���Gx3�U�����?��ءP�_�k�ǲ�c���ꉢFa�ٰ|�z�_G�{ov���J��?;�tA��mɪ��so6�䫷�'�l���j��C�
;�՗nEЅ׀X;"��-��p�=�FI��S/�yc�`�C�V�(�h�G����whf��LD�ޥ#̲��e(4_3ms��u[)��2�vƳ^(��=3/�k���b���<ոL �H����X��y��H��Y�g��SU|�țB��t�L��&��� �}S���V�t�z��#�b7" ���d:���LNa.@��z�jF����h���.s��	h���ރ.0���:�Bwg���i���>z���퍦J!&��A�{fq& �>7\���N���(�hy��W��xs$�7�V&x�%?U]R�}N?������1}��Z=���>�$R/Yc����
�Y�,1�O�����3�1�I�v�mP�S>YYS�	$:�җ�H.�����}���Ú��v�t��ܳ��lnC��#�k�9ށ�#vB+;߸B����#�|ʶ�]��=LF�1%]�	yi��TO��P*�+���U�jV�P�@AZ��ٙ�"֊l!�sR�z�Q��#d����;�jC��Aq?�0Ґ�������:8*�b�G�� ���[:�K�A��r��bK�`,=���ˬ����{\���eג��S_��F����8�W�"��Uŋ"{ M6�)&Hޤ�&YT�4�@���A@�'���D�b�;�#���S�dfZw�𗙻�Z\ؑh���#.vpM�f�Ld��gܫ>׬���,:[\y�D�fD#�����Ϊ���a�*y��O�z�sؖ����Oa2E^X���Y��Z#���1���+XE
mSt�rH`��8s�M_�=gT�m]ޭSǏM a���Z�P����s�ރq�6��}�X��0�6g���`�99�IrԖ3@䥓�x�
=�z0ꤜRΥI��z��o��{���]W-M}�����1y�<��:P��T�Ih�܆�����+��TW������M��yCr$zdt��*�b��<k�f����˼(A�M������U�xd�ED��w��#o��E��8N���	��? �;0�_2]E2����<P>g_w��/[�������wK��|����ش�������hjYrtC3�C��=��ۣ��N�nї�z��Oek�7O
�����h��X��|b�}U_��};��H�<����o.��@�Sx"Z6b�	�#� ��1��<aS��b�C��s��/�9���^a?P�sn,Z6"d!�?��i�3.�9���f������6�wn��UB);�� �ع�+zLA�wI
�Rn)U:�l<�+9�OPs��d�T眰#ѩ.����D�]�"U� G;����DE��zo}��g��,��𲶘��~u*Qzc��F�S]dˁ0�gL��0�8
�Mi����-�yXwqN��a�Z��X��D��й�+�Hg�a��^���F��H����;�bY+"Ƕ��``��S]��5	ւ�nY�t$�T��l�-����ڕ�"={jo�2�D��p���[�r �H�+���7��e�[��*�X= ��w���J�yS_�VM�h{�� Gv9:�O�ZC�t�Qw������W��?�O��M����ޯ᠜���Eߎh�wͷ�ȡw`�1�͖3#i��B�l��&�\hc�OT9F:ŵż%ә�'M/U�dHNu �]��
SbbADMJsl�%���s�2�� ���z�D��pы,[b�:˳.x�T,����]Чl�Z�'�2^�f���	���1Z,9e�R6�bx.w�^p�<���R�r����44�����,�W��r���0�Ϩχ)��Km�Zg6L/�ѳ`�+��%���j�N��в/E/7_mR�Ф�nc���-g�h�̣�ȢGW?2r�A�^����m�p��U��1ѼfFD�	�8��D-䛓#�#ˌu��j���x-םXڃ-ZZ���@;7�I��p{�X��L(p�5�LW�u�A�Z���z7᪌Zp��VM��K�=����I���\�I���<���+M�<�TK���YHV(�P'&d5r��5!�[���O��kG�\�y���^�
5��֎D�{) �N�!���D{p6VZ��9�k㭻�=*��Gu3Ӟy;���/p*vD�v�v
bg<I6\��*X\���;l���ts^pК=���d�Js��q��J;եI��;�G��t�J7}�#���0��|-M�f���&^xU�u���_���͇��?������O2Ou��VN4@�-*΋:�����R�.ҞL"��r���O�uՍ��h���4����|��gjL���-�?(��~�]�����#�:'E��Ȇ#S��5<���M%�ժ�Ψ8Se}�����:B�sg�P�Ŋ��+`/��y��"����؋o5�@�1o���TS����E����s}в���,���X�s���VZ3�BgЌn�h�������?����o�_���J���Jy+�k����H�O�bA�F!�K�J�9ɵ�Ծ�ZϨ���>���S��c����Z �87n$z�h�V$]� �кe�C��H��*�`+�Y3c��򅎵��?|�?����W��`�"�%oGt�^���Hr �F��{K-���.�F�qq������iw�v��RT��Y�;�s}�H�bK�����+JN�X
:����V?�2Z�e��5&g���S���~@rj��8�%qa�4 7��'�cyi�#w[�D��d۴��M�S؀�V8'�;����_4}虑��s �	��(�=�\���u��<8�#��-_W>nE�I#ijK�� }�»�
�˲�R�;i�쾓n�C�.�d�FXŕ�~���� WJ ����^�WV�D�I+\���r�[�(JJ[�e]��K�|:�g�
)ǵ�x�D�O e�&!��W^L�\��t_�>ғ7��<sY����tO4���([��v�YǦσ~w����㬼(��!���Z8��r^ڀ��1��r�k�E�|���g<Sġc-�BjC)%��Tw���    O�ږ����:�0WF�*:�G��D!.� ���v4���Ɩ�e�餵3%��|���|��RPI��"������Q�s;�����`/��>�SL�6]
����.kg�DqN4Ȥ�mm���M7'��|��Q��<Z�ƎD�)d��9� L��+���93`�x���U\�񜄜6Ys�t�mCh�?�q��	:p�E�{��6[�%TIYX ����#��� ��%7�%����C�Qu�z�?>(/���>��^q����|Sx��~��� ]&碁�Qx�o~�6[����q��Ux���}2�=����d�]��M���J���6/��F��0%�������[	)��+O�\}C��K\x�3�Î���@��I"�;���{��c�D����@\p_T@uʓ��Es,i'��Mk���ovM~����&p�F���TQ��5��j4<�ʥ�:�������k�"M���L��En/4���5'�|�'�|�b8m9Y�fd<-�Y���c}��SF
@�����>�
`+�9k
����#�纋C*�Ǥh�f���Vt��9Q�A�/�������V�c+*�����l��Q)qhx�mOD��V�N��Ȣ��J���B���Kۮ6�؄;��0M�b�bZ�۴0Z�N�#�A����`�]E�7�)2��dV:��J��>��*[�ӑ�S����C���?4��Q@�-F���
#�)�~$�X_����L�!ƞB�q��iR�Ds��S��Z��1�����n%� �Wy+y�������
t���H�n�uڼ�C�5w��%�X-�pb$:с���L�ܐ&*K�V��)fSYO��Bj�L�8{<K-4aB�>2U�a$:сΎ�����@ŵlh���qrVd�/�y�i�o��J>�Rik�*:�A�����e$��ք<-?�/Jۥ����a�!Rio/t���!`�mhI{��C�^�	2����ƕ�"�
�뀻$�r��X�c�I�vZ�r�����i��^���HӨ���ZK[�l��bj�	.4R�d�1k^ǩӎ,8d��{�Pw5�6=��JtԚ�U��	�,���&����Ȳ�zr^����8nɍ��rm��e�����KWo��N��=z4�p7s^Eꊫ��P��%rq�@ɡZ��ZLj���r�`n��捫7�w1��t*�d��[?�'�+F�����W���5"����p����z�7?����ڑB`9 *�ܾ�e�z�^�x�8o��H��$�FA
N����Sl��Ҟx��AV�@3�Z��Pde mPK ��#=��ŗ��q!!I^���6���I�b�K��+��΀��x�8�@�5Q"�c�цwF0`:U+���}��5 �h�.\�|�� gT�VK�)�4M3!�X��eC��N(p���/r)/G�tB=���B� ��>�F��0o)r�܌D�����2j�� ��M���������uls����Μ~�J���6��e��W[�UtԚ���&�Ysȡ�`�n�����ɜ�Y
Bu���ڷ!���X�Ӭ�[�2�@����w���3���4�!��ʅ��1���̄��匢�Wo�M��S]$���\��(�T�u/�*M5a�M�٥>.2؄/�w����L���h�+:�G���%��#8�R��ڤ�����:�'�����餴���5�Ğӯ.�)KѴ
��YgM��ǿ�ϭ��G�EFo8�K��l�,�Y��ڌ��m(�p�M��4�
W����碀f=��r�bfA!BN[��#�Gzr��FS�9I��6pm>1W�G���E��!׏�a���P(w�@�Q�30ϯRl^�W��r$�HO�Z��xVW6 _ ���H�}�S��l9�h�H�Ԥ[pF�Ez �>A��'W�܋������'�P?)�D�bJI��S�Eg�[V���R����H�\UUZ�z�(]ޟ�̛C�!������qk�(�@��n�cR��j�:��p?b�~~�}`t�ʩ�нI�&�Nw�7ʹ#�&��nb�Z�'��Ȅ�}!XN4�K�>����� =)�\*ӟ�k��������Bǣ�4�AJ$y�*��:z�3��q�[����Ïl��]ѩ.J��7!Q�T�q�&l���Z�9��l+��~ٹw�'�`��ڑh�qe�0����.#��7Tv�Xb�9����-�z@���������������/��/��_����/�����O_l���'�(��ջ2o��=�l� (nj�xV#}W-)��I$ķ�	���ln�'uA����?����i���k��|��+Ze;�= �X֨ƣ��"a�X�Y�LaM��eM5�����_|�`~�������}pч��~* =�l[t�O�|Cr�^&�Z��Ҍ /�������vC;$�T�+�]y��H�5J�L)�Z#V�As�F�����1���a0�z�d��t���/�	/�#��S	���b�	���%iVx�F7Z�ҞQ�~��е.J=�f����h �Rc�xw�́s&����]�9��u�N�����\9W����ܻ��o�wO���߶vsC%�Ht�ښ�������lt�T���4]��_F����?���ܞG�7*�ppws��&�bv�5ZQ��-S6昌U���b�3���Ar��lݭBGs�o������H�l�dn
��\ ���y��:Z�9'L�K�k�� c�[篕��o�|�o�%�(0^�������uQ��1�_�MQ�Wh$>�тU�׋���s����L�2�>�A��Q��f&�U�G��!W�i2˹	�C�,��X�"wt�>��'��AsF��1�@g� �8��M�� ֳ��I�ȧȠ��J��)m���pe�W��
H�G�w��Z;�����2x�r����1.��$SLN��߷�
�lq=�{����Q�=�wE���Z�)��~�E�'ZÐ�+\S�v̱ѷ�X��o}����?���?�O?���'}�Y
�վOv�VMi�7Fے �e�7��������R˗�Op�gN�m��� �S#�Qk�ּB͈�p��Pt��\��\��/�������;.�� \EǭѾ�xm�A�B�Kc��[M=��>��X{�໢��B*�� Р-.S�`��&�Q������	��_~�Np}UjRy�V���|��՛ӛ��>H;,�&�����"V��cs���7*+����������7��"	����}�5uSr�@t�Z �ǚL�$�<M#�W3�RK�Yp�bc�-��n�CK/Xӻ���2�J �ȃ�a"��ȗ5�l��uyO���MP�
P�.�H�
j*��7�Xh�	����N�Ԃ����B>�H������T����o���ŵ����M�})nA)�$�N ���k��
r�rm<���4A:@T)�LC��`�xZ~#�QkB�X�%�����B�e�"��3�&�j�4�Z��X�d�::����d-��B�|7���s������}�#�j2pK�<+@	{�S���q�z��T������g҆|6N�(+X���/"p(rah�A��#��T���#=e�h^���7��ц�j� ?s�\�Z�Iyd�}�g�JY.���_,��P�$4mO��*=��,�i�H5է����>���R����C�<E<8A=J��2%|�P��n9�mE|V\���<���C�QH����A[Z�#�i{0ϯ��mM�&��4���	O��Y5Y8Q�_�݃�S�w�b��1mv�1�	l�7oePj$:�I.UPN��98	�� ��T
P{�j~Dw=6/�Aj��.ԥU�I�G�����Kٱ�@P��=j^e���� Ë�<� �T�[���@t���K
��A�*�r�J���ZE���N�ό��΀Jő�D-��R�,���G in��RjUIٍ�9��b�'h�� \��5��F�S]�km� �Lܳ6�����&34�,z�[����i�"͌�5�y���Nw�"��g�`�Z�6�.%K���s���kP,;��"�pd�y�=@�u���    Y��eF�s}���3A�f$�V�!�ئ�r�t=Z���9�ã�Ii�q���T�D.n����u�'�ѩ.��Z6:hsC�
��@�	xK��c�Qnə�⠚E�_Hmtʛ�襦�	��� �Qh^�;2Ue��hҖ����ۃ��D��g����m���@�^�Aζ���ruȍ]����0@D驔�mւ��P�rN!jQ����T�r��s��V�N��{�am��������Y$FrP�����Ի�o�!��>�S
�|▙k(�*�"��5L�z�Jbm��{�~wߜ���#.�D��B.�%Ov�kK�uG�ߦ�be��k�^���lJ������bS�0�x�O�˵86�vg��}!W�|�/�D,,@%���Yk��P�*�r5#/��@�=�	<čD������O�H+� xի��&�jItw��л�2�nVz�o�3991%s���|�l��X�B`3��~���7�Tfx��o@𫛩�5+硼Ob^������܂����t�[�F*���D��/dR4�.L��Ő�*��e��yyl��F@;T$&�	ߡF��M��c�#�����ֵ��eh��pM�*ƪ9�	��"G���:3��MT����N�D��&z��:��Eg�Y
��I�@!v���'((j�㑚c�P�F����s-�0ғ�1��)J�c��jB�v�9��0*V78�	E��z�d�� ��9~�Nu�]1Yq���hs �g� +(��f��cT�aH��d��ci��o����݄d|u&�4I{cĕtj�gSk����6��x�L���6Ji׎D���*JN� �����xK�Bd���T���:�V��RȥAV[�?�o�S]�de�7�ӫ�$�&WD7�X|򜭖?��{�3Q��ɷ�%;��Nt��Xy�"�Õ&hǒ��g����hvwW=�;�14̓;�甘�U��m�INuPh��f+s��&��X3Pa�R�q
��������9����*�D���<jQO4Ҭ] ��攩Apڦx9i�xr��+�d*[/���W��n���b-�+�S�B)2�1�E��E�'m�K�n\Jm/����p���8���Q��|[�.q��9 6�s����#=�߰��HP�-������`��9�gŻ���a��\?����b�C#C�2�y��I
�ŽA�+���pS���C=�P(\$�4�F�v���6����FD�����>��	��Mp��:��X5aǡ��6\.闚o01��.��[[�Gz**���M#cŀ��z���^�	����]��v����v �qF*=�Xx[s���
G�X�&�S�(��i�/����p�f�n��o�|�r��@ì闤3�Xk��#Ѹ�".�,���Ӊ�Z)�B�e}���w3��̟zFA��i##��M�����=��)*� �bM�3
����p����Hc}��wr��� ��ZV�nE��)6��(L��,�F��;bk9��M��"�f��a�� ���s
�������5��E8Nd�����a�Dt�q�OC��u�"R�~"�etY�H��mY�'����R)�wk:Vm:t��V�(�!p\«�¾?�e/�N�y蠭�{>���$�>���c�Ha펉�
� [�mZ2Aq���N���Ǒ۷����3��"�Y@��\(\AE�j� ��Q��C��lg[�q���Gc�
�l+:�M���T���{4�ty-=��+(n��KT{j�#����\a��;����y���3J9��TE���*�0t�S��t懈P�̻zݹl��V�В>��ۋ>J�%KwF����HmF�S]DK{d�CцV�53[Tt���7Z�u�1���#���ƨ��}��!��u:�/J�5Ӊ �r<(t�{6�� q�..�p������*�e�J��2�y!�����A��6}.����?b�Fx�/ ��=�S\�/���!mpË��m2��@Ý7#ч�����Me�d����b��<.�|5m���7H$� �
�z� c�����@=�%xr�s�i>4�>��]���Ý�tFqܜh�ו�HA��V��S��8�KfK�S�`���M V�!}�Nwc�K"S$mO��$g�6rހ2�hCo����.v�zwI~�����?�o��͗?�*k`���@��V�<9P�P�W:�2����iq�����w�U���x�����D��PUk ��G�g��"R�]�������l�������f^0t>���7�B��,���M��rZd��D�q���	&��$�)t.�$K+m�[�lqz5��^��f"du�:���NwC��M�V�Ix� ;)l�I�M�7Ս��1<�<ܐ�ʌ���Wѩ.��.j�YVS�ϴ��`�5S��Z��NOm�FE��~b��ʩ��T�We��7�c6M���ٜ�o�P�uH�Om��u����qo.���J��x�s�_:�)���;0$ G�������x�JE@H>&�&��6I���ȼ�|F&:�j�y��|6`��m����YP6�*ZZ��o�x=#���j$�HO))EA�g
Ynp_B?�����H{c{��y����o>����|���&i�(�����P�Ѳ�$�`��*�)����XM��:V�>ʐ^����D�؍\�e������Z��L�.��H[+K�s�d��w��º��'�SK=�^�;� ]�F���p^lB����%��?l_��*�3&S�5��~W��b��&��eU�.`�Tp�l�]����Z�Eh��>PQ9I�8��ƭ�J�)�$�ݚ��?0ģ�v��'��_�������@���ܧ��sb�?6V@�� :�_����a����(<t�?I1��B��/�V[�T��1ru�.r��|��@���٫Ѓ`�ӷ^;�K�)���hوJ�=�a2��(�B��U5Ym�U*|O��_��������&����#јM��R�i�ș��w@[����d-�XK4���|}۠��G&��7m�~>�&�]�rƹ0����� �I
@��i8>0 Ѳ,J6
��,�#e�<W�q.�E���kOQ�������98�
>T�I����KT�^�^"y�<�D[t���m����m 6���Y�g�Q	?���q�����o	y	\%���(� 7���&�7�K�GzʱG����b�o)H#�s�Ҧ�\�=)��r�EF�η+���o�îW�Z����	���SR��5���;��챟��c_�+#f���͈���_i�G���Yb�oE�vy���%9|Xک(���:g��<���I�,}��3-ߌ���%����HԷR
�����@�*�,'�I�T}_Sw�򜬰���5�z��/��b�V��lR��fx�3K���rY��8
�P�n�ޕ��,�����܁���e�����ik:���&�y#���&�P���"U�@��:U���Q�7o����=O��{`���^���u��Vئ�� �"<눛t΂o�Ue(���h�	u�3vZ��*�jp_Eg�cv_�/��R�8��~��m�@�sp9��;.�|f��]Ѽݘ=6�t�o���k��U��G���e<Y� ��3��Tcs��Ba.MA�����q��R�#G�՚Ѝ;�����Y���ԘK��l�үk��C��g���{��v�'���je�32	��dIt^֨[i-ta�3Ԅ�Īfuj���н����M�ɤj]Z]��8+�}C���#��ͧ�MB9��jzW(�6ŊI�kt�����ꃛ��*��VIr8������ /�|-ST���c#��D/7/Z21]���#Y�4��9����yș�i:Y��Gv8��H�j"�,k@�W�+�q�V�LQ�f��%�rNW;~)A��T�JѢ~S�RcJA���h���;�	�D�8�J��D��;�(���ʼ�iX)8����f�Xs�:���z������j$��pH���>�`�9�Ch=�����k�C�}�f�s�����Nz��	��c�\�hD�(D <{@�=�8`���-�u2I�s(��������a���+pW�j�QP��`BE�    İH����FQ�m�ȱ�5+M�;�T��`$Z7�kJ���������0YR΁��l�	Mq�p����}�����q8W�~T}��VbN�5U��q�z��)ҏε�U��M�;�|������~�>���uHǧ\93!gi
͍�f��H��pz0R�����~�~���6>U��4#3+ph�V�����7-ɘ�R��>�M[�� bؓ�\�����Kt�� ihh�dIR..�L�6H���n�#Ѧ�M^���t�)��ӟ�TE-�����'�3��2 jmi8����<�H�����[�������e�To9�dO+���~K4��M����h��9����	K/��iS�-W�&Kr�k�j��"BΏз��@]����u"�}œ9�|S�q�D��+ J������kmGʆC]�C�����#�������6R��r���Θq�o2�58)�H�5Rh��P�u�,<���&9�Ɓ����H=���ϩHG�/@�P�&��� �Us�=�kJ�5��5�ɫ����[���ͻ`�u�!)
���=D͙)2�cR����ᵥ�E��~NX���w^��H���7��;=m��E.4.<H&���zW��$]��d�Sz���>VX�zx$Z5a�s�#I�H�(rr�C��	�J
�/*{���|`1������mW�i�
�9�QLN:�h3�x��:���d~<�i/�^E�h�A���j<^�%��J���{�'y�v�I;�
Ym#Q׈��H�K�L��F�5 �ז�[We>�#ʡ{mG�c�ޫ�o�����x(��' ~
W�1(#}��v��3}�QV\	�(��oj|* NKC�7�Nk?��B��8+)8-x�6xѡ��V���NŮ$l�Űz�f��}�Yq��
�����
I���Nt�`Jf2��-�OxՎ��5��/�|ˊ ��ӻc\��4MH-!=�qM�o_O�=n&~��xկv�@�I���HZ�`3�&@:�kk��qY�j�Ng���F���V�NNU)5Û4i*"�c�F܀U[��5}�JPSe�d�d��"!.��p����j^����0<Ӊ�}�O��徚DbŘ�i�3t���?�pK��t7�ft���<d%�(�����	���{��%�}��]��~��U��H�,
,G�UِG,[`Y9q%RKt �'C�Wҋ�v���՝zrh<�O������6I��%p@���NwÛ���ͦ��F�!5�o3>����K��)v���X�j32�k�F�S]i�՚���+O�EBI��5�(r�^����?�]*"��\D����ޗ���T��t�T��yZ�nq��L�Ϯ�ߖ6t^d�-q#Ѫ	ޢ�\zfA �9ޚm��ިji�.jK�o�ԭ5�M��a$Z5!hap�%��@�}U�2�s��X�H婦ʍ������p���h$���(	\�%��Vt��bs�Zfm�hj*@x�k2'����x}�7��*r���_B�1�j�ѹ�5n�EI��H��)��(��Ҡ$.8dx'g^b2��#=��#�����^�Gi�B*���-� ��O�43/)����B4�^h�RF�� 7��@%��M.�C!��>�S�J�P���D�C��%rP��ԆA������͟B�"�qsJ����p�/(.䜆�I���-�0]E�I�]�����â�H4�R4O��-�Y��e+땧w��K�H�2ѥ�\���d
�<�F�zo��*�ZyഫuE���n�~Rn����$6/MR@�����*h/x��<
�c��>�@��FU�Yk�T�?4�����$M3R�D���.�V�aT9  a5��B!�V����'��9g���_�t��~����;v6eگ�� �
�ލ��'<(�vEs���;#~��������D�V�|b%N�x��[��;��{�}(y��W5ܪ�	�ʮj*{K2�U�E�D':𸛅��p�05�7L��Z�d��y�;`
��kf*�&�.'�lJ�{/l%:�Gj�&��h��U8�N#��U`^���K��Cz���10H j$:с5�Y2P*[ vLn�� �uI2qw�J�gh!e�@�����#��׆�J{Gn9�\p��
�{E���B!U�Z?}��PrI�6F��q�!NQ����/t��V�w�@E�&���6��r�@���r[���:�o������[�<9�й����$-mQ"���6x��yh��6�	�p�Z�@脱4 䮐C$� D������:M.�H�����ʬ��a�X��V�>Qd}G������"#Ok:!կ0g"�}�̼��������u(i�"����JP�[����WX�-C?Ă�c��%�X�F��+�	�����"zUJ6�)%9��h��άj�x��,�sn��;�=�j�����z�׽�D��!���+�V�����~JS�\[���=6z�a�2FޥaJ,�;��ӝU�m�1��<r`,�p�DZ��"�S�i{|�������i�[l�;��&uUx!�i���h������.�|�1#��j]n����P�u�v 9�A��8ڂE��KG3%��gi��đ2�] �����E�>A�X(b����6�0)���t7.��Q/��io�{�"	:�Mk�T�k6σ��b����pg�2���]��nt�
�p�r��IEmb��;g��o���ܰ,^���7^���%Phu�qN|���1�Bծ����J�E͇���|�TG�D�wX�\ڠh����{X��o��;�S�r�L��C��3�57ʌD�gY:��
��xv1t�{G~�D�iB�ѕ��s�ɋ��B��w?鴱G��$:Յ��p����
���R�m��^�"�����/OH:��`�����7�~�~�\�Nw�yp2(��Dj��V�oi�������JP�6�������/��,4�@8Xb��ו�NM���8m�D�ZmA<7)ʍHFK��Jv���.�M��=04ޡ>�ߦkY��_~�� ���@p�' d�i?��DGo���RSD�)�H^�mP�f�i������
���_���}�T0˒��h�qZډ��k$\Q�-G5��� �����,��^��M��#�����"��p���t7<�e)��h�\t��dM�H;C��h7�O)�;0�j;k�& ZZ&�(:��&	m�9�Օ� zX.%�J�0�=����@�2{Q�t`�Ut�_�i�І��k�@�TB�9 B*�6��:t�׊�rK��{`�Ut��L��j�3f+4-�D�c��5g"9 ���眭��ԕWN�Ҷ�'%�D����o@E�z$:�G��J
\�
�K{F�#����E΅���\����۷} +��J����d���s}Б�SCVh( A�@>�BqpUP(`�|��;����ȷ<�E��������*7ͯC�p�6����[X��z��.���ˑh��j�N2`N3�qˑ|�G�����=��\�9R4xw��$Z���(k��P��P��֌�`�Y�P�={��W�[0U�I͔��" �#���j�j�w�n!;ڭ>�R@x��h3Bt`�=>2�r��R���En��tƔ�� �����|��h����eF�d�x ����K*�%�zYA� �\8�����C��8���-O�3�'��U��(��m��5�ю艧�̜��ı���/�&�4C�M���>΁�J��aE�5M�j���lĜ�*U0By#Qe,�BE���^����#G�ˆ�i�b43e�KD��z���m	����Ӳ�AYS����~����1��]�Na�Rw��1�X�/�Яy�A��Z�ϐk��o)���T����H�&|��D6I�d��~;4��������ӣ�~*!�Gz5}�'yT�K���Y ����cvI�����}g9H�sf�(IleJ�����h��-jKr48Di�}I+��/�~�eb�V�������4�.t�/���i_�kt`�0^���#=�@9@���٣� ]5�Z���S�ω|b����w|D3���]���E]�hv�J�-߀A    )�����l^���h�:a�@-�� �C��&	�q���)�}ĕ6�{=�<c$]��id�ň���KS����_VR?"���*c.V)r���BMZY��[.��^l-f=?E1�[���H/G�u�["���r3ך�\�n��h-s��k�������>�����zX���BG���N�r���ra�7n$�PW4�r�E�S"s��՜5Yk��O�n��~s�@'{t#5ho#!-P�2��M�b��H�r4��}`�U����"�Pq+���Sh�ڽL�B����'���D������w�{�ӝ�L�����o�P @.������ޓ�G���\+�O��ݵ��(pe�����d2�3U*nlj���E���e��=�°���6���l+:�G�"/�ц��U���Z����/��S��i?�<~�W��ู|��?g_����������s���ㅽ�+Oۯ�#��H�OJ��	�I
�Ԣ1l��'ɐ�7�����אMO(�oyo��}k=�k��X5���@4\�^��zh[
Ni&ER�\/�ʸ�׽��s(�/�?����@�kX#Z-�%g/��hՄ&��|��qI���q�q��d�|��z�h�4��m��j�i鎪Ѫ����3s0��O2�!Æ(����%U�B��?V���H�n�fuN@���Ȅ�sr�\iO���͟R�A���X>�C�����S��L#-�| ��6ͨ"�(����Cc��>��6��5�O�,M��gܬ�">�|���GK̓�VM8:���Q$��Y���xr&q��qY��Dz��o��ȕ�B����o+Z5*ي������kI�|��<W�%U�9�֚ځ�^H7��(�]q)ڵteނu"4�����	M�s�f�i�f�	�k�wTȐL�w/F��Z24B���HH�bx���,]�#�ݛ:d��k�R�&��l`e��.ȑ�DFpI�id������"�!ڂ<�^2s��Sv�Yi|��ӉNt ���,e�O A�3R( �n����)+�qz��S�0�28eF��	�"f�J*�a)��:Vi���8#k9c���u��Ƞ���"R#���O�0ƾ��3�)�+�:"���B��,g,�����i�o�?����{�(`�,àn�w"%ڱ�TR#�:��� b`���8&<��t4����_4�^�k��{(!��r��M��dv:��r#ѹ>L�>����uB��m�M7%d�,��טS�>u����N���ܥM��]ѹ>D$ߥ��J����*���5���Es���t���T�I�x9����Pj�]�
$�=1Z:vQ�CR��Ik���&;��+�踱#ѹ>|�IE
iɶ�E�R�''(� ?e-9{z��Ɂ��tf$Z5��M^Y@ךK��"T����>/}��y1�i�v<s��qc8�Z��;}�#�k�P��#��[e�W�,��q9t��϶V�{x�Щ�/y7Q��݁�>k%�@Gٔ*�BƟD�$%p�d�AЯ�I����^K���!���l2K�w���Uռ'�\�NuQxh�IRK��0��\3*�lhI�\�s�QE�^�5鯘z��n#ѩ.b��;Qf�}��"iFN�k47i��,�G�����i��ݿ^%���^E��	��\���P�	��hu���(����C�p���/�zWx%:Յ�19E��I�y.���[���'O��^��&�mj�Vm��)�~>��B���?��,T���(��!�F(]lGfoÁ���\Al49*'�Y$������9�>��Lw=O7B�B�dU2���T;���`�����H�l G�#�- ���+:1��oN�We��~uL$E��^�n��3���^�Nw�����e�6�����m)�k!�֕1H���
�������t� 6�uk�c�#ѩ.H����L���a�����*-J{{�u��1,\k�GEW��
|S����&���Eu����V`�+��}BΌ��#����������t��HۣDB(��^ I��q�h���˩|x �PW&r��hv����DN�����TAGkJk��Y��8yX���-�7m��|5L��݀ao�n�+:ى��jI��
���<~�)D�'T�ݷ[�Q�����׏|�o��_ㄊtd����U��Q�yd��i�Q���`���6�+�=	ס���/��m`�R9{08W��N|�<�b��H1l��c��RWZq��vyv/�;KzU��v�%�t�ؚ낥xn^�%FV�CO��%Nڹ��:�xԛ�e.�����J�x
0�9K9�f����\�;o%��a/�������gshm}�����Y��v5#�g*��[����{բҩ����#��slM�~���*���F�����c�ed�ε*d*�+W{f����0Mx�v%��調y��o��=�������
ai�W��P�A^�5��������tҙ�d�X*"�\��A��@]�D����F������.:Ѫ����i��3ƒ���M�����j��#:ՅG%�,�h%@�R�Ug=�4:��,�sF�>yX*�_i�6�ZoF���4�%�3X���N�n"��H�I���l�Lԧ��{!ɬ\ha���-^\%�m��Z���BO��NѼ���]�Gz�I$WmP��qSYZŖzh��Re��dm���.l���)~ͪ4����H�6��f����0m�ŬN)�\���|�,�p2�h�����\���O��܂SF�xg�,�Dk�k�MG�^h3� E��VwQF��(��3Vܝ�_寕��͗o�o�K��=���i0�	��|D�7/�Z�;��@`�m9������~�×�a��=���H�EtI8�39���gQ�k2��5mb�مvF��v�]��灢R��3Ўh5�<�H��'�%��,�!Jn�)\���_WR>���(I���׼�r���s�����\�o��3I��t�C�C�&zpSE_֑f�}I�P�(ޅy|�2؊�Z���HQ7St<�)���+k)�̏%��W���c���U�kd�O����U���Z�-E�R�4�19��iz�ꔑ��]_�y���8s��yV�y�M��緢M3��ޑ��Q��'jg\�\	E;qJg���P:���/��h��2A+�X�����e�F0�w���k 2�X]ؑ�#=!-�$��E�m��1]my!R14�J�:��밟h����i�t괊��w#�ӶJQf�G\���C.o��h����Y3�v�Ľ}-�@���2�[�;KM��F�Eۖ���H�\ ͌��$Ț�bSB�qI:�|\=J��s:X���b'A����j��#Z5�J���d}���%�$��Es!���m��9�(���� �\�hՄ)�xnț�p��F��a��d�]���3��m�>h��Ypf�;A;N�4�����T��@c�t����v(z�y�����\ɸ��4s�E��������3��o��\YX�!be�<�	��3�����������J	�G����iZ,��`@M���Z$3Q�}-Wo{Z�##灼/��۠A�5�?�jh��B��(���3����ZA�vJG���}��W;�}�O����r_�K!]��F,ϱ�,���98�E�`<lG���hgu�A�h�_�hp����
�[��sR����Q`"/ �[����H>� �Uu�ŀ<� r{:�X�M����_<��#��<=%���ek�_Զ�Nua���Ҷ��,ȓxR�y�K�щ����R )�ތ�JG�#ѩ.xj��#؊�6$��m�9F[���g�����m����s�+=u�мm�j�оF�8'?��~������Q(-�Y[��֎��r�%]���9o�U�8�VK�G�⊲Q��Uϛo�yɼ�B�R$��M�x:
��."D�lk<�����䌾���v�8�����xSȐ�<�.E���Y"_&�F5��]�D+��5��9%g�HЅ�H�o��)�8�M��eW�1!��7�h���\�d��4ʗ�}a��rV��MFGp�!���
A7    ��on����Ŭ���Ѧ%W���*�|�at���t��4J��E��t@��:n��Bީz,nx��[ʑ�\)�,���LZ �r��V��J�S���o�I��� fU[%��pn/t�p�E���GA�~F�u-gl�[�D�g�9c`3�4A�����"�nJզ�N��z���_��l�ӌ"���-ay�F����	;�(.(�݀�,����@���������#8�N�)�"i9��������s}�3����rQ�����L���`��qԋ7ah���iG������)�Z� N����O�`C�qu�}c���Q����]�^^s�=
����T=j�wE�&j�>���4F$^Ҵ�l���vE~λ^�s%�RUk��~$Z�Дo:F�sj$��ƒP�Q���������'�+=7�e<�|�e�����:��Ff�\֎|a��:�gX������g$Z��Z09�������ff�X0���?������,+e���\�Nr��h�H)��z�ՁY9S4V@NK��^�3J�q��08y5m�f�ʨ��d'�h��l�M.H:p"�94�*MC�����_,_�Z���}��Jt��i�㶍����
x\<�io�r����3i��s$��Uހ�W/���j��#z����Y˴�O!�7W�:N�F�t�$���� ��N>������F׿���	�K���~Q�#:�M
�L7<�� n4�z����1"�֧p=�����у�O�����D�e�x���x�_�k`VG[(�J��V��䘲}�}c�Q��{W�~�<�Nt�r�o_��C���<3���n�w�h3�B��3�-���_�ݺ�D�x80�*:�GIR�H�J�a��)X<���	�/_^5w~|XK������}$Z5A�])�U�s�`���b�f/$W>/w��py��F�Gv�p�F���+YJ1��h3��hJb��&("�!t%�=�	�-w�b�7dW�?����Da/�c��6ʏD��\��*UVj`�) ��(�|�V��ҷ���	�Pd������ا��W�y{��$Z%KT.[�x���^Z��ۼ*665}F�gu���p��p�<%7=�OI\�%m�h���Bc��A��d�9C4r`�.Y��v�����-Ϫ�{[v�f���n�i�#ZMLފ
� ��i`q���#�BI�Z��^7�P��I��Z�g�ʶ��>Ǽ+�.�fɽ�#��n��<��^�h*Zp��jԑ�N�^tq���T��%d�q90��r$���NNFC�d���M�a���$�N��w��� �o�vh�W�:��Ht�[������8�w�\X��X��%�x��!	�ޜ��>K�4}���w��GKΈ0,9��*K.JՙY���Hcmg,V�Z�f\���(�Y�?X�膿+:/�v"��^`�|[��/_����ĩ���H�iF�yB��ݿ�O]��P S.o]u��q���%���nr¥��ہd��*�������_��)&DE�M6��o��e���;�UMD��F��H�j"�P��0|��Àk��5	W|/�:��[�^'���U�l�/T��ZsO^=�~L&��*"�.��sB�{����]ѲZT����l��@:sP��0օ,��9��r3պԯ�A\`&�ƿ`�Q�T&�9�B�y[P�.)����)��_[ч�2�fٜ`.g�v��G/����@Y-]��4��X~��73ߪ ����'��!��ʻFޑ������v��`i�^_NnE�K'�F�*�ȧ�*#�YTm�H�'�:4z���8��7���!P*�� x���^�h�\^:lE�K�"����m$Iς��1"/B��˨S�[�@����������2�s�F�!���W��:k�����E�1/*������.�OL��t�{��������N��8UIr"HJ��fL��O�T��H�
7��GI�z4i}�ͥ�v}f�Q��;Jۑҁ=�4��^�}�������'ҿ���F�}w{����k��D?�4��� |1��ӜaQ�Ȋ"�4�zFƧZ�Ä�����[���~����-�f�biRϽ�^���^٣�u���[�*r��Y��ތZPfl%�(Y���X'���P򀔊��4��;��=Tz7 ^ih?�U�
�2��CL�L U7&���gr�t>��8�;i�p�l���Wa�&x�G��l�%0��
#%�0*n��?�~З�I�e>��R<��,�0m�2k��F�'�%O�BzK���Cm��z:1[�m,)��JO�]
�9�;����1G��<P��f`�-~�-� ��x[�fh�E�"��v�h�ˀS���V5P��-��&�^��|ز;4���|[�+ӭh54��]��JQ#*%=2|<Y�'J�pʜG�۷��~W�㯎��G��:�� ];�nCޣ^,��Ux�
�㋊-r�M�#P"�M�D�v)od! �^��\�׏���P�ۑh3y�l�5	>{�O���{���-�`����-O��{[�&�Co෍Dk2"�2�[���M�H��� 	�9gsʜ'�|J-v 5[�W�p�����6�=f��SO�����q��������w�~�����~����WZ4�w}��u�\E�#HU�z��ɗ����W�y���(0��R�~��:�y�'sf$Z���Ay)�R�s0�)�9�)�֘vJ�g��b��(�Wm�Wk_�#I��w������1��Q�vi�=�@�����t7�zv�=�Q��A��y�'��<2<���T���V�m�̜�ь4�LÁ�j^�Q��6�vW����������Zi5#=�2�jRV�IPb0/� ���\�)��O	����!�Qӌ��+�-�+)��,<iNY0��)ښ5�V^��=�;ay�>N(�0O.'��(UJ��8�1A]��l��`~="��ԝ:`�(g��iB��*�)��6�1��!j%,�j�x�5^��_1���:�.|QK4>��ޓ>�H��[3^����Z��5y�����۟�=u���֑�!M�&oG�����d�o�|��������B.�4�sz���k�\[jh���^~\�Y��=�U^q׳�V���������xeKU��,W�i�l��vSX�0>�F��W���p�,�e2�E̽Q��ོ�inh�����#g���{���;�{�C�a�~l�I��Cޝ�������f�����;�#):&|�"ɐJ*U��ޖS���Q�ջW�kƢ�#�ϲ���>|*��OE�)�ZfJ>H��P.�"��ܻ����h��1��W�d}�^_*��q�	g=�?����DN��9�N�Z���]O���'�'6� ���{~�r'/?��j�%�Mk��-5a-|�4�\T�w�}�6� TP��E�����3�ڑ��g�O���9���
�q[S�,2UU���:��9cR�e�el	�������H�� $�����C��=�3�2NX���2��g��0%��z�:��O����T��/���X�L䅴A�`cE(�ʬ.7��{��ܱM[��rb	\7$wn�{�
�`Z�	lg��3�fD���J��(p|�^K8�{�:�!���8��u�M��O&q�.7�Bn��t��vѦh�T_}E��cć���ty�M��*L)���$0��u�ٱ��sFժ��p��t�(��Fߜ
7Ѕ]����b!n��_�U��Hd�)" Ty5���1��j��v��	♞�>2Gd��]$�8s�g.��L����_���}|�[k��7�,�t+$�����P2��&[�P��,�yH�}*�t�/HZ� �Y^p�8�Y"�S�]��ᴆ凫i�>�����H��2Ȥ���{Hp����-#5S��6�=C�z-߉��l����e�0�I8�:�N�+u�Y��D�SZ���3���{x��QI$�|#�E�A
�U#���5cW��T�� b�T��ȍ^;�|�J�BŲ�1����)jFzy�d5"k�Xͼ�3�<gD�躑�x{�t��*�[p�a6<Ïڮa[�����Sk�먍^��vI/�9����V����N;
�dD�6Y�OΣ�x�    �e8R_@*��F$�	i7��U!��rx�=f��t���U�#"Jù�ة�a�RN�%,h��O�����${˹��o��Ծ��o���Nm���w)x;������L�������eY����Џ�X�uʦ�"{ߒfS��S��<��U�cA��u+%�eD\�9�vN�[w�ţ� �Yv���jܛ�6z��n��+7�E�.mt�?5��J]�h�����N����I����Vx��"�]�� �b��'5�7����I%J4�s�������n(#F�I��#Y�P�ֈp��b-炒>X��ې�/���a��o�K����N8�=w	���9���0]Z�C���X�g�~�Z�VG1/��3�1�9��v1�;_�0�"2T��&����3�g8EL�̌5+8��*z�_��L`8��4_�ܮ�k�6�A���s�<d��p�4|"!�2M���m��Nt�W�q��@'�~>]3qlk�D��$)������Ǟ3�,ۯ$��fPeg�S,Z2�:��1�S��T"�{E��M���+���ݛ*��Z{C.JI�pu�h46���;g�:F�毉O�`�����m�H���ø)��Ǌc\��ӂ�1�6��zNR�X�Nz}�׮�����U@�@�'�R��y1r\O,*�`�;�td��j�G�g85l�(��mхȾ9�T���\�`яU_'��4wܪ/����*8�n4_�k��ް�D��q=g��p
�t��Cs�^:�;Y|1����k=g�s-�;���L��g�Ҙ��Ip�=هT�;�,Ԋ�g�(�R�ܰ/q�z#���VR�2��z��S/e��e�=�A5��[Wz5#�f#�_�w��A��,4Nn]B��sM7,����I/+��K��5#����4��u��J�8�(�*B�0m�9�P��w��:���|a&�Z�$�H�X�\��)�2�\�����H�A�
휮��G��T�sN�����[�~]:�+����[���l���kG#������-4��uc��u1ӳq�����V#��K�+�A:�G.QV���J��|�ꊉɇR���^'�Y��{A��7
�Խ_ď�S,�I���7�R�pu��XZ�δ6��=��Y��U���2���N�C����#��*���"ђ�����[<�#�B.�e�^{A�H�E�,�N���խF��Ìt�E��ƘDvI	s+�4�cp����d\�Gʮ��d��ӇH�t�M����'����>uJ��B��Rs�i@@|j����J���~"�����N���Rl�q�P�������`��?��y��^ư�����3�i6-�V�e�ÍY�f�q�����]�ɹΤ׌WƜ��#�l�N���y�K���4|SU�j8g�gD���i�N�Yvs_Jq�'�g��g�|�0rt,k�M��#i3Dɾ4D��?���w-8֒s��{Tř��Ϻf�.]L�ǢF�p�H�!m��M:�D$��e_Dʼ��K���L�DUw���Q�i3������F����'I�2�-׃��W�
�|ݠ�������Wro�P��|O��}�-e��{��t��o�s:��[�ugo}�wߏ9'c#��A��.��Ueej�B��	wEV��^J�kX�����t���8�<��ud�$�:��	Sk=�z��02؃j�K��W�#�H��d�Mq
uґX��E˲u�\,v,E_Ϸ�R��<K+���cq��t��J.�<z��w���n%�V�TZ��ȇ�s�%��)�&��zDl2�sO����Y�"�/�u�����z$}����k��e��Z�&�I���F5�>���V�%��Y�jF�/��tl2�d�Ek�wj&�ù��u|f�5fb8�-�Hڎw�DXW�g���^UtUQ6�<����%��O9�2���]H�߯��'��~��J�`��6>T.�x���2O��G>i�l-��^K/y3V];zj7#�f�#ux#R�ʎ�#w�R��c:W5\����Nn/���]z*�'��*mc�6��l�|�\��4�(��G���o������H����"�~I_��Ρ��q�H�H��6��~F�I�D����y��!0~\��e���j@��J��~�5ahi��/�/�����"�g�=�6C��������X*n!e�L5�5�*��w��	k����z���6CD��1�`�/�����P�&ؤa���^|�|XOǲm���6CDK���P|M��;{8g���!�Y�������o~F�A8�r��WzM���KB�p���d^�ɺ���ONK4��7�f��pjՑo��.��HK�l�H�tٛ/����3���d9Q�"��_�}�;�/��������Lu��>��ݓ>�	���ӣH�cĜ���E�%1�+8�/��N�u�jD%�a��+������wL ���WG25I����W��~%}��k�[��p�����~�N���ͤ�i�V?�����~�9Տ�l�ܳKV��^k3#=��n��e�$7H��D��e���In+��~�D��y�_%S��g��a���nR�B'a�s����|�Wc�vp����~赮���X^�)j|�ܐ6C��ex�[:3PMV�R��[��`@��ge��3�J=��U �R�3�f��k�D_m_�H�e�u�f���㙬���{h:� ;����w}��c�v�hS#
�r{�G��.&_Jz�{C���M4-����F��E�g��])�%����oN%wR�E��圬�g��JYu�|Wă�@�i;F*>{�H]0{������b)� w��\���OK?\\/h��q\�7R���c�$��
H�\�e�l�v��>��ƫ�����s��Gr����p	��a�'D�8ۄr���m4>k$��x �>>u��Z�eN�T\�j�JÙvd��n�P�uJ�;\�0Q���F�v��=����ܨ�q���R�αCV5��=���Bj�].�8����3���	n���`���OY$~s��3�CMy�������GSV��.��|E���?�=�i3���y�3�W`Jb�V+L�ՙ��S�:/٣��M47�PXŵ�zF�����:#��\�a�`�Es��JAUzQ�5�4le=���;#m�(���1�W�-nkT�u�FN^{��e�ƺufŔ$a�!��"p��T������=�tZm�G���'������[3Ei=�cj�Z>�:<i�s�|BӴ�6���9d�
y^#zN�@/�kU�)WK������}xLΙ��Q�i;D����b0oJ���Å��m8LZ���S�E�����c.��)��n�y��s<��a�0�,���8�#����JM�i��o��c�ܭ��+��� [�4���3�9��+�����5&Tx�r*���_U�Z�2Tt\Z�.e�æ�|��PQ�<�T3�9�s���slآ��P2a'����h�^���(s����In?��q��c(�~w�$��"
��/h,����6�gvH��Լ���8������O�KZ��4�u�3��8A�~��̀����쨫�W�|)+���^�DN�h���ix�	1��)SpM9��r_�[����ȃT�A�i	3����X�e���s���p|��Һ��^Rr��㧐��&::/݌���Q�1�I�{L�mIpqT��f�9W0�?�����X��~(>�'ݏ`��h	�R����D�뚂�&�������P��_~���o����o��΁�!m��n�.�"-8���j���M��4:w_�w��vP"��I���iK1J�U�l�a�j�R��p8~ݠ��p���	�Ɏ[1��e��u�����ƣk���Ӈ�ip���=T�3�˄�	6�SJ�q �3�?ŕ*����kɽ��ճ\�XL�ۯ_T<���<P�B�Q�MJ͝-w���ǝ0�UI�W�R?��Ԕ>�Q+����˄ׅX��g�\�Gq+���D����D:��.��5x%^�����H�X(��Np�2w�&<��D�J��j�Qy�ج��_�g�:��/�S,��Bk��50�u��c�    GM��z-���Mp]u�j����8M{Qy��P��
�����T4�"�ݩ Ef9rf��g��p����R4��Au�=b�"���Å�[�}쮃�@s B.s@;ӌ���4#���M:����N��1r�I6rg��!��}1���=����=(���~�_�b���
�h�� <"Mf��ܐN���D��t�l�q�E���4�����c�>�s��O����K6��qc���@��cx���i66d,h�X�|3�=����M�^X�p}{K���}� �u��C���Xm܌t����S�0�:��1"���=�b�ѿ���B�'X�������G��N�iT;�{�T��8���7,7Vjޅ2��t~�;
3���H߅t��!�b5D�V^�	StQ8˭%ժN�z�����?�c��'���KsOG1�3�)<���RJWn1�Å��͕�G8��w�1�}���mu�B_H��(**5�1����9>��iQ{,SZ���~��H�S3H��'�kC:�FF���Ih�Z�A_�qit)������Mz����hF:Ţ��c�o)�}f`TmǞ{r��T�?����3y<��=8��t��ޒ�Ux�O�lM"Ԇ@������u����UW;= �	xى��<5��b�j�n�����n�F
�&�M����YM���V��z�'�0�foH�X�D�j/Z��`�����:۞rԭ���tu�Mw�օ�;j�+�⾣~��f�{�`�g�aWᦗD��lJ
K|��~諯O]�Ǡa���
^���N�� � �5Ȏ AU_�ې�y�^�:[�w�!6��.j�a���h�ј�N�ɥs	*	����.�r��Q�j���t�˰����Q3��}��B:��jkI6ʔY��F3�d-�#\�*�����<����f:3pˁ��i6R���)�*�o
�`��&�l���-�I�'�M[a�G{�ݵ}I����ù�4��s�	'T����[�]�*�Y���:?)�yfom_c�!�h �f�Z6�PM�Y� 8G��=��KA���|]������������/�[��+_�7����v���b��'~���l/W]K��)�4Ҹ>�@�k�B��W����c+�RN�#>�N�p: `��8�#�.�?�.E"�4�Ҿ��:IO��Q���u�����O��4�b\�S�������r�O1�dc?����+/i�ީ�[p���?�Gk��3�v��mԪ*Q��9�c1��CQ�m_A�����݅��s�xʉo��Ys��C�rO:��D���I��,w��Ȝ�	�ပ���r��>����������b���ӆt�BnME3�t�[[���-�����F����^�C��H�㹌Bɍiԗ���\o�k��� ��l8;9��C�K�hU6OM0(z�4r��������l]|FXp�tk[��
	\�`��b(2�*{�/
�~\���Vh�q�ȋ�z��Ɓ` j��b� ¡��H��B�TӰZ��fGn5��s��'�q �9@�4�ő��+Dՠ�2�J;)���t׌5���|��t�B�uo�qEԌt�MW]b�����EG�#|Q��d;��~%�������t[a�{�A)� aB:Ţpwu�8��v��%סp�Z[Dq�����;�k����4��'�_��N�H�8~RX��d (���֦z@�7X��N#��%6Q5⻹��j�����Ta �	{k�{��?Q��M/��ߎs���	e"*O.P%,����(ؙ(��;���A��UV=��e������A��N�^ peJ)\��w��&�o���W�5���XZxK��H� >
2D�r�R8'(�b1�i��w'��~r�d&M���>�o�}.��hNZV�Ɨ��t�A���n��8\��9���ħ���[a랽����K[)��ꉚQߪGwI'��(Dn흋��j�x�Q�ƾ�4�>Gj��y|���j��3-ݭ�s�t�At�/�r�d�W��L��w.���~N���aE�x����p3#�` ��(I�M�1�d2p��{�vȿ�e�{U�X%>	�L�;�vH�Xd�m�	�"����Ȳ�f��^}."��C���7~���k��n7�S,�q%�Ή��}�"�؄qֹ����^�Tח�\.��i�(D�{AY�P��H�XXe��?��q���Aأ��RK8(z�����0�����哿��;j��t�Ee�:sh��kՈ�w�C8�l�C�܋�^'v�����w��r��1#�fSb�J� |]Z0��ЯQ�O��L�Ph���Ob����Su����4��lH�X �M:q*��]Cז�$]�	�z2gu}�2^��x���"o���ǹݐN�h�ub�Q$��oYa��@٫�doI���FJ�����RA���qC:�ƚ܍��f��:�����X�%���_:po�L�u��H�X�d����>�S
8�srT/���X��T����M���j�(��=��n,l�l�m��	��&�ʜ����F��GP�>�l$A�5YʋRpM���4U�+�0�dJV��qSk&�<;�J��;}���!kb����6��l�%%}�v�o�\^����Q���/��0�+�F1���y�t��/�2B>���;�ȹ�Օ�zL����Ou~�L#T�{X��b�ep���iB:�&�Ν7�Н��/ܫ�H�pٖ�탛E:_7t�/�i�f�}�L�u���t��j�����H��M��/�P���u݋JLt�c{�9A���?�g�H�Xp HG�p�bA�CI���VD��Y]�>�㇟��X��^H�XH�����܂�x��/���.2ס幮�f�jK���p���Ww�K���lr�!%��:�Z����QTHf.��꼖���D5��[i�k�nZ�x���H:�B�F-pݹ�<\G:%�����]�����]'xj�y2�|���4������Q2��0�S$�Y[�<���y7��,п)�����D�������c�x�OPf�ě�F߽��7�h_��^}%�-�yE�	��5W\Ԣ~ⱚ�*���r�����k�ăG�yj�V��Ɛ}�a�	�i��T	���"��D������rw��u��W)?����M��.~B:�&���:y���l�e�A���4b��?W����xM���d3�i61[�v�&��.`E�*0�?r!�tJ�[)�?�������L���>F�!���#���M����]5jDڭF�m���.��	����V���n K��6��<����tw}�Cz}�ȉ��YsY��}�(H뼻WP�-���.w�����Xlk������X�0n���{�D| ��j���3Q_o]!W�j��⣋3�f��i#p�,�ژ 3$�����ͬ�H*��n�z��U�7���l)���Ճ�V
Ħ��	��:�������1�v-d�w���?im�9����N�%�N���d��u�X�^6�eak$��B/*}�����V�|��ܥb�N��p�Z���>�3���F�zh��n����)�c�qP��X�w�vH��d�J�J����Dcl����>*S�W�D�[7ƌ�!���,#�Y�B��<��\U ����cL�]Z���Z6���Dw˫�M��]]N��M88�P^���r�����O�����c /�_�7�����p�n*F���MH���[Jʊʮ�V���k:e�=�c<��}Ƞ�9���'Jb.���N0p��Q��(/�B�U�R��8ܓ�"�i9��`���1�6�9���|��T:C薎��x �[�#Z{�x<��@B��!�#�L��	��/�'|���k��n�Y��bԊ,a�I}�������������o���_�������*.�Ͽ���o����&�3��$�p'Z�wZ�p���D7=��Sn��'Q��G^*�����B�PN2@T�:g�1�wM���	��w,����B�fѽ�g�,� ;�߽Nw����O3�NO͓�!�IY���W�������.�P�uZ��[Yv�7
��q3�)YwgT �  p�d˽#	�p4�\����>�Խ���$m�������u���H��~K�^��Z��"�/�᫪����-�5̾�C��L��I�}$�b!�o2/�+�q"ITֈ���͐��c|��<���������c��4���9��ig�Ί�$ׄV� ŘO��8��,c����{�!�fcz��O��r���$"�!S��]�p�;�g*_�������������/����o?�������o�~������?~��߿��~���o?��ۯMH8�p�5��j.*��o��<�	��� 8M��'u-8�
�s�v�q�cM��T�f�G����24�R�X��U�I��\�e�⹜��(BȌRdB&W����7m�����CyIGj!��D��"d�./%Yãwp�l�.�r�C��KW��_��������X$�G��}��JH���/��oÕ��I�!�2��Q�����D�F%�1J��v�����s�u��vźh��P�����H�����(�[?��KN�l��|!(�F�G���h�+� �Vf8Ҷ+�2�g��8߈��M�L��)��d]?�5Έ1(���j�]��i3�E\��NG�	�_���q3(hW�3Q�N�MD�0�ʁ�3�����{B�h8�8{|b���3���������fG      �      x�Ľ�n#˲6x�~���'�i`.(щ���I�[ъ|���"�I�WK��ݻ��b�*+32���a<A,��M�*�p��M�F2w����K2��H� �7���#Y�%���I�L#�%��Ze�%��{L��w��z4]�� ��1I(���6ƃG�ߌ����I�,%7�Lp��«�f����������rY���~������YLxr�^���n��W��j�������Tj�o���k�/j�{�d+[�9��p:-t�������Z�-u��wV%w�#�a��R+���܍~I�n�P��Dp�' I��K�a���`�y���B�Іpz�<��&�#�N
J���I^����N�R�Q��}g�c�{[���AvGY���lt�P�΅���`}�J�j�����X�n�LKQ8��ڍ�v���s���Nj#�F����h�Q�B�y��,dB	Q�PI��U6x�@6~�"��e�/~��o�L��߈�y<̪�aM,G:������\�����Ӗ�Z���-�����Cl�ʔ��\N`K�R���~��c�o�� �	���(A�$g��ݗR����1��6#�1������K�����ñ1ʥH
?HR�'�2/��_F�q��m&�Qo0��s��L�� m4�M�X������p�V7��÷�Uo|�Eip��7��0n%<�o$n��|1z��4���S�zZəA�Ad��Yc;��n��۟8��`)NK	�T�+K�$;��
䈺�{x�a!���7.�Ey�!�p<�P���R�����j�F�}�58:�)���4&If����@��ݷ	_���'����RS��ݼ��w��j����@�@��PV�u�I��)~�St�1��8�d��S��x�"�rI&9B�	�I*nQ��O�����\��o���b�A?�@Y�,�
��PY�?z��0s�<���Rվ�d�ty̛J��\L"��§��D5X�Y"�G�%5#�md��PZE�t�@:������,h��az�u��Q��7v&dr.e�j1���g����Ú��E�ܸ�����!I`d���H�������p9٥[b����/�H������~<M���Q����2,�A�����%��H {$I�X��po-q�m.I=�WR�Y��4O���N���B�RT�t��Xӽ��-��:�`J� ��s��jA���(k��1C	�.�C�X�;�b�HX8@�_x�-�بŦ�^��I�X����\� {eVk�/�^���_��KxrKr�0��Cj�;��$�*�F2��ʧP�è�z(�]��hK��F�t)��j����O����
*��Ŗ"�=@r@��o$� �Rr�n�����qr_����t)��t=���ڼ��*����"#�
�/�@RHV0��F�-9  ��*�,��p0 ���A՛4�Pf|�b_H�� ��'ƅ���7��&�?���r3~yM���K�^��yg��I3�Os����\�eӻ�p��-�5z�^o�����+T�i��_I�f܅� t��7)�r����H��=����!�$�4�p�#$�
�"�1wJ_R��՘�.�[�����������a�r>��$����O��.|����B�<<������`$� 7`�z���n����/�k��T � �а��,�t2�ԉvP>�՜���8%A�q�L�Y�����:E�'�3���l6�����/�VM�%Ek=Ӵ�����F<�L"�eΤ�h�^YT�7 yG�u��h'����9�n���"Fs��R���T�]R(�ᙖ����$��j+X8���.��ZK��q�yxl�ԑe�ϵ|b�<4�j��[iǏi����m�������`4��2���)���@�'�	���n\_`#O��@�z�4�����d0c�V�!H�S�v�@�<i m�7����o��^oy�s��习����p=���$�&���^���t���/�"� )4��I���N��:�~�TO!1���Ѻ`��3ti� �%�"#q�&�tx��^ �h'xp�����:¸�kI���8	@�H�0�<�<[���(��P$^e���t��%g���$.�`��O"W�*������~ت��ۙ�뾳?����}eޞ�X�K����CogC`�	D�����C�p{$Q��8������⭷��d�_�7�S�8�����$�!�

L�
��EI ^�>O[8�+��,g����l$�KH�R�I��T�i 6�a�8�ֽI��ch$0$��*���������r\z�$�S)���)uL���
��q��#L$�vJ�y��ۑ|��Vϳ�xݕ��i�ߏk��`tl�ڦ'K��Au?7*��|!�: ���.�.�ך�/���>�L���#�����c�7�Y�6��&��s��pnF�I�]F�A��.B[ŕ�x��D�:N>��"Do�����	v_3C��=F!��]ݯ`�Kv���a}`'�-,	{���ĕ�k&n�
@Q��I����ѯ���sx�V�@q�v�R�(\8���h���H�t�%!`�8WE���F��4#�QK� ~@�(^�=��%a�W��cީ,j�)���N��Ѝj�R�/k�:k�E���lMHr�4H̻U�w�;�ߋEo�K�N���0TI���J����7(h�|�7��g����bNJ��J���#1t�I����/�2����< ��&������M�RME�D�=�B2��G����/���}��{n̉X���Lsc�=>��3ɖS���c{��o��؀��Fpy[<�|u��J|y!���\�C&�4���  B
�in$���R�����]j9]��,|���yu91x�± ���f�)(�X�k�O���@Uj�ʌ��6ZТw��n����Ix1hY #��aãd�F�ZP�jg�f�_�˲`$Yf���?0�A��At5�CL�<ðC���:�E�5�`W8��g;�o���7&��=�:z� %]\��?	�+�$��&x�^7�6�z�����5�E�ᖄb�h�Zw�a��?u��D�Y��-���:�����qI�*�(L��ʯ��q�T��h��������ly<��ɰ߻����ů�)�v
x�r�I?��q� �:-N�RD����+9qB��M�� "NQ��jT�� ^o$涛���m	BI���R�"��t�]�{��}�����f.|�����%���Z �u���!���c�2#C��B� C�!����o_�F7�y+�o& ��jY��e����#Hȴ���}T�!J�:�^O�EH���:�d.$j1A�k�#I��La�@��j��ư�?0t�)��K
�h>#1���v�o�����Cb?+���q��p�����x����m��$D0�i�yZ�Zac�Q ς�,AP�c�0*V�	�5~�\3x��y�0� �%��YC`C[��n㵧Ь��op��G��r\��=��t�}<��J2!06M���B�>�(r�_�$/<M�3�(�L#ad�%�A���mc�V��r�8��@B��b�Ǘ�7\2�r�p��*$?� Q�?�g2����3@�����������1�qFY '�!cX�:�5���F2�|�$�������[��F���bC�V����^��
o#�{
0���De(�㳘r(J�3L8��H'�bK�}Cӛ:gq�2��X�${��D��R���9�����zӤ,�b��F��<$�A�����w�Y�t�&�`�F��1j΄"xG��?�(�x�� �j���҈ �S-�_Ipn��cÿA������$*B>M8@f-@À3D��Q��V � ���I
�N*�Ka��)s��~C����kIxyh��zG<i��q��Sc��č��O�ۑ�R�~�߽�[Ϲ�kd:�4.����ӥ�s�V��-"n.�k*� �l����]}���{�_���7��vnA�̉K����x    �ia��#.aIZ �����`a���q�8ɢ.���e(l�qd9#�r%Cl���\Fbd�\I�꤃��' �� ��n���w��މc�!8r%1�AX(�ֹ({( ��cvWNi/�a�a�傚	U��arpJU��o8�Z���!�xo����Sa񘩋�{�e=�$jruV�r�P6\��!��h�on��%�?.n:�-�/$zs�G�I�RM!�� �¢�#i�>t76��>����g?�`��C��9�M
��J���W��#��'a^$,�
�dy��x�)�Q��	+n1��b6�0W�-�|��n:|���r��# T�5{)�$�����K~�[�%��J$�,U~���<D��4�Rh�l�d�=E .���N��ɨ�J@AX��ۉp
�Ļ�w��0�5�5�Dv�5�І��3���f%�2������4�Daȝ��!�nA�k"i�u|`��@.f�)I���b���A�cR�Ԓ�|����/���3���q1������nQs��~��˚��֋Ǣu�Ny�L�N*n���L��Ȁ� -��C�qx'�4�"w��q8\�������Ŷ�Ep���P��u��&Q4������f�J*4�R}�O{�]�zo�&���31��0��2u}�TI�p����2	�٢�X� DF�sQ3�Ry�AW:��V���	S@ð���$�O�"��]�	A/C�8�k~Mb_\#r�x��2%�-�,L`���շD ��?������P�,\"�2b] o�F��szM(��;�#�RH�;R��<w�!;��jX�F��S%˥l�����i'�C~1
��k�����~f�5��+ke�>��� 0�p��wK�����~!m����r��B�I��=�>�"�p7Lf1y07M����//&u}�B�%��bje�$ѝI�F���D\e��l)��@�Ў��C[q��/)�%Q?����L��	ݞgh�;M\���H��D��>Ħ���?8��淳G��
��	s�G�h:?#Wyd�:�0.��>e$����A�S#�F�~"�7B'��s��p���E��Ӭ�����+��nT,��î���zO#�����hf�B��Y��@�0���T9̹���D2��B#d.n��o�ˏ	�+��o�L��?��^꼿�ʼI��q3�{�o�h(��И�s[:�����\ O�Iƕ�0�]���qߍu}���S�]f���D/�b9Zo��c��y}ZU��|��J��d��vh�w��EY;,A0u9	P�O$��4i���2�=Hٗ�yH�;n�v��7m�@�*�R��e��D���e9�>�T@BF|i���u.8�^&9�9k>�0�n�������M��xҶ�+�kSR)��ų|��������X����m����G���^�"_t��� ��Xdb���(�d_�B�`Z�W����8���_�r2l�{$��G�,@�U�R�ƞ̶��V�)�{�Y��)�R+'�p7����\>\���|<��eS$p����,�Q�96</���}W��ǀ}���%��Y��C0	t��_�?q�F�C1����G��o��ơg[3Bc$�#Kj��¯<���O��Y/ }�������bd��8�I�&K�ł�q��\��X��\��qE$�� ��.�h$�?�.JFH���Y�B�������6��p^ �{�(^3P�"N�^�<wZ\YQ�I}C�hE�Y�A�H����h�x�$��e���Fx�B���4��/1˘3�B7� 1��+��'A���.�p�=0�z��D��%�	]p_��q%9<�`���]:���L�/������}�ѫ.ކCIEf��<N���Nwu|.���9s�[du��C�_vKEh��	z}�_��l��9����O���$��,F�s�o�+�ծ�ɰ�$��~B#E|�����bY�i�UFR�w�\h;��G��f&��R�.{_^��:��s�y�}��J�?M���\���S!�#2��/>�B��$1�����Yk4D3�wN��% ٔ b�V{�y7\���ΎEM��օ]�^7$vdq�ze�D:�y�)u6�e�����{��ԴP�/��������O�5d']����)�$'N5��Xc^����쾟cV�]�lVUg�7.�G�L��䟚�,���~(�d�W�� T��M��x[�p�"X�lT��)���F�W��+w���=��EX?�J~`.�$��������^���V=6ˇS{}|���������)�������"�2�q���t�2�!�ظfD|&� B�,�#�/gT��?������  � �3�4�9qH;���%I�k�/H���l��U���͍y���7r��m�f��r����j�����}�H�.�w�GD�6�Y�4��$��iq)\D1Z|�C�"f��B�!��k�H.�?�O�����M���P#��Z�>�k6ޤw.Q)"��1%���~t��P��z�[��owG���́��m�~��<.J����u��'��� ���ڳ�M��<���O�@@�b�.jĬ%>����bʞC6 ~5�P08.$�A�H�U5�����?���_<�`B? @D(NL��0���N�/ϟ#���3Y]������{��~���>U�Ń?�����ύ���ɬ7��Y�u�<�����<[J̸���}�΍��:����Н˓�h��[�M���,����N0�#5�N�o���I�Б��F2��m�KSrq���JG:*<8���6$��1��gX
%l����� �Y�xʏ����p���do�>=��'o�#/>R��r�zV�e�9Tk�ѷ𕌈�_H:!��$���0V�[G\�1G0͌aI�Ϻ4M �"2F�.4�jzJ}Me?)�8��z����������cw�Z�&�JoU�-O�g�Z�V��\(�]s�2��Q�K璨�9c��Gb.2D�qs�<��[��.k^�#ٷ4�m�p�}p��q����L�Ư�
e��0�XI|筟|�	F��!O%�q�K2`��IY���D?-�ǵ�����tR]�;=���;��hڙ�ʼS`�%���I��vt]H�
���O$�i0nQ�8��j����[�AgՓ���S�u��h����ᢳ<s�7{~8��o���d ��TT}s�#`�]�0q
H+
&C71s ש��vХ`3������a��~ټ/׳O�Ť�H/�����%3hLC����ETT��
��iLQ%e�\	�G�s����Ͼ,kC�K��I��)Qݸ�,`�0*>�$ n��7��w�Ί���m�x��SSdG��b�m�iY�;$}�zR�!pM�Ձ�JWfw��Dd�a	�)(�9d�,~_/HCV��rA=��5�v^���Ce����Ke�N���Yl	�_q�}JE��H`��3�oHq]S0�N�q@��U�(�x��v~��u*�P�F�eP!"I0Q8ju��f'�F��׷�3_O���E{:;���Xb�$���]ү��SH9��"�p���v�,h@!��+I}ߒ/�W��&��uV5Y�����@���i��z�ER�����}0�d�(�<��`�55�-��0�H�#���d���V���K ��reU���R�����	\.@w�ʲq��\@��&�S9��](����(#j��z�ȳ�z�<^���5�x��.7��R�K���)����0�kb<�76�P����!G�_�떲Oa�B����f��*�r����+�01{y�(J�BZ�)h���D�}��+�Q80N0'�n���{��ݮ7D�b1!O\Uh���ں�g�jL�pڌ��H��Z,��'צ���9��_A�q�yN)�� �#9�B8Cq���"�~�&yԴ�U�z����]�����}�/_ۙtN�ϗc"�q:��ߟb���2��.�T�fHd��$��D�%t'1��� ���첗��q��\��.�2(�fσy�u���v.���y2��4���j?�B������- ]�m����`    	����Լk��m=Vx�u��qf?Qb�j���<���ˇ�C�#���z�Wx��iV�@��/>�B����"��p4>���)��_��߄��w�	�D����Ґ�cF�0� ���!NR�4�*0��.�0��LV��M�I���Lݺ6H?���J{���&��UT�R�&� ���<*�;�%��:h��A:p9��7nd���]R���n��y�m|�i��]r1�BTw����e���b~|q�#�Ix�+���>���0�p+�$�W�E���}�����|b�lE_r	%2e{�j���6}R���[.�*�/tnP���䱯Q�T}�J���
Ll�����8����H(�쿶Q�-����i%;+U�7�g?{�v	���ӁY�$n��X�zǼ�ߕ��y��>Ϧ���c�ۤ�k�L��N�!�?��ԥ�fmf&�@b(�r��U����:�����$���?D�Y�,mnkI��ǎ6���a�UL ��U�%�;,�W���+HF1 ���Za�ApR�Sʐ~���jgF�HUq��P���eә[Q�������䵔)���ڨ�f�B�%X��[n/?�\��3���Q���^�bρEc# .c$I]�c�5:R���k��w��ܳ�6�P���ζyZu����4d�[���(�/��]ʸ調��������('Q�!lr�e�W����D��΅���;ͪ�jl���V��^'!2��%{JE3Z=H�XP�g#W���T��5,F��U0������b�0��:����d_�3�k�E��)�}+�w��!��+��{i�}\�C�!��@�ۈ遥��Ð��K>���X	���Sa�$�?yj������%ЩhLH��q��7h�HH��?��1 � ��\ָ
uX�M)����k�K�j�R�4�����΅�s6=[1vn�
��n��.���f� ���*�L
�w�
��Dr'a￤��X���E|�n�.�����)��KQ�z�5�y�]�ϲ^b��~s	�wFa���pY�vNi�@�X�D]����&������h��G��;l��J#��coE��1����x4I4�h�ۛt־g�K�QTpo�R�P��"�3�W\�z6ɼc7��_5@	���j�+��Y�pY�Ľ^��9M�-���ֳ�c=�<FU�`�廝��׺�h7�\�Q%�����%��W;r��w�鹓]��i�>UH�����v��v��b>��a$�J�U���8�t�:e�kg#�V��P�J���fI��y�0܎_��qz��Z���jw����g~;�_,|���*!���Dru;��*�{��4l�}VƢ7x��~�Nt_�聆J����:�i�l[��X~�1/�J�NFtlcp$�1#I�"+�P��[7�����e�R9�vK����3���ѳ-�wt��6P�ms����M��*�&�<v������I.���-C����o��/����X6�(��㦴Jeޟ�zDH%3l6J��Q��|�1�٠��vA��R�vV^Ӡ@�a�mc$���K�rޜ_�8 ���(�]gH�$	{��.�L�Qـ$�F~�=�UA\��{U~^�N?�z\d�+};i>>��X�z��N��r*1�Xug�8~�>�>ȠP�q� b�+�$F̻�^;m���������ɪæ�q�e��4�Y�%蚩r@6\�I�}��5a��l�eH��קvӮo�/�5=�2�z{5ܟ�e�oV���@�Y%�u(G��*�}�Dh��:�A�?�q�3f�pM�]Ϙ�g�ۭYK�s�Q]?���.�	��E:��]l^7��:�#=�r� ���ث���{�\[ ����0q�˼��QP�[Gs�ey$�]:�2��	K@~7�IGV���IcO5�]�瑱J~{��pQY.�r�z:��tG�c�_�F������د�!�[G������M�c�q�K�Ţ),�ڡ�r�A�N0�
��/W��� �I`7��$�&��Z㇠{�u.�Y�K���c�Q$)�e�|&��p��}�*
�����VN'�nb��3�&�I�zy�SǎH��-;|_6i���==>�T-��2�_��W��5�q�+d��:�j���D�`��������=3� B�P�1���� �9���^a�ǆz���@�8Ŀ�LF�k	ЋB$��A~mɁ���H"���q���șS/
#2�it�Xʈ<�q����-�l
,M�?���agS���v�J������D���F�}���6�[����~�,�X�m�����k���B'i粴�ya��gX������^O�����D�'���7�>K՛;4��6��b$��p,$�`	wp��k3����:�Y����cOwΩ�c��$����VΦr;.ZZ��gBHd;�~� ƣ"���A$k4�m����%5��`�q�_�D���!OU]�N���\?��g�j]o�^{^{Y<�h��X���k�A{20A�]����<���A��'�F-�) pr�45���8�[	�2$�
^�sX.*�i^�*��q�@�-�r׋ʫ��~E�t
Ji�u��|�W���N�2N��r��G�A��$�۬W~Z�>���?�x6oT�)w,��V(��۬�z�ᾷ	X�m���*}W�HhR��M�d�lt��V)D�H�I̺�~e�}�������F'��w=� 4�-�����}�����v�*-���-�RdG����n��r=5��p�	f���6HT��� u�q$�h쭂��V[�Rû.����T��2�#Zl��od�j��c���n�c�3�Ϟg!�4I &���׮���/Ƣ�U�!$��o��\���Z���j��Ϲ�02�2�}��Yk����L��������a"B:D�����XLO��\�3�4�=+�u���$~c������:�����3���<g_*����C��k��n4g��ULR�m�r���^D�h���(jv��t�r��d�ƃ�ᥫ���n�T^2uV~��dg+�p�����L�ECF�V��DRۺb�K�2N�_I�f^|��;�E�8?���:��ٗ�*-�wQ<��g��x�:��OL[q�
HK�t�7���z�+o�^��K��~�s�U��ҙċY4������f�,ugR���pR��iGJ����Jf��,��<��DQAI�Or%��  ξ�~V\of���C�{��/r}h�Ώb��n�|>�>����y�Uö��6h<��N���@?%(�p�H���n�g׹�K��n� �)���=���Y�M���E�;t��O~��+6z�=g��鲳R$�_�^��v.�`��yL�HR-50~�d&dX>!Wz���DC�I�������� t0�̋�?�t _"��z���LE�$lڐ�F����v������M4� K�i��aO0���ތH�&-�@�
g_Mfa��:�%JI�U%4NrM<�
��5��_�ؠ3Ё�sF��3o�k�����H�'�l��{����n'�R����|:<���l}�/��ä���Ǵ|�B3�	�y+�u��D���b�9.��^߷p
�����Q��sn��}O��IbwVS�}\l,{"�:��r��pA�p�p7��cc����58n�+����?�8�ݥm���y������|[�_����ǀL��6����gf�H�5����
��Z�In��&Mf.n �0I�e��,2��H�
 ���y_~��T��q����$S*��k�rX��&�@�JZ1�@(��$�Gg@ހ����jvC\#�;@*H�b����3t�`V0q��Jj�s!��8�<�u0�㿂ƞ#��R�ny�d�ZY����Z�b�m��,[��e�]$[>�eh�g�x�0�W�xq��^j��0�y�<@�T��g�؋�1k��;W���y��o�^c�HP�oqBA��5JR&"��4���59R7xՍz ��i�D�t!e$�z�R�-�YViys��燧an��-W�n&��h��j��^Y�2���Z�u:��Ҁ�?��g���u�F9ÿ �0��\~�J���    ���u}w�ǭ�[��]�a���'/v˭U�i/=Lk�l�*�0���-�r���
0�(� we�����.�HG��������<S�qIn O�a2Nr�� <0i�KH�o����{/�fc���fu���\̫����������n\�d��M��_��Юxǌ�f��N����I{[�U
�w���wCb�K���mT86��n];��������AX���	'��H8��4�4��,�?hvRN���$ƥ��k9���i��{/V_��潦�G��~N��GϝN q1�E{,p�ҍ���L��I�Kg ��ϙ�_�N 6��s	M�_�D�u�j� S����H��f�Ћ��:ID߯F9}TfU�}���ج�ۧ�$[�mg�s%�k���s�6���EJ,e��:������xX�x$�ԣ �bXC3���b}}�c�E�"�#�zUj�"١�Z� �}u\ʠ���Hw �����?��E�	���B�>�W���qy?(����#/C_k���;�o�S��W�tz�nλrz_,5}���վ��;�s�d �h�?�$
Zm�� {�]�k-�}��y���<լ:~�w�O���~w~�<�m�d�̰�<i��	�M�Dp���uY�J@
�m����]�0%��H������)1�#�`�"����(��)��Z,����p��rM�$,�fI�n��fnr�׼L���<Q��$q�
ApW���$1�]XJ�$���)�v��xY�_kS�������<�;��V��$�(���d��0B�H�Ԇ�	������'	B�ɼ5�5�v��W�jzڨ��E�Ʊ~�m/	���n�FȹV�%��9q.;!q��z$D";L�޻�3��ʅ��I���8����7��iC��m�=:ƍ��eɀ��m��Q��E�gN��&N�jI��l��(];�|Q`��%�ũT	�DR;w�F!ꑰ�B��Zp�ح����r9=xo�zd�=&�j"7��ˇJ��9-��L�O�q5w,��ȱѷ	��*�T�?q�M�[�P�(�f ���?�o!d��8:�hm��+Vc��`I��q<%���)�c 	`�����(鿔|b�,�n@���xa����1��_RDӸ�C�%�A�'QW�kc�N|�P�_|xp���'mt�9��&���7�MDz0��u�լq�r�V�B	@�aD~%��%	��;اI�>zZ�ۻ�������u����������_��^l����5������HE�9E��D�I��h��o����d���i3O�j�ҲP��f�ֳ�S��x�[���ZQ�^�OSUVo���/�a��V(]��"bѣ8|˱-h$7����.�� ��=����b�#��`{�P:N�J�S���V���`�a��0�o Y�7I��5&a"��u$/E���30k]��u���φ�j��t�%�󞐤��'y�Np�9���䌟��N{��������טJ��+�7O�~�L�Nh�[�na�L��u������67[�o$��m����ʺ6����0#�_w������+s3���Z��R�d�긡E]֯��ފ��W6�z�A���u�{��������b^fKJ������`p�׍��y�?�5��6��!qb\���b��Z�InF
��qWȅ���E�oE�e|��%Ѓ8���;�&�FQg���P�T���8�~�����Z"
tU0�4*���U�7=;F��@q����g���J-	�(�l)zpBEpR8�58	{�p�V���Hh=c�]b5 7�ǌ���� �k�˦�߿U��ĢҘ��2�\��r����ȁGG��yY�$񠰛*�y	����9ذR$Ѳ:N��e�|t-�C^��n�ub�����nEd��p�e8��8����F�jW!�b��1����
^g��`��z\��RA3�[�mЩ�C�����>�̙^f���z&������4��&"�8�ޗY��5��8�Y2���Q�
ǵ�Jjt��)��L��J�K��*�h�52l݌���"E��r��j�1�g]`O"L���Z�c� 0+�(}�6�k��B�8֨8ɸ��DH'��w}A�i�bI�t�
���x�X
���jj�$l��
�Z��k���X�	F�$�E �Hd����k#v�lc�k���M|��?0b#_��L��n1eG��������j��<�o:��~��˸Ҍ�Z���3'����F�%�Jo��k�¾�-Xz���R��}I6{��̤��?�7�S���x霸��L�}�r�KL!>0���e�q6��6Ln$t���gt�����V���f�[�lc�+�X9���G�q��wz�茔�O�|5pN� U��]�~7UXrId7��~�	w���2K�Wy��Y�klo'$�!��ɳg�F��D��8u^M�N�χ�шC��J���ׇ�~��ߪ�>�t(�r�Oͦ���H��@5��OUZ��=z���9��נx��u 0��c.��&�s�@fQ_�p�(C�&�ר!���X���7v�ai�{)��:�tj��M�^^t�h����+�A��V�Ǝj�_��-O��rl���5�G�6�!p���Du�w��x��7�-�~��m���Z��V����n����~�+�P���7:Xzt}��+�d�,9���~�^�>͂\�؅"ߐ���xٟ�W��GAm�Q��,{Z�
ُt+1;�v���?�%�fq�*�>L8s�O'��IwP`U��	r]�_S>e�[�Ո���2���G�f$ޟ�O��	�0�f���A�%�y�6��It�^-�"v����W���w�������]�%����i�>?=��r�?5����̥PV��a0z��G��hV]"F��h�D�I�<7����Jz�@wQ��2������6YM��I>���N��ӥ�.��y��z�4u�� ����_��-�L������� �`���W�
�A��hJ�@�<<�;�͞��>^���ᘨՊ���z3Kl��3p�a~�/�`�kQ+�҂�e�$�%�p��o[���.4��ݼ���z����`K�/���`՟\^�d��2��l�؊>,J�Q��yb�_c�TquC-@ׁ�'���D�UZ(θ���"��N�K��6�.��I��j,v�s��W���:�;�ŗ�\уTD|�
��^�☒;A��̵���|�WO�.W��Es^l�6���i=�y�[%�CN�M��0��{����k�G*8�hR�]��"'Z)i�]A���M���u��ɭ��YVa�;Ck�+08_�F#��UZ7�Q�Qu������^�.���(ӊaI��!���k68��)@���� O`�x��v��S���[b��w-�D�A 껩8�(�k92�EQB�rd�1r�q��j~��eнT'��d�ٓѢ�}�=�^�0���y�K�V�C6[��A20�+9�ze	���D�Z�"�?L�Ʀ`�V�����x��n�W����p�O�0�D�[��/:�}�ϵ��ֹQLL������;[���������4�J�c�]�|�۳���ǷHzI�,4��'	4>���` ��з?�rg,���ܬ�V��,�<��s�8�ד�Su����2!�3��P6X���/$�G��ʸ�͘ƉK�t�_8ĵVÝ�w8�Hs�ڟ`v����8��FC���f�8�@/��]�+���S!o�:�	���g��S~��x�j8WM��>���#
�8���8�!�b�V�,zK�?(�-���c�1jw��)�ꦲ9vr�SY�t[G�a��ü�[r� ��2���J���7'�&�+h�ļ(-�H8Ao�?i�Q�y�n��I���x�C�N�e^�r�߷����"�2�Si�P��40?:�Yt�n8�ץ@q'9zl����5?iv_��Ӣ�9���`��,̲���o��7�r��8Ѩ�^S�P��1���b˓�nZxݩc$�F�Y�qx��Y�.������m{�2\����h^����8�0m��e��8]u켱:��Jlrt��<�z��u����H^M�R���om|Ϳ�    X�(��X"��D#	F�|$��'�_G��\��n�U�&N�^��	��F�B��}�˲_��g%��~̏�����������c���_��~�m�	%�
��[��� ��9�I^̀`y'��*���쿌��W�Nq�M�VfK��z�6�����u�5�gm�]3�pKa�� ���. ��0I	���+O�}����e����ͫq��=�8����i��g����֎����>�F_��vbJO�G����Oë�B�6�����cz��+GK!p�<����PěԵA%OE���Q�K�u�ГW��Y�����ғ�pU��ti���I��;��K������W��U٤.�}�z�F�C��v���P���w��`���]]]!=p�\��W��{��^��#?�|G�nQ객�Þ�GG��{�[o�6ل~L���S9��Sk�|�(�,��h�~���P!&�a��i����[��o�߿x����+�b�y���+i�f��-_{|э�h�Jӫ�FD��y	Z�ƆbXHbn�*G���UcIí�엨��^�	؆$``cS���Jc�6����!��o�3åT��S���}~���=�F�CӴL����v�{$�^yxU���
��,��z	L#�I�7	��1��(�Y��_��ľ�R`t`
����`������jF'Q�����X���|{G�������Z7��B��d�vۥ�j�k-���t��̥Ƃ^/8 ���,~��v�A���N�ewҌ_��|����ֳ�&4~���Xq�P@>�	�C�7=՛ր�J8A����B����[���{9�:�N�����&�?����˩�>��n�#�3(�+��ca\��&0�1�S�y%Y��`�	�ϭ1�
�M`s�ƙx>�Qu�a[�s^Q2Nr�(�`>����6q���yhg��8�2B=U2��9玏��i?]��W���'�?��7Ap��(������G�J(e�eP,	�f�����,��{��Vh����e�����S���ļ�q�u]�v�����!}��ub����l1ȭ�6%���3O�E��֏������yjh���q�z�N��IT�ټv�vȌV<�-w�~  �I.^ o�
R����o���=ڃ�{�r�Yf���QN^��܁�h��}˾�Wv�rZFdh�u8���k�#N�[?��O�	Uf�8|�ȩ>�����O�S�.�a�i�z{�h������S�T�H/�;�n�J�� ���֏��K�F�~�ӳa��-�	�9��Z����s�y����8�z�F����Rλ�}Y1�d^�Ԧ*�����i�M}��6���;y}�8�z�u����}+#;:�;ȁM����Ӑ���ah��%�����b���e:h�iW������G��P��}�pO_2��a�B��9�nK[� ��V��)Ι*D͝�jG�ﱢ.��
�skq���>��
W�/�Xi����A�X>��n	&��nvHG� �EHp~2��Rz�.�:F�fc.���n��z�v���K�X��:��*�ա�:/��[�}F�-r�r��;�=oXno��-~������Ǎ
��_Iڕɹ|�;!�o��/��%�J�Ix�E�;Ʊ�&\�I����7��S̱���>�5T�1���vJ�� ��2b�$�����	u�6��4�.X5��w�C���~sNΝ��L�B�a��t:��v�3���L��(���C5��B�q����o$���J�K��E��[��Z�Z�}[��Ja��<?Lȳi�O׉��'����v�e<��ɧ��nr�D��B� ����B�כZ>f�Ey� ����N�O͗w&��J�Mv*��\|�F4�:@��:M��$T�t�+_�(q���E�GF�R@�:�rئv=�\h7	7q!���4I/��l����q}|�4����);�G����Ԉ�wyE��� V&9�Vq>U��ڡ;K�.�pwm�9v����B�ғ�AO.>
i�o��p�띱��I]�B`���$V�0�p�5�2�ȷ����Q�"��[��#�dG�i�������t���	�m�����Aן���Ln�o�X�q1��7��*�
���YO���d��%���|�^��rz�e;�Ž:�3����������T�^~+ۺ�:���$J'�Z�>o�s���[y����z-j��`��4��qqy(��1�l<Zߗ�=����r�&���E���Q�&�H�1Z��[���:v/�κ]꾷O�N�׵�&Z	#:��|k.�o�}�&B��Dz�����D��� +t��JK~�K-�����K;kϓ�h<�,�;�7�	�ؼd����E{���9!���\����#*�ZM�8&�r�$����\�^*ϙ��9�]�̠8~��?޺���T�h۫�MM>i-u����(��\,�N�:� ���uI��'���۰��<N��'�6o�&�M3�2���|VVD�j:�Nءopx��[�{�;���=!)��`p��"�F��=]���\ϲY��L㸛�4���9e���3g�ڨP}���:��ڛ���辴qw�+p��_V�iJ4�{��7҆�D��2�w@G�Ե c<\m�	��s}�?���S��D�>A�#�!��)�	��Idԍ�XR��lp�b��Եڒ�����?;G��^����/�i��|���G��� ��I�&.����������#J��p3ܶ�z;q>� ���I�,�J�J�ixd�k4����~P׷�x=0���H^Wl�]�&at��ϣ}��gA�ý�ov��v�.�޺C��پ�V��~nV��<D�2 �Z~�X��XKoM�1�Bb���)����8�vk���یr�L����"ߔ�f����Qֆ�L��`��L�1>'p�A����v�c2���o|��;���аU�Q[,��_��Pwzk�NjM�ʉy���DR�oZߦy؟t`O�),ծ�+fs���\z9ӄ.�/L�PU��z���U'ax+��5\Gv��)�p��)�ɣX7��kD*�)�䇙ߣ�����%��MŒ�e>G]Y:Ӯ윞r��C����J��
�:XS��n�G���r� �t�=��M�Nx�G�8 ��d&��&��Bz=�t8��JR�-�B��[�ߔB>��4/��ӧu+ߪ�*ͷ~ck��b}=H��/���.j����{��4��X�亊�\�H^#YP��5k�+�m���k�����#���kQ�Z�8�M�5Z���7��9XH�+\3��8��Z-QXc Qd�$o04P���k��e����A�LXZ�b� �<j��ڟ��M�~`��<wf�H^v6�DC���͝K:���e80��h��)ܭ��u1V��#�QpW����C�n�ܺW��UD9�N���Y�� X7�*�����)QNv���u6�'v��&4(�������7��
���7��uĊ^a�g�;�S�Oz)yy)?tR���ET��L��OwO[ۿ��LmD���y��N����W�'��	A?� �e��;I��Nb��haC=�����5\0ʂ*�Py/&��VaƆǗ ���9δ^��k=��q���iY��E�5�d�R��)���/��N�[��}��8�O!!���Gn?v�`��T[�)�r����R\90Ϸ�Ci�<���{z�4���t�;�.W��u�Sy[�v��js:�]ڋDM��:p��('Z7v���R͈U�.�"����U�6Dϙ];q c)�H1T�u�8pB�ڇ��?��abnc�i���!�7'ֹ��M�����=��"-�Ó2�$��.�4?a�?����~`b��!�ݩ����.�ɶ���mDb+ϪґFW���Δ��-[�dat#�v���A����r��jb�$����.줽u��?a;েe�����yW1������1;�	��Z��].O��� ��.��j�������� ֵ�����Hq�`wp�ԯ��3i5�2D��    �UN�����؋ѻj�*(%��H▄pU�pؙ.0Vm���=H���H��p����&K�tX�y����ְ��vu�r��ڽw����ko�?�/�P�u_F"$!��R���z�\�9���G�r�����ҫQrv��3�J�{�:��_.�>M�j�[�$Z�Yi�v>�v���0'�MZ?w��Y���4���Il���<�ؤ�1w�P仔�z�����0�cA+*#��u%J�j���b]��5��8�:]!�ӝ�Y�ǭ��6UK��~]k>tZ�ӥ�"ک�*lɖ���dX�9���%@}AY��"��H�&����{NR"}d����t4�5���u�%H��,���
�H�$�:an(��Z�+���,��a� %@!�/HDRQW��c�AFՋ�S (N���悺~C?�$_�Qb;陼>�+��n�׻<t��ps_ɏX��>f�*E3��E�1��q�b,N��B�)̥O������qdG�}����~��y��������`�ҩN����vt��L2|����K�f���	b�G�6��N��`2��p����#���`(_�E*���Em�6��/����H̢�*)$��x�V��˹����f�W�ʳ\��i̽�.`����> x8����N}!���/��u�S&���-��Q@�6q!�SM�"
�N~�x�A�5ˢ߉8�9eK6�h�i�Z�_F�y_"�|Y�jO=�t����{S���p�9�qH�RtV~C�)2{'�2�������IR�5&jw�ݏ�yy{><��ʪrΦis[]���q�1s�v�]/	,�f�L 	�M�sD�|(�!	���ɈC������ݥ�7�<���R)�uD�R0v���X���f~�C�E��d������H��[��:�?���S�R�'s�V���2�֍��oh�g'yM����\�D�8��2N�,�0�K,'�𳙐�|��T��p���C���q�1j���|��~�r;'����08���T)Hm�e!�o�;�s̝a(����qoh�ܾNPk�����v�b!�ʎ(�]��n	�SU���,��%��R�Z:�C�>NH���U�ʙ���J�休�J��6�K��h�L���A>Q/b�!x��Fi(;";M���!ǟ� 
���e��W���	��V?����W@'�,ݥq倍�����\[�"�teMN��NϱX?5�7�U�xs?�M�)]X��C_"[���g'-��eL�0�$PmtD�R��a���g$�1>&���	y���ņc���P��qE�o�I���7}�|���^dds\�/�I	^"�Q��8a8�	�X���g�"���J.�D��q�>b�'+͊���8�wG�ns��Y��� ��*Dߌ?A���I;�(	� 0?��r���AL
� NA<�R8�N�������Ev�ߜ~�����ȿV� �tA�ϑ�3�u�!�4N� ��������7���2�MD�2_���ǵvձM���>�@��'�a�~o�3���u�"$1BC+�NBEQ��w"N~�s�Et�n�6��C�6�Ə�L��F�At>]v��Ŷ?m�ߚ�	�2F���^T���t�1q�L�����9��C#��t��HL�'w4a�٨ˇ$[��Ϗ��o#���w�!|3���B�ͦ�af ���"iErf�G���_�\j�抩
�4Pzՙ)��G����q��eY�F����_"I�����!���DY� ��a��B��Zs�9��|�MOz��.�N3��/�eѾSD��,>��b�r���%��[:7Z����!�5�3��@���^�Z.4��k6�9�����t1���;�'�j�:���<7�d�ث�,�h3��ت�ǖ�|S����O�)]?��Kd?�9s�	�?'o � �Y�PwTh��btG4B@(�LPD��i�W���>V��@әo��m#���ȗ�B�?�!��5A�Zj
;�!�^���;��=��9��b�Q����_��i.�QE�g39���Μo+��+3�n}��1R�]>�h̸_�9"
5rb\>a���W-�ϻ)ǣ�<Ow�ޡ5^2*[����\�Nf�4Tc���Ǭ�P@��}g>�E��3��tʎۑ+��^Y g�^������2�w�[`��-G��u�#���q���P�W��9V��xv@�u~��4-��͞_���6s��3��$s�/>�j4��@F�#�O���j~dE����лi����j�ω��Df�XlJ;%c���T�au��c�Qk~�g��Ye��nW4`t �{W}}}H`6"�<D��R�+P?���ٗ�~+��2�J4���?�f�~ĵ�g&��t��$$�嶺��ʿjd���@�cP��cA�Cn��M���ND? UC��D��8Qj{j�r�A�+�	'A9�a�pm� }���[�Fm��{\H	��Րev�
_����R���.b0�i�9�mtU��h~ǥ��r�bk̳�ȭq?��=yı�u�ޫlǯ>5 r��;�J���$���.�e�?��h�p����R���?@F�|h6�
�/���.�`���ޏo�$���::��]�J�{�z��/e3x2e��7����M����2�Ƣ�x۷x�_��eN������������,�5N=�k�+��ds���f>Lĉm�~;�+k���3��g8u4�N17�a��n�Zi�Dk������~�Ou��y���ɸr��b�(�ܵ�u*��J47̈́j^r��N's�@+r��y};1#����c�?�	Ȳ̫_����3�T^J�ț�Z�d+��%'��XV�dsY^מ��6?X�
��]#����7�Y|7b����Y:�hř���;����/IXdqk��h�c���Z~������0�w�7ָG�گJ�³���r����c7��3��N�`�p��2��'q��-75��1�!��a���N(A\�E-ż�4A��&��x�/����`p��x�5����$������ �o�-��-��/��O��dF�i������3�!t3�L�E��I]q�{l���ed�]���C�6ĥ�������~��[k�VGY�.����,�ݱ,n477�u��o�-�$'_/�X'�oͷ��Rʧk������a�}��kk����I���!v����6�7�%%|ӳp������R�Z������/4n�`.x%&_~Z���v��/���~�V�-%����_�\n?k�젩%@�|�o���ZK�A SZ|'�"Ю�೸�3�`��OZDA�iҖV[D�eMA\�+�v�[�c������קv�fD�$ۑ ����:���!�"-6
Yz�L߰(��ʂ��:;����C�x��g�6�a�'�F����(wr0�NV������?_ϴ  @���?G,+wh�$n�N}szǸ���p[ʙ�E�@xM�_I�g����1��M�f!�ey�ug�V�%��J��>O�%b69 Cn&ʳ�N���yG��fu�)?�j�zʓj}�S��e�Za�"uK�b��F#��$'�Y��3e�F ��$,�N��"mq�ˤ�|΍o�j��o�Z��i??Gr=پ��3�E���������$}�e<���t��� ��b�8�N�	\x
�s}��6(�#M?���T;�:�[.g���s�z�'ls���	I�>���e�\��U,��U��)�-+��|ލ|um����i>9.����n��|�����o ��������;A�^� �r�j`��a�$���ө>���o0�۴�/O�-/��ꈇ�j%��o��)R�2Y�K��cZ�^|�.��"���-ҙƃ��KI�w"�y.Eg�)L���)*�-�9V�Zʍ;.����J?�9,�d�] �_�).:�J}s`�z�.�GV%�aO�w|4��2~�w��#���N����T|/�%�$���JR3B�Ϗ�B���L���e���,{�-5k�*��}����A��[��i4�L�,�JV���+l�
n�R�qD
'5��=�3�lYT~�;]�~Sнkj�n��h�&���O    4r?o���!W��'"}�en�*��5V��[N���r� ��}G�m�/ ��kP�L*
���^A,��� |�������<��^���܁��h���?b�<���Fw�.��T��eT����4�X>-�w��K~�Uq��ή�%"��xsj�7���6.c��6����i�յRs�u��"#c����Oz0��|;Nl����\��E0�PF�ٹQ����t�9T�����D6�ġ]<�'yIĒ��tԊ/zxa���@�c�� �A#!��UZ��W۷��������Y4.&�^"�|+�0��rͬ>F�����Dn���LD
[���`�b'������Sa;ai�os��%YQ�&�ܤdK�Mt�v�rޘV��ٞ�bI�����j�*�[gթ�����WxF��EDx/�iGȥZ `P 0�I0�Lq_���k=̕�u1��æb������tҾ(����O�*����&����m���D}�(�Zl�2E��Sڑ���؍0�F�F|ҿ�V�?/'f7]�ݾmn��m��`�E��"��`4	�]w�-���C�F�����U�n���I��e-I������2��,����``�r�κ���2O%�5��u�'t�>Y}�Y�kc�ܔg���T�����V#-2V����P�� `5L�B�e���N9��a�>��s��i(��E���nv����d2\E�G�o�����S�s���%��>r�S��$��[Υ����9)&��JX�
a�s�3HVn�1̟h��Q��L{Q�!LA3AXbc#.LDhN&��Z9�XΠ�r���XL�����.�������o~��!c}��1���4�o|���o��)߾�d	���
�l��RR�.>k� �#;Bq�R���R��܃�p�ZqhU�#l1H�ߍbfw�F<�B��1��4N�v*���yV]W�֕s��BeA^Zt}�[^�ҧa�N�wgƃ�j� Yu<I����!��<�y�Ab�͕����;F�Yz�������o��4�W��?�O Ms���w�wB�z����mc�"`��ʾ�	������|���.���v���p[h\���mw�pz8�?<�V�D0X�~��臡A
���;S/�l�
i�G8��+��/s:0���d"Eè��^:W�CXA��s��"����c���
��3�<BoϽ�
,�N���q&@�;��Y�%�E��Ҵ�	T�'�<�zn�:��!F��Ils���-��B����m�0�eʥxr�M��C�<C�-�'ӏin���Sf6d�E.��~ n)`���蚅��fi���R�E��+p��W��oH|rWz�Z��*1Ώ�+k�\���Z����SϬ�n�4�G��v��
���n�2�}i�4�$�P 0�N$�/�hw��H�Ú�Ѫ��tWݷ&��<����K��6o�H�{=o�7�A�}��;0�f�](]�E�f��'�P�p?T�N�^�+���xB��H<�+�{�8�Uڇm�U˕��W��|��@`!�+�5<ﶏ?��j�j��4l3���>c���,c��B���9?d�H�2�W�����M5��>�J���7&&��o";��6{�~1Msm�I���i����dw����R{_������)�}����;2ٌx�9��c\P�)p�'iq�QQ�/�*dA�5�p��'�?N�5�*�/-�uƇ�s�Ek�X�����z�p;�[J%��Fw�=W���1V@6�8Ԋ��p��|j��`?/���F��;d"��R�U��������D:Fl1j�Zd�
���_>�9��Τ��
K���s�'a�̠>E��O	��Alü~k���>#H��H؄ 6��QM��}̅gi5��/�ɡ��=��Z��\.��x��>��ͼ�������n�;W��d#���Zխ�OB�Ό[���v�QPB���f�ԚN���@��C��fH�G"��UF��O����$ν��TI�q!�sϥ��W�,�o���'?�B��'�_�ۚ��
w.�2w�6�u�lN���M��"m8BI��j��Җ�Y�3WAp�{��}�֛2w���R���2�>�Na0 �� +��	��ts"i�� ������N4(�&a�8�Pv�a�&���8H�D�z@�{2�w�Ĭ�"0�������_ 6���#[F�(��K�^��H�W��u���Uy�X3*�J�f�i㍰������&���R�Y�	AC�nvF}ۮ�q�.����"`Q1��h!���?(��jQ��ՠE�v1ZE��.{�fIW]v�L��A�t57�'�� J oT�k���B8��ļ\J��H������Ny��^�K�x��eN0'��HH_ˠ3"��T�w�P`m��)������Νpjז~���qWJY���_��Hj�i�g��q�R�UQV��HM�q�V�j�9��ipm��C8u��"��(t�5 t�2� ^�q�����{��:�B��p�HS��U�I�����B$$	��'_,Hm0e�E�Y\c�h�sp�'*�W.%���=�Ope=�.��f��%YWZ:���*��v�\3Ǩ{��bO��P��-�Q����%Dh㲳}&5&Mp?�'P�#[���N�?��y1�ˉ��MHS'/�:,�c<����l8s��w~9�8��7^9�_��sD93���L~��lM����HH�������|����z�]�MDBA��D���g�S�I�����5��!�/��f���I"��GZ�~�u+>���SA�߃��Գ�X��{����w"!�0��9Ӯn��'b�y�;*�k<J�'���t�g��.U�Vn{Ao����~Q� f�	���}��@>ӥ%�]������|U�E���L�+��������g���ޣ�f�Ln��Ru����`S���j�-vѰ^io�3��[�x!
�4�;{��!������`�+,�v�
��Y��{ 
�����2:��m������?�Ns=��zXn�'[��u6��k7����Ƒz�jm
<wKٌ����E�����/�`�W� d_�=3'�83�;�P,�l{�}��zz����qP�f�gc^�l:P{�~>�Z��#QXF׏��N���%��]�G#�mf�,K��H����^���=�-��%y�p��gʞt����_��
ǀ��$!���|�/r�Dl��N�p,�pە����u�K(V`�\P���1�?Q f��܆cxz��i���.��0��1�~����M��S1n'������ۼ.��F�)K�c�8���l潶r�_��0����A�
�a�)pQ8�8��C��(�<��DgT�m{��:s�%ׅb�<��t{�^G��f�Rl+�ۣ=-J��\	��[��&�%�Lq��Hh�v���Rڅu�`�8$��ը�lR�Eʁ��Z���%������uԙ퇬����ώ��!YejVeD�V�nG�V?��1$�v{v��s�of�����/EB�Ë��!�㢼X�yD�4�N$�Hwγو���l�e�h`�f����� �)Q��_\�K����qu�_s�� �ܭ|Y���:��%��N*���5��1V�$]�%�V��9�;� ��d�qY��OO3S$��ڬ�yyI�K� ����R�NI��"�����(m�Ӑ���[���+�47���&^L�P��Hs��H�;�^�ܼ�P��i�L��n�s��D��}�X0P���}5i}0��`��~'���I���Ol��~Z�{�Ic�_ܳ�iN4�f�2y[����Y�������yW�9����x#��B}K��af��R	4���D�����4�!�R��=��E�ɞ�����Q�{��v���"�zb���N��"4YW��D�V��r��}��և�J<o5|��n��`��kP��(p��\�o���*�O�)���g��Ά3[b�����D�g �yf���5wRP���Am��- �$�#`��^���� ��%��� �: _>Tx����iG49�ȧ    �I��e6��R�����0���h��Q��Odu4��s����{>�"Yz+Ir��K��0YS�Z{�ї"��.Зw�W�|-C ����
��t�����D��N���"�J̲���=I=s������5���l��a���}�����:-�J�z�h��0ȼ�%t.�{������~p�kz�R$�ە�:���a�V��6#���[B~!�<@S2W��Z��N���$D�N�Qi&�B!�(p��@�E�]dM.D�f1�@�������+�<"�yݶF��]�l>=�:��q�\+��3h����F�_ Hۋ�w�;��o^0�@��}v��@�C�����Sf�{�*`�&\3ɾ�=>�B,@��t�F�a��H�Z5V�?�%�(� nJ�=�\H�d�9�]���+��6g*�	L�v�BS vo�����nG��e�JK�;a���ƝY����C؛�qߓ�r7���ǋCLԲ�͐�ϷT~�ܲھy��z�,3�Ch��Rn�E��aVZ¬!<,�: M����f�]6a
���rn%6�a�zE4�/l{M�B�w"IޜG�SSP�ǹ$_@���( ����/�k�fue��y�X���鲍�v�fc?��3�l�Z�,��zs���+)�3籺,��qP�wym�\2��A>�4P&D a��D�����$�d3�Z��<���6�=���=s�'z�m_6�Z��w�z�Q�2�]��z��D~�`黨%���$o����'�>�e�m�_IG���uۡ%�`�8�Ɠ��x�ڄ挅�� Z�}!�E���#�\��D���r�]��2r_�͸��Ǔ�=D��$��wT��x��w��A#���
EB"�)������";��C�t]��sVT:�h�G�6e��v=���ոo�ǳ5��,�� �����,�N���/W(�Hmk�����h�%�>Dch��_����qsM(��!>��b�3xm��}('��s��Dh�a*+r�2�	CQ>�S�v�Dw��Ϫ�a�)��Ŧ��7��{�&��Z�%��=��|�q!�G���_�i�'6�k�Y�.�KJ4tZI�sW7��6�����e|�I�#�x��(�U�dio�k}bxp�&ǹk%g��ҍɲ���K.�� ��D��D��i���K���Á��D�m�Dҷ5@P�Y#�����I��p'��cD���;��^�����v��|���Oq0��.�����à���3�<0�/E
��[��^<���6���x���7�doI$ "&.w�����Z2l���/E���&L��x�y�LE��A3��|I��x!��Yt�OP����ä{��s#9�������f��:����"���x_N׼�I��D6��Ѡ�,p�����Ʌ;����C�8��a�u����ۗZ�b���(�85و��h%X�T0@�g�P`��5g����J@L汹C/n��^��)$�_S����zuS�%��~!�@@������1Wo$k�B*_Ij�NN��9�˹�v4��~v}=��� _������VO3�,��6��^Xd��v
�~�Z?o�u�/�ˋ�,ӋZd��po��<�l�^�F�n�h��ၸ3n��ܥ�����l#"�E&��(�:���v�n5��]���zP�?��s,6���q؍<�q>�ܫ�Q%t��Xo��B/8�,*$¯I��B��-e���!
| �P�â߉$��x
J��!1ޡ�D�����؟��M��qXd���m���y��C�Խq��"#vJO&�?܎�ˀ����!�Ӵ��&k��UI��E������2�J�q����"�rㆀr���D�O�Ѯ'��Z-Z��~��c��a�s��Gj����,���S��׸�Ї�Z�@(�@`��q&yX� ƚ*�J�� �Т���r��8�kh���C�>����ˮN��K�/��	�V���T7(p,^m>�Cg��w$���Cr�A��Fp� {�0��,e�
�'<,�����4wG�?O ;�s�.��Q�f /��"���\�%���??'�(�Pr+e���vSΟ�D"�~;���/�q�����P}�����$�wC�:r�XS��;�T�52�Jo(���|qxAz0�]ԎNkd*n~�'{r���}�XE�@���˽i:���/���^��Ĺr��x�A� ��k�?��x́��Md�em\p��/�'��GgTc-݈Փ��1D�N�՜�Ko������$S�oN{�`i�$e���b��=͍��כ�t�I!/i	E ��.��ݮ0`,��u�E��"bI�������i�DA��|W�زY5��A=�2i��EϭSꔏr�7��0�5J�Xu5��}*��U������a�\E'�+w�',J����i�[b����Ǎ�<���4��C%�E�Ջ�M��_4���t�
�K�}��~"�.b���v�f*�؎��sR�t�շ~`_�	VI�H`Z��s��#�'��=�H���R�S��>���#�Pa�U�2�F�����0��aRg���%��-
�n$�ӱfzr>G���c��T�C�q�����1s�?ٺ)c����͵m������ߥ�ȷF|hAS�g�|ewG�2#*�s��h_"	ք��s!�/�KW��iK�c���cz1��i?q��eR�Z�Y�����9����,�����	������Va���"j���]��Q� �`h�+d�ه4��u���f�~�)~1�l�W�XG.�g�1����6<�.�˱:-�bz?��ʓ����*2��E�Yw�Ң��`m^ pe�*���%_�8|slT�y�_�=�-��Y4*��Xgw���Rζ��:�����Vb�z���B��G[	��]�(t�84*~@��ӏ_��z��fq(Xg�KC�J�D��F@=5�7SI�뵨�e�)l'��<��Lg��Ԋd{J��Z���Qly�.��\��P�ƌ+c���f0�O����=B�C)5,�0#��	]+2�fBFPJ�'�^����	z�+M@�� z�?�MX��zZ#Y;��5��o�^��U�%>L��I�_ש�f��i2�TH�\B����\�Ot��`��=
|J��u�&'��-*����2
3p:j�R.S�G��0\<[�^3)�a��m�� }� �େf`��8��/��*)�{Q�,A�������Z�w�C�!L/�ٺ=x�����[E�~>�eLv䘫��A�/�=�F���^���Ϊ�I�f�L��A��������ܟJ3��E`�����T�liB'0����� �x�8/H ��
<t���$,Ґ��J(�8M�?-�G��}�|��a*�)���9�o�C����|������cR������5g�ƪ���PY�L�ݶ\�E�Ъ�G�b��0��y���]&���s��5=_�c~����<��3�AcЉNh+ԗpO�n�]}��? �c�^���N$�?ُ��8��ߠ%����3�� ߉���MR��
�eG VA��K�q�0G���'��S�����Q]�'dk6��=�n���ղwo�����٣�����f;8���M��N -3�g��������_L~䯙�*�G����
d��.V��3m��CQ�D9=L�[�D	�M���æ���g�%? Վ���N�#(|���uj̀=�Q��Eth�pp|�4�(�`#�o�{���,`�߽�~��P�s��>N�:��bpB�Z��I�kh2����=�E_�h_��$\az�h_-W�����7�J�JQ��$7^foy>��}+Җ��v~*�rjվ�F���k�~�8�a�8� ���>�h܁����
��ZBr���%�k�����M{�z�	\tb����&��-b{1��2��]��UE�㳾�'5�=U�q�56ΤT��p:p�9�_ �f�l�4��"S���3�N�*O*����N��)��Du��M���6���1�=��K��8rhXdњ��
s��#-��=(�ϗ~�E�=|:^���ȼ����2�����,��ȣ*_) �q �  �����D�x�2�xA�� ��g���)����Z&�L#���Z�c��ҳF4�L�O�(��L(���w�F@	�UU �a�ͽ��3Q�p���07�����+��1@�);� 0
�������`*�u�XPًm;q_���|��f)%�*��
�p�fFy���X���fiu0N��[^� ���a"�(;aBrcd5�߉�~˔b.��ʂ[ x�`��"fX��b�/�~�)-�H6�C�_O�v�G�y�x�k�P�3;>�3���L�D6�����Zbo_T`����E
B�w��#�
����Y.^�j�(w:�^��_��>���ꆆ"{�*�¼ОZŠ#�9�n�-�$�MO�>HH�P8������+|�\�6�C���G����"�ry��ٿ�&�G|Z����x8�'��o�tvf�!�.�wZ>̺�k�:��c�@�
c�qv�B�/7�,jQpi�g�)���]���x���H
�'�#Ϭ�ڥ+y�_�2��`��W��X.h&g�`=�h��rWNB4�ڴ5��M�K��&9{����9����&����.Ɨ��`�.� �Ћ�G�_$��G�V����l�Ϗ~*��u��%�t�Q)���V�b�JV٠�1̈x�<g��q;��&A�$-���0���l��iD�o�S�ב�0��n��LnF���4͡{�@Ѐ5gٹ�tX�J��������<�V�2t!7���0��l�^����Z�e���o��u�T8H6���g!Y}��ז���٢?h���&%��\���-g��+ѷ"g߳ �DG�ky@aA�jj@����l��ѡ� ��rF��Ai@����BW��P�|Y�d�AB"b�)�bƗ4?�Фr�V���:��"�Q�G��e:�.���F�޾w��I��*z[lB�k�0��g`���t�����*-S*%�R�.b�D�����&O������E-7�klw���rw>���r�\=��91�Oį4�� �����B���l��İ�� }�E�1�X9(��w(����P�D��{��b=�J$R�#��Z�D���.]���i5�(��A��8S&`�K��J��4~�o"[
���e�^q�'�W|�/{��lSֺ..�gQ�T��G�GԌ�R��.k=�C��LX�v�B�M8y��	�	�7�H�J�ؗ�?�QN��\�Z?��Փrӵx�|"����TW����x�&�}0���	{]�v7���1@�
�zf�vR��}�4b��n���D����D���쿿�� �ݫ	�e�"Yo�0�ۨ�?(�v��qM�l���w���)�����cu9�9;�g����
J��6;����r;�a�_���Uaߠl��6Z�/5��5��ӪR+��>lן�.k����:N��m�Ov�+<X��L���-�Z� p����� �����&���Bm>��s�D�<�'�ɪZn�yi48�Yӛ�6���)6��0p�x+��1[�ǒ ��E|�H��)�\���G��i��Q�2U�|L��WZ�R�i�^)f�>򘝓���pމg�Exg��!A9��"cAV�?�rrK�܎��OW�0b�H4� �T��rH^�7@�8��Z���y�շ��uP_>�*2xfs�o���3y�-�H��h����8���H�� �{��1�����6���6��/]Q��]="�F�R�h|��K��(R!�����v�^;ݍ�V2zؖ��@�01� m�ѬD�rjQ� �'��قOb�l�Ek6��l�cZ���VB�6"�lc��f����2��`�kW�����)G�4J^���#F���qX!�!�	\LxB~^	�G
�dZW����{��^R�5����uY��$%[�z�eCP`D`,���!d�&����=Ɵ��"`� �7�o��2��^N�atp���ĵK�l?fq6��RQ���`H��2ÏA��h��F=?����{n�	��Y�w�z*d�tm���q􌏄8�;�E��������{b���tX]͚�\"-/�d|p����G7�H1�m]�-^��bIM�!�Ό!EܻI{I,��Ɨ�J��R����jQ�Se����CnHf��/r� S��_�'z���3Q�ASʠ3�jo���ِ-@' K�YXbo��fῘ,{n�:>�>/�VkYt��R�>K���È����$ڤ�Aw�um��!d3�WS��Kay���Q��Į�h�Y��а!�_��1p/*� ��Y����+I��߉kǖ���ٷ"��(�@P��^T�D9�!�,3�fRK��]���(�8�M�ʍ%��Adetv��E:�4��^��J=��M�BO��t�,"fPg�P<,���a��Ty��U��{���TDB	|v^��7�J,��E���Ng$�)���7�����h?���Vw�g �] &>����1�	ͩ��
�A	Q�a��]	�$�]��.�0��@�J�`���Z�R/����|���E��+�XX_|����0
�["!�#�q\�[��"x�f1�oሰ�d�b2����^��h[&�D��kW��Y4�Gt;�LWYM-{C�N���hE>�Z��3��I:p�!�l���/�Ԏ�x��Xa�����^�ϩN�x���h�O��&�ٗ��o�{�_��x�=��a�J� ���MT`�Xڐ����wa �i"/���E��c�L��=�g	)_i
5�s��j9�j쫑��f�~q�����.΀kɍ2�-p��х[ſ)�޶l"dc��gk~ �J~�9��;�b� �V���
�X#�S4���#�]�J0cB��_L!��U�H��H�����4k��d$�t�&;��NLZm����'��t�ݚWr׮d�:چ�U��*�h���.��f%�9uǅ~-5�/O��i����s�L�l%?[�F�E�O�γ��'��z2J�F����?���8���V�my&���N�X���sf�m�u��`��v�#@��4蕅E�m���� xD�y�̓3dh�D�8�E.���B��r` �X*����V=7���#X���(s�*9�N��0�x������G+���顽/����񣱙��E �ϵk&�/�[�B����"�6����PP��<.��̧�/�*�RAoD\�۲�~1{X`��&����x.���*�;�*�v����-u|�2�]���I����B�Dl��l>C���5�d�;������Fn|4��ƣ�����M�W��0����,p��8@�~1D�=o;���k��˪����Kj��嵺�ų242[|��*޺�Sf��hw�8�@b�Ǖ	�/���_��e�v=�'��k�],���9��/�ў�e6-��9)���X��.�70L���i+����\�xg���6���kK���
GT��^�A�fG�_d֝  U��.R�z�VK�]�%��T�]��jn���"�ٙG���Q�X'�Й㦔^�{t��g��:��F���L ��Z��xy����8t���N�����?�:x��J���ȨicP�%~�J��m��\d��?�|gW���`�c��u|��S�H�>���"qI���H�L}Q�Xиϵ����H |}{-�H�� �`r��#��H� ����8S��w3������4jxD"������>�<z���o��|��3�k�E����Y;�sЈ��I���f篍a��M���F&���IQ�%��(S�eZ��:Wjw/���a�|�����Dvn��\�f���=��B����P����������      �   %   x�34�441�4�24�445 1,8��-9�b���� O)�      �   �  x�MU��0;{��g0���V��ױ&�MJ�b@Cܨ�����FcG҆#m�h6u��t��rt��ގ#j�^�PY.H2.�LPE/T|��!Qzh3�+�Ǝ^ǉ^�G�B�I8��t,��=]��;����7)�&���7%���ޜe ��BI�5�pwT5H(k�Q�`�����1ګ��h�J���8�����[ݻ�Ž�[�{�����KG;���NO�����wF�;����wn�t�8��\ה�3��J��S����C9�~�����'�W�*���S
\�,M�r�#�F�=�4̚�y�a^i�w擆GOÃ���g��a����j���H
����# ��1k����Y2H��Ȼy�#�z�]����w=������̶H���Ķ��i��F�jd�~<��@��@��@��@��@��@��@v�U�yHn��c�6]!X�0��,~X`��
�����U~M�ek䔟V{Y��(�e7t��R)+�ZvPg]���nڪ�(�s�}A,�[��kl��xY4�l
l�����/��(�2=����1$��!}�f�>BcH C	D}H`Ӈ=����d����� ���ft�w��;Z��Y��U��]�����ޟ�������qC��;,�Z�}	@��X`,0��Ä% � c	����F����~�����      �      x���Yr+K�%�}k���.�zN���uAb ��H��")����@J�u��"z-���=T��$1:�{/*�ƻ/`����T��ɰ`?"��� 4��O�R�Q"	V�K�"S��D�*=F��G����+��ɗ��\�/'����E��eV���hvm�9��6���H?4/��l�����Z��R�d�?|�X���l�¿:#�z�d��ǿ��+�G��h�.�m�}Y\��h{�����:�
ґUw-�]g��x�j�Ǐ�V��X������,`�&�>�"b�H),��̭�l�ە����5�>���������o���嗈�I��0���G����"��(�I��0'���|���{��{0���ǃ���q�n�TÚT�{�h�+���paM,��~I�}�^v�u�R�x�7���lE
����ca.���׷��??�w8،��	��Q�FIb4c3�FL�ϯ�	�����?Ae�(WZ�[K�B={�nd���v���Ѥk@QRN_&��K"-ɏ�d:0s;0D�#-�V�B��}����HZ&|�C�#J��[�>'���䑤���wF���'�_[y�1�.��OL<�'�:pe�Ё�*��T{�1��r�&�Z0�.�5G�n��ￔ`3l�}x�������S��\�?V�̣���Mk^oP���V��0_��m|�,�������_~���s����������������Њ(��k��� 'ki���D��R��|j1c<�6a��ju��Ƈ����ԙ!-9V��ҥZ����y*cG���N�[D��u�Rրe!Z I#c���LxB�C�3+����#�諒Qc��͐R`-��
�m)'I�D��޼��@��7L�h�?�Á	�\q�,O�n��e��G���L�=�]jrO^uNߘ]�ґD�v΢'R�mT�P���+0G$��¿�� �Bp~�O$�	N�AZ:��O�~r�a�х>�B΄��r�z�T�e�U�䪿���F���Yol��b"�Œ,�C�N����R��
ӻ�}m"���EΧ~b�����dF�n�)�!	��|�HX͵�	b"H�
;_��*.��|I8�G��#W���"ez�޸�z�G�\S�d�x����;�S��j|Ii�Fy��n�~�ng�ݺ$�j���w���է��bw�<�fa�4z��6�>�&j��-!Q������>P��O
���
�b�HRm;7�^�H}J����v~ӁO?�d/� ��$i��r>ݓ�t�7_��V�^v�%OZ�W4(fZB��f����FB=���)cnJ�*��"�� 
0��iq���0�i��Q)��%�\�ݴ}N�̉�$E8

z�(�"�[���:Y��'��b:�/w�sE�p?R�q�`���;��_N��o���3���Kѷ��^ =J�}铧=Q�G3��Á����7z�F�]Љ~M�5��9l�zf:�^x��� Ç	�H^r/�k"�]�@L<$��n� M~DTipڀ��8�#� �@�=�H�`Y�*AF���δ�/����,Ft�ā@Pp����������ȌS�=�;��#2	���Y��J`i�Kj"�����E�j�=�/���@��ɐ3�bz�DW��|��I듅M�{á=����j�?���F���5���@||� c�>0�/����!�|p�H�҄����@B�xѯ���q��8B���K�'Þ�3�ɹh��PyMv�� �Tm���O�c�K�x�Âa����P�x���b_�ؠ(əbE��;�� �]px*zk)�OԳ�T#�N5j�z��zȺ�ɨl�3c�G�{����ښqh�|u�\=Nwa����v��.=��*��ٖޱ�{i��Q顒�:4�p�#`B�\���Q%�U��6P��py�0�ZjI�?�� �U����d@E�j�=��
�dL~"�7f�v�**Ҁ_��m��s���c�1��W�ۮ�o㰅�W�1�,>敠���ܛ�5{�Oc/+���W����=�{����Y)w�^m)?� 4'��q@�+?�c,)C'QnJ�	&f�`��&��ʥ	�O:N��t1���[Y���C�sϗ����/�њ��v���v��T�`1��N��)x6&n-]>Wf26�N�yo���S�"�z9�v�ӿcuO�0a(Y���E�D!8�3�VWq���0��	)�����ea�d2����<<,u~��H8ࡏ\Օ�K9<M��TɌ� ��)�p�l�_� )D��5�J�#+���)V�����8�@��E�-a�����M���boi�y����Y4��/�&鬨}L2��}�7÷Rw�Q��>��z���^���&WZ���w�{�R~4��M� �"�� ��h���$b��	G��JA�����Z�|�e�!�Tz�[��m6��X)����i�#�Hs� P��� R@a�R� �0˴����rJ�;|�o��ܮ��?�3�Q!��\l��St2���#���s0��M�̼�8�bџ���H�-kpb������ak?�F��@#�@[� ���Oe$}ͥ�KG��ҥR邑D)�x��.u$�����4����߰�E+*4@��b�}������Tx��9 O/�r��0eqU�~څ���m���"֙�n��_�x��x���z�>�ϫBɎ�&5��_y��[�9�?5�ͻn���zk��7=x�n��k_:��@H��R��DU�N��VR���qR�r�5�,�&2��p���vxJF�4RK�h�O[�����S����?W{`�RLcN����ď"�CI8sP{D��q��y���s>��wO  8�q��@"�{;�|���c9�v46�`��-~u'��q�7Q�=>0R��a��\X=�Z���mn�h]~)����{!�Ts�r��&���/�6AA�'P�d���+��I(1Ɯ0)��$����@fK�!
���D�Z�����ǩ�dt����x�ϱ��g1<B�$����g�FER0��v��<��c(�<��E�܏��WR�4>~��;~�cL� ���������M���ε�{6g+���`!���]�����
��>��3c^�3�z5[?��/�,.�]��>���C!�3F�S9 U���k:5C�;�%���g�d�u�'}+����8�#\�Ga�:9&��{���݁\����[�:n�F�C�!(�Sp��-ϕ���_�Ԙ��B�_�,S���#ʁ]�^-|U_W����TyZ�I<�1���]��r��~2��r������,σ����U�A[��ZU�^���y�l�r�|q�m�p}�+�Y=fm-WI�Ӄ������Gf#cC_� �[b�&��[�]8�$����5�L�/aG�B��������������ݧ	��8��0#�ų�����!��%4�!��ON�b���) '[`e�ʧ1��]8V_؃�/��<P��So4��:�ʢ�&`d�Ip����P,�^dg�x�
^�ao��t��ޕ2����+�O�y8p��5�7K��k��Mt�À�+�2g��B]�E��.�������Lwd�}���,'Kc0����:"�SgB�cC�����8?��CCȅ�??b�W�.��b��0U����m�>ç����� �LG�"j
C�`5�6c��H~��Y�L ~k))g�Z,l�4"�¼�~��L�h8����S-H�4/�e�A�� ��;��\� ).���4�'/��r��Q�aF۳�3|쁑�z�]���sH��	\��Xh�)�h�o��ϫa	!{{�!��t����Me����r�F���4�7�Nb"B*�� 8+z �+���� f�f>S*]V*0�&��1F_"���>+n8�4�KN��R L=?�H"�Ϯ'õM9R�ɖ��l������dn���(��Y����ۨ�HoH棍��C��L��k�*w�������}����vͷ��0��	!
Pq� �T��!�*! �jW�8�"~�Ę��lWW]�st^{�a    �@���95�˭��������p��ÎU��Q���Ny��$��>W���A�?�" ��(�#�;zt��.��b�I����!{�c'�	��KO���+���HvSH�V&�p��;�?M'�����_�2v�K;���ĥ7p�ZXQ=�׃+6�����.����|��ݴ�b�)�_���>�^VIH?d�}j�Ծ�t`1��'��V,��\�Vxċ������巂�o��G6��e��&��8�eo�T ���;5�K���\L�[�=ݫ�����˽to1ʾ̗���r��nGe%��B��8��R@;$	�`u��̀X�cİ>*>���SN<��,� ��ju�ݧ�k�׃i�?�s��w�GEZB��FH)�8��3�ы|�a|��e�J��F>�Ed�{��"����={f�q;9_Ү$DIIą:��6h/���Iۘ�9�
�b���+���߫Y�FEH��1Ă���7��:��_��P[��"pH�qk��U���S�{��a��TQxU���2��(
ek#E�q���?���^>�S����*)�r��^�-'�_�g��puYݛC��s��艙�� ޿gO�6�j�,.�����sY��^}�b~���KO5���d���]�6=；:n�� �v֡�8K,�<K���!��I&ϗ�WA1�QsV�3��������1��ח|��\��嵐���q��_E�����Ԡja:(�a��ms�z�(��� C�Ŷv���7u-�E� �A�8��$�C&{_Wց gO�7oqM�'Ǯ�4�ˠ���/4+g�f�RˮM��8�1�}^*<67	ID?�w]
���8]�4�6,��{�L�6˶��k�3O�"ۣZ��jp�R��I>;�d�?�Jk�
X�4V	���sg�:Ê�G�R����KI�X�Y�t�� ���@�?��.�c�~��!'�����0�;��t_��I�\�'�;vq14��'/��8��Eصqh}�m�����[�U��mp��8Z����	���NV
Y{*��c���j�����.��)�ߢ�@Wf�j1��m�w���j��#C?�3d�I�+{�!����|��.�ɉ�a�J�����=���_�uP�FWڽv�ݪ�yG�ٟ�x�.����.7������硇x������)ܮ%瘅�
+8h�Oi�X��G�$'ϴ��vE�߽+{Mb.��h��?�����$B=J.
�V�'��(�%'�:0�Ѵ7/:�k���}�?��w�Ҫ�~�o�tV��Ixm��XE�r�:Mw��m�����aՀ�Ɖ��(��&cNE<��4�Ĳt�Q r`A�+��dυB�!PƮMLV��i��-z�i�k�Z��9��G�q�0W4*PLQ_�g��T~�a<��� g<A8��U��Q�}��uU8�~�f�(��\KW��0�q�#�;��\C;S�B��ʷˉ��iol��Ya��ܽn��Ql�����-���̪_=��`�ó�j���M�z�Vc0�ۻ�n�OSd�����Z� ��b��"��q���ѽ��cN A������J}����Ʃ��fx��OF�.�1�=H�cn�k�hΗ�rov��^��%��^�U�
���ѦJ�UR����Iײ�y�y��X�iP'�����)���������e)p"�Mb:6H.�@��T�j���G���3m���V�]
�6\��;�v �Z�f�T����(�/֯��S�߱@��3�r��p�)�7'쾯��F�o*#�������N��TN�J��eq�W�zVSg�\�#�����:��=�gee:6U2�3�����m|6�n	��pӟG�I����U��~��*9/���4d���E�b�ac���9��ո���H�q>��t��C��l�A��[10���F@�r��g��ۚ��c�5�CR�J�&N��Lwp
gk⟨F{�_������,{�֮R�հ۞��U[*FO⡸���t��坨���j����z{,5�"_&�u���H�]��H.5��t	�z�px~���7���G�O�!��+��J��ppJ�
���N��q.��1�0�>Pj�	8ÈSa���wS�>�dW+��`��O��t��GJ����j�M0Z�R���|�p��XY��H	�K ���%�5xg#~_��5���`L� ��w�<*	�g ��"LqDO q��"x	fW�.�*.AgZ�Y�Gkb7Ԝ���k�L<6��Υ۸�Ů�)��f�4����r��m�C�_�[�e���[>�CpĶ����E���Q
��Zy�u��''ւ�� Ӝ���|�8�H��˾��-G��7gXRi�,&�����-ਹ���3\��6�K�s�������GT�~U�.��u�ģ���l����{�������.�������W@���!���Ŏ���SU����a�H��`�9�KqNh4��R�"w���J��F���qe���莰�r'#��xȵe��`vŮ���Ξ���p'C2�ϭ���dj�n<���P�@�8�`*(Z��5�a��� ^�9�;��N8P\��T��[K�|������t�|\t�Kf�����+����&Z/o�n�Q>�glR�n7x1��
��Z#2��ﴻGJTRw����"��o���Ð��&�r-��l�o� �Q 4/��Q�f���Bl���B�$JP3�J0'���-S�q51��#ܚ�~e$�lTz�M��-������T�ف=�{>�/�n�Z��;5(���EL�PRU���|�;��$7��t�եk��a1'<3C񊷟�¸�;-��E�b#>Kk��ӗ�p��R����w��"'$"큓V��RRX2퇓S�1�����?�G4:� E�3�RыrxF�!3�[T2� �F`��(��T���g�$f�a��S�&��ҟ�d��ڑ�\�����`)l�C�Р�e��T{a@��} ��f�k'�6`  ��xqoʗ���Gn�O�<0���%���@�/H��!��EfS��x��e7���9 ��?]���HFD����W��N�]�U�S%H$U�+ ��]�TH k��o�-���P�I�	�gf��-.�B�5=�T<��|^r�O67���dL��I�-oi�����̊unR���Vo3�K&Fۻ�����)iy/��b���8��p!>�@�D��� ��K7f�A������O�]4�o�	�G7���`��ߔ���b��H6��,a08˔a�9T=��_�}q(����] .a�HJΗ\�:�"}P;M�u�+Q�0qK��4�<#W�Ś��mŔ3�|c;����^��k7��&�	�ճa�%?P�۶w��:1A�&&
W�O��r����Uf�?���!����q�J�N��j���x�8mx<r���`�eo�� Z������x��6\���^b4S0�R�?��[�߲>��3y)�+�Q��fV�����b���K���#""� Q|���w.��~��7V�y��*�L�����.7f8����]M}�X|0(�G��5P��~qW|9�I��6����F3|29ਰ�i�?�	��' ��(O��T�Vj�\��uxQ8����ҕW5�_i�0�y�c����ς��� �M#��~�R��m���*� �G�, �|I���k��F��"Ț��4IZ��ڿ�D{���F�_ �Y׮ʕ
H��ѣ��6�1+�89
�rg�]�C��q�bWl�ɞC
�3�0�������F.��ULw� f�ҝ��~w�f��b��C�$��}�Ӭ��x+�e��Z��z>]�>�-W�uT�]�S!z~|B�E�ǉ!�TJ�kP�3z��<�
=�g�'����r��U����$���Ih��7^�f��^�ܤA��HC��+M嵖4��w�;c��a�C���m����6F�{��}���K(�L���i0�I����X��Ԙ�$����X�Qw����֎    �0���>sa�I�h�f�����u],犐j/���Q��Q���8��W�����X���(�v~ ǻ�ʲ�B]����,��a�(j�o��D��u�L��b甞�F�!��#t-M�N��������'�М�I>k��q�1��_[ӝLN��P��F��	���?�o�U.������Twv�z�T_/6�|~�
�wy�q[\(���0�E�����"'ϫ�Yp�
��y�aOj��0
�J��N�Q)�MI�z��};奲�T�1��n$
���n��k6fqE�#��[蹳�sU�y��>�w��ٳ6�h�6�wp��L���5�z?鬑J28|@FI@8��c�>6�n*�p~Jk`t'*�*��K!�8��:�> ��L����7f��[o�ˋˌ�H�2�>&\�v4��p�3�]��iv�I��	r�WT�u~[&�n�r�HP�h��&���Z&�-W܎�\� �}].]���?�����R�������?��S�2�z��w0!c����4��/��PJ�ɱ�ќOQA5;;6�h;:�Yr:��,����?��Mƽ9�)��󂈇��h�+(h�Z8��;vQ�՟��p��j}�V���.��4{���H�a��B�%I|�D�H;CB���΄����g\��l�X�|���C�ڦ{�Cɖk�j;�u<t�6�&]��щO9m��L2����>�Ls���jz�v�R�����V������]O�s�c��,��bz}�D��+}�$!X��7\�Opp�yLu���J<TLƃ_o-%��3_���Tn�2gAa3���0@��맊(f�RV2� �K�C}N0���R#zH��#C���Tm�,n��>��.У\y�)���ÞK�t?\ٸOg�H5�I>�>l\�����z#���\�콟�Ay�+!���7{�x�4ki�аħo�By7���=O7w��;����B
q��f'q�O��>F(\�<���ҥ~'�I*}6d z`h��;�A��ܗ$��\��B���q8Z�9��z�^�yM�y�c�ݧ=�bѳ�k���~)�>3���% �[�k�x�P�F�Ү)M��I���"��Ȝ��$�W%B��O8�z���ɸ]�;��@aݒ]���u�x��B/f�����A	��Np�W9�z���ֲ�+՟�y�B�U�<�r�ח���BܐR�M���H��I�U��9� ���'W�8�J�!��x�|��l7,��ɭy�����0��S)=��M�^�2��Q�MK^��X�=�k�_|�ӝQ ���D�uW�Z�����V\�;Kr+�k�N"��V@���+(�M��9E7<PJ,$c.H\C�+��ҥ���� r��%�( yN���\Ć��y�����}���|�	�]����o�kW� �k�oˣ�*�H*�Ux_	���lJf��X������w`�r��@G�C�~����uGMԕ��$]I�~@9(��(yr+V���z�����MO�v�RZ�̗�I��ߵ� �h`,	|��m"�H�ʕK)��B�+K@��k6�1��I��W�!�����!�+B`^�3�	B���J3屹U�c�|�t-H<��y*g��홷q;�4#�.�����6`���8Rw��8�����˥kS�5R�bot��~	���a^�FD� B<�H`.�Mz���A��'�'�//�RG�_W���_;��������wZk��wb��Dҥ�9��I�k?��>�0�~{_{�B����c�gST��,;A@i8BJ¹����Wt���2�Q	�X 1����~=���q�ucF<�R�'F��y	���G�gd���>�[��I��[M�|t�󍨾�F��Fc�l��5��Z���;��*�����;���f6U�6�����X�!gad����Q��I��V�x�й�p�>�I]�^&)e�F����!1�����Q4�&�f�`�՜릛ͨ;���ORy٥�w�'_/�����Ӈ��B�B���l��A�ػ-67�.�;N�0��D���1P�u�4��s$.l�`��;SpI��[��ƭb=ݬ&�0��%`љOV��Z�f�<��f�0l?�"��w�=F?�Y:=��r�V�w�Ň��!�m�!w[�4C�1�:��ppAR��qrr|\����ǉ�˥+VthL*�=R��?=�S3�B��@B7��Z#�޸~�$�y��#U�f������"�g%<��\�e�ù��Wz�gF*�T��M�]-�rnf6�JfMV�-!���4-���=<��R}�6+k��&�Nw��U���c�l��7(��XVu⬾ϗ�������=@�I/�����R����9�m �Z"�b'SF�	��R5'�T���:��|�r2��[�~����Q��nni%_mt�mUI��n���2}-<�ʅ����E�q��Y�F�r��3,��l�u��n���+�;W��̕~q_3��{��A�xƝ�v�N�u��ѓ����I|-��Ԟ��[㮚��ձ�?}'c�?vR��G��F�~�Q솳�U��2X=���W�{���v1]��b�4�]��c�OK�d�#/9\*p:��m <�6\	5��w���a�H��s���Ubq��x|�.��]���[RI��R����^ �ы��F�^(fo�lt1 ���5쭭�C����xl6�P���͌X�m񑴶������4�_���ڬ
��|}x�o��� œ��Ud�Q*J��u��wqw���9_~C|���c	a��Be�����}�va|㮅y/���I��v����l����r�+UZ��i�f��F�:�����U��6Y{A�Wݽ���,}[N(�2`]Fa!AN���L���Zjh��ۿ�ľ5�����j�]�9����V>p��u�_Ƒ���ʘ��{gŻV�Wyi�}Q��j����V�%S/�b}�}��X����� u�<c<�D_�2�G:�.F~���b�"�CRj��"K�s
��q�T�ќ��"��G&�M�x<�1���}���.J��*E:����Z9ߞ���˞�����ʳ�Y��6���t-��(���@2v޷�-B���sA&�r��+9�xp�V��Nu=��F��G�1��d��E�P*�o��։��+Ŝ쟳��kM>d���'�|�|��ry������ѴՍڽa?���zT*&��o��=,�c��Q��\&�Wx��$�@.l�^��a��yS�{NKǷ��ܞ%آ�_�#���� l@-E!�nhu�z.�e ?�# ݀d���)���c"��_|C}w���Dz4|W��UO�Ӕ*v���,�k$��Be��bH�nS��S��i�C�NKu_6K�v��k����n�����YU����-�$Z�D_��Q;�]���.#�u~��?� >J�C��
�r!�x�V.Ҹ�tI�&�L��4�\op���-�&��r ũi�8
�,� /���&�DSׯͅ�dz�E�of�O�x�.���`^�;�o
�=.�5�'z`��&��YI��z�e�����t�~�W"}:��	5���胘�]��L��u��e}Y�{Lg���p;K�������=E~�	7 R J�3�dg�C@���'(H��Qa��R|>�+2���>���nY~	�#×v<�-R��4� �Ϣ������P����[�U�G���FrOwύ\f6ox�m����ͮ��ػ�+��/������R�t7ą�|�"b�S<���F�<�����o��.���n�&���S_����M<��ˉB{p�h���a�,������d�vm�����g�n{�ί��A���o����C�>OU�]��Ri����E>t :��C�N���ˣ�$��C1�H���-W��C�=.00�K9�&ڄ��
�^<J���	�����:iV��_s���,_t����&�H��U�=�ףf��#�L��I��w��7Dq'S F�
P"��̌}v>Q���Ny*�=�����$�о��sf�W�{{C���nq���Nd�2��j�,u��L������R    �Yg�x^��!||��a���"��(�6�* ivr ݝ��!!��@��$"7�Vx
�6򤚴�z��j��@+nD��#�5��M6��!^���Ӡ_.VV5i+K�
�*ld�ǻ�����[~�~�:�hr��N/R�5U8�ݵbX$��;e1�+U�+t�Ge��K���X]�N�Iq��@�>�,N�SY���?{�.M�ŉ���N�gT���Y�F���|�<�aϮ�}��h?������۩�����6���$�����Ja@Fk�����q�(���1W%�҄Cm�~�2�q�!�v�K����ӫT��C�ԺO�x2{�5t������}�-Wt�x)�G�_�WQA���-w7�R�����uW�W
}E��oʮ�Bq18t�F���m!ĉ��Q4��:���D�V��O��=�qP|'�K:�K�� ĝJ��O�92\9�L!!ھ�X9���xrq�g�1֧8r%{:b�N�y:O)�N�'i&� #7]�=��2�r�G^N{�~��:�v�+���(�ź��u�g�:&}_��>�#�J���Y�x/Q�T�X�5�lq�7f~�4��ŵ1��Yѧ�OǑ��@
F�tW��b�:,��&g���	���%7���鰉l��qS�c�R��H��.�?�Dv=��_ �GעD����z�=���I����j7�����vʫ�*�o�{F��ܺ�3������'������C��ː��B��9G>�3"~i-��3'E<B*~.��pӛ����+�?���ّ�Am�j�횛�g�뒤��MvL����0��W�5*]th��AD �P(�G�5I�DЈ��k<X��Χ�e�F��]x.�M���\z�����Tcߵ��ߚ]���C��Ǖ�ߒY|�g���uCݤ�n��>H�y��?p�%�m[=�y�Rͷ���[M2w"/��6�f܄~Hw! �Z�AK$u���"1#A4��ֵ����\�%�T"�xSS|�6.�O6�/�6��.����Pg�2��L4dX�Q��6�ŶʾL
��>�f��� �2*}Ԟn�"��,��"����8X��	���;�!V@�8;Yrj߮��i.����2�Z��f�vl<�?!��db��p�ڠ<lN~N����꼺�����w��B4S��]�ZN��u���i�nà �
E� �:9C�MbM�@�
]�>��]'�5#�����yp%JlD,�"��Xuv���x��ÁY J�6�f����u�v��ȑI���tY�ܵ�\��'��?Ϙ��e0}�N���gA��0�GȂ?�6�,1ǁ7иG�.��	���,}-9ʦ�UY�
��^�O�:���A��?s��g@�#��tD&��_\'��o{#�����k��{�����D����m����/WP�?gE� �[�#�� *6�ZI��ԣl���V�Q�)�g�f;�ͦf L�I�ͼՀ}x�B���m��l�3��L���S�u�m�EthB�9y�!�� Ѫ]��niV_�Q��P�P��`	�钮_��?�~w��8AÎ��x{����՜iMԴ�U�lo=*������Qg�\<�=g�*���-�g�j�3����Ԅ��r�_������"1c��I�L�wwYx����񴻚�G�|^cJ��u3����keB��M&q��oy���K��_\�������ַ֜��fy���ާ���nU�W���> am����=+��$6��1��`��:V�Ǧŕ��c��r�.�c�%=L�\�s��j ($��;L`�#Uc�j7mGi��� s�ŷ^C�>"���>��Ϭ='�z���ܞ~� ��F��@D�.��c��i�}�����?�[�4��p F���d�8/�*��Kώ��j��}�5(4������M�8��Znv�dQ�p�5���]�r��Z��*,�5ߴ���F�(��`�-��k�L�?����7E����]�'�R�{a2��=�h,� ��22�*p�-_U�Ws+(������,��A�)���氷�&9���l>���2
��ݠ�^���ҙ���s�/����毡���ih�O���Iv4�k�m<؂�9ԁe<��yx#|Y�t�ܥ��ag���c��j��_�|*Sx��~s��܆t'�9�X=�Z� �>	�22�
���κ���]V�k���r��y������=��H
�8'k��8�V[Ę�9$��>*�ݳ0�xQ$�:j����WR}�f��8���5+׳��iM1`�ܖk�F�iVJ����ݲ�*��V�jK)^��h/`�\y1��jWyx�=ۑon_!`���Th��캯M������-���<����h�~��ssK/������O�y������j�I�~k��x��ת��M%Wn޿?6����N(Vc�y���A�h����z(f�棾s;�o���"_+�� �>
��>�C�?'���F l�D�_"�V�t�$�p麍�1�8��u��s7p�f���i��>#L�H�HR�GT!��!g	ƣ>#O4rQ�<��ӻ]D<ޜ{�`�/N���iA�����d��@���ߧ����zߟ�s�3�an�m��Nѿˠ�k���1���0ӌҭ��[c��QXP��c<�µ�'�qh<C�Ei�X����^�.���u��rp���Ѱ?�V �K�Ӧ�>|8�tA	-1� �����n�����:v�3W ������*d�!	!Iw�r}D�-�LxR���2����ut�L�+)��-�Χ6���dNѰ�����$"�2
uK���(�g+�<yAb��U�&������A�>y[��4��[]F�sB���v��'ĵ�$qf,;��1�2⮋�.���>_Ο0I����3#�r���tp�ҭ�rë}w����p�3׿m��|�B7L�!c�"�X�9��v�YH}^B��zH��~z]��֞RX�kI��=�x]�b?+�cY��J±�b$��z�䳛ʼ3�V_��_xŗ��B�q�ڥ��&����ԭ�^�:_��.tA3�Ua�0H�����]�8n��]�v��.�w�2�nɋ���=��Jn?3�����x�3���	�=���n}�0i�ע���lTѢ��O�\�ٮ��Ie:��R��p���õ��r�">I�92%�`*���m��0�C��X\9�n�b��H	1�b����)g�B��\P���7���<9�����&��G��n;|\W���]Z�2��$�^���_��mY�yx+=OoW+���(D����(�!O�C������3B�J|�qq6�@z����N��;��Α���O����+>k����IMC��ƕ���W}i>:+�Q}��K�r�};Zo=�Ń�fj���3�g���2X� �`�%�d�Dª��uE���qTG���r� �Q��1I�J�>�%��j>���׆�F���i��Q�^%���/Q�Z����voS�,�/�]��)�����*N+�q����Y�WZ$�rTf���9�`A�����ҙ�C�	7���<�s�΃�'��Q��2n�������l�7�ߏ����[?l{�U��0�޼�d����`9�O3�����K���>H�������6 ���4����ORQ.ገG��@q�#-%�>owCV���Tv8���>m���P	x�[5
�{nЇO�D"�eH�j��):����)��F�ǭm���{�C"cϔ��Z��"�k��h�eLz4���pxc�񮓒��׬@_�e����ާG��󲼺Y�A�NZb��b~7|7Ӡ�1x�����D��0� ?P~�T���Ϟ���}~��8���Qq���.�9���f�5#�=ֈqg�[t���u��,S~m���6�϶�gg��h��>ܥwU^l2�>�;w(�>���J¡>yq��k.#��AL
x*�:������'�@6��9b���}h~Dʕs*qnX p E����#v���q!$.:MNo��q���4cXܨ���<՞���G���0���~^�ǵ�p_/4�7��=w�/�����+/�u����gˇM�~�0E��<��?�'�>�J�P ���蓗 ���Lx{
�/�*�!3�@�W�D���a$d��8    ұ)L�8�N,^|�'r�p����t,��.�aw��~���ӌf���ßp����<��e9���3�e����)ݭF��{�vþy�H���Q�Uh4Z��~��8� p�GzN�ssE�9�p4�$΄�L�H�8@�a��2�=�R+�.
"�?n�i�����~"�)���kU�>�Q�8��[��o�.j�����y���ßF6����6ص�}�]��nϞ���a+��D��42w�iX��΅4x���Mo[D���qM�13Z$v����gQ�EB�+l�(�p%n$x�K�3(�>u�@��|��g��9q�QM$=_�����ym�I14�ԫ9+Qt�"�|zR�z�_V�����)���)�/4��!�z�e��G��{�k����23��fԨ	gb��p�@7�,�v��$}�@F��T'�;lpw�Ru����"���V��&�)&:�/��
$/n������w
��yϞ�q��%M63���'������S�O�/�Z�W߉B��P��E8.�q�)|*������t�`عP\&;W���L��`E"Q�ĵ�u9FB�0�4�&����.�c{�O� 3�|�#B+9��)*���{���Tmhv��ݩ1˜�}�����N���z,L�j)^�
`�����p۪��ڏ�{^,e�o�/w���b'7̲o�*��l.�0r��q��:��ϖb��~;z#�p4}�kN�G9���s+�����̀O����_�K�}
 7��gK��!N�g�v��(z�[�W�SW���.r�v�s��gN��1w����#�\�̩��z}��i}�+w����U�\���Uݚ������n���,�îզ��.�����Չ6i�<[��@��K8��o��~1�aTa+���]/��~#>�D��<L�Q��������g�J�sO\���[z�Ԓ[�\+�?2�p{:���-���Kv�5޺w�#���pÖ�۶V����~����K�y?�+�Y���k>r���I�8$�¾&��Ƞ �
��x�+	~�߬����},����(nR�{�$y|�������7�W��p�4���t�ݼ�a��_�UǄ���sm�[����O��o|l[++�%-�[�	�����.�|�?�sQ�L��C��N4����\�+�9&Ƭ㫶%������0�Ƹfz� t&|�.=L=��v����0��3���S`3�����u�@����,̆酩��,f7�9���������.υ�4�E�["��3�[��'SU�ڵ���ӽ�}���5�7�\CݗB>G�`II��۫5Y�SOF|�s�o�����U�9Ax��䭥�릙���T]e0���3�ƍ;��V	au� *a�߈�ͮ �� ����R�U�3:=7����aoܛ�l�rU���<]�Q#���G�0r�M�u7S�1��'�G��zn�gW��~�qS^�e�N��~^�����;��ȍʼUU��NnL8�պ�(�gBC��/�k��Lz��	a�UȕmQ�(��K�.pW�r�����7NE�~�s��?���� (�[E0�����rxZ�Zḧ�H2A}�n4v�W���f*ӧ���'���'zkධw��`�;��M&�d��<�����c���d�fkpw_]W��E���R���ܢ���Z�[T�՗�6�H-�Nn�(9�&(�p	--�Zcm�ц�B�L\��wN:�)��0�K�0�� gK������e��l�'�" Z����0i�;�j��!Jo58ϵ.g���{�����
󶔷vT�n��
+˻�Uw��U����mWs���J�H���&K*I��x}��O�Z�QGajwHݍ��`��\��$ &u%{�<N�ro��a?M_|.b��f��O-Ɗ ?P�M]0�>�F3dCA�ˤV8 �g��]\$��h���x�!E��_ݲRn�My�������,a���#����7�80�*�0$��@��	��U)�n�q��
=.ve�
X�����b	sʵ�<�i�[/��p���:j�K�%	�� �lT�h������0�C�y|��/2��x՗4�~R���'U�v�v��t=�.�����n�wT�|�
+<~�t�O���"��>�c��_O������]��?۾��e�h��tW�9���g�]���D�3J��-���y����.-
$�gR��+g������a��r��40]���=�yr���D��=^Y�!��\��ߧ5c�`��TQnY�#i��ة$��6�G�������z��	~�ڢ���]�3��b�K�x���_mli�1�����W��brR�*�Ok���+�5�F;��f�0�
h�>+�˝n-�ü�^���~Q�����n�ʶ%����@�档o޶�ʭl�=8�AI�:��,'�1����LP��9�ojΠ$K�H�{�޻�>�0��hƜs�1�P�$�L �"�0��(b�7�ia�Al��A���H�f8-��P�e�J�l�#֐Go4(�����5���%�(YW��AF����Y���~@�G�W�G��z>�>Ų=�i\��M�_�慐�ë��w�.���&l(�k��w������w�׷&��<�eF��8d�M��D�
$�N1p�1^�ߵ�{m�F񳪣9o�G��9�P�Ma�����PU��XN%AY1�B�1		T�c�Z�x �����W���$�q�oR���t�%��Fla*������C�����9��8N��7G�����W��|���sS}������d�H�
�K�$�C��*K�����9��e���"��N=쐡L���
�>Mv�ի{��#��w|�W���t��.��___LH�s�:յ�h�뮮�� rt�D�uO/KZl�4~eb#i����8����e��b+i��C{��e���cR	`���<��$���c��feU���Kx`���Fd�DRm��W���
aG�1�����rΌ����%�2�|)uiR�av�	%/��r���#e���6��)���5,���:�����^�&+щE7Nӏ>;I��[�zxm}��xv�4��9K���\��F��8Iz����]Շ���|ɋa�ҷ��(y��l�L
�S��$Ŋ;D�YY�L�M�����S,UC%��07 ���,C�6a��?`w�S�>�H�f�~�Ȳ��Z��Ű��dT��r�#tyVf7V?Pb��,!�c{'n�](%�t�u�]U���q�^�*Q�\d�')O),��:-�Pky|�1�+��u�1:�H��DJZA�����x����{��ogCH�ն<y������Ș#u|��gd*�g��=k��^ �|�`�������9���o~U2AZ���3JQ«�
1���L�fޠ�&��v���T�,����������1�H.ũQ�n��@���Bc���"g�~����bmg����'Mǝ>����0�����a�x�9���������Y7�}v�E6j��|�|��܎�/�����Ū
�Qc]��Ä�Ld�@4Yְ�7��7�9'x� �<�c�z���k1��=�Ɋ����G"T�\��=j���in;�]�Y$U�*�V�\��q8љ�I�bk �(m�2�0*�m�x��@mz��lB��fQ�*S���Y�� cU��'8���UϚCXP��Kc{8�R_�m������,&�C�F����`L��P�D�6�)��k�}���Rq�G:
����8�GW�ߍ����E�ط����U{z�3V���^'�y8�/'��ct��zޖ�ޔ�b�̤�RGQMJ%0sK�tm~RS;c՜ù-���8dq�P�,�X�Y�n
'Z�2g��9�MeU|'�ŋc�Ls��oP�g���r.3�RaOJ��fm��:L|
���-Zj<�)�FW� sZ� �	�r�mr���Vs���Ks;�ۓuv�5���u������,��Y�~�N>������8�zZF8�	b�,�f������̺��4@zo�AMS"a.����23yA�d�%�l�R��Z��j;��LE��{A�|���_O���:��    ����k�6���`k2�i�]�/K�I�fp�k�id�Y47�����I�����O�d:����OU{n���v)h�ɌÃ�e�vw������7v�~l2ۻ>��Ǔ��F�_N�����^�tK$a�&	G�N�IZ�t��h1�-�t�:�|Zc=/��JEdA:+ �&�m8]F	W]o���mZ,XuZE���cl��#�8M��SU?�t��q�B��?�GjsH�������{��7���8�1����������x����'z�E�������f�*B?�a������ڱ����Wk��?�Gۤʂ�yJ�Sp�K�#2.�"D���(���	�?S�Ca��7��$uἹ��V��� ��+��1��;��43�'�{Ia9�$1v7yo'�ZˑR�?9>�Y���������ݼG�r����!㻱KG�acYpN+�� k�N�ŦE�J�Sp ��pX�Wt7�v��XS��UC.^��H��v��v�������4�P�,����ӷ��1}�;����~���n>��W�������]�������'?�eR�*��P��+�bAʙ {-Ey{	�xÎ��m�a�4MS!��W���x��P�BTay�����
��2cW�\��iI�寽��`�4�#a������������;K�N��yS}�Q#�o�?~?����K���C�aiy�H���`��׊.�������5Y�[�,��7R��M!v�4�#ŰR�0��y�3<Y<�&����=N�����Ş�kF8#h��:��bL�ޫB8��@Ǿ��&<����߉G���h�@}9x�+���X;x,"����!�&�m��\4���d�|���v1�i��y��ǝ!�6�.���:�w/ѣ�|�����{[�I�Q1T��4���^ۿP�$4LKl(GۖRR� ڦ u�~ h[��?����E�����ľ|?Pk��Y<��1x�jh��cu�_�Ͽ�׿�׿�_��͛���G��-J�[/x����׭����v��`<'�Mk����E�z9{�Mnꇺs~ݿ��?����_A�����)�ʹ������Py�,%����쨁v��"I�H3���iJ}�M����7�3C���>���4��v��Ӣ|Fw����\�}|�Z��1}5k�����1�vצ�zrdOon�M�)�KtD�i��JkX����A|��,�� ��;���}�j����PΡ|�ݔ�A�s��([�sV8�*exѵw��t��׎ף����!��?��q�B�LQ��&\X�
e�m$� �v*_�z#�`!Ɛ�VL�?�U��L�Gx�7��=[
�(������ �j�ʒI{�y�
x��&ף�A����������Ѩ�d����7��=�n1��Ŧuu�V�7�4I'��$�^�Ԕ��j�
0EHD��w_
U~�|�����v�t}��6�U�*��.�Ɲ^

'� ���0�e�`�n�xf|(�.�����`E���sw{W�: ���Zw��<�97Z�i�z�`�U���c-�7��qi�v�A�]V�2b-(l8� դ-i$\@����i��Ԏ���$�p���8\���p|@�� X��r���OK�qZ�Ud��ӂ��1ʒ�g���).��s2꼻��=�{j�$���g�ĂQ�@�m���&t��)�Z��h�fm��?��C��B�i��1���!
�ya��Z>�e���v�<7·]%��֘��h��������zw�k�oup� �>�eL��,�g�<�ֳۖ���5o�P@� v08Zz"3�3ly��\�AI�q^pBQr-�����-����1HP���ܠ)`��"v�_��'ۡ9*���vU�9Nҏ�����q����>���i�j|}����ݳ����I��.��x����t�wB�6��s0�D��&O���PZ��	7p��l��x�ȤfZA($�殼5���Xڠ�-��1d1e�d!���Ρ}�2:�|���b�v㔪J�3sUUjing��T$pQ�ڄ�R'�f��!p����8pB�	1�FY�@euE�g��ɨ���ޛ�M�]���X�Ri��(N�'֑4������z�;t�#i��Q����}"��@�+Yeݮm�p����M�G	n+ٕ�b�Y�2n���_�j[�� �7�{�Ӱ�V���c�4��gR�Eh!#E����:W�b
&n�a�|R���V���M��&�ݴD��^2�o���Ս^z��bVx��kuh܂e`�0�n��K�!L+lf�	��bwdmTL|�Q+t��(�� ����u����b�����ڏ3�T���o�:��ޠ�n��p����"�dCC������7p;W[��Щ�F�D�Ϛ����2Eee7L���1B����YE�I��YPxX���)\>��c���4A�:�*��M3]�1E-l�K8��xM pÎZ(�x�m�Y'bfS�%�s�jͰ��A��)UUC��W��c�d��1U����TL�e���V��^���x�aG���J����_W�,ryo�<�xH ,0��+�C�⋑�g�P�ݼ��,z��v;�ָ=��%Uـ���g�����ؿ��Y��s�=��6�v�|�ήk�o~rpu�}�ޜ�y������� d��(�'	%:�C�T)ZKZ�d�1%wQ�-����H��_f-�"<d����OŦ�_J�mJ�4����L�ui�qU@�OV�=�8����E��?��{wHS�Y��g�h?O��U�G���~Z �*��s!��%�R!\C�č��h��p§���Hl0!@f}~d�VC�p�`�
�9�q����h�׭U�_���{~�%	����$��e�6�h!x�!�8D.�0� �4���֋��G �K¼����F����@mj#��n<���Jb�8(�&��))sa7b3�c��ҕ5�rǐF�$��o�$�q��
����}Kˏ���wy�>��c��/|6��n�xrM�Y�xr39<ѯ�#����?<�'�e�p��ʲ�X^���k���q&��v�*$De¤�Z⬡ޕg����iC�C����B73X]E��[���c�b�����둋�h0�W�(0�1��;�^nF�� �
��ܕL,m6s���G0���nq��-����n����ދM=�x�PfM_	���L��@�˥F+�LH��86�����f,��y��������"T�d��>݊F>�:�8�9?`Q2B+�Y��%��|<c�N�I�O"3�K�V�%��>w�!����A�'��Q�M���$���u���+��A:�:J��-�J��������C��'��+w�O׏������x6<�p�� %ftu��NW�hV���;�e�:j-��cK����7��cɺ�q'Zx�0�e�+�Ɗ�JE؅YhC�� !���������B�n㥷�@^���?`�����C8g�$�X�R�=��H��f-w��5yk_İ�!���H!�q��#քO���q{��t�$��JF����?�򰉤S�)XUΊTPo��v<�-�b�����z���#&�,5�l���0�*��^P�*�^��˚�p�L���~u��m2@��%8��v�$�D>�n�;�>�o����v������E$#w������a~�j����wլ�QK�n�JEEV���Vy`�"�����pî�Td�Q��K�t�]�ŝK���6X0�A�Ҁ�$5�>�|H`{
;�yW���A{���zp�B]�޻�ϓg�-�����M� �ф$�}�z���Kۭգ���(>��z\~�)��_���2v�f�R8۸��'U?.B�-�)�i]1�c�P�����C�;߻s�v���|xF+�Tc���湺;��ɵ>�ete���g�M�_�Ag.�>������7W��H��I���9�	���v�9�2Qb"E���w�]��r�| �&�`"	���5�Bnh�1h侞}X�xnd�}E�;�$�V̄��J�#l����=�n#����~�o�ϵ������    ���x������v����������kb�{���$SneBU[{8_�(3�Sz�v�K 2�A���!Lw�H��/h�����v�(f����}z��,� <v��`L+�~ӹ��b5,&+$`	�V�S��NLU)��_���Z�C�b���f�܄p�����;~����h<H:�Um<��B9s��}��r|��?O����(f�Sw��>��8��s�q�xU?~3��2�j<a[c)E�� K���V�7���������T�8*���*
�k�"B�	-kʐMz>*���S�� ��a�]�ŷJ�a����3��3�l��= 1QP'�,�^%����EڨB`����T�	QB�׈���o!��ю3n54�|��Νt_Ӧ���Y�����!R�϶���ݨ��׻��<n~����{_�[gq/����m0T�WFiR�7�p o�V��5�EJ�XJ�g�|���^��B�����y若�HK���������ҷ֗�ɟӠ���~-efI�jN�������dEq;"m&��������Iʐ� �J�ʘlrx,��a�A�)
��`W	C�JSA[�Z4�lk�.Ze��(tQ�U��4��*��½Tgx'S�|F5,�҈�C�';J�YQb�C�<�v%��Wx�͂�(
K0�\"a��瀊�XO�U�0�X�zI�X�D%e�;!TQgG�g�Q^�8$�'�-�*������v�o
#�0Pu��L�h�+,f�;�%��Vj��������G�I"8��S6�n.�C�����=�6_u��p]�j�6�<��i��C��T&�A`a�*�k5�ocp@0�l\ˌF?��'���(Hb����#��fY�-�p6����b�j�W��3�9�D��_���@�1�$���nTH��N(����[	������j5FkU5T.���U+��~�W
�	f��&���Vzث���IU��L.��+�d��(���N�F�YItT��Mz��w����պ�Y�Q	^�4=�B��������;æu ����f�/~n
 ���&�חO�-.Yѐ��-���,�e
�LQ^d9�kq:)э�c�q��5��F�>"o�K���w+~>:<��i�~_v�����K���������t|�:�n��oz�nr19�����Z"VJz�$ܰ�64��j�r�u� P�}j��d�9f�0��<�C��`'R�����;b�y�x��^g����3��]��گ����C?�\\=5^�[w.[u���v"���Œ⤐�E�:DĔ�"<XߔQι7l��<� 1����A�CTEϓ�d��� �-�+�׍,q�Ձ�v�@�m���
���`<:��h�þ��Bh��D�,����V/�Y�� �L�"� �b�-p��_�P�0��T��
x�������)6n���LH,�T��4Y`���f1�ަI��6�Չ�׀sR�͐�xACڠ��/ߎ����~e�Q�sWDz�������}~5{_�����`��%�i���9�����Z��+y~hݍ���EZ#/�++R*]`E=	/w6p�aDBq�tj(D�"ViE˛�Œ��r ��WP1��S!�^]6A�� �ޠ��!f��0A;��b��K/�$.����2˹�� }�ly
H��?ؘ�E�J�e1[!���׾���*���?��o9@�Eq|��(�d��pXZI�2�'�0���XH����f�j�J]���xP��A��jNh�P�ɗ��q�؟�~�*�B�I?7��/o�(��'C���t����~��7�G��i�n��W�˘�����&����ΞRm)�e���	�T��^�A�p�F�S+�Lg:&��V�r)2�X�c!!@!L_WR����#x�zƔ��*eҥp�J^��k��� �*b-&��J�=`b��L���>�~��f�� tA��5mt���xV�(4���5��V���.����4(�=�l.�|�k�B��w��`Z�G��Y��Z�ߜЌ�ϲ�c��[H�tq��"�De��Y����'��^C\�NI�>(��ijʉ�(f��*шBp�p1C��6'��[;�*W��_A3���\��nHg�'��x��n��������Wg��Y���	��u�H{r&
ݲ�X��Z4%�+`��o�AcF�[�<t��Fl�;k��v��k��7��&E�	{���TJ��W4��Vد��YoԼ}t�� z=��x��M��o���];�G_�s*>�L��c�|�2K�� �'���[���j!P9$ �-`e�CXLx������60�bgR�c,5�B�MU�<�e��0�8x ���*��G~��nύ��=u?��=,p����Г%O�MR��n�,�Q�%9��he��
Г�W�E���=���b���mU3�g t��u�HS�BZ�@�Ҷ���r�R�L�\�?��HH�aK"�
��̑w�(u���E��?s3
~�=�g�~�<��������[�w�xM��H_��y�=9����9G��ylL��� C��ײhI��e��TK8p�\�4�,���))c��î:�B��lm�5��,(���d%���wC��IE$W��m�m��G�E)W��I��f��%���3a8��Uv�6�k�<���Eb" mF���ؽ�U��ρ���b���j���H	�X�Y�P��:Q4vڡzN�vsf�I]@By�@-茳��T��נ8)��I����B���ĕ���f6s��VF�8P�����׆���������'y:�7�������,~=�߲�����C��5�ԍ[)aXTVQ�i"J5��e�P��RU�	7�����%��)`+�(�9#�L���X�8��ڻ��v�ح�� �J�kHFJ�����	s��ީ�G��fB4���@yN��;�������뵖N�N��5���M��c�=�S������ɔ�k|�������ž0cM=$"�=jiC4܀�*z��n	��@S��d �/���&W�q���AP[��l#�̥`H`+�v���=*Q�c�r9�*q�pӰ����Vj��'� �2)��%Ѫ��>�&�~/�Br^�H1�㘕�~�P��Q��h�5m�#�:0�X>FN����������7�xSG�ٳ�����I������/���~q�L/ݗ��CMן�mj����M!�� W�I�¦[�S艦Q!�l1�L�m��24@����A��;���2���#��w����w�\U�ִ��U�-M,�1l��iQQZ�n	��N���#e�����K�#o�<\��J{@ܫ!H�ݼ��UyƼri'�qtӊu9�`#�kaq�~v�!X��������׬0�]L
�LJ�J	b9Ӫ��+��t�g���$}S�@�&��N;%��!h�xF &�&���N���]�;��j.RNv��,���p�;w&/g��4��2��i^Љ�H�����V1����@I�����x6���z��|�sxV��,���.��ȯ,I�DX@&���)
�����m��;�EN�/�.Í%?B�1\�`�Ρ�,z���L6s�q�%�:)cD��KI���gY'�������JW}��!x��""�J���Zq�� w�C���h���ƓB�X"���X|�������0?`�2q�E��\��g��&:�-,s���R�d�1�ۺW�Rl@GH(�)[2�!���ح�9�7�-ZA>�����o�e,�S ���U�|��I��_o�1�<Bc.�C
�ET�����K����R׎�m�ǵ�nX��%w��H�EQ���ߙ��p��J�]s&_���"����8I�k��Zu�Zk] �L h�I�-I����M�B��}��.��q��������C��o��ӻ竳ۇ�����׍vt���OO���}��yyix�?��ѹy<x��a���`�T�p�*�������K�b,��X��Q�������i��N*��%%1��
S.��3Q�\nq#t ���[!    ���&=�����D8�;�~N�[!�;6�+�Oif�6�J���Hrk,��V�ݤ�S�B�� �WJ+MA����*��JowP��H�j��J#*�r�� �{���EM�$�d\���Ǩ통	�mEYS�)�8,�`�B��m��v��� ߢyW�"Ǵ��sw�������:��Z�ژ��ף��Y;��������Ǔ<�Ӌǖ;i�+c+_��r� � GJ���
���q�2n�ч�SIY��M-�Rͷ�kim`+��ǈaN�lqI��R>[2���ê�M���<����`�RXޕd�<1C����2�'*�q�$��0�!��`�u����m\w���no��b��<������s��wL�b�I�<+t�����
�4%%B�����5`�4��_���`n�C4D�;��m�w�Z�
v�?�*����W��*Ѕ��-'H��NR�~��f�e�VH]a���!��?G��{�/���Lb��/s�m��١ަ�"R�/1��CX"u)
3k�+����b5�Q��@�����r3k
�JR�F	�����"wy�,�p-�D�'�~:��AA��fO]�����h��?���I�}5���s��Ο�C#z���ǆ}�����a���d^�ޏ|���ˇ������{́�� U�P�V/rc޸{���b61��d`���̥e-�L���s�!t���4��})'��BX� EE��jS�KD��mIk��?�):ҍ`z��y���X�Ok����U��L���%J��G���};�~v?���T��s��P(�)�F� ���q�ʤ�'�&������Rԫ��)� ;��$Lle�Yh�C!q�����A�����{�������bԭזv>}�i��GvLκڿ�����d��C�&�L�?�jp�m�uM�����u����NU�ec�U����$����y�)�3]�/��I�."DfkCy>��`�-�\�rD�a�Zn����.`��wv�~1D+퀙@+��l��]{�c�2 ���R���0���`"�U�O��YU"�C4�jE��-M��=�'�q0r�������:��$�?s��4�����L�֜�
����B�$�x�am��n��%F�<e�GA�f����M� +*a\���m"(�>�[`���1wHW�@�O�Q�U�;$'.�R[c�����)���S8p�Zq v�H�۝�������������|;�+�v�*�h�zF��;c�����e�|�-K���	���?)��C�u��}4�gs�Y�����?��l��0w�H�Q�Dٲ�+'Jd�;�ӌGT@��lh���g��ޜ�{�N���m�dY'��� �����?�+�
y�_��iz�'W���m��ulW���I��}ޱ����{~8&�s�m]�r��c6���(��L{I�!��Ih���������d
^UQ����w?l�,�*^��|o�_��D�W.�Ƿ����|��t��E|�=9�ߟ���#}}����������i���DUw����N��Y�� g2.�S��|ˣ�@Hco���!�a��c)������$s�ts��C���DH_�n�p�h��T�&�0	��|j~��~i0��֟�ҡ-̢
��LЭ�?4-4�sqA�)Z��O�I{z����ݿ}7z;NS���?�����V{v�<5�]2���\M�V)�Ͷ�-IF���U@����D��s�A�pÎ��f���۞�il��L�XM����H���a]�!���7AǶ_�(W�l��~X~S�?�̄}����0�by	N���D#b�������|!�D�0�`�H<qG��	��ө� bs�E��2$kk-��,E���P\�h�}y�%a��¢�ɨ��ǀ>D�������˓�����ԍ��A�7�^��u���lzp}�ף���v0�lI3������Զ��"-�`N�-��l�GAc������P eZ�,�j\ͳ�y�Ꭼm�aHme�eQp��޷��,!Dr�9R{$��e�C�<I	�#\�Y�w?�(�. �h��C"rk1���j=� #�>�KZ��N�����+��=��G_��_ڤ���>$%aZC�.�\����-�q������j�b�/�F��]�c��YJm����,AIV.��g��)w̩Tg)��I��L������Qz��H0��C�
�}��!����U���r��F#�w�".�_�zdN��N��M�f�g6M�5I,�Je{�g���	H�C�E�*!��+m��t<�%P�)��+�{�-Z3�<������D'܉� ����(���+NV�W�}g��0�')]GX����`놱c��]=�Xgٜ�#��r�����s���ڗ�������}כ����εz�;P��N|ڄ������t��O��TP��9+ 9{Î��k��էV$�<�$b`[�\�d��#L��6�	���Do���-����1���j�;`�ZY�Y���}�zO����ŉ�Y�����l�t��G�A����$�"<�p����9O���#��R�$���td��]��\�L-l���PP+��ZV ��p	M�ی^�a2�Q�h%ò��z�Z�&�^Ǳ�&F�����݉�d�P<�d�TdH/� �'<�Fl���!r�%8+ ��R�}���j��廉�}u;x����������smn��������������g��Y��&�s�$Vi�ڙ��N���ı���S'��w�+���:�|��Z���,�����*+�����p!��$L��7s�ʎο&���/��sr��z7�??�iQz�xz�:�i���\�q����>��e}JR-f��2�S�^�4E9q��x�C�V*@�4U(��y�Uz��Q���0�P����G�q��.*Y��d3��o���`��l�����Z�&%sH�5�G��ĒP���K���v��o�����B��f�{�i���0�+�ϋ�s�$p��ۏ��{��.޾��QK'��Eҍ�����q8H��<Rt{zw�Ug��L$le��b"��Rj�^�t��V�Q��`J�8d����U\�\*t��VƃԻ�cU�����H<�۬�Uݜ>}���s�=���yp6{�?i��]?�ώ�����JR�[�T���&�HV�g2���^y�
���;d�Q�_h����*�U^öHR�Au_��`v��1E&��3�zyf���^G�=���=s8��B�HK�"�ݽ�䃄ʉ�W�I^�}.����*�����a\/ʯ�jg��EUi웫	�r^[lr�Ә���7�7�CIR����֕���޴�@�i�<��<��¡,*�=����:�%�x������N�O]$���l�RI��C(�q8�#��'���w�im��x��ϫd���hz~tv�n�|d�o�s�����O��[t�%���t�ja��[�e?����ۯR��' �W�8K|3Ԑ��,!��i8q<�����!f)Z��C�������\�r���TEZK}M�m������䔛I��ѱ�sÚoo�獳�v�~��E���O^;KT��|��=�[�~��*d;���i������)�1��}bbV�gR�S�Z��ҭ"Z(�=�D�-�ے��J{{�m���bww����Y�M���������ot���=^���Z������C����l!u�bt�J�{?�� �M0!���X����P-(���	�뺖j�\��v7:LV���F����.��r���z��F�k2�� �J"�rLE�?Ϧj��>5*�D��Mh�eQk<K��4ў��B���O	�ze��<+k�V�5�q���p�9Ă��,7�bO�M�ۓ�����ח�-���Fm�{=;�ܜ�����Ӄ�������ȑ���k�{W/������=��e��rυr�!#U	i�A8��S�p�6�Cr['0���mB�O�z�[����u�Ӹ�6�kqǚ<��. T%D������9j��iA7	V.[��E+�5h�̞^���K�{�v�zg[��>�OI=���}{��n�    �������7��	�V�9V�%8����^Р�-�D�n�l	ܰÿ�`�r��eN�L������$���Z��A�T�5��jp��Fn�D���)5�]���N���s�>���|��7V��A��<7��f�'3z>�_/�c/�7�����A����Z�������C�Ae�z�L�9��r9+��МBq^���H�vX�z�ή7
��VG]7�L=1�Ҷ~�5NS��@8�2,�PG�ЉXJ��U墩T(B֒R4�P��y1.�¶�h<��e�+4����!�?�L&��7O�ǯ��at3��9ʇg�GT������1�~��|g)��C�쯬1�b(f%���c�V�ە��Y7b-��ݨ�  �b<��n�m%(Ok��˽e�r�`�r7q)3U�q������\�+�e�%.�4v���3�$�0]KXk�v(0$�1-�CA6�B�k+� �]~潸��
C��S���Υ~x�g��>�����}Y��������x2�xґ��V;���ͪ-��W H �.�FR �Zg��E�5# h%� ���u��G�ݵ�e�&ky%��J�D�u1�C;t۹�0f(�z05�(��^U
�e
UA��(Ż�[���n<D5��W'���4�F����}-7S}/�g/zm�j4T��z�qf���`��U�kf%2�xi��X�"�S,�@��J�	D�Ai#.tËHz�)Q����kwz{��A��KP��ߠ��[]�Dy.Z՝���D�0[eF��km2S�Z�Z���Up���Zc�,�`�Lk�"���-y.W>����0����#������!5������n��7;~�z��^������c�><Q�_�/���û������^hX��,��.RA ���ԹL���K׋ڨy���E��u�rihl��j���B�a�?�7������*9%W�~{ywvz���J_N!��z~>z���2�9��:��}��C��l.�"�-���{DJ�ɬ&*�R��2>�Pd}-ĬT�,Ywn��Y0�a�S�E>_����:J��q���W�U�N��Y��������Pia��L�n��y�� o�Q'W%�D��(b.]`.��`hM��$n��Vd��;D0��[�;�w:M�Q�9_�ՖPZ��	M,�ħ�y���R뵕:V�VDѮ��`ak�k<�%��������.�>:����<%</q3����^"J]�\�W�$��U���fYfH��O:�Ю"~����`��E}6�N�ZtU(l���P(޳=����{Wn4�f{�n��.���Z')Ė-���x����������-�
`_D����b�&Z�%b�7�Ey���Jhc�U�ۼg��`fӲ�3�s躟I����&-6?��\���0��_\D��a_}�����a�}<8�z��v7_����U���RO忱�����
|Ш�<�1�U$]�X�Ī&A��,aN*�����O����0���vea���
1l�����+��\{�҅˕�����g��e��2Cc��U �J�Ek�G�~Z��@�tV�$Bb^A�)�}��x~ϪC �eQ���Z
�$u	���3�@�P���ȍX�`�Q����F��#"��*J�#=���u�bJ�#���G[ϟJ��A��=�n����x:\y��No���h�f�������nwm���*�|zV��B���"-��d������m��7����`am�}�m�:�*�&I�`b�+Z�}�0:H�>ߢU`L8�-��4f��	g�N,�,a�e����)٘"��J@���=�M$��W��#�jc�)L�0�J�|=7���j/@����}��,fN4!�W ���	��j>��6Q���P@KF(&��$w}=AԒ:u�?=��ǝ�jX���5�y�*L��G��t�:��Lq���`!^g�$��,'sm��[x�b�t�¹�����ݬ-�+�R���[C�Tk.Ķ��P��W{�
�� `��g<��9v��]�Д����P_2Ese/]�5���_7����Ӎy��ْ��,�Y)3��RQAV�b�'F\�5e���n��);�$���n)b�0����,`+�	���+b[bг��
��mZ�: k�V:��0�b���k�k;d�?-uD�ځ0`޻Q����'x�u;�2Ri�/e��T����M�4�������2�E��Q�2��r��[��s�b
��H"�� �8�� ��\UX���Q��s����^�
`�tZ7�b\�\�����5�J��ç+~}\�p�j2"���W=���\��ۥ3��KE~?i��!��a2˴[=<�	$W����;(
�cc��$�,���9(����8���p��P4χTE�M=��]���v���Xk��r���==���5�w��ϣ�Q��`����5rjy����UT��W�@̂9p��Պ�OQb��k�"�2�5��*�����<l(�qA�q��s^P��cU�a��vw<��l\<����n.^�M�����w�ﵧ������s:2o����s���RK%���zR�q#�p";+������O�:�|�d�)���7���l�.-d���}�W��G�~�®ӟ����u~��������X����P=6�0;;zJo����Q�=���>��d��O�*�aV��'z��S�1����4�V��� �(��rd���(�.�����HT�&�.���gI>��C��O�綜�pu1���w����=�Ά1o�^ޟ9=��s7:��K�}�O�C��ֲu�X���Ɠ�W�B
�H�8�e�TJ�E'iC���x�1d�.!*v��6q0g.���x\>��־�\ܝ�&��=�w���ӯ�F���u��{0�c7�?���>������?�$����$,�cF�����֢�Ж��k�d���|�b6�*�m�x�5��j3���"P��r�
���2C���[�I��i̱�[�D�?|���9��m��bEq�c=��y�^}��P�y��	���G��e�������o�\���ٰ��_^'�L�͔�R������G��xV_���Rs�+����^����̑ ��t=���}C��~��_RT$�V[[A� �]��u��{������=~�H���Y	��/&�6YFt��:#[��Z�@xi��sݚu�D�-@@�Vp��I��T�E��i̮��� �	����a����r��7w;C�����|��+�ʗ�нN���cL�In�`h`����ڴ�Ocxw�"�&syv�$(	q2��F�+bք�xO2������-ܳ�@��k�]{T�Xj��+�v��0���z\.��N{g\}5&s�{s�(^.o��{�>N.ǽ���7���'�OD��@(ͤ��q���X���V���6_?�M,akes���"{
w11�n)�&(�E�z��nPR����2i����(0� 8�*3�ж���fb���(�-HFXfYY�1�����Q�q;/I�/Z�J���8�O�w��؝����n��ةN+5�7j�ZE��ަ�jS�˂r�&H6T;0��C��g��f���R�͠*�󗃉���������Ց�Ny�xl9|^KY��k'�\R�l��eqHc4A��>����s��W�ݡ��b��٦ђ�����}�^�&IϞżQ���������vk0�=�9��w�eW�M�{R���b�p�۔��H򗊱�$�^�,��b��v�-���D�>�F?�D5�#������6�_n��:N��5��Ə�ˋ���[Ɂ8�'<8����ӃǓ�\���������md�Ko��RRa&��|;$nȔ)��8%�9�te�e�{�4�i�1�nT�ü��"1�%*
>������������������o������%ᬋ�)Q�&D�,\�1��^��I P�t��M�����&�4�%���W�!�T��F����Y�����$L ��J���g#��%=�Ph}��X$>�D%�l;4|M��b��L��Hi���D��f�Z��:���d����ʯ���ϯ+    >a"MI�N���2վ\xS�!n
5;+�吷�v��o/��)g���8��������$�Y��rMMYZ�2[ā�V�G�R���N1U�^yBb�b#h���DWt��Z�C���'�����Q���A4��{m?ܘ=�^�j�O�=؇�`&Z7��(]<~,R�^�0��{;�!>D-����IB�8	�:�H~v�<_�+�Y���f+�	�6@ �E�B��}1�ڰ����x>j��qw2ٓ}���OOӮ�;j?�nRz�ߞ�Ϸ�ǋ�y����j���^«:��x�Q��"�i����aB����J�_��T�f�Wɇ�٥:ٞ|��Nކ�?nIB'�9$�ć�	w>{Z�8�6 ���"vؾ�qX��O$��*�b�P'�g=���n�&�I� �u$��hg P�i1���fT�� $��
Y5T�]���[�K컣�4�WU0���V��������И�.������^?�^'�W�j�s�x:�W�>5W'*��m����$��94�FخYY��@�;�-��8�|*t
�P_��'׶� yKВ;�T�uzw����)a;�6����Bu���eնp�Ҳ*T�+Y�¶�ٵ斋�� �h�$L3O~�������#В�9�3�l +�"C��"TYZ�{������E ��a���
�J#�wO�8E�o�$���h�j�2k�{�����F��L��z�NDZ��t��`o�������я�Z2���X�����-��$�G���d�_+q ��M픳ˊ�O?��4?��H6$T��	�6Vm�9��Xd�v;s�z���߳�@o�p�7�\��RV!a_Z��/rxvx�.'���夝5T2O���q/�w�I+�u������y�5���"��u�nd���*M�z�.S�D�n�a;�⥷ *M��aaז�"�*-������f�{
j<�ua�/�O� ����K��~�����"b�q�~}�?�?��E�����:�=��������xg����s7/����!1�Ws>��ʯ�\�w�Ӹ�I*0�Iq%�gRR�IL��`���H(	���Pr����եS�VĒn�$�}�c�ZQ������VȰ��j�ou�@� �Zi�q %eֆ@b���X~V��Z'z{�.��8�L������u>B�f��o�ף^H�|�Ϛ������ߍi��.�o��{�\�.O'���4���O��K=�s6y{�;]67lq��Uy��Kk�b�����쯄�	ǵ�}fO
et7��9KB�I�42R�{SR�*���3Z"Wl��?w�N�p0w�����Fy\y8��CHؖ^͌�����<�B�g r�R����HEHMr��T�V��PG	>����j�kW�G{�=,���i��Y��כ�7���׃��bT����氱�w��4뾼Lޏ�F�O�ݍ��]=>|]j�B�)�nm�U�~@L�����UiKڰ�����jQd�xA��B��p^���Z�;��:�Ao�=�����y{�����k�*���|��BT�sI8��HEc�y��X&�0�2�+��R6�>�q�|�`��}�ɍ�,d�%2y��(_��A}<i5��ڵ����B��Ǩ�*"m=�~ݕM����'{�
))�h����|��5�fdMa�6�ZXQ	�ECU�2+������U��`����
@��8��%pb��(�g�.��r��d[
=���b�I�)����3�:�{�I�L6	�a9ft3���}����x�?�=��^�׿��l$����E6H���q�~<Sw���3�l���:���8ΖI,����,A���/�����D.����O���b�2,�H	���p]��G�=���`��Z��~����i�n��7�̭�n��T���ra�7�_Ď�hi֚�۳�L�[㖐յ��2�V̥��M������>5����F0�.��b"��O��\5�n��/N����q�y�������yi2k<l�*�� �8�ѣ1�@1i�͕���VOD n�k6t鈣*=��r��Zѷ������DVJ<�t��_tR+Nڵ��ԹLɲA�5�$v�8��ѪbdTL&�yc���?��tt�'o�ϛۧ��h�rq5�ѱ�/���Cc��nt�^��lݽD�������U����,IQ1\��JQ��
7P�AmO��y�T���ﰏ�fZ�b�~j��MR�p����b�:�D�*t�Zl0�fd�{�+zUl�����]�'�����_�_�^{6ث�9L������z�����B[�r���� R�yI�,����R�vD�N�4#p���Y�o�f%G!@�J"��B�v�x�R�Y�H�� �����H��A ��=���'������S<�����^h@e�i��$VYV���c) �"ˬR�����]�!�4�C*Hd��aE���)vM�5g��ob��O��eZ��>FG'��섿�������G>yo�O:_�}U;�o���}w�go����1���G���o@�F2K���i�&EQ���S����ak|���yͷ�`r��7�N������=y�Ń�Ӌfa�7�{�Y�mA�KJ��zXB6e.����E�1�5)3li��
$a�ɃE�� �j(��F_E3=pcן�=myU�a`����$]$3��b��[�g�
�4��h�i�A���X��3�
*=D�)�NpA�$���H�yD�YiY�Z�ұ��b��l� (�c��B,Wգw5p�{�.Pl���fjmeG��Ռ��^G��`��q¥���,-K4)��J�b��,[2.�������2޲v���j�Ȧ�|h<)v�9���'�?ko�#;ҥ��-Т��a���<ρF��>D�q�W-�T����7����
�V������VO���=H��~%u�f"���f�4�3}���NO�[l��'�_���n�l�����������=���_81�,#�ˍ(m����Y�iPͨ�9x�AVcŞKi��B����9�~Q�w7��y�4G�ʒ�W>(�d����)�v�q�QE����Y������J���� �ԠvJ[^�h�d�J�"S�:�y��J4C�bD�A�Ȫ	RJ���(�QM)��M�D�¥�?�ԯ�����;mw.�'l��q�G���/�'_"�P���{��5ݽl�>�\�ɸ'�d��USo�	�$@�5*�T�k�S�;�&Aw7'�F�_aV>5� �	�8R�.7*�{0)�8�i��6�����۟��������?�����^�����
j iu�D��R1Ꭶ�;��zIX�R���6�;���R!PQvQ���U�B�������<�Ӎ[���s�������n�|�����&���<�w�;w�����!���p��������CG7��>�l��,
�����x9�e�1�:N�N3F<�C����T�
��[42BcY5��,+-�QTc�¨έjk�>K�`o"cE���A-w�!,^�X�����+`n0�A�2kf��ZO�;��?���R~D����#��5fH��Q�����=g������Y��cq����ܒ�bO��`�n��P����J��:hh*�@�%,��g���Y��,a,K�7��W8�92�0����|�,�)�Ӝ@IG��	�M�����-���-��rv6@��#���I��^���Sw+�b}}��������?�<ov����9y�8�����5�G�EkZ��A]|�S����X� עN� ����;
>�t�®pVr�5S�ƌ(�R�B�Ph0�+U5!>�$��*��oy9ҧ��(+�Af>����f˄�2�Y����:u�]wS#�k��v�K�?dvJр�F��`�O���#�un��oN�prp���ɩ>�ؔ�~2���m��z��O�����/_������̗֜�����ἰJ�s�ؐT@�c��ň2]�j8P�qDe3�||!+�$�A,q��o�!�P�2t(�io��e\'V_��Ǘq��]�����<z��Ë�I<���=LI�:i�s���    ;{ӹ,-�$��$m4�%Y�����[�D]�L��������j
�xLئ��Y�o�dx��أ�f>'�a��.�M��綅���p]W����T��k�Һj�]���,s����Q�����7����1�^.����9vVM�)�H�+yi�]̙JUj��~���n�J���@6��	]��>!(rB	�.�,L<`��M
Y��� �b����!�%���*�� 8"�[�_�Yg�Q�8!	,�d�f�q�KPx4˹ʼXrY\�Jy[J�&��)vӺ�eg'�.���*	Q+7D�B���?����*�4�����8s9j���8fj	�����y�H��8c��u�����e�@�h���y����gn�Ǒo/���?N���Ý�����&�ܿ�~=}߾�v��g��>��:��A�T�2�La
�n� Z��N�!u���;���+L#B6�E�t�QE���~>t� �����q��c�qUˏt]7�[�+@+x�`S��b�:NRx!7&K�������~Q�>T1�2���r
�&���LWo���l�3���V�Bޱf_���z��I�"3��:[Uy���B����f�a^���8�AVQ2圠""��+��{�{�b1S]_%��~�Ք� �s}}�,�����q��,U��YҔ��F�:��[W�UM6+?G�l��O6N�Jop!��%�DZ����)�%$Dxx/��H��DF��TW&/T�+��uʲ�E�Bև��6���u{���og�%�������.u_��k�T�烽�c}�|��=��N=�:�W�W�Z�l~�l�������i��`s��\KȺA%�׿<�;�(ቋ�V2vY���)6.��v/)���K���dՔ_A��|U�	�
=�Y��s<���o+뚛���������E|{��Q��o�ѫ�9��7�x4�1y�ˎ�LW���h^�ds�L�4C�i�tpJ:��������
�F��$�B6B��w��"��0�@�t86��½��a����۠�4>�9���&�����58�����6{o�[��������z�l？$�'S��.�T��s23��U�q�4KQ��scjU�R�B#�6�C��\
�ϊ���tck�.��S�����5=�?��,}HX
&�L�IgқZ��.�Ҡ;�0 �%ѽ�F5K�BN=�0�<j�ө���D8]��s��%�A���_j�	E��>����OX⃸dT~-^�h�*&+�D'x!+>.3��aתŠ���ZA9��(��*>��?��i��A�)�:Vk�X�:)��II���Y2 6F�2�������J���x����&4$]R�::��=�ʔYE���Tܨ�+�̀�zM��WI�.����M�%.O���v4Lw�ߎ�����W�\?�����U�e^;��c���j�zu� �(���o�(qm.�"����Ɩ5nXx� :+��(����LRR�'gs�td/��'�x��!(4EsSa
��K�$�ѩ����@�=p�*�p�0F ]+�ng�2����C��0,����]��!��vyU�頻��ǃ�p�hpnyׅ?���Y�n�K���#u��[/|��^w{��N��w�n����}v���Uk�~0����ݨ��[��4��X���ꢆC ���=J$Yѵ&Hh(�:Ի�sxޜ��\$E��h.i��z�|u�O��nt^*�m�/.�.�i�����ɥ��._8o�ͧ��������p��G�F�]���Tw78�ԄE3�(V;9 70�a���c�@���,s��?�X��c��I������ g�3غ�zZ'����vE�{n���#�"�@�{>�,тeR�`�*���a��c#�����P�s�ZC�IcHO��:�����$��N�\4H9*�D�1��mTb�n@���i��=�������gv��=O��aKN�N\t{y�:<{Um�x�y�ݝo�UB[��/Рqe��	�Yl�B�9S�U�P塂O��!�MREZ#��/�io�\�պ|�x��E	�U�M��nߟ�_<�f��ם����򄛇�7wwzݾo�E��\��P-�cH5٠�-���k'|#9�k'|`!�tE6M=�&����9KhJ��0ΐ�s(;9��bل��|�av3�N��(x���VA	H
�֨���:��䟃���^�oo�ObsvEt35��kx��=z������~� ��=�ؙ�i�+/�H��jr���D��l��7�@���Dj����[���7,�)��:���rR�Ո*Yh~��=(b��7���Vbn�0�W�WL����r�A5B�� K��\J2ṗIL�2F���i,������1%�.���|d��lò;��n��+^9\� �	����3l���Ӄ�ts�׹y�.�O�������������ߚr.}B[�I>T��ru�[z9��[��^�,���V��L��g�	����*��DCo��׮��'t�T_>m�K�5��~�Ѓ��׉4�&�΄M`��Z&Q�s�e�q�7
��c޾�!z��4Z7kw1pq97��I#�;GcH3T}V�̄�)�86H�:��ly>��z6���~������PfK.iL�p�2Y�L����T�Mk02��r�3����bĢ~�a���B�`8�7+D@v6A7'������,b�/�aKe�p
���Jė��U�T#��&�؆�+e�M�ZM�Q�U��;C3D<1�l��6��l3rST�@�xȘ�Р
0�I夈�Ӵd����0�V-��-�Q��`r��̘�7�+|¤�񝤍�md+zuϭ�6�qI�$��̣��u�0���A_p�1�v�8;�&!�]V~�"b�X��i�~�`]^}:X5}7 >_����|�� [z�x�<��ak� ��xKZ-�:��O�o�v�e>HĤѤ�7����R��!�p�\q�.v�o-���{`(�A[�D���X	����]�s(��������A1���+�̊�E�][ a���/!d�Ct�H^/cF}��X^F�b#�i!��pT�v�����M�H�KYD��o�j8�p��hB~r�Xw�t�+:��{֪!t���սP�k^�V�
�J�ꔋ��-&����>���ܜ��F=]51�@�9m����*�u��J���Q��=R�?�/���zm�}�^��� }���Cu�Ŕ٦�?���Hn��"�#�[��ILl]� �8�^��!�~�aE�(\�%��T@�gu��٧��c�{r"��	%����pB`��^�`<�����[o��s������U�ڭ}��ڻ�a�{m����羒/�C}�������ŵt'�����ӧ��B�mr+���La�IGfi\�߯� �F�ʲ@�'�ʪ�)��68TV��U����.�QP��u'�<>�yfw����0��dk�=n=������я���c2β��D]����!�X��q�����;uN�<U�((o�J���~ذTVL8m*�K����UǍnc�uFe�d�e��K���ȧ�ȿT_�$������������fC�o��������H/��̕�LE�~Ӽ�t��=�;�JV��ּ�ĥ��I��N.����_{]�|q��
O?�aea:7W�&(�ά�}mu[�/7����mv��k����]�������?>?��.��×�z;�z�t�޾��_�ﶎ����|���VjG�%��Q0y@a`ZWDAnX�/�&M�$�	��|	����ˁN���,"v�Q�7��0!��z��X�Ma&�$]�*���Wa=�[��r}�x��'���y���#�g�_�?#�1�հM�}}y����zZt��Y���.��bH�V2=�#�U������g�yaY%�*m�MI6l�X����$	�(����o��V���*^��~�NZ&6r�w��x܊��/�������?��ͷ��]�n{G���"v������k+�l�u^[Si��:�7�pÒK�x�3b2�cV`�Z�n��r�)޷W����� ^W�4    �+9wrJ���iz9=;q���f�P'����D��[�d�hz��������~�����=��ʫE���*����b8T�I�W.��M�|�����o~��?�>@�����Ͽ��O?���������j6D�$b�����tݰ�yDh�w�{kϨ�Z����5m�������	i�a���;:!���ޝ|�?����a��������Jv��;�u�hHU�S�.�Jni�=��4q6A6�_�IjQ��b�`$�R$�(�@*C#�G�*T�rU�N�x�g�N_W�����������3}|�M&�������/#u��~�_�w'���w�`^a���+�(�^����t��	�-�LtrijU;-9kk���m�y��4Vp�:�Y(�g᠌�G���I�-�_��+�bhI���ιvi���>����%Z���ӕ�,�2mp9��ԗ����B�O`ȃ���u
�-���L*0�qi�����6b*'Վ^�˖4+�3NN���g�S��n��cS�E��a��,/f_�H^kZ��Q�A� ���.LS~�}>�ǽ��d�5J>������j��/�{'�/g���.}�O���Kv�}�M5�,��T�OF5��bYӘ����x�H+�U>�GB��boG��UAC�_��A�Ò�Nٛ�֗A���)�r� %<�PBp�״\!�!�_ixC��4�xFq�M�y�[�)Ԡ%�w��O�j�[��@O؇(P�PC��QE��4�U�4�V����W�dS����;gh���+���[��I˙W�������)MQ^XB<���/� '���d�����T?�?q�~gT��M\�_�s���WJ^l������^OO�c�*�Gobs}^��>�w^��/�S�;-�#gkI�\X_�єǜ���XO�*b��9T�B9vI(��H�脮��X=�4�	���U�d���&��z�GU[��9�lv�mg����cv;~�Iz5�}�e��'$��{�>������19�����U�E_�x��������q7�q�I�S��8�@��.��7�lZ�L�H�� Kj�9��E.&�IS�V'
.,2�i�<>[
���
����;,~�
}ku��^���h���d���={�q�����O��8����?}�ܿF��ۏ���F&#U�^���1���*�g5�J���H�
�BI���SLԔ�'u��Z�.6d�����2U����P�\�ɞ<.+}����ź8[��jʦB���ǙL��0[����N��-4<����K�,l�J��>�HW�Bf��&�X��<�z"G�x�)�1��D$	�V�`J.:aT�yx��*�Sm��,Ih��g��Ւ4$�$>{I5X�l�'�ڸ���n%I�-��Dv�N�_�R����#?�����\�d�[��:mѝ���Χ�luho�~��]�G��`+��9N=ي��r��.�)�j�ke�l��c��ל7 �r�1�����#�۠��,	��C���YD�u���|r*uo�~ȏw��M�e	�YS#N�p;T�26������ Da�py�Q*d�圩FJ+D�%ɯ+�0\��epM�qTj����Oc��<��%���m,	�-�>�x�LX/U��Em�Y�Li�z.<>�1&�Y
��Ѱ�4�Rj�X
�
9 �E��B�33�F$6���?��?�"�������㏿���JG����t}O6���;k�wR���$#��,I��u�i�����jO�ž'Z&�!��°�FQ��qs�S��~�p9��U�˾����ӥ��Gw���?������>$o�o��7�/��'D�>���v��/��]i0Hn����r��41�Q��ZYb�Z������2��@�����
p����"��m_�ebW��6!z� �t5����\�2�jWV�VB�yUcN�%�t�L�E]"��u������,���ZhTڨ��F�2l|}u��-�FH�bH�?�K��~��������8>}�|�=�=����9���;y;��{�Ǔ9��B�,=��D�k�h!(��F���Ү�5p,Ʉ�̅�2C�8�-0[ڣ��tՍ��ȩ��n_8�J����7~R��x�5ϯ�����*c�g�OI�C�KS��x�f3?(�(e1���4N�GY�H�� �xI�w�ƨ�ZX�R����6�;�Mo6�����������|�q�w{�}���{���v�K;t����h��(���"��Y��4�Wi�x�d��R����x��)7�
�&(G�0�Y���#�kU	A=��u����{��:�����S��tu�j��M�p��G�x:I��Sy9��^v{�ί.��������k�}f `62�(��͈�=eL���|<�t�!\�za}���v�
f�o�e���7����#~.�������6���I���hztvr>8��=<�t���������<�Zl��e��^��4���CN(9�L�e�P�����hH	��9%�������?���/���̚[�.����!��r�7k�z�d��|���5lbR �P9�si~Pd�2����-�Ya�Z`��UI�����ph�l�_9��^��diyJ༮�?׻��X{`����N/��^ln���s�=x4���+���ŵ`�d����e�o�e�.A�Α! \Z��v_�aՎ$iB8�}�$Y	��L� U�x�Ȕ�RTM�\|��n~ZU��g�\V�3-����	��ZO5�D��uy'% <b���i���Wb"@0��Q�����MF8~����K��G�Q���4�KY���3��yK]��ߘ�Z5]��薆	*�w�Y0!���ժҷh��t����n��r�g.]��F�m��u��<��ºU��$�R*]w^2]Z�A#>P`(Bx����i!����ϺL+�z��w�Lh��	e2�L����CQg�%IZ�Z���V���J͛0ޕ �&��HX��Z��1�	���
��
���f#������r�J�������5�)�re�P�Dg.�xFRc�`��Z�N���^�eμ�ؕ
�8U���,�k�+
���W�����Z�5 �\��A���D�_i�8����*'%.�|!����%�׹Ix�6M��g0q)���R��ٚ���Bh�\ek�֣ct�S�ADd}�߅˱_��HHc���`�3o(���rVE��U�@�q�6�͞
E�8_�a=��%	eNA�l��u�W=*����Bp��H�AD�$0.$M�����<S�<ٸv�_Κ��B[N�FJYāY�zsgŖ*e��qB��%�ՕY����}fܖ�j�koU�d���?�Z�o!6�pU�4�DË��Sßm���Sk8�l&��D���� �NG��	��\�w��V5�81f�I��#����}�%���pniܷ�Ï�DJ����&��9Ti�O�+��M>��u� B�Ci͖U_BE$�v�R�T�"�AmS��(�!�'M���u�8�$:1��p�6ӷ%�V$xQ��1�~?N�t�4g.�(Qi�0 /��������1�t��G����Y�~z���&�<�׻�������=�;�ϟ��6�/O�dV���sD��ڔ{����%)��6c*h8�Ø���,m���K��WI�V8c��x���7:&X[�#��ھ_�9"��(�ߊ4���Ө![\�:D<bV}#>&�D�W�����pA�js���ͱ�Ѷ�R�e"�\���&f�и�i�,�*Щ�עplW��漭�����v�q��!x9�zT5�4>,��p��Bm*�<�5���%<�ibe�g�#kα��Zh+&ĳR䕱����	J�A��zR0����|;d���1Ǔ93����9_[�嬐� �	]F�x/�l
J�t��n�!C�т�*1���д�MELd�_+c�՞x��u�%ĉ��+
,�*]��L
V�X��P�����������?��?n�������Z��|A��l&��(�-��/Ȃ�c�X`ɜ�09��� �\_�#�����@�    (�-L<�q:e�D|>�x�S�*��9��e�Q��7b}g�1���vI�x��gTC���`�'��O.R��)̈i�$�rs���l��K��V4Vh}%��/��c��D�Ce�uO��N�����5�<���&������:�{g�������2(���a���ʢ���C�"KX��Y�e�ίJ�(���h�uFj%���%�ɱ�ܪ_5ȥ��dg)6�ʯ7��x�����A d��tD�F9.�"_&
�w�?˩2V�=17	�~�Ւ ��IՊ���v���+�d۽���lj�-�~���j�����c>�������|�>�{�r>zx�L�ށ88$Ssx��o�L�&gv��{:���t1`)��y����	�:�ך������R�磌I$U�Nn��.��!tT�l�����`dh�o=rtvE�B�艇o��it}�������A������Wj�����FB�8Y�U��_�~ �$ҋL8�3�J*�:AM�
�M�X��ea�)�#V]�x�E/^��GZ�x��?�۵�N6���g���[��ƽ�@B�\ ��]E�zxT�+5�΍F�U*s��ճ�e%�FcJq�X:咯����pY1���b%�n9��.ͼ*�qJ�wP&4מ%"A�*"$��,s�����1fсz��U|لJ�V)	��8�M�1�PVȘ�-����J�c)z-�)I��g�&*U4�Jf�d?#��!$c8�Ъ�%�:L:t`dɻe��Xc�6� l�6nP;S�_e Oa�xy��'�#r�K��L��Hf�����U�ғ ��#G/��nB�D����mm'��sn��E���lhh�!C2�׵p�^'��b9�^��!!O��s%c�<�PyQ�a�=�m��Y(G�G}�o��PfQ�h=CL�&�K��v�2*E���ږ��eZsQ�a+����)�eS�b����mC�e������Uؤ]����ם���w��8����e�?�_�]�������QO7�ln]�^�
<Mc�?���M���d	$�J2�Ե4�.9}�6�\�<�Mx�e����:y�(��k��%�V��3;��3��T�Y]���{Vϝ�ȁx�;��M9�UO[�vrî�x�U�i&������j�J$Nߕ~����2Ni�h�IO��$�� EN��:Ab���EO���q�a*ε��&��������KW6��`�'Hn�������GB�Z@)s�Jky�`�؝'8ե�A�JM�W
[�c+U�QJ���z1p�[X���G�4�S� ������:�/��/�����"�@|1�������9M��<�w�"k��w�rID�i��Jt�k�p�q�F~��̑�2���9d�1a1�Ԟ ��zp�"��WT�e�A�ɖ+[�U���:�������4Ǯ�0�6���_��XX���8M�j��B�Zp�q�I����Y�@���.�Uf&�3obX����aVM�̂9�v&�7�G��b�_@hCfb�y%��$��6Ht�R��˄�J#�����Vk�B���p��|ܩ,���5W����q�Ii�/� ^)D��$q��$��եg̖�
MдG�/l��S##��x�MCOO��R=~쏧Ӧ�1DWX�f�ܼv�E�3��\dIK�な�K%� }��A˨
�����5�j�$HYa���)�7�]�]�h��?��7�icG��+��~��+A���p�餶�AJO��)�x�&L��Ick�� ���k���7ڗ�!�������k���<������g�b�/�ы=�Л�3y�o>'t���)�Yw��ݷv���q�Ҙ�WL)n��bs���Nm�ɛDP|��)T�	�5��_�`Ջ�]�ܠ[[7��w_��6�ߙN�o|NT�x$/�v������ݿl�D����Tt��a|�qvw�ߢ����Kʕ�,Ogަ4㬚�~��b�*p��:"�T�6M�%����be�󉞤�[Ҳ�n�?���)�<y||z���ƭ������?�>�wz��;�!ϓ��V[ϩY�G5�NuYh�8�Vs�A�p��Z�	ELD��`7*���YRz�-υw�ղb����j�2��Gc�I�2'�uេ"��=-�N�����
�Dǫ�faX�CW;�l�p	���Q�Pg��ez�	��/��I�+�;��B���y�)Y����U8�8�D�&:��J5�f���sW
�$�E=44v�� �3�1`�!�4�4FHQ2�m��"�H��A[�1�ؾ��G�HwH4�ٲ	&��lo�8��ܝ��G�������-!8,F��(?��{�j�ߴ�;�w�y��Z2a�Yk�"�m7���'���i���i��M45X`yp}	�0	��f��2�=�����@����j�iZ�pԞ#�)���I��f�\a��w?�������7������,���s�4&�8��h�_(>�<�	��$i�RiDU�E!�|Q��إ����_Y��D�o��	�� J��g=���u6N �veVM�y� ��:���p͝H!��:&�;³�Rj�Wg��G츘�φ����������!W;@�LpELU����&0�G�����|(E��g���.O/���~�
�Q��|3��>�}���[�j�����L�OO�w�����㧳�c����|�����so|񍺅�ӒZ�+�j�2�0����t4�j��ܿ��d�4�m�hTm�޺lu	�{L�\*�>�tPj��&�G,��|Ř���#	6�I����v�R�q 9o������r�w�ʄV��VH��j$J�q�`a�7YL��RU�k� $�`�{�5b�eq�!nA�H�(l�	q�
��r8si{ÍpJ���E�'n�=>Q��=]�_XB�~������?a�r(�wb�>��/nEܳ�~K}������E�g���.C�� F&1�2(lY=�
IC��E� 8�� �1��h�c���l��|Fu!�M�_����wn'�Cտ��>�?�����U_�F_�����|���7�}&w��_]/v��:��9.�m��q�ƄC*�i����*����1�Uj8���ƞI�$� �h���{n~~�jp���]�
�O�)>J�L�^�IX��A���֛���'($�b�9B\�UЦ���D���ie�������fMe��/e�Qsgv$B�%�ΰ�KX#�Q�9���`)8-i�Y�I$`�[���bA���e�ҮO����3��x}���{,�}���8���{c��'��m��6��ޓ���w��^������[Owh3g�!�0��DEZO6/
�S|,���DFղ	՛4�S�Kb>�sQ-�qf�A�asÈsa�Y��^����qTx�y"�3��G�Y�j$�γHn�G8R85ͽ�`>�j�/���j��C7��XkS.���n�Zǂ�!a��P%!�o��� �&!ձU��rx��w^���;��{��}��H���W�{/����O�a�F����y�҄���^g��N����Dq�R҄����3��:���U4Uǃ�[E��R\ZڨA��;F�_`��$�F��N�E2��o�J.��p˿5��&L�a�[C�;�~J.q��pU��V0����J�P	���a���<1���譴�D%kڬ��#	��oY5�0�g������v6�[3��Ju`ҟ8��x��b����+�,�k*��8ʲ�-S�3�����`�B9_����F*QR�3E+&F෈&V��t&1<9��R\v�j8���w����{�m��=�/�����4;�;޹�/�����>I�ވ��0��!�I�*�Z�����*װ,J�C��<#(��VM�##���+�A�u��T������4u���60� O���$C:M�c�䵏�UY#ՄC�1!�B�4���Co��y�Z�i/���>k���w'f�"�����ޓ-�v!�p´;��A{�����\|�=�$�Nv�7ќ.�P�XY꠬�C	<S�r��am)x�r��$ܰ
I�%^9��e�:n�OTQ��b�X��#T�@R��    �Ù��&\��ɳ�L�
N��}"�l��m�3���-G|����q�==n���Q�0��^�[k����ٜ'�8��]�5O��L�L��*�h�re��7TJ� H&!����D�)�F�~��i�7�����Ɓ��r���l/��T�f&����)Ml�1�dJL[�UV���Ф�	d��*�e�I�Hn��S�/�?n���ʩRªV�+���yp��*�kQ�}�H|X�x��ܷ��Q�0��1tqֈ���PH���$\��q6ވe��9���D��x���&͚#e$Db� :Ǩ�1�|" C��!7���	�Fi���M9G��K�E�iſ�l[U�t1����&�,E�g�>�cݽ�,Oę4�&�� iÓ��D�Q̂����)D��#��r ��J��ڇ���&�5���g>)����	[�8�ݠڧ�ߏ��L����T�0�&��S#�܊i�9��w�p���z� ��y�	ŵld��mb�M��Δ����j�* ���A��|Ų���I��D"ōYfr\�c�D;]�߼i����xp/�0��(i\���4���*�qJUlx�ṽ�1�cC����4�u��t�dY	V=�%�Ǿ�W��_}�O�m����*6vg�ω��Ws��1��^}�+S�40!����P�@��X'9!$'�x~D�Z��iiF�*�젎²G�o|Ì^mS�O�B@����;ɉ��YǴ�iIV}<�X����N�=��RKi�x�66�b���x^��mad�Ȣ%��7�t�".�R�����$͜��ɋ��a�|���o��¸lb�t���{�\;U!��4��}Q�8��c���m����#c�[�d�l^�w�?������������`o(��[���W�)��6�x�? ����3�EDJ:��0>�!J�xΠ$�`J��h�������� W���`���/����`%�I!o�kKoO�;����F������-�Q��p��������������'{W/Ӭ�hA�r���	�𤷜e���C(P��)�a�CX���E	s�AsvI�
p�ʀ��$��U����jbFN�����aos���'�2N�.6[�G�=����ȍ������������x؞�h
���l��D8E����7�����*�.�
(Ƣ����b�<�	:P��_�����W��OK2-�7�Z��F�E6�[�5�8��(�e�������z��C�{��[2�F�o�iA�����n?E$C-[�ݕY��H����sg|��{���#G/s۟��x8
�CW}S���b���}��e�0�<1��Y]���.�6�^t��-�^�lZ2�gt�;Y�[��~������דe��e���h�6�dIf�c��ڐ���V���?����y�LD/
X* rv8������-���C�������(B0B3_UB62��/B�y��ֆrG��u�/��j��A�+:�dҡL@-i���R'� 8Y�S���74�h�ԃ��Uc�zK��D{+��8GʏM)�c�G�a�%+[����7���DQ(N>9Qk���9�&V�м��B]��{������?L�=�>�㗷���}޵��7����������u4�:y�-����ä����������8�P�67��#fI&� �)����eIBL�S/�1J�"�b�"���4"�i�Y��e���A�F~m�������$j\��)�h�6��M�,A:�D��y��Y�lBa�������k+
5�\��g����I��_�e��i��q6���bN��|��L�!�_�]P
N4�<�N��)i3���A^��ϻ��E��VM���p��4�;�E+<r���G���!i�J�#{��o��~ӛ��k�ݹ�|���j|ۛ�n��k_F��3uT��Xb@5.��J 9��/(��Dy��%1�[�&��D�
X(�1k�&�
�`�6iXNVu]Kj�ۍUN�l��$l��	a���T%�VO��y)��yN$�>�m������pq�	D�FΡ�s��Q<p�
=�,�o�&�y��<�䍥��W�R8e���i;d\�y|�
�G;c��g��?0�l ��l�4  nZ��6��w*����~z�����VI�*�$5#�Bb}�5^��3R�[<�"߁5�N���\x����h�Xay��_���
�k ��~��w5�i�t$n�
�CHH\a4�%rP��pj�p�4�jIa��*#a�T{�7����D$��Y��թv����H�P�=l$k[K��u	I�M�HbO���SH��Oc���Ly�΋��B�E���'�K*�������9�g��,sP�b�[���c�o�\�rU{v��|���֭���e4�=н��qy|xz|�yx����{�pL޻�x���P$�H̵N�kE

Q��d4C�)�O!c�x��/U�3^vw�H�e��,�&��Ea���?s/pܝWG-�x�W��7+����dNܭ<r$@�J�S�RSG��E�Y���a�H�@�&�¤�A�s<����)��A
��2{0��������tH:ө�xU}c��z���v�N6�t�?���䅶ų��;�/,&q�b���d*Ra�7)��*�<�.G���J4Vh���Pn
�f�w��:O��e��a��\Gw��ٖ���8I��P\���oy��b�f���NZ	�G����F�i���3x�'��c'����i"�S}��"{\훩>>ut�H���tXb�4�����t[�����c��s�����'ԡ���q�ܕ�+@�&�!R�k���l�9Hu�0�������v��=�Ê�`�Ҙ���
���yq�p�6�Y@IŢ2&�z�A�9��a|�ԥ��ۜAM+&d	�dR�55��`c�Ӯd?~�:ml�43yiΐ��"���'ΫmM��;�`�£��e�w%��ǃ�.�E��>I"-P���[퀈D���l��tS���ԏ���[4���#�c쨀��i�Y�t�-&�D�=�a��z�]^$�1��ܒ�ؠr��~��u�R��5�2��K�f��Q�b!,��4���\��V�Q��
�� �-5j WM2��i���
39�uY[vE_��C��![Z�WV&����%q,�L��0J�F ���_!%Z5��+�mئ�0o4j�3���#jUcf&e���a6��45�)c��I�A�R�Քʾ:�h��1�l�̵�T%F!�ߊ6n!P�Z:u�jη�D�A�f��
�E�$���&MTZ=r�Wi���xe���(�RD��@F�d��|�Q_v�Y���i��=�q�!(����*��gx�!if�+Qi'@�*�5�1t��h[��(+>���*y�)$f�Up�M �3!{=����L-�@{F�aaėI�BD%���g��.�֪��*8�#
�WQC���h�|;&���	�R���\���N�Р���������ٛ7�j�����u�����������ԝ_�O���x�f��B�etQ��V�]@P!j���j���\8u��"@��A«R��,�ڸ�	�_F�%�8�]5qV��G.kϋ���A�)o��TN�WX�rH!�Ch�Lu���Of�wM��"�t
��S�Ѵ��f]��n{���='�6�~���2�g��n�\O/'햟&�_�Q���o[�⽻�/��;���������v�]�Q������Є�-$��5�X-�[AjnX�-$��{��iE��N=/^bp �@�=c	�j�A��W��V/�����J,�:p6Ht��nP��\��F��B��Y�d���Z�*Q�{�{���A�,��d� 9*YbJ��n.����󍇭ӣ�J5�w}�k�����zJE�j��Y������B���!�\D'-
ȯ�D�ǖQ�)q�v�jy��Ȩ	�Ƙ������8�S?����%�pR1)]B����^8*�	�e\Td-D���	�[0-�̭O���k[���-C�1v���<�Ӌ�������ǧ�Ð�D����}�s�yr��Oz/�-����z��!u���J�>g	��:X    �R�T;]�ЦJ��7����D7� 'E)iR��9�6n�qk���!\�M�""~A�J���8�,^�fp��Ш��9�I]�9��N���i O�����#��F�5kL��{I�I�t᪗`����������o��ˁ�:{���劉�a���x�4ong�B�:g��w��|LBH)a���x3�6�H�%�����M(h�J���) ���0�������?������m�?������W��s �k�gk�$e�G�_X*�6��4N5�gT*�B�ZXx8>K��Yz`��9h�Ve��� �%�K������`��9\��9LiB��2���9�Q�f.5�(WKC�
edt>*J�hsS���n�.����7�]���d�ܛ���a��:�G�XX�L�D�x�:�!���+�n�Az��O�K�10F1�&��[�9��LA^P����N~�� ����B�͙[^�,�Z�Xą��r� X�s2��H��M,��Mu�cC$hp
���.n5�Ռ�NF�LQ���4�K���tp�7���d<��8��9�c��$��h�������2|�F�:65��/��Í1�D�'FV��?��u`�k�:B�!����{�I�c�^x���lfq�|ĥ��\wc�}���1���I�Q$��0g��p�p�(kb�R�=�Zĥ*�	��C���̚��3�]�kiJ)[0�,�^�`�0 �D�ҴKv�"�~�G$�B�!�D��T'�:�τE�4	��s�<�
�q i��1��Tz���-V���S�������a�~���M޳"#�S9uB�����g�� ��2E�E&�l�K��rv��U
���� ���o��G[_��`?}����O8�����t���|oop�k��m���xt5���C����g��B�:iz~ kq�'�@L�aE��ǣL�i;�Z��Vw�W�!Z�Q�.��.Y¨���i�q�4牪hf��<v�;E�_,�iR��I3l�J��D$HnH+N����9m�U�"6RϘ�	했�&X{�@0�����N9\5vo�JglQw�N�~�~��A��}}��v�}>��^�G����[t���}�ҥ�j��v^��D�ּK�p~�gFf{T�ސ�{m�7lƴmP`U� �ΤS����g&�x�\����:Z����Hנ�.kf^ Ԡ>|�Tx�4���(d�a{���F[���N���4]��i
j$��^�;��S�'1�<tK�#3���&��lQK��
���c�_"�2VL�8�8#1�V�)L�W	#y����U�o&�(��(��+&NV,,Ӥ�#����z��5�;Zx�-q��~��e"dpb8�ƾRD@"�K 3�@v�x�����$2��&��!j�"x���0�^��h�4���?�����)fI�Q�R��]Q�n��R҄"�W�lQ5	H�	mR�&�ZV���ą�9��$��ԑS�HX�VR���['b7�y�]�~��&$�������4�����5#���=��Jd������hYAEj�)2,ILiP���!�T^5aD1X<���r/~���Z�JY2��&/�A���_C�c	k�����I!�u��0νM�li�����}T&J��`B��qn�Ԇ��m����;�%I��W������m��&J�י�zyc�^d�W]6�Oۏ��������Ѹ;�?����\,��h�X��A`4|"���&\LjӞ"Ev��24'�R�T��+H���n� �=2F1U��n��.S�P!��xwH��(~�H5�]t��K':M.Į�������Bu�6[O��zл���o�T�i��!����)�G��Xm�X��~`����5%���G��i(nC�[>�c�Jꔘf�[Ա � �p���6��)�ʦ4U	��'�R�+'p���D�����td5r����:D#S8%Ռǌ�����f�� �?�z��YR���u�C� U�z�Җ����+E�:�Q�봳v�����:p�L�`�/p��L�LQd��V%�+�ui#�"����jB���BνJr�
%
�+6��<CQ�	��ft?�5�VC�����&2�h�6'*���	��MG�����!�G�YQ��dl�E�0؄3�j��a~ř�j'�\<h�Ϊ
�Kn��q#+
�]���*��iQ|⨄���U���8>�X[付�x?�Ԭ���Ѝ|wc�i^�բ�I�{{�z��p����M	/�4J�7v1D�K2�0pC�ڧ-�MfV�ǡ#yQ�jn�8C����V���V���C���p󠪤�b�hb'2�D�B��I��Z��H,<���l,Q5��Gd����]7h�7ܤ�����kb[e����)�HfC(jc�D�cNk�_Y����U7-��'��1;$��ZӨ{���[nZadt���U�lF�#� k�#����AH�H�d��v�j�3AI��HS0bL�d� ��4vw/Ξ����w�k�w|7�Qи+aw!�_SK1��a<)w�S��	�X�]Y\�~ˋT�g���b\��h �dJ٦I�Yq`y�k��W^&o����f���բ������"w�tH������v�L�#1>�켝��y���$稅�jJIb�,cFkS��IE�Yj�D�e�0ؕ�^�o�m{�/���s-45Q�NG����eo����|�ӗ�K��˯l����q"������Z��=���}�6p�X�]{2�6�Bv&�cF2W��.��$�]y�M�b����F� g���6���A֨��hX@��=5~3�Û�����u�H<!�v;��;t�`��sҿ~�����.�N�c7�RRa-�����9�fL2��@L�V�aˍ��<?hD$���׈�1<0Y��ǰ�kRf��h��H'�Կ��ʶ��`[m�G���k���/���5O���M;��G�����]��h�.��#(Įw4N"Maj�b��sɇj_Qu�@�+R�C������R��k��>Y����Ï��0��~A�A�̥*6w��x�U�:\Z��D�@ᇋ�d�@�a�u�b��L�lV�҈ʨZ�:��n��|Z�ϮQkl=ht��͋�ͭ���ӏ�����v�}��+��w�_w�L݃�M���n�1Vq�(j�G�<c4���Nm�	��IjaĻxE� w���R�b���$Ό@*̚����dw��F���؍�V��Z_��f��s�D�&˸��m9�
�H���7W��D����~����gYeFo.�{�gI�`!�m���	�eZ}FI�4�W3_Hx9R������g��DG0��.�R����ο���;:�������l����8胆�v����d�����&I�0�Gɝ�"Iy}ǖb���8�;�-����BX��y�d؁���$ˣ�ffR����W���B�g�%�]��V�v*����	�#��nt�~hO��s{Z�����,�I;�Mx��@=�؟��RZE�����o�K'���Z���҆�K8oLb!#l�[�� �CC7\oLb�Gơ��'.lHE�㨋��c��0W��C��@>�%)��rB�h��@o\q�nY��2�F�͂�~�����4�A��/$�2�2Z�Ot�kJLuک�YUe�I�G�����/��=�EA(]�o�Ed��]�ҎZ�\���Oi(�OnOI_�&���~��t�u<> ~g:̶G����}f�~�s�{�sy09:����y��!Aq��S���u��V��IF��Ep�����a�ŗM�E�C��B�c�|���*�;kڀ�����V�(�/(x�P��9%N�y�5,[yi��E���$H���+��s}������#_Ofdҝ��)1أ��-3ʡBB�d4a���}�n�J����S�����^��Y�yB� �L�$� )��m��~{Q�1��u�Ľ�`���	*S$3I�]�{��?��8�w�O�z�8"*����EMu��F��j�d����F���d��A���#�F�����q5��ڤ&��ƙ� B���jQ�D�
z��	V֝�WB�Afc�A    Ƞ� �x
���[�m<�������K���(8��8V�k�'m���uAFe�� Q*�
%MuI ��$�wU8^&ie;;\��o:���a�4�}LMIʼH�2�u'V�r ����IF]Y��C����G=�����0�в�K/a�4΋0��`��q"���4�)��6����V�D�����1��`����xa��� �+[���������TJ(����F���&'S
�s�\�
e�,=\�gck�G!����Uٟ���~;_kŉ>ho�n��=X��l����^kv���'��]�^^�y����#�py4%�ֲ����r�_(h�P 췰�W�Ŧ H�lfS�CuY�8,� ��nZ(���J�����mV��A��������!_�.�HA�����%�m�|�� 4�ctQ���|P��Hs�f��qH��<�TN(���ϓ�x|�@1���]2�:�_v&7�˃����zŴ5��ۣN��Xe�ן��J_�N(�i�K��(��%����5f�fi
�2)38.Q�Kh)2���ȃ�lQL`��hH�ֈ��Y�_EF��^���¦ 8�����e�fY���� �T]ۣE��06�����b	k����Bd���	�w�t�� h!����7H|��l��n�bj?^ɭ}1�P����.�ie
La�;Nkf��q\��7�������� 節��i �b��(P�`#�5K:��ij�-Gg��N&C0a#������u������s��}{���'��Sq����)�|��8~j=<�],��	����E�� �α�n$ ���0�v$ κ��j��i�q��%F[�&�Ea���% �5R�.!?��WAvK��*l���">@�`��Y�����+:��׷�'o���l������pp��1�zk�>A0�|w6ݟ��"[М��A���z��R�Wqj��Um���LAB:~)�n���s�`)��т�d+�fe�^��}6s
P��~A>�	��yא"��z����t!NG���N�����bA�=�p�W��6������V�7�x�m,�P��n�'�J�ƽ&���&��JhRK�P�&_/�wWZ+��K��2�S:�Q���*`���ڝh47+E{��%�����N�fY�d�6;(`�i �A����|u	�0��w���.b{�T��Iw�ҟ�o�[�	�_�`�L _���b��ڧ:��^�,��OL~i4"C�F��N�E�h.��ņ2�Fw�\R��p=}�f9P8������JClC3*I"S�}CV�?��
�X�B
�P����j�����]o4�
EE>#ױN��gL��_���W�r6aBT-i��+�E�$�F7PR"T!���񔊪*�C-�ŭj��>�Ce
�j?x��y�j��t�#��B*]�X��"�9M!�3�'����~���$?lge�Kpno����P�w�c8aiV,�@�G�-S����������H�W��M��~_��%�������$#7H�
�Y<�K��2�@ġ�<�M��Qom:/�I��=�����lo>��#�7��so��w�7�.������o���l|8�.�G��Q�|�#��4Ό�����fͻ�|% �(���5-�p��Ћ�@o���*�q����a��M�����pN=��+GifMRE��V%2��`K�ۚ��82��'���psiʅ+��<5�@nl	!ֲS�k���V�C&�ʔ'*�7��`�2CTi��Y�����w�;DB�|����AX`6B�Z��O9���lU�:\&D7�E51Ғ��)�,a`э�x�iϪeI0�3_�������&���F�.d�����iFaIcS�U�ؕlj) �J��\Y!	�V�COx�2>����l�bq�VQRz�|)]�����|�X}��n��~gz:��j�?���o��}��#����ݴn�sdrlr���s�C��YZ#e�*Pp��S�Ɉ�	�?��B��ep��b���"��b��KX s����%�������2���W�1;r35&��Vv����Vg�w�yvpyzqݚ�'�9��ƟM������<�'�/^ӭ���e�.P��F5�:�Zd�I�h_[�ᥗ�#<9�Lo9Iɗ$���$��� ���.��:�HF�X�R��fv��5��$��Ydvs65����6�[���IXv��@���a�Q0𦛘3��G��B�_l�$���xd�����"$�;'�K�-��MV�d9k�zMu�� �����Կ��F�(�a!Lq@�ި��H���LO�˧p�S��Q��%Q`���a� C�w�V����6*���w������Fޡ�Iy�ڀ��8T��(�Pl3P�I�d>�T����(0���2���K6�y�/Q]�P��K=�����2��+�}*4)T��UؤXIP��c�[Tl����y���9�t�o�jx��}��Bv���}��~���v��N{��Ѿg�<�-�G�"�&�A��J�������H� O ȳaK��*ܰ�"�4�!n҉�*��?�#��,�$O�Od���S.�0,�p�F�������P�1g͵~�/2}���3�J�y��$i���(��0�� � �.�#�0�Υ6����{�h�^����k2���<���lR9�Q���n���+���3�~�,�
���\ũH��KDŐ
$~ (׍��z�ɫ��9�;/b�QN��N��J����VQ&p9�E�l�ͼ�h�϶�r������,_[���8�b܈�n����$�50���з�gy�w�%��hX)��&6"�H�"}	���6�k�r\i���BW�82\B� ���d?��x���*�\������_p�k�<RBc��/��
GA^��YܰF(QY���58�X/;�h�W��G��<�σ�6�����n�ys6L���d��Ak���l޿~�O�y�����h�����'m�ͧX�1�0��t2�nŝ�-�׾��K`
 ���x��bm�jh���������7����:O͸u���ts�������Co6{�ݶ��;��������/���^��_ uH�b
�4A��8�D� �Х=�;�8e檯%�2bE�U-�I
%/Z��L��������^������Nt�%������Q{�\lu�ȟ���z��d�1�2��G97�1��bӄ��H!�l=�ԢA$��E�	Y�i)�*p �p$���U�����V���������?�������������5���i�̄d�R�hP,�d�3j��A�`2� �4Su��(r�CI s��WWd� �(�W
����C�`m�~���
��b��Z��G�ޢvc5�#� 8ް�#=Qr��zH�|��=N�{��V�SluA���@��6����u��\l��c��7�0�'���C��|}��V��8<&"Q�

�����<w���X�������_U�X���~AJ�1-�龚����+M�9
��-,=5�j�')f_�$͔E�s��6�qie$w�o�tXE����;p��?��G�(�i���\���{G�NGu����^l��"��'݉98z�[�����`�@��>~!F�Rf=,v@�+jH$bjPx��(N�Z��9�5GS�ݬיA��z�˫1(�J�e��7�gI@$cS����2�\�	"v�j}�F�sckP��p��~�YӃiH�U1��:�O��XZ/$N§�p�P�)�
Ѡי����d�e+�� H�[$���̾��<�*�-p=�lt�o~|�Z#�w�0��|}��om�Z���-=�ޤm��&篓˃�1�}\J���d���?ֿ�[�l�8����$W7]�;�E]�s�RLK^]
����л����J���1�,�����C�Ev�g3|۝?>����yr?>~�;[���������������E�I�_�X�J�?C�Ax"�ý��{x,h@�.ќSJ�[��ZflCj���^5���4��(s�θ9��3�����<TJ��M�}�`ҹ���;<8�hBc�
�Lu	��B�������?h�������ǿ���Å_#T��    �F���5���/��^&�H��)ת,UVI�d��ٴpN���ΰ�σv1��q�劉 �k����.��`9ĥa��?���3q��c�{�K.ۑz�%��`v�į�[�ts�m�]_����v�����zp9Xb�#!j���y�zI)��A9l�ZL#��dM�;���ҥE�7��ād�	� ��U�URE�������V�
�D+5L9B��J*0cN�l*�H������4�|J��0,q����f��q0���	�'UL��%����{o
��0x��7Y�x���r.�蝭Ā��n�s��"1iF��r�h@��>�,�B`�^c���2��6�KQ}���$���T��e��t�M�@�}�6��u�T$^�;����[. ����tafM1� ��Y��ޮ.��a��0����Ӷ�tb��2���R�����m����Z�G��>n�jMUZ[6��.>Ù 	f��i�%��1kj,���u �\�G7���P������S�ߺ��O���q$O�3�=zQcuպ=ݹ���>��s���8����P,�6�~��z�&�x���q�h7D`�c�%q�w�8b�V�,Np_	k��VLu*/�Z��b��ӏ����l�ߍ.f7w�ٕ�����s�%]c����%�8�ݕw��.p�U���b�g�tF��:F��lyǄ�	�U���/I��P&i�
f��M�w�r��T�2Y��~����z�>�>���;�u�;;�����_m���C2�|{{�c�E��QA����_�0��Xf:�i��̊�� ��;�4�� �y�ޔT�%0,B�z�i�1�~%�GcSP�.�������}w.�G�z�d���#�j��n����F[�N|�e������v�Z/�x��Hr5-,�p���0���҅�DnX}�Hg{�$��L#�u�Ӗ�r�,�Ab�����  s�(�e���%4%[I�s��aܩ��p�5G��*us�/g�4f�d$��c�|�H����4��Ƒ�`�yiI���(����f�� y8v�ɨ�`��#u�z]�o:����9�]�C��6=���:x#�'������o��}1B��~�Y�hZ�F�BY�ᨆHoXC����Ǔb�-����b�T����'%�W� ��I�5�($�M״RC�Vi����q���R{8oY�,,�?"%���b�L֚�5ag�����,V�T�{�^��ݠ����n�?�	���l:K���p'e`#�\9� �+��:ᨾ��7P���bˑY����Q)����%�V�K�|��x3�� �L���9��P%b�(,�J�w�0˖����rU2ȗ4�����8�r��B�z�R�o��gK�6�Z\r�~���l�ݎ�����y��9�~nkq�7���v��<�}�K���w�C Dl�~%X����`�C�3�^TYX9�sl��9����?D?Wn�L3��̪z���r5z�T�{��h0Rϳ���x��m��^���g�狨���=�����Y����P��w�yj�8'�G6f�ӆwdJ/B�mY�Z��,!	�L�4�N1�n|M�<�;�%9'��Y?��،�p�&�h���8y�P�TQq���R��WHw� ]�r�I��'�
(����P�2��q����\�2H��P��2S*����hK*#ʏ�SNJ��T��d���������Be2�)��e�?���i<�݉��6>?ǆ�P?sz�,�,c�9�+i�Ƅ�'����������J#g24g0͆MO���rr�n��p�}�i��
�`���P
R^�P2����9�R")�w�z"PE�{A|�,bN�K���������:㪊�;�|�� ��E���O��'}{v�q��9�^F�W�럋ν���������p�J�]���ws\Ac�x!��m
��y<�X���ߒ,����2<N ��Z&�9��c����2j� [�� K�^3��-�(^Z���D����i��켉���}�G���?y3���ď���_�z�I���Q�K
7�C�ڀ_5k�Sd��1�Mm�kՒO��� ��� �V�B��qɫ���bM�&'�����ď��^t��.���at{����rgyjY_��<}|��m�:�r��b|��N��EIAK�O�8���b�(ψ�>�w�l	�g���p�D�?�9$n���!�c��faF
�*�%�VѫA�e�o�d	�P6KxS��p��@�)��fJ��	�J����7�ҥq��-w���
<�ٜ�X�o���@�BC���
��m����1��}�����O�������y�i������'i�ҙ�]!��>z��Uk�`��\_�ʂ5��	2d�!z��(�AT�o0�5c��XA!��:�TY�En�~���$afY�~[L�c��@0��!���4^=�S�L+~����U���Yt�1<�n�'r|�����}�X��A�]Lv��7���=�Sx�,	s�i#`.�R��3�*oH����7��d���I(��B&��o�h��� !SL4��/zB��l��� ^��U\�V�K��k�����۞��ݤ~7�ܷ;�������ӻ�hO�����p;[���������${\��l�91`�!|��؊D��'���XhJ�^�6^h�l@�R�Bc7_�a�-�p4$҃n�A\ûkw+z[�JX �����8V�sx�$8�D�H�JS�c�:R^h��<8�fe��0�%I���C5"(��"�V��}�����}�<�����j�	�w����-�m��������H��h�~�B^>����'��|��@8e���B&��1�PYb8�����J.�S⋤LnŴ��H��[��K�G��u�_���g����ᔱF^gvg����!1�lO���Y�y�ˎ'׭�3�z�?GG�G����g��n�n�����{�I�Bx x�4��7$��Jr*]!0�(T�M�@��X�G��O��kz/�_�����hd�6��lP�1Y�8N�r��Y�kY�x	�d��p�aazL�i!��KPTr^�Yh�
+'�ʵ!&��l���w+]����
ni��e\"{#j.)J�
H0�X
�9V��Cp���]�2.2��0�֔aa�X��^.�/
��B�A��ʲ<��;|(����QR�'��e��4�a��A��ҕGr.x�6��B:j28�o�zx�0(�B��׿�Sz��
���MGC��X�6����(�c.�0s�RE(�}� �>D���פ��?."$q.v�NVp��hy�|z��@ �.����iX�ާ�'^a�����:٤L;l�[�io]�����(���W
%T!^�_C|��$]]B>-�<��1�\���"��I������Ѹ�\d43����s��i�z]ǎ/=t��Q�iŷ�a����ߗ6�@�g#P��V}�/����_�6�����v�:w��ȭy��d������ut�����}�M��a��k*�z�)�y�/�q
��w�H���4���J�|3�],��W�V�)��r�C7�,W���e�ٸ)ay>���x�t{;����W��Ѿ?<�<�j;ٹݹ�/��㥳}pxin'����-YZ�&$��f��ǈ���oF�o�uf�Y0A�(KxeI��;T!�[)w��G/~�t4c��9�:�� ���'!{Ղ�hةOjwg���yr{�1������9����i��Uk�p���{��o�D���-�g����$BLo�]H�7N��v
ĺ��V���h�#���z蛢��BP�`A��!s��.q�z������3�!6.F�IYsþį��m��		����䷣)�/��'Ṥ���.a)a1�YV���[�8��C앪��q:HJo�&
�P,;}�^^@�QwA	:Ն��R.N3�J-fk�u����u�@V�ag-��������\\��v�=��=���/������N���M?�}�����p�#�l;������s�=�W��s����^���nP{J��Q��;+���v�>_$�J��?�Q�%    '��'�l��[#W����{W�A2����%�5�h���Ѭ����c�	��DV��H�
nЦ��V�Έ^��x�c�8M"j�R)+m �$���K����]�M��歠%n�������k�v.5��m�˧̇h$e�,��8�B�* (O��o �erBC�&�s�`�M"�C���C�����&"mE��*`�k%,�v��/i���35ow�ף+y�z�]7;����z4�_<���}~9�����lg킑�㧬�A�jbbb���h�9GE�&|A�ΑA�YY$)�kT^�����������O���t��<u�I+�x[/I\��yn�T�ıW��>��T��)/�yo¿"�z��l��אj/é�G���o�ϗl3����ȟ{����,3�S�ǩ-R&�0������.L�b5���������f��#B��X��}ʗ��hg	��;Fg;�w|3�w_����^_�����q̭z�ݹz����^"��F�W����>��Q~��,��I!u�O�C>���!��U�Ǡ�U.�s1��}�y���z)�R�(�#ږ���ƣ���V�O=�q����ǣ�Bs�Ì��`=J�4ȼ�8OǓ��e�t�S��樆$5/Ng�K!���J5I�;�x�,�������!Jr0;��)B��O��fI�D^¨y�B�*h:�N��$��|	���>�Rk�����/���5ps�"|(v&��)b�)�>o��IqެU "a��Y�i�T���K2��0�P�u�n�s4�~������c�q�x��v���~��G�����x~=~>����ɩ��ɞ�y�ɇ�e �dc�6/Υ>�n���)c,m P�³�@�G1Q\��oJ&PC��/2�U~y�d�V�S�����jSw �i4y�eF���۾����ǻ������}3G����e�xW���a�����q{�;��g|�zl
�jK�`��L>6Y��h�	}��mU�;�͐cl�f���(D�D绢R:���h0b�DwT�0��3m�HP��$�pR�r�*+�ǰV$	������aK0u�0�EQ����%�8���5K��W���	��e��˯4;�?rJ"�� Ai2��H���end=�Ԥx�Nb������R�a[`�U���K�F�:�JM/,�כQs�`���g6M��:SV$<�XVG5"��9I#�lB��^��B����
���{�A�^��;Fs�7Ϳ��E�������f�u�^]�_�F��G�������kw�:ڿ�7׽��,Z2Y�����f�74v�!�`�n�1u��Չ}t
���B�=?6(}C��d���R3ba��"�����	�e��� {J,Kc��!�'����o����h�Q/A�A𑼺d�Ӄ<pjf���B�U'�p}�E�1����p?FA��W����'Bgܦ`�Ē,q�� 3�4:ļ���p� 7����ȨXD��yu���}?���R���g$a#��읰��۶�my���)�z�δڜڽ��*y�;�����,�����Y~xfF��j�9�E��]��7D�R�E�Vr��{a�
�M�`����Ɖ�*�.#�A��ƈ�0kl�jL���c�M���ΪU����2`�5ctQz��a����Ajy�mZ*��/��C���}9:z�n2�c�����hh�4��ϲTa���!t���/�	���7(]h�.�	��I��[9��{X�֠E��Y?�0R�Kr�Fn��5B*���+ �P�@� ��[F=����:�P�3+lv�ģ�r�2)�v����"@8T�M�ե ʪ�4I �ؚc��SO;>}8\m��<�d��~�u}"�O����\F�jzۚ�df�7瓏��t��H�<�˃g��!�6%F��I������u������A@g�k����}�!�1>%(����(��5/�"�_����X(b��j���[�&�֮l�kp����3������Ǉ�r���j�{9����w�h�>l^�3�	!J��LO�Ǉ-2i�����V�~i�2* �!	��'����5/��s�`a#l�H^]2�����t���;X+�,>��g�C��E�pX��&(C(gAN��%'TeR�8���b�@#(>8�I,2!Rn5OSo�q���� Rw��/0��F�y�R�%,�Y0������i����/��t��������L�.�?����;:�N����a�=;�>�^�҃�H�n&����ݝ	������=I���K��1��e�7�Z��~Av�R7�`.Pߡ�ia���%TB��樨�ߞ�(�y4Xg��vا�>^v������b;�Q6�7O7������������7O>n�݂��`��f���8AM���L��ˤ��R�@�����leɠ�8�D)ΐ^`�������v�N�n�v���H��,�5�5���[��Q�'�����W��rzۢs=��m�<\��n��\��I���<�	a�����G�b������'6Nېd�ؕ$��"���Ì8�Q�� c>��hPiW.��]XBMs�������+���I)��K,m>,Ԏ���p9�۶��y9'Y-�ňj ��G��awRi2M!��'�!m���y�t<?�����������qԛw�g��d��e�����t[ۤ�u򾙌��� ��S��Q��7hU�O8KF�L��c|�����f���b�XR_�#|ÐaW�uK��`���yU�d�$|:�~�n��1o�S�i�S�?�'8aca�����Uݓ�e�Q"=�t+jv��͠����B�&<��h8��4q��p�@ �9�R������g���0�Nţ�-$��@	�����0�����[��Z�[ן�Gg�,��z�#�]ƅ���s�u�}���,��1��J���Ha�I3�8:�h���V&ׯ�M󥯕�R	���(&���R�D�ZAR�igMֿ���7tJ,��P��Z�Bd���c.��$�i)YE!��'>}_�.7��E���<4ƌ�P��N'��XĤ��Z�B3&�L=�G�%��/�$�J�`��u��Iu`�a�6�#�j~�'VNP�\k�&�q�M���W�E���TU����b�)�s7+�8�'��vu2�̍�n �!�U)*ai�������ϏUB��D�LY�Lj��C͇��� �ӢO��I3SY$4�UJ��4A�7�g�߆�[�F��M:��8������I�|w~a�ͬwt�ytЍZ�Iv>�=�<����׋�����=>�^���X��2V�f��`���D*b3�<MD�dmq�#�Q(�"_�.,��w¸j��{?���F� x4 ��6�(;�p O��i���(�'r��r8�8,���s��Ґ^�A��=O��E�;q�jW��!<k ������_妼�gl�3��;����]��6j����Gb�}��=n�ͣ;�]��Fkmɴ����K�L'�$J8��j����{ ���y��gR�5�Z�A����3��PvTy;鈪vW�G@;��s��;��1wDeV��:kM;��5b�l�� ����Q�q"��aN:�\����q$ D��U:0����;ܸ�$�2G��#���s7���	t��`k[��)M��.5^��0��ϣ�$�1�� ��@*����(�$!���|�YF��`�%�%0��������kӠŷ�`���+g��`4Y�ȄٱA٠���*�8�8��u�SA��E��  .jٔ.�30sD=��	�W�0gb�k�u����7��>u�"�$�z�y{��z�y�LMgw�_'*�d����p������5�=���[��c�?��n����׍�7��D ���GGS����..�~=!\�"��r	���M��p�������%E�@�+��OK>w;~@=�6�FO�_�Fn�p���DM6o�!E�Lf�.5���hu�����
te����`X��/*\@D5�؁Pc:i�i�MI�gM]{�s�[���io��c�u���[{~<��l����\���}������~s���@��S���T8��) f  �+Pj] �[̯�~�ihڋum
H�NU�d�٬b̍+��@��ȷu�f����Ug�-"j������m���� ߱���9؞�H����C����X9���چ�V�v�)�6b-�%'2P����eY�.�^��!]h{M�q��%l�F�!�L-a�=�IU^uXQT4��p�V4J\���B�RcS�NΓ8���7�4���j���vq�)���f8�R�f�����܊�X�� �q�{�2�3і6N@�$�1mC{d��%>:�*!&�r��v�R��"��]��(1D�d�y��.�z�QJ�Y.�m*��C}L�@}$���B���τ��e\*`Wp�%T�,���q�H�(f�xx��Xd�3���Ro=�PȎ,�SJ]��
�DhN�%c�[�\m�SHNB�`�����í��ݍ뭳��k{���?v��r��j]��<l��RI ~ˬ��d���O�Q��W_]0�,#"a�K2h;B�`��/[7�c��j�o��fX|�Ās�<�9x�������ׅA��I�ivx��|��W��vX������G�e��n��x�ҙo���na�3���C�y�3>9\=?���ao��N�l��G�;���\����h�tN��C{s���Q�3kl2KC\c��'	İ2f����e���N����^q�)J�2�KAnGp\��� ��ݤ��c싕*����f ���\6�ӆ,|C>�s���8�!�)R�C�*)l�,�Q�?�!P$Ee	��[Hs�<#F7A��������"=���������VYWPt���0X�c2?��=d:�K��=@VR��o���H(��@F+��Z�S[��
�6��T�.7_#����/E/8�ZN�*��S>b��>:�7G�����gtfo{���eww��i�q�/ol|�}w�����߱x>Fy_8F�>ʒ�,�A�*-3��Ԛ�&%1S��u=�M;�ݡ�n���x8�\8t��*�{&)ЋC i�w���Ќ�A�"͆I�Ť_�����<�l�"'�uv�kw���:�ݏ��Ң���;Eٍ�=~����I�1����m�إ�YVS�-�R�X�sb���sq}��,��eJ`0[��S�fA��@�@�������p��kF4g��Aި�����;��O'D&D�l���v�ZgW�	5!��өHa���`�X�H)yi�7���)�2�i��c����<��=� I���5�a�O&~��Z�(��F��0��!�d���^����m|tv|wz���wv�gG���p?�����ɒ � ���tq���֞Vk�\�����aHGPR2���%�א���%�D���P̿�Tr:VNP^����4��(M�a�	!�����x!f��[C���t�翵G�v�oL=�IW�~�r�?�����~Z�(���O;\���6�a�A=�V� ���?�۝N|��:��ɦ=����-�:��^Y�G��Z�A��$5���7�pC�0[m�/�}j+�E[[�t�a��C3�SnQ��&X�$�s鄱�������<tx���I�MӚ��a/l"�MdT�����n�4G�b���+���o�����=�o���us����}z��%��C�:ܝɌ.z��Ҭ���H�1�"�� vE�u:"Fj�2�L��VdA��
b"L����=���_ƣ���?m�fQ$7��3��?H�Ra$o@�9d�Ō���@9����R\�2���!u�0f�\�ue��
�;��*���Ȼ���z�c�K_����{�p-}�zp�xsvw�0�L�tx�0�eW�g������U������v���R$����H)�����Nx��F���
T�*l�ޓ�{jc��I����B���Tӟ��ն�(�:�4�n�@���7��<����`g�{��g��V{o3>z��޹?��<̆G�'�l�'�tA��Hc��Q+UFh�!Z8 ����|#�nA�!Cu	V#	%�Ҳ�q��qkÅ/�ԨT	����t[M�c|c�}iR%����~���I��YF����P4Ǎ`�^�n��n���z���*���A�������-��F���;9��-�7OgQ��A�=�{���G�N:�ߧ}}����BK����B3�@bc�&���Ҙ����U�1�t����,;2@Y�b�U �zM�2�G�G���8�����֤	{y���H(ݤ798�(?s%��Ǎ�,���Z��Hδ.�P���Q)D0f*K7��F�s;��S�	�袁ߙ����������[�w��{s��v7{�D��F^v����'�m��f���)Bp��@�$�� ���F��
  
7��NMFL�I�ŜaS�7�;�o�#0q�LDz�(�.�\4˔�����7�WRr:��ek��}?�mǍ~�q���~���WI�Z�k	˯�L��$�g K��`P볔h�i�`�� �8Az���H-�*�F�.6$�FS�2�_�'�W��~0����Ѭ_�G_O�wvq�z�۫�q������ٙ�^���z���ڋ����;{W�|�ĞK���V���O�a�}r��xc�R��(��Q�y\j2��Px�Z-K�?k7ܷ���k�?@��ܜ��c�VI�#�̸}��z6'�`NU�ŉB�5��KjD$�f{��Z
*�w���c�i�@tS�r^ty9�[Ed�L�Y8��#Ց&���+ޣ�������xcg4�q}��]������x����5T�j�N�S��V2<h�_���;}<���u�_���ƪ�cܩL&�����u�Qt�j a�[Ȑ8�2z�`��{��|��_��׌�m�&�]�a6�sxQ1�WzOR�o�G��<N�;�H[d�\t��M秷�g7w��T�����^������,�:F<r�(N�ּ�b&K�D	�RC���K�N��M��	rl�S/�19a�P�Tl���c��g{���t�t�^f����hpt������-��=l�<r����s��Y� �2T����C65[�K'`���c2gķ�bܼ�$�(����F"ub�/�Nw%�>�z".���Xh�3�������}�����븍��h�~?Ǉ���eT���H�5�������x�۽��vw��`��OO_/n�� {�7�����Nz��ٺ#�j�*��oc)$�,�p���1K	�۷t�	�8M�H�k����ҵD#��ZB�h�EV��f}/�M+��\��*X���HXH�����b;ꬠ2f>��S��}�e�|+��X�}���	Q�D�Pmզ-��؂0���}��-�T�Pn�r簱w�<0���2�2I�^x��{wݣ�ޥ�'�����<�o����m�����:�|$L5�4ɝ�6MU"�>A9���ǈoݼ���{�L��%i#��5Fo���8sn0�UFp�v0�
�d�6�e'[2�'���<P1�=F����~�|��:��v��Y�������,j��~F�Z+��NV�Y90>��Bu�j尢nX�x/!�7�sE���U:q����C#�W���HeƐbm)��Zٟ�0W�yӽvsN�M�㖢�Y�X�����晞��7�����:3�\ʣG{p��w���/�+��=��o}�~�7G.&����2x�ԧ��5�������������      �   9  x�E�۪59���z�����AhD�B�A�mA��iķw����Z��J�Lf�1��~�����y>~�\j��يPk}�^���k����xn���zԪ��<Fi|_�����:Oк���3��[~{���/�/'1���{Bw.��n)� �[1��H��r��z�A���7�3�U��ޗ^}Cﳜ7�g���P�������uW��}ֵ�>��z���3)�tk+A�9Kx��ʈN�Wzg�I�I��z=N�n�'�~��2�{b��<Y\�?��	�=�h��t��ɻYD�Oz�����L��
��|4�uҺ�ez�29����������b�6���\O�_CLq���ꅡ���5D:�4�4��BG���T�t����S�צJIQ�*Vv��O���o����?���O�����������?_��txc)��̩��a�؊�<�֩Qq��⇦��߿�����������r]/W@�9�r��W����{k�(.Qo�Y�k�s���X���\��큙Ϲ�z��ڜ����비���tJ6��Q|�nm~|���j:�)F;�z�s��P�1�����ZM�jm�����B�Y�Qh7�4V�e49��������h>���n���SFt�mb�j�C�B�A>�v�xno;G0�E�'��N�v��m�Ud/���
�Kq�p����	�t��ErB�y@Y��^� F�X�ٯ��qH@�"�j䴕�U��挧l�����X>Up�P���A�y��}�h��n�z��p���ᣂ���y
W3��Q|�=\�`4�y8������IC�"���N��m��~��| ^�g���¾Ф���V0~n�R�R>�a,�O~�㑟��!@���?���� ])�~�t8(��H�$r���H�4(L��v<�'n�I�t��|Ao��-C hy�_��z��Qp��q?��^ �B{@�]����I�{@�|lJ��.��|T`�C�;�_��A}�������D����m������o��P/�} �)ke>�'���M|��#>y������oL�G�+S�|{���!���N�I�~)�H������"�w�G�:�lZpS��a��g=���"ڥ�8~�K�G)�@�R���cyP���
�+��G{�����~��s��!��z1���֟�>n"�7����6��_�ܻ��'�Ô>�K�}��y������J��G��)����	z���������K�G��4�п\n��ғ���>��^�y�~���L݃�N��L���җ@?S��gJ_��y��<��i���)=
�5�G�u�dޡ�i=B��m;K��"_ŋ>���Y�������馭x�gݾ��1���9�e�����$�ג�����;я���c#�]����&�pH���g�#&�Sr�������O��&zS�I}��}(�/�w�y���a��2��w�n��������kĳ�O<~�F=���_�?�<�!~��G�zO�]���O<L�K�O$w%>&��r~M~���Qҿ��%������<��>�y��	�K<-�k�09������x�x��3�?>��x�G���Ǚ�?����D��W��J�M��J~2ыj?����W��S�'�Q��>��=ч�'~�^����׿������ގ���>%����b[�����$~��7�_������>◾$�X����'����x�#�H����_�O������_���HO=+�/����z|}ۏq�t�D��u���{�����c~�W�'���N?P�������/x��#��҃��m^�O�'��Co��|����'�j�����W�WK�j�]�����U��/Z�з��/�fK�
�ӏ��z�U���x>�O���-�*������z ?�e�'�^���o
�lݯ�۪�B/[��Z<)���7�^��w�W-�)�U�O�<B�Z�S܏���Я.�<a=�/�^���Ы�������h�Q���O���J?
��v}�?����L���~������~�xV���U<o���߽�����
޵_����~���
�����|l�Y��~]O����'��U�r�ܱ������r��r<>n���8n?^7�s|�����@�&<x�)�e��\~����o�'������c��=l�{q}��7m�/\4۵4~��}l�ki��#<4뵌p=>��y�.����ݯ�;xڬ��w��������b���y:�k�=��+5�����#v�gI��bX�bX
�)�%���*�Kr�N���xŒ��#�԰wĊ��#64ŵĶ��X!	�_,n�o�}��3���/��x�[/1b�$�?�?b�����ʕ|�d����7��덶��r>��-y��0-�Z4�
���k^?K��9lK�
���Xްit��hψ��a\���ǯ�ўy�O�~�\�#�m�=F��x�k�5�r��s��G���W�ԏ`�hے�j�j�^���	�ZҚF����ў%��hْ�j�h��
h�_ѣMK�n�g���}���q�_e���[�F���h��Wj�{�+5ڸ��^f�r����[�F�7X��p��g�%��Za��ģ����ׇ5�?�o��|����ҳ���/� ̗�X����g^����������%�x����x8�z��o����+>�^��|�Z��|���+/�o���|Ŀ��K^j��>/�p��Ļ���.��x��|}9�}=����:?��I��5_%m��|����%^������l�sć��K^n���/�^�;��g/���^.�{^}�w/�x7�r�����{o�Ƈ�[���ū�^m�W�x5�m�||��N>��_ΰ^����-�<�����-����l�m�f��_3��������x2�n�'�x2�n�'ﶿ%�o[���ŏ�g[�x��e<����m�сg[�s�ٖ���ef~m>">���<o���,o���o����n����n����ne����w�?��c�?��[�?��+�?��'�����_���������l���W��n�[��{��~n�|��m���<G�y�l�=���B���Ѓ->������M�      