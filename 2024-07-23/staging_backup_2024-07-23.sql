PGDMP  7                    |        
   booksportz    15.5    16.3 �   H           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            I           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            J           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            K           1262    16399 
   booksportz    DATABASE     v   CREATE DATABASE booksportz WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
    DROP DATABASE booksportz;
                abdelelbouhy    false                        3079    24910    fuzzystrmatch 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;
    DROP EXTENSION fuzzystrmatch;
                   false            L           0    0    EXTENSION fuzzystrmatch    COMMENT     ]   COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';
                        false    3                        3079    24827    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                   false            M           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                        false    2            q           1247    16775    applications_status_enum    TYPE     u   CREATE TYPE public.applications_status_enum AS ENUM (
    'PENDING_CONFIRMATION',
    'CANCELLED',
    'ACCEPTED'
);
 +   DROP TYPE public.applications_status_enum;
       public          abdelelbouhy    false            G           1247    16620    inquiries_status_enum    TYPE     Z   CREATE TYPE public.inquiries_status_enum AS ENUM (
    'NEW',
    'OPEN',
    'SOLVED'
);
 (   DROP TYPE public.inquiries_status_enum;
       public          abdelelbouhy    false            �           1247    24634    itemRequests_item_type_enum    TYPE     �   CREATE TYPE public."itemRequests_item_type_enum" AS ENUM (
    'SERVICE',
    'COURSE',
    'BOAt',
    'SCHEDULE',
    'TRIP',
    'BRANCH',
    'BANK'
);
 0   DROP TYPE public."itemRequests_item_type_enum";
       public          abdelelbouhy    false            w           1247    16804    itemRequests_status_enum    TYPE     �   CREATE TYPE public."itemRequests_status_enum" AS ENUM (
    'PENDING_CONFIRMATION',
    'ACCEPTED',
    'REJECTED',
    'SOLVED'
);
 -   DROP TYPE public."itemRequests_status_enum";
       public          abdelelbouhy    false            }           1247    16826    notifications_type_enum    TYPE       CREATE TYPE public.notifications_type_enum AS ENUM (
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
       public          abdelelbouhy    false            �           1247    16862    reservations_status_enum    TYPE     (  CREATE TYPE public.reservations_status_enum AS ENUM (
    'PENDING_CONFIRMATION',
    'CANCELLED',
    'REJECTED',
    'CONFIRMED',
    'COMPLETED',
    'INCART',
    'REJECTED_BY_ADMIN',
    'CANCELLED_BY_ADMIN',
    'CANCELLED_CONFIRMED',
    'DOUBLE_BOOKING',
    'RESOLVED_DOUBLE_BOOKING'
);
 +   DROP TYPE public.reservations_status_enum;
       public          abdelelbouhy    false            k           1247    16757    transactions_status_enum    TYPE     f   CREATE TYPE public.transactions_status_enum AS ENUM (
    'EXECUTED',
    'REFUNDED',
    'VOIDED'
);
 +   DROP TYPE public.transactions_status_enum;
       public          abdelelbouhy    false            s           1255    17684 4   address_in_range(numeric, numeric, numeric, numeric)    FUNCTION     �  CREATE FUNCTION public.address_in_range(lat1 numeric, lng1 numeric, lat2 numeric, lng2 numeric) RETURNS numeric
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
       public          abdelelbouhy    false            �           1255    25314 !   check_reservation_before_insert()    FUNCTION     w  CREATE FUNCTION public.check_reservation_before_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM "itemTimes" it
        LEFT JOIN "reservationItem" ri ON ri.id = it.reservation_item_id
        LEFT JOIN "reservations" r ON r.id = ri."reservationId"
        WHERE CAST(r.status AS VARCHAR) = 'CONFIRMED'
        AND it."startTime" = NEW."startTime"
        AND it."endTime" = NEW."endTime"
		AND it."item_id" = NEW."item_id"
    ) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Reservation already exists for the specified time range';
    END IF;
END;
$$;
 8   DROP FUNCTION public.check_reservation_before_insert();
       public          abdelelbouhy    false            t           1255    17685 +   currencyexchange(integer, integer, numeric)    FUNCTION     l  CREATE FUNCTION public.currencyexchange(firstc integer, secondc integer, price numeric) RETURNS numeric
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
       public          abdelelbouhy    false            u           1255    17686 /   totalreview(anyelement, anyelement, anyelement)    FUNCTION     �  CREATE FUNCTION public.totalreview(anyelement, anyelement, anyelement) RETURNS numeric
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
       public          abdelelbouhy    false            r           1259    25436    EmployeeItemPermission    TABLE     =  CREATE TABLE public."EmployeeItemPermission" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    "employeeId" integer NOT NULL,
    "itemType" character varying NOT NULL,
    "itemId" integer NOT NULL
);
 ,   DROP TABLE public."EmployeeItemPermission";
       public         heap    abdelelbouhy    false            q           1259    25435    EmployeeItemPermission_id_seq    SEQUENCE     �   CREATE SEQUENCE public."EmployeeItemPermission_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."EmployeeItemPermission_id_seq";
       public          abdelelbouhy    false    370            N           0    0    EmployeeItemPermission_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."EmployeeItemPermission_id_seq" OWNED BY public."EmployeeItemPermission".id;
          public          abdelelbouhy    false    369            H           1259    17143    accommodations    TABLE     �  CREATE TABLE public.accommodations (
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
       public          abdelelbouhy    false    328            O           0    0    accommodations_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.accommodations_id_seq OWNED BY public.accommodations.id;
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
       public          abdelelbouhy    false    310            P           0    0    activities_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;
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
       public          abdelelbouhy    false    338            Q           0    0    activity_log_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.activity_log_id_seq OWNED BY public.activity_log.id;
          public          abdelelbouhy    false    337            F           1259    17124 	   addresses    TABLE     h  CREATE TABLE public.addresses (
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
    country_id integer,
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
       public          abdelelbouhy    false    326            R           0    0    addresses_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;
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
       public          abdelelbouhy    false    316            S           0    0    amenities_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.amenities_id_seq OWNED BY public.amenities.id;
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
       public          abdelelbouhy    false    330            T           0    0    applicationVisits_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."applicationVisits_id_seq" OWNED BY public."applicationVisits".id;
          public          abdelelbouhy    false    329                       1259    16782    applications    TABLE     3  CREATE TABLE public.applications (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    status public.applications_status_enum NOT NULL,
    "assignedUser" integer
);
     DROP TABLE public.applications;
       public         heap    abdelelbouhy    false    1137                       1259    16781    applications_id_seq    SEQUENCE     �   CREATE SEQUENCE public.applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.applications_id_seq;
       public          abdelelbouhy    false    278            U           0    0    applications_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.applications_id_seq OWNED BY public.applications.id;
          public          abdelelbouhy    false    277            \           1259    24933    available_amenities    TABLE       CREATE TABLE public.available_amenities (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    image character varying
);
 '   DROP TABLE public.available_amenities;
       public         heap    abdelelbouhy    false            [           1259    24932    available_amenities_id_seq    SEQUENCE     �   CREATE SEQUENCE public.available_amenities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.available_amenities_id_seq;
       public          abdelelbouhy    false    348            V           0    0    available_amenities_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.available_amenities_id_seq OWNED BY public.available_amenities.id;
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
       public          abdelelbouhy    false    226            W           0    0    banks_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.banks_id_seq OWNED BY public.banks.id;
          public          abdelelbouhy    false    225            j           1259    25359    blocked_contact    TABLE     :  CREATE TABLE public.blocked_contact (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255),
    phone_number character varying,
    user_id integer,
    provider_id integer
);
 #   DROP TABLE public.blocked_contact;
       public         heap    abdelelbouhy    false            i           1259    25358    blocked_contact_id_seq    SEQUENCE     �   CREATE SEQUENCE public.blocked_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.blocked_contact_id_seq;
       public          abdelelbouhy    false    362            X           0    0    blocked_contact_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.blocked_contact_id_seq OWNED BY public.blocked_contact.id;
          public          abdelelbouhy    false    361            B           1259    17104    boatActivity    TABLE     �   CREATE TABLE public."boatActivity" (
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
       public          abdelelbouhy    false    322            Y           0    0    boatActivity_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."boatActivity_id_seq" OWNED BY public."boatActivity".id;
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
       public          abdelelbouhy    false    222            Z           0    0    boatEquipments_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."boatEquipments_id_seq" OWNED BY public."boatEquipments".id;
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
       public          abdelelbouhy    false    262            [           0    0    boatFeatures_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."boatFeatures_id_seq" OWNED BY public."boatFeatures".id;
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
       public          abdelelbouhy    false    264            \           0    0    boatSafety_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."boatSafety_id_seq" OWNED BY public."boatSafety".id;
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
       public          abdelelbouhy    false    324            ]           0    0    boats_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.boats_id_seq OWNED BY public.boats.id;
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
       public          abdelelbouhy    false    230            ^           0    0    branchCourse_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."branchCourse_id_seq" OWNED BY public."branchCourse".id;
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
       public          abdelelbouhy    false    332            _           0    0    branchEquipmentRental_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."branchEquipmentRental_id_seq" OWNED BY public."branchEquipmentRental".id;
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
       public          abdelelbouhy    false    312            `           0    0    branchService_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."branchService_id_seq" OWNED BY public."branchService".id;
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
       public          abdelelbouhy    false    304            a           0    0    branchTrip_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."branchTrip_id_seq" OWNED BY public."branchTrip".id;
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
       public          abdelelbouhy    false    302            b           0    0    branches_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;
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
       public          abdelelbouhy    false    224            c           0    0    categories_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;
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
       public          abdelelbouhy    false    308            d           0    0    cities_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;
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
       public          abdelelbouhy    false    228            e           0    0    companies_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;
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
       public          abdelelbouhy    false    268            f           0    0    countries_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;
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
       public          abdelelbouhy    false    298            g           0    0    courses_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;
          public          abdelelbouhy    false    297            d           1259    25053    court    TABLE     ;  CREATE TABLE public.court (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    "scheduleId" integer NOT NULL,
    solo boolean DEFAULT false,
    space_id integer
);
    DROP TABLE public.court;
       public         heap    abdelelbouhy    false            c           1259    25052    court_id_seq    SEQUENCE     �   CREATE SEQUENCE public.court_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.court_id_seq;
       public          abdelelbouhy    false    356            h           0    0    court_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.court_id_seq OWNED BY public.court.id;
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
       public          abdelelbouhy    false    220            i           0    0    currencies_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.currencies_id_seq OWNED BY public.currencies.id;
          public          abdelelbouhy    false    219            f           1259    25096    custom_payment_options    TABLE     .  CREATE TABLE public.custom_payment_options (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    item_type character varying,
    item_id integer
);
 *   DROP TABLE public.custom_payment_options;
       public         heap    abdelelbouhy    false            e           1259    25095    custom_payment_options_id_seq    SEQUENCE     �   CREATE SEQUENCE public.custom_payment_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.custom_payment_options_id_seq;
       public          abdelelbouhy    false    358            j           0    0    custom_payment_options_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.custom_payment_options_id_seq OWNED BY public.custom_payment_options.id;
          public          abdelelbouhy    false    357            b           1259    25042    custom_per_hour_day    TABLE     �  CREATE TABLE public.custom_per_hour_day (
    id integer NOT NULL,
    name character varying NOT NULL,
    "startTime" character varying NOT NULL,
    "endTime" character varying NOT NULL,
    "courtId" integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    availability boolean DEFAULT true NOT NULL
);
 '   DROP TABLE public.custom_per_hour_day;
       public         heap    abdelelbouhy    false            a           1259    25041    custom_per_hour_day_id_seq    SEQUENCE     �   CREATE SEQUENCE public.custom_per_hour_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.custom_per_hour_day_id_seq;
       public          abdelelbouhy    false    354            k           0    0    custom_per_hour_day_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.custom_per_hour_day_id_seq OWNED BY public.custom_per_hour_day.id;
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
       public          abdelelbouhy    false    242            l           0    0    devices_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;
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
       public          abdelelbouhy    false    270            m           0    0    equipmentRentals_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."equipmentRentals_id_seq" OWNED BY public."equipmentRentals".id;
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
       public          abdelelbouhy    false    334            n           0    0    exchanges_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.exchanges_id_seq OWNED BY public.exchanges.id;
          public          abdelelbouhy    false    333            ^           1259    24944    excludes    TABLE        CREATE TABLE public.excludes (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    item_type character varying,
    item_id integer
);
    DROP TABLE public.excludes;
       public         heap    abdelelbouhy    false            ]           1259    24943    excludes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.excludes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.excludes_id_seq;
       public          abdelelbouhy    false    350            o           0    0    excludes_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.excludes_id_seq OWNED BY public.excludes.id;
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
       public          abdelelbouhy    false    236            p           0    0    favorite_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.favorite_id_seq OWNED BY public.favorite.id;
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
       public          abdelelbouhy    false    248            q           0    0    group_permission_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.group_permission_id_seq OWNED BY public.group_permission.id;
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
       public          abdelelbouhy    false    246            r           0    0    groups_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;
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
       public          abdelelbouhy    false    232            s           0    0    guest_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.guest_id_seq OWNED BY public.guest.id;
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
       public         heap    abdelelbouhy    false    1095    1095            �            1259    16627    inquiries_id_seq    SEQUENCE     �   CREATE SEQUENCE public.inquiries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.inquiries_id_seq;
       public          abdelelbouhy    false    254            t           0    0    inquiries_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.inquiries_id_seq OWNED BY public.inquiries.id;
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
       public         heap    abdelelbouhy    false    1248    1143                       1259    16813    itemRequests_id_seq    SEQUENCE     �   CREATE SEQUENCE public."itemRequests_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."itemRequests_id_seq";
       public          abdelelbouhy    false    280            u           0    0    itemRequests_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."itemRequests_id_seq" OWNED BY public."itemRequests".id;
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
       public          abdelelbouhy    false    290            v           0    0    itemTimes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."itemTimes_id_seq" OWNED BY public."itemTimes".id;
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
       public          abdelelbouhy    false    336            w           0    0    loyalty_program_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.loyalty_program_id_seq OWNED BY public.loyalty_program.id;
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
       public          abdelelbouhy    false    340            x           0    0     loyalty_program_withdraws_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.loyalty_program_withdraws_id_seq OWNED BY public.loyalty_program_withdraws.id;
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
       public          abdelelbouhy    false    217            y           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
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
       public         heap    abdelelbouhy    false    1149                       1259    16849    notifications_id_seq    SEQUENCE     �   CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public          abdelelbouhy    false    282            z           0    0    notifications_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;
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
       public          abdelelbouhy    false    266            {           0    0    organizations_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;
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
       public          abdelelbouhy    false    238            |           0    0    payMethods_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."payMethods_id_seq" OWNED BY public."payMethods".id;
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
       public          abdelelbouhy    false    342            }           0    0    payment_way_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.payment_way_id_seq OWNED BY public.payment_way.id;
          public          abdelelbouhy    false    341            `           1259    25031    per_hour_price_range    TABLE     d  CREATE TABLE public.per_hour_price_range (
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
    "customPerHourDayId" integer,
    "egyptianCurrencyId" integer,
    "foreignCurrencyId" integer,
    "foreignDiscountStartTime" timestamp without time zone,
    "foreignDiscountEndTime" timestamp without time zone,
    "egyptianBulkPrice" numeric,
    "foreignBulkPrice" numeric,
    "minimumBulk" numeric,
    "offerBy" character varying
);
 (   DROP TABLE public.per_hour_price_range;
       public         heap    abdelelbouhy    false            _           1259    25030    per_hour_price_range_id_seq    SEQUENCE     �   CREATE SEQUENCE public.per_hour_price_range_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.per_hour_price_range_id_seq;
       public          abdelelbouhy    false    352            ~           0    0    per_hour_price_range_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.per_hour_price_range_id_seq OWNED BY public.per_hour_price_range.id;
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
       public          abdelelbouhy    false    252                       0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
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
       public          abdelelbouhy    false    296            �           0    0    prices_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.prices_id_seq OWNED BY public.prices.id;
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
       public          abdelelbouhy    false    256            �           0    0    pricingPlans_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."pricingPlans_id_seq" OWNED BY public."pricingPlans".id;
          public          abdelelbouhy    false    255            n           1259    25410    provider_block_map    TABLE     �   CREATE TABLE public.provider_block_map (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer,
    provider_id integer
);
 &   DROP TABLE public.provider_block_map;
       public         heap    abdelelbouhy    false            m           1259    25409    provider_block_map_id_seq    SEQUENCE     �   CREATE SEQUENCE public.provider_block_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.provider_block_map_id_seq;
       public          abdelelbouhy    false    366            �           0    0    provider_block_map_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.provider_block_map_id_seq OWNED BY public.provider_block_map.id;
          public          abdelelbouhy    false    365            l           1259    25398    provider_contact    TABLE     g  CREATE TABLE public.provider_contact (
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
       public         heap    abdelelbouhy    false            k           1259    25397    provider_contact_id_seq    SEQUENCE     �   CREATE SEQUENCE public.provider_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.provider_contact_id_seq;
       public          abdelelbouhy    false    364            �           0    0    provider_contact_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.provider_contact_id_seq OWNED BY public.provider_contact.id;
          public          abdelelbouhy    false    363            h           1259    25228    recurrences    TABLE     '  CREATE TABLE public.recurrences (
    id integer NOT NULL,
    court_id integer,
    "endDate" timestamp with time zone,
    rule character varying,
    "startTime" timestamp with time zone,
    "endTime" timestamp with time zone,
    appointment_id integer,
    excludes character varying[]
);
    DROP TABLE public.recurrences;
       public         heap    abdelelbouhy    false            g           1259    25227    recurrences_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recurrences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.recurrences_id_seq;
       public          abdelelbouhy    false    360            �           0    0    recurrences_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.recurrences_id_seq OWNED BY public.recurrences.id;
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
       public          abdelelbouhy    false    288            �           0    0    reservationItem_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."reservationItem_id_seq" OWNED BY public."reservationItem".id;
          public          abdelelbouhy    false    287                       1259    16876    reservations    TABLE       CREATE TABLE public.reservations (
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
    "admin_fees_In_user_currency" numeric DEFAULT 0,
    "price_In_user_currency" numeric DEFAULT 0,
    rejection_reason character varying,
    get_way character varying
);
     DROP TABLE public.reservations;
       public         heap    abdelelbouhy    false    1155    1155                       1259    16875    reservations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reservations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.reservations_id_seq;
       public          abdelelbouhy    false    284            �           0    0    reservations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;
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
       public          abdelelbouhy    false    234            �           0    0    reviews_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;
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
       public          abdelelbouhy    false    286            �           0    0    roomRental_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."roomRental_id_seq" OWNED BY public."roomRental".id;
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
       public          abdelelbouhy    false    320            �           0    0    rooms_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;
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
       public          abdelelbouhy    false    292            �           0    0    scheduleItems_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."scheduleItems_id_seq" OWNED BY public."scheduleItems".id;
          public          abdelelbouhy    false    291            &           1259    16929 	   schedules    TABLE     &  CREATE TABLE public.schedules (
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
    solo boolean
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
       public          abdelelbouhy    false    294            �           0    0    schedules_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;
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
       public          abdelelbouhy    false    300            �           0    0    serviceProviders_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."serviceProviders_id_seq" OWNED BY public."serviceProviders".id;
          public          abdelelbouhy    false    299            :           1259    17053    services    TABLE     �  CREATE TABLE public.services (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
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
       public          abdelelbouhy    false    314            �           0    0    services_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;
          public          abdelelbouhy    false    313            X           1259    24771    settings    TABLE       CREATE TABLE public.settings (
    id integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    section character varying NOT NULL,
    options jsonb NOT NULL
);
    DROP TABLE public.settings;
       public         heap    abdelelbouhy    false            W           1259    24770    settings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public          abdelelbouhy    false    344            �           0    0    settings_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;
          public          abdelelbouhy    false    343            Z           1259    24809    subCity    TABLE     o   CREATE TABLE public."subCity" (
    id integer NOT NULL,
    ar character varying,
    en character varying
);
    DROP TABLE public."subCity";
       public         heap    abdelelbouhy    false            Y           1259    24808    subCity_id_seq    SEQUENCE     �   CREATE SEQUENCE public."subCity_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."subCity_id_seq";
       public          abdelelbouhy    false    346            �           0    0    subCity_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."subCity_id_seq" OWNED BY public."subCity".id;
          public          abdelelbouhy    false    345            p           1259    25420    supplierThirdPartyDetails    TABLE     �   CREATE TABLE public."supplierThirdPartyDetails" (
    id integer NOT NULL,
    "providerId" integer NOT NULL,
    credentials json
);
 /   DROP TABLE public."supplierThirdPartyDetails";
       public         heap    abdelelbouhy    false            o           1259    25419     supplierThirdPartyDetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."supplierThirdPartyDetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."supplierThirdPartyDetails_id_seq";
       public          abdelelbouhy    false    368            �           0    0     supplierThirdPartyDetails_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."supplierThirdPartyDetails_id_seq" OWNED BY public."supplierThirdPartyDetails".id;
          public          abdelelbouhy    false    367                       1259    16762    transactions    TABLE     X  CREATE TABLE public.transactions (
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
    refunded_amount numeric,
    fees_amount numeric DEFAULT 0,
    refunded_points numeric DEFAULT 0,
    refunded_from_supplier numeric DEFAULT 0,
    refunded_admin_fees numeric DEFAULT 0
);
     DROP TABLE public.transactions;
       public         heap    abdelelbouhy    false    1131                       1259    16761    transactions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.transactions_id_seq;
       public          abdelelbouhy    false    276            �           0    0    transactions_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;
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
       public          abdelelbouhy    false    272            �           0    0    tripItineraries_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."tripItineraries_id_seq" OWNED BY public."tripItineraries".id;
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
       public          abdelelbouhy    false    306            �           0    0    trips_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.trips_id_seq OWNED BY public.trips.id;
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
       public          abdelelbouhy    false    274            �           0    0    units_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;
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
       public          abdelelbouhy    false    318            �           0    0    uploadFiles_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."uploadFiles_id_seq" OWNED BY public."uploadFiles".id;
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
       public          abdelelbouhy    false    260            �           0    0    userDetails_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."userDetails_id_seq" OWNED BY public."userDetails".id;
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
       public          abdelelbouhy    false    244            �           0    0    userGroup_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."userGroup_id_seq" OWNED BY public."userGroup".id;
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
       public          abdelelbouhy    false    250            �           0    0    userPermission_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."userPermission_id_seq" OWNED BY public."userPermission".id;
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
       public          abdelelbouhy    false    258            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          abdelelbouhy    false    240            �           0    0    wallets_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallets.id;
          public          abdelelbouhy    false    239            �           2604    25439    EmployeeItemPermission id    DEFAULT     �   ALTER TABLE ONLY public."EmployeeItemPermission" ALTER COLUMN id SET DEFAULT nextval('public."EmployeeItemPermission_id_seq"'::regclass);
 J   ALTER TABLE public."EmployeeItemPermission" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    369    370    370            �           2604    17146    accommodations id    DEFAULT     v   ALTER TABLE ONLY public.accommodations ALTER COLUMN id SET DEFAULT nextval('public.accommodations_id_seq'::regclass);
 @   ALTER TABLE public.accommodations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    328    327    328            �           2604    17035    activities id    DEFAULT     n   ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);
 <   ALTER TABLE public.activities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    310    309    310            �           2604    17719    activity_log id    DEFAULT     r   ALTER TABLE ONLY public.activity_log ALTER COLUMN id SET DEFAULT nextval('public.activity_log_id_seq'::regclass);
 >   ALTER TABLE public.activity_log ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    337    338    338            �           2604    17127    addresses id    DEFAULT     l   ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);
 ;   ALTER TABLE public.addresses ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    325    326    326            �           2604    17070    amenities id    DEFAULT     l   ALTER TABLE ONLY public.amenities ALTER COLUMN id SET DEFAULT nextval('public.amenities_id_seq'::regclass);
 ;   ALTER TABLE public.amenities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    315    316    316            �           2604    17159    applicationVisits id    DEFAULT     �   ALTER TABLE ONLY public."applicationVisits" ALTER COLUMN id SET DEFAULT nextval('public."applicationVisits_id_seq"'::regclass);
 E   ALTER TABLE public."applicationVisits" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    329    330    330            T           2604    16785    applications id    DEFAULT     r   ALTER TABLE ONLY public.applications ALTER COLUMN id SET DEFAULT nextval('public.applications_id_seq'::regclass);
 >   ALTER TABLE public.applications ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    277    278    278            �           2604    24936    available_amenities id    DEFAULT     �   ALTER TABLE ONLY public.available_amenities ALTER COLUMN id SET DEFAULT nextval('public.available_amenities_id_seq'::regclass);
 E   ALTER TABLE public.available_amenities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    347    348    348                       2604    16497    banks id    DEFAULT     d   ALTER TABLE ONLY public.banks ALTER COLUMN id SET DEFAULT nextval('public.banks_id_seq'::regclass);
 7   ALTER TABLE public.banks ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    226    225    226            �           2604    25362    blocked_contact id    DEFAULT     x   ALTER TABLE ONLY public.blocked_contact ALTER COLUMN id SET DEFAULT nextval('public.blocked_contact_id_seq'::regclass);
 A   ALTER TABLE public.blocked_contact ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    362    361    362            �           2604    17107    boatActivity id    DEFAULT     v   ALTER TABLE ONLY public."boatActivity" ALTER COLUMN id SET DEFAULT nextval('public."boatActivity_id_seq"'::regclass);
 @   ALTER TABLE public."boatActivity" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    322    321    322                       2604    16474    boatEquipments id    DEFAULT     z   ALTER TABLE ONLY public."boatEquipments" ALTER COLUMN id SET DEFAULT nextval('public."boatEquipments_id_seq"'::regclass);
 B   ALTER TABLE public."boatEquipments" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    221    222    222            <           2604    16693    boatFeatures id    DEFAULT     v   ALTER TABLE ONLY public."boatFeatures" ALTER COLUMN id SET DEFAULT nextval('public."boatFeatures_id_seq"'::regclass);
 @   ALTER TABLE public."boatFeatures" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    262    261    262            ?           2604    16702    boatSafety id    DEFAULT     r   ALTER TABLE ONLY public."boatSafety" ALTER COLUMN id SET DEFAULT nextval('public."boatSafety_id_seq"'::regclass);
 >   ALTER TABLE public."boatSafety" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    264    263    264            �           2604    17114    boats id    DEFAULT     d   ALTER TABLE ONLY public.boats ALTER COLUMN id SET DEFAULT nextval('public.boats_id_seq'::regclass);
 7   ALTER TABLE public.boats ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    324    323    324                       2604    16519    branchCourse id    DEFAULT     v   ALTER TABLE ONLY public."branchCourse" ALTER COLUMN id SET DEFAULT nextval('public."branchCourse_id_seq"'::regclass);
 @   ALTER TABLE public."branchCourse" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    229    230    230            �           2604    17166    branchEquipmentRental id    DEFAULT     �   ALTER TABLE ONLY public."branchEquipmentRental" ALTER COLUMN id SET DEFAULT nextval('public."branchEquipmentRental_id_seq"'::regclass);
 I   ALTER TABLE public."branchEquipmentRental" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    332    331    332            �           2604    17047    branchService id    DEFAULT     x   ALTER TABLE ONLY public."branchService" ALTER COLUMN id SET DEFAULT nextval('public."branchService_id_seq"'::regclass);
 A   ALTER TABLE public."branchService" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    312    311    312            �           2604    17003    branchTrip id    DEFAULT     r   ALTER TABLE ONLY public."branchTrip" ALTER COLUMN id SET DEFAULT nextval('public."branchTrip_id_seq"'::regclass);
 >   ALTER TABLE public."branchTrip" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    303    304    304            �           2604    16989    branches id    DEFAULT     j   ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);
 :   ALTER TABLE public.branches ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    302    301    302                       2604    16486    categories id    DEFAULT     n   ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);
 <   ALTER TABLE public.categories ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    224    223    224            �           2604    17024 	   cities id    DEFAULT     f   ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);
 8   ALTER TABLE public.cities ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    308    307    308                       2604    16508    companies id    DEFAULT     l   ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);
 ;   ALTER TABLE public.companies ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    227    228    228            C           2604    16722    countries id    DEFAULT     l   ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);
 ;   ALTER TABLE public.countries ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    268    267    268            y           2604    16956 
   courses id    DEFAULT     h   ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);
 9   ALTER TABLE public.courses ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    298    297    298            �           2604    25056    court id    DEFAULT     d   ALTER TABLE ONLY public.court ALTER COLUMN id SET DEFAULT nextval('public.court_id_seq'::regclass);
 7   ALTER TABLE public.court ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    356    355    356            �           2604    16463    currencies id    DEFAULT     n   ALTER TABLE ONLY public.currencies ALTER COLUMN id SET DEFAULT nextval('public.currencies_id_seq'::regclass);
 <   ALTER TABLE public.currencies ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    219    220    220            �           2604    25099    custom_payment_options id    DEFAULT     �   ALTER TABLE ONLY public.custom_payment_options ALTER COLUMN id SET DEFAULT nextval('public.custom_payment_options_id_seq'::regclass);
 H   ALTER TABLE public.custom_payment_options ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    358    357    358            �           2604    25045    custom_per_hour_day id    DEFAULT     �   ALTER TABLE ONLY public.custom_per_hour_day ALTER COLUMN id SET DEFAULT nextval('public.custom_per_hour_day_id_seq'::regclass);
 E   ALTER TABLE public.custom_per_hour_day ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    353    354    354                       2604    16575 
   devices id    DEFAULT     h   ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);
 9   ALTER TABLE public.devices ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    241    242    242            F           2604    16733    equipmentRentals id    DEFAULT     ~   ALTER TABLE ONLY public."equipmentRentals" ALTER COLUMN id SET DEFAULT nextval('public."equipmentRentals_id_seq"'::regclass);
 D   ALTER TABLE public."equipmentRentals" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    270    269    270            �           2604    17175    exchanges id    DEFAULT     l   ALTER TABLE ONLY public.exchanges ALTER COLUMN id SET DEFAULT nextval('public.exchanges_id_seq'::regclass);
 ;   ALTER TABLE public.exchanges ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    333    334    334            �           2604    24947    excludes id    DEFAULT     j   ALTER TABLE ONLY public.excludes ALTER COLUMN id SET DEFAULT nextval('public.excludes_id_seq'::regclass);
 :   ALTER TABLE public.excludes ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    349    350    350                       2604    16548    favorite id    DEFAULT     j   ALTER TABLE ONLY public.favorite ALTER COLUMN id SET DEFAULT nextval('public.favorite_id_seq'::regclass);
 :   ALTER TABLE public.favorite ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    235    236    236                       2604    16600    group_permission id    DEFAULT     z   ALTER TABLE ONLY public.group_permission ALTER COLUMN id SET DEFAULT nextval('public.group_permission_id_seq'::regclass);
 B   ALTER TABLE public.group_permission ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    248    247    248                       2604    16591 	   groups id    DEFAULT     f   ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);
 8   ALTER TABLE public.groups ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    245    246    246                       2604    16528    guest id    DEFAULT     d   ALTER TABLE ONLY public.guest ALTER COLUMN id SET DEFAULT nextval('public.guest_id_seq'::regclass);
 7   ALTER TABLE public.guest ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    232    231    232            !           2604    16631    inquiries id    DEFAULT     l   ALTER TABLE ONLY public.inquiries ALTER COLUMN id SET DEFAULT nextval('public.inquiries_id_seq'::regclass);
 ;   ALTER TABLE public.inquiries ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    254    253    254            W           2604    16817    itemRequests id    DEFAULT     v   ALTER TABLE ONLY public."itemRequests" ALTER COLUMN id SET DEFAULT nextval('public."itemRequests_id_seq"'::regclass);
 @   ALTER TABLE public."itemRequests" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    279    280    280            n           2604    16914    itemTimes id    DEFAULT     p   ALTER TABLE ONLY public."itemTimes" ALTER COLUMN id SET DEFAULT nextval('public."itemTimes_id_seq"'::regclass);
 =   ALTER TABLE public."itemTimes" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    289    290    290            �           2604    17699    loyalty_program id    DEFAULT     x   ALTER TABLE ONLY public.loyalty_program ALTER COLUMN id SET DEFAULT nextval('public.loyalty_program_id_seq'::regclass);
 A   ALTER TABLE public.loyalty_program ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    335    336    336            �           2604    17730    loyalty_program_withdraws id    DEFAULT     �   ALTER TABLE ONLY public.loyalty_program_withdraws ALTER COLUMN id SET DEFAULT nextval('public.loyalty_program_withdraws_id_seq'::regclass);
 K   ALTER TABLE public.loyalty_program_withdraws ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    340    339    340            �           2604    16449    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    217    216    217            [           2604    16853    notifications id    DEFAULT     t   ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    281    282    282            B           2604    16711    organizations id    DEFAULT     t   ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);
 ?   ALTER TABLE public.organizations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    266    265    266                       2604    16557    payMethods id    DEFAULT     r   ALTER TABLE ONLY public."payMethods" ALTER COLUMN id SET DEFAULT nextval('public."payMethods_id_seq"'::regclass);
 >   ALTER TABLE public."payMethods" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    238    237    238            �           2604    17800    payment_way id    DEFAULT     p   ALTER TABLE ONLY public.payment_way ALTER COLUMN id SET DEFAULT nextval('public.payment_way_id_seq'::regclass);
 =   ALTER TABLE public.payment_way ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    341    342    342            �           2604    25034    per_hour_price_range id    DEFAULT     �   ALTER TABLE ONLY public.per_hour_price_range ALTER COLUMN id SET DEFAULT nextval('public.per_hour_price_range_id_seq'::regclass);
 F   ALTER TABLE public.per_hour_price_range ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    351    352    352                        2604    16614    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    252    251    252            v           2604    16945 	   prices id    DEFAULT     f   ALTER TABLE ONLY public.prices ALTER COLUMN id SET DEFAULT nextval('public.prices_id_seq'::regclass);
 8   ALTER TABLE public.prices ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    295    296    296            %           2604    16643    pricingPlans id    DEFAULT     v   ALTER TABLE ONLY public."pricingPlans" ALTER COLUMN id SET DEFAULT nextval('public."pricingPlans_id_seq"'::regclass);
 @   ALTER TABLE public."pricingPlans" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    256    255    256            �           2604    25413    provider_block_map id    DEFAULT     ~   ALTER TABLE ONLY public.provider_block_map ALTER COLUMN id SET DEFAULT nextval('public.provider_block_map_id_seq'::regclass);
 D   ALTER TABLE public.provider_block_map ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    366    365    366            �           2604    25401    provider_contact id    DEFAULT     z   ALTER TABLE ONLY public.provider_contact ALTER COLUMN id SET DEFAULT nextval('public.provider_contact_id_seq'::regclass);
 B   ALTER TABLE public.provider_contact ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    363    364    364            �           2604    25231    recurrences id    DEFAULT     p   ALTER TABLE ONLY public.recurrences ALTER COLUMN id SET DEFAULT nextval('public.recurrences_id_seq'::regclass);
 =   ALTER TABLE public.recurrences ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    360    359    360            k           2604    16903    reservationItem id    DEFAULT     |   ALTER TABLE ONLY public."reservationItem" ALTER COLUMN id SET DEFAULT nextval('public."reservationItem_id_seq"'::regclass);
 C   ALTER TABLE public."reservationItem" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    287    288    288            _           2604    16879    reservations id    DEFAULT     r   ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);
 >   ALTER TABLE public.reservations ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    284    283    284                       2604    16537 
   reviews id    DEFAULT     h   ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);
 9   ALTER TABLE public.reviews ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    233    234    234            i           2604    16892    roomRental id    DEFAULT     r   ALTER TABLE ONLY public."roomRental" ALTER COLUMN id SET DEFAULT nextval('public."roomRental_id_seq"'::regclass);
 >   ALTER TABLE public."roomRental" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    286    285    286            �           2604    17095    rooms id    DEFAULT     d   ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);
 7   ALTER TABLE public.rooms ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    320    319    320            p           2604    16923    scheduleItems id    DEFAULT     x   ALTER TABLE ONLY public."scheduleItems" ALTER COLUMN id SET DEFAULT nextval('public."scheduleItems_id_seq"'::regclass);
 A   ALTER TABLE public."scheduleItems" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    291    292    292            q           2604    16932    schedules id    DEFAULT     l   ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);
 ;   ALTER TABLE public.schedules ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    293    294    294            ~           2604    16969    serviceProviders id    DEFAULT     ~   ALTER TABLE ONLY public."serviceProviders" ALTER COLUMN id SET DEFAULT nextval('public."serviceProviders_id_seq"'::regclass);
 D   ALTER TABLE public."serviceProviders" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    300    299    300            �           2604    17056    services id    DEFAULT     j   ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);
 :   ALTER TABLE public.services ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    313    314    314            �           2604    24774    settings id    DEFAULT     j   ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    343    344    344            �           2604    24812 
   subCity id    DEFAULT     l   ALTER TABLE ONLY public."subCity" ALTER COLUMN id SET DEFAULT nextval('public."subCity_id_seq"'::regclass);
 ;   ALTER TABLE public."subCity" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    346    345    346            �           2604    25423    supplierThirdPartyDetails id    DEFAULT     �   ALTER TABLE ONLY public."supplierThirdPartyDetails" ALTER COLUMN id SET DEFAULT nextval('public."supplierThirdPartyDetails_id_seq"'::regclass);
 M   ALTER TABLE public."supplierThirdPartyDetails" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    367    368    368            M           2604    16765    transactions id    DEFAULT     r   ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);
 >   ALTER TABLE public.transactions ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    275    276    276            G           2604    16742    tripItineraries id    DEFAULT     |   ALTER TABLE ONLY public."tripItineraries" ALTER COLUMN id SET DEFAULT nextval('public."tripItineraries_id_seq"'::regclass);
 C   ALTER TABLE public."tripItineraries" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    272    271    272            �           2604    17012    trips id    DEFAULT     d   ALTER TABLE ONLY public.trips ALTER COLUMN id SET DEFAULT nextval('public.trips_id_seq'::regclass);
 7   ALTER TABLE public.trips ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    306    305    306            J           2604    16751    units id    DEFAULT     d   ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);
 7   ALTER TABLE public.units ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    274    273    274            �           2604    17079    uploadFiles id    DEFAULT     t   ALTER TABLE ONLY public."uploadFiles" ALTER COLUMN id SET DEFAULT nextval('public."uploadFiles_id_seq"'::regclass);
 ?   ALTER TABLE public."uploadFiles" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    317    318    318            9           2604    16680    userDetails id    DEFAULT     t   ALTER TABLE ONLY public."userDetails" ALTER COLUMN id SET DEFAULT nextval('public."userDetails_id_seq"'::regclass);
 ?   ALTER TABLE public."userDetails" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    259    260    260                       2604    16584    userGroup id    DEFAULT     p   ALTER TABLE ONLY public."userGroup" ALTER COLUMN id SET DEFAULT nextval('public."userGroup_id_seq"'::regclass);
 =   ALTER TABLE public."userGroup" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    244    243    244                       2604    16607    userPermission id    DEFAULT     z   ALTER TABLE ONLY public."userPermission" ALTER COLUMN id SET DEFAULT nextval('public."userPermission_id_seq"'::regclass);
 B   ALTER TABLE public."userPermission" ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    250    249    250            '           2604    16653    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    258    257    258                       2604    16566 
   wallets id    DEFAULT     h   ALTER TABLE ONLY public.wallets ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);
 9   ALTER TABLE public.wallets ALTER COLUMN id DROP DEFAULT;
       public          abdelelbouhy    false    240    239    240            E          0    25436    EmployeeItemPermission 
   TABLE DATA           r   COPY public."EmployeeItemPermission" (id, created_at, updated_at, "employeeId", "itemType", "itemId") FROM stdin;
    public          abdelelbouhy    false    370   �                0    17143    accommodations 
   TABLE DATA           �   COPY public.accommodations (id, created_at, updated_at, cancellation_policy, checkin, checkout, description, no_of_beds, no_of_guest, spaces_available, title, type, address_id, user_id, trip_id) FROM stdin;
    public          abdelelbouhy    false    328   )�      	          0    17032 
   activities 
   TABLE DATA           �   COPY public.activities (id, created_at, updated_at, trending_score, name, image, category_id, boat_id, "cityId", city_id, splits) FROM stdin;
    public          abdelelbouhy    false    310   F�      %          0    17716    activity_log 
   TABLE DATA           f   COPY public.activity_log (id, created_at, updated_at, user_id, key, old_value, new_value) FROM stdin;
    public          abdelelbouhy    false    338   l�                0    17124 	   addresses 
   TABLE DATA           �   COPY public.addresses (id, created_at, updated_at, number, street, city, postcode, district, lat, lng, "timeZone", service_id, course_id, company_id, country_id, boat_id, place_id) FROM stdin;
    public          abdelelbouhy    false    326   ��                0    17067 	   amenities 
   TABLE DATA           j   COPY public.amenities (id, created_at, updated_at, name, accommodation_id, service_id, image) FROM stdin;
    public          abdelelbouhy    false    316   V                0    17156    applicationVisits 
   TABLE DATA           >   COPY public."applicationVisits" (id, day, visits) FROM stdin;
    public          abdelelbouhy    false    330   �      �          0    16782    applications 
   TABLE DATA           c   COPY public.applications (id, created_at, updated_at, user_id, status, "assignedUser") FROM stdin;
    public          abdelelbouhy    false    278   !      /          0    24933    available_amenities 
   TABLE DATA           V   COPY public.available_amenities (id, created_at, updated_at, name, image) FROM stdin;
    public          abdelelbouhy    false    348   �&      �          0    16494    banks 
   TABLE DATA             COPY public.banks (id, created_at, updated_at, user_id, currency_id, card_holder_name, account_number, iban_number, swift_code, branch_number, branch_name, full_name, email_address, phone_number, mobile_number, refund_policy, account_nationality, status) FROM stdin;
    public          abdelelbouhy    false    226   $(      =          0    25359    blocked_contact 
   TABLE DATA           o   COPY public.blocked_contact (id, created_at, updated_at, name, phone_number, user_id, provider_id) FROM stdin;
    public          abdelelbouhy    false    362   nD                0    17104    boatActivity 
   TABLE DATA           B   COPY public."boatActivity" (id, boat_id, activity_id) FROM stdin;
    public          abdelelbouhy    false    322   �D      �          0    16471    boatEquipments 
   TABLE DATA           �   COPY public."boatEquipments" (id, boat_id, title, description, per_day_price, currency_id, no_of_equipments, deleted, created_at, updated_at, foreigner_per_day_price, foreigner_currency_id) FROM stdin;
    public          abdelelbouhy    false    222   E      �          0    16690    boatFeatures 
   TABLE DATA           Y   COPY public."boatFeatures" (id, created_at, updated_at, name, sea_safari_id) FROM stdin;
    public          abdelelbouhy    false    262   G      �          0    16699 
   boatSafety 
   TABLE DATA           W   COPY public."boatSafety" (id, created_at, updated_at, type, sea_safari_id) FROM stdin;
    public          abdelelbouhy    false    264   %G                0    17111    boats 
   TABLE DATA           
  COPY public.boats (id, user_id, title, description, "isFavorite", city_id, provider_id, length, width, no_of_cabins, no_of_engines, number_of_guests, fresh_water_maker, top_speed, features, navigation_and_safety, status, pending, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    324   BG      �          0    16516    branchCourse 
   TABLE DATA           c   COPY public."branchCourse" (id, created_at, updated_at, course_id, branch_id, city_id) FROM stdin;
    public          abdelelbouhy    false    230   �T                0    17163    branchEquipmentRental 
   TABLE DATA           m   COPY public."branchEquipmentRental" (id, created_at, updated_at, equipment_rental_id, branch_id) FROM stdin;
    public          abdelelbouhy    false    332   �X                0    17044    branchService 
   TABLE DATA           e   COPY public."branchService" (id, created_at, updated_at, service_id, branch_id, city_id) FROM stdin;
    public          abdelelbouhy    false    312   �X                0    17000 
   branchTrip 
   TABLE DATA           V   COPY public."branchTrip" (id, created_at, updated_at, trip_id, branch_id) FROM stdin;
    public          abdelelbouhy    false    304   �h                0    16986    branches 
   TABLE DATA           �   COPY public.branches (id, created_at, updated_at, name, user_id, is_active, address_id, city_id, status, sub_city_id) FROM stdin;
    public          abdelelbouhy    false    302   �h      �          0    16483 
   categories 
   TABLE DATA           M   COPY public.categories (id, created_at, updated_at, name, image) FROM stdin;
    public          abdelelbouhy    false    224   Mw                0    17021    cities 
   TABLE DATA           �   COPY public.cities (id, created_at, updated_at, city_name, governorate_name, photo, city_code, lat, lng, "isFavorite", place_id) FROM stdin;
    public          abdelelbouhy    false    308   x      �          0    16505 	   companies 
   TABLE DATA           �   COPY public.companies (id, created_at, updated_at, address_id, name, logo, trade_license_no, tax_license_no, certificate, contact_email, contact_phone, contact_details, license_no) FROM stdin;
    public          abdelelbouhy    false    228   �~      �          0    16719 	   countries 
   TABLE DATA           V   COPY public.countries (id, created_at, updated_at, name, code, dial_code) FROM stdin;
    public          abdelelbouhy    false    268   i�      �          0    16953    courses 
   TABLE DATA           �   COPY public.courses (id, created_at, updated_at, title, description, user_id, provider_id, category_id, activity_id, "cityId", languages, prerequisites, organization, "isFavorite", status, pending, city_id) FROM stdin;
    public          abdelelbouhy    false    298   ��      7          0    25053    court 
   TABLE DATA           _   COPY public.court (id, created_at, updated_at, name, "scheduleId", solo, space_id) FROM stdin;
    public          abdelelbouhy    false    356   ��      �          0    16460 
   currencies 
   TABLE DATA           R   COPY public.currencies (id, created_at, updated_at, name, code, logo) FROM stdin;
    public          abdelelbouhy    false    220   V�      9          0    25096    custom_payment_options 
   TABLE DATA           f   COPY public.custom_payment_options (id, created_at, updated_at, name, item_type, item_id) FROM stdin;
    public          abdelelbouhy    false    358   �      5          0    25042    custom_per_hour_day 
   TABLE DATA           �   COPY public.custom_per_hour_day (id, name, "startTime", "endTime", "courtId", "createdAt", "updatedAt", availability) FROM stdin;
    public          abdelelbouhy    false    354   L�      �          0    16572    devices 
   TABLE DATA           @   COPY public.devices (id, user_id, device_id, token) FROM stdin;
    public          abdelelbouhy    false    242   ��      �          0    16730    equipmentRentals 
   TABLE DATA           M   COPY public."equipmentRentals" (id, item_id, equipment_id, name) FROM stdin;
    public          abdelelbouhy    false    270   =      !          0    17172 	   exchanges 
   TABLE DATA           O   COPY public.exchanges (id, updated_at, "firstC", "secondC", ratio) FROM stdin;
    public          abdelelbouhy    false    334   6=      1          0    24944    excludes 
   TABLE DATA           X   COPY public.excludes (id, created_at, updated_at, name, item_type, item_id) FROM stdin;
    public          abdelelbouhy    false    350   �=      �          0    16545    favorite 
   TABLE DATA           p   COPY public.favorite (id, user_id, course_id, boat_id, service_id, city_id, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    236   �A      �          0    16597    group_permission 
   TABLE DATA           I   COPY public.group_permission (id, "group_Id", permission_id) FROM stdin;
    public          abdelelbouhy    false    248   	C      �          0    16588    groups 
   TABLE DATA           =   COPY public.groups (id, color, name, company_id) FROM stdin;
    public          abdelelbouhy    false    246   �C      �          0    16525    guest 
   TABLE DATA           R   COPY public.guest (id, title, first_name, last_name, "reservationId") FROM stdin;
    public          abdelelbouhy    false    232   $D      �          0    16628 	   inquiries 
   TABLE DATA           �   COPY public.inquiries (id, created_at, updated_at, type, subject, message, user_id, "assignedGroupId", status, resolution) FROM stdin;
    public          abdelelbouhy    false    254   AD      �          0    16814    itemRequests 
   TABLE DATA           ~   COPY public."itemRequests" (id, created_at, updated_at, item_id, user_id, item_type, status, type, assigned_user) FROM stdin;
    public          abdelelbouhy    false    280   �E      �          0    16911 	   itemTimes 
   TABLE DATA           �   COPY public."itemTimes" (id, item_id, "startTime", "endTime", reservation_item_id, external_reserve, imported_reserve, appointment_id) FROM stdin;
    public          abdelelbouhy    false    290   ��      #          0    17696    loyalty_program 
   TABLE DATA           �   COPY public.loyalty_program (id, created_at, updated_at, points, user_id, parent_user_id, reservation_id, parent_user_type, withdrawn, redeemed) FROM stdin;
    public          abdelelbouhy    false    336   $�      '          0    17727    loyalty_program_withdraws 
   TABLE DATA           p   COPY public.loyalty_program_withdraws (id, created_at, updated_at, points, user_id, reservation_id) FROM stdin;
    public          abdelelbouhy    false    340   �      �          0    16446 
   migrations 
   TABLE DATA           ;   COPY public.migrations (id, "timestamp", name) FROM stdin;
    public          abdelelbouhy    false    217   4�      �          0    16850    notifications 
   TABLE DATA           �   COPY public.notifications (id, user_id, message, reservation_id, review_id, request_id, "itemType", "itemId", type, "toAllUsers", "toAllProviders", "toAllAdmins", created_at, "Seen", cleared, redirect) FROM stdin;
    public          abdelelbouhy    false    282   ��      �          0    16708    organizations 
   TABLE DATA           D   COPY public.organizations (id, course_id, name, status) FROM stdin;
    public          abdelelbouhy    false    266   k      �          0    16554 
   payMethods 
   TABLE DATA           �   COPY public."payMethods" (id, wallet_id, user_id, save_order_id, "save_order_Token", token, masked_pan, merchant_id, card_subtype, created_at, email, user_added, nationality, get_way) FROM stdin;
    public          abdelelbouhy    false    238   �l      )          0    17797    payment_way 
   TABLE DATA           a   COPY public.payment_way (id, name, type, image, availability, "getWay", nationality) FROM stdin;
    public          abdelelbouhy    false    342   �      3          0    25031    per_hour_price_range 
   TABLE DATA           �  COPY public.per_hour_price_range (id, "createdAt", "updatedAt", "startTime", "endTime", "egyptianPrice", "foreignPrice", "egyptianDiscountPrice", "foreignDiscountPrice", "egyptianDiscountStartTime", "egyptianDiscountEndTime", "customPerHourDayId", "egyptianCurrencyId", "foreignCurrencyId", "foreignDiscountStartTime", "foreignDiscountEndTime", "egyptianBulkPrice", "foreignBulkPrice", "minimumBulk", "offerBy") FROM stdin;
    public          abdelelbouhy    false    352   �      �          0    16611    permissions 
   TABLE DATA           @   COPY public.permissions (id, name, admin, supplier) FROM stdin;
    public          abdelelbouhy    false    252   /�      �          0    16942    prices 
   TABLE DATA           �   COPY public.prices (id, created_at, updated_at, type, price, discount_price, discount_start, discount_end, currency_id, accommodation_id, course_id, equipment_rental_id, unit_id, service_id, trip_id, room_id, schedule_id) FROM stdin;
    public          abdelelbouhy    false    296   ά      �          0    16640    pricingPlans 
   TABLE DATA           W   COPY public."pricingPlans" (id, name, plan_features, price, limited_offer) FROM stdin;
    public          abdelelbouhy    false    256   ��      A          0    25410    provider_block_map 
   TABLE DATA           ^   COPY public.provider_block_map (id, created_at, updated_at, user_id, provider_id) FROM stdin;
    public          abdelelbouhy    false    366   �      ?          0    25398    provider_contact 
   TABLE DATA           y   COPY public.provider_contact (id, created_at, updated_at, name, phone_number, user_id, provider_id, blocked) FROM stdin;
    public          abdelelbouhy    false    364   ;�      ;          0    25228    recurrences 
   TABLE DATA           v   COPY public.recurrences (id, court_id, "endDate", rule, "startTime", "endTime", appointment_id, excludes) FROM stdin;
    public          abdelelbouhy    false    360   ��      �          0    16900    reservationItem 
   TABLE DATA           �   COPY public."reservationItem" (id, type, reservation_date, quantity, price, discount_value, discounted, "reservationId", original_discount_start, original_discount_end) FROM stdin;
    public          abdelelbouhy    false    288   )�      �          0    16876    reservations 
   TABLE DATA           ?  COPY public.reservations (id, order_id, payment_success, reservation_date, status, type, activity_type, category_type, branch_name, "currencyId", price, discount_value, price_type, discounted, number_of_people, user_id, provider_id, trip_id, schedule_id, first_name, last_name, contact_email, contact_number, payment_method, reserved_currency_id, created_at, updated_at, "usedPoints", "actualTotalAmount", original_discount_start, original_discount_end, admin_fees, admin_total, "admin_fees_In_user_currency", "price_In_user_currency", rejection_reason, get_way) FROM stdin;
    public          abdelelbouhy    false    284   �      �          0    16534    reviews 
   TABLE DATA           �   COPY public.reviews (id, created_at, updated_at, review, title, rate, service_id, course_id, boat_id, user_id, reply_on_id) FROM stdin;
    public          abdelelbouhy    false    234   3�      �          0    16889 
   roomRental 
   TABLE DATA           |   COPY public."roomRental" (id, item_id, room_id, "noOfPeople", room_price, trip_id, room_name, external_reserve) FROM stdin;
    public          abdelelbouhy    false    286   N�                0    17092    rooms 
   TABLE DATA           ~   COPY public.rooms (id, boat_id, type, description, no_of_guests, rooms_on_board, deleted, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    320   ��      �          0    16920    scheduleItems 
   TABLE DATA           Q   COPY public."scheduleItems" (id, name, number, "order", schedule_id) FROM stdin;
    public          abdelelbouhy    false    292   ��      �          0    16929 	   schedules 
   TABLE DATA           �  COPY public.schedules (id, created_at, updated_at, start_date, end_date, "isSchedule", name, course_id, service_id, trip_id, user_id, service_unit, description, duration, "numberOfSessions", "unlimitedSessions", "timeFrame", "timeFrameDescription", "minBookTime", "numberOfEquipments", "perHourBranch", "scheduleStartTime", "scheduleEndTime", status, pending, split, solo) FROM stdin;
    public          abdelelbouhy    false    294   �      �          0    16966    serviceProviders 
   TABLE DATA           �   COPY public."serviceProviders" (id, name, created_at, updated_at, user_id, approved, "pricingPlan", video, company_id, bank_id, "padelFinderName") FROM stdin;
    public          abdelelbouhy    false    300   _                0    17053    services 
   TABLE DATA           �   COPY public.services (id, title, "isService", description, rate, "isFavorite", "perHourService", "cityId", provider_id, category_id, activity_id, address_id, user_id, status, pending, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    314   !      +          0    24771    settings 
   TABLE DATA           R   COPY public.settings (id, "createdAt", "updatedAt", section, options) FROM stdin;
    public          abdelelbouhy    false    344   �\      -          0    24809    subCity 
   TABLE DATA           /   COPY public."subCity" (id, ar, en) FROM stdin;
    public          abdelelbouhy    false    346   �\      C          0    25420    supplierThirdPartyDetails 
   TABLE DATA           T   COPY public."supplierThirdPartyDetails" (id, "providerId", credentials) FROM stdin;
    public          abdelelbouhy    false    368   l      �          0    16762    transactions 
   TABLE DATA           �   COPY public.transactions (id, created_at, updated_at, transaction_id, order_id, reservation_id, provider_id, amount, currency_id, status, refunded_amount, fees_amount, refunded_points, refunded_from_supplier, refunded_admin_fees) FROM stdin;
    public          abdelelbouhy    false    276   �      �          0    16739    tripItineraries 
   TABLE DATA           b   COPY public."tripItineraries" (id, trip_id, day, description, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    272   �                0    17009    trips 
   TABLE DATA           �   COPY public.trips (id, boat_id, sea_safari_id, title, description, minimum_price, currency_id, no_of_days, no_of_nights, departure_date, arrival_date, "cityId", status, pending, created_at, updated_at) FROM stdin;
    public          abdelelbouhy    false    306   e�      �          0    16454    typeorm_metadata 
   TABLE DATA           X   COPY public.typeorm_metadata (type, database, schema, "table", name, value) FROM stdin;
    public          abdelelbouhy    false    218   a�      �          0    16748    units 
   TABLE DATA           A   COPY public.units (id, created_at, updated_at, type) FROM stdin;
    public          abdelelbouhy    false    274   ~�                0    17076    uploadFiles 
   TABLE DATA             COPY public."uploadFiles" (id, pending, file_path, created_at, updated_at, file_name, azure_blob_name, company_id, accommodation_id, equipment_rental_id, course_id, service_id, trip_id, organization_id, user_id, inquiry_id, sea_safari_id, boat_id, room_id, "position") FROM stdin;
    public          abdelelbouhy    false    318         �          0    16677    userDetails 
   TABLE DATA           �   COPY public."userDetails" (id, created_at, updated_at, user_id, date_of_birth, gender, photo, emergency_number, first_name, last_name) FROM stdin;
    public          abdelelbouhy    false    260   r      �          0    16581 	   userGroup 
   TABLE DATA           <   COPY public."userGroup" (id, user_id, group_id) FROM stdin;
    public          abdelelbouhy    false    244   ,�      �          0    16604    userPermission 
   TABLE DATA           R   COPY public."userPermission" (id, permission_id, "group_Id", user_id) FROM stdin;
    public          abdelelbouhy    false    250   q�      �          0    16650    users 
   TABLE DATA           �  COPY public.users (id, created_at, updated_at, login_type, last_login, timezone, name, status, type, email, language, password, mobile_number, nationality, interests, is_mobile_number_verified, is_email_verified, email_attributes, password_attributes, logged_in, plan_id, sub_order_id, city_id, "lastSubDate", referral_code, parent_referral_code, loyalty_points, subscripted, registration_completed, geo_area, social_user_id, phone_attributes, company_id) FROM stdin;
    public          abdelelbouhy    false    258   ��      �          0    16563    wallets 
   TABLE DATA           N   COPY public.wallets (id, points, currency_id, user_id, stripe_id) FROM stdin;
    public          abdelelbouhy    false    240   �      �           0    0    EmployeeItemPermission_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."EmployeeItemPermission_id_seq"', 1, false);
          public          abdelelbouhy    false    369            �           0    0    accommodations_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.accommodations_id_seq', 1, false);
          public          abdelelbouhy    false    327            �           0    0    activities_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.activities_id_seq', 107, true);
          public          abdelelbouhy    false    309            �           0    0    activity_log_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.activity_log_id_seq', 1, false);
          public          abdelelbouhy    false    337            �           0    0    addresses_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.addresses_id_seq', 463, true);
          public          abdelelbouhy    false    325            �           0    0    amenities_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.amenities_id_seq', 725, true);
          public          abdelelbouhy    false    315            �           0    0    applicationVisits_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."applicationVisits_id_seq"', 201, true);
          public          abdelelbouhy    false    329            �           0    0    applications_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.applications_id_seq', 59, true);
          public          abdelelbouhy    false    277            �           0    0    available_amenities_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.available_amenities_id_seq', 16, true);
          public          abdelelbouhy    false    347            �           0    0    banks_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.banks_id_seq', 74, true);
          public          abdelelbouhy    false    225            �           0    0    blocked_contact_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.blocked_contact_id_seq', 1, false);
          public          abdelelbouhy    false    361            �           0    0    boatActivity_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."boatActivity_id_seq"', 66, true);
          public          abdelelbouhy    false    321            �           0    0    boatEquipments_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."boatEquipments_id_seq"', 15, true);
          public          abdelelbouhy    false    221            �           0    0    boatFeatures_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."boatFeatures_id_seq"', 1, false);
          public          abdelelbouhy    false    261            �           0    0    boatSafety_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."boatSafety_id_seq"', 1, false);
          public          abdelelbouhy    false    263            �           0    0    boats_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.boats_id_seq', 23, true);
          public          abdelelbouhy    false    323            �           0    0    branchCourse_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."branchCourse_id_seq"', 93, true);
          public          abdelelbouhy    false    229            �           0    0    branchEquipmentRental_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."branchEquipmentRental_id_seq"', 1, false);
          public          abdelelbouhy    false    331            �           0    0    branchService_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."branchService_id_seq"', 637, true);
          public          abdelelbouhy    false    311            �           0    0    branchTrip_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."branchTrip_id_seq"', 1, false);
          public          abdelelbouhy    false    303            �           0    0    branches_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.branches_id_seq', 126, true);
          public          abdelelbouhy    false    301            �           0    0    categories_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.categories_id_seq', 4, true);
          public          abdelelbouhy    false    223            �           0    0    cities_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.cities_id_seq', 39, true);
          public          abdelelbouhy    false    307            �           0    0    companies_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.companies_id_seq', 69, true);
          public          abdelelbouhy    false    227            �           0    0    countries_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.countries_id_seq', 242, true);
          public          abdelelbouhy    false    267            �           0    0    courses_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.courses_id_seq', 47, true);
          public          abdelelbouhy    false    297            �           0    0    court_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.court_id_seq', 102, true);
          public          abdelelbouhy    false    355            �           0    0    currencies_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.currencies_id_seq', 1, false);
          public          abdelelbouhy    false    219            �           0    0    custom_payment_options_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.custom_payment_options_id_seq', 231, true);
          public          abdelelbouhy    false    357            �           0    0    custom_per_hour_day_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.custom_per_hour_day_id_seq', 1653, true);
          public          abdelelbouhy    false    353            �           0    0    devices_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.devices_id_seq', 414, true);
          public          abdelelbouhy    false    241            �           0    0    equipmentRentals_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."equipmentRentals_id_seq"', 5, true);
          public          abdelelbouhy    false    269            �           0    0    exchanges_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.exchanges_id_seq', 9, true);
          public          abdelelbouhy    false    333            �           0    0    excludes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.excludes_id_seq', 178, true);
          public          abdelelbouhy    false    349            �           0    0    favorite_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.favorite_id_seq', 41, true);
          public          abdelelbouhy    false    235            �           0    0    group_permission_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.group_permission_id_seq', 228, true);
          public          abdelelbouhy    false    247            �           0    0    groups_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.groups_id_seq', 8, true);
          public          abdelelbouhy    false    245            �           0    0    guest_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.guest_id_seq', 12, true);
          public          abdelelbouhy    false    231            �           0    0    inquiries_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.inquiries_id_seq', 4, true);
          public          abdelelbouhy    false    253            �           0    0    itemRequests_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."itemRequests_id_seq"', 860, true);
          public          abdelelbouhy    false    279            �           0    0    itemTimes_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."itemTimes_id_seq"', 4941294, true);
          public          abdelelbouhy    false    289            �           0    0    loyalty_program_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.loyalty_program_id_seq', 57, true);
          public          abdelelbouhy    false    335            �           0    0     loyalty_program_withdraws_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.loyalty_program_withdraws_id_seq', 38, true);
          public          abdelelbouhy    false    339            �           0    0    migrations_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.migrations_id_seq', 16, true);
          public          abdelelbouhy    false    216            �           0    0    notifications_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.notifications_id_seq', 2615, true);
          public          abdelelbouhy    false    281            �           0    0    organizations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.organizations_id_seq', 43, true);
          public          abdelelbouhy    false    265            �           0    0    payMethods_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."payMethods_id_seq"', 106, true);
          public          abdelelbouhy    false    237            �           0    0    payment_way_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.payment_way_id_seq', 7, true);
          public          abdelelbouhy    false    341            �           0    0    per_hour_price_range_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.per_hour_price_range_id_seq', 2059, true);
          public          abdelelbouhy    false    351            �           0    0    permissions_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.permissions_id_seq', 1, false);
          public          abdelelbouhy    false    251            �           0    0    prices_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.prices_id_seq', 576, true);
          public          abdelelbouhy    false    295            �           0    0    pricingPlans_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."pricingPlans_id_seq"', 2, true);
          public          abdelelbouhy    false    255            �           0    0    provider_block_map_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.provider_block_map_id_seq', 1, false);
          public          abdelelbouhy    false    365            �           0    0    provider_contact_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.provider_contact_id_seq', 2, true);
          public          abdelelbouhy    false    363            �           0    0    recurrences_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.recurrences_id_seq', 143868, true);
          public          abdelelbouhy    false    359            �           0    0    reservationItem_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."reservationItem_id_seq"', 602, true);
          public          abdelelbouhy    false    287            �           0    0    reservations_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.reservations_id_seq', 1134, true);
          public          abdelelbouhy    false    283            �           0    0    reviews_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.reviews_id_seq', 9, true);
          public          abdelelbouhy    false    233            �           0    0    roomRental_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."roomRental_id_seq"', 12, true);
          public          abdelelbouhy    false    285            �           0    0    rooms_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.rooms_id_seq', 28, true);
          public          abdelelbouhy    false    319            �           0    0    scheduleItems_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."scheduleItems_id_seq"', 214, true);
          public          abdelelbouhy    false    291            �           0    0    schedules_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.schedules_id_seq', 299, true);
          public          abdelelbouhy    false    293            �           0    0    serviceProviders_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."serviceProviders_id_seq"', 77, true);
          public          abdelelbouhy    false    299            �           0    0    services_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.services_id_seq', 212, true);
          public          abdelelbouhy    false    313            �           0    0    settings_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.settings_id_seq', 1, true);
          public          abdelelbouhy    false    343            �           0    0    subCity_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."subCity_id_seq"', 593, true);
          public          abdelelbouhy    false    345            �           0    0     supplierThirdPartyDetails_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."supplierThirdPartyDetails_id_seq"', 1, false);
          public          abdelelbouhy    false    367            �           0    0    transactions_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.transactions_id_seq', 456, true);
          public          abdelelbouhy    false    275            �           0    0    tripItineraries_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."tripItineraries_id_seq"', 94, true);
          public          abdelelbouhy    false    271            �           0    0    trips_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.trips_id_seq', 22, true);
          public          abdelelbouhy    false    305            �           0    0    units_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.units_id_seq', 1, true);
          public          abdelelbouhy    false    273            �           0    0    uploadFiles_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."uploadFiles_id_seq"', 2294, true);
          public          abdelelbouhy    false    317            �           0    0    userDetails_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."userDetails_id_seq"', 139, true);
          public          abdelelbouhy    false    259            �           0    0    userGroup_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."userGroup_id_seq"', 41, true);
          public          abdelelbouhy    false    243            �           0    0    userPermission_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."userPermission_id_seq"', 671, true);
          public          abdelelbouhy    false    249            �           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 235, true);
          public          abdelelbouhy    false    257            �           0    0    wallets_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.wallets_id_seq', 112, true);
          public          abdelelbouhy    false    239            u           2606    17102 $   rooms PK_0368a2d7c215f2d0458a54933f2 
   CONSTRAINT     d   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT "PK_0368a2d7c215f2d0458a54933f2" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.rooms DROP CONSTRAINT "PK_0368a2d7c215f2d0458a54933f2";
       public            abdelelbouhy    false    320            �           2606    24780 '   settings PK_0669fe20e252eb692bf4d344975 
   CONSTRAINT     g   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT "PK_0669fe20e252eb692bf4d344975" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.settings DROP CONSTRAINT "PK_0669fe20e252eb692bf4d344975";
       public            abdelelbouhy    false    344            �           2606    17725 +   activity_log PK_067d761e2956b77b14e534fd6f1 
   CONSTRAINT     k   ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT "PK_067d761e2956b77b14e534fd6f1" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.activity_log DROP CONSTRAINT "PK_067d761e2956b77b14e534fd6f1";
       public            abdelelbouhy    false    338            �           2606    25445 5   EmployeeItemPermission PK_0c38c7b4225433a0e41df0adc8b 
   CONSTRAINT     w   ALTER TABLE ONLY public."EmployeeItemPermission"
    ADD CONSTRAINT "PK_0c38c7b4225433a0e41df0adc8b" PRIMARY KEY (id);
 c   ALTER TABLE ONLY public."EmployeeItemPermission" DROP CONSTRAINT "PK_0c38c7b4225433a0e41df0adc8b";
       public            abdelelbouhy    false    370                       2606    16602 /   group_permission PK_12f86c54cc64469ecdb10edc29d 
   CONSTRAINT     o   ALTER TABLE ONLY public.group_permission
    ADD CONSTRAINT "PK_12f86c54cc64469ecdb10edc29d" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public.group_permission DROP CONSTRAINT "PK_12f86c54cc64469ecdb10edc29d";
       public            abdelelbouhy    false    248            �           2606    17180 (   exchanges PK_17ccd29473f939c68de98c2cea3 
   CONSTRAINT     h   ALTER TABLE ONLY public.exchanges
    ADD CONSTRAINT "PK_17ccd29473f939c68de98c2cea3" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.exchanges DROP CONSTRAINT "PK_17ccd29473f939c68de98c2cea3";
       public            abdelelbouhy    false    334            0           2606    16746 .   tripItineraries PK_18935091aded1e2fc59994a6e0d 
   CONSTRAINT     p   ALTER TABLE ONLY public."tripItineraries"
    ADD CONSTRAINT "PK_18935091aded1e2fc59994a6e0d" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."tripItineraries" DROP CONSTRAINT "PK_18935091aded1e2fc59994a6e0d";
       public            abdelelbouhy    false    272            �           2606    24942 2   available_amenities PK_22662ee1fc9742cd7c053f303e8 
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
       public            abdelelbouhy    false    224            q           2606    17086 *   uploadFiles PK_2877095f73684d7a395ec3b6c2b 
   CONSTRAINT     l   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "PK_2877095f73684d7a395ec3b6c2b" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "PK_2877095f73684d7a395ec3b6c2b";
       public            abdelelbouhy    false    318            Q           2606    16951 %   prices PK_2e40b9e4e631a53cd514d82ccd2 
   CONSTRAINT     e   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "PK_2e40b9e4e631a53cd514d82ccd2" PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "PK_2e40b9e4e631a53cd514d82ccd2";
       public            abdelelbouhy    false    296                       2606    16686 *   userDetails PK_35f9ec44d0772d64d68f5417c6b 
   CONSTRAINT     l   ALTER TABLE ONLY public."userDetails"
    ADD CONSTRAINT "PK_35f9ec44d0772d64d68f5417c6b" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."userDetails" DROP CONSTRAINT "PK_35f9ec44d0772d64d68f5417c6b";
       public            abdelelbouhy    false    260            �           2606    16503 $   banks PK_3975b5f684ec241e3901db62d77 
   CONSTRAINT     d   ALTER TABLE ONLY public.banks
    ADD CONSTRAINT "PK_3975b5f684ec241e3901db62d77" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.banks DROP CONSTRAINT "PK_3975b5f684ec241e3901db62d77";
       public            abdelelbouhy    false    226            w           2606    17109 +   boatActivity PK_3bb7ba518026dcb6c863f022a3c 
   CONSTRAINT     m   ALTER TABLE ONLY public."boatActivity"
    ADD CONSTRAINT "PK_3bb7ba518026dcb6c863f022a3c" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."boatActivity" DROP CONSTRAINT "PK_3bb7ba518026dcb6c863f022a3c";
       public            abdelelbouhy    false    322            S           2606    16964 &   courses PK_3f70a487cc718ad8eda4e6d58c9 
   CONSTRAINT     f   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "PK_3f70a487cc718ad8eda4e6d58c9" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "PK_3f70a487cc718ad8eda4e6d58c9";
       public            abdelelbouhy    false    298            c           2606    17007 )   branchTrip PK_417d7fa3722c1177e4f7d0f08bb 
   CONSTRAINT     k   ALTER TABLE ONLY public."branchTrip"
    ADD CONSTRAINT "PK_417d7fa3722c1177e4f7d0f08bb" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."branchTrip" DROP CONSTRAINT "PK_417d7fa3722c1177e4f7d0f08bb";
       public            abdelelbouhy    false    304            g           2606    17030 %   cities PK_4762ffb6e5d198cfec5606bc11e 
   CONSTRAINT     e   ALTER TABLE ONLY public.cities
    ADD CONSTRAINT "PK_4762ffb6e5d198cfec5606bc11e" PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.cities DROP CONSTRAINT "PK_4762ffb6e5d198cfec5606bc11e";
       public            abdelelbouhy    false    308            �           2606    16523 +   branchCourse PK_478ec097bfef059e81fd64d2fe7 
   CONSTRAINT     m   ALTER TABLE ONLY public."branchCourse"
    ADD CONSTRAINT "PK_478ec097bfef059e81fd64d2fe7" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."branchCourse" DROP CONSTRAINT "PK_478ec097bfef059e81fd64d2fe7";
       public            abdelelbouhy    false    230                        2606    16552 '   favorite PK_495675cec4fb09666704e4f610f 
   CONSTRAINT     g   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "PK_495675cec4fb09666704e4f610f" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "PK_495675cec4fb09666704e4f610f";
       public            abdelelbouhy    false    236            k           2606    17051 ,   branchService PK_4e3ea6a8b0fe337338347c3394a 
   CONSTRAINT     n   ALTER TABLE ONLY public."branchService"
    ADD CONSTRAINT "PK_4e3ea6a8b0fe337338347c3394a" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."branchService" DROP CONSTRAINT "PK_4e3ea6a8b0fe337338347c3394a";
       public            abdelelbouhy    false    312            �           2606    24816 &   subCity PK_4e7c3472570f7884f7bee322c3e 
   CONSTRAINT     h   ALTER TABLE ONLY public."subCity"
    ADD CONSTRAINT "PK_4e7c3472570f7884f7bee322c3e" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."subCity" DROP CONSTRAINT "PK_4e7c3472570f7884f7bee322c3e";
       public            abdelelbouhy    false    346                       2606    16648 +   pricingPlans PK_5486d72595055dee6d763f1882b 
   CONSTRAINT     m   ALTER TABLE ONLY public."pricingPlans"
    ADD CONSTRAINT "PK_5486d72595055dee6d763f1882b" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."pricingPlans" DROP CONSTRAINT "PK_5486d72595055dee6d763f1882b";
       public            abdelelbouhy    false    256            �           2606    16532 $   guest PK_57689d19445de01737dbc458857 
   CONSTRAINT     d   ALTER TABLE ONLY public.guest
    ADD CONSTRAINT "PK_57689d19445de01737dbc458857" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.guest DROP CONSTRAINT "PK_57689d19445de01737dbc458857";
       public            abdelelbouhy    false    232            2           2606    16755 $   units PK_5a8f2f064919b587d93936cb223 
   CONSTRAINT     d   ALTER TABLE ONLY public.units
    ADD CONSTRAINT "PK_5a8f2f064919b587d93936cb223" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.units DROP CONSTRAINT "PK_5a8f2f064919b587d93936cb223";
       public            abdelelbouhy    false    274            ,           2606    16735 /   equipmentRentals PK_5de194c45157fb9e7822584f84a 
   CONSTRAINT     q   ALTER TABLE ONLY public."equipmentRentals"
    ADD CONSTRAINT "PK_5de194c45157fb9e7822584f84a" PRIMARY KEY (id);
 ]   ALTER TABLE ONLY public."equipmentRentals" DROP CONSTRAINT "PK_5de194c45157fb9e7822584f84a";
       public            abdelelbouhy    false    270            �           2606    25105 5   custom_payment_options PK_6240483154c38df84b1a738b44e 
   CONSTRAINT     u   ALTER TABLE ONLY public.custom_payment_options
    ADD CONSTRAINT "PK_6240483154c38df84b1a738b44e" PRIMARY KEY (id);
 a   ALTER TABLE ONLY public.custom_payment_options DROP CONSTRAINT "PK_6240483154c38df84b1a738b44e";
       public            abdelelbouhy    false    358            �           2606    17804 *   payment_way PK_64931a4086462262c508a783c21 
   CONSTRAINT     j   ALTER TABLE ONLY public.payment_way
    ADD CONSTRAINT "PK_64931a4086462262c508a783c21" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.payment_way DROP CONSTRAINT "PK_64931a4086462262c508a783c21";
       public            abdelelbouhy    false    342            �           2606    25408 /   provider_contact PK_6594e561946063efacf15bb1197 
   CONSTRAINT     o   ALTER TABLE ONLY public.provider_contact
    ADD CONSTRAINT "PK_6594e561946063efacf15bb1197" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public.provider_contact DROP CONSTRAINT "PK_6594e561946063efacf15bb1197";
       public            abdelelbouhy    false    364                       2606    16595 %   groups PK_659d1483316afb28afd3a90646e 
   CONSTRAINT     e   ALTER TABLE ONLY public.groups
    ADD CONSTRAINT "PK_659d1483316afb28afd3a90646e" PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.groups DROP CONSTRAINT "PK_659d1483316afb28afd3a90646e";
       public            abdelelbouhy    false    246            F           2606    16916 (   itemTimes PK_66a06181b5282e06d34f87b4e06 
   CONSTRAINT     j   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "PK_66a06181b5282e06d34f87b4e06" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "PK_66a06181b5282e06d34f87b4e06";
       public            abdelelbouhy    false    290            <           2606    16860 ,   notifications PK_6a72c3c0f683f6462415e653c3a 
   CONSTRAINT     l   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a";
       public            abdelelbouhy    false    282            &           2606    16715 ,   organizations PK_6b031fcd0863e3f6b44230163f9 
   CONSTRAINT     l   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT "PK_6b031fcd0863e3f6b44230163f9" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.organizations DROP CONSTRAINT "PK_6b031fcd0863e3f6b44230163f9";
       public            abdelelbouhy    false    266            �           2606    16481 -   boatEquipments PK_73c69f0a1be9d2dc98a82d19e7f 
   CONSTRAINT     o   ALTER TABLE ONLY public."boatEquipments"
    ADD CONSTRAINT "PK_73c69f0a1be9d2dc98a82d19e7f" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public."boatEquipments" DROP CONSTRAINT "PK_73c69f0a1be9d2dc98a82d19e7f";
       public            abdelelbouhy    false    222            U           2606    16976 /   serviceProviders PK_74465e86dba18eca3f696c388ca 
   CONSTRAINT     q   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "PK_74465e86dba18eca3f696c388ca" PRIMARY KEY (id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "PK_74465e86dba18eca3f696c388ca";
       public            abdelelbouhy    false    300            {           2606    17133 (   addresses PK_745d8f43d3af10ab8247465e450 
   CONSTRAINT     h   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "PK_745d8f43d3af10ab8247465e450" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "PK_745d8f43d3af10ab8247465e450";
       public            abdelelbouhy    false    326            O           2606    16940 (   schedules PK_7e33fc2ea755a5765e3564e66dd 
   CONSTRAINT     h   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "PK_7e33fc2ea755a5765e3564e66dd" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "PK_7e33fc2ea755a5765e3564e66dd";
       public            abdelelbouhy    false    294            y           2606    17122 $   boats PK_7f192e10b468d99557a0aede7e5 
   CONSTRAINT     d   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "PK_7f192e10b468d99557a0aede7e5" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "PK_7f192e10b468d99557a0aede7e5";
       public            abdelelbouhy    false    324            _           2606    16996 '   branches PK_7f37d3b42defea97f1df0d19535 
   CONSTRAINT     g   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "PK_7f37d3b42defea97f1df0d19535" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "PK_7f37d3b42defea97f1df0d19535";
       public            abdelelbouhy    false    302            i           2606    17042 )   activities PK_7f4004429f731ffb9c88eb486a8 
   CONSTRAINT     i   ALTER TABLE ONLY public.activities
    ADD CONSTRAINT "PK_7f4004429f731ffb9c88eb486a8" PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.activities DROP CONSTRAINT "PK_7f4004429f731ffb9c88eb486a8";
       public            abdelelbouhy    false    310                       2606    16568 &   wallets PK_8402e5df5a30a229380e83e4f7e 
   CONSTRAINT     f   ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "PK_8402e5df5a30a229380e83e4f7e" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.wallets DROP CONSTRAINT "PK_8402e5df5a30a229380e83e4f7e";
       public            abdelelbouhy    false    240                       2606    16586 (   userGroup PK_858e0887636a55b726ff3b2bcf1 
   CONSTRAINT     j   ALTER TABLE ONLY public."userGroup"
    ADD CONSTRAINT "PK_858e0887636a55b726ff3b2bcf1" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public."userGroup" DROP CONSTRAINT "PK_858e0887636a55b726ff3b2bcf1";
       public            abdelelbouhy    false    244            �           2606    25417 1   provider_block_map PK_88ba711cf551f57425b95c5fdb0 
   CONSTRAINT     q   ALTER TABLE ONLY public.provider_block_map
    ADD CONSTRAINT "PK_88ba711cf551f57425b95c5fdb0" PRIMARY KEY (id);
 ]   ALTER TABLE ONLY public.provider_block_map DROP CONSTRAINT "PK_88ba711cf551f57425b95c5fdb0";
       public            abdelelbouhy    false    366                       2606    16561 )   payMethods PK_88ffeb20acd384bf51c4e188c3f 
   CONSTRAINT     k   ALTER TABLE ONLY public."payMethods"
    ADD CONSTRAINT "PK_88ffeb20acd384bf51c4e188c3f" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."payMethods" DROP CONSTRAINT "PK_88ffeb20acd384bf51c4e188c3f";
       public            abdelelbouhy    false    238            �           2606    16453 )   migrations PK_8c82d7f526340ab734260ea46be 
   CONSTRAINT     i   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.migrations DROP CONSTRAINT "PK_8c82d7f526340ab734260ea46be";
       public            abdelelbouhy    false    217            :           2606    16824 +   itemRequests PK_9100bc2b2feb5a8f46773a25f19 
   CONSTRAINT     m   ALTER TABLE ONLY public."itemRequests"
    ADD CONSTRAINT "PK_9100bc2b2feb5a8f46773a25f19" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."itemRequests" DROP CONSTRAINT "PK_9100bc2b2feb5a8f46773a25f19";
       public            abdelelbouhy    false    280                       2606    16618 *   permissions PK_920331560282b8bd21bb02290df 
   CONSTRAINT     j   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT "PK_920331560282b8bd21bb02290df" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.permissions DROP CONSTRAINT "PK_920331560282b8bd21bb02290df";
       public            abdelelbouhy    false    252            �           2606    17703 .   loyalty_program PK_926584ab2a6ed625138cce7c134 
   CONSTRAINT     n   ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT "PK_926584ab2a6ed625138cce7c134" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.loyalty_program DROP CONSTRAINT "PK_926584ab2a6ed625138cce7c134";
       public            abdelelbouhy    false    336            8           2606    16789 +   applications PK_938c0a27255637bde919591888f 
   CONSTRAINT     k   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT "PK_938c0a27255637bde919591888f" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.applications DROP CONSTRAINT "PK_938c0a27255637bde919591888f";
       public            abdelelbouhy    false    278            $           2606    16706 )   boatSafety PK_9e71f68258e055888e7eb6cf807 
   CONSTRAINT     k   ALTER TABLE ONLY public."boatSafety"
    ADD CONSTRAINT "PK_9e71f68258e055888e7eb6cf807" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."boatSafety" DROP CONSTRAINT "PK_9e71f68258e055888e7eb6cf807";
       public            abdelelbouhy    false    264            4           2606    16771 +   transactions PK_a219afd8dd77ed80f5a862f1db9 
   CONSTRAINT     k   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "PK_a219afd8dd77ed80f5a862f1db9" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "PK_a219afd8dd77ed80f5a862f1db9";
       public            abdelelbouhy    false    276                       2606    16673 $   users PK_a3ffb1c0c8416b9fc6f907b7433 
   CONSTRAINT     d   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.users DROP CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433";
       public            abdelelbouhy    false    258            �           2606    17152 -   accommodations PK_a422a200297f93cd5ac87d049e8 
   CONSTRAINT     m   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "PK_a422a200297f93cd5ac87d049e8" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "PK_a422a200297f93cd5ac87d049e8";
       public            abdelelbouhy    false    328            �           2606    24953 '   excludes PK_a439afb4d03ef5a537bd1b8c973 
   CONSTRAINT     g   ALTER TABLE ONLY public.excludes
    ADD CONSTRAINT "PK_a439afb4d03ef5a537bd1b8c973" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.excludes DROP CONSTRAINT "PK_a439afb4d03ef5a537bd1b8c973";
       public            abdelelbouhy    false    350                       2606    16609 -   userPermission PK_a8af9ac1595cc54a5d087ba82f1 
   CONSTRAINT     o   ALTER TABLE ONLY public."userPermission"
    ADD CONSTRAINT "PK_a8af9ac1595cc54a5d087ba82f1" PRIMARY KEY (id);
 [   ALTER TABLE ONLY public."userPermission" DROP CONSTRAINT "PK_a8af9ac1595cc54a5d087ba82f1";
       public            abdelelbouhy    false    250            M           2606    16927 ,   scheduleItems PK_ada58e0790d2d96664862903fb9 
   CONSTRAINT     n   ALTER TABLE ONLY public."scheduleItems"
    ADD CONSTRAINT "PK_ada58e0790d2d96664862903fb9" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."scheduleItems" DROP CONSTRAINT "PK_ada58e0790d2d96664862903fb9";
       public            abdelelbouhy    false    292            "           2606    16697 +   boatFeatures PK_adef14c3b25cf7873d57a2e92c3 
   CONSTRAINT     m   ALTER TABLE ONLY public."boatFeatures"
    ADD CONSTRAINT "PK_adef14c3b25cf7873d57a2e92c3" PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."boatFeatures" DROP CONSTRAINT "PK_adef14c3b25cf7873d57a2e92c3";
       public            abdelelbouhy    false    262                       2606    16579 &   devices PK_b1514758245c12daf43486dd1f0 
   CONSTRAINT     f   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT "PK_b1514758245c12daf43486dd1f0" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.devices DROP CONSTRAINT "PK_b1514758245c12daf43486dd1f0";
       public            abdelelbouhy    false    242            *           2606    16728 (   countries PK_b2d7006793e8697ab3ae2deff18 
   CONSTRAINT     h   ALTER TABLE ONLY public.countries
    ADD CONSTRAINT "PK_b2d7006793e8697ab3ae2deff18" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.countries DROP CONSTRAINT "PK_b2d7006793e8697ab3ae2deff18";
       public            abdelelbouhy    false    268            @           2606    16896 )   roomRental PK_b84689a31f60fb2df7c6692936b 
   CONSTRAINT     k   ALTER TABLE ONLY public."roomRental"
    ADD CONSTRAINT "PK_b84689a31f60fb2df7c6692936b" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public."roomRental" DROP CONSTRAINT "PK_b84689a31f60fb2df7c6692936b";
       public            abdelelbouhy    false    286            m           2606    17065 '   services PK_ba2d347a3168a296416c6c5ccb2 
   CONSTRAINT     g   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "PK_ba2d347a3168a296416c6c5ccb2" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "PK_ba2d347a3168a296416c6c5ccb2";
       public            abdelelbouhy    false    314            D           2606    16909 .   reservationItem PK_baa5fc55765f4f3a322f852414d 
   CONSTRAINT     p   ALTER TABLE ONLY public."reservationItem"
    ADD CONSTRAINT "PK_baa5fc55765f4f3a322f852414d" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."reservationItem" DROP CONSTRAINT "PK_baa5fc55765f4f3a322f852414d";
       public            abdelelbouhy    false    288            �           2606    25233 *   recurrences PK_bc886e2f5042804348556c33a2c 
   CONSTRAINT     j   ALTER TABLE ONLY public.recurrences
    ADD CONSTRAINT "PK_bc886e2f5042804348556c33a2c" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.recurrences DROP CONSTRAINT "PK_bc886e2f5042804348556c33a2c";
       public            abdelelbouhy    false    360            o           2606    17074 (   amenities PK_c0777308847b3556086f2fb233e 
   CONSTRAINT     h   ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT "PK_c0777308847b3556086f2fb233e" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.amenities DROP CONSTRAINT "PK_c0777308847b3556086f2fb233e";
       public            abdelelbouhy    false    316                       2606    16638 (   inquiries PK_ceacaa439988b25eb9459e694d9 
   CONSTRAINT     h   ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT "PK_ceacaa439988b25eb9459e694d9" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.inquiries DROP CONSTRAINT "PK_ceacaa439988b25eb9459e694d9";
       public            abdelelbouhy    false    254            �           2606    25427 8   supplierThirdPartyDetails PK_d0af4deac602fb821084e515034 
   CONSTRAINT     z   ALTER TABLE ONLY public."supplierThirdPartyDetails"
    ADD CONSTRAINT "PK_d0af4deac602fb821084e515034" PRIMARY KEY (id);
 f   ALTER TABLE ONLY public."supplierThirdPartyDetails" DROP CONSTRAINT "PK_d0af4deac602fb821084e515034";
       public            abdelelbouhy    false    368            �           2606    17736 8   loyalty_program_withdraws PK_d37982e764392ea976a899ff86f 
   CONSTRAINT     x   ALTER TABLE ONLY public.loyalty_program_withdraws
    ADD CONSTRAINT "PK_d37982e764392ea976a899ff86f" PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.loyalty_program_withdraws DROP CONSTRAINT "PK_d37982e764392ea976a899ff86f";
       public            abdelelbouhy    false    340            �           2606    17161 0   applicationVisits PK_d3a7ece045ad7ee3bd12bb5c995 
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
       public            abdelelbouhy    false    220            �           2606    25062 $   court PK_d8f2118c52b422b03e0331a7b91 
   CONSTRAINT     d   ALTER TABLE ONLY public.court
    ADD CONSTRAINT "PK_d8f2118c52b422b03e0331a7b91" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.court DROP CONSTRAINT "PK_d8f2118c52b422b03e0331a7b91";
       public            abdelelbouhy    false    356            >           2606    16887 +   reservations PK_da95cef71b617ac35dc5bcda243 
   CONSTRAINT     k   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "PK_da95cef71b617ac35dc5bcda243" PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.reservations DROP CONSTRAINT "PK_da95cef71b617ac35dc5bcda243";
       public            abdelelbouhy    false    284            �           2606    25368 .   blocked_contact PK_ebbb7618fbad37a427b328a7a97 
   CONSTRAINT     n   ALTER TABLE ONLY public.blocked_contact
    ADD CONSTRAINT "PK_ebbb7618fbad37a427b328a7a97" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.blocked_contact DROP CONSTRAINT "PK_ebbb7618fbad37a427b328a7a97";
       public            abdelelbouhy    false    362            �           2606    17170 4   branchEquipmentRental PK_ee8ece4f4956609a628465e3708 
   CONSTRAINT     v   ALTER TABLE ONLY public."branchEquipmentRental"
    ADD CONSTRAINT "PK_ee8ece4f4956609a628465e3708" PRIMARY KEY (id);
 b   ALTER TABLE ONLY public."branchEquipmentRental" DROP CONSTRAINT "PK_ee8ece4f4956609a628465e3708";
       public            abdelelbouhy    false    332            �           2606    25051 2   custom_per_hour_day PK_eeaff69f365217134afd46f7d43 
   CONSTRAINT     r   ALTER TABLE ONLY public.custom_per_hour_day
    ADD CONSTRAINT "PK_eeaff69f365217134afd46f7d43" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.custom_per_hour_day DROP CONSTRAINT "PK_eeaff69f365217134afd46f7d43";
       public            abdelelbouhy    false    354            �           2606    25040 3   per_hour_price_range PK_f1d09b266e225a97c71c6def461 
   CONSTRAINT     s   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "PK_f1d09b266e225a97c71c6def461" PRIMARY KEY (id);
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "PK_f1d09b266e225a97c71c6def461";
       public            abdelelbouhy    false    352            e           2606    17019 $   trips PK_f71c231dee9c05a9522f9e840f5 
   CONSTRAINT     d   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "PK_f71c231dee9c05a9522f9e840f5" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "PK_f71c231dee9c05a9522f9e840f5";
       public            abdelelbouhy    false    306            }           2606    17141 (   addresses REL_21b07f425d667f94949fcc0791 
   CONSTRAINT     k   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_21b07f425d667f94949fcc0791" UNIQUE (company_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_21b07f425d667f94949fcc0791";
       public            abdelelbouhy    false    326            W           2606    16984 /   serviceProviders REL_2d48f1742a279e7a912c542bc6 
   CONSTRAINT     q   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "REL_2d48f1742a279e7a912c542bc6" UNIQUE (bank_id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "REL_2d48f1742a279e7a912c542bc6";
       public            abdelelbouhy    false    300            �           2606    17154 -   accommodations REL_2db82c1775049b6fc0bef24063 
   CONSTRAINT     p   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "REL_2db82c1775049b6fc0bef24063" UNIQUE (address_id);
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "REL_2db82c1775049b6fc0bef24063";
       public            abdelelbouhy    false    328            6           2606    16773 +   transactions REL_3f0b8d3da342d862a42b67d5c0 
   CONSTRAINT     r   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "REL_3f0b8d3da342d862a42b67d5c0" UNIQUE (reservation_id);
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "REL_3f0b8d3da342d862a42b67d5c0";
       public            abdelelbouhy    false    276                       2606    17137 (   addresses REL_5323628dd808ef14b3e39263cd 
   CONSTRAINT     k   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_5323628dd808ef14b3e39263cd" UNIQUE (service_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_5323628dd808ef14b3e39263cd";
       public            abdelelbouhy    false    326            Y           2606    16980 /   serviceProviders REL_6012fd887cebc68d6371b23700 
   CONSTRAINT     q   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "REL_6012fd887cebc68d6371b23700" UNIQUE (user_id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "REL_6012fd887cebc68d6371b23700";
       public            abdelelbouhy    false    300            B           2606    16898 )   roomRental REL_69de05bc4527573321f85edf8d 
   CONSTRAINT     k   ALTER TABLE ONLY public."roomRental"
    ADD CONSTRAINT "REL_69de05bc4527573321f85edf8d" UNIQUE (item_id);
 W   ALTER TABLE ONLY public."roomRental" DROP CONSTRAINT "REL_69de05bc4527573321f85edf8d";
       public            abdelelbouhy    false    286            .           2606    16737 /   equipmentRentals REL_76dec177c821074a2eed5a9116 
   CONSTRAINT     q   ALTER TABLE ONLY public."equipmentRentals"
    ADD CONSTRAINT "REL_76dec177c821074a2eed5a9116" UNIQUE (item_id);
 ]   ALTER TABLE ONLY public."equipmentRentals" DROP CONSTRAINT "REL_76dec177c821074a2eed5a9116";
       public            abdelelbouhy    false    270            �           2606    17135 (   addresses REL_8adde7f90b3f34dd994b20eaca 
   CONSTRAINT     h   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_8adde7f90b3f34dd994b20eaca" UNIQUE (boat_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_8adde7f90b3f34dd994b20eaca";
       public            abdelelbouhy    false    326                       2606    16570 &   wallets REL_92558c08091598f7a4439586cd 
   CONSTRAINT     f   ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "REL_92558c08091598f7a4439586cd" UNIQUE (user_id);
 R   ALTER TABLE ONLY public.wallets DROP CONSTRAINT "REL_92558c08091598f7a4439586cd";
       public            abdelelbouhy    false    240            �           2606    17139 (   addresses REL_a8c79e2600f0f688b574c162f1 
   CONSTRAINT     j   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "REL_a8c79e2600f0f688b574c162f1" UNIQUE (course_id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "REL_a8c79e2600f0f688b574c162f1";
       public            abdelelbouhy    false    326            (           2606    16717 ,   organizations REL_b071480a21b1242365ace4c03e 
   CONSTRAINT     n   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT "REL_b071480a21b1242365ace4c03e" UNIQUE (course_id);
 X   ALTER TABLE ONLY public.organizations DROP CONSTRAINT "REL_b071480a21b1242365ace4c03e";
       public            abdelelbouhy    false    266            a           2606    16998 '   branches REL_c03aef26af49e109f784a101ec 
   CONSTRAINT     j   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "REL_c03aef26af49e109f784a101ec" UNIQUE (address_id);
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "REL_c03aef26af49e109f784a101ec";
       public            abdelelbouhy    false    302                        2606    16688 *   userDetails REL_c1a882f399a453d730c2f4055c 
   CONSTRAINT     l   ALTER TABLE ONLY public."userDetails"
    ADD CONSTRAINT "REL_c1a882f399a453d730c2f4055c" UNIQUE (user_id);
 X   ALTER TABLE ONLY public."userDetails" DROP CONSTRAINT "REL_c1a882f399a453d730c2f4055c";
       public            abdelelbouhy    false    260            s           2606    17090 *   uploadFiles REL_c49c10511acf0024f50906d01a 
   CONSTRAINT     o   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "REL_c49c10511acf0024f50906d01a" UNIQUE (inquiry_id);
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "REL_c49c10511acf0024f50906d01a";
       public            abdelelbouhy    false    318            [           2606    16982 /   serviceProviders REL_e47a3ac28ef9462fae69aaceba 
   CONSTRAINT     t   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "REL_e47a3ac28ef9462fae69aaceba" UNIQUE (company_id);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "REL_e47a3ac28ef9462fae69aaceba";
       public            abdelelbouhy    false    300            H           2606    16918 (   itemTimes REL_f909df65f5f3d72941802aade4 
   CONSTRAINT     v   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "REL_f909df65f5f3d72941802aade4" UNIQUE (reservation_item_id);
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "REL_f909df65f5f3d72941802aade4";
       public            abdelelbouhy    false    290            ]           2606    16978 /   serviceProviders UQ_7a9f11a88b45dc94ceb4d8c0d4d 
   CONSTRAINT     n   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "UQ_7a9f11a88b45dc94ceb4d8c0d4d" UNIQUE (name);
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "UQ_7a9f11a88b45dc94ceb4d8c0d4d";
       public            abdelelbouhy    false    300                       2606    16675 $   users UQ_97672ac88f789774dd47f7c8be3 
   CONSTRAINT     b   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);
 P   ALTER TABLE ONLY public.users DROP CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3";
       public            abdelelbouhy    false    258            �           2606    25239 $   recurrences antiDuplicatedRecurrence 
   CONSTRAINT     �   ALTER TABLE ONLY public.recurrences
    ADD CONSTRAINT "antiDuplicatedRecurrence" UNIQUE (court_id, "endDate", "startTime", "endTime");
 P   ALTER TABLE ONLY public.recurrences DROP CONSTRAINT "antiDuplicatedRecurrence";
       public            abdelelbouhy    false    360    360    360    360            J           2606    25309    itemTimes antiDuplicatedSlots 
   CONSTRAINT     �   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "antiDuplicatedSlots" UNIQUE (item_id, "startTime", "endTime", imported_reserve);
 K   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "antiDuplicatedSlots";
       public            abdelelbouhy    false    290    290    290    290            
           2606    25307    devices unique_tokens 
   CONSTRAINT     e   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT unique_tokens UNIQUE (user_id, device_id, token);
 ?   ALTER TABLE ONLY public.devices DROP CONSTRAINT unique_tokens;
       public            abdelelbouhy    false    242    242    242            K           1259    25156 "   fki_FK_431f9477ab1f3be0f320fcfa458    INDEX     _   CREATE INDEX "fki_FK_431f9477ab1f3be0f320fcfa458" ON public."itemTimes" USING btree (item_id);
 8   DROP INDEX public."fki_FK_431f9477ab1f3be0f320fcfa458";
       public            abdelelbouhy    false    290            �           2606    17421 %   prices FK_069941a584af167b698f7ac9c57    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_069941a584af167b698f7ac9c57" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_069941a584af167b698f7ac9c57";
       public          abdelelbouhy    false    296    4947    298            �           2606    17371 .   reservationItem FK_0acace0118d09a48fc55efa67e6    FK CONSTRAINT     �   ALTER TABLE ONLY public."reservationItem"
    ADD CONSTRAINT "FK_0acace0118d09a48fc55efa67e6" FOREIGN KEY ("reservationId") REFERENCES public.reservations(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public."reservationItem" DROP CONSTRAINT "FK_0acace0118d09a48fc55efa67e6";
       public          abdelelbouhy    false    288    4926    284            �           2606    17246 '   favorite FK_0b73fbcf6371cc64893c07db1b9    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_0b73fbcf6371cc64893c07db1b9" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_0b73fbcf6371cc64893c07db1b9";
       public          abdelelbouhy    false    236    4973    314            �           2606    17236 '   favorite FK_0d72f85fd5f30f984ad51887ac6    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_0d72f85fd5f30f984ad51887ac6" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_0d72f85fd5f30f984ad51887ac6";
       public          abdelelbouhy    false    298    4947    236            �           2606    17281 /   group_permission FK_0e55010ae1d72304910446ee8e7    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_permission
    ADD CONSTRAINT "FK_0e55010ae1d72304910446ee8e7" FOREIGN KEY ("group_Id") REFERENCES public.groups(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.group_permission DROP CONSTRAINT "FK_0e55010ae1d72304910446ee8e7";
       public          abdelelbouhy    false    4878    246    248            �           2606    17416 %   prices FK_1182a9f9bfa1370f3a823bd8b86    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_1182a9f9bfa1370f3a823bd8b86" FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_1182a9f9bfa1370f3a823bd8b86";
       public          abdelelbouhy    false    296    4914    274            �           2606    17201 +   branchCourse FK_12130d3d7846ed4dda2681506b5    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchCourse"
    ADD CONSTRAINT "FK_12130d3d7846ed4dda2681506b5" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."branchCourse" DROP CONSTRAINT "FK_12130d3d7846ed4dda2681506b5";
       public          abdelelbouhy    false    4947    298    230            �           2606    17481 '   branches FK_1359c25adc8fa78046837f7ad60    FK CONSTRAINT     �   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "FK_1359c25adc8fa78046837f7ad60" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "FK_1359c25adc8fa78046837f7ad60";
       public          abdelelbouhy    false    302    4890    258            �           2606    17241 '   favorite FK_1cac9d6926ea4b5a95ecb45478c    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_1cac9d6926ea4b5a95ecb45478c" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_1cac9d6926ea4b5a95ecb45478c";
       public          abdelelbouhy    false    4985    236    324                       2606    17636 $   boats FK_1d32140a23e65433c7785de4811    FK CONSTRAINT     �   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "FK_1d32140a23e65433c7785de4811" FOREIGN KEY (city_id) REFERENCES public.cities(id);
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "FK_1d32140a23e65433c7785de4811";
       public          abdelelbouhy    false    324    4967    308            �           2606    17426 %   prices FK_1f858d2631e4168d38440de398f    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_1f858d2631e4168d38440de398f" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_1f858d2631e4168d38440de398f";
       public          abdelelbouhy    false    296    4973    314            �           2606    17546 '   services FK_1f8d1173481678a035b4a81a4ec    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_1f8d1173481678a035b4a81a4ec" FOREIGN KEY (category_id) REFERENCES public.categories(id);
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_1f8d1173481678a035b4a81a4ec";
       public          abdelelbouhy    false    314    4852    224                       2606    17581 *   uploadFiles FK_20b45b0f9115c34d14d86fffea7    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_20b45b0f9115c34d14d86fffea7" FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_20b45b0f9115c34d14d86fffea7";
       public          abdelelbouhy    false    318    4997    328                       2606    17661 (   addresses FK_21b07f425d667f94949fcc07914    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_21b07f425d667f94949fcc07914" FOREIGN KEY (company_id) REFERENCES public.companies(id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_21b07f425d667f94949fcc07914";
       public          abdelelbouhy    false    326    4856    228            �           2606    17361 +   reservations FK_22d254a38b8ce7d6be792d43d4c    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "FK_22d254a38b8ce7d6be792d43d4c" FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.reservations DROP CONSTRAINT "FK_22d254a38b8ce7d6be792d43d4c";
       public          abdelelbouhy    false    284    4943    294            �           2606    17186 -   boatEquipments FK_24217aa21f8008cc727cc23df17    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatEquipments"
    ADD CONSTRAINT "FK_24217aa21f8008cc727cc23df17" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public."boatEquipments" DROP CONSTRAINT "FK_24217aa21f8008cc727cc23df17";
       public          abdelelbouhy    false    324    222    4985            �           2606    17326 .   tripItineraries FK_24c55f8feb095e0515a99796a8f    FK CONSTRAINT     �   ALTER TABLE ONLY public."tripItineraries"
    ADD CONSTRAINT "FK_24c55f8feb095e0515a99796a8f" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public."tripItineraries" DROP CONSTRAINT "FK_24c55f8feb095e0515a99796a8f";
       public          abdelelbouhy    false    306    4965    272            �           2606    17351 ,   notifications FK_264fbdfc991d71f3ae598b76ed1    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "FK_264fbdfc991d71f3ae598b76ed1" FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "FK_264fbdfc991d71f3ae598b76ed1";
       public          abdelelbouhy    false    234    282    4862            �           2606    17476 /   serviceProviders FK_2d48f1742a279e7a912c542bc62    FK CONSTRAINT     �   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "FK_2d48f1742a279e7a912c542bc62" FOREIGN KEY (bank_id) REFERENCES public.banks(id) ON DELETE SET NULL;
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "FK_2d48f1742a279e7a912c542bc62";
       public          abdelelbouhy    false    300    4854    226                       2606    17666 -   accommodations FK_2db82c1775049b6fc0bef24063f    FK CONSTRAINT     �   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "FK_2db82c1775049b6fc0bef24063f" FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "FK_2db82c1775049b6fc0bef24063f";
       public          abdelelbouhy    false    328    4987    326            �           2606    17531 ,   branchService FK_33ba8869de9f50d6b94c9d82328    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchService"
    ADD CONSTRAINT "FK_33ba8869de9f50d6b94c9d82328" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."branchService" DROP CONSTRAINT "FK_33ba8869de9f50d6b94c9d82328";
       public          abdelelbouhy    false    312    4973    314            �           2606    17196 +   branchCourse FK_386d6db187ee5dcea975724d1d1    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchCourse"
    ADD CONSTRAINT "FK_386d6db187ee5dcea975724d1d1" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."branchCourse" DROP CONSTRAINT "FK_386d6db187ee5dcea975724d1d1";
       public          abdelelbouhy    false    4959    230    302                       2606    17576 *   uploadFiles FK_3bbf2b4517174ea39708eed9330    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_3bbf2b4517174ea39708eed9330" FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_3bbf2b4517174ea39708eed9330";
       public          abdelelbouhy    false    318    4981    320                       2606    25132 3   per_hour_price_range FK_3bd0b48f87deb86bc437e85b152    FK CONSTRAINT     �   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "FK_3bd0b48f87deb86bc437e85b152" FOREIGN KEY ("foreignCurrencyId") REFERENCES public.currencies(id);
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "FK_3bd0b48f87deb86bc437e85b152";
       public          abdelelbouhy    false    352    4848    220                       2606    17571 *   uploadFiles FK_3d8ca1edfb94b9c89636d21e7b2    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_3d8ca1edfb94b9c89636d21e7b2" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_3d8ca1edfb94b9c89636d21e7b2";
       public          abdelelbouhy    false    318    4985    324                       2606    25068 2   custom_per_hour_day FK_3eba8ec7a110fb5d7c8e8b54470    FK CONSTRAINT     �   ALTER TABLE ONLY public.custom_per_hour_day
    ADD CONSTRAINT "FK_3eba8ec7a110fb5d7c8e8b54470" FOREIGN KEY ("courtId") REFERENCES public.court(id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.custom_per_hour_day DROP CONSTRAINT "FK_3eba8ec7a110fb5d7c8e8b54470";
       public          abdelelbouhy    false    354    5027    356            �           2606    17331 +   transactions FK_3f0b8d3da342d862a42b67d5c02    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "FK_3f0b8d3da342d862a42b67d5c02" FOREIGN KEY (reservation_id) REFERENCES public.reservations(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "FK_3f0b8d3da342d862a42b67d5c02";
       public          abdelelbouhy    false    4926    284    276            �           2606    17551 '   services FK_421b94f0ef1cdb407654e67c59e    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_421b94f0ef1cdb407654e67c59e" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_421b94f0ef1cdb407654e67c59e";
       public          abdelelbouhy    false    314    4890    258            �           2606    25151 (   itemTimes FK_431f9477ab1f3be0f320fcfa458    FK CONSTRAINT     �   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "FK_431f9477ab1f3be0f320fcfa458" FOREIGN KEY (item_id) REFERENCES public.court(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "FK_431f9477ab1f3be0f320fcfa458";
       public          abdelelbouhy    false    290    5027    356            �           2606    17521 )   activities FK_463b4906ce5cd0817cbc2d0999a    FK CONSTRAINT     �   ALTER TABLE ONLY public.activities
    ADD CONSTRAINT "FK_463b4906ce5cd0817cbc2d0999a" FOREIGN KEY (city_id) REFERENCES public.cities(id);
 U   ALTER TABLE ONLY public.activities DROP CONSTRAINT "FK_463b4906ce5cd0817cbc2d0999a";
       public          abdelelbouhy    false    310    4967    308            �           2606    17436 %   prices FK_524b24ea7870382af4202ef0ce2    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_524b24ea7870382af4202ef0ce2" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_524b24ea7870382af4202ef0ce2";
       public          abdelelbouhy    false    296    4965    306                       2606    17651 (   addresses FK_5323628dd808ef14b3e39263cd8    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_5323628dd808ef14b3e39263cd8" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_5323628dd808ef14b3e39263cd8";
       public          abdelelbouhy    false    326    4973    314            �           2606    17401 (   schedules FK_55e6651198104efea0b04568a88    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "FK_55e6651198104efea0b04568a88" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "FK_55e6651198104efea0b04568a88";
       public          abdelelbouhy    false    294    4890    258                       2606    17616 +   boatActivity FK_591ed4a7ad448d4fb6b8b12b4a5    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatActivity"
    ADD CONSTRAINT "FK_591ed4a7ad448d4fb6b8b12b4a5" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."boatActivity" DROP CONSTRAINT "FK_591ed4a7ad448d4fb6b8b12b4a5";
       public          abdelelbouhy    false    322    4985    324                       2606    17601 *   uploadFiles FK_5b4c3b94721ee97608c52741e9c    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_5b4c3b94721ee97608c52741e9c" FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_5b4c3b94721ee97608c52741e9c";
       public          abdelelbouhy    false    318    4902    266            �           2606    17181 -   boatEquipments FK_5d727aa852f8f7ed71304d30c7a    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatEquipments"
    ADD CONSTRAINT "FK_5d727aa852f8f7ed71304d30c7a" FOREIGN KEY (currency_id) REFERENCES public.currencies(id);
 [   ALTER TABLE ONLY public."boatEquipments" DROP CONSTRAINT "FK_5d727aa852f8f7ed71304d30c7a";
       public          abdelelbouhy    false    220    4848    222            �           2606    17266 &   devices FK_5e9bee993b4ce35c3606cda194c    FK CONSTRAINT     �   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT "FK_5e9bee993b4ce35c3606cda194c" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.devices DROP CONSTRAINT "FK_5e9bee993b4ce35c3606cda194c";
       public          abdelelbouhy    false    4890    242    258            �           2606    17466 /   serviceProviders FK_6012fd887cebc68d6371b237004    FK CONSTRAINT     �   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "FK_6012fd887cebc68d6371b237004" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "FK_6012fd887cebc68d6371b237004";
       public          abdelelbouhy    false    300    4890    258            �           2606    17461 &   courses FK_6158bff272157e1e16498eed44d    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_6158bff272157e1e16498eed44d" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_6158bff272157e1e16498eed44d";
       public          abdelelbouhy    false    298    4949    300                       2606    17671 -   accommodations FK_61a6f64ec973fe15b0b6cbfaf72    FK CONSTRAINT     �   ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT "FK_61a6f64ec973fe15b0b6cbfaf72" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.accommodations DROP CONSTRAINT "FK_61a6f64ec973fe15b0b6cbfaf72";
       public          abdelelbouhy    false    328    4890    258            �           2606    17276 (   userGroup FK_61d2057e882356891f6cf9eafa7    FK CONSTRAINT     �   ALTER TABLE ONLY public."userGroup"
    ADD CONSTRAINT "FK_61d2057e882356891f6cf9eafa7" FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."userGroup" DROP CONSTRAINT "FK_61d2057e882356891f6cf9eafa7";
       public          abdelelbouhy    false    246    244    4878            �           2606    17431 %   prices FK_629f61f9867f39346ae1df5b862    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_629f61f9867f39346ae1df5b862" FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_629f61f9867f39346ae1df5b862";
       public          abdelelbouhy    false    296    4943    294            �           2606    17206 $   guest FK_634c70ef4f0a25b35ba169574de    FK CONSTRAINT     �   ALTER TABLE ONLY public.guest
    ADD CONSTRAINT "FK_634c70ef4f0a25b35ba169574de" FOREIGN KEY ("reservationId") REFERENCES public.reservations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.guest DROP CONSTRAINT "FK_634c70ef4f0a25b35ba169574de";
       public          abdelelbouhy    false    4926    284    232            �           2606    17216 &   reviews FK_6587db79174d07150fde1f1a4d6    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_6587db79174d07150fde1f1a4d6" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_6587db79174d07150fde1f1a4d6";
       public          abdelelbouhy    false    234    4973    314            �           2606    17386 ,   scheduleItems FK_665caa1f0e355060a3359d3f3dc    FK CONSTRAINT     �   ALTER TABLE ONLY public."scheduleItems"
    ADD CONSTRAINT "FK_665caa1f0e355060a3359d3f3dc" FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."scheduleItems" DROP CONSTRAINT "FK_665caa1f0e355060a3359d3f3dc";
       public          abdelelbouhy    false    292    4943    294            �           2606    17511 $   trips FK_6953304630116af4602dc6e3b35    FK CONSTRAINT     �   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "FK_6953304630116af4602dc6e3b35" FOREIGN KEY (currency_id) REFERENCES public.currencies(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "FK_6953304630116af4602dc6e3b35";
       public          abdelelbouhy    false    306    4848    220            �           2606    17366 )   roomRental FK_69de05bc4527573321f85edf8d1    FK CONSTRAINT     �   ALTER TABLE ONLY public."roomRental"
    ADD CONSTRAINT "FK_69de05bc4527573321f85edf8d1" FOREIGN KEY (item_id) REFERENCES public."reservationItem"(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."roomRental" DROP CONSTRAINT "FK_69de05bc4527573321f85edf8d1";
       public          abdelelbouhy    false    286    4932    288            
           2606    17611 $   rooms FK_6a64e95ff8396f2ca8ff008e441    FK CONSTRAINT     �   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT "FK_6a64e95ff8396f2ca8ff008e441" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.rooms DROP CONSTRAINT "FK_6a64e95ff8396f2ca8ff008e441";
       public          abdelelbouhy    false    320    4985    324                       2606    17586 *   uploadFiles FK_6bcbc913c553d3ec55cdb8ce2e7    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_6bcbc913c553d3ec55cdb8ce2e7" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_6bcbc913c553d3ec55cdb8ce2e7";
       public          abdelelbouhy    false    318    4947    298            �           2606    17336 +   transactions FK_6cbed86cedb31104e975a579d10    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "FK_6cbed86cedb31104e975a579d10" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id);
 W   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "FK_6cbed86cedb31104e975a579d10";
       public          abdelelbouhy    false    300    276    4949            �           2606    17226 &   reviews FK_728447781a30bc3fcfe5c2f1cdf    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_728447781a30bc3fcfe5c2f1cdf" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_728447781a30bc3fcfe5c2f1cdf";
       public          abdelelbouhy    false    258    4890    234            �           2606    17321 /   equipmentRentals FK_76dec177c821074a2eed5a91162    FK CONSTRAINT     �   ALTER TABLE ONLY public."equipmentRentals"
    ADD CONSTRAINT "FK_76dec177c821074a2eed5a91162" FOREIGN KEY (item_id) REFERENCES public."reservationItem"(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public."equipmentRentals" DROP CONSTRAINT "FK_76dec177c821074a2eed5a91162";
       public          abdelelbouhy    false    270    288    4932            �           2606    17556 '   services FK_7790290d3a7e8a22cb738f055c0    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_7790290d3a7e8a22cb738f055c0" FOREIGN KEY ("cityId") REFERENCES public.cities(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_7790290d3a7e8a22cb738f055c0";
       public          abdelelbouhy    false    308    314    4967            �           2606    17346 ,   notifications FK_7814037821140da2a093c972336    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "FK_7814037821140da2a093c972336" FOREIGN KEY (reservation_id) REFERENCES public.reservations(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "FK_7814037821140da2a093c972336";
       public          abdelelbouhy    false    282    284    4926                       2606    17631 $   boats FK_7a2278b3104d396ca29ad90dc52    FK CONSTRAINT     �   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "FK_7a2278b3104d396ca29ad90dc52" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "FK_7a2278b3104d396ca29ad90dc52";
       public          abdelelbouhy    false    324    4949    300                       2606    25127 3   per_hour_price_range FK_81a1517f93422a6717c769a36d7    FK CONSTRAINT     �   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "FK_81a1517f93422a6717c769a36d7" FOREIGN KEY ("egyptianCurrencyId") REFERENCES public.currencies(id);
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "FK_81a1517f93422a6717c769a36d7";
       public          abdelelbouhy    false    352    4848    220                        2606    17561 (   amenities FK_85f93e760d004922a71bf914676    FK CONSTRAINT     �   ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT "FK_85f93e760d004922a71bf914676" FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.amenities DROP CONSTRAINT "FK_85f93e760d004922a71bf914676";
       public          abdelelbouhy    false    316    328    4997                       2606    17646 (   addresses FK_8adde7f90b3f34dd994b20eacad    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_8adde7f90b3f34dd994b20eacad" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_8adde7f90b3f34dd994b20eacad";
       public          abdelelbouhy    false    326    4985    324            �           2606    17356 +   reservations FK_8e65d43933cbb37928f015ba42b    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "FK_8e65d43933cbb37928f015ba42b" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.reservations DROP CONSTRAINT "FK_8e65d43933cbb37928f015ba42b";
       public          abdelelbouhy    false    4965    284    306                       2606    17566 (   amenities FK_9180945dcb1888c561fb3099bf2    FK CONSTRAINT     �   ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT "FK_9180945dcb1888c561fb3099bf2" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.amenities DROP CONSTRAINT "FK_9180945dcb1888c561fb3099bf2";
       public          abdelelbouhy    false    316    4973    314                       2606    17626 $   boats FK_91a8892b04a4603324c43950849    FK CONSTRAINT     �   ALTER TABLE ONLY public.boats
    ADD CONSTRAINT "FK_91a8892b04a4603324c43950849" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.boats DROP CONSTRAINT "FK_91a8892b04a4603324c43950849";
       public          abdelelbouhy    false    324    4890    258            �           2606    17261 &   wallets FK_92558c08091598f7a4439586cda    FK CONSTRAINT     �   ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "FK_92558c08091598f7a4439586cda" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.wallets DROP CONSTRAINT "FK_92558c08091598f7a4439586cda";
       public          abdelelbouhy    false    4890    258    240            �           2606    17496 )   branchTrip FK_93810c72bba2e6fa802386d2000    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchTrip"
    ADD CONSTRAINT "FK_93810c72bba2e6fa802386d2000" FOREIGN KEY (trip_id) REFERENCES public.trips(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."branchTrip" DROP CONSTRAINT "FK_93810c72bba2e6fa802386d2000";
       public          abdelelbouhy    false    304    4965    306                       2606    17641 (   addresses FK_98e1ca336038167c7eb48c02582    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_98e1ca336038167c7eb48c02582" FOREIGN KEY (country_id) REFERENCES public.countries(id);
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_98e1ca336038167c7eb48c02582";
       public          abdelelbouhy    false    326    4906    268            �           2606    17296 -   userPermission FK_9914ed53b6cc72cd2206632bf6d    FK CONSTRAINT     �   ALTER TABLE ONLY public."userPermission"
    ADD CONSTRAINT "FK_9914ed53b6cc72cd2206632bf6d" FOREIGN KEY (permission_id) REFERENCES public.permissions(id);
 [   ALTER TABLE ONLY public."userPermission" DROP CONSTRAINT "FK_9914ed53b6cc72cd2206632bf6d";
       public          abdelelbouhy    false    250    252    4884            �           2606    17341 ,   notifications FK_9a8a82462cab47c73d25f49261f    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "FK_9a8a82462cab47c73d25f49261f" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.notifications DROP CONSTRAINT "FK_9a8a82462cab47c73d25f49261f";
       public          abdelelbouhy    false    258    4890    282            �           2606    17451 &   courses FK_a4396a5235f159ab156a6f8b603    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_a4396a5235f159ab156a6f8b603" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_a4396a5235f159ab156a6f8b603";
       public          abdelelbouhy    false    298    4890    258                       2606    17591 *   uploadFiles FK_a60de16cba13ae4a833d7d5da0f    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_a60de16cba13ae4a833d7d5da0f" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_a60de16cba13ae4a833d7d5da0f";
       public          abdelelbouhy    false    318    4973    314            �           2606    17501 $   trips FK_a645f117e4c98b1f7e69479e85c    FK CONSTRAINT     �   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "FK_a645f117e4c98b1f7e69479e85c" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "FK_a645f117e4c98b1f7e69479e85c";
       public          abdelelbouhy    false    306    4985    324            �           2606    17301 (   inquiries FK_a896a1864d60d5707403e0a0810    FK CONSTRAINT     �   ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT "FK_a896a1864d60d5707403e0a0810" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.inquiries DROP CONSTRAINT "FK_a896a1864d60d5707403e0a0810";
       public          abdelelbouhy    false    4890    254    258            �           2606    17256 )   payMethods FK_a8ad1bca942f54ce1baf9c580f3    FK CONSTRAINT     �   ALTER TABLE ONLY public."payMethods"
    ADD CONSTRAINT "FK_a8ad1bca942f54ce1baf9c580f3" FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."payMethods" DROP CONSTRAINT "FK_a8ad1bca942f54ce1baf9c580f3";
       public          abdelelbouhy    false    240    4868    238                       2606    17656 (   addresses FK_a8c79e2600f0f688b574c162f12    FK CONSTRAINT     �   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_a8c79e2600f0f688b574c162f12" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.addresses DROP CONSTRAINT "FK_a8c79e2600f0f688b574c162f12";
       public          abdelelbouhy    false    326    4947    298            �           2606    17251 '   favorite FK_aa6ce8d4592db172192b9d9cfef    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_aa6ce8d4592db172192b9d9cfef" FOREIGN KEY (city_id) REFERENCES public.cities(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_aa6ce8d4592db172192b9d9cfef";
       public          abdelelbouhy    false    236    308    4967            �           2606    17491 )   branchTrip FK_ab9a0f198f6a3c6cddfdad3b0c9    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchTrip"
    ADD CONSTRAINT "FK_ab9a0f198f6a3c6cddfdad3b0c9" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."branchTrip" DROP CONSTRAINT "FK_ab9a0f198f6a3c6cddfdad3b0c9";
       public          abdelelbouhy    false    304    4959    302            �           2606    17316 ,   organizations FK_b071480a21b1242365ace4c03e8    FK CONSTRAINT     �   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT "FK_b071480a21b1242365ace4c03e8" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.organizations DROP CONSTRAINT "FK_b071480a21b1242365ace4c03e8";
       public          abdelelbouhy    false    266    4947    298            �           2606    17391 (   schedules FK_b1e10ac4dc72412af1c3f4d736d    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "FK_b1e10ac4dc72412af1c3f4d736d" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "FK_b1e10ac4dc72412af1c3f4d736d";
       public          abdelelbouhy    false    294    4947    298                       2606    17676 4   branchEquipmentRental FK_b63231e3418da4533d94b663d6f    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchEquipmentRental"
    ADD CONSTRAINT "FK_b63231e3418da4533d94b663d6f" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 b   ALTER TABLE ONLY public."branchEquipmentRental" DROP CONSTRAINT "FK_b63231e3418da4533d94b663d6f";
       public          abdelelbouhy    false    332    4959    302            �           2606    17221 &   reviews FK_b7d143e7ceb1cad286c2cf4a19a    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_b7d143e7ceb1cad286c2cf4a19a" FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_b7d143e7ceb1cad286c2cf4a19a";
       public          abdelelbouhy    false    324    234    4985            �           2606    17526 ,   branchService FK_b8b0a564517e0c93d782677cce7    FK CONSTRAINT     �   ALTER TABLE ONLY public."branchService"
    ADD CONSTRAINT "FK_b8b0a564517e0c93d782677cce7" FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."branchService" DROP CONSTRAINT "FK_b8b0a564517e0c93d782677cce7";
       public          abdelelbouhy    false    312    4959    302            �           2606    17411 %   prices FK_baf743d0e2daa78701b2cf394cb    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_baf743d0e2daa78701b2cf394cb" FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_baf743d0e2daa78701b2cf394cb";
       public          abdelelbouhy    false    296    4997    328            �           2606    17536 '   services FK_bbff764dfa6918af2cf15f1a7f7    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_bbff764dfa6918af2cf15f1a7f7" FOREIGN KEY (activity_id) REFERENCES public.activities(id);
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_bbff764dfa6918af2cf15f1a7f7";
       public          abdelelbouhy    false    314    4969    310            �           2606    17306 $   users FK_bc1cd381147462a1c604b425f7a    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_bc1cd381147462a1c604b425f7a" FOREIGN KEY (plan_id) REFERENCES public."pricingPlans"(id);
 P   ALTER TABLE ONLY public.users DROP CONSTRAINT "FK_bc1cd381147462a1c604b425f7a";
       public          abdelelbouhy    false    4888    256    258            �           2606    17286 /   group_permission FK_bfa1a11bbb745d29a4a941c7cc5    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_permission
    ADD CONSTRAINT "FK_bfa1a11bbb745d29a4a941c7cc5" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.group_permission DROP CONSTRAINT "FK_bfa1a11bbb745d29a4a941c7cc5";
       public          abdelelbouhy    false    252    4884    248            �           2606    17486 '   branches FK_c03aef26af49e109f784a101ecd    FK CONSTRAINT     �   ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "FK_c03aef26af49e109f784a101ecd" FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE SET NULL;
 S   ALTER TABLE ONLY public.branches DROP CONSTRAINT "FK_c03aef26af49e109f784a101ecd";
       public          abdelelbouhy    false    302    4987    326            �           2606    17311 *   userDetails FK_c1a882f399a453d730c2f4055cb    FK CONSTRAINT     �   ALTER TABLE ONLY public."userDetails"
    ADD CONSTRAINT "FK_c1a882f399a453d730c2f4055cb" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."userDetails" DROP CONSTRAINT "FK_c1a882f399a453d730c2f4055cb";
       public          abdelelbouhy    false    4890    260    258                       2606    17606 *   uploadFiles FK_c49c10511acf0024f50906d01a6    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_c49c10511acf0024f50906d01a6" FOREIGN KEY (inquiry_id) REFERENCES public.inquiries(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_c49c10511acf0024f50906d01a6";
       public          abdelelbouhy    false    318    4886    254            �           2606    17516 )   activities FK_cf4a8062ad267056ddd5f867ac1    FK CONSTRAINT     �   ALTER TABLE ONLY public.activities
    ADD CONSTRAINT "FK_cf4a8062ad267056ddd5f867ac1" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.activities DROP CONSTRAINT "FK_cf4a8062ad267056ddd5f867ac1";
       public          abdelelbouhy    false    310    4852    224            	           2606    17596 *   uploadFiles FK_d31b25877c1328114d4bf17f171    FK CONSTRAINT     �   ALTER TABLE ONLY public."uploadFiles"
    ADD CONSTRAINT "FK_d31b25877c1328114d4bf17f171" FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."uploadFiles" DROP CONSTRAINT "FK_d31b25877c1328114d4bf17f171";
       public          abdelelbouhy    false    318    4856    228            �           2606    17506 $   trips FK_d8926932b8ea2aa8ea85db56d78    FK CONSTRAINT     �   ALTER TABLE ONLY public.trips
    ADD CONSTRAINT "FK_d8926932b8ea2aa8ea85db56d78" FOREIGN KEY ("cityId") REFERENCES public.cities(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.trips DROP CONSTRAINT "FK_d8926932b8ea2aa8ea85db56d78";
       public          abdelelbouhy    false    306    4967    308            �           2606    17396 (   schedules FK_ddd03cb28bed3c395141ecc05b3    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT "FK_ddd03cb28bed3c395141ecc05b3" FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.schedules DROP CONSTRAINT "FK_ddd03cb28bed3c395141ecc05b3";
       public          abdelelbouhy    false    294    4973    314                       2606    17621 +   boatActivity FK_dfbff0b0269a87254cafaef9e24    FK CONSTRAINT     �   ALTER TABLE ONLY public."boatActivity"
    ADD CONSTRAINT "FK_dfbff0b0269a87254cafaef9e24" FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public."boatActivity" DROP CONSTRAINT "FK_dfbff0b0269a87254cafaef9e24";
       public          abdelelbouhy    false    322    4969    310            �           2606    17471 /   serviceProviders FK_e47a3ac28ef9462fae69aaceba6    FK CONSTRAINT     �   ALTER TABLE ONLY public."serviceProviders"
    ADD CONSTRAINT "FK_e47a3ac28ef9462fae69aaceba6" FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;
 ]   ALTER TABLE ONLY public."serviceProviders" DROP CONSTRAINT "FK_e47a3ac28ef9462fae69aaceba6";
       public          abdelelbouhy    false    300    4856    228            �           2606    17446 &   courses FK_e4c260fe6bb1131707c4617f745    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_e4c260fe6bb1131707c4617f745" FOREIGN KEY (category_id) REFERENCES public.categories(id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_e4c260fe6bb1131707c4617f745";
       public          abdelelbouhy    false    298    4852    224                       2606    25137 3   per_hour_price_range FK_e562209b36ec0fda719440d9f24    FK CONSTRAINT     �   ALTER TABLE ONLY public.per_hour_price_range
    ADD CONSTRAINT "FK_e562209b36ec0fda719440d9f24" FOREIGN KEY ("customPerHourDayId") REFERENCES public.custom_per_hour_day(id) ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.per_hour_price_range DROP CONSTRAINT "FK_e562209b36ec0fda719440d9f24";
       public          abdelelbouhy    false    352    5025    354            �           2606    17231 '   favorite FK_e666fc7cc4c80fba1944daa1a74    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT "FK_e666fc7cc4c80fba1944daa1a74" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.favorite DROP CONSTRAINT "FK_e666fc7cc4c80fba1944daa1a74";
       public          abdelelbouhy    false    236    4890    258            �           2606    17541 '   services FK_e7a40b21f8fd548be206fcc89b2    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT "FK_e7a40b21f8fd548be206fcc89b2" FOREIGN KEY (provider_id) REFERENCES public."serviceProviders"(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.services DROP CONSTRAINT "FK_e7a40b21f8fd548be206fcc89b2";
       public          abdelelbouhy    false    314    4949    300            �           2606    17441 &   courses FK_ea2e349cd78d70d56055b54967d    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_ea2e349cd78d70d56055b54967d" FOREIGN KEY (activity_id) REFERENCES public.activities(id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_ea2e349cd78d70d56055b54967d";
       public          abdelelbouhy    false    298    4969    310            �           2606    17406 %   prices FK_efccf450fbef16adea889a07742    FK CONSTRAINT     �   ALTER TABLE ONLY public.prices
    ADD CONSTRAINT "FK_efccf450fbef16adea889a07742" FOREIGN KEY (currency_id) REFERENCES public.currencies(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.prices DROP CONSTRAINT "FK_efccf450fbef16adea889a07742";
       public          abdelelbouhy    false    296    4848    220            �           2606    17291 -   userPermission FK_f3e6433a5004b37b935f0e4681f    FK CONSTRAINT     �   ALTER TABLE ONLY public."userPermission"
    ADD CONSTRAINT "FK_f3e6433a5004b37b935f0e4681f" FOREIGN KEY (user_id) REFERENCES public.users(id);
 [   ALTER TABLE ONLY public."userPermission" DROP CONSTRAINT "FK_f3e6433a5004b37b935f0e4681f";
       public          abdelelbouhy    false    258    250    4890            �           2606    17271 (   userGroup FK_f6e9388fbd41658ee6311ff4e24    FK CONSTRAINT     �   ALTER TABLE ONLY public."userGroup"
    ADD CONSTRAINT "FK_f6e9388fbd41658ee6311ff4e24" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."userGroup" DROP CONSTRAINT "FK_f6e9388fbd41658ee6311ff4e24";
       public          abdelelbouhy    false    244    258    4890            �           2606    17191 $   banks FK_f709fcbcd013e948be9fe3364e3    FK CONSTRAINT     �   ALTER TABLE ONLY public.banks
    ADD CONSTRAINT "FK_f709fcbcd013e948be9fe3364e3" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.banks DROP CONSTRAINT "FK_f709fcbcd013e948be9fe3364e3";
       public          abdelelbouhy    false    258    4890    226            �           2606    17456 &   courses FK_f78b5a39a694052fdc034fa6013    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "FK_f78b5a39a694052fdc034fa6013" FOREIGN KEY (city_id) REFERENCES public.cities(id);
 R   ALTER TABLE ONLY public.courses DROP CONSTRAINT "FK_f78b5a39a694052fdc034fa6013";
       public          abdelelbouhy    false    298    4967    308            �           2606    17381 (   itemTimes FK_f909df65f5f3d72941802aade41    FK CONSTRAINT     �   ALTER TABLE ONLY public."itemTimes"
    ADD CONSTRAINT "FK_f909df65f5f3d72941802aade41" FOREIGN KEY (reservation_item_id) REFERENCES public."reservationItem"(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."itemTimes" DROP CONSTRAINT "FK_f909df65f5f3d72941802aade41";
       public          abdelelbouhy    false    290    4932    288            �           2606    17211 &   reviews FK_f99062f36181ab42863facfaea3    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_f99062f36181ab42863facfaea3" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.reviews DROP CONSTRAINT "FK_f99062f36181ab42863facfaea3";
       public          abdelelbouhy    false    234    298    4947                       2606    25073 $   court FK_fa87bba54227ae111d62b3e42d8    FK CONSTRAINT     �   ALTER TABLE ONLY public.court
    ADD CONSTRAINT "FK_fa87bba54227ae111d62b3e42d8" FOREIGN KEY ("scheduleId") REFERENCES public.schedules(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.court DROP CONSTRAINT "FK_fa87bba54227ae111d62b3e42d8";
       public          abdelelbouhy    false    356    4943    294            E      x������ � �            x������ � �      	     x��[k�������� -l����7?�8q�^�A� %qW�TI��M��޹�%YC�J
E��c�;3��̥�#L�RS#5Q�L$x��iQ���]Rd���6e���$��&/��G�*�O˨�Q�M�uU$���U�{�N�h��^�<J}٤�~�{�scM˂ѐ�ۘ�HjΘ:g"��y^��E��?��w�������פJ��yR��W��H͏�̑�#bGD�T8BD�p���H,���(V�S"x�T�aE�����V���U�5������f}B���w�Fl,U,m����3�+���<[���v��÷���	}���7x�k<t��l�QRsqke�L�I�ȷE�ݯ��i�oh�ޫ�1���p�X@��A����P���vp��e����e��H�5,��?o�z�s�iY��Oĵ�\TJ|Ȫ��wC��6M�c��L��!�_kP���wgq��	�]&|���>	��]ۛ���$O���X�K��I� ldĨe
s��D��W뤬�iٛ�}�Ǚ�f�g,$���y5d�� !ş>bƙ\R�C�r�!+0�N��dh�<��C�o7��go�v��>{��C����?e$��̜3��&�5_.��I�\��&h�B��6.H鈲�*�N)�#ʹ6�L��eVV�t=�?��!~@�r�� �~���0mr�{L���0������Y���r�0�s�oB�����u�G�f4�&��<&��F�Y>���;w�L�e��:-�ut`�[O��%�g�V�`k$Lϳ�TG7�e��'Ќ� X�-F�cg�e$�r~�E|WC!�����c~�\�ܯ��.]��[9M6i�)�W��cT �(�٢e%*z�i��������-�Ԁ6��Ǻ�A{Z�
l�eD,��a][�j%@o�w����'���l�Y��]Rg��yO�xo���dc;Iyf�䱬�
�%���l�G;o,1���
^Cpe֘H u�j�/�dê����E�2��hM����I��{#Ե �<._�����Rhܝ$;J�x�<f"RVS/*�5����q�p�{Ud�:��z6��2���$�D��-�/MgW�5椣�����R��ǔǜD�X)@X��,�]dW���/J��5x�ʅr��U#�C*cgՑ��PW��I�y:��@���Kdb���a?�m;���+(�4>&ٺrYx�]���*�wXc�{,,�.pR��!!���#8���U:��d{m�Gä���$e�
8(���k��}�΋E��n��b�X�w[9b"d)�&1P���l�����BѲGBD�}H����BČE�(K��iz�V�(�EW{R�	i�"b��E���}'y�VI�8Z�]���;%hY0�[NAɃ��y�����M, y�����J(pM�����Y�d7 ¯5�7�D�7��]n]�S31A����VE����m�}h<� bN��:GO��p�u@���iS/���_���ٚ�\��`%���l=:�8� 6��&k��/�5���i}��P{�t=Lw�A"����A���5�weրN:����vYYBV��JCm��z���&���(a=�Bp�t�ac	!)#�����}���i�0s��� c�o��/��M����QȊ��o�C��\<�g�ד2�����~X@��TS{�<�&b\(fΙvӂ�٢�����v˩�I��pJ���L$���F=�p�h�0��4���G��:OmV�+$�%����=�nc��d<FD�.> $����`WC0�#��ܕ��;�,���޷��ث/��P�8�����!��M�S�j;����i�P�e��0�x5H�T�Z�2'�%wB�@9�W���E6�{�K�����Q����h(Q]��P��
�e� �nOc"��d=�� �Ew���1JmL	X?���P�~,�{�2!D�{��;)��&J�v,�p޿���~		z�m{��d�RW�P�����-^m��`Ns���j��<ۼ�������+���r�]��:�Vss C����]�(���i��G�i�k�#��d�n5a�%t�q�^i*H��*�Ǧ�VY�_e� ;��gI;�{� T숓H��	>�����#����-&0%�d��m01��c&f*>�4x�ګb:O���"��y$�N�K"�Ed�� �ń�$�=s�~�6_o�au��A�;�Ց��4�#w�&���t��_��[.�WD����\Ѹw]�E�h]��^���΍܌@�s&8O*8�F�M�1�͖�e��y����;�+�����;����1��o.���o�ǎ�O���R?�ࠤ��[.�*����s�`����b;�Y��43�A2�t�!c:�)X���R�H�cZ������ԧ������pz�����5�6KII5����b5�;��� '�1oL$xSd�����~k���8H��ۑ�	�1ێ~̪�����8,<�O�
��њH�9�,�p`�r �ʃ`��AO	��Zw���j�����(���_/:�o�����ޭ���"��;�M*#a�kqpp���w�G��]��N�	bH���&p�퀊���g5ޕ��s��ݚ�����|=�S�C�\���R�co	>%w����Wᤨ+�:Tnm�/���x�;��QG�&mJ�!���q̟:��J��Kc"�/iv?��a���a����ҹ�rɌjOEj�AǂEZ1�h ��G��e]����u\�Fw\��8��hM��17�/11�lg6�&��M����kwa��q����Z��s>�('R�9V�HP>���"�cc���V����x��l�� �4Go�&���9v�R�®
�^jk���UoF�U�mjW���&�M�Q������#ĔR��l��r&}t\8Ԗ��l�7��	���c(�P���t���yd�X�����T�5��$��%�}ݏ^0 �#�\M��4R�Z0����7�3��x�Z������6�pS������5-�
^g�e%�5[0�����	��];��7�����Q1���,!-A̽ϋ2?e����oI����:�T� :�lM���~9��f���E�~NB�ə,5
�����&���v^��I->���Yޘvc�M��_�ԯ�9��:�:f�����"ɴ��>���"�
��h��y�k��2>!(����Oh���Gyp�gw��-A\r�I6y����; ,l:�-�񃩅l-�SP�Q���Ȁv��K�։;V;��u�u��h�3�#)(��,|��I�H�b��YzY������5�r�      %      x������ � �            x��}ے\�u�s�+�PΝ��7��LYAJ"�P�/B�������|;$Y����-�d�lOx<_�x�/��v���'3�T��K��4�T��˾_h��6OUz��Sg:nR"���H�)�Q:�V�g���������G�����/�������zx�]Y���LY�Qɓ�*%�#�2��!�#��������Zy��D� ���|��n��*�4S��������۟3�����n�ޮ����������0�֊\A�J���J�M��@���W�?�,�=�=`3�Jk�d��rTڇ8#�3��\ڐ!�����)��J��9J*��ѩ`��̴��W�g�0T��T�f�m�I����ӫ���W���_?�l8���IZK.��g�������ߌ��>���7����p�yzm��]�F�E"��f��p}��`?n�/^v�E�V�z��շ�����9�q���=�W �:#���(o� 9͇_:M�l{��Ir�q�\�=(�5i�gFo��/�0�V�W�|x���o��u7U��.�2���M*���q�{���w&��@9�/�5љJg��vk��ɹ��y�._���K���U]���1]�մ�+�W wf��x�
�D��{)�k\��ō'��Y"lX?��~3���>}�����W�o�7/^� G���S�0=�^�=d�1*D�}�U���֔���W�Ԏ[�I���w������q�/�������߼�U��_���������������o�;�������7��5���:�Uc��Y�h�i��&qS\K-N�Q[��K����\����~�Wd�|�b�I��g۟��o��g�²���Sr?�O"~`�G�:���	�~��2�୤9ɝ�pFfC!�Hr|�|�_�����])-�8?um���E�aلmԎߥ�m����{���W��i~��r���dx1�����o�����R~�܊b%]se�"Ź�H��__^`}�_/Wϯ޽=_?��.�O���oF��������J�+2�_�an�X��x�hS���l4�7�R�V�U�.�������ۃpW3{z�b-���Y� �q(�X�n�K��G���C	��$H��M�i�Z��Y��xC��[�y��ŋ���٫WC_�p�w�f�?%�d&�2X�]�k�8K�����>������xK:V�F��Tq�D�k�J���i~e,X������^�9;[Ttb�+))�d��SEr��Ah��|��@`�®�7\��Y��|��?��`�\����%���N\�h�����f�'l��vL��Jo�o�����ܔ��	e`.��Xd��˞p3fX@"��Yͯay\4-K�%xX�e���O��߼{Q��,��C@_����;��آ�SF�XH��s���3K�&u�4������y��֚k����L���v�F�p��i�̀�G��#1%����,Hx}�����gJmd[u�Ji��.w�R�m��ug&���XKn�\�~Y�X��U����=P�Zd��ژ.Pָ���@?޲�v>V,�>f�.���ђO�Ɏ��͋l���f�w}U��O �Vc����>������=��Fᶰ��g�L�3˜Yy�����ђ5�m,�*�?�����Z��ŷsX|t�YA?3KH�"��R�'�8{���:��~��Ia��M^���y���w���q|l6x;����k�c[=��v~��]\���B{9�jf�gYi���8o����A���uZ�] ���g ��f<��Oe��w7[�8���'>"�]:*�Jrw�0[�ٍ����g�Db l(��/�������f�������������;f |#������_�o��������s�?oK������ċz�M�����yl����t�^"�)��v<��<s�d�%�q����lf;3�l/�����0�	���@6�&	�%gk���˔�k����w�_���ㄍ���'�Sֹ��D��cd��Z���Տ�K��K(u�H�ܴ;w-� K,�������n�Ύ$z��R큇���3�$6I�������m���q�hX�ħȦ��I���6�=�����Q+?W�6��Z���Ʈ��z8�x#��W����J��f���8��T
�L��7��L�o��T�4Ǐ�m �\#��i�j��ߴ�3��v�wRE�hԢ����q��=Y��k�G/���7���N�6�a��E|�����P#3g6V���"s�Q�����kV_�]�l�X����O�Q3De�c"��}۫���3�F~R)����Bt��Y	��Gf��|�n�<��+(6lUf��e>�渿�8Ko��X4˶.�Bˊ��V�b]���|Y�:��7�5?q���|x�vx��j�b�i�|���˗�r�}hֲVW�l`���x�?+��b�](B�>렓��Y�pp �_���j��s-9��yK;���-�ߝ{ޒݣ�St_h��MЙ���ի�jl���Ƭ��ñ/���8�`*�L�+x��"�C;�橖8����am\�f��ho��b$B(��axy!�ĳ���T�$s���t��*������d�fR��� �`�n����m�	��	��&XL�y�aY��?�	����𤤔AaW?aɖ q����t��X��K�Y�&�u��!;�k\��?*F�QI����������a�m���*U
��gF��%�R	���0b�xϏ�I�jT������_N,�	:��ז-@m!��U(�aގO��n_����5�������W|��3��ѳj挕!�
��4&��Zl��^~�i<6/��}��{ͯ�ԍ�JT���l�^�%���UQ��g�����S�["l���'�(��������7������J%���]�nX���(�1P�hLG5Mǒ�B�߄D�d�lȀo���M{sz�	�=�I��Qa%�;B0�U^B�����g/��Ih˻�\#��Û���Uf��2��'yVy�ȼ.���}O�����pu.���L��b��h��!��G��(H��g0���}cH�`4����u������=K���&��J�ЦuK��[�NL1l	4�;F�������`����br�~�jZ�<6�6�fORZ���遏�ͤ
J��W|*�b���&M������d���;��Y����M̇
�qD��m�X�B\�5>����X�Z��CS�U���;z0> X���3���!����Ĩ�4���k����;&i6!����w̨6P��;ּ�↏��5L�pP���b�"��G�Z��a�A��$�V�C�y���2�au����I�!�uI�_���X�69@��Zj�G���1&`7�i�&���#mc�1N*V���c�7�Eo��<�7פ@�����<�����$�����nFJ7��tP6�($�v�p�5|yc���l�	4���:E�J�^C�ev�K�����v�7C��P�:A���wO��dc ���_���|�VRj��.��.�q�%�i/-7q�7��{h��mg��H��$��j�eFz�e�n�"�[g��Lg��x�(�
�����������F[@�p��7(imI}��FB�|=���-���:Ԍ���v��G4Zl�-˂� VV�#�z8�j�&"��c��P<!��G�W�
�v%����Y�3��8Q���t���S_^/B�"Z\��ʏy.�9��	�@�&>8ȖGy�}W�U=���_"=ND1Vh�7E<���?�`�H��&UhR�$��#Z���H�V5��U��&D�����#���Bjf���f[N��&�1>b�&�����#u)�L�%���I��M��G�w�ߖ�c2����q��HRB��W.�C�3`,q�N���$� ��P7�����8Y����Nǰj|�!-�rFH�'3�A��M� X�ol�&�I[�m�/�ί�]�?z���zX��y�΅PĊL:�8�Z�$I��4%���� ��f� 8a2��+	v��@�Q+Ʈ$҅�ja�?��oχy#    �i��0�-�YYcD�Y3E�wT-H�����FK^B1��!R"\����ǳ������YQ�E��5���};!�|,�k����zY"&��D�t��^䢋�+�DG>Ɛ�O]xQW�C�V_�L,�0�;aŌ��q)�O�l�@o�\�_J^V?S�gՠ�TI�J{нT�hY���Q�����qB
 	��ݧ�!l��	]OqQE��h�D>������C\�6�l�b��R�SW����č��T_0�����(����ҕ.ܯ��y[�P²�K��憉$Ġӿ��~7GH�=�Jj�B�v�ɞ����]�g���[q:�[Q���^.`�`�[�v�,��!��}h�x�G�S��ӡG[M��ޥ&�G��YT���xwq�����J	Ƈ��f4^�x #[�y0#=��]����I�U�u��T�%-��#h� �ԭ�bݚj%�EV�PB��\:�Y���^����HOQFx�YJ]�H�C=��h�g���q_}�����^��^�Y.�Ǥ�	��p��px����Ͼ��m3��	���&�ﴫ����~x>���j�8��D�cʖ+���sF,��cz_I�Y儭�2�"��v�XQ�
�MϜ� �Q$֊�x�FH����9eȲ��!�Da��İ���oPE��Ԇ�O�$Z��tYKf�\�l%糳�û�s��P폚�O��"m��|��yq��H���Q7�s�5�sHob]��&TX�F�\|8��K��(9R�\� ����J��=T)�����;f&$ٓ�!��Fb+�1W�~'����<��n
-��2��5�e�["0IoF�}��t�V<�+��J��P�T�1G��N±|�$m�#u��pX���>k�G����qPy�R7�r��}B��yˣ����[�1��B��<T�T��h��69���Mm����_L�"�����{���bAj%dΊ�����f����FK �$���g�Ʒ�셵����İJ�Ey�ޱtTW%d��<CR��'$�
�֋{���K��=I;_6"�o�FU�["�-Pv��Ƚ�Xp(;�P7R���ة<Ar�6������W�r�ۗ����X�����_�
����IAk��/܆���\��݃5����0DY��l՘�����׉`���t�Z	�̎�_"�D�@�G(+Y#NI��u�I3��A�O�Ϳ�8͔eƮ}��U����>�C�L�MˠfE�Y )������a	v�r��c��F����i�W�e 6s�~�:NG�8���
��: ����)��Ow;�I3id%d�6��`_�\4Vc"����@�����������������/��;�bbye�:o�&`�v����{�"�gmc���v�r�\ް槳:�*F�%�V��������e��Q��r9)j����Lu�(Q6�qNM$xA�iHQM���	��:4F�e�͑نVK.e���b��&ggO���s�l�D;}��ǻ�w�PP�a ��,�d
M�C��a�̯���}�����£�D��ĸD����r�2R�)VL㝠�	�;v��>�����ÍƼ��^\��w���+��s;B����*��H\�AL�Z�p%���"�CZ�x����uv*��<cE��2�����7(��0�œ,����t8Py��(��|}[��Bᔔ����H'B�֔D]����<K��d[�i�VG�f#H��E��<��!l�Cd�:!Q��^����Ym����=���n��՞f���[�4b|L�#�"J�r������V�pzg�`]��- %=�F��$vz�U��Md�I��o|J�i���b}��|�0���-t�)M�+|�[��2RGPsٮp��m�~�e���ͼ�>B��2۹e�R�`9Jf�q,E1��T�z����8Yi�t���s�#�����G}�Z�st~������h�)��9���-�F$��A��	���`�ןY80�uq�;G�߷ F��y�Z��q3X�am�/t�,D	"����juI�fWM�Q�k�X�P\5d=Y�[�����r��i��7���K�M�麤��eV^����/P/څ��[�!�<��( 7����?��F0m�(����-��lB��3�,�b/�*2fR���ؠ�[�����EɎ�ۻ�l�Ꮯo/Fs��<�c%�G�;�)���Ʉ
����f�6�&�DІh������0�X*/����q�]Jc��y
8wcW�J��y6��n�S�e�(M�2�(3k@fH$r��.���=jD�C��zN�۵E��n�֏������_�~w�Oٹ���}��.J�P4:ٸk���~�k��0�)�i\A�uG�[�G����F2�}�z�����5EK��3a��H�*�C�A�1�贊K�"i��X��ٚ@���)��K:���zjc#��@��&�
�=U�W\$KVSC믍~���;XBdW����� id��}tXMB�̤ny�N��K���C�0IF~�.-�S�G�zY-A\fjI/�eٽ�;�U�U�l�RJ�$D�1�C'��} ���)�ڸ`����z[J
=�^M/�̍*�����/�L�ݑ\�"I�4��Bu_*҃Ϩ�%��k�H'aF���i!)��5A�K9Iͣky)J}	(֫�����zs*�q@��I��f��ҁjK�\�p-D�X%�T�u��=��s�k/"�+�T��1��f"��� �
���cL���bå��w���ʘd�t|�Q���zd	l�X����@V����"0����K��A��8�!/HK���_�éZ{T;���m9~�s#eVh�n�4�m[WQ�9�E;���B:۱}��.m�B>��Fe��_[M\+UA���m͠t��ر��X^����к_�N�㽰�|�fY��I�t�H�J ��,.y�$s(��@���W�}�j�Ņh6�Q��H}��*K.g5{Ŏ$�f�
��Ek8�	��-2������a5:VU��E����n�(	b[?�~���Lmnh!�O����Q����97�_�~�������廾\�d��l@:z��Q~(�ZM(����-$�S��Q΂�{8�S�hz�j�2J�:�X"���7�V~B��|�f,�V�f� �I��ۋ��������ߠ5��yh>��PG�P]Pc�prѸ@��H�0�DZxhEl,��ҟy�F��2R�IG�zo��-G�$mIM�R(�=pi��s���+X�D���x��xh^¯i�۔��$�Y~��UiIJ�ZU��Bf�U���%ҟ
slYa510�3����㟖H2̍�G��ed3-Ie{ ULK�y�6[T�����x��Ë�h@�N׉�}T�zL�T,�,b�p&ZB[�L��4�Ó�������y[ܜ�Oz����I��K�$�de:��K������(�N���2�Ėd�\���(��nJcq�YzQ�|�$����"=��cu��W�N�P��T���		��n�t2��EmT��$+��%�IN�U
�<���I'=�o�%�l}0V(Hlt�}H5�	�	?��z�b(2>�
�)��oGkR��%��3�4[,I	��7Mu�Č�:��i�zu�;#K�<=`ҕ��B���	#�b���4�e��H
d��Ĉ,D2R�獱������a��]^ГB"H���j6��o����m]�5�H-NI$-�ӘZ��p���2��7����7��œ͍p��.
���%�
��yJP�'��69�e��b��{�&V��L�U�b�c�n1��$��za��c���C��kB�J�>�Ih�d�/��ww�I���	j
�����$�JH����͓ӭHH@����):P�Wk|xf�D����"�����w��+��5*>��}�v�}���'j#�鑎M5P+�P��:@=��M�������a�O�Q}�/�J~��g�$���`l�a]xJI+���N� %�I�'ӏ��q��)�H��S�;�DL�Dx��|��DB$�'���K��cM���r-/9~K�8�D��Ф�|T�9G� ��*��T�/��z��HwͦP��.�N�K��o�q��    P ��Tc��u�S�:�r�0�S#��oLK����=�fKK�%���v�_;Vb�:��)Z}�����z��C�d g��)��wu�o�
��F�l�O3s��G�ÙZ��Υ�F ˅f�����iûNՋ�j^F/�P�U��J�5:�%����ѡ�S��Ʀ�2P:*�H�s�Y'�Gch��l�ݠ���u`I�BR�/<�֔�MO�Q/y$i~|��y���|���ӟ_�e]�gۥ�>B÷�W@�d�"����#�Īx\Qw��:���K1ے�6Qs]�����^ױT���7����A�ߒf�D#>���X�>~�y�0��:�MPh�V�0d��V������LR�������xg��E6iD 8V�Ѣ���c��r{4i��0��.����w����/�n�~:ܜ/����1+��R͖��&��C[�O���V�� �j�K04ך:��(w5�s�o���g�Z�))esQ����i���+Jlw6��U�4�b��B����3m��(i���l ��d4��іM�(�%Z����1_�~ʲ1Y��$Y�\kD����&�>d�ޏt���u�>V��0�,e�P�>�E�kt��)�d{'��rȘ����z������a-UJ��p�mɱ����͛�_����txyq�<JJ���f�{l|�v�;nf�P#�J��R��\}Z�+�������m@��4��2�Uwg�����{
�d-��sї׵%5����W�}�����������7����?��|���7�����q. P�"{�J����wS$�H:�c���C����+�/m��H'3ܪ�X_�*��"3PR�~�fh��1��v����0�6���le=���5���P�
o�`8Qڧ�ܳKŰ@9�w?f\�O@D_�%c���v�V��*h��4NE�۳�L�ʷYf]�خl��}f[��H����T���Wg-R5�Y�V�g|�������n���1�����R4��:�.�P�~[)!a`�Dw���=�?N]�ӄ�̌�`�օz�f��!��LB�0�d�E�����Y�����"b+�~sf�q7^���X+�O�&n�a�22U�ii���M�&7"�v�6�ʛ��Z�tT�)�,j�9Lx�ӳ���7� 3W[�Ԕ��1��kb���S�1��ٚ�k���R%�Z�+�����ë�/��ً��j�}{�mϞq؊ݩ9��`b%M�;�8nS��J�<�4���t��e�L�մ	*�b��8���>0��s`9��(Mg,R�Bx��D�F�ie!?�o��<��_JW�bm~T����D�v�2��yn���v���rC�������&S��i�δ%�ǤR���h֤�]"��zV� �*6��
׼����
-�L���V�|�t���5���s;� ��uA��(%��������l<��ꦟqE��D'U~!��2?#P<�ц_�;-�I�IW �-�"��H:��t�BH���=�I��$�xl�
r�*�������uHBP��mI�2umD-����r�o<�X	 �2	#/Of��B�R�,IJ,�Bq�����FT[�T�Ċ�Wu	�E&���H�=�a��i'�8�A=o��N��0�3��>X�_(�A�z�%��ڠM*⧋�8lc�w�3$��h������Tc} XA�
VH�+DB3X	Y�0�sڊt+G%�P!AY��F�5%cLåN��~�
�$!Tb�:�9��vF�2�.5KK��0+o���qF�j�d���ɰH
O�ތ����	5����W�/�����b5�Ř�\�k��GO��=0�lJ�%�֟��T��<��0eF�,�N���}%�0z�~΂\�t8�t��0f�� 5�ʹ)�%��M,x�ڙ�,z�#a8��c�sK"S.�1�̝���B�Kꗦ6����܁2�R's��a۵b0�ɯ�H��q��\�*�6��|�}���Jv��A���W���'P�H�ѧ��Q�&x��BK�Z��DZ��c?ǝ�H*�S}>��/q�Y[�z�2b~��"��.��0��W����:<,;��QN���Cf������`B�F�(I�U:Lc`MY�f�G_�gѧɳ"$>L���ɩ.[�3��I3���[;e�vI';DS�	E�^�f���D:@[��qlo����V�K�>;�Z "�#�ڠ�s��l	`��ڏ�"�b�z�����xPb�<g�&˼��U�������d�17w��^"u3C��� ?���x�#,�F#�/8�a�=Z�\��d�]L1�V����zX��+�Uy��F�d�ȓ!�y�MH�PǓW�
r�0�#�Po�t/��1$��<?Tk�7�)�A��'��%>ku@��y�DZ���7@m�aCq��LXc����%ҡ����-�I�Jʺ>�"�"5ιM����.8�]E��E�j�P�Kk=�>���߬?����xyuh$8�mC1�3Og�AZ�p����J�DJ��~�f{�uw)pŽ���`;$��8��&md7��z�r�ĝ�3w��O2�KZI�ק�p>�į>������-�}>�X�+�~�91�T�-�ӣ؋��Rm�$s���d��U ��1&Jv���iԓ&>f�-1��_]��θJ&�)/o��l�q Z���hWR�c���"�N�p��+a�n��"��T����*Ѫ]dǄ�زK)d�ؤ�.iA�}��ջ]䫧���ϗ�۵0]�E�7K���8��/�K��D�DZ�?��ff�Wۛ���.��Wȝ���i������d�s۴`��Ц�@I����[�o�����l��޾ʂ�-�D��P>7��X$�=���C$���?���]7os5 �YIz�ڇ�����/�Ф.���tR����g2�&��i�]����r���`��Lf8~�ܣ���ޤ���}���<���¤uI�������Bȱ�+SH���z�L�lPY�����H�7���/9I^(ɨ��_$�C��[U-�g%c�UA�7�V���Z����MT�to�P{#���҃��.�������
ڄ���bF�7���i�k��9���>��{cho��o$�𘗤�k0��{ch�k6<ɨm]4��Ϻ:<kPθA`+.�	�W{k��K��}���t_�w�����,�U��̌to��t͗�QѬ!O6D�toU����ԗP���}�}��������t��P��V������F���Ye�-���Qn�!IE�Jt�v�t��ce\�Q����:T��"�`�w�T��&�I�n����k�W5��ґ�4�K:�V:x�QDK��)��t��̞Z����Bp�bZ�d����D{ɼ�v"�(B�[i�dv��m���,�_�c3i�~iu������T;g�+�02�;G��H��2|_oS�(�λ�H��JEߠ�&��L{�3�i �j�3��=:��%�i ��0�I�ҡQ��b�*��4 ;�d�"Jgs�F"QX"�`+���Q�k�e�-�N�X�j^�F$�:.�N�Xa������h�t��$	�$�ce�ӬYZ]���I �V�[�p& �{��H��J�8���C���0�3��<�B2��'��Ws���f,�4�%i��G_��c��� dLF�
}�C:�F�&���<@$B!��x���byq֣��J��C��ck�ngiiT�(P�9�r��u������˂l?��"���(�0�#��p!4�H�t�Q�׎|+<���=b(x��<.�Vd�T/�����9�!=.�VT$]����l	��O�=�]N1��&���CN~ �sF��غ.�?����IP٧��.�HJ!e��c��ȩ	��`d�%�w&8�#��W�J(#-����:��q2�U��m�G�����?dd�Mݾ�*���W��8,����;�x�Ta#;�#�`=�.[����E��.��F��%[���9��/�?�ߟf�L��F��V�����h��"��#���W��)ګݜҘ���C�T���L��T��~D �  ��J�kl4I��|_x��h-:��.���V��@,4�ry�R�����ƶ����;��S@
5$-�@|aCG����kE,*��1폷7��`�NN�U�w����͘�Qe+���WG����e�|��Uh��{y�4w����.�����*�ZW�a�_R2|-����`ؼ�ծ����R���>�)�׏�؜��oʈc�ќCD,-�]0����W�Wo�;a#J�ƎY)���b��p��	B��LP|E����o��3@�fd���:�G�;>���ׯ�Hs��^$�?���P�J{b�>n���s���=#^��ڲ��׈D�s�TsI9�D����5���LN��-Q/Qg?��ޏ�>3,�T}%g�Ë�g��Q���(���((���5�a�HƲ����"M6���Q'��8�7�W-��c/xko����jPK�]�	�,��T] P�|N�BOs�M��w���mu�c3ңC1an/Xi[�6��T5]h�|����KT�����:���/�����Y�q��w:�#C�tx#M4)﹯>B�����$y�:�;Զz=������pKk&Z4�� �a;w�����ѣ��Q� +�{��FE�%+b?nn����\�\��B�����0�*�~�fx�����H3]���z|����V�NR�0�[��Y�fSB<u����Bik�/�C;�%'�����h��Ęu��|��a��8@T��Iꝉ��������Ac����6Z��^� E(�d���N��1�-���1L��:V��1�D�J@���Q�~���m_����u2�cJ~�S�t�t�{}��a�G�	�Y=_N�h��KK�"i��L��r2ن5%�o(��<�m�ڒy��V"�K�"��W-G��m�Ii����jZ]�Ԁ��i9�0�����qdZ��Hr�ޥR����h���N���ZK�Hgؐ%��P|�MU�J�`33�:�P�����^G�<�Lk2x#�q0�no����F,�a�-��/a����׃��̞��U���E�D�I"��E��a���}}�k��t�%u{B�˻g7�df���%;�=�l�Ӄ9M�x���'�~n%��hF%Z"�}{v�z{C�Ι���H�'�ڍ'��6�&`�CYNjTk������z�v6DK���[�>W���<�vV�u����	��M|s�5�"�~��H���T(��M�U>x��D�behd;-�s�!��j�����K��:�O��j? 0\�y�6R��O�}=�����I�J2	�`�hr*₠��M:����|M	@� �à��t@J� �{��/i��{�;˪�*�����w׶�٢�A�ʍ*�#+���{P�"9�BWy�����Û����]?��j���2��Yh[P���j`	��M�j�N���+A'+��\l����_J�QbE��E�$�v�m����������XfcP�����h��,�v��lƎ��v�Zc
q��iJ=�&H�������ع�yb_OR�Y�Z���5"B�Q	Y�T������7�W6�d$Р�ʊ�nr�¹A��[��m���:$
9T�uc@�{\Iz���r=�E^0ښ�HK��~TC*#�%�R����OC�cY���P���vI�Ͽi�j����4�,n��)7���턣�AR(׹m��Zf�FW�J��>�Bb@hh��{�T}OQ���-���Ɣ���J�㟲�ˑʷ�W���������7ۋ��8�n��������7ۗ��i�w��E֘Li�3՘t��C
]�I2�g�TV���������<��=
2�*���eSmlj����#��x-�k/��.G����m6km�Q#&��̮���}����i']�=��_��Ze��w>�ݬ��{=*��2���H�@�X���Sm�!෸�Q�Ԇ
��l�Fos�V��
��fzm�bcS�=�F�ZV�EC��J���S�և�q��v��ߺ�]:_}kI��MŮ��}�Bݟo�<��U��Η�x���P�
p���T�	Q�D���c ��V{\����R�l��@k�)���)kx�Y����'�2E��	��Zl��?\_��BV4����k�)��X�YC��|!Va�J�$빙��ܥ�gS.�r*���S�ky��UҶ�>y���<y����b~�            x���Ks�8������ic7&D�������{��㰼1���e�t�J[U�?�&� 	�FFUL��~L�DHU�#�_Pz�xCŊ��-�J��t����f��ܯ��_���������C��#��Sx��]�����#�I���1�NmtC���U-U�PS��:����4����[�t���y���K�m��?����m�_���k��>�Q�o��'�	cJWR��i��5Z����4Ǉ)��Z�84IT����gח���K���x�=J��₨��W�D�VI��?��"������pX�z�i�������X�a:����7����6���t�ݷC{���*`�?|~ɬ
O�D6T��Y1��Ӓ��0���Օ������e��gj�K}wB
=��];�WL�k%冰�t�￮o���K��	�<�
G�:�H�Qd%��VH"�S����[��,�U�����I�Q15Rn�3
}�
�f{I��0&� OV�r����]uw}�Ѧ��^w�WC̻c\�=ò�0��h�6�Ғ�-�=I��+y�9�D%�O��M.�$dr�i˩5V��|\9�������V�б�2��֙J�r/�[��٪8����3v���J5w�X�����,J�Ō�Vj&`8[+5!�$�$��� ��y"whF`��Η��A,�f�_��)m!֥NBA�V���̜� ���ie6ȁ��l{z�=W#B.k�\IX�y����E���P�]n)"SS�O����ռ$��ȡG�4=8m[	�,�C��%�V�Ǉͮ�m������G�xG8	1Y��HEtI
����`�`������2��K�'��"X$�!ۅp�aL��4��~u����f��шr-�}��)Ck0��z�Cᢋ��:-����$�3�*�Z^�
 ��|}znx�eE�H=�w��<���1KV�p��|I��+�)Hc��/���n�4T�9I"�}���ڇ�H�1�3�M䴒�i�U��w��-��1�
�}�_2.v��!��*��{\?@�|�۩4��}s}��c�u����r��,�v�	j+'E��a�1R���~��GO��͇hҪٚ�L�ǡ���u�����g2?���.8�fQ��������o����~w�}�w�?&��L淁���E�ō�!y.�#�����Yt�b��ċGy�$��J��P�+(o�C6JB�E�g�����+�J��q};dp~@���Cx��VrRBS%��x7�0�}��u��ѱc"�$�aR�):Q�����n��pX�]j�����p���PL̛1W�4��]�H��q�Е��a	DSI\����ȥaA�$��8�@�gW�5���ٟH�h��幰�a	����K\���g�s�K���lyv'·%�����e��SY��a�ӕ��a	DSI\����ȥaA�"��8�@Lg���3�r�lIz��͛��?�~{��ڟ�`PT����׷o��]�c�㧘w��˫_b�8�����o���׉��lO�̵��~�;����d�g�����}��G��凬����>�wߛ�k��t�6}���(Q��t�u����K[��{�ūP�^;��6T�/rEdK��c,_���`�(]���S����ˈ�y�W\�����xQ�ߔ!�W��(Q��_2�d%��z���~4o��@?�f���/^�P"�F�#/����nvww��8��b\�v�v�FH��E"���g�V�݈��Dj�ԺuF@�3Xg�Т$����/�p��C��]6'+���`8�~J�g,���sA��c|�h�����ٖq����t̃X=�z�y�*��%i��������n�y����ǋ���/~<~�������8����H���$Ҭ<GߨJެ<���ЙΩ�;���n�.Io��n�DW o�9��
o��G�4�]����f{��.z�3C
��Fev��SѰ��o���]��25Eo�)�ܑ�G+O(�� ��y�m���]wl���/���8���H%���£���p'=���?&��U���O������Yh&o��VŴ-IC����=������ǉ U����@k�~�FI���;@���>�g6M ��M��T���$`�}�}<��f���SSc��Y%2��p�6ƽ"'�Y���Jc��E%4�G3h�eA��_]��/�!�Ϲ���g�� |�c�@յ����f�� ��m���k����̀�&�?�~�$�jS�f�'l��?ś]�!ϐJ^Z8�kc,��ꕴ�V�4�eoX%/.�
(^��{p��J^t�?�d%�J&�x+��/����e�S!ǣ�E).|;�q�{�����G���,RE��B��h|�(��>�W+�[���$�}���Na��ѱ�S_jc'cQ����?�<͒쯥u��`c�?"V6�T��iq-�	5Y���YI�� LH����B �(!���^xr�K+��?�>�6}\�v[t��:6�xL�i������4x��/�1�z2T�Hw)�TQ]��T�L���o�뙖Rȅg-��tAA0OZC�I]6o5Ռ��O�O;�����JP��f��0�!�(:Ξ%�}w�o`�m�����>�9����`��O���-����L�mFq3^G�j[,*���Tqff���4�>Ł`��]>�<[k`~��<�^��� lL�4D���݄�*�̦�tlr-9��XȤ�o���v�n�u��? 8��4��k7Y�z<�^�Jh,���ifE`�u�b\S�������x�?��僴T�lIJ��A��ƈ&�I����U�2�7%��ͬ��`^�d�%:#ST2yۄ9�N�S�L���BYBhIZ�s�]X���H�AJq�0$��y�a�n�4Ӈ"��2�#;d.�Q_�������2["�'�rLF�/w�$��;���ʳCu-a���Vp����H�l�l�l���*�7����̶����'4S.|I�؜K	;�CK�����@�s��3v,-��5��c֕.X��1*���a,�s��t��Vk�s"-�5��i�Zk����u"-��O�c��:+��\�D�i��(�;�z���) ��	{��Dk����6R�4�9�礰� :w�DZ~o�a�e�t6(j%lk��kX�~p�X�X\�Քy1�_�IanY��)ICw^?><l�!��a��-J#����X���a��!Ւ�ܷH��lIU���=�SB�bEi7�!د�c6���u7�CZC+J�Zw�e���sK�����2SPRC��謡r#��:�Ei�Ak�Ҹ��B`�R�H��J��wk���Xf�.I�;|s�6�!Ј����J��c�mЃ�8�o`OV�����y}��.7�����.��,Av�Bڒ�<#1�¢H��p��%l(��z�s��3X`��ssi9��NI�s��f2�-ӰFȒ���ݟ}��`��i���%!!�3ˌ,IL�Ʊ�Cr����t_AK����)��V�7�y�헰�T%)�a��E��� ��^7�2fy<m��Y��� G�)���H_G��b���h��������x%�I���+CiQr0pq��1��h�ɒ4r0Js���rk��T��#bi�``��څt�Wܴ�e,���zӇkc�	����h^F{��3&?�9� D�š�Q�'$�1ӱ߯�SMA� ^�K���dc<$"*��:Պ˫`B4g�A�p)$��3v.��0�%9�o>H�*�������?�}�[b���Ԣ43���(SiT2l�%�&�(��SWu)����֢c��C2y"�Z���ZF��4aQJ�9WϰJcr�9����H>=�>���w�kb{�R�C������g���P�A��ɓ�	�ۣ�li̦�����zHeO��%�re]PSęLI���V��$%��3�?ѕ�V�K���DJ�Qg2&r�����kfyIJ���1F����o�(���ZVP��}撩�K̠Uf�.dN�Ʊ�X��ң�V�d�{�d]%��?u&E�/kXIJ~n�L˦���q��fqXEq؟@S�$����Qg\>�\(wOv�l�ZI��$%�v��A�OԮ���V*�)IIx.c @  X�D�>�j%S����s��JGO��V����VMװ�Rb�y�*=�3��C�Glk(a�!����Uz<��Yc�Yu�A�����X��QQd>Š82O�J*�]��R�¿M�.�R�C�|qG�7 ��ֈK����+���E)�!Z�%�=4=��u籲\XnK�,2�ϰy�Z_P�j~\�5����7���̨�9��� ���ߤ��m�d���x�T��8��e��{QJ�b��S����Q�l��8i�bF�,��Y.����S��٥\��$B�g�I�WK������t+%��h�K��t� �y�~�o��Uпڗ/_�?'�         a	  x�EX���:{^W�|6�S����+){��>-c�!D���㯟?�_�;��y��o���?��������hk�8�����ںm��89������~�~۹f�ǲٮ{�kq[�ݯ}�3��2=:�y���潌���q8�F��������k�ǣ��1���awǛ�P�l��}�<���?^����~��0zeϾf�������I?_��t�m$�y��P����W�`����0��+��qǛx�z������n��⋏z�nH������`g�Ȑ�k�����`�w��	\�X�NNe!�Q�IwW���*(ف��F]�v��Xxr�6�@I�����]W"@�Uh�+�ؠ��W'z
�}��8�M7u��m��u��q�C4;���̅��_#O�=q�'i���φ"����Q���u�a��*�s1i�Y��2��#�ἠc��z2���Zϫ������Р5�{����vc�%����������iQ���@�����Ѣ���/�d4ֳ�ū���{'+m�u;|4εJ����C�Aݐ�?E᎝ D������d�I#�7�1D^���IT�ֵg2��� �s�`������-�-d0��f�Ew����s�ʸTQ�H^k�d��e�A��E��(�!�	N���n��֔�~1�O���� h��"ژeu&0B�!?����[�H�r��2˚��ؑW�� ��?
B�:C�h�q8����K4s
�Ho��:N���m�}�W�vڶ��M�PA��fϬr����E�&�h�e�d�63A�����U�ur�с�^�Y�`"�+P�� �݅3@����5�qoy���h闣��yw׻�S恀�n��U!�9��XN���G3 ���h����BH=���)�3�6{ʍ�:�?p.� � ��p6� �G^}1��@�XgW"��m֣h*XMl�ȑmN��z��xH�c0��FG�d��
(R��xQ&�^�`�£�.;`��M?8��x��ꍶO!��Ϡ-�oz���g���f ��e��㜥*�`��#�F�s�] v�Jj?�0�2w�t�i�Ke]�:a8����B�^�&�̈u��.2@u��`˂eG˒]B�=�y���:IJM*+��T�������Ɂr*����L �B:�ի�����
Fe4u��qֆ�G����f��H<���,�9��0ǫ����H�N�ŕC"�৚I�N���1�4865HL��e�s\@��b��a���̶*&��p�6�`��(���F�/ɡ
54:��x/'�,f�Z��gy��T(b�1�UV�<��q�N���J954��oZ���h�8�9S(?QI�b�y-J	�Q��,�J(�8GO�)3�݁�}N���UH/�I�dp�ѭ�����t�����k.&�+x�w۩�C�S1���`��V	�F� r&���z���;�38�+��!p:�:�BfI�..����W&Aa�S�T����<dE2��G��W��D�3�O�1Y���r�y���r/��SJ�伃�z����y��	����#dO>,Y��c��|����������R,��������sD�� ��b�4�2KQi�-�z6ˬ�����YV�D!�Mڤ�c�V�H�Gl��GZu����r���f
��z��ƅ�Xb��ڠ��e�����"ۨ���B� ��.�FeӤ{8�1����Fe�4�h�R�2*Y�[�T��~c��ŔD���Jx��39����*��{��L6�9*��3��&˚&���#a'��AvXX�(���Y^��،��������; ט����U?�ec��h�Ye�gme�P��uwח��xz+[3ʚ��t�aVYy�1�(Cl�{��L�'�C:Q#]�T��~�������*�k5��"�W�������'��W4���q@�k@s,���x[������_KK��
\��fA��gA�,�Z���C��������,�� �3~zJ�KV!8���-Y��pNR-���A�e��ZA�(Ӑ���]JH2k�p���%�:��;��(�l�r��D9�1$$�L�E?��fc����3��V%�Q�.�)8�`p�l�{�'�i���&�r�.��)L��mU]_wL��n�N�m9��b�SA۫�VWp�"	쥣��} `�Hl�T�+djs�p%�<�ͯ������S�*��Y.�L]g���~�Ň�Χ��!���һ�>��'{�R�%5�>j���+k�P�
I���+���7�ݩ�8���Z�?Ϸ��ZY�Ͽ��A�ѻ��8(Y�,h?C��b �gӇO��Bx�t����1�=�eA�� �<\��rӟ���2�*1w��`ۮ��+\�Bߩ��8����G�[���g/���ln?PqD�Wk��0�      �   l  x�mWK�,G
\�;E]���C�nL��L�Y���'՝Y��j�4�8$B�_4�(_l�~������yZ�b�8������������_�䱜/��आش���� 3��'z[2�XN��e$�������ŋ=�r�C�:8�U6��Z���^���6O��ld��쐟̃y������~=ӕ8�f��9=d�#�� �n걵I���L�C������y�/�S��B����I2D]�/L����Q�9+s�!W�&��Zb��8�5�'�0E��8�򡱺���@b$��wh�* w��O�~�Jʿ�6�r�ء:5ƌ2���Ef[��~��+��!��T�<d{ד�؋���]��e;4�2��c�6?o�Gk�\C�=�!%�K�T�ꓷ��&H*�<ɦ�:ϝ�L=|Պ��E��'�oxV�B1�J ��:�W��E�%��蠦�V��l� 6
��F�G�:juwQ 4L��x���hX:����8;!�yZF�'sK>|vyz���1���� -#�W!���"�qW�ڏ�@3y�c�ad0���}����������e����J y*���'��P|Bx�����X�G�(����*?�P�tߐ�"r&J=b[Z?Ŕo�a�-QT�eό�M�a�/y�B����5KLw(;Ą@c�O-��~l���P:Q6�Y��^,r���`�0�u������ȏXi��=D���[�E1�b����F&�kו�薠�I,5?!ρ�J�ŏ�c�T��e័c�Bo!~��G�6��̳��n�C�W}r���u��x^��F�1���./�
ֵ_�Dի���Q��f'�;�:���zr�b�}%�N�;�.I�>g,��<8���\I�(5���ύ K�W��k�p��D�#�@yJ�iHPvB[��c�W���lM������9WN��|����0b�4톼����Ź���к�T!��6|Cݷ�&8�������1����ܸr�����I8 ������&�N���J��u>[0��\[�~����&깧`�!(���v�k��=ָ.P��v&���������a�|Z̭D?��Ź��,O���>[M��(��J�������ς����y/2���Q-�~�O�zB���@Y�}���[ظ��=��B������>W��Z��N1ej~BX+3L���v���\��uc}Zߣ�ٿ1
ܜY��e����X�;G�E3��V��֬/�]��*;G>0��%�."��8�H�>aq6L��@�4!����	X_�\��tY��}*Y�H�y%�ǻ5�������[����/#|��B�U���z��a2����;}�k$�
�Vb{-���B����5iq3�Wb�3~�����4�      /   |  x���Ak�0�s����D[��R��(���^#�Ԧ6�Ĉ��~&q=zxo���|���HF��8�q�G1"i��t�����u9;k}k���Gʪ�I���Z�51bmX�Z+z1�����]�
)�c?��J� ����?�`��L���@˧�W��c췆h���Lq
V<�ct)�ÿ�׊�)�	�b5K�f����d�Di��|�� ���Ȟq�dQ1PKC�f�Z�����}A��'��v �Ѣ�{�T\\�C@�玟�?H*������^�׻�i�[����(�#z��z���§dL	L�A����w���}ny]����4ĉe�b��2�HWx�d1/�#w��4D|��}����B����=z�      �      x��\�nGv��~����w!��.}�`�J��X�d�Z���L���L�l_���? ��<�_ ���T�}f��!{ �{����T��b�O�#/>���L����W��	�;��ݪ�����.��0�=�rN�q�y2��
��G�K/B?�9��W/��'Ϟ��Q%�:��ݤ�M�x�Wy�.��q��T䏮��l��׺J�̹z᜼�??y�Ih����4ʛ�
���Hy�� �/g~�<R�r�A_��/��������g�:����!��!���3�M��Ϡ�>���W����7�`�z�������Ro
m����E��x�����~�$��O�c;�ˤ(�Bg��j�����4�e����E�Vy��E�UN��r�J��:Y�*�$�Uvv�Ԃ[�i�J3��6Y�7i��#s�&_��{jBo��4)gW�o��l�f	�ْ}���b[��$YU���x����uV����]'�Hn�lI�ێ��Ӳ��2=���=zG�j<{T�����'�1.Y��������7�.W�3��i��M��-�m�+]�&,�S���k<�v}"a��}�^�U2cv�H��UY����N��Ih��Z@=����4pyo�.��K��i��*�s�ӥ;4!K�G��fҟy�T�)>��p�7=J��#`��󳧎�W<��(�v ��s?�A����/���g~�d��S�I��4/�l���½K��~|��i��\�Xi�y(C�8�x�I�$�'f�w�(V�D��p&㙈]�Q9��m�.�����g�0����//_Jƞ�0Q,	�+�"k�t���������`�+BnrU0��D�
	�F� ��HD��v�JXZ1 XR���$7p�g<p�Qx��� �����ւ��j/�xT�8R
����ѵ3x�]$[��=&}+�yQ�k$�*]^t��B�{�����3�f"tcD�|��W�ttq؛��N�0�\�J�ȣ}Ťu��/:z�q���&��d��e����ݝ��Ѵ	C���4��9/�B~Į2qt�I�NWܻES�cV`dғ���yi+!<���_ի`m��4��tYI�;}�:�Y ��	?Ƙ��B=e���t��⬕fwz~򔽘_^8sj�E�e��x�WC���b�X]}F�H��k@7 �l�������M��ȭ�-�Ui�G��%,; �XԤ�K�K�{���+�E%͓�z�LM��B�(�_���TG�6l
�N��z�]�v���n/�e�ie{�vI�h�W򨨡*tV�$Ea���v�"j(�"�*� /R1���/z��w�M��#��A�B1/�)��+�+9�\�,�*���
��������ų���9���V͟��x����'ͼ��B��E�ݭ� U}����A��J��@aP��
ݟc2W�.+��5}�B�0~D� `���H樓Yr��3���9��'\^ȸ���	�Ơ9�d��5��@�4���B�Ƽ�����t�o�U�S����E�pǝ~g�ཉʓÂ�������G,���b�>�U�;��A���!.cnf>r�C�OA@����j�aN��8ؚqx� p{��=�@��^��J7����+��R��M�%��b�\��,��-s׋0�b*� ��RI��Q�lvؼ\��}��띁oM�0RI6��oѻ/����u��1�$��|�x���%��m�`'�U�N;6�H��
�%�����JE{����ŸI�;9(�9�;;o �Tg����a-��K�U(�'�ǣ���I'5�|R��x�(��G�q<��� #�(���TC0���{�A�brL�ǀ�|�0 uL�,E�C�>��7�k���Iz�}(����/N�6��8&�rt�4���*)+p`���u��J�	��A�x��$o�����M�cI5�@)F݆��3�]�EQ<TDC&����{�F��`����t���������&�?�">,�-�`�}{��~L��5Q������(/��Ub�k	"�D�'M4����^��$����vP�� ��n�/ݓށB�yq|�w�?�D��T%3��1/��.���#�j<��[�ֈ���x����<&<�������a�/9�	��D9>�F_�[�b�z $���G��R��M6�v�5�ұ���4�ǌ�M)�]Cz������U}�mq%4��y+�8�Qc����*�QG�w�]��Q�=�d�H?brx�
l�hJe���]�ِ�7'�gs[7��iN�d�(^����8�t"�E�~>���?����=!(��/I�76��LG� B�`%��oB�A(3*mC�lv�w�;�Xn�(��x"\al�%�!�D��p�Br�!bN��	f<v�(�d�AKhV���)�W���Gk�u��Ar���`Ө�L����o�(M6ND�0�$j�}"M����}8�ğ�3k�Q䃾+�Nٳ"��̐nb�^��Iզ::�ݕ��|aG�����H�k�D�{�N��V/uko�
��K���f��K�#���q^Wkp�o�_@��f��@��U�Q���ߌ9¬��09� �N�����lIO�%���l��I<�ݙ���"A7�mN�`u�$���>G�YTi�G�]�y��>�ot9oҚ��ěMf?mf�R���4�K��D��|a�PG�^���	s��v{Ds&�1Ep��qv$�!o�[�� ~�H¨	�T���� ��i�����M�H:�-5Ř�����=�m$���Q�J��_�|~�����_<e�.^>9y������e/��I;���_�U�N�G�#��_c�}���ߪ��\��ns��$�����������k]l��*]�4UQ��]&'��:%�xdJ75hD���):�yZ'��սf��Vv�2������iŖ9���"��g&;�"0��]< ��(�F�l:ˠJR��Q�N���$�ۦѤK�=[���9�&�cR%Ozx��kg����iD�V��F���E��Ĥ��j��w��&em�V�Y��nI��I� ��*SJr��1T9��e��!eZ%��wӥ�A�Щ"�7�ܵH*m�d�5�O_e����UQ�O��b]/)m�-r�2�cb� x$�"��G��>���lO[��h9�������~.�a@�x��}��.�� /��5F�M)�v��V7�<؞n r����͊4�
vDJ�,j��D�3D�Ii^5O�噫,2�E�"c諴����<���3�ݒ�����/��kֿ�l�i��C+_���3�F��#h�/'�7�e��ٜ��B_�Uit��h��=`Ҋ������dqG��eSW���Ĳ�e�e�ݐ��7�AMO�^p�e�7�ip�P�b?|��P�5�Q����u&ۺX�(1���߂p���X�z���	9��ϋdKUAwi��7�l� �;��M̨o�dӤ�ڂ�(?��HMR�7%{KJW4��?�#�ě�b��*�Mm��s� taa�Ѥ�-�%��m�7.�n��и�������`DF �Z��N���R�-AIAP�*2D|�L�?��v�4o͚�`��0��0i飑�afP���'9��Z�c˴̯���s�E��0�����f�rKCqUͺ��%�NI�*9�e�!��)����b*��� ��ta�%����@�@tl;��_p�k�ƭ�n�F��@��5�ም�@�p4����VY�1$��(�����*�C�1�F�JXWB�c8_׻��B�J�E��:8��%�`m��٢�n�c�N�����,=!CpSzc(�]�a�x�hn[��zDd�e���\$�%{;D ���7����!p���1�����TՐ��EH��m���%K��]��o����让��k�p����G������c��h'm	53��4#�l����9���a��S���kN���<D�z�|��I�^�������m�M_ղ.��΁� ��|"�a��E����E�V�$¶8th�Ĺ|����/��뗯/�.�)�#ULQ=vZV-�>�B�'y�/3��\N
�_��&=��h
b<.�,�'��m� 5  E����r��R��w,�ehg��$X�.��0�r ���#E�� 2��U�,:E���M�&(�M��,��B�0*�?�k61j�s�v����0��S�=��@1�'E�g��(T��-M���4oY!��p�i r�Y��GDy����?�����H�R�d�ơ�y�P����Wz:�ώ�<~��1ަ�W���;�_X�{���C{���M��[�]� ~|_��w]�?�")>���]Qց���FXYX����W��ˀ��P^0��<���+n�W��&������6/m,E�!gi2p��U[<�Y��+��g�7��_�Ҽc��mj��U��0.�q�O��;6���)���"5������Qd��F��G��"�G}|��uZS�0����V�z�lEX֋���P�M$�F�E�f#\;
���u�o��#��>���%�G�=�
����;����0��E1q����o~� ��ʏhV��ѡ�hx�{��w�;�"t)d�1�g2�)��h�`o��\�f)��Ͽ�Ҏ�m�[��6{����d��:��7mi�\�I�������5-d�ϟ?g'�������9ω�jv�6I-�Ӱ�0������/�9/
�V�xC�h�x�n�C���?�����W�y۰�a*g����SM;���V=�GDlH�-,�Dߑ�u�M���}��,�`�P(j���A/m�¦E�W������Ͼv�']��*��\?k{Q�I���~��M��v�P�h��Ь�#�K+��I�]� ���ټ����3IB"$�8R�'m����4���n�L�r�onb�ݘ7M����>z?�S~�f"��ƃ)?�����N
7��vc��4,4i"CDC�!���{1���te�W��.���`M�B��ؾ�I�;v�8/�(g�/w�m��J
�e��
y,���墾��)�	e�7y�<���(tw��/�I
���J�C�@�Py���D5����E\����uU=��/�I*�t������!�z�l�2m]k]V��vsT����:��)�W{��r�M���@,fع���7'���S�!݆���m����.�aě����x�(&�	F���P��bm)��@�h��:��fDb	�i�r��BR7�,;&��? ԁ� I�WZ%hrk�dX�%�?����
M"m2� H��=��yN�`��b����P�m���^�[���h���N�"/ۆ)�>f��_sԱ�IZ��u��Nr��i��MaoH,����88���
�ّKA�qʃh�1|;���G3��N�žYl������8��Z�w�'���k�p��+o�g��ľ�"x��(�t^�W)8��9�)�D���g����?
?��۵A������{��#b_�S�GĴ�,T2��o�a�_w�@
n>t� )7 �n	�_�oa4=c�|��
�ƴ�qFw�	�W�NGڲ�JF�{'ф��l�A��l�G��04Žf�1`�KW��R�P}�� ���/�A��ރ��&z�G]))���AM�1$pC]A89�r9~r��Q��9���*��G?�n�PwD'i7�_�uR:�$�ٸ��t�� �zf�������+:2)��C/\%�H��"�V�H�@�Z�d+��V$��"ѧ��]2�y�@�F2��P��R�ر��u�8QS��Ln��:������4T�ŵF�mb�`���W�-�p}2���u�MG|lǒ��B	�(�a��9g������̣�eh>"�$��l��]���s���N�)��?T���~���v5��𽮳�7��+WR�p����P���uN[C���:>�FU�?��&��}���H�wc�bJ	���"��*��QQ<���=W�8�-k��/A�� X�i���\���nZ�����?7\���,J�[Zz׋��+�7���g���~�~���w����m��{R~��9:k��O=z���0՗E̸O.@)�{�?P�E<���DK�?�{5���U�Ю�7S�Ս���3��'OBQ7��eH���E  Z��|?Db��wc���uE$6%Q� �A~/��U�q��P����ݷ &$C�҉��� N��΂�""A��n�& ���P�1g�1�~Y��J�X=�Wu�K�xDT�t����a��	 ��+n� �J�Tc��6u��'+�@8þIҲt��]#>M������C��I3�@��%<H5�������eɆ��!�O��$���xpq�*z�.�c-
:?v%�y�T�A��FrA����]��x�����ż�z]'3�駏��t�}��)��=�9�!#�zN;�[i}�jA�7S�+�"�,�A��ik�S��;g?ih�sM�=�J�+F�Dq�a�9�!��9��tPB����-_w�j��ٺ���Kx�ʤ�>xx)��dn>-lIx�PEB>\D4�{c�E��q��R/��8�3=�y��R0교������!"��(�	��g>b��$�?���]�P�h�8�����&Z��]O�Q�9q"u������;��S���0@J�Hp��t⧶���1j��:���Ie�yxzN�@`�	��e�TWz:��D�	,!'?��Q�s=�DT��+�)�8�:~�aБ{.x�ƨ0����%��c,�@;yL��a�JB����t�܍xL|�˟AH��?/����V�TY�^ɼ�lt�\N٪��s�PJ����E�/WYc!)�;5�����u@T�,�bnD���͏�`N��������ք|�U��5�R�ϺR}s0Xu�i^�H`�4^r����=��T4��ї��"�dI��b������>F����a����5��Fn@W�QQH�+�8Q�>�
�~&ȱM��v���#��ɫ��~��m�?v�(�|X�����9��9��9A���Kg[�{֭����W|f�'
yחa04ُͨ懮�����?��E�Ik"���{Ll�ܩ�b�%#�Y	G��}+�H��o�h`8�-����"�-"��f�}~�>E���XpX�~)HN$��?�m�♅�z�^o��=c��v�\���Mn�����a|�r?���z�{M      =      x������ � �         �   x���D!�s\̈�@/��:��ē���c�����Xv-/���
��A���.2�C�8j�T2�m^J������ZB��<�b�ؼ6-��e��wa��j���Fo]�Gw�-O	�i]8#4��?+H'�      �   �  x���ώ�0�ϓ������c�*-G��r�@XE��K�+��3N m�¥q�ɿo��8-�(��@`�
�wH;�s�\0�$�*[��h2�}x9 �`H7L
��M>���[�m�&"����܇�� ������??u��}�^>���K�T�&7��ar��B�s 4KDU�&�xIh���o����x�~?�Ŝ�m%��0֭�>ĘrڔȰ������ع����b=FuS���lc��S�iKB���
�d��<HGUY�	G#(��Ȃ��
j�jQ-"�X1Ж$\�o���t>tGK�����4H��(ٱeo��H�Oɲ��N`�e�Q�º~�E�un�(gْlj��H\�q=�5[�kS��p[�M+�N+2%�\��|Z����K����ӻ��p{wg��_o�eƠ9`�bR�1ŕ�T���,~%om�lX�^�޵���]��B��~
$j�yK����蛦�	ZR�      �      x������ � �      �      x������ � �         �  x��Z[�۶~�~g:��w���&q���{K��	P�XKn(��ֳ����EJ��L��^Q"A�~�s@f ��o��NWn�>)@�8�� .���.4��g�O��w/�������˿�?ű�?%�<J�ꪺ���O� xqqw�wk�$ޙ�3������b:/�Ms��$�WEv5��%7�O�U��U՛�ɬ�T�{ʰxW�o��yU���$�g�p��_wV��eϪlC���{�q�Dx��='Fe��R"�g���G��e��2��mF)^�a����Ŵ*�Ȫ�����Q���m1]�:�w����Q��B>]�=k����r�Gs�=k⶚O7�{��2Խ�)x&���y"XnH沜�3�x�s�ɳ�GI��j6-� }�Ն�ͅyǹ���wٹpe��r�δT�H�6&����(Me���vu;swWo�>TWo����j�Xfa�}O�2�i�	�9��$�Mw�dզ�7E�
��Y�*��h��x�T4l4�l�>�Bj�{�$4��r�F�q�xu�z8�%�՛�tq�\�dhG8��:�f�o���y��d<K��o��έ�[��gӛ�cU6�㢞���Oܴ��u�e��W���}�op�C�}mGn\������:��ӷ���#�\�{�/���M(����&�<qٴ�W����3F��*�n�c�Ig�9��ɴ�yd��on��ݛ��6����t��d��_�"4��g�3B�P�P:bv$lj-5�aTl$�H�$�L1�)3�.��]=Ml�$��`�cl 0�@p��)^�t���KLt�P��������O^cv�����&GL�$O�[��Nq6�Riځ��$�FYO�	�͑>��H�MB���d|��~M������H��!��<I�Z)�0�!�B����Q��H�N�������i ���|����>~��^j�MP=`Q&)�ǥh�
�T#���W�|�u5�\��q2Y�E��sK��` PBQ6d?*���QX�ϾZ�L},B�q�v�U���[�J��W��HC-C���h��5�� ��Iyj�i�(Y�ȕ�F�x_T1hQ�"
U��P�@#9՘=K�R��#CC�!�eRU�Y�|m@���Ѐ=��0X_\��?�Q��E�T+
L�u`�Zf���B���]��7����?�J�h
Y�\p�:�y��i��� G\�JJ.���2�9����K�f��7���Í��h��	�"'��!S1Z�̃+��r��2�D#�Tф �n��y���ɵ�1�N��Ec��GgO1�%�C�p�2��Uy�ĳGg_Mkdu�I���w�"$ߺ�M���!��������G�f�u�k|;�5?6���u0��}�s���w�e��N�p���|�ڳ�WU��!y�\4�.ݬ�|�ど��tq��/��k4X+��EmM���b\J��[�b[�W�Q���:{lB̦4�}��)���ޡ	�����!H9��䏌�����ҭ7T7���o8�)3x��XɦU`0z�� z���P���E�<�nnga|w��� :��Ux�eH�j�7�x�v�����Z�w�L�i5oAZi�?�i�4��O��T�yށ�z�����[�:���͗u�|� �jso�VN��1�O��EC�(�tLw����	ZƓ�`w�5�lT�O$�N$?D��������6�?x|�-x/{��N��A���>F�cؾ�����aBf#n"���*�����kʍ��J݅ї����4Խ�b"��ak��n�q�_�E�+
;qX_��;qz���&�f�K�	d�a����p�Z-r�+�ȷ�p�w�Ӽ�飷g��p(|�P�TƉ� �Р����Ŧ��]x<���._�Ǔ������c���ϟ���Vpq�|���>V�L�h��:�s�m�Lp�Y"��I拂H�ro��Pо�_���,k/�F�ǎ=^�|O�G�!�
���0LY	F3e�P�
K2��Z�òJ1~U�?�v��St$�m�iF���D�[Q`M���،;�ӄ���%N��3S$�#�9ς�.(�K���`�X���D���J�ujN����~q8M�{�꨷�zb[���ZhK��;���x�=��J�@O���1�f�s,�O���n����(OkXzk�#
� B)O�p�(.�"d2w��V,w�4T� r"rÈ�yN
�����C���bk܊�P�ت�ƭf-3 %�Z���o���t��Ƴ�kTj�cx�@6��e��߅��2��wz���хEd���vP��	$�����V���58���?w�4�舚TjB��`Gy��_X;��9�Ef1
%��b����L쿰�!��b/�AqqW��M;���>ң}HO�d����c��o�n1��&�n�$$�1	Bi�R
)��y�����
^�u;�*�`�E�2�r�/����wQ�͢<�6p:�����80�g��3L���2�I��(���ɣ�k�-��eQ8�E���<���o%�hrR�+o'VX�����Č,�����E��t 6c)xa
�ֿ������m!�+H��'�fh�9W�yĉ EV��ٲ54c���ш�2ω-��H�8���ppc��GeӏΛ�� �ݘ��vS�X��~��':��,��E���v}>ԕن�v�G�ucZ=�V7�i�n;fW�C[�k���c�����d�����+rЄ�e#!S&����N�1�� �zI33�f�����L�f������n��g��Ħ��Lp*��u<���o'wK���b2�۠�f���X�\TZ�7bDmj�2��M�������Ľ���#z�>�
އ*L��Q_�_BB�ve����P��p�u0�й�;��/��b4u}�(D|�J	wN��S��+� ��D���9%5���@�9����g�6�omP/»v~F3�)s���N)b	�o��~W��T�����VJS�c��n��䡀BYNL�Q/A� H�q����}z1]��
��-vH+��v���W���,����͈�Z%e�<͹+؉��-"���zT(@'I��N�w�[�X�}��=�t���oQ�3�y�7qӲU( <�+��v���/�F(r�����āPr�
Ϳ�A[䈨��By�5�1��14���v��2PXBĮ�.0��Hni�y�xp=]�7�`�3xb��hQ�<`}&�W8�j^@f2*8djN���nk�T���6&�R���)L�3w���ؾ�EX��c��� ��S���"�x�`���
��7/���`�P���œv��g��}�v��T�U<����T<8�6�]�c�|���;�Qݠ��쓨��ܽ!|q=�O�3��6�*���U}�hY=��J��҇�����;nf�����P�u�-1�+��#0�U����m�	m^g�&��J��������      �   �  x���Y�H@��)� %�K�2�?�ءB �J�Fʟ�wf��ApG؅w�AAf�!o����R�;�θKVT����=��𭦻�NgY��N~��.><�DW"����jH;��sZ�8OBk��A|G�+a#SB�x�@w��bRA�&�!��˞�>�)BW�6���>[��%xe�Ӟ`��;�^�H�\; �g+���������9l\.���+T^�HR�3�X_4���U��P7��`j\%h�$�\Hж����1�A��Nvc�<�lGw��L��a�(x��w�n�J�&� w�4V"Jd�TV����a�C�9 }Ց
PC�;� Q{���=L���&� ��҂<┝�~&��P�XC$Hx�jF:W#�Q����!b)B�ID�(���?DF�A�K�|��? �w<(]V�<�(E��"��t��"V��PpI�Ix���HJ�A��� �&��
V͐=��nv��s3:�9~ �A���sSj0��ע���Ç���W�a���"<}�O�<��@�`qH�㼮hW������{�}���j*��&��=�	~D��Z��L�=�Ci�ե��p�80���xi �ĵ��R���~q��q%�6k���� |,��Zı��7���M����l����iU�W�24]G O��]d:���Z�	_��#��� ĥ���{�2�����x��Si�*�2�9�+S=�}'j��֙Xf��}J�x]*T���@���A]B^fD? |lxX��p	8C�^��(�3[�rp�wY�`O�^O�z�U#�*#���U��~䣓��V끝!�N>��T1OO�)�D�O��z�ɱQ��1�����D���iB�@8�b�i h?�^��_vDq6���f�Z�P˸D1�hv�G?���k#����$�            x������ � �         �  x��[ە$+��<�	�-��|�d��}nݟ!�� ����?,?$/-/��R�d!�?� �����⺑����ٗ�o)i&��P}Iy)m����(��V�>������b~Iڈ�fZ��*`�K���NU��*8~[�n~-"���Sz�oՅM���5]��&z�o��� �e��`�
%��wKr3Wyc��ɾ(; �� l?D/�
�E(Y��%y��a�2n��4��I��Ԍ ���%X��Ni��O!D������8]Uc�p��$�\�"�e�N"�9��b���LyᔡAW�lB`��-�;/ݺnM�KQ��l'B��W��_��������q\�N���`�nNIu4;��u�<�V��_V�c�|�S���<�����׌F��J^H���u�kKS�!~�b��jЂ���{�T�f���m���J���-!g�	��T��bY5�RD���X�3�a�!�q$a�G���l��v1B�s�$?؋D�	n�2�1~o�U�ğ�!��2��e5y� ����s�K���@�Vܪ��� >��˖����7��<,�9g[p��4ԙ��@�)�oǊb��7�,�0N�m��m~�������[r�e7z"�'����=�|� Ia��P{�כb�/.�#��G�Y��%���I��@ T���$���.�� {%��jV�d_ ��,}��Ud�$Ǚ�d�+>tBPpX��?�aD��&SlZ���#��r��Q&x5":�Z��䰃���FPhSXA8X�=aܘ�Fx0 d��D��l�
�r����豰�RnZ�KY�"i!6�#�̄�I'a�ᖑt�s2� "���n�=��H�>N�;���"�x�Ԓ��STl��.�܉]�YE��u_�rW��� t�M��S�����m��6���������BBH�����-R���"�&�-�"�U����#�M2K)K�H�OX�!"��'2�{��p4���)8 ��S[QO�l������瑾L�΂
��X5$_�uk����<j#�$�t�8�K�!�SE�I�k]A TZ�gZ�-!�����k�����O ���(�4Ke��!������V�=��Z��J����אe>��$����D�b�o��"�t�d�M"@Q%�.̓)'Q�g�0��F��x�~�44�G�F�8�9y�DMz��������A����5sD	�~50��q%�����v�~He�mv�)l��R' 	��(�������r���H),U]K�ݵ��þ�W��'�R�"��R�]��}��61V<;�MD�D=��j��)ȷȔW��V�����9��+�}%�3А5l�d�!�P��˜fP���$=(���`�a����`���B�M�g�
�p�T��B���#�5��DCC'�c �G�QR�����@/�K��(�(B���`�������@��5ߌI�7KTI��g�C�x�^LF\R6]jw�D�3K�uV��K��'DhQ�o^�"��Q���Z�e�����B^�pe-^P����y�A��lc�{!���2��ƻB�PRޔ(�G��QO�:C�g�2�s]A�CpJ7��z2R��H��@�	A3D	-Paѳ7~��B��6��7k��|�{=x��Ƀ��H��A(Hy!��W-_�gQ�ln%�BB8�^�Y��q�6f$�z��vYp�3d�$�A�k���n暬,!�	Qg-4vBS�z#D����BRlF�<�]����/	�����>U�j��^ӢW�l�j�c�;����Ny������#�u��O��L�����kJ�Q�ӿ�]�CDQ�c`)�r^�>�{��4��œ���ν�����k�y#ch���J�ҸWǔ�"mc������=��%Y��*�v�
�o:qd{���?�q�݈�(�����/P�v7v.C��%���%�Wh�^@��"��-���@���ol��:�a�6��9��#!k�-�J��P�/��5���&��x%"���`�q�[��՗"B�Q�܂[�0+.�t�݂�&d�h&W�i�!�	�7i�B���A�q�[����b��E�.��o�7��ѯ��`�k.77��R�3�[ _��v'�a��`�=��s_ߣ\�l�����K�L��� |(���(B�:1l��)��E�������E]��S^��zč2#hp"-\V5uF�J"���{�8�"�G�\3e^F?XrG�	�wD([F�z�p�'Gx�v'䂜��d���W싔%����3��#�!F�+��f����{:,1L�I�{џ0�r��8����ܞu��/�������1�A�Z�Z`wm;��9cCZ��'�IdZ[to�$�����g�=�S����("9�:�w aH�c�a�;tZ�F�`R�c�G�+E>,A�PF]{�VDȌ�M^�	ƾ�Gw��g,Z*����8���G}_x�����ސ3s�]�&"9z�ʳ�~�������Y��:o�MD�=f?�c�c���0���c`c�TZf׹�H�\˼�a�ky��� ��E�|�1��G���~�F_�<���A��~S�{re�7��2�)ʭ��RZ	ӹ`l�܍Z�:<��x5�+ʩèR~�у���`�����1�U����<e7�K��]W"�=���<.Z�ў˓L��2�k�x��ޔ�D<o�(!�C	��y\��9VO"K;�xh[��!F}`�"�r�q���y�V"��o����q)hq������qHA8� 8&�Q�����7���r�0�A���������i���-Us�Mu|�G�"%�͝��JDB'�pZ�����Xkˇ$����k�x�@�K��F������Q���~T����aŊ�ˌ�R��C�Ʈ����;2s+�Nȡ��cWc���+jF�|�&�k�C��\`�j��8i͐xʝ�0�F��C���]��8ݯ�PS-E�,W#�_`t5�݇Jc-�ܺ�(���<�âu�ζœ�B�qP+9��(�d�!͑�XⲂ�ԡJ}#��Þ��]��A��Y��0����ވ��ȓ�����Q�q�.o��XO�ţ��'��=���#	i��������E�����)_���rnW��
U/�G߈�nܕEF(:���)u��>%��6����jl䍈����p�Պ�;s��o�۫��BB��?�����H���Vz�]=յ��i���؛µ��*����(��n��B#�R������"��E�=0(�D=��ߊ(�}s+M�ŗV�eDz����vX�)���ڻèY�,"ή�[��.�$U��<�������;�?l:�� �k��yJ�w4:��[2�%-E�M�?�]����;)�PqQ�����<4��h�zm��MD��+����f��m��/E�kk�Fa=|�m����tEFQ{q�(��nVRk������Z����h�A����x	_ӄa�
�J�YKN'}���q�i��,�h�O������a��A�0��T�o�<.7r)6��@��H,%��Av�@��@l1[�����^>bD���H��.�<��{
۲��h��0]�մ��������$� t7^l$�Ԭ��P\]�g��ت��l��E�<@��ўPۚ��W�"����52�_�vD������X�npvk�m_�5M�+nGEn_��ET� �4�n�ǐ5��JԾ���ʾ�gi������$�q�����"�-;�ֺy�pп/V��$L��OEr��(�jK�~6=}���B�@8��oDT� xV/7��]����$��S�x��6w�����Pc$����,D��L�Y�����a7��������y�E�˸2�`o�`�d����H�x�Ӆ]/bF��
��,�?�wmdĆ�C�f�s�OK�+��F<�*����Z����\�c`���Evm����}�랟�            x������ � �         �  x�}Z�n�H]S_�e��D�z�v��Nҝ8F�΢��b,"�dHr2������^0�3��̹E���ZH����sYU��sȤ��L��d�R΅(�%'é��e���l���)�]^�?{}�<��j�?���ڜ�\����������*�e(H��6�7�o����7�^��z��\�|��u~����ZfF!���r�hZuѤ���ܨ�k!�9M	+Hfe��修�/�vW��w����.�X=~lb�$����|N4WvN� C�©����rU}�)��������{B9�}qu&]Nf.<�
KV5�����U��ܖwU�ʤ��4܂�y�?��Qs�����N,�+� �tr.ޥ���օ��"=N,���ne�&'�_|:8�]8�����g�3R|�R�䔭Jpcyj��n���zqv1�	8�6D�==�bN����9�ʨ���VZ;��.��n_�"���rp�B��py&4��[SA䕦~�p��0W�0��gY���ê��9bh����= �Lp.#�|�$ԩ��m]����ҕ���8�1M��	I�e$cy�>=!3W�Rh���*?�-��S��f��)���\����.�\P�u�#��됒�D����u�ȥ�pס^{K���\�]������q�� �I�V�$����^xi�Q4R|���~���m����i��/4��O�b���n�Y����cYj9δ!���Y���*��l��8Q[8���n��?�fV���q�Y�H�]:N_�S)��.�s�/�lV�'/�?�\�KP����a�^�ȗBiB�.k�Q,��P8eM������y�".�4N����yH�/�0AL�����6���tГ���|~Nr.ua��N��B�~W8,(��U�#bX?!딑�	�)�u���H����(�cC�;p�3/�ӬO����
�����C����u��<� &/#�T}�5!��fk��v�H� ���^�o���3���ziȯ��g�-��L�]�4H{<����m�d�h�U*=�fc�@X/���b+#*[y�^�Y�wO��sOa��^Z�Y���٠Ȼ),�Fx��͞��=�,ru�l[byfYH�,��(��"�7G�hԋĶ^��Eŷ��c�?������4
�',�����r@}�7��!�*�w�m-xZ����s�'�696�	�IT\!���d���|�7�j[�q��z]f�o�d���M�C�c9�D`/q�x-�a�5a�O�]�%�k���#�A鏞���0Ԟ�]��]z��6��QE��I=�M��ܗ��S��h��J��4�I��[w��6u4Z`7�)��7��SY!ǒ8�JS5�3�:�vNMT::3a�^n��zW�:�*omYzfR�/��_Fʓ�6�El�H!}��s���ͤɑ��0j�[(I��IM��<�$Y�u�=���c�i��I�X�a�rSa� y7-����/0(�w�'x�kP�jY~���g��={��q�Z)� 6��ꋯ���*��;|���2l��\��f����-�7�c�1�6Ҁ#��`�����mYd��C��M;Aye��U�\��ys���6?��y�z|�G�q�xM�Ͻ#i�S�`Ɲ;�!���v��K���r�y��Y�<���@�O��{q��V��qW�}#3Z_�>Í�zQ�<��]��6��;K/%��ׅ�PIy�6���Ԏ6���oڔ�e
o�Pv7��#�{Gֹg��*Y�U�[�A��Q�FAc��#B�cܯx��Q^�������^W�+�6�O�ct�C�s���pMӦ5�m�"�~C�g�ڧ�������D�4i�3��窓�hGPk� �|E+��\�RJ66	 �"t�p*��F<RN6y�^��������I���0�Y_b5!C�����h��Ш��/���E3-R�H}�Ǔ��c��>85vA��R���C}���/�2��M�IקQt*hY��C�M#d��C�)?���5("�F�ΜX�Xܵ���P�N�v�:~�����qP6� Po���t/���#Ǣx	2{8��Dv�k�FG�;zyѽ|3b4<e,�Pf81j�m�qVY����@3�*K*�\��"�%Dv8,�`Qh�qWo?�}����6���Zk9<+?r�hBk�rH-,}��F���I�9P8��(b*XA��k�q3�C�t>���i�m����&�Z:�������K�*���(��8b-�8`3�B)Iaq1wq���T�\�u�2/��H��9àLs�^���hƻqX�_�ί�߽���4 Ś0ʫ�`M�'@��xW-�E�m���i�H����<�W�� �AO���o/��"ֺb�N-���B�n���yd7:b
n0t9�4x���H�'��Q�>�ts�y\�.e��V���s���tVS�SK���m�f@ytG��JeBc� 00dEH������؞'u<�a���f>$Oǟ�3ښX��'�7�qo�i�n�����fB��
-���N>	���hA�AG�_,2��-�&Xo���s�P
ê�^���K �Y7�ӱF}\�G���ѥ�U�f�,׋]U���6�GGA�0���^�o&��K�_��oT=��Yקu �o���Q8������������� \=���p6&E�|W�Ef����������������. ?8(eg��(qt����Z:Gsx�,�w��E� f���ߞ:CLg�M��DV4>�Y��5f��ʲ�4�J�Y����IFr�f�Ā���������ю��Z�u�I�I�y�c%z�x�s���a�B��D�C�[xLPXq߰"[M�9+-��tŰ<{�d©������a��~��#L��͞]�`�W^�	K�}8��+GZz�:���\�e����tr
a���
gO-5#��բZ�׫��e�{Mb�5�t��{��!܄kvGz���.���\���($�i���%o�lr��������5أWg�#�R��rI�p�zm��7?���`S�&��g5����m��5Zo����S��H<��k!�P_ �7����0�_HB�Gq,�@i)���p����]C=�l^����U�?t1��Q����ƚ� ��p������jde�9E7�@�#�=�n�� A������?u}ڙ�=}1<Ceҩ�v��?�̦Ѥ>�Yߵ�([d�--��j���a;q�kr�P&|�%Id�1)���8�t>45��W}�ui�ؾ�lɞ�w?<�V���^-����9�����>|%R����B��<�v���c�8�
pK+�|;&U�ݧb+��@����d� �:t���Wt��k���eOSp����Q��G��J�R�Ū�ts��ʧj�E����/��]���,�8�±q�Y��?�ѸĖ��Ӭ���"HAZ�Z:_U�`à��	�?��'T���.�Pp�LFH7?�K��	m�F���y��p�?�,��$Iq�\o�{h���'��~r�rpe���
zE�{'|�dTTm-P�/��|{hVLm��/�T�/�6~YƁ�0@�?G�B9n����j[�9�� �>�G)P�Ҧ�|�xo��>�n��h5ޗ_?U���RC�m�(�x�>xy� ��*80Y
$����'ž�P�{_)g���G�=�V�J
Ǎ����Mͷ�_����ԍn�:��:���sx�x�c1��0�:���"?�a�R:����f��M�      �   �   x��н
�0�ṹ�.�I�g���K��"ȱ�6h��D�^���q>���OF�r�i�i3��,�������ܩPp������Ir2��:c}�u�r�	�n�T��pŌ@�i��Hi�dH,8�"��*c��k+�U�!b�m��]{�icg�}JZ}}K��<t�7#\6��hD����f&:��ȵf         \  x��Y�n�8}V�B?`��K߲i���&���X��c%"K�d#M�~gH�N�R��&5���hfΐ�#���]�S�ۏBT��%�����M�Γ�p�1|��a�uOÏ�?���{,�b�Ey\ݗ��w͊n�^��=�}��PG��G������B)3�
f�Ⱦ���+��$9�L����\�����r>�*y��"c�`JY^*d$�`d����ɯ�����/����u��4���D&i�La�����ɚ�C�w�7x�ε�M}x�֕�. ����a�P����|s���`pZh�m|� K���Lo\�.�!���_ȓB2fK��|U��)�{ӟ�;�ǟ�<��c�";�,1J0�K=I�Q�ȴW��_���]�{3���t  �\y�J$ÜO��1cŴǣ�Y}=e�/.�q?=R���Ș*(�"��HCX�;]sW�$�L�ók�8�(�Hz&
b�E�k�8�$�C�G�	"��-��� !>9� V�,S�2��i���r�<��������a��索1��N�B0}sdѮ���
�n]=�m�ȡ]��q�@Z.г�j32��5&���M�u}�m�n���2&e�Q%ؘD4Ƀ'��M������G(/���y��)� �ćf�V�zń�,Qt��?�u� �\q�_Xi=KK���&rG(�R�����|�쌂�C>!
j�2��K!O���(%K�D0}�=V� <?�`�����1���	5�L���������,�̏L��MT���\b��,�c;H�d-e��L�������wGEB�F�;����,�H��4{4]�m�����S�\��n7e3 T[=�0Dd�V��h����I"c��J�&����z��;�4�K� X �aѽLX��!d����T-Eכ������|���f�^B����H��%#�i�R�L�E4As��w���I�Q\��܏��1���ä��b�(\�h*Sn��O��+w��%�� ����(6\�K"4������(�b�"¦�5��1�>7�ۺ}qY��B��P�l��h5�"�(�*���vU��冪,!��w�U��"Z��7W���OP�OupZ�8�	Ӻ,w��޺�i"��I� �oy�'�	VRr�pv0A��u��{�'p͂�D��#V���L�1͵>H�r(zѲ���R� #����0��nRR}:r��B���K&<���e�ZWe�T�O�CLE��K�F1��o1�bc��	UT\']�M�#���vq����C�vDa��̱u��#֌Ҙ8|��j�H�`�+��<���ź-�7��|���ï2b�DR馱�_2���=�q����Q��\*(Z:��vA(U�u$�B�tӹᐿǉ^�x�{��=�sX&��gbܖ��D���Eӗ�Յa.�G���ĉ�5�exTF�^�����k	�����Y�n'�HL)N���1]+�铫��]*��b���ةK�r���z�2�Sm"�����}ǹ��nO��0�d \RhBn>(V���#9��D�	~�,��k^�[Ȥ�d�P���x��}��&����phu��>x~bc-|�6�|/��������      �      x��[[��ؑ~��}Y�~�S��cL�c���$0`��֒�֥==�>,���}�;� �O��f�:�H��]���j�!�T�W_�9�~$��c��B$�O��h�J.�Q$Rc�!M��0>�>��8cF�?��%/�u6�����U�*ϖ�i���V��EqU������ʟ?�_e���$��1��M���l� y�x]��B�+�,��t���X�	��*&�t�����/���"_Wb��ΰ���[�㥲̏�M��H=�&e�1�Z"7�l�TʄV��S?߽�m��o�={��b-�-�E���\��+�,cѧ`;]*(DmN�ɜ�T��"0[��4d%&B�J8�8=����������?��~�y���'w?������?��׿�틻q��P#˸fZ)ٵ 3qke��E�#g�U�0��ʙ�ei����5.Rc���X�Y�%�V�_�~�q]ہ�����R�,	2�SF{A÷�f���B�(�0�J��T�+�m��,�l�U
_{͵�]S��3�)�״�5���yr'h"m�����DrB����Z�����;o������K�.�p}K�M�Cqi,s��z>�yץ��ޣ�
rW��8�d	< ւ(����Z0�h�z����C�t��#�[�s���f���Ã�Ã�M�2&U�I#ZhE5��
V��4ON��e��M���y��γEr��F~��0��� ��M��C3�![�q�bY�0�ҹ~�߮��8,F����e�ހ�BP$�"9�����'��,[��V#.�Xx�������<�y�]2&�v"��i��> �gA����W?nTi�i����r����nOfŶʹ��>��{q���4����p��쐈O���		�3�_p��!�Z�?��Ӥ�*a�C��Ж�5��qz<���jo=>����H�j!`�*L�XX�V$x�D��!{����v=�ȓ�W���(a���ܛ��Z*o����m������6Sv��� ϬǢ�2i������,apH���
!�mJv���V�G����ɓo^&�z��q��%鳳��H�� ��N�mMqDCN.�7��b�����U��}�pc���G�Z45-EP�	�)�����(�6�����eɣ����j�G�c���xxK�w9�r�-�lۏ���� 1]��)L9�!r��R����d�l;�&��l}��7�S'��Yv�Vݍ��R�$�C�czQ����L��i㵗"�j�@�p|�<]���}�H8�H{���I����u�e��؛��h}�*x0�!x�`H:��|����׻U�Y��č�m�%�X��NĪfh�)�MN���f�ZA�S�wa2�<���u-.i�l�
���G�",�G�!C�������~�?�"@M���?������᧻���绿T��ɓ���t���i-��� u���|�'i��%�7���s���r.�o�
�ier���K[8��DH�ʢ�����"��������\�
��LA���1f�+!�w�2[�o�����M��.�����n�o�(U��)���c}Ǭ[��9[��cy���-��܂��2d�U��ɓ�bڤ�<�2�A�*�}P��|�m�@���n`�%�:2=���q�'?�Z��"FD�P�.v�Ke�}����ހ4W�F3� ��:kש�JːPB(���?%U\\ww��=8���{f�������鏉T�BЬJ�\
��x�X����r��^$�U� %�L�"O}CّB_#t�e�
6%�p:��UD 1H�ht��ݳ�T�f��� H-����@6�Ri�h�sR���q�1T,8ƀ��Um@y�"4R�H��薊�d]�����Ǔkq����$��K�p* ~P�KcE@���@XS�18�Xt;x=�����]v��b��A�N��vQo:M����4�S ���n��!��5"��������<�E����R��z����֛�V`��}H��k[�قQ��j�vq�Ho� 5=���#o�u�Pa���: '����W>t?�E���V�YLDYk�����,�Em�о�~�]e3>���;�<��H�^\�e��*C5�S�<�Y�*keaXX�o�W�.*�0��#��w�ѥ_9�Z�	��W�j��(�=."�㈁�Z�Ө_MEBj�����t�3�����Wyv�˓�o�d�HY����X���c��Y�I|�ܔS��)��%�.�5�N��5u�:VCkT�ګH߆�o�qaCFV�O�����=�wX�@�y>-V���OH�|:+�E��r$��AR�6�.�\�B�L�Z��|�%T�=�v��)��J5�U��D�� M��zD:0|c,/C�P�׉�7QM�J��l�n�'�W���|/.��x�P!���t��(l�`^О�*|�����_�|������y~zv��:>�O_>;��A�u�_�
�Vbc���L{�C�ѭ����I�߬��X�����Bg�\a���e�����B�"� "��ȕ=����<_�^��w�՛J�	o�Wj�ťZm������E"�&R�=������Fz����-���^��D},����}&@�ԩ
?,q#["���ܘ,��t��̊���a�F}i1����6}9Tx6�jq�Mb�g6�KK|K:i��D\�Ms�1���Rz��O��&���{e�Fx8<((�P%0w\�!�A�ʸ�z� (� ��8#�@܃��8�P�f�mw�M�Z�7�p���<|���Y�વ����m���D�n|��B�O�0��c?���	���>(���ģ�m�t�osQ�Π�-�/���R�C֛�<�/*�Q&LIi���7����FZðʘ�A�nmY���rp��]�d���B�'�v?f]�F��}�5�2���T(4��C����=��и�t�D��� @�_d��E��:�v�^ُiw^�m�������G~#.#���M܊SY�(;{�y$��i檖K���&����Rl�q��u��G�R\�k]�g�&�7�G�(�:)uI���|�Mh�=X�����tr����6y��oʗl�͓eѥs�-�/򷻓e`�ٶ�J��!��f�|�W�B5�˨��}*᫼C���k�|y�>��-��y��JCU�L��J�1�v(D��'}��� �L`��	�V�@�_����x���#e?�*�"D�@������^\����F�M-e��*��8�ŋ֡''�v�0K�]H}���j�/yv�>������N
Rۜ�H�9�"�)kxp�"桘p����n�#їԬ�g��S�䑆�Ls�HL�A���m�G�ֈ�|�*����y�X`��\�����M�`:�
�o�>�}��3�|�����|�߷y��~�ET�7�=d�\yc����,B)�ʽm %#LA]}�'���p�x�6���m�c���(��SZH�JD������M	�E�TXMg�E�8?̬��e�z����ν�";�!�q��'])4�苚����D��t!�L�o�81X$+�����>ц޲�����u�Y:v�6�-����a��������TV�4�tRE{X���E�<����E��A"�T�tl��&F%Z��A.̫p�0�[Z�%�V��Ǜe�܄������ŭ�D��~�BhwB׾���O��Us��<�,m�Yg��HE�<�J��S'�et��nN�Y���M�gh���KN*/�tuY[]���	E8Z齴*通ҁ�u���zA��Q�jHܛ�LDG5�.�9�M8��\J�yj�(�2�9Gg����òu���	��`�j���p�з�Ź�$�&<��d�i��Gu�(���;�t�h2��9Ԉ4�s:������=*6Q����j�q�z�O?�nȇ=C��zo�8h˅S����=��qJL�����k����&�@�")N�m���4�zY҃^:^�l���Ԙ�#\�U�ԑSJr�#@Z��	E��|9�-;k53\��� �\ʉ�i�P�p}ح��gIi"�x����`�_��o�����4��o�tu����Ҍ���W��<C��o�[e��������<��e�u���1�g�
H� �   K�{q�nl:�2�HA�����%�B�+�R%��j��+��]��s���v�A_�f�;W�K�m�^y|_"�x�x��Z$V�U���ݘ��������f����D#.���Ê��hQ*hwT�D��E�Rn�k������o�Q{�1z~��'!�m1;�x��KDW��~0t�w�WG�����f���jH���>�$}~�޻w����M      �      x��\Kw�F�]7~��c����HJ�(>���|����I@	k�_?�-�3�J�m���f��]u�VuC��]?���~u��3��z��0K��=h��n���t֕ިY�����\7z6��:��V�{�!
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
�`�f��R�/�Y=�C���>��#ݨ	�����8����	      �      x��\ks�6����
V�J�D.ޏ�&[����V,�df6S*�%ZT��͖#����^��b�[�d��xV��n ��s�@ۀ�#J#�C*Ǆ�9��aV�.�ED�T��S[f�~*&�|1����b6��	�{sP���0�����%Ezr>�.���o���]1)�w����F'�;�k���/�o��o�ϯ�<8u����3����F>fv�x̌�c���(	�s�'��ඨ=�,&ס���$�Y�6�[�&���]�'/���M q��/�N/.޼��
���c�c�� %b��tT1�����������2d��q�����4��n ����\�-���.&?[���U����~ؘq>x7�ü/S�y���������z;�ޗ>���}}��g���)�̼�=��dLU,�!R��uqW����%���r���Z�ǀ;���P��ϖ�F��_\�3%=�05BĔKB�.t�b�.�a�"�n6߆.� ����t1�M�3����1ױ�V���_B0x�u*��Je��D�%ԲU/��K�P��c�?u���~�=t���i���,|�f�~2)��e1�ݬ�)�g�]X����킮�&�p{��6�}Q߄�I,�� *�����*��yQM\	���
&
P;<\*�;N*<���㒚V�:�	R��3_��eY���r��ο?�3�5�l,���@1��@[�c�ƘΊ{��猻!Θ?�3�} 	Q��Рh\�^��6���ƻ�Y�?e~���r ɺ3��޺�"yl�v�>��O@J�$�6�����p>�W{���$��}�5�+2�+֧Z5�46Jj.W��q#`0"�[ ���h܃+���7Щ�S�-�1�,�ڨ�T��I����}%���w�`��M�J����ĨU�ȉ��D��p!A^_��
:}{�&<{���7�%�K8��э�z1�a ��q���ve�&'o@!�{t��<�	G��ҵ�Gam�D�C�k�X�b�Ҙ	A./_.)2����ixV�ü�0s�o�@�nҺ;W�����Ϛ/��a�Ǫ̐��a��2����ü�wq��䢀|h�����k���"-�l>���c��޳٩�^Ȍ��҃���pY68:�jh(Th1�7U�o�������]R�0�f�C��E.��򈅬X�5�
�	C˨ଟ��Jb�5]Q��Fm��a�og`�7˹���R� �����Khɘe��~ ��ۙ�@�Ppw�Y9�鮍�-�tG�a16�`?���Wt5P���ZN{D.	J;�ࢬF��{V$��3�R?��l4��N�Q]ԥ�/���$Mo���C��|�E�_����e:�~2���k�M<�\ci,q���%�ռ�a��J�跓p��Ѻ�`�n���U�G�և��'$�,��#�G��1��JÔ�����K��h�ȵ6���C3خ�U�pif�
<fNw	�dS�:�US����*k�$,�Ȧ�j1�g/qB�Ώ��7/�f�E̥�\/���Qk��3i�T��K���몫�a��� �j�s�.�fe}��]�I��u���VV��a�2��NW���ɲ��i�~�Ys�ް���,�gH6�18�<g���b����O�! �����^�
���э1�jif���*o)�-�H1k~��7H�?��K����O`y��c�>��`�`g�<�*ȟ�%�^�\�*�@
wE����Z���uRU�a383�%#�O�T��cp�y 8���Cp�R00�K0�j�y�z([�Q&� L����Ϲ ��ҧ@yQ}���x{J��70�K��$��t�NC$��P���B�6���o��.u�܅�,�����Y���5��Ԭ�߂��T�S�	�Kx_���m"���{��e��ek���E-�l,0��j�ԫp�	�/~L��/�ޕ��W��{���k�q�3�J��R
���e�m�XL�e���	[��!cchl���PV�ͷ��o}��g;��9a��^'��~�w٘�����}��iY�lm;e����ĭ;i!�~{�xCe���Qz(�ͳ�ݭ��������
��ޜ�А�$����j�˂8��X3M�j��t�=PNm�z��W�d����"��	.�m���Ff�TJ�V��?"��zD֚���3�I��b|ɬ��\��ռj��f��*w�G�c�!�E�,3���jv{U����]�ʂ��L�YY%�n$��r�\�|Y�e���-	�Q���8x���4|y���F�!1��������Ӟ�U��>P���<�X�i$k#c�<2y&L�2�����{�㴺������$�0K8��r�LF	��('�&�����XZN,�ZJ��VK�+��\�-�<-�]��H
w�v����M_@R�c��
��:��R��Z��ZJ�tk]��v�T9���2��H�$�`��'��R.�M�AC}҃;F�R��|��BD£5
Q@�f�LͷzݹA}��o���5i�f/����F�9� B�H��m7�1E�?�W�6���C JM���j)D<"
��@$���s�l�����X��=m��O��5�@i;N��br=�\-��Lh;|xܞ����$uW#ӑ���K�(a���$R�W24<Oz�i����ݲ��أ��㯗�p��,�a�g ��\�Qe�ɕPWt�������{(�C��3��x�R�0�ڬُ�fWH��!�<�`����y�	GǱ2���"VRry gdw���i��.��g�����Q�i�`�iqs�j%����3�q��؞�+(F�O�A�>}aAZ�cmې�6KܱJ2fZd��m~��� kNWr�������(��	���%���{`�Hh	.��&r�� a$���\��@�=�B4"}Z� �I��ԙo8�^MK�p�,[]����jQ/��}D�~O%G�J�V^�4"9D��y9
=c�%<���*�{f2�3�!�K��:��զ<�U.�S9Y�
����B��)ry��BO���9��'�c�!�'f��$�Z��6�K����h�g"���u3����$����C��\Kt.��~������G�_�]��Q֑�ާrw,A[ X���M#��<�"�Q�iI��䖰mob����Ε�+o�^9�c�Yx�O�f
��!4Xm�v���?�ps/����p����Q��
�j�����G+9�X�&�?Rwr �,��f�� 9��B~ea�3��ӝϜ��O@xR�H��4��S�'�8-�f��6�窨i��z��H�{�C$(*�IE����n��.i��㮝-�!�>f)�L��{�D�r�x"2�gw�{�P���fr��2t<:�W}�g���J��gI�?�-;��]���Sb��{��bOLd�ڄW�!�ѰL�Y��Q��T},&�ϋ��6B�a|��{��nj����ĤZ�7�
J�3�k�#7ɁɩJ�D|�h�$�sNP�WE#��.���s�f<�q��uHE������>�k�$�FY�۱��N� ��"6��Lx��6L�ȧ�j�D҃^_���V�v`T��==����?^�>=�>=���y}����󳿽do��\�U��g��!��}5�X7�[��p��3F��*�fFKa���Z*��ú��oT�O��^��7�!��7��.P�����Q�gM<`b���c����h<���1�I��ě��!��c�ч���Kc	�H(.�w4��	%�c�l�wxJ�g}Ą��X�V1�]xFd&��z�:���q��[#���:�"5�Ud�� +Ot�y���%W�
�R`%�idR�F0 �:��n�Oz���6�
���P%Ė�K`d4���6I�"��/P�(�����$<��#���S�I�/##�s1��9'I���K>������^�&W��bݫ�t?8�����u�p���}r7`24���)O��M�``��rg2#�:HϷ����a��l�����M���|5Z�O!����.�w?; `.��N�pjx�n����[��~�n}��   ;��^� S�&�U��s�[��V�W�� н3C|����޼āV4�P�������Վ�I��`\'�<�����ڪu� O�y�B>am���d�1�CI�WF�n=::i���bց_Ń���j�)ջZk�T�uv���3�	�߹ .�$��p+���|��o>�9��i�"'�XY
އ�>5���m~^Rg��'��P	��B2pW��r)�Ns#����͔Rg%7Q&-p��,���猦D0�l�^�d���ِp�2��O�O�Ӊ�2%\im��S4�h���V�ԁ�
��.��ƍ��Q�Q�[L��n'�b- �X#��H�4��,��.bp�%a�����Լ�z��xy}�;x]e�+L;��N�7��'�K5���^;�������W[��ަ�풜m�fY�D��@{9-����,q���a���}5���XV0���
���D��e����-5{��ᖗ�f$Vu��(5ʚCY���[��WFt�8b뽄�v��^���W_}����2      7   �  x�}��nG���S��Q[os�eė�"��Z[��P$8y�T�MNq�9��cu��(+�w��a�z���̞Ӓ�W��������_FG�!/J_�@��K�sr1e�g�X��v���޽��vjS����3فO�$�1!u=�v�|\��?l�O�a���	O9eZ�N0a	�N`��sp1f�E���8S̲�}�9�t7���������>�H�DpXrX��L2L�ܡ�IzfLt�sP���s�R��1�\IbI���=z1��K�H�Jj}Ғt �!����Ӆ��+c�9���bΒ[^bG)�Ćt��|���X)F�HL����*ɔ0q!A�	]H!�IA����a�]o߾u�Cĵ�cN.�҆F�7>0�j�L�9��j���p���J��"��EitB�v�Y�BiH]�lc9�:=@��"%����ڸ4T7h�A�9Q��]��F�&B�R�H�A��?�m�}2�?-m##��>�>��sw�������azAҋ8mkL3OZ�v��c;�7���3�8	�̕V��_����ռh998�H�/I��y���.\L�Í�����q?ǲ�X�.��Ԇ��a�������dG��Yw�x�Gdn�t� �cydx0�a�	\�;��S�%�^���bV�>�����e����?>���;%���3Izд�J�Ψ���m7?�۷a������L)��Tb\�H,�N8�|�hG�	]N�������,8m?	s�\]���jIa�	K��	�*�e���~�����0=6�Zr���SX�lc�mXi��&M�f���� �ȑƆ�۴샭�M����hmC�6MwAl�4��ui7�����a���������%�η\7c���K�g���&���M��n�;N��r�lʖ��ѱ�$�ϕR'
��QR���P�R\�>������Ǥ�#,J��� ���A���(�ʲ$Mv�T[r��!N�����&q�y>�%����}HR��d�:�xr��2��f���1Pj7KY}\�Y�{��������
,jnH�8����XL4uA�i���}N06��]0�if��t(E�\Sl�É�w�mX�>�����÷���ui~�Q�:mn�Yiʴ�V����{1K�Y8�t�8t�m�탩����iu��j���8���F�yo:r[��GH�Y"Xij+f� Dɱ嚓4e�Ȝ��7�G����<:ʠ&m[:�������q�ӡ�4`j��#��j>ip��O>���i'?ڇB-�8PE��JJm�f �&�s�Z��zrgl�9g�����JD��}�����h_�-�V0t�+sR�nD���/9Q_n�d�6�x��р���;�f���[{F�7�����$5w��e��������
�$����^_�ڨ*��Պ�ꮮ��̫p      �   �   x��Ͻ�0��\7�B$�����H�\>+��#���՛88)�;��"r!i��y�rU�m�S�؈b)5�N+�&����0�2�Έw?�f�`:ϼd]�m���r����Y�C�2�0��='s%���Wt�
���\-m^c���#Fw!zwXm��Z0̉%I��v�      9   '  x�����7�룧�X�WI��pĝ�ic�T����x}fFҰ���>��G�h�F@��L��e�Ȳ6�bz���?n__�|���˭�D?������߼��(ů��O�6�M17��4Bw�>}���ח��$k[��-B?<ڕƯ�nj��r�6Hei�Jj�1E]��n\7ѬT�8B�S��Һ�R�f�0ٯ8������/z��ݺ<A�����;����k�"�j�S�b|:a����EZ���'�����>��얋�pB�Bf��!ܒ�ei. �� Ohv������)&έ FhpK����Z�;��r) nR3"��+'48U�ڼ����f�\�G��%�6��T���������m�% H�Р�C�O�i��2��Q�%K$'sސ6���H:+$:�g�M���2(5Ѡ����ܑWl�������
�� �Q�w�C�,��'���zRl��@�[����'J���[�N~4�*W��ht��I=�R7n}�(�U���U8I[�{�Uє�.f�	o�$���I�f1I
�S�'4��J{!��jc��%�(@�Р�I�ʼ)Eh���9)�@�~B=�h�
F���Kٕ�'%B�c�F����{~{��+b��#4�#�T]��(���\��?�k���R����h*"�-�PD�~�|����R[��(k�4W=,�4�bv<�Ê���\O�=GR�s�R"4���	�'���C��45Z��?@.����-/"���.�;Z��~�}8��к�\(�y���ʅ9s�����B��u�����>\�����[�^ٷ�"�D�c���S�=��}����ʙ]ջס��ͅ�Fhn�޽�н��� �!`���k	֥�#4�����{��`��5[�Z8B�c�V��-����%�s��*^^�i��ML�e��AԷ�=-��}��-,Z��]��a<-��S�ڞ_�'���z~}�7�5�����g����F���>"4�����Y����h��˱�ӡ�����w�6,��/O��o�W_���1�w��s��jD�F���[�_9��?W�(      5      x���ͮ�8r��UOQ/���n��^xtO�0ൟ��fD*)�xNd�P������F�A���폿����������ڗs�\��1.��\���>}��N�����^j��o��ǧ���Z-$���?������\��b!�l���o����	�>���D4�ǟ��d��������?���Ǌ��f���ܷ����?x��+fw��R?w!��ϩfΠ{.$�>K��]�B���d��g������x�D�DI�Xٍ?�(Vl�T��`���}o�ީ�wmI������Ѽ��YH���Tһ#�vd�����[瘒���sv$��fC��,���o=����^��B�o�c�st�9�3���1C�)ZH��/L�>q��h���a�6<����>���=$�?"�u�/��͝ۊ��`����L���H+H$�Y��������9���]SDW� ׉����+�/W�1��Z,��}��*��u��)�,$�~5���-�������g���W�/�+��|\�$@"9���YE=�2=����T���d��#�V[�А�5^�Y�Gٗ{w?|�J�����`�BC�����H�~;/,��?�(/�T���j!��T��D�>G绅T���:���f#�,nz�U�C=bKΡ�H%le����V|�>ˎ�5�p��D#"�GD(χ��5rO$�8�$�!����D1��W�ӱf���Ds1u�C�E[�y��L$�4�C���Y/$��i�o���������G##�����
j㓈�=�|��j�D���S�FZH$qbF.K�%��\H�xXCz��&�=��5ӈ~,$��$�Ds�f'w�@��p��A׎�]u�B"ٙY2�\Q2~!Y�p���ee$u�fV�4iSZF�>���-C�۫�q*Ml���rC�0�(�A��+�XQ�^�Wl_qD��%-$�0�O\֎\�m�蕈0J�H����-4D�}m�M#[D�=�(�,���퍧�$MŚsI��+��vD��>�(���vtC"�Q�K9�(�b��$�E��m+�õ���׫O?�i�`�r�:����-�	��~�?���r#�Az��2��3��4�0����qY��$��5iU`3YZ�G�iNz��kJ����w��z��ܑH6�X�;�p�P���r���x�����Ȑ���q浡�$��w�h]'�O��q	ꦉ4/Ͱ�Y^Zk`��"�L����4���9�x��fJ�z�y+vX'Ow�R�~�a��D��^R�\]�Md uu��2g�sv-��.0s"����PN����g���lm"��O|^q� 3�H}^"Me^��h"�zk6�n).a$<{��߻&�O�^k�ZH��Ó�B1��'R�N(�O�A�7�����T���O��)"�Ǘ�bFK��,������g�:<��H�]m�B�.���s9$sN��9%(ɖ�K�8�;��&��]St��؉T�3/�}SC]?����O���B�6����6��z��g�B�D"�LčD�#��&R�3���y�cN���P<��T�`7BC'G#'wN��(�L��Nm�N�-S�*����9�SN�5y����5u8�4f��p"	��u/+�����&RgǶ��s%y��[g�O^}Y�ܑ���͓��1V"�ω�����$�͐�c�@��j�f�H$�"��+R)Q���--�*Y�u)�أ��%{�0����L�>��ԓ�u��G�҆�cMw�}$s��C&����p\w"�l�����u u��8O��}���&�N��J�q~z�Df7���v"��kE�G�b�W��8PG(�s%N��ԁVXI�=]n�U-*�|��
���д�%�k9�}Mdw$�%�o���������@�H�g��Tp�Y��j\�v��m�l����'R�\qK����Sv�f�^�H�Z"�| u�	7�xz�]��'�i/^�Y3� ��D*��0�;2Yy�9�OJsJhx��D:o�D�f#,��zy\�B�x:o�s��t��F��.;@������1�%E:o�P�
�a�5�N�y��ؓ�Q���M%$ɤ�v�FO��N�4<v$<�1wM#�7�N�bNc��,��tڸ�W��4�3��M�E���a�HHE3�5��Ͼ�P~"uǙ4��c^6uw�γ�D<r^���HE+�G%���D��ӛ��G��t$��>�$*����z����L���%� g��T4�v2��*Lc&R�\�!Q�쒉T��vR�<"��O�
�>rʲ1\,4D��?���%d�_q�D<bm�U��5k.��9xa�#��?w"�,�`�����a5�Ɍ~��~��tF�N��:9Ƃ��N����ܛ���u}G:y2��i'��Q;���o����$	��T��BZ{:���5��@귕%5��R�ߢ���˧���%A��	�xU�D�lI+�۞棝�1��ux�n!݊��c�����6��t�W�C���9���@�{G�Ɉ�j��!�gC^�yX��s�Z0r���ЮH$�.[����!�m�9��%OC͟H��V���-�e�H�ҽT��W�h^H�}C�M�\��4�݇��f�Jš��T���n"Ǟr2��������\����ԅ���RsK�J���|��u"uJE!$���XD=R���Y R{���#pv�.t��
@��~���n�uمH�([b_�7�������F="c�H�ɑ���}˨�&R�u����k�َ~~o���#�v~��<D�o�anHv�D3�_�H4�if�8��v+��!QL辋��u�A�c'Er�����L:�gy"����L2�i�ND��i��v+~�'EpH�ld��ю��[��[h(F|�޹?|t���'w�K�� �l�~0�D�r=2ݼ��(�Zr��D�	�
p��өX�g�=Z���D���BÔ���$?D4���B"ډa�T���@C3�يe�� ErΆi�h͓V>�hh������?v"Q��z�h"QL��ɕcl�f!��cd�3��ωDr?'li��/��9�hVhED��6*�F,��RJ��}"ͦL}q:�S[� ��/>YŲߔ۾I�"�~�#v��BY�gG���Ǚ�%��z,@� G��F��^_��w��jd�Dt���Mt"�{�N�{̈��L���s���.ĭhxE��x?�n���>i����K�.���J�^H�f3��}[;Ҿ����9s:�f��J�|5�TL���e�4+Mt�T�&���K�U$�V�ε�����WG�:�ژH�~[�3����D4�(��^�@��9��z0�Ĵ�O�m\H%;��b)6�
��y�λJ�h�hkx �H-���}�k��}������Z�3|f�1P{���e�`��.�l!5x��9n��a�<���(�������i/%���:�y�(�@*�U���+q�H{)�=W�Mqq�BjN��eâ|��~�[�|Ǥd�K��4��7�O#�ꨝ�h�[��/"���s]:�I�Mɵ���N�ݔ�j�5�QK�D�'Id|���~�tE�΄���������ԥ��ɺ{��Hfv��+�1�y����[;�5׀�N���Ő=��KU;ҧ�*�����z��A�"Za�,{�1F���6��o�F��?\�G��I=[H$۞{<f����ow�-"�3T����u`�ƌ��`!��P7%�X�� -�Xg�Uris���r"��{j�����}�a����T,$�i_�|�vxe�@�R����|�c�A:��v2��v	�4Dj��>�[fߊ�kM����-yH6ػ#���D���E@��G��A���R���@���$%���1"U�g~i�g�~p"��{�����,_�H;�aC�nI R�4��g���\N$��z�������M������گ�QC��p-P�w�FF�1�}+����>:.)���V$9�H�	��R�&��[�M�]�/� Qd;D��t_�^�(�֏%sH-ܷ�^����p��\���O$�lC�^=�Ԝ�w$^�h�q��=�(��Dϕ�mG� Q�c�)�����D����]�oH� Qdo���N�Ùd����D���>�\�� [  �v9�h��p����y��D��_i%�У���f�ӭ��{mE�:=�">ƣD]>�(��p&Y#t��$�G^Q��CF�>���ݑ��\�g���&Y�暹!�1��<|фu紕�l%\�b�>{�'E\�LY�Oy������NH��`�E7\X�tͅD�<�*�{�-$�x�!��~���";�-ރ�����ȍjf�/44ɧ%��k>�#��g;��AS�D�2d*��1�?�uC����|�9It�����o[i�c%�\�m�)/HDq-�,����"�{��l�o\H$a�U��5ZH�{(nƜe����v;_�Pl*�����ȅ���	z9��D2@�$����osĊD12�ĢI�=���W�2͑y�ư"ф�^�e��e%�=XZ�(fX�D��}Q�����[�O[�(�����\�'��$Ky�h�9�ي��˻:?Ѭ}+�}A���QS���s"Q$�Ѭ#�'��D�	K��a����[y"Qd���i�Ql�T�oU�/Hq�<�,}+$A"I�F4�|S
[щD�a�.��7�(�:6raG++��F窈z5ι���+E�Eﲃm�H��ؒ�PL$�$dc�)7�2'M�qżUg� QdA��6������N,�@��Q�ߨXH�%n���^f����؈���Z��v$���L���n��hHfV�D{�k%܎D�,?͑ƹn"�$s�)�ؑh��6�K_�v$�p� 9pY<J(�Г�Y������nG��_���s�.'E<r���fk��׊�D�z���DC���1���qG�	���/>�эO$��/T�E4�'M� *2ˉD��mT��/pHD�jפ���s�Cq��l�ID�<\�w4'E:zpSJ����D�m\3�/����>��F1�TN$�x��J����D��W�?��+�}&�i��p<�h'���>BC��H���ΙH�C�l$��E��)�eG|G�Ɇ�=�UN44ۨh�&Q2z�u��NE"��l,5�+T,$�l�����D"J��fz�,֎�f�S9��2Ґ����9QXQ��J]_��֣m3�������T��m>����=.n<�V��d����mGZ��?�L�ܪ�� ���%����J>�V��Äo��RF�ji�����w���KN$cW��a	�'�'�c#H�pl!1$�W��*f�����[6�z����Dj��}��6��1z�������&+�/�aDu?aY��[N&����eF\�x"�Lz0�̮�xx"1M:	Q����D���8S��'R㼿��2�KK&R_�퐛�X�_�)�Dj��0�ޛ�O�XH}1~i+���ۙ��gXN콕�񃨵�ݩ��B�Q��{�ը��/��[ϰؘ�/7R|"-6��賳5�Gr"ռ>��/��5z�w~"�8�0�B�9�"|��Rfn#���c�^<0�tV��9�v��8����HU�w��u���ZoH����?{Tv:*�9*+9��$��Z|�Th�h盃��H�r�����N:�#OD�	r^�D*Z��,:6sF'5&���7X�،p!e"��aph�M�WN�c��Б�^Jbv�ch�����^���}/�>;�^j�v����ի7��ZD����Wo�O�؄N��g9����i0��HE<GCG5��S�lH�-�v�H��-��.N$����G��c���_��{<��H;h��[WLd=��FvP�ے'�@�61P'�~W���H���^g�,Ԓ"\�H4雉�1��=������;1���O�����R٘��Y����)������ߑh�.�WM!�l"5���x~����>H��#���>WpK�i��o�D?���������      �      x�t�Ǯ�\-
��~�����xA�M�=<}�yN~ը��l���d�1��,0��~`�BqMQG��
g��-ܲ�$��a?�J���M��~�LA�����<	�7�2�d$�'	����5����y�3�Y���.��0�o���/�U��3�0p����?��m��^����وS�2�h (��]?�;����������0�2,�I˻�qt��b�.��[��_��Ն7��"����Z	�^T��C�]��8��[����s���ζ.a7RA�����su��=�gCt0;��F_.��5F�UX���ȅ�X����)7҄�b�B�P�$�PYB� I���
:�b��}-Ɍ�T+q��tчYh-����`]����B��x�1����5P	�y�m�qtXV���C�o�G�c_8��ZY�N/wG���u	V�_��Wb;܌��V؆�"��<$b3���9u����)	 $8@q(G bAi� �����-G��v�
���l�_+�a#M��&E�ԢS���������1&�S��d� r�j-�)>�Q�ĴC�h�H���ኹ"V��"��VA�� \r4}�����N��V��_���� �c2�-�O�F�YE���~
��p��b(�MsBs�'�Q���q��ū����k��'���^���T��3 2��8�_�)�n�-$F�� %dݲ�%�7GP�Z�F��M
�&90qФ�7��a6*{¥��e����ȸ��]n	��>���gLH*%�ʒ��$�2�ϊ2-Q!"����'��nE���Y�@شi�sc�.i�����̬D}��J�%��q73���N`�,^��d�CU��2x���1���0_�b��˄v�1솺R��e�OP�>P�~24)@�!(.2�@~R���ZN\(�������_��D:���߀�lﵫS*  �P"	�;�xK+���W�F��
��!��);|� ������S�]q#zBbI����}*���9|��PHz'Z-�7�OH%r.��/�����,�S< !$�(�4�
 �s�P�q�O����ʿҹ�:��e��ߐ�9hmlX	o
��5�������Nl;�'=.����n�����!6�i�kNY�ϛ�'9*�pP�k�v���x~@3�W���0ڮ~&��@}?oX��h�(�W�!�!����R�H1�����or�V{E������n�K���&�1�u�����禍�L�!��p�.sߕ�!_��}`/A"MZŝQ Y�M��*�0�d��,ꥩ�t�0�N(+�6M�_���Q���Uu���B8���'H�RDg(�Q����;�k��� %$�����O�)�i��K�ê�1�vW%��;t��;�a�kZ��t�^H��Ľ���oS�p���7_��'�ղ&����Y���_Gf�WQhz����j�5`o�D=7~:L�0��R?̲�! F�؃#�(b �!a��B`��Ԏ8S������������Xt�����#hh`a��5��E�kW@�`J|!����@�[\���1����vЬ��)�"�����%�y�fL��xn1��+Z21��~�g ��:'�4��/��3	�)A��1������tkgWs�F����*�H�h��ŭz�S��p�YB��������/{6���� I�-c�qcAI��\j5ϩ��5��5�fL$��w���nǅ�펦Z\��e!����E�7���a"}D��8���'���n�����M��z��]�75q���f��xg��H��cE �oP�^���\�%��-wI��
�^I-l��.�ۉ"��*�}���&��D����۬���/z4�g��� `�>�#p���A$���y'�������q��Ǒ���J�5���7�C�ۗ_��zP��TÝ��$�t��]��0���
ot_%l���5<�M�y$�yY��s�>�×d0!ƍ�|.,�8(���8��F�K�ZCx���TE���?�I���#�0\dxF�dd�:����{V�c^�q�	iyL&v6?�4F0�f�~ 7h�wb�'ĮfX8�N�I� �+�*�?�����{1���J,�uKƳ;���Xա&зe<���	�,08����}�B^�P��I�pᏯޯ��V���%�2��A��sF[�ǺZJ�2K�WR�c�3(߷�5P�#���@���gW�W%��00�M��j����lA�U7�B(c��,;��]��B'�YZK���4p��0��K3�E����S�c�a���
�m�(�<4����������ƒ� |h�~��om+���u��_*<^�B�X�ۜ��P�bV�$�:ɖ��w�-��A��S.� �,~5�Y�#�ij�����P���h߼_���u�)$�p�(*}N�����)�����B�/����u����&~�B|��fnD!H��]	8��8���r,؊��H4تͱ�Ew(6	Yl5��>�C��Q�@�w�����/`�T���FYa�9em�
]���/���)�	J%$O"�~r�3�t����9���K��`���y�łɕ����[�8�|�HD>Y�p�͓�$��'�Wɗֹ��*�C���R�l�� ���w��v�j�rV,���z�bD���U.��L��/�)z,��.y�@���g!�������R�����z㯠�*.�j۾�Sز�qpoqά�3S/����c]���r*7j��]�FC�RX+�k�S�d��/���}��6�jY+���X�8Q��9!����4�'?9,K�$NI~�6����~����O�}�����N�V��&�Fj�=&#;�lf)�l�˙�����m�%zd���{2����6gP�
Q^�Y�Qc�w�����
s'�s��kuVxt�.�	����j̓T��"��_���> I\5�ns-��j!r��i0EL"m5�-�����
,����� �e[�sB���cNxg�%�o�Au��9ُ�z/�բ�(��P\��v�ybL�����Rog�ѻ��f���̋6�A,�ƞJ��r�@�$G����-ńrr�IKE�i�w��c�a�[�D>�Xξ��=��������3���u��!O�zP^���չ+ӧ���1-�m�Ĉ��R,!-�Zߒ�~�~�BLn���:�^��͚QA����_��uzp'Y
y�>FX�^�nǪ�q���4e�?^oQ"��/��q���,x1��~��\=34��'��H�8_	�HA�9�ʙ��M��9���T�q��PFf�-lC2TqGw�PtLפ@L�E¹�p}�-w��1�_���)2Ϛ��v����?��c�|LU��?D�� ���ｙ1HXj^w�5>!���Y���~!�u/r����M�d�#ru-�$��S�$u9�&���/�d�����*�a�
��?�6��!�>uS���u������=9�T����8������� �H�lҮ!K��)C}�=�os��0ڙ$�b��ƫpw� �p�bnv� ��f,D=M��p����v^m@ԸT����u`n�;(���1����� �#���>��Q����<��x�U6�aֿ!�}��o]�v)cT���
��[�ek�n1{�{O�,
mpѭ�}7�T�X������2-Q3n:�=�&�kk�⨪R�v�/C7"�ir!���<��,-�����6��=Hyz�ӣ��p�Qgpm"f�m{�?���@����2�|��M+�=3]��ɤy��<��S�?W����5aM+#�Ɉ@<���?�V90���]W�W���r��_�h�iF1Y)�2�����f>��X�����0
�I�"�>�G�?����,��_B��j�(ҿ!�k�)H�R�u\g/��X�]��J���.�V^%���/��F�q=.Dӌp�֘s��Z�["�����֠�[��
Ky��dw���1��p��u��� H?r� ��    ���S:�)"8D� A��b�ɺ[Җ�^kdg���L�״[~�/`��6���ik=��!dȹ�G��Jߙ�ZϬ<��� 欯�����Z�]�D�����<t��%o$����(�L�KE�$��8��'�"]��h�%~!}J�	E�%�������}X�H�U!4����4��+�:���e6�(�A�����&�����~%���dX�`�T0�{����Sx���������d1��� 5�B(�F>�?]F���+��g30����m��uv�o1�O�(f(�� N�A?ܶ^zv�]'��t"��?�k�1�h�& ,ћ�Y�c[.���ʊ(�R�(u~o��Q~��HS�S%�+r�d7җ����^�N�Z�z���]_���\���p��ϟ�S�s�F�
z�b	Qɒ"�� ��W�q����x��[�����z`۾~4�ߗ�g��R��Q-wi���Ǒ|5���AG{9?6L0�%�/�].\�n�=Rԑ�Zz����U�Q�Y�g�z�ck��*���W��:B���b�_��rO����'�{��|���d\�B���t��t��>��H�T#D����v���ĭ�c�ѦOh?Y{51BH�(�A��]�-��x вQԍ���j因o\�^����F(����	���r�
�0�1��"		�1DP�QX��L����W$�;C�E� �]�$"2�$�d�7ߕ�q{��j�P�� !u�;��/g��>A3`�8�0�exnH����sj-������6IN�Bp%Re~��p3�f�D�Gs�E |�@K����wP��!"�	<y�]V���ژ���&m�� ��*CL�X�&S�[ٺ�T��iI�]��]T��Hݗ�S��˵yb�"D��w��3��z���F�X8������5�����P�Api3|��8�4�"fk�	�&U�
>8���S��iZ�9Mʥ��w�R�,������c ��Q����0G��PJ�'����W6/x	�z�6CC��AY��8�@|4y���}N�b�_���®��ڄi�&W��Z�n�[�^t��Ǎ���]N��l�����I�d	U(��OJ�~��
P�[lݶM7���S��������cW�a���o�}�ED�$q�����t	f���~��\��LŔY�#-o1�{5��-w�������C�����S.4f��+|.�B �*��/��׳�TA�9��9H�?P������Y@C��;�k�*����k[+8^�.�{�e�6��a��f����%����;�`�M;$#_̥�����tX�"�%a=�i�,8됂:��_�]F� Jyf�4�QO�����P⇂~`� @���`i h`xT �#I菱�һY5���A/q��cdR��as!��f�z+k���r�Ȋ���W��8{(��ϫ��"=j��:LEgU�r7{�:�_�K�Ʉ":� X����=�m�\m+����}���%�O���`���S$I�y���?��2�i7�y���F�5��Q��VТ�ޜ���k��.���Z�	�+e'�)����pg���k�	�+��K�H̍`�4sXb�ƨ|�B��$���&v������An�M�.�r�����<6��I��!<���?�I�������P��JO*ʽCη�P��޻2��zP�MGXC���(���@Fxx'w���*d�M_�f���DP�LH�����H���Lϕs��Iv�	�AK�<U6��)��QI�.f�T�X/����O�Kq
Q� ����9�4e����c���X\&��*��t����<D��� �Wn��ov�;�M	TvG_~���^�)��Ul�ZH���䑙�p�c�G�?�&"��Ъ������ؠ��^N~���	��6�ަr�"�/�Wb3�s(&����Ʉ��D �Kq�f�\J���T&�y�DͩO<����3_��2��&��XPdʛ�M���ۍE����$���B�P8sC^�����"4|Q��D���ø��7D���ƶ����e���<��� �r-�v��/a	�te����WEɇ����'��Z5}��I>�ǐ\0�y`�<+�u�������M�\Dh!�Z�j��g��;i,��}}�r��� ��� e��Y=~�$�a�o�&��A),'
*��"�)����@v� �MzU�j8��tJ�i��Hn:n�X��w��}�d���B�o"��l�zr���1��q�h�'�.�����
x�����u3���{3�(��qY�����Y�~�9G;y���w�=��������d9cdLB�e�O���4��׃���\2��?OV�������}: �ۚ���ހ��n�ajV�]Z�.��B��� ���PJ���a�|���-���P����5I������A΂�1����$y���j��E�(�q��s��~^G��QՑ��0����^�F!D��Ij���5��s�Z�'K���n8S}r�CJ�o�J��W�na5I�@m���ח'	����f�2�2)�p8��K"��j��V����2K���dq��Őأj`��?Y֟���n����B����_�����<�h�W^z�M��9�s�ޖWa�Z�b���15S0FA�]����R����]�gz ��j~�;�i����&����s��v]3���aWCV=��m�U���'kC������<�U��eѢ|�������#�νL�%�|� ��e���B7|u(�\�_o���!����{;\Z�&��ʳ��s�����I��Qp`1ܢ?%�7C�{�=����"B"�B#gC��Z�.,�U3�_��C�8�T�`L)�����tyG4~g���N���u�<����=��I����~?�aE�hO����-�힟�Žx���ς0��Z��������y�u>���Y�Z�u��\�^���b0!�Y��e�3m|]��ѥ��_���-�1�9q$$O���Wf��s����~{�a:�����O4+�s���X��#�h�C��_�R^�vh�R���V�<L:p����v�V��+���sVz�'L�v[����֪%\����{��!���k���/� �UEY�F@ �0@Y�(�' ��P�%�Gh�zX�
4�i�=O����F:O���R�S�$ [�䂭�5��'i�LuzX� �l�	����V���4��s���v�������$��t솊 ��x������6E��<[Vޕ���N���:�_�_:�َ'��e�q�+�c�6���x[ĉ�\u������\X�}���0ꔻ��Ա3����zU�����q+���x��M�@�=��2�����_�T��m�	ɝ��H(QW�@�g �;��K���u��DH2M)� ��B$+!Y�F�4���h����F����jA��9�g�^])j��x(����J����d��؈�@ez%�C�J����e�LJ����K�}�!�S�6��yQ
t1�c%"q��@n�F����`��P�$9 `P� ��`�y�ϰ8?�XLoކ���I��%�l���8�a�js�rj3E)n��v�Cj¡�C� |ʮ���M2�!D�p��(��MJ9ZM����cuuc���e�ŵݏ`�DL7}��Xu(�hEx��w� ׆��ث��f���;�`^d�_�>$	���O��b~��{�&���3���_�Y�ޤJ��'���N�"-ňX7��/x�5����G�V�'�o�M0�	T�2v�+tW(d�22ɋ_=�ї< ��Kg����l�1lh2EZz�B�=A��"��t�8L�-&��,(���U9�α��<�a]p������ayŅI��/�sq��W��6I'�,�+gCx_��!�6z�HS�އx�ռ߿� Bm�dU�R/� ����@��(/��ڤAxa�c���E��l�}<��~�K�uI�%�$��xN�Y�a;v���)�F�L���cQn>�/N�<�L�d�����8nA�����ש���˕��3Ǚk�������k��oXY��    ��!��5���u����	8����W���������!�?�P���� �ax������;�GǕ;Y��Yޔ��L��`5�R�Į�����S�dt�����$H{��{*�٩6R�% ����G)3.a ط�M��dE��"�k�PH Z&z�-�xzAy�&��ɪ���c�/A��z�#g�	>��KS�(maA�0c���S�cL����2\����3&��:Y�+\+U&;�"@:�B�V8�n���E�+A�_	fL�k��r��$sQ�[�rj<�qm+����& ĥ�yfb�Yu�p2A�P��%�:y�)����>�[�Yp�fokNC�!}��O����N��qJ�2�����Rn��Y0�Ѝ����	CЄ�a��T0�r�B��9a+��}��&�|�f�����n�i�8V'g�fU��>	�T�&�)�569cq�_�w���0���|A�i�S�O��B��}�%�VC��s�lAjy�h8r^�E���e!X��vC��������}���%B����Ҭ�ĝ�qn
�ַHT�"e�k��*�K>D
Q��Խ@���r<,�!^2��RP�y�xB�P�<�.���b!w 2m���i�;��!�
���`g9y?�F0:R\�?�=�c�ͪz;B�x��0�f�A�z��	-�N�5�h۲��Rٝ��S̒g�>il�*��2��.3SK�o����5��K�]��?8�
��c8%�A�����N����[ܨ^��h���Xp�X�z,�Y	���re���X��~�S�|0	B���=�<�bp0�п�aĳ3���S%��9���e��'I��#ȷ���Զh:=��0W�����:����4#ۙ���<��~b��P=�s�����n��E��[L���&��/Ybiv�X,��Q��o��5ș�|�|G��ʅ�n{zlʜ�Ei.���b|����ct���G��w~aZ�כq!�iIhg��/�>j�����"������'�!ne��Zr�=Ĉ�φ�;u}����Z��Y�;����r)�d#t��v�}EDS�IC�P!���dґ=Ѫ}��9��{�A�m�}��� ��c@ӄ]`Qy�w9xh�B��h���(⣕^d7���=1J�	�TO"(��$�S��T��y<����f�N�5[B�Y_��?��΋��ǅ��"M���-z,�����:��#5^���29~@^ ��y��P�Ja�U�m�eV�0��X��cqTl��!��A��;~c���[�.����|�45��K�q�F�a����x�I֘sq:�$��j.��b�xHn��Dg��j�`���dnJ͐���@Z�����DX��K#>���'��Z �=B�d�v�	��k����憄��q�ǝ�"�_A��<���ȓN � x���'�P8����7i�'w^q�X���W�.o��?�|p�亇l�����]�(à<B���	T��:�А�3]���PT����d���<w�0�$7ዢWúA9�ͻ�)p�D��`>�
���7�p�y�Ew��O��^@I��$I��O���ؚl�Uޮe+����x��������*%�����(���p�&;B���gt(f��?����[(���GeqSab&_�C���
޴��l�9}�����y��Z+�J�����ɿ--@�d>@�K�p�<��S(HR��k|�9Ȏz�{�~���v���T���s|�<���Q���K�l�����Pm6<��%�����O�k�f�!�w�#�kk9=�:%�zZ<��ݙ|v�>�pٖQhi�i��AP6��,i�T��Xf+~��៽އ�a�M��`$`��yt�'V�M+�5���R���5q��h�RJ4n	,73��5�e����
��>��f��!����L�����*1��Q�6t�g�O?�m�Bnٵ':��Q���r���$�;�,(]Y�y��?� O:|��'� �Of�}U��f7>Y�8�����qwK�T��pi���|}A��#5q@���{��Mk����_F�x
k��|ỉ���u��"-6h$s�as� J���RP]�Or�7G����7+��S齟,��K$p��� ="E�O� �X�	�a(�����M�)��S�������ԇhH�(8�^
��Nx�w���X�@��tE:��{�$��e��f�`�\����iZ
�4C����.�B��j��ϯ�&�*u{ 첱">{
�j�#���s�a���n1#�� Vd�c�,��~T�Er��ɇe���D��n?.����Vj7K҂<��ؠ�I;������>2Ay�w�A�̳נ������w{0���<��Ρv;�M��{1����BͰ�� ��OުoWoK��O��~(����G @���C�OpG��	�'p�C���b���'�-��J��]��󥚏�^�\>RP��#��T�������=�-<;d�*�h��V�mi�e�s�,�_Ȯ��e�BW��;���-�f�N��W����V�A�L�_s�9{)䗼��<��D�Uwe����P�d^��C��LϘ�댮(�����"����Z�&ֹ�N�<Mn��筩�Y��@���1�M�0HVU@��LgȬ#j#{`p�8�"���-���R�ɒ�%ٜRY���N��#O���G��B!TEOP���ri�H�Ei���#��̝���|3ӓ�IU�����5+9�)�h��XMRoS���Lq32]}����:����_E�qwJ�Y���c�����'Y�A�p��Cn����c��(�M�ŷ+�D�}���)P���^��s�Љ�Ib��t�ĕiN�"��Y�
>xo��jx��d�@�l�%�s�DJ�������m��A���~�Jy��
���.AA�Y�~I�9��9�G�@���WpP4 �C$�?�b?���k��p��[�ޝ9��_�a�v�73�4�
�q˿0T�[�������u��i�C�M��\��W�k[�'|���d6�9RyC����Dd����u� ���	B����g���a�	�;���+�g�#�Q4�4�(γ �R�!<E�4E����j��:~�b���(��Euai	���.�IFu�̧�f����Ÿ ���qeƏ��ͻ=������}���SHϺ�b��jȀ�Й��gA�6�Y��x=c�c�����-g�Et@<��Ӟ��������9N�Bp�s,������c�EC�mä��Ǐ��6������׾�0I���Uc�TK�ٿ%��������7�F�)IB����,���ɛ�Č$�D�5Cw���8�;%�CzZ���6Iӂ�" �b�n�$��o��!a`���=:�;|�mav"/���/. v���KL������B��~ *�7�J
�o�&nd`���R:k�!�:~�y�.�J~�P�v'���K���S��uW�� @ASx�]�,�j>��y�í�g}��G�#�$�<I<&�� �I��Y�㞖��b�v��Y��*vSF����a���Z$�	�B�Mx�nu�},�h��>�X��q��n1�m��M�vo��,��S��oi�Yi,RW����f`N]!]K�c�r���2��Ӽ9�j�O~�G���FaͲ4���G�@� �}|!�<)�>��V'�@,�=�Ϩ����i0#,ӗq���������ߥ��T[��P���>��|h㧑Bq٬5m�Y((g���k���w��<�qe7�[���ab,�����822�f���ߥc`�	�S����O�_3Q��b�:\�����ɋ$r7��2GE8�?�ܒ�wU�a c���"��>Ŏ'�f��t `s�����z�陪�p�_	�G�wE���.�WJ�O��@�N�ZB�ۥ�����b�9$����~���)�OrO�	*&�*JȄ���H/���~��(��$����o�~�p�
?on�.�n2�H�������u���tC?�2�H������-�S�H    �'tI��AZT?	�KVb�Bv��=���vɗ������|�O���Ƿ��O�w]&W1M�J+TQ�b2�dȆ�h;��T=�c.5$�)��#:�t�SBǼ�9 ��u0��/��}#\�����X#_�F�勉��ae��K(/����mg�ۮc,�C�G�Ԏ���ӱ���Ł o�(���e��&Q��'�Q�)qD����k�vӭsu@�V�ÃF%b�gӫC:�SO"���W���O���;�B�c�* ���`gǤ�eg��/�:��>��$ق�7S���6��H��>�x���P�n�=b�@P�>��s��!�]���]75�1��_q��7zuªF\юu��`��1^L�m�L�m��g�O#��]>��߶�tc.I�qg�
�EʑsF��R�3p�6�:CE3��k_uWC���f�݋�8� 9N�9��R?��/(7��[��ؔ/i#׿����O�
��72��7�����%���re���e�܂�O~��:�4S�F�VP��;S8���٩|��4Ӵ(#^s���J�/
?:��);�@�d[P�r�B��q����e��0���;L|:�Fz�B+���G@fC�>�;���1�U��v��`�#�<��Ҟ��\�"*�|�b걅�������O��BG�B������+��͢1Yi��l�4��Au�;��+�e��\���G �e1�'8�+ b�@����+�xZE����л�\@6��^�͉`��v�ݽk{^��q�I}�;v���:��j�N��*X���f�q�kI�[��m]/@[*0�Ƕ1c���k8s!7Q�&tGWK�G=]n	-���*�~�,��?_DC�S ��R I<~�!)���)�a��O�����,�Du`����@��%����/�W �b�qE�lV(^��tM��v�� ���p�����w|<ʦ,�Fآ�80ڙ,ܦ�����&|����I�``|{Œ������ t
����{6�Op����"��ݒVt"�t��7c>��6q����P�Ǔ[�R�?�}W��̲�s��o�
Wx
]	�}���_�ۚ>g�=�[j��G3�i"V����H3��J}�Q�/�Nzs��t�V("s�X�R��8m�ͥCvc_Ù�#��$K����;g#F�hUq`(A���%�a?����Z�p�n�6 ��B��O�n*~���S�	���9ߠ�Fm@ڴʟ\__̋ю�p���}������[�{�����x�S�j�a�)Ώ^��)�����������iըR�^)��Qp0M�0cv&;���$KO�[9��@nۺ�@�Q v�X e ��L(0��8���0R'}勬gm4��'ٝ��LH ���5O�*����ce��P�O���&:W�c@�"r��Z",lkT���Ⱥ���w�0}'V9T�U/әP\D����d�8|Y�+���y<^=�7��x�A���� s���ԭ )�H�f��A�p_�V�pe�1�7�Xb���4��3�R�3�*}��%4Xs�X.��7��[C����u��3O5�yS�>I+�o�Y��k�,e��|p�3�`�,\QL>���?f4�Tpkv.Wn΅�l g���#O�ѽ��L}���o�N��=���@�7�a� �4�C$�ޜ���]QP�Q��?�?��D�K��3�7��8OS�r�l�-�in�dxg ��ۂ1dk�|z�2�V*4�i-�"���������u���$S�G��W��Gؚs�ٸ[��5������P�g�o��eD~�<
rE��O(�`vo�G�@�4�0��j
�G6��l�6%X��I�K���E*Q���%�]���|�t�p�@j�͖g_�$��ʼ�CX�o9�2D-8�c�!I�|������E֫��C�1�z"g�É1����s���\���~�7]���v����o@�S�H����ْ%���6|X{�v�&!�P� ��%���I�����cU�/��*���n�¤5;Z��ey�����Э��军���dP�=�4O[��g���H�33P�2�:=�M��R-�"(�w+���?U�9�0I�1T��c_���2!�0��(6����MHf�	̅��;$��BM���z��V��C#��rU��A�v_�ڄm�=M<�5�k���J���Ī�4[��Kҝ�97�����\y��v:~%�P1tg��7rC�_s.i�W��66T�;kg�l�o5� =����.X���O�P%��c��`�R{����&��rc�yR�'�A=�V^���/�Un�J%�ۭ���x���V)�)8Q���Qv톋�5LU.��jĔu�+�"��0M�}�{KU�'�#$�s�_��j�*�P;]Hx�,ٱl��2��J�X�[�g��t����)�Mb#��!S
L�D��z1*�|��v�S<ֵw+2}�7��/ 8�i,�P�KX�K�Q%�]���"@)���Pԯ^88[N��a�u����[`�(�0����;�P�U�ߛV��z�i��6�,��3k��Q6�8�����bᒧ���V����݁@��8�q�͡`2 ��.<	S���`]������,����Y��u~�E�^B���%�n��2��)Klo_X7�K�O�p��7��"��{�C(��X�s�j���&��*��r���"��؟�꺡gZ��K��Kw�*��L
�:6�X��Y`�k���O]*H����U3$�M(�|Ʒ j�n��^��S�5w�I!������<,�(��\|��O�F������0���?y����?�@�?I�'?���_El�܂#|�e��:22"�L��x����`ԅ��L�{i��ã�b�%{@��cZۂ����J��z�,nGP����'l6��$�Jׁ^�uj��D3o��F����S��\xH���7L�����7�@[�T{k^�n��O�>���g "��H�t@z�8���>��F=�m��V��h�*C�/$Fʶc�
�F�P��+֎$��Dy�;�{!�S��)�+�s�Q��6�r��?�L{�s;:���&p�9�	#(L�d�	 i��`	����]����9�:�?�����Gm�������6ƴ�ȏp�s��	a����|leU�͹��J�C����z���o��_��_t��(�x�X�r>V.JR�{h�����p.M��y�@�Ooy�cP_?'$��G� |3a �o�H�?"P
�@�X�X[�qD�As�m�(`���g����	�ս~��`
9X#��Zeط#��:���V��,U���IA׉��L0�y�r�D��M�3 8���tn�(���A�X�Ue��)"�E�XF�v��ƽA�� U�h�%	���}ֹ�
Zt}�!mb�suC�eɲp<�q,)�G���VZ���ϩ5F�Zw����>�@�VR</�}����<Kme�����C⹠닧ʻ��N@~f幀�����Ì�n�b*5Eޫ����ʗL�䣪 �����E���L�Z�{��]W6@�5*}�>1D�>�K�.'�i���`�ޏg3\�U��Y�DI��z��$`ٶ'7v3�����m���!�h���ByBs�2H��T߿���s<��m�^w���1�z��j3��"�|Y3�����{K~5uw�7mԲe����g�3��
|��	R��܀j,���au�jWj���!o�$gz��ŤxS��M����*�w���"�zoF��2�xz��=џ�ߊ���"_0Fbi��:��b�P.K���o��f�<�����%l�1�Pj��e�BN&���!�ي�S9ȗ���G��&zj�J�T�t��[���+u�L=h0�q���p ��?��iXA5�=Ǚ�?�d�����`���^x���B� �doDBH�1(��Fw�����Z��j���6�ɸ\���	�We��աE�q>T1�{�����(�bw%���;r�����pl����|�5||�۫��S9a��`����3�?���ㅲ�1��.��    �1���)kZ�Ն������~�o�Q���QD��)�~e���q�r�����f���ж�����ր���(�Ф�F(	~0"��?K�cFbx�aa��v윷ڔ����|^~Җs��Gz�5�:����;��`
G�,��ȷ��x>��~�8�E}�$��%0�dB|e�� �DO��G�0O]�vP��Z����Uv	��L^����cu�ӟC]���Z�����.h�sE}'��\���8����e6��(�T"����~$�.G�V��Sӭ'.�ҠO�K�A��h�J��O�����6��͊���5fXU+7��ujc��F)�aȬ�A���$1G���	]/�@>Mn�8��Z���H�&�i�p���<�p��Uf�ͩ��ųG�q�Z7��b��%T=����s��q�!i�`���� �	�m(�Q�a؛����d�}��]�6޺��m��.Tjj��ge��wع�>9UPSeKv�`n�Q{�U���+q�:~��wX)����-O����55BUM���j��ka�Ƨ�uc՝4����b!Q��o��i�I|�	\�#H�P^|�S�:��9�xl��������j���A	�fo~�d��ۧ˫��ݑH��R��p 3��&�>���>G�MTPqϏ#43�x�pe�&^3I�jɫ�����'�YTȭ2ɟ��p>W�
q��TP_Y��8�(# ��a,�t)�]lj!�J�
��[��C&�����#���!���1ŮNd�	ϒ \fhu ���|p��HCli�qMRč>�l����#G�����A�<k?�W*�0)1?Q[�Y�//�Z�8��oY������'s4O@,Isƒ�԰�Ml3�Hg��#u��o"GU�;�,�B�+�MW:zC|����(��aw�9./I��~&h"�Rp���4��%�J;��~hFQ���yS��tK���;r�e�?U2g-�{�E"���m������k�,�����6$�NF�c̷?	l��.#��)!�ї�ɴ>˓� @�m��t?�ٽ�J!Zi��O�!�#=	��Y<Ir$f�4��Fc�Љ��i<�m�h*�[i����
sP�6h)�y�׬��[����T�Pă��BA�,�'at�Q�Q��������O\�ѸwJ����Uk�d��"F�*X4c{L5���0n�#��~�<�k>3[_T�0�/To�ŉ6��G<��Q��B��&�����!� � ���o�]
�x�Zza��H�v�[���+�<�@ �z[.G4E�T[ !���4��_�ؖ	ƚ!Bӱt^g���eJK�\|��yI��!3�*9�+g�� ��
pn,����'�g|7ϱ0?)��N�v�r�ƖMf/���`}�i��`xڑ����Aذ�4�p���|�6}��OX����8A�ܑ����=���I��9������R�nf�=�N���~���f�GD��>�[���U�Y]7��0oW�WK
���� ����[��c���ǻ��~Y�댎���	�ͼ�F�IZ�$�fe�ϋa�*e���=��Cd.�=r���BW�o����ˠ7AP�͎��d ���X�pX�*�ȷ��R�y�9AI�����43h��n
����nÅ�Ǥp�yƩ�����3;@��8�d�K�8h��&�p�u�li$��(���e��0hSsYM�\3��%���M�'^����{B�tc�9,D�i^���+��ɉ��R{G1���J��N'����B�pSx�ݕg��d�W��N�%�1Y�R�����[|�?7��Ʀ5
��a{
��+@�J�\Em�l>�8���'��Q#�z���������uG����$��y�I������?���n�E0��gS��=.���ge9�]���ĺs�Q둽�p��DG��mB�O�0'{t�-\��&��a��X�|h��nҕүO�BA�	$v~�#��j�e���6uR؍��_���t��	��H��������30<q0N�_Y�t���v���֛���?w�E�Z�]���N��c�'�@ny!>���֝��~�+D�ˍEJzJFd͊7�y�§n�`�Ԙf%�>x�m3�Nv��!&�S^6�e�r�Ք�v���X&����7��S0�Ef$�a譤A2�H�+�G�޴�r�m�v�N:�~;��:Bw �����y>�ƍj_4�R�v�
z ��e�r�5���}<u�$�9���P�%���:�1e���ˡU��w��)FR���_����l
��>v=��'z���FhAo�ei��mA �Y�#9��a��8�>R�{��D�zӯ>�;Uø
����v_���l�[A�Z8��=���C0��l��r���'3*����՛�}:�z[$�������]/�m��b����h[�2wû�=�K��m�a��&������E��s���+�e�� Ŵr�A�i3O�ϕ~!�F9����s��i3�4ͧɭ�B��9��	��	^�ڦ�4Ĵd����8���M�g)o;7��'(]�HѦ��y�'�;��B/��#~�k��Uo�� f�n�݃���KH��9��}���� ݢ�V�w�侲���  �V��`��PRx�|I��B��f�9��/<�@ѪLF�Ȭ�����}ӛ�F�I�iDrt)�z����{�RN���{t�I���[ܛ6�������g^�'
Qv��z=��aq]����nv��_B4Ib .@?m�y�E�B�?�#�����g�ӔG�T�O�/�A��6N�=��
f�@pѶ7��Y����<��4+�N�hI:�MW�9Ίcn��z;@�  f�RC�s��7(j�5 ����h�-��V��Qe�A��q�G��=!��!��)����J	���A�f��p_y��	?�,�C�R���`��˂��+]�j5U�5�ΟQ�T��B�Ż�S�����'k��|�~�@���=���t�O��qT8�O��ЋcJ<7���h�Z� ��������������RI��I��IF%Խ��W��]�/�;gY�!�+�O���N�H�o��a#�z���������$g���$��Ժ�P��k>"f�5��M@��������*�&a~�!L��pºQx��|�{���a*��w/x�0����L"/_Ifˊ�C%>X]����ϗ��Up|�����uqKd�p"7�g��$Goe�:^Q۩�rLכ��j����;I=h��Ք�lAUJ۬������(@{�;	Z��)���F��_� >����o�~�w�%k�����v��,��J�
ߚ���#>��y��oZ�<�v�6d=�a}�|�b���l����XR�/q�xJ_�*�;0i�XC)�x��"�����B=�.�$37�$� B�'$9�X��3jU�"��;�:�^��F
��?]ɿ��*��"i�~���;�9��ρ� ���D��c���wH��pmoic�j#�:��Ǭ�N=Q̣�`���}R�����) 2%��A��j�^V����"�-��)��c��蘐ڵK�S��v����H���j�?tl��+�鲳�w�Yzr���R\j��}�/3&�d�5�m�N�Ӕ=�-ǧz��imң���*��&M {w��aÇE�S��!ŷ���d@=���(�]H)��{����y��pFK�=�c^�n5��IF���W��Y��U�R�w��
��M�̊^�T/
,j[�$�\EpWѣO5�=��L���-��y_�G��3�N����L��aMX�q�X8�Ɖ%_����CR��#���`;��é{}�Z���s/�=���8������|������A�<:�}Z볼���ۦ��b��Ms ރ�B,Βg�$$/3�$�(���z��U-[�a{�]w�5+��Մ�t�����\: �k��y>7 ҡ7���}�29H��U���S�8��YU���7��|8t��O��������Kq#_�{+@��K&(Tt�8΋ץ-[0���yɣV���*ʡGL�    �N$Q��3�����J�"@K�B{ �bm�ٞ%��ƕx� L�Ɠ�8�=x�{�$�p��g["��>k`�0��;5�h*�p��J�⤅��K°��D+9�晪[d��za����}�L�C���,�=C�2��!e�"�x�����D�=��Ձ��4�������*�S,n��7��H�1�n��*��� I�����vV;�{�$)�[�z�*�yA�vw/��FMf �P᠔���1��!^5����J^�I�Ȉ�ji�ObA@<i�C�{p�^�y<����?e!�oA��R�3e�Q-)&r�8�2��ߞ���D���^p�L��R��F�
��큚���M�MĶЈŃ[n�Û%���X�,��	���D;�Xء����X�+������ř���XI��l�[թ�sN�0�}����Pl�P�[��3Q��+�oc��ɤ��h7#�[�G�z���F�
e��?�n��K�#�C��E���q��뻽E��ӂ����'���VDZ�S���I���`w� �-@F޳�bΒ]��d�
$�BH��	�D�4��ҏ��Ki��|�_���a���o�+����g��쳞[��2��G�� ����Q#ͨ�T��r�M�7�Fh��.��!�w�W�KǢ�=�ݡ�65/�ү(�u܍0�_�J֪��/�Y���S�=�@}�����qu�~�o��Wj!{�m�s�%j���HƇy|�N	*�F�m�R���%������m2�G2���6���+4�� 2(O�[��Z�����	.��b��)�!S�^��m�����콈TbT��}�+o	�Y����ؘ��2����	|
�Pdn��l��w�V��=@pb޵�R%bT�*s��1oeɄ�1�:�S-0�e�5��ps��W��+��le���V{�F��S��&LRGD��xZ^�|<��і�_�w�b�j��$b���W���z����EY�<�?����1�--.[EJ$Y5��v5Nj�G�#�m�+�����L]�h���<>14f���D� nzLVo�v���\�q�Q��
_~�&��¥W=��ES���yx�W��7Bb_(��Y��Xǧ��{V��>�����`4}j�˖w*�G���p�'՞%�Ӌ�^�a:�)f3�V`� �jq�P�Wr;'q<���֢���9Xh�p �Vk
��z�D�l_��0��D�<�FfL��{������EA���q�	��?��� �Gg� r�(���/����I���n��mp�������>4K�ˎ,��i� ��xc����V�t�v/!�չ�'`��(J&%a}����S�|����R���N^78AU����"���#mD[!��f�S7��þ�j�;gᾍW�O2�T����&yhpƪQɤ��n�Y�n;�~��=����F�i1��ۘ��86�&�ED~�:�#,��"w�?�:�U���IE4] E}� ���o�(���4���A|�������	d���C^+���#���H���A���LB�!!�J!�}��4�~S	�U LP��,ۏ�@�-�ю�KrB0O"���n����7A�C=鵁7R}�%��,)�e��W��W�5ԅ�kFY��/�����)�(b41�Ƥ�ӿR�]D�KLH��L��]�]u��zR���.�b�#��hz��6L�S+����}�D�T���-W�ݙ�S1�5���D�8l���mq�j���I*�!�������jR��?����8 �w�2���Nvd<B������I>���*��x�Cu���6JW�1
��=_�+#�;.?�m��s���3���CJ��g��e���Щ
�����k4�'nA�12����jkaD�;�GXԑ(P�{�7o���Ɵ3��eE�LO=���9�|1�,�;��vA�I5f��[ ��{cqI$�·-����%ز�ı���:kx�+�%��M���sZso��\ �ǐw V����U��Ɔ���5�9ɩ����,�e��4
�1�A֚���I(��}�g(�0�m�ة�9>�(�N��Q K�}���s4��5��+v�\4��c�><��닾�X�ߤ�g݆�����
^�7�[&��d�U�%���8��E�\q�����6�<�z������HEt�U�o��� ���%�[�!(Y�e���1�fj�J��b���<Ok搃>�����r�7
�gz�1��
N:�I��Z��zڎ�-�l�Zm���%j���3��%���o�@�JK3��$O��"��:����X��>N�<ڵ� �9���'7DF�h���8$4|���a~���K���QyI6I����	�$5(��@��Y�-
�oK�v�-���l�H+[TA�����|��w_N�� �	s���CI~������|�z�-Ea=8<w=�ʤW#]C<T@����%�ZB֡1c���)��~��CՁ��$cl1M߻�-{D~_���[ǭ[��Tڡ�����Exo_m����&7�wR�9�e�:�r��5��~�l�����SWs�-�-ê��IؠA��|���E�<����B��w�>����c� ��p���	9�����m5A8��2e�_!yc�cQ�J$\YP@��t��siJ=�*NL�-��&�=������]H��LX�A�\�S���I�2{�;��'~�F)�ĉ#��#V�'zaRI,�Sl-b���gd8�4V[|L߹��i
����K�j�z��}��#���I�7��7gU���ϊح)�Vْ�����|y�E����;Ɨ�U�H�z}Ȳ���U���u����ejt�am��KX��J�~@#K��$v�ΠJ�^T��"�D�=j5	ڻ���V&-�TQ�2��� 
��Wq���c��^' �{����_�����I�ȌN�ږ Z���!���YyG�kv&C|;O��zi췔��p�x�fbP�� �R����_e���
gĳCޭQM�!�CeO��xC�v�{UO2A�o�����i���{5��E�����c,<�::�S���$X`��IHJ`ĞE����"�g�������D�b�V�|~V�ND�LLp�%3ׯγl�ˮ�	�+��>5%V�����
~F�e�{}���a����h �����G��H��~���@_9���N���ޗE;P�o��w�Z�V0��dL�5(3r"���s[�j2 �L�̖Nvz]P���=.&�bA=�\!z3p��=m-�PB�gt/�[w���&�K���3Xޚ̹��օ��`?�d*�ƃ� #]{����mׯW���H��R�B�D�M�8�Ɣ�d�O��c�t��\%3�x���\in��jv�5�+n�VEr�0�s�'��w =�Y_7�%E�6��'�y7����<+:n\��jk�7��=B�	���FfI��W�?J4ka{�[��Ȕ���}��Gi��v�1
4�h�-�*���"�_��a8��r�l���_��MH^�����'�Ty7�9E�V{�	ԓ7���j�CN�:�K��q�MW��<	X��"��&�R�Ϗ�����!��h�����o<2
�8���$������Cy��c�C����<a���w�<���8>��-{�<z}@%;��N��2q���[���/@�p�F^�z! {�jnh��ޤ{:�Q�&8��Y02����9}�����Jw$�2{�N�nt�?T+
���>Ve��,_)&k�*W>����zDR�z������PVâ�\ۆ���l�-�4P�d��7�!u�E�)�ͼ:Eɪ������o
�쐡!!��5�~퉝���K�xo>�M��'��~qc�6hG��ʹ��j���m�����mru�?���.&�/�*B��mL4�#�F�h�[�O�^]X�:����i^H�4e� ��k�	�6�Ԓ�G���m�ԭSK�"�*BTVGJ2���ݡ��a�w
qAX!��5p
�զ��Y� @�F���^�f��Eya��a�z%��m��4�j헭B�!�  Љߤ���}r�_}���Ņˎ�	ɋ~� /  ����-�$���>���ϕ�_eB�<�tR���nl��=ᓅs(4 
X��M�x؇�O�gkT��M��֮$�����	�yhu���(m���u`+�I�DW�=@�b��  �֞ 1���q�{�ď��`�SI�A�dvʜ"��y[.���B�I����h���~��HG[��M���=䉱�-J
r98G�?�O�M����O|Q��>���L�hdnV�x`3Y-1���+-|� C���O��M�<�����݃ƺ�f��)d����L���t �+��`T���H���� �Y�H��y��GؕU\W,L)K�СB�̗�Pk�4�h�l��4C�Ύ�����gk��s^�խ�6��A���(�c�
�Yap���U ؇�(�)��<���������,���ML���*����cuWGO�#I�?�������}fATAoƑ�'�H�������ԏ�H����S�:94�2u��w�Q���F]��y���}F��8�{��?������3L�1�������j{���V�����v�Mo`�9��2� �W�D�7|0�
���q&�s�f�)�����{����'eN",:�X��:&h(5�@�����*��y�	�� .���n��-^��[�����1���&K=aԟ�'�A����̘m��ph�l�Q�(�P[����:��H䓇��J���Aӭd��/C� ������ %��s)��{�ܺGR����%�8*XK�]+!gp����0Gu�<���a�f�cٗ����}���$��ċ�JG@���X��
�"�W]�Pж���o{ul	���y�3�S�.1竷�f��2P
@mn\�,t�\^�;@aƟ��U�� %��;� Q�nyR���o�������B�O"� �g���j�i.���$l��_�qsv�r=��>��}/i�����D�֑4I��6��Z�p����!��X���c���ٟ\�2o7�Q�r�9~\~�l�q5
7BZͳYAЗ�44�����]>���������h���      �      x������ � �      !   �   x�mϻ1�ښ�8��K�%���b�}�(��"���̦�����;�f�!;L}'ՙ=t�I��r>�,�َ
�gdXM�
(��YRS�-u����"��*���50!H���]Y*��3p�5")���U �;�\Mu���8+e�fSw�L"��?�      1   �  x�}��n7������ �:�v�HS#6rQ�f�ǃ�w6{��>}9�ή����#�I�$^�F3�fN�I�ɀ�ޠ35������۵īu���{h��~P��'t*XtT!��r��>$���"m�B�V.c�m��VE�1Vё�=�u���V�pr��2`�pc/!&�oj�>��8��۴ϙP�`$�dB�cl�TC�f����%���Gn���D�j��s��6]V=p ���H`D� P}n�fZ(@�yX�I�d�B��m}:A�ܘ?K~��������NDB&���v����M��-�^��f�)~�o@R�3�54%M^��&�C ���r��2����Q1��_�I� Ɔ�����#Ӳܑ������2�I9Y�j�
�V�[�L���[���7�]?5�M�����K,�z��Z.ׅ����fqk���n����XQ \��>T����{�Z�Rx�!��j�~��vs$F�%�d�"���NN�@s�#�:�{^ڕ�<ϥ`V�8v
�YT�s*�Y�3٥�ь]��`j�~�m��O���u��)6�����!.tSO�DZEDXC��i�u��'4��8�O�~cÎNWQ�~|�ޕ#�}go���up���K.Ʈ'e]؍��1q�%n<*����A?~�PA���/*q��r���5t�\���j(66�_�q3=E4�0��FT���wK�a���B���Y#
sxQ�8�Lq���r?����l�D/�
�Hj���	�	0��g��c�>��4�y����q��dGB=N�K�^�'�YT\�Q�5��w5Ms�d�qڀy53cN��:َx���!7W����	TC`��b-������w{W��'��
������v�{�YQ��g�����n��m�b���ד�&r"������y�pH����u1�x'̞=�����k{N��������B�#C��      �   5  x�}�ݑ�0��Mn��	��� ��q8q��.��-�E�b��~���GXto�+txC�j��Q,ꇊ���Mt�C�4�L��𗕇�m��m����X��e�HdpHdi;�ۊ6C�tX�'��R(��Qܻcp+�Z}���ԥ��_t2�:2O�R���'��/�~d|�Hb�!\�y� J��q3�,�E��|G�xz��_���Q� RY�S�4$ٿ琋q)�D9����h�������(4�sg�C�"�[�k�p��~G����9�Nݠ��6X���|��p^�W���|p��D�BD�����      �   �   x�-�ˑ� D�53%�OK����+�����9rF.<�Qx��������'�?ݦ_�yr�o�ƅ7
.�xQ؁�/��X]!ο
E��
m�B��E*$�B�T������ȗ�N�]QB^T"�U�g�!������<��v�s��C��ߜ��=1:      �   Z   x�3�Tv5w�p1�tL������2�Tvrruv2�t�-�ɯLM-V �s*������r:�,8�]\L��8݋�K9�L�b���� ��1      �      x������ � �      �   D  x�}�KO�0����`Q�f[�L	6�Ip�%��#�}~���,���w������j���U�u77�nͼY^Kͬ6�t�o;���iղ�zL���@<�=f�S���!P"H=FJ_a���GI� `�Y�ڎ��@�r�`C��˞l,�Ʃ�����h#�6O'��;3y�h�<z���#����n����&D���=cI^,:�$��)��q���S�#z�ʟ�W�'��7�E�#�.z���`	[��:W�d)[�>e�#��EJ��Fh��<��De���)�tFuf!k�����z�.��h�[��v�j'����囱      �      x��}˲$�����+�F �S�j�5�)���ٴ�����7���#��r�0g� ^���8��������n?Rz�DZ�L���ӣצ�|�~�������_����?���o��o����������߿�A�5����?(?T�(�I�єP{t*��/�����_��?���������b���6-ι���#�Z�j'���Uꏬɍ�W�L��I��o�Ͷ�,?�>�J)Vp������l���
�QR��5���&�ش�d[��-K�Z��l��9K�/J���+?H�Ԗ+?��nK[���4������\j/�dM��Y�Ͷ~�/��Mq0���p�T$yH2V�/"ǽX��ql�A�Q���$�V�����.��|����~ln\�k׌$�p����G׮��|�;�D�5>u�aj>���Z��U������c,i��������j�&��#	��!һq�Qm�׸e�lR�r�H2V#����=Ω�Mst[E�@�/��3Y��(;Y�'��[M���䪺$+l'��9��t�9��5�d�EˁdgX���+�]�_N�����\{���M�<���A쨗���q.�TjuŅ�v,:�w��#�K,S�*��0�b���=�F�
�CRhto��­�@���2�my/D%�J�H��)�L��o�/C��_�������yӋ��ƵT��C@�n����\�/D����Y��a��$���^.p����G�>����I��j���ͶGT;o�9(��q(R�W�m\����l��M���@|���
�o�h��U�1�b���폪)��{9[��+ȹK��5\�GL�s]�--��
���$)�����x���v�%n��#,�S��`��ܪ.�7��޶�fۗ��1��ɔ��'��l����*׶���.� ��fi#���3}��P��a�����9J�>���d�'� ";Ef���Vlya�vn���,w���Ӎ�ґ��M9�,��?��{����
�T�C�������Lj����-l��C4�Z9k��(�i{z#w��c��fNzk�kM��y{�XS�^(�������y_���-�)��3;DLû|.���O����+j�nS��)���	�̴�����
5Qro������f7�K��O�{�y�@s%�e2��dgl��Ж�H5�/�7g&�-8��9˾��Fa�� ���B�c+U��;�чQo�B����p�M6�B��Z\D�f&S":�5�a����@L3�GmXc�z�G~�a�'F���L�^�7�˫r�1��v��^�K2�iB�d�Ϋ"�+�Ѓm����殙
��(�no_/�/F��y8�5���٬a��M^3��N�a�1��)�<Zmִ���d����^N�8�?��!�C��f�6]��W�}o]O�p<��섘o��L����uj���#���msl0��$]qm}�-��8����Ï%p),�Df�
���k�
8��K��9]�X[]�H)+��z�	B4g��Z��".�y�f��W\�S|����F\�8[k\�'3⇹=�H���k�f����"�yF0Nw�� ��v�v\kJ�mC����-�9*3����ۯ�pHz�5�9*�$�@��ζFj8;��R�����%��n�k�(���%�E�p���n��%�=��x���
����,�K��#�D%M�O9��2B^��d�^ k�Pq�)�	�	}3㹸#��#����aOV2o�#�.�{�*�f��NV3�o��(�W)�F�8��R��(�H�0�Sl���mھ����z7�HG�	�������2s�� b�Z�B4����p��~=&=��3����K$66́.f^x��r�t3]窽vi˜�t-��f��gh���p)UVhs�MZ�U�35�yE��*Ŏw]����I��Mfh��
h�9rYX��*���D�F�	���bz�.��8�d�"��9�)?�]+��&�r!�$m�Fj:�̨�{]V�L;ެ�h�9�u�#�Č�e�.7LYC��� G��ش�����5/A����g�����ش�i/Ƅ��1�(A�@�mB&@�%�����ϗ��E�#�����kq11��F���^�CmGo9��"m�؝̏L�Ps�]g�e��0c����{�٣.���=��mWg���1�%�qP�j>FKr�.y�F`��n���}MB��Y�<����j���G3G�ߤ�������B�1YtH���Ӽ��M�M�\�6g�g���mZ�A�7�M���	T��Z�y���^�Ύ��l�wj&-!2�ۿ���3T���Ś� �D85�$�y{��o��>��䣽�M����j�� �q!�ےH-�gz.�W���s���d
��K��h�����=p��҄ܐLnf%�Ql�{����fp�'��`����j������O1���ɨ �@������ڔ���)�VlP'�+#n�E`�W��I�IW>����`���W`�"�; _���eZ	�Õ_m9q�H��bRH�)���#M3Ɗ�0�-���'�ٸ�ُ��M �&;�*X�ъV�@��_�V�2{�p��D�۰�l��
kӭfr�|�]��&����Ʊ��o��J 6�¹�Ժ����I�ů2�Dm�K��{ġ����F�.7nr�����̅�a4�R1o�oqM3�PSD��nsw�+�8�����	!����D�֯�z���ہI��1%��mc�O*v$d����9Wlv��"a���m~nv��-�I��<}�L�h���L�X �bl����5��etA�F�ULG�d(��n�["�e&
�	��C��lT�7�q4A�%J���������=�2\<�,�8��g�� ��*��{���jy��i��K!s�.��-�ed�x��:���l,������?����������/�����_����2"���f*3c���6�_�|���c�|9�����|ߜ̳���y�Z Wϣ�V߮�.8D�����s��ag3M;�������rq��)� ��}0;�ӊ��#c�q)r��q�]{7a�4.�
����@�J?RO)-�,��4_�V���G���ST�֗94W��E�h�=2R�P�����I��\ͨ�BhsL=�f��f^���	n�	�������8��mp���+��\3�yi��j.~3@������& �i��'\"�;�vz[[֨�~/gR�L^������C�f�6^f\��+|���3�7�z���ִ��V���OX"0Ҋ�H����n��IS�Ƿ�멞�BS=����I���WF�$.�"�g-���k^�ͽHD����j���`4��K��&HՖs��ʳ���F�9!F�+���n���̔�Y�?�V-܌�@�U`�3]��	����!J$���I�f�\9�Ӝ���9L��}���74:|9�E�[�*�"�������}��IfF'�r�M�m���#S���l�˔r��e6��a���nt����C{R6�v!�	Q��V�٬qX�;`��ڱ�z3��	�V����gV/� l�[{��ya��ia�5��c}�|�������'�4����B��Xߴ�o����T[�e<���_]n��*������1Z-�x�W�������ɜM�o`��g䴴�:H@��A ��Pӄ]ԏ�>Q�*G������x��$��r�b�+}ϩp!m	.�r�K(8C��ef�,�R�˨M�dΞ���i��(�<n��[�mYeF\������ګ�+Q�R�NW "̑j���Mx��,�h�o;&�13tX��V�p�;�Ɂ��ly����(u��<��+�r6!hGF�ӥ�
��dR+/����5���L��dp�FV/+��q}�ʻ�j�٫-��Yį�ѥ�����~��V�4� ��$.b2���������v���T�������`i^>����~�H�'����j�u�A�y��������=��K^V�LeY`�#EN`��]�v²{���R#������~��Q����'9�� {��p    �����(`F���R���=�4[�z#�4�98ʾ�"=M�3n��l�.�S�v�=Y�r�P���	�ȴO��ۚ��U7~AT��H�O�;���n.\�Al��To�D�ǃ<7���Y�Zǹ�\q;#�_�ن�<�D��ELt?�6;�Wd�G�S7���)���˷�l<^J4p�p}M���o��M¹�$Od �|�;OY��#)��Dv��Bv�Tv) ��~���ޖ���v�1�ݜ�����̇�����N�������\�q���hә$j���Y��Fv^d�О��a<E��h������J�v��l��dڨb*0�?p�yO�2.%���b����\�f��Q�����=�qe�̶]���h��aj�I������(~U͒���8��c�0n'�ss�"��8���K�+)��=��]A!�A_�q�NK�^	�ɑ2�i��J�A<�~Vɘ�f6B�Hf���U��$���.�l�'n���nj�����U1O�yǺ)�a)�nc����BFV*$]�A�?�9�D")'sV/����B��8��	�=*�h�$�k��R���b�����LO.���_��0�C$��MuK_�Eb|a����&D;R��m��ӊ��5Mz��̊,m�٠3����nt�S���H�ri��~��Eٸ�K^q5�s}��~���b��Or���5�����U"	�h3���;$�g�Vd�N5ˏ��(��Y�{���a(
ո8�偦 	s�=��8�W��I*'s�B5ObTޮ�ҺE�~����睻������Q˅� E��/P�p��X"nvAM?�����f�����8n.�M%��G� ���E�������~��s[��pat'�(Ae�v���v��[I�;�#�
�W
�mJ���Sp�I�g��Q��X��mY�v�4)ZÂw��AWA�������u���W�,� B[���C�n�{D��$�r\���\����z���%��(�0��q�������_qA~�Υ.���+h���]v�/�Z�'�ћǬ�T�b���kݿ��9B�[�R��m��\Y~�ƥ6%KNȞ�_���Y�{��W�l��p@�;��#���w�A���E�R�+2$G���k6�W:�TB����
nN��)Oָ<�%u?�|�~�ɽ4�f�o��#b��t�z�_nH|D6�9��D�j�.��~M5�g.>9�A�����P^X�r�ޑ�#z������f7�e5�L.�c1���X��l�q�R��;Ԩ��6"�|1q��5̙���^Yw$هMv���u��gQ6p3t]5-4��;n���D�z�����Kd�U��Ed��zװՑ��Gn�@���t:C���!��mq��"�x�8��Z���2��p��+��8��1g.S�H��q5�E��n�mb����h�v��&L�Ka7�rB���Ď%�d4)-y�r�4��p�2|�ӞѨ�(�/��$�6I���u�Ed�Z�D���J��{��j�V��T(c��m�R���'���
�iEf�#d;�`��Vdo��eY
O�3�X��rt���)�l�]7�`2E������s[�A����vA{�69�/ds�[ĝ=����%"7������B6��ʂ�n�uENH��s*���ܓ�'��"��2ȴ�,F��^��M:
v��.�Yl�ma��u�f�(#�L�#p��C�TO�MmU�Fw�@m'L7���us��YwUͷ���q�Ȟn[��0�kF�!1�@0�m'<�rN.t=��Uu�n<q�zͶ/����o�'�=`��EYtηxaz�'�U|	0������DDL�������{�K���]��jg��N��d�`�x���s͓�1�j�-t��d2�ċ:��b�)VrB:u���2%F���6=�tG:6M��Δ��cܽд�'�c����,�y9i�,�S��}�^�̦��~�;r
VL����|���s;P��3���wΘj�D9��oR����F�.�Y�n&���f9�����iY����g�#�y�9�|_�$	|s6j�N�Y[�JZ�)yq�9���1�1��q��Y%W���6Ő  ɻ�N:?#3t��ʤ��6�C�$/��<=B##��d�\��E�풦�b'����v'y���4F]��L:�)���ŔՌ���C���Ϝ0�8�\TtB�?��[���va$E���|��'�Y<�i�9� +�3���{�^��	�C��$��P*�\�`��0�M��5��H�?�76*��:��y�߇h{^�͔�7��� $��M��p�����$=���wu`[��t��ބ�Nzjy�E�f�+�'<r���K:�C��xJSO���T�v�B�3�����qB����l:՛	s��R��M��"�Pبu?a���3q�g��#.. dD�̈́�A �WRN�u�T��w~^�d8�y�e�:D(v�7S����S�N�,���c�0=ȡ/�Z"5�M��h$�+,���7���pA��]�+r�%#c�턗�-�*�{��f�g$ah�O8�8�B�?Ӊfډ����m�8�:�p�(G�7:F#��0�~3c�ý��Nl�I�m�=*���K��2W?�$�d6�d������p�"=c�g5�Lj~��SFCr>���"VHR+�)������>{`��MղɞBa�곁B'E�uK��\�l�:�Lr�:�"�����3��W�Ed�T�5=�q,/o���2�<!����G�'��u�
��b;a��{My�^�\�l���9�=_Mx����=�/Z�I�g�F3��b�fh9�/��$fN�T[$U\YTՄˬ���sD(#Ƿ��t|��W*�{�`Ex�v*�F�hY�Ѧ�ܳ�>Y�i�F퓌�a���d�
K+ȅ^����y,��$��w"�$m���|ڪ��
��C�.H�e�N�D�+]�+ϻ�ĥ�	�I#3��I��m������N�I�7���J�4��3�ۏ�4��;�[X�fh���H�9�u�f�#�zQ�?COL�~E��i�}6�S�	�h�p��:�s��p4��� 'B��&�"IwF�q��kj�g�l���S�ŋ�_]����6Ɵ#ޭF*J5?Y��z-Oi#J��$�r&M1�+�a�� Z���K�d��f�j���������ޞ-������*��9��:k�[/Zh�F:).�p_~�Ej������_��L����m'���!Gh�&q.ڽ8� ��9o�0C�u��د�e6��!���կ�_��u�T\���Y��WT'�K���0J�G���M�����e�hřLԫh���O#q��/hx��Ѕ�3#�׃�;a���L�*�����DF�4��6����E��f<PV\��UE'�7�ݒ�~�e�N�ވx"=ӖڃzGs4X�rY�.-��^Ph&s�����M��(��*|=�6��^A�9�9!�%�̆��0��.g;e��[)���;W\d��e���n����̜M&�ݽn*n��1���x��S�d��=,���c���9��o�1�����<������#���9`�\T���j��� �{n�:����m�ޱx�s�0�۟�p�F�A�� !�r �������8@Y�|���I���7(���{����ɛ�p�Hr�c�ʑ6���J���æ�)�S�_M�`�PE�>w�{
�B:��6Yv/P�OS���*;P�#�-�{�*�CKsd ��N��ǟ��	'�L��
^|�h�˴�A]W\T��o��"�L1�v���ݴ�f�z �޳q��v��n:���W���ǵ͡�	� �%�;8�d���Gǘ�&��I�۾cR�n�T���������I�"�l�qE:�7�ӛ���V����ԝ�g$u���*=�Vfo��ڟ-�.I��'8�n�!��4~�@j���^߈sͣ�ɽ�t;!AB�����Ӧ��dD�� �>��F ��(���Q��7���w�g������7��}S̷�&әv���g�h�cUdbo�Ɓ�?e]J�����;!�{������g�끴ʲ��5�y���L?#���:���    ~/�����H�ݫ��S�I*��S��Ƀ�&��K������m�����3��}��Tw$�?P
��~�w��D��L(��
щ�KޑH?�@;�T�]��}�A����D�^�痍>ƕ[z;#g�#�N�� �*�L~&Q=޵oׇ)@����aoi\��o s@��ä��w��
���3����!%K����ֻ��|�%�n�K<
����6'\��1ʦcq�[���uL�5��=�zq܏D%��4�l���OIh��_��yz�r��T�2���(?�����n\E笸���~����H���Ƴ�XI������SGK�	=#�3�)��}�����)�~�e�#��Ҳ�Hh���d��?``�`Ҷ#����$dx�#�E��Ƚ�O-��S����޿�����iȌc����p�š� f��/��eKr�N[LjIj\���~��/u ��Ě����<��oO���Y?�X���N�E����J��s��)"y���$��\Ix3���2�$}�[�Nܖ�2�л����zR�i�Tw$����#,�'j�~��j�D��|�z�{��2��v�!Rn͒�����|�?T��O$��.ju=�g��l٨��96s>k�~�祅:
���!��PV�%@#��Wo
sD��qox��_�p�+�9� <���aPV`���1@�#�-p�����(�]��z �]�o��ڸ�7$Q$��01^!��`K]NZ�p�0��p��������W�{(GEtB8�S�^��i�HN�[V �rq��������gJ��h?����ч�l��� ���?Z�/�Ix�J����d�L�˳-�q�~��f��S�₢4|J�;y09k����N=�L ��;5"�o���v$����}�O? ��>�+�S��vz�[J
X��$��I#���g�ڝd^θ�oo�Z%��i�޻��8��n-�.A�ʎD{��Q����.�f�N}��P���x�;����?������:?V�7ڳ3��%���i����xB���	���e�U3#�u1�F*y�}J=ŉH#���r�Mˣ�������<ޥ<����'Ca(څGYHT>�x=��8��;�J���(���ʊ��I~��x���m/���:�,�$̼|o&M�w�X'�h��D�{C%d�n(��6p��j��%Q�p��ۇ���A2�>�i<�D&�ܖT�v\ZO���篂F�� ,zfut���M��;C�5�\�V��I��_\�yP��A/S+��I4��<����.x��A��_�xB<���z��x=�@�ƣ�!Ny�e��,*��s��v��V^�H�l�&C� �i���f���m�t��� ���^���g&�<�RVd�Ox�'���&�I�pe]��d7�3tO3������sd
�ԅ�����Cu�s��"#��C0��N
y�~�Ԃ_x:�Iⵓ�A]�6]��h��6���IP�KEg��EB�u�0�ݴON/z�jiY�/�Q�tx���I��p��:��Yߩ�~��^�������t,��L�B�hF�|E���K���C�9����md��Ӗo>��{2']�w;9�X�7����s`zDlG�"�������y
c=�V���;x��<I��YP>ҏ�gb��ry��l�t%pFһ���+q��e<ὗHA��G��p�
c��5�/Wt5��@��Yl`w�:Fس?Sis��@{B���f����{�&j�xڲ��	����������d�=I~�Q;�O7�ݕ�N��X��T��/`3���F�nzN����ta���l��^ʆ"��l��j��w�%��r�g�7V����Pj�q�"0��T�Y2��/P�=�8�_A��rB�����%ww�ab������a��soW����o RYV��% ���d㌲�Y�.{�F}si	�o�Ǥ IO0'�@$�K�">,�f֔ûw�D�n�)��$1*r]@���e��{��H��fo�Hj0t:��i=��:�H���O��t=��l����2���Yɜ�����o!sz5{���j����<���Ȯ^���5ϣe��<�����3*A&�z$=��:�8߯E]����9B�$������{�h���̥H$y�A��+���c/nr��K��P��鹘p9���Z����R����;g�=.���G_�2n�M>��2��`Ȁ���B��9�2�5���֐�A����h�OҨ>!�? 
�W�}�@��f��J�n$�����W��
;�Ӗ��{cx�t!3����)B^�E�}b�n :�;���tW��%�b<;��Ab�H��p�t�<O��tڦ��"�>�VyGxƅr��n�Ejy!�7���|p׬S��s~����'�:Hu��U/(ª߬˔��D��IJAM�J�眽��G�t@�O�Չ�h$�����j���A�y�5���u%�dA��s�@$u>1e8���-�̲��!�wB='��he���~�$��6�_���8���Ԕ%�@½*���~Ys�3�2���P��ۖ4߉�����WK9w+�(eo?�#�e�,�:_IGr!^��	ݜ��`c����g��n�Sr�����w�v$���t�-�w�I�i��Ļ��5<G}�J�!�F)���,�ȌyƛS�s��6���{U���i\���,9�Y�=l�u�ٳ�����tK,���[/_�O���7�x����=V4i�⺫�|<�v;Ox���2�l����J^I�0����\�g��d��tY3H�j���^]�	d6��*�O�8�ڕtwq7M|��yy�%�~Xw�������,�Ϳf���b���C�����u���ɼG�|��7�(y+kT(�-����L=`��w�����wr����ڷmT��r���]5�[gi�$H��.HD>�;S6�A]��I��]����Z�,_M{�rp��H���8��QR�ڴ}���y�(Z�:�q�f4;�0�=B�[�W�L�s�G'�	ݒ���Q����Ib����/S�3:'��xϚ7�����ţ����ѻ�1�)����=����5�)�F{�����djք�T_�후�j��4L�'�	�E��q�W��_V_���ݛ�QX�4�O7a`�@�I=۟�%$s��e�Z�x�s����E������$�G?�o��{&	���F~���I�ף�~"3BV�ō8����)��?G�M��<��m�4m���;*wN�,��m�~��(A�@ݑ�f���.L����Q�|�H��:�=�h�׋��I��"����	c���:��X	�We%e$�<c�[y\�qt�{Q1#�h!yC䒤�5wj���HN�IJ e�����K����p�Z�$��-��'�����T�m�_��!Y��d���0�=��˅L�$o�T��B�����EȐ-x����E�=F�	��8O����W�v!�;����.�����势-D�g�ê��m��<������d�$n��p9��m����b���Au��ik�/��P��:����R(���Q�#m>�'��,������[cd9�w��E*p绉^t=�y�w�m�g�͍�Y�Xo�JJ�@k�I��ˑ�&�a���e�x��Y��?�������׏F2�1#ǹ�7�h��d�?I~=F5�F��nD��{aC��(��-	ϧ#����)�y���M�˞��Ч�+�׋��}�
�5���V2�<��_��Οz��=����xT�\p�F��&�7�������Iߝ�W���ߥ,���f/h��X`�I@�:�˼����
*&�g�g|a��WPfF�v+�ua�"�W��E����"��{���x�!Nz܍�T�����eP�����[��W.�I�"��qj͟{̏*�tZI�J��C|� 3z���qR��G�ߝ�?u���^��y���=�e���)�O��n^I~ڈ�!����I�r�(���;+vk6G�Ed��H�'�k#{�.9"�q �N�ZWd�5��Nr7i�О�f&Ż�h��M��C�y?�)�1�i�ޖZ���"�:�� �
  ��g����qΞ
:������4>~?��2o�&���'�Ȧ��h,����f�)�wtD]�	c��R���	�Ɛ�{��ӪIˊ�\��+c�c]yG�+�e)��:�55� �t�О�T	n�
���(���A��]kE껞l����^��y��핒�]�n"�\��7g���q�jk�,=��n����?�{��!�(�M*	��蜼��y
�Q`>r���Y��D�f��W�ݰH���#�'Wֺ�R�NZP_a�r����X��lV-�w���CcB�o��]��]���)8�!�F�]h2(h!�o����v��Z\
oO��"ץ�f,X~�9+���/`A�1�ߚ�Q�m���m���;����o�v^N�皡W.L�S*=�{Od3L�ch��bHX���]T�tN�6T�;��Ôo���G�~23r��/�q"��uG��9N���i�U�x�&�╞r'���Y�+M{I'�4f;�g�����Ã���Z�`$���RG���`$�.���Q)��7vXM�<�Q:�4΢�Z���-�F�]��ye��3���I��4|@W�Z���r�a5��K���4�b���#�57�J�E$O��-����y{*�sA[d���D���I[��N=�G�����:��i���톩�HE�0=ra���-��GҎ�rR��5Ι��;��9�/��^ƃ���%��#$��IWo����)�k����/ݙuZs_��ڽ|�︣�3���mj�=��w���z2�j<0ބ�h=�ՍHN����׋����){o�F����'�_ا�#�=�ZW��ȓrfO�Q_�-����K�l�2�Ǒ���5�=o�^�TO8[�Gdd��U���~_���Y5\}�N��ݐ���-�������3�S���1,��@Z��}Y3l��׫��F��h�������!wtT���~��7��WMh�h���+
��o�i�Hޡ�˻���l��(��8����ᩘ���7��&�6���IO���O�ıSAȘ�,�.���83z���2�y�L����TN�p<5�����H������Ț�8qQXz)6��.�]�GD`p�>�.
A<A��..N<�d�`Y�k��\�>�����S��q(v�73�2����'Z0\S��}��'
*ş��<�Gfc��W����#l���E2J>-�%{����|cn�ŷ��
��~n�)Pz�w�BV��r���g�#�g�4b�	|B"���}���������H�	��*��#q��)#fPv$<��G$�ff�u�$ҏ��W�$������$*OH�W(>�H; e�-��5|$��"��9"�����҈��e(~d��=���f��a�Hr��6e�g	U�0��� ���QֆN�xvxP�~���g3
�^�	�=x��,7S.+r���$O2䅌z N.5���atFq:���kP���LG����[��J~��r�Ig=�G��,�ً1U(2��������	�5-b"��'P7�n/�����D��E^f�DB���c\�|~n/M�p_�2�+=�Ej~yaB���ٚLV���&Oi��2\/�~=[Vm�D�!��s2�sx� {��b6��%?��ĩ���TT���Vdߘ�A�M��nanƀ�. �$����'[)F�-�,�I
�讹v��z�UqȌ(�w���'���)Z��w������ y���"f췺�o�5�K��Z�o��"y#@�-v?�w����O��[�Oӆ�(�߷/�f�%�mt�ç˴�z���K�N��i��g�)�x�جDf<���qn�i�i!t\W�֛�_L�8O���^P�2��"�M�N������͗S.|�R�ց��5���m�<�#6T8��-Qxjj�"���<.�! �6�X%�kD�$�<٣���Lʣ��E��E�T�z���y�e����<nt����2�v�Fm��xk(�F����F�O7���7���Uf �w�o��?�������_�;e���E~b�C?5�<�E��F�?� 7��C���<n�v�/҈���܁�(��Q���Ps$��%y]B�yQ�N��!�m�M;юDY�����P����
�h;��?���]u�7/� �L��/�X��Fui�,�M,�i�����wq��W{��{گ����q�@s��S�dKrO�+��W&y��%y�0�]����ɉ�����>��,,T'>)���	��N�<%�K�Y��<́�lv�'���4r>>��(�U�C<%��������	M}
��r�w�)�\�|x�`��ѽ��y�}ɏq������i�82�.0�t%�v��=z�����זP����F���Ϥ��0>� �jȬ�HzX4����\DʧF�F��??#Ql%y�ug�#�#D��tp��n��o���|�2��)�2r�\�9��cΞ��)���ٟQo��l+@U��&?e�9wlXf�f����$�d�yC-�~��j��-G�]�z�h�c3�>�w���g�29�߆��g|bS���riA��"�wo��f��%Y"��{����͇�%I�^�~�@Q��k ��:ƶ�G�T�L+2[ぃ���̺lTz��=���j�;��W�z�����#�t[G�賹�4���I2���;���O�>��.'7��uM��D�T��}�/�T��������}����@�y�x� ���M��i ����
�Lۗ���-~-l�k�nq�zʤ�w7�	ژS)	)n���ߌP|=Գ1�2M�n��M���e����G	�&�?���?�Hfzg      �      x��}K�%��e;b�_���C�7�A�s9+�%�����������,�Tk����'�T��#�+�����O��4���9�?����k��7�
�8~������!%��c�Ӟ_��`��o+������H�oj9����������㲿P����#��������j-�8����B�S̀0r�IA���8+1%����<�;��o�����j���h�g���p��W[L���m)Kn#8��;�c��F#N1#�)oß[�8߽�!-1M�1�����1�y�G��2X_��{St�����6�M��E���E���k�O��h�7��<OMK�߽���x�p�yjz�
�j����}�?;%���ZCzy;�c���ܓ�9��TW峓�����K����N#���q���q�v&�����<�^Ibg�۽o�WLK�o
��yf��g��+��D۱��}^	�7E����=�_���V[�;�w]`^�z��W�H�j:���sg��
5�i�{m�Ϗ�c�|���s�������y���!]ɖ�텠�2������J�!d�-�Z��ᠴ�Hmj�~��h^F~�>s(9���=���B����0��<-��2�����7��4�@�u�Ӓ�iѺ�<D9�{p�H�����Z˴�ͽ�U�����|���.�0bJ;
֍~���\z�����U\g����%�q�SIM5\��[K_�ʥ̗Y�r[,�N���۪��{���؄�&O��J�ҵ��W2��!_������N!-ȕ��B������;�N_�ͮ@���5�[� ���Q���cO�5h�b^˚-�:���w�/b7VC���$X>�tM\J�|
B�U����Z(��F���Vm���\�����Ҽ�n;��
L /\˪�5�x0Q�/����� Q�u����(���"�6�;U�8��Fg8i|h!����3L�@΀á]� pae�����b�#�5%����eT�;�Q捂��}(�
M���_\���30�rn�$v�(!N;C\cS�������> ��;`9�S��6�׬4;7�����W���4�.dj����עvFA�q�e~��'6�%���Mi������'c�땲|%��J� �Z��-�ڗ�!���^DxM#�{��^.��8v=��������a����_1u��Y��G�TO�W�o��7�>v�Ct�!,UE�_1�1�����1dn�4���f�as;1Dk=|i*���^M1mS+��fl/)����S��7��J�>�?��<-��GM'^����3�����<�l�~�晙�[6��m-�_�LF&��A��@3���d\�<������k- �b�:��{%k62鹒l#	�4Bn��!��wV��B�&$"��;S�Θ_i;H�n^	iR�q���i�T�|�=��r�R9��B������i��!$I!�i9��Q�Z���}cA�I�B��m��BB@1W���!�J!�w͏���Ҵs%e_��"@ 3�l;��cN�}�`�o��w��h����y�ͭ�|�y O���	ױ'P�W
�T��x����B���J8��MU"':��D-B�u<�8Q���A�0oiҙ�U�K��A]8�no�����j�aX��jv�4�z5vAP� �����@A������d3$*�|)ƙ�@s �ޘ@~q 	��n�>����.$b���B�2AL��c�����]0���Sp]�&]t�W�/[L.:iᤵ�%f�y��I�E��|b�K����a�/ð��B_��i5u�?P�6�GF���LK?@���˱�����~&�5?8i?��Q����4��+d��8Я���}����.�ߺ��0��xN��Un�����N:O����D:�(�֤���T���@�,�"���@*��D�J�C��}��br>6�ru^�ߜ�R�k]c�'S�.:0�%�PY�����FY�'�RY]�p�[�*��>I9>��*�\32�0�3��g�B}��ӕT���>�֗z �<�ӧ���/��U�%���7�X[��t3b8ԹWL�+�:�{T��/�Ǡ��qY��y�H��*<Q��'&ο&Vbj�N5���0u���{`�҃4.g�c\`^M��>8�\�o�J����-F��tq��ا����=`"\	��Se̅DʣN�ooR�43���]Q�'ъ���N}<J4k��q���~]k?so�Ր�#4�$�P���F�b"����x,�ZI�+��J��>ߕL�2-n�����,Â:��d<��yz?���S��yA~�r��;�v�I�D�g�p�}zIϐ�Ry:�ݥ<��qz�3S�3ö��Uԡz���Ky֠����M<Lʓ�U���>v��*�)l��|�Pш����ڣ*�����_7��y~{�����4)�<@��%���qs%,&��A�w�~K[�X֎���^���)�ݮdih)�_9SM��\������.N�B��,��h���8��o���q���&;w}�L�/]$bt�u�S�o�ӖV$q�����N/����
N�'�"�9��~|$�K̨a��Q�G���������'���F��^�'� HpϾ/�[��Ƒ��sX�Ծ$�M1�?H��b��T3`V��`�*2q}��i��*����#%�%M�]󖌎����Ӹ�i ȊQ{��n�Yh.�6����2�k@{a��ayadu�:"�O1�0#�KM9��t�>�2�B�Mgz\뛏�[c��E�>½�2WɁ�6;5u��S���f�@8�48Z:�p���!� ᄑ��M��g��S���~�Ph�d��oc�֡�v~��Br~roꙄM-���puے��I��Dݿ�(^K�k1?��,m����B���}�����<.]��[��J	�Ը�,7<�ra���G<Y��Q�Y+��F��!��\�������^�&�@��60�HPݎ�� �5�r}��P���z��FS�?z��|(��tW�`�Ǆ%d�G�f1���:���W��r\�f_�f_�i���f��m,<B�ip~@p�@��L	SQ���ژ[��n_��i$�͐%`)�jS� M��v����t)�L�	B��ɚۯ�dn�č�P0�6��	�{C�a�:��JF�	�օi�<��l�(V�t�ޅb��k޴.��"�I,��9:c�Oz�l���R�1�ZX�k)��
bA��-�$c?~��G=
|Դ��=	!]
���������kT��������1��bЀ����K@�F�����~h���)r�T�&�"r�D��i'�؅��b�!!��f�B�سč�����+)!J�披弌S���Q���A�#�+��Ɏ{S��G�`�}nlג��-N=3N�2�[����j Ilt��+ա�t*����-���-D�nQ�W�)$)�Ү®"��Y�j8z�P�Ù�&q���D�<.�>.��y[���U��n���f �B!,"t=�ַ� �SOL%c�]##Gx$^�/�_x����y�[͹���C�����9�T&j��sY�w��������B�/b�"A����k-Q�Ŵ��v��\���!{`��BgV�VQp�5JӴ�����G�>v���JҀ��3�D�fʠ��!�ӵ�N��F
v{S�ӵ��[h5XK~RO�/�9�K�5�|�f��7o�wJS/�UP`�4��Os���S�=\#�_=�C̯�Țe"�#u�Y	zv=��/�wbF�O1�e�B�ޒ��!{K*=\'�Dȣ�:N
a�͆��ؒC|&O'�y�LO�;n�w�GZLD���3y������πqknF��n�"o:Bxks"�	���O��LtG�@���Ft��:N܀�o���'~�[]:�_U�_vH#���"O%jO��-�����r�W�� ۮ8L7�4���U����R'�5��5��LSܠ/��S��V�]�0cҹ���yraGG���	�E��Ǭgi�_�0�F��?��UQzg�/�J�jLE��g�-e�ݰ���B�U����>�F��v��'�,    G]_�amX��x��t[{��#�j���d���!ԼX��Y���'�r����ӮsO���Ӓ��n5�S�S�hQ$5�����@l� ֗���԰����vJ(lT�OƇ�����|����*6�>�rG�/`5�B�]"�{�p!G�G]3���b�GM�{Rx�#"���]�%�7
�=I^�>~ʱe��]Ӱ/vJY�EÒ2���4[p��2-̗w��/�v}n�%���s���2y>
�Ƙ�e.�Y� �1#rC�!��pːN!�7�2�L&�(QPO�*���+BW6�;�>��B����FkY�5O�&�5d݋.���O\ I�/	��|��3�����Κ�+��T�v�St�&a�}~n�_�X住���}��=�@�<�֐ϡ!���[uw�x��Cn�`�0	�F����렞>6�+�ߟ�u�T��J�@cנ��{̨���R�Rʽq� ���a>����@7�Ac�0��;����|8p�/�5�mZ�� ����ԗ�-'�	{^ǧ7U2sx��Qw��6����k��C�R/��@¡�V���uh�D4�j�.@�5�jj{2��سk�y�l,�I�zh@}��.@��BҼ�4��$�NHPb�!���Q��a�sF}�r6(a.ꄹ�/�$�Ź=���B�z�)�ho��9��@m"���^1�T��
�Sě(:ٞș��{I�9���P_Ѩ�6��St2$�Q�L�\k�e6�C�׆�k��Bצ���,��&��-ԇ,3¤4L��RL�9�3U���@f|�O��KaA�4h����Q͂�w�rR?,(�	��X����u�b�/	
K�ޛ/��nY�h�@��C��
���щ(c%":1����҂�7S�-x�ѵۘ���d3���>�LwL�doݱ��um�����5m��_�rC��I�^�K�m��6��|lf�6����\���pYO�d�a-�F 2�2$�r_{=͋�z��y+��nS���$!I
�hS�A�Z����M�6���)D50yo+iBh!�J`_�>J ����{�29W�� {u#
i���!��&��u�Ǡ�9�O݋zn�e�̯�9�;s4-��&0l�6^ Z@�@�H�'����I�d�e��B�M�NS�90�Qg��a�Իku��!V5f?�<,Z\��|�8S>��'�G}�ʪl�Q�&$26�1�LQ�[��^���w$I~?�"G{yJY+��N��eE��{2��ɤV��籙���CJ����,?y�I��̽1�e��ZS�:����9�[�xR�e����r����'.��B��.r%]
���%
!C��^��5��+O5[K�j����W�觌�e�x����[���b�9����sf�.��U��Ӈ��}g���cdhx��ġU��/y5Cv��䋄���E[�[���g �W[� �l�c�a����f����i�
�-6�2Jgt�C0%�T�����c��|#��~�\Y�g$����Q�Q�i~�v����2��) �x���4HL��'(������A[6�s�)�I:]��{ҕ�bm�-�@t6�?�!C��k�Z��4Q��2���P�'�!]�!n�aC�����7}�"����k`������b�l7v�;lw�g-�}�R�a*�X6�T��y�L@�@�[M�t��Ms�z��K�F���]��k�kŹ>;�������sl���m	�أ�[�A&�߯f�L����$�[�;�W���$��aXA�A�޶3Y�����I�#�sr=�fb���fٷ��}R|!`��؛wMU�:��Mb�8|X�a���)��'V���H�6,��ϕ&� �r&�g�tĤ�+:˧yq�NG���s�=7Ҝ4�$Ö��F��E���I��0N?G�`�<��ﲗ��(�P�/G�>�#R��}hk-M��(����U�B]1_�����gԤ�i����8�Z�\��#O�^�BF�B�:��IBd�vS�-��9�y��1앂{���?a�0��V)�v>a���Q^֍L��&�ՐMv�y��0K���!�jr���UtWK�����'�p�����,�r�
ۮP�'��Dø�LW���,�7��Ҍ_)Ai_WBy
����8�+(F� �K �2�8~ݓ�)��Fd�yn�K�sÌpD�uhĨ��ڗ�c��	�8�ժ�1G�bLO�ڞ��I���ӄc�F��E���B�?m���z>;��	��W]�5�e�/����v�U^M�e�1^M�hIc�[Z�1ڴ��M����8���T�[�gY�]�Aۅkr���Rѯ�#�iqG[,
!p�m���&*��n{��p�ZK�k�մ��h���{| Fm����<��I\f�e��Z_��6(�ǐ1 GiO�\�v�G�Y�oi�D����j�]U0Z�K��j[�b�f�501�����?�y�=Eɴ��4S�S��LC�5��OX���+]d��7���&�=�^�y	Y{	&qo��T�0M�OqU�|�De���<Q�irv�����fb�#@��N֩/x/�?�0�D��#�JM�4�3�,`ٱ3a���Ь�i���d���L���<7����f^�{�c?������aIs`�w
9���`�~~jX�fP��y�e��f���\�ߺa;����~��䌬L������N(g ՙ��sXX��Ͻ��!"aH��Lg"� @� ��#�%�B ���R�_WC�45��1Ă�irNgS�PM-N��WβHr֭/u�.�W�ֻ�3���̀>3?�����7�b�S�{��+���tp�qfN3���� X���'���*7�m7!O�6b^�{ʋ:v-�%{��S�<�JM��>3"��m׀r���1�����U����Wo�OO�ƪ�+S������z���J�,��#6ˣ�g���uf�yf�7��BT�T�+��+�=?I�!I'G��"��-*�-2�9�٢Z1A����%�h�c\���U�/����Pt���0��!��F��q�ԵaוD�^qDv=3B�g���G��1��b9QSc�h�>���F��IӠ���'MS��(����Rw�Lb��ՠ�-�K�^� �4���!��v;V����e���ۦWi��E����qe7�+��������2#��3�K�k��vN�R˙g7�4�F��I�Zߓ"<M�*D����p!���A��\�A���l�����ub���W�vM#9I��������"�O�/zO�s*/TO'ϩ ^������r�a�����:�dn>�r������E�R�E[��������1�΢����)�X�d��
1vb��34��|�R�nŬT��c� ��Ji�)1�n�!L�c|��5ڛ	�Cp�D�b��1�=��`�*�+�#�4�F�ܘ�r�5C�>"zO�*�[��R4��.�'	�Q
���O8�{Tm^(w�N�׊c���Lg�M�f��PYM�,S�����x���m���?6�v�5`~�&sE=_��AL�����nĜ\�$BU}	��D��r�/|ܱ'��2��z��s�
�$��}#���{�=��d\�'���ێv=���$GL��,!8B@��k�i^�f^�j��/SB���?�|��<�s��j�:�o:"v41j�1b>m��<em��7���n1Z�74�M7ŋ�������I&��3"3�DFİO��=�(Ȉ-	�,��Ĉ�{�},�Ls�\�l��N;(�q}�J����/%�{q�)�x��Ԡ��A��Ő�G5��i�\yS-"�hu����y����+O�)��˔F%��"�U>c"������HÎ}�f"F��xK�m�� 4{z��f;Wu:�m�r�T]e���yݠ�i�1�Y�K�M0���{O��9��e�qv΁��α���g��Ӳό�|�]�|Qع7����R��/���au�6hH���;��Sԡ4Y\���z]~��$8z`n�[�v��c��cM`��+��G�g�	��4�438b	�`�?QdYV ���1꾬n�V�}l0��D�[��0�,%GG:    T_ 4�>�[�&hb�6�f�,2�Io�������D�9؊���|V �
ɪӶ�ԱT6M��t��MęD��d����T��籩��RƐ ߓ�Q���t�J�U�Wh����MkY���OH�XK��z���ǖ�#��e���=��ݡ�KSK�)�dt	���S�>�+�mw�����e0�6�����0#)�5)q��H	2��iq4e�I�{h�}����&K��Yb�X Y:6ߪO���N�<�|��6-�F7}�"�dFw�.���Zz"Pa�"VgAJ�j(]^�O��:"亂�5����Y��#�xW�XOe#�d��r�Ͷ��"�4�|favzO��FՆX/���D��	KP㉫-*a�%E%�r�lqs�S�ȱ��xV8�Y��&�����D�j��kmw��{�����I�J�K�$�g�8{��<{T�(		��9�!s�*Y��9FYR������n)��d�����v�kJ_Nw�F�{��ò*'��*i�����0	E�����nLB�Lµ2'&�`�Y�M�tO��9
+,�9z�K&pW�	j��7/�כ/�FL{�ss5T��B�s�t�������t%F�5�����m>b��!�v��#f����	�;�n�7z�nƍ)�d�������X-V4+q�(+� )J�Z�[VHa��㽢��(Q�#O�Q	9�QX^3��Dɹ+@�F��0�0��U�Ƒ	�E��wf�����8������2�^�&ip�	WÂ�QBYu���y�?p�ͼ��׳�'�Ik)EN׶Pu}C�,�2�����ٯ�`�P���δ����ܣ�b�RH��2ݹ�Z��0 Qc�[H�a���*�����j������Z7ҬZ6�Z�ɖX�0GU�,��d%�� Ǳ`Mװ�A�PO��������<�eͣ�e� 5���%��0�V�zj�	�!���X>���)��~���;��b<�#��ɖ.�Ő�I�w�vw�B�t�{��C�v�˹���k`ݳ +5�&7lX��	�%��̵�s�(�I��Hѝ(m�j�h�fR	/��X��z5�<,�f�1J�1<)����[]�4����%Fi�d5�d���J^b�H(�H����$��y�ȷ��Bihvs�%��Q�evi���b�[���b�B��B���]��0Y%k�wM ��8���ɂ&�Ő/i2�D�6�c a����S*�,��Gړ��t⒅"^����,�d��\M���F�9j�����V�E
����u��|!��u��|٬�MH]_��H��đc�CM�W��k�>�0�5��O���e٦%ڕ1�7�Ev?���U֮݆���8�����F��Y���)d��a�t�552Ab�_%�WR@2/��`���>߲�����{����"h�%4rT�34"ؘ�+9�6�F��CX�ݶ��?�����'�{U�k���^K0O��{z��NX�n��85S,��4�v��0Pk2ǨzO0!�a�!��[(!,�#Y�r�
;�:�i��´xRc�3���iK��>AFG4FE�q�`1�� �S��l�'Px���1M]b��4�D��4�i<`�ᰚN[� ��T�u�vL�x�|1M���QK�a5���j�k0�n�W���+���s%�D?I1��a!Qx��(ǝ��tt'�Wcꌾ��V��>ڦ�m�I��-�61�z�{����m���� �#=�`�g4��(oc Ŭa�5+��	���Uv�J������	]��L�o�W�����B�Y�E�`ű����0��`e8����+�t�	���;� Mn��F��\\a#�d��Q�"]�+&��ʢs<�0���1-�K���Pf��{8�'��T3Jc[�'�4�!�&��6阑u�̳G1#���k�R|/b�c������R(��^�p�T}v��=����v��ho�ѐT�9u7�Sww�-��'F�e4p
{����%C��!���p��z���ջ�n��\�`e�2՞�Wk��*��=N%��#�`4nZ��"`��"��#�<em�<Q�� ���i~'��� N��;�@�l�߿�#XH�B���x��m�SƜ����mH �,ww�R]UXQgY�r��M<�K��bn�>5zk@IP��,$m��E��k�r-F�(?޾��2|>(�K���=萒������)�e̍݇`����i*M2M��x�Qoe(���J�����uE�DO,/.jF1<���'$:��\��wǉR��s��5�(C@>ZO:���N�+�f����E)	��M�+�Tp��5	�l�6�χSɚS1����EURL��_|O0&��t�š|e���kO��n�͑=�n�D�,R�<��SS�O�S��S(f1�Å;�{@��9jF�p:�����f�" RS��S�V4�P��D\M؟ZYAh�܏^ٺ����ܚ�rئ�v��.<���>�z��T�6�(��(������[���z`Nrڦ.�y<YE)D���6��܆��I��D��c�Բ��b�x9��2Y�̏��>6��CO��G���	�W�M��%�Z�+�J������m-�ܗ��K��e"�����m#�*�酾�ل.u���x�4 �;�-�!S�,@U�B�B���Ϩ��R��;'�J(QaVk5oc�	%"���N������&4��-$@��YMsdf�fm!�:D��r��	}i�\��������,1��@};�/�w1�>6m#}�C��������/�</"[�n^k�-���V�
/�w����/�!��o�b�-���� ������*�^�m�TD��B�)R&J<�汕$""��q���LŜ�*��%�"���"JC�u�W�I���I��?v�]� ĸ\��E���GO&wJ]��&ݗ���rfaN����F͞��9�N��N�;ڷ����V^���������wkL�_�c0���'��?��!Ը#��8�Rӯ�3
���ǣ����m��2�����5���]����zm,dh!?�߽u6��#[_神y�<����H��(���E::��? �j rV�  Y�kR�/9ڥ=a�VtZ��^�����5��r2p%&P�Ф����@ձ�����c��i5@b�W��=Ѳor�����DUGT�xIOy߳784S�j]�%�)�I�q��cg(�3]������$Q��O4�����wNj���h�z�	�2,�d��(^Z�l���JS��+�+Z�F+��y�f�R2�h~ď7����$�rj�ʋ�]3���(Xu8��DL-�in��Zߗ��ѥ��Qo�i��o�{8 @
I
12�ŗ�[�.�Z������i1I8�W�-�?h���@��#�Q4��aC��F�+���x�FUC�[�F�i���e�1��
��Ţ��WkQ�?쉏_R��H8�^X[�1�e������!�#J�:�j����O�U�٦ �cL2t�w�1�_x���_�I���H�*��Q)*{�YLYg�ݛH̀���������6�0Q��@�|��Z$�0$|�PE|@���c�e_r&j��<�9ӣ��]x�j�̴(|0U��פR���5Ѧ�j\X$긢IB�-	�P`Eu���$h�9�4I����Kr�hQН.��NlYu]�g�f,���D���KΩg�F@����29YH�B.ؕ-鑅4-�Gv���1,uX��.�� ��3	�:�2ڪR�����&;�q�u��s�8rc2#��h��I;1�!�4Ccm��<14>S2<؊�gm>l�r�ax-f����:k5�K��[M_��K\�)�b\��4`���	02.���`��?�BWq/{o�{��p��qe�ʲ®{�L��Ľ���2��j����PZ�(�*x�o�$��IAmR ��%Bs����t���K�H�!
�%ҜE��&y`=���� d�BχfAT\�T�5��T`��$g�y��\Vw����3)\�Ç��]�w%�>O�w�%�������m�q[��L!NM�}�C^��{o���d�%�BL���e㳐"�\�}Jt$�$ X	  J�=��U���(�Έ�Vd|�r`5U��2�Q;Q��%I���~~q��Β���!����vT�Q;�p��f9��;[cՀ���Q�끛ӛM@�V �ʘ�K��AIx����-���Р1���e	�δ�v��З��Ky���o��W�i/�"�_�m9��?�]M���3�a��?{��g8��u��ZF�kQb�F���r����>��=C�����!�����>!;�	e�z�t�2!��ƻV����}J��[OT�h^V � ����7d ����K�����Z��L��`M\�&�Dᦇ�&�Q���3���BW��!2�h�fY�.%��Ϛ�7��eU��'&O�q�3��`�(F��Vw�3� b�$FΤ4�L<xĠ��r���9�U�K����bZ�b<��z���x;}�*��'~�Ɖ�J��<�5�J_��"��_E<�"v��AE�V.����\Z�N�������D�V� �t�MR� ��!��'��'�L�;��/[7jB�R��U���j��=��2X�cF��d.e��_�tW�5M��k˰�t�R�|x�5x��w&�����Ǘ��M��R]'m�C���J*��u<���F]��h7�V?�;w�줓3u`ǹ7q���"-�-h�y|���b�}x1�6��|J�^ߩEH��0Oq�{� }�A�PJ�}f�9�5�jv�����}x��[�-�}b}����@@_Ms5f6κ�-�c:�Y\�d����R�)	^�>��d�����4 8��ܤ�s�	���,���:j�T
fE�w5��}�����:����b:�^̑;f��W]�����b}1����b�doIh"����h嬟�?���
!�*ȁT�6z@¦~�x��N/��u��"όq��m	c#kHh!��K��BH�B�Ϥ��Ҵs%�Λ�L�R��ϴ��$F���a��N��C%>���ryi�*��×c�K>BҬ�5_�>)� ���rx�L��Q��� �\[�3����]��<���A�X�7'0"[ ��~��ڇlA�����n���0dZ���p�|�i��R��K��+�=�mv�6�����=�l�5��Q�e��xf��aQY��jT�@��^WT�c8;s5t1���&���6^L�
E�>�U@m�g8��-��g�-(�$q�	�"skJ�j�Fe5�W�ha���&GD�cڽH�W�<�ާ�Ym:3E���/�������mޝ�ykb$�?յ�t����B�A#r������'��`o��@_����|� b�{5�?��i$�����I�[�!e���A<�k��#,18@��~{߶k��L�Q�RT���!dV4���D�\�˭ŉ�F|��O in�$@�˟���=<av� $��x��b�e굓�:FM/{�wX/%Q����z)2-I�#�iy�Q�7�QT�7�Th�	?�1���|n��*��'�F���C��#��OV?2~��Q�(J�B��.� LJ�{��m�� �=����O��qܟg�&r6D��^�@�A�����P��`,�����yl7Z���*o��G���s)��{�OA����R})M�b��|)��M�|�@��m`K�|$�;x�ycYA�*��DT
�Uh�*�dX`��՚�jV���v#��k�r-?��u��b�P�_(�BR�B~nI!�ұG�r3��k25����y��,�K0���\*�/��e��)e��&Օ�i���NU��sVw��v�<����]Z���<i=lg�eD�4�`���A~p��K]u��L�gl�RW��e���~j�iz���ѯ��B��*��rÈ(��W���b�f���b�$~O�dN��)��sô�t_Ժ�T�[��%�
4I!?�������3�Ό��:?�s�x!Y/�|�ߦ��)R�ѯ�ooӄ�B̕�}%�Gh1k�x��w��5Z4������E�s�z�Cۏu���F��5l��׈�f�z�
��SIo��R��0�'�e@ى]�R�C���8��y�J�[	����z<�{UYv�=�=���J@��B3D�VU��6Wӝa��T��UC�b%ʩ5��EqM�^�W��J.�KLBH�B~�/1�*��[���*���b��5k�69�����u�@������6��	U����	XWX�A�K��/U(�w�y�n-Sǥ���Ϧ���;|�Q+^>�A`R�����t�D$�:h��6��k��I�p�4�)z4�����5f,�lA
�Qv �D-�g=U�ŎK��՟�[7�s�0���L4��>I�ύ�%�{��5��)o��:_��C]/����y���e��'#����"��8*y J|(�����;��Ã�ᎁZ��Ѣ̥� ��� S�-�X��]@{t��D�4#eN%h�r�"������߿�0�k�      #   �  x���;nA���S��9$�uT�Ipe �O��#ܕVZ/�I",������sT
��j�@U�uƂ�Qq���t~{}9��y�����t.�c�;����:bU
%���o��'�vE���֙;@"���CŰ�~�^�kG��.�IjXHCZ��/�����&М@�A;a��2���ؕ;AE��%4�L��M��������'�lц1*��jgӵ��C-�Ɨ^!:EW��%P��������oSDEa۔����mJ=�22�pA�j�n
��^K���w�,����y��C1�rR��Y�K���H�4狉�e�_X���E,^Y�v��w	ib�ʒ�؀+�Ӓ+����i��R������y�yXN�Ð�U�+��-w';Ê�IƁe��!;�����B[��jx�T��¾U�S��T Fl��,�=;�ء:X>fd��~�*����|0fi\�}�nz����N���1>�      '     x�}Tۑ�0�^UqDC�!>jI�u����leF�@0	����X��|1�Lgs�	Z��/,y-�ݸ*E��< w���P�(��D��q���+
XwPJ�:�y���DW���gR��H8A���Q,S�<A�>����싢��|:�e���5.K��`�ɫ8� �����-�.�s�q�>����sSU��������Ǉ��U���@w��M�bBd��}tz�����A�,����	Z-��`�H�(���P;Y��l�RzڷCm������7r'�iB��w�,e/��	��郟WI�޵����!���Z��0^�[���ی#tm�[��9����f/���?ԡ�(�(�;$Bߋ�NC�=S/��Ԏ���^|	�łf~K�������QNP;���o�8��[҇<�k���hN1�	�>k�G�'��w�w7L����&��؃vmZ�j*��'u��B=�K��O普�a����m�	�z
t��t_ �q��OЏBl4�wj2�=O�?��s��3Ve      �   p  x�U�݊!F���	�?�u���,�0d{�3m&��v��l���a�F����lQ ��8Y%r|�PC��4:��ĺ���_J�&z�D�֣UR�sK��R\��D��Im��՗��,%�Ml�����&�RĿ-����r���������-���u�:)�{t�:�S��!/_Cm��'
~�}�#�|�bI�S��Nx���7)�Ј�J:��2��rhVYD˪�^�%��S=���C����[XEZ*'²��9��G��G��y�ů�_��췰NP�?Vc��q����|=�5�21��G��!iQck)_��������H�q�s���Di蚭��=�qO�|ٯe���' ����      �      x�ܽ[��q5���^|9�,gD��F����)���c/�����X�xf ���'"��՝�Y��K6E��dUV^"v����Ͼ��ٷ���px|��x��{|������a�����v��������?��x���ү`ԳW�������g�ٷ/���/_}7��g��|��`w�/Lx�MgC���R�o��=��9������a������n�������f�y�k��F�_4���~� ^�y�L�1���i\=��p�S��s4��F���~����0�3�V�gmi<���t�rʁ��-�XϿ0��h��x#��Џxw�y���/���仇��޿�����|x�e������'��O�����s������kJ�����B�}
��J_Y+|f��Yp�<;ZQ�^ v!(�L6`l|>.��7�zu������:�,������/�� ���Y���\l~�a���;�*�^h�u*'6���k�u��}��ן��5˻7�0��u��!����3־w�^�S��U����X3�tZ�i<��۩C����Ϭ^=^\Z��׊6/�vZYmt�~�3�6�����h6_߹�1_,�
׼X��g�<��|�j|�uG/F��t��I�r8��T4�tF:x:k�g/�6�e'�=���Z���Z(�P4����ɗ��Kl�4wA?����]�`t>�@'��7��/���:;m׼ݴ(U����;�T�������������������ݫ��������;��W��n(�5~�H��ݛ��������Ǜ�w�{���ʿ�7/���˯��??��׿��ۯ>���?}-��?�C�#��`���1K��~�'�b��Ik�휡�5\|T�[c�5��F��?�x2P���[��k����8I���h��W#d)��C�V�8l4�㳯SPp\[��>y���v��'��_}�=����`E3�Q��aټ�b>�����H�t��/��ec=��c�n���s���%$-���P�����+5E�d�����o)D����ᯇ_���o?Ќ���kzا�]���v����8A��?�����`S�t�>s邠��o��۽������o����wi�hV�?�=��7����^�.t4|v���%�D��̾+FLc���o\z�`E�V%ê����|8Z�&Zt�j�~˱�pJGw��[�hb~,o���Z!�͎MWE�*�|�z��&,�Gw!�jќ��)L�d���|�֯_���P�|8���<�*�Oa�t8�7�x����>�ӟ�}Ew�R� �XT�U�Sֹ�$��>w���a���O����B��s>r���vz��x�<�d6��7���nòuY���Ō��<B�"�6풥��_E���ţ0x'�|��Y��?�癞������a6�JA�)����,@� _C|��I��Ɗ����BeF�|���m��nL�L���(� ���&l�cDX�=ӫ΅mt(v��M0Fu4�V�Q4^6�����/Yp��P�U��p�,�1@)@|����*�?tSR�MI����/fM�џ\�������7���ѧ���D%.p�*���4-b���Z��ᆂ�-q�R�0���rtD�x
�(Pް��x0��`��u�3�9�w����eDp
"Tqm�1���I�v������f3��/��	켍�c�#�b8�W�\�ÿ�����^�=J���K�}����8�Gho-�=�������ۧ�����_��h������]�S�і���ЩM)��V�Z�2��@��=U���j�`Dʌ��	x|*���@��"��}��px}��EG�a%�c���=k�>y�M<>���0H*�P���C
��@��my��'�@fP%���#��ci��DZ u��޷��0���/�6̓���J��ڠh8{�HY榓�/\��9{�}m���ʯl��Ҵ'ccHR���R�b�(҅-�*�q�p��o�A*>����moW��'�8q1�(����n!P�c��S"�Hܣ���e�P5��:�[�?u�ƈRm�(���"�TT�yA݊��ϞJ�r�&���Ey庵Wn�p�Z��V&֮�@y�47ԃ��B-4*�46��'�9>�)��ڊ��'��gh�����-܅��o�.P �utQ@�~Ti�g���`�ĳ"���m�*2������q�*6Q%���FS���Wa�cf��Z��eZ��6b�3M!���K��D+��[6_���N)�~����1=�H�2��_�}�՗'!�aС�2�(������Ӕ-,@w��S��J��l[��ت�� ��6,y��Ƴ����y�n�&,�2^����OY��<踉�Q�2Ld�E���1_�گ��̗2ъ.dr����-Z/k�8�J���<	����'o�����xC�~��?-�
)�(�o)�祫98����03UbH����?=��8�v�����5$�E�N>� L��2�1�����7Oow�{|�?�~|�ϒ��v�� ��2�,��߾|���S��3�<�z��M�5E>/,egƊ�����SBL��R��D*ħ�ze�Y�3P0��,�#���nUY��ͥo>OL���2P�O�>tx�����6F�wWI��:�=}�FLXZϛ�T%��HecGS �M���`6M�{᪚�M:v^;grN�uv˯�r�� �B�aX[z�M���R�D
G�X-�5��]��9Ƞ0W�;��B�ڸ��3l�D�Ӽ]1r`�v�g�)U��0�[�N.mp��cA�Zi�8��b	Rb(��3�	c+��.�:T�/��T���W�f�0��b%�^h�9��I~ږ�\(�MH�rOGkE��	*�j�l��y�	�h:n"�,���RJ�"MfG��:Y���:r|2��pf�ƃ�����5�,�CoD7�ѫH{G���n�N*��mZ�_���K[�A���֪ �>�}q��N�>#Ė�e�����u���g��/��v�6�y�,�,�mZ�R�ʷcTƋL�1if-�a1�p;����gD�rP�"=)iƶ�����T���������R��2^�芖�%��n���1~�+t1��l�V�DZ}G#�(�ۄ~��x�^
� �����r�d���S�/%�Z����is�Z:��d�����	��z�*AT<(hQ�֥�㭱@��t֯����*�BPOr���O�O1������ܹqLwtOI4��-l�����M�+A���6�­1�֞��T���6��04q���§�O%(7�->VE�8�Qt�f���-�W��3��`Ei�E�VK�ƚ˅�/9&%�������`׶G����9&R�w �/~S�T|�`�^�����ᆌ�!�0���Li���_N��|�D\E+�������0��=�2ڰ�u>9���t@X�)�ށ���6��P|�sIm<bynL�&~]�@���6�΁0n��v�x�e'��J2��G6�R��ȑ�C�tD��=;�tSQ�ΐOE��DÁ_S��z�7��z�g�M�cg�0+�eo��0l
zm)r�5p3��1Aæ�[je�*���Ȓv��|S����:�\q!��uX����%��T�r�4��D6��KPJBn�ܦ;���7z�ާS�A׃�T���M�0x�u�z����Jdv�}���?Y'�`:0A	����c e�#�EYQ
k*J��]8ǧ�R"G8#�+Zz�[j�,:b����BT��'���~b"EsF�Z�a�x��L��Ё��Qv6F�<�p�$��.ER]��������%:���%#�& �v��\
��5�ˬ�Z�m�.`��������N�2�K���ࢢI$��W lǴ��Se�U]P zS��6��;���0�����%��!X�����d�Qt�3gc5�Q��3Hcg
z�����|��t�(i�6 ��U��w�mC��Lݦ�uW)�t�+E	ӭ�ܦȴ����D	8�<�@���.�Ow�L���bM�̈����U�hC�S�h�l#�ջ�R �(��q:    �՝���L#%j�lP���7"�z�#��������=ON#
\&q�D0$���#cs,T ���oo������=�7��������i^��ЩRQr�(�X��>���6���.�M`�ڧC�)l}Gc����x�����N<�+����h4R����-w l��,�<zZ	ڎBL�e��T��b��ӊ��C�Twe�r��eJ٦�l�p��U"��������~��G�7�:-�E�.�-$��x�=�H+E4����Jƺ�ףX�;���WqX��L�p��`T�I�ꪏ7�f�Ò��"��N���ׂ��i��W�sX���}s�q��.���[꿉ϑU1K)��Bh�%ny�2{�#Z�Y�hK�P�3�E:e���m�uq�(RS ^�um}E��4Iq&�7r�8�O/i�J�o���w*p��M�� �[L<X�^�H��FS��-B�RW�ח�Z��i=)'&���喺�˱>X���kLP���3k+���Y|P���#l�Tv�T��4�x�VZ�<g���j�y�=�(�
r.)��W�k��Wcj�mV_\pŇzw�׷O��������
�K���m;:��X����P�X.G��\�k^�RhJx���<�ݚR��'�CHOi�������Bj�2�9O��M�I���?U����Z��Z�=�T�VM������e�OAVX��E%��?����i�:{6�x+:�����8A��M7Q#z,�Mg��m|IN�J�����V}�����~$U�;�IG"�,�nӉ�x��[���DN[�dn���?�9�=���6��,1�VU��9W��$ k�0s�����[�鱷,Aȋ�e>�o�GȄYdk��#+G�w7�+G�w�~�M	�͎�XFOŠ�����zM[�h�����x�ӌ~Mq����G�,?��By;.�T,[��ɩ:Mq�p9�݇�[�á�g�.���W�$u��Y��$A��Y���_�*U��S"@�aM�i�,�iF
�#�ߜB W֛�:��,��������-�}AMC)Y�b<nn�B��x��0A�q�<KM�}gQΖ,*����|�O���<�X%5�	H�bM�sE�FT�5�k$&���]�uX��4^N"� ����K�MU�X�LOL��=m*-�<V�ߠ�S.fx %+6�JЧ�zS��D��+�!��j-K�����oi��D�g��<��0m��A�1�:���qۀ�4���xJ�倫 �〕�Ⅎ$��~☢�����%��M ��(�V�6�D�
s�����љ"����0@�DAO�����C�u���B22����Q�P���D����8��1���aSɻ����"D�>��A�m��bʏ�;�^1w���</� 3[�-��k7ɏ�a��fq�zY]ժK%�"J�.�61ZZ��X�:D���A�!���kp�3�G�I�n��,���U�D�+Z�?�R+�Y9��g�l��k�.wX��5�;��t��ߚ�fKD��hF�-cFc���Nas���7�DŅ�$	�HA����}�~�H2�L���,0M[K�t�ui��yB�[4�v7���e�8�S^�(���WZ�7�.]����A�0-��jn��I�NZ1^lCZ���P]O:.���.EyA�O���+�/�����|���������?<���v�������x���rw���:1�����������U�8|o��VU�X��O�%��X�%�k8uP��Mb2�/�VJ��[Ԙ w�t������_�r�.7	ut'{%d�U&D��t�/f���P��d9���5Z�����4�'�h�^�}��=��ݫ��-�.��v��U�F/C#��R��dF�Y��`3���r�TEY{z��7S�5n6K�}��VrX�[�aЏ�����Y�mQ9q�ޕ���U���*G�
��P02�x45	����3�b4Q� )�e�����<5o}��
��������?�������J<���kiu(D�Z��-#(���������\04���N{B��T�.���~�������?���t��N� R��R5�x����e&B�v�^e�2v'���o��LY���P�斌��Un����cpF,L�6')HMɗӮS�(/Ԋh��y�M��yw��aO�ѫy\JWnF�.�U�fMr� 'd�T0�h�ӈ�9�|B��Wg��A�R����{� ���C9R�+�uY�vFU��~mM���� W5�\B�G�T�)�Bm�Rǹ�u��N��v�d� �8e��X�.���4A[�ɪů^oXY�R�,BS�3<���7w���?�p�O8�Y��{�&�(G1�$����L,hl�(�$� �n����R��x|a�lY�����Xvપ�GgQ��!��4�72�l�n.�!6�I�2r���\�^#�M�`L@�����u�z���:K�I�oZ��T4"��2�e�^,�/�=�yn�y�k���p��R�L��<��[��7 �u�X� c���.��ђ㹆I���;������F��X|�{P$2w�Y�cx	,��{������uJ�R����
��I Da)���N�\"��zk��o��hak:py��G���J�ʏ6��V���r\hc��msY������NT�1l*E��Տc��i�7�R�9��R1H+`�,�j��b����ڶ	��V)T�r��?Mw�@�W����R}4�9F%��8>�R�]hj�
�Vэ�A���%���R��j��Q[k�K�[�~�Z�/L�aa�.�4�]�r�>�/�4?��Rg��e�q�q���2rL�r��n�=j옣��	�;��GڱI�Pqh#-��}Y&� �����p΁+��d$H�آ}��
t�.�ӡ�}�<(˛,�Y����w�� ��rH��2� �XM2|�F���0ba���]Y��;�f�|Mj�Z���)���>\�\)�_��j�l���
�!��=V���U[Sl��7O�[:����T<)�ḙ]}�O
���iپ>��&�"����/8 ]�����vjտ�Bګ����tB�G:A|����ʹ�,p�v\���c�D2B4Q�P�{�㌒��lO�J3�-cEG<��.���[����$_j)됪 ��T�����/D{�&a�z&��w'�]::�=��~}������fҡ�?��#L����t�$�!Z���(��Ja�uI��)F�p��{rE�(�KljGM�O�n֍\'�l9^a�jH��k*dr\��9.qz�^�L:�V���Kf�cY��!��p��o�(1��}e{�ZTB��O��S��Ĕaa
ZM����]��o�e�)T)���S##t��3e%�^��2'��Isݷ/�����^�ɺWm�,�"�tlk��i��D\>Rk��F���� �5��/LK��h������oʌ�y�1S��z��(#)�?��}"{��p>�G��>Yfc���A!(��{��P���aY
=���2T\�k7AtKDv�
��E�5{�=�[����I�*-&1�6�nX������������I�zs��m��3� �����J� �M��B��b��t�
]4tʬ(�Q����E@�Uu��L�~��H���E��������_���xd����/^�h�~}������o��t��sV�)ה܈<�]�Ϣ�6�p�N�g��*�:��=B)�$��qSH� W�ekvi����D��߽>��&B���볯?��?�	u�k���� 
����A�qs�>�����M��K]؀UmY��Fq�q)�B��+w����$��D�:/k����I45�Q�k�Q⚻2�
*�sJC�v!�"��,�R��9��� zaq�,T����^H�2�n�T��l���q1���Ú�w+iX��k�w2�3�ښ�F��P]Z�-q�BD���"(vQ�:���}\P��Ӽ�ܻU	�q�-�=�*�tw��l����so���	�I�%1(%���*����uF�oΩPJt������IB���kR����Dw�]c�4K�ّR���*y){�uK�I�*r�"p�2��x`\hd�{M[:���    �O�H�q��E+���wn�y#��o��㗟��}̿��9J�]��Cy	��m��z�=�w}�$�}�������c���J;#±���ߥR�P���zF���ȖR�i@�`#%�Q\��iY]/�*(���X�S��a1����߷�<A�0O�3�����=o]�(x�*V��YO�n���O��t�V!��,���<�1Ƨj|�b0:=M�	@`�+������&�J�ylg�W?���8'�S��2��9j_t�����&E�k��+�M��ґM@��gAq����n�*��'5�aê��u����oU_�mk�`��7 ���C�d���!G\S5�萻w�c9�T�b&𺡀?L���Zt#�`�R z3�W�v*C����A�xL>
�im�gm�fn(�4{�,�;P�_A'p�n6��(8�qF4�Z'1ff����B�`��
yr�ܜ[Rw��0��5���·?�X:6-�Ʌ/�J�1F�B苴��NE�9�'kJ�o�}mP>�$��F�YC�ٙ�l1Y�?1,c�yj��jgU�e�5�\���ƥ�i`1!�p����Mf��5hOA9sߗ6��k��%�Hm�Z�Ӕ�e�nI��q����'�F��B򆸺�I��%l5�9���5JY�ƒ�N_�J�J�t�e����KNcC+��@A��ԅU�#R�L^���[Dqy�MrZmK��p0iכy�e��e�ؖQ|'矐�.[�v[�N�+�U'�S�ڤιܕ<J��)TZ\+W8��B}��A��9{��~K�����7�y/ʝ�m��2A�i��vk<�`�n�b������[Ӹ4�\��|n���Mn�$s�,P�.�tx/4܊�L����?������qj�f����DH�-�:Ǳ����:�2����u����x�#8�HL�W$\c�P<��EV��|4N��@��Ȋ"}����ww��Rh[�Zh��T�t5v^E-�M��_Ք �ѿo�B�G���X�-5% ׏\c�蘥�ִ�p��LG��ѨĿXyÜ�������:��I���X���n���(l0�bW���9A��m�܎�y�i�uA�F�Z<?T�X�#S2A��x]�#�r�R����HW�Ȫlh՘`�6r�P6���F��/]Û>Ch��޲���i��}S#UU�~��Ddv�\�mړ���t�����J:ćj���n���G\��D��]�f��
JX��Kg��2͈m�d���4#�=A)mA�Ej���mzQ㤈�b�����7�]A��95�h�0��g�ض�X	l�r09�,���EG�9���s7�a��t�l�+=�Ο�"��SA�#crKwA��Si6�U�IڝR.ʒv#�X^�(ĳ�v��{�w\E�-���q�i�Ǯ�B\�9%��W,�{�0�+tQ��
��;cM骹��ǜ��YCB�v�kHش�M�~�4ݬ�V��׫Cb��k�{Te�b�Np�:9S�.t(	�)O3�5��BP�nt��rCHZ����b��Z�R��<'4/��zsJst��� �6�O}��h���@�v�3`�L`޵����v��
���cӚ�3���{<>�/��`G�����Ph�
G�F+�l��g�ŔG�����_}-�n4�X��,�8q����q�ԐOͨ��?Z�*t���)r�[m��'��M�^��G���N�����UX����"��B�~�k�����F��b/e��:rM�2�>����<^,�Sa�s�Lכ�����{sš�IR��p���;��J!jgG����5B�)��T�Ψ;nyq|��pw�tsX�G�b0-SÐ�QB��Έ��\��Ng�eEA��W���V��`]>�V�kq=���ղӃ�V�,,ڮB��6U��笲nm/� V��T�9����$��<}��g�F3�%���F�܈�=z��;�y6�C�WpO��������wlzZ��>V��7�XA`�/��ج��JH,e�=Bt�iZ����{;Z�~�ᇔ�������/��wfi���N �`߄������� bdaKNl�[���G���p�L�X=����ȶ���ؗ�s�ԍII��Ƒ)��XK����򼢼
^f�Ӏ+���v�ר�����̻����F��Z���-�aq�L�a��S�T�헚��X/ǘ>g�mRn���"d�B�|~C\�n�OW���tb�;M0_�I��Z�/W�	)�,L�!��j-0�g�/����Kf }˩%�k:�!���B����͇w�vR=�{�-��}ЧX�Z;%�3LxYh_�_��`�i�B����L!�NGm�@>'j�b��F8ߢb���2"&�q��(�����r3Ɋz��`����u�|0��F����W4O���ZQ��y�4C\�W��oV�e�yj�T���+�Rw'�+dԖ�q��\�z��c�%Z~���~]jn�h�vFw,�+6��rl"��D/�/Y%&���9��k7���Xz�ɌJ��o��^$�Ӛ~3�Ϝ��k�2ʳ�
Z��+�gM"��ж"�!��~}������͛���n��������-����o?y�zI4;tO�dEŚ���C�ϭ��J��T����~��9�����>�y?�S��﹚l�r���1��JO�"�,�|:!��f�[W;!��(����cV�j��K�8'�%ب�;��-��{��������RnXɋe�+,r�dLh�W��G��F���xi��s��t� Bd��0�F87)�&8�]�B��tN]�!^���"~�Ξ�h%΢�!lr�.1J2>���)m9���p�-޼�9Vܿy{�t?}|���l�����q�L^��0�sz�٭�(>���`�����e��A�/���Χw�$r�3�5���(t{�>Y�ӳ|s�����&�Lw9�����<ڴ*7S餑�@��> �	H�?&_D���X��zz"��V�t֐��a�g�k�����bꡣ�z�8;�Wry�4��t̯����@����������w���������Dp�J�J�V��W��L��v��J�P9CҚg��Ey�iV�����7{s����Q
h\�ʙߥ_Ő]G�Z3a�%T�<�L��R�\�Y���t�$!d�@N�\��SM2�'�Zief�zm�%�پ�:Ua��<4��	�������Pw^	�-C7��ƞ�x��ަ�%��(�ӛR9L�\�aS[�Z.�dC����\�߭������N��]���˅��m��u��8D��8�^o�d�)��^�
b8:��9�:�_R�t�%�q��z�RPZx��K`&�]�e��p�T(��ɁV��HD=[�I�v"p�T��1e�������+/"s�FȽ�G��T��Zr�7�l"�^,N�K��8ي�-�/����IF�)X\r[��s�Bm9���^ps�	�	�L[�ҹ:x%��Ѻb��r�u����_%ۊ)�
�woP(!R��W����_�&?�>\e�mt�Bm��/d�5�r�"7��@�/��c;�ӡ�ya�G[2�R1���^1�kZ��W�5���	��@z�f������6�rwK�Pۋz�Kδ����(�5��%P�'O,E��{=�3G��m�J��H&lY6��GTS�w��h�0ɣ��d�g�DT���Q���ް��K��m���]�U�v���c��������pj�Ӹ��%ߜc�����T+ʭ�#ت�:c��Sg�-�ӥ��o���݃F��í��\�na�k�n���9SE9�h�r6)ġZ?���ػ���r�/{�:J$#`ԂN'ǭ�OF�����J�ų \:��`�ـY�C�o�#��n��d:�XSD7V��t�@����rP�k�j�o�nj�Y"i'-A��(��_vxI���&3�'U÷�.e�Gz2�e�I�q ��%��9�Ce����/2�f �1���~��i�77��n��4���,�!u&%�v瘬��t��n�� .�ڙ�doR�B4�+��I)l,N~s�:<�~ws{{�x�8>���M]\K2��    ��2N���*���7'Q�l���5��:H�Jvo�^�R�\#�3NN�7nMt$ʷ�@���T �Q���w��;a_t���T��#l���Bd �D���r0bmx�jWL�>.�O�B�ggAa�o�I���{R��#���CQ���>:����YQ&�T��1�x��1�KLLmIP��"������5��U��^�7��ཐbp4�,�?L|�JI0y��Q:������Z�c���j���2�]/�gσ��,�Z��?�oD�d��.(k|ޣ��JN�bЗ��Lض�Z'36�n\o36	ZnR6Jk�����5ޟS�Dg�B�u�T���ey
��;~�9�t�XX]��Pt9R�~Pm��x1.��ɨ�����vG�-cd/��NE`m� 
k�M�De]�b�=v ��
�`�t�x��.rt�\�x��<SH=$O.�����gI]���V��6���k��>mq��#(�ɛ���s��I���bB�Q�?,���?��Wc��B��`[�5r�|w��Ԫk�b��T��u(�l�c���R�˨��/ ��F]�Uq��/79���<��BS������<g�\=bE!�3W%����#m&X�?6ұ6th���*�v2��V�u�����Ao+a���ܚb�HC*��H� ��6�Z{Y۷�k�`���7P��1�돥�媎h��6+7T���F
}�$��ɏ� �+ܕ�P�z�ܿ��΁�t��[}�X�8;�K�$�D�L���J�ʙ�WDI=�:X�����4���sO��OE�9�5��(��/��?�������ۗ����{9�|�V� D�Xq����İy��~+����x�����L��<�(��4��ْ*904My;=��������󌃡�'��3J��"m��@����F�`� ����`��eI?��I�|���R���Rh���Ĳ��yv������8���]W��
�G��ώD���� �ZUOg!�$Gl�'���"�Ћ6bu�IJ�յw_Som�&�XBF>�� �������u�n+}��t���� 2���!-���B'�G-o2��f�V��<@kk�U)3�Ƭ�8s-Ϭ���i\���d�@_4���p��XvS1�E(�³�"�IB���@c\@�7�H�I��r�����6h;-�*��G*)IyṄ&��Ŏ-����Й�jY�E����tE��j��Pj�sB��B�`X����f�@��H�r���g�+8�Ԯ��8N(lwA�;if����ż� צ�/�9mb�R�(���w�(r�B|3	��D�w�mE�܊ l0��[���~h�^��E�}�/��&��
U��x��e>�[%]@�*�ˎf{�U�9�@!�ƀ,����ƌmd����z��ƴ�����R|'�H�O�Q��9��;"��M�:��������5S�Z@wQ�a˄��:���ɹŝP�c�eܫ�L��.���'���XP�^NJ�F9�9�Cc�� ��%�辬�I؅�s:�����Ҕ���U����Ai��A���d]�%:�ĺ��C1�Ǣ�� ������ڇ	�
>� �Vt�O|K26��$c,�t+�a��j�F+�s�JI�>�
�(/�sly��`��1�Jct��t{�FT���2��3T��2lJ�X�����2'=I��WL�p��߽����铸ݫ?_�J��7���x"�o,Q����ꄛZNf-�I8s8`�M�m��yac��0V3ؚ>P&+ 1Gy�j��l^ͨY���G��*r��(�/T���a|�1*g g�F����F�䛢� }2PT��/��w�-��d�]X�̷�Iq� �ǚT
p��ۛ�4�ܰ�%����W�:�Nų�}���g��,�~�9�~��{�v| a��������5���S�"q$F�)Q����K�rΓ���u�ޘ��BG��#�R1x�`AȾ�: ���rE#�)ĊWm��<���?8Z��[G2\�'c��x��U"�ԫ�ʭ~�1s��*e��lM��k��(�〇+p�GjQ�pp�M��"�p�z���Ag����l�5W��=I[&X#�
��3��1���c7���C��qR>��-8ԑ�>�/;�T*Ԛb�9.�o�>�D�g������h�Yd�1���J��j�E!XM���[�~'
��]�L͞����:?V����hչ�oX^���تp�N��ӧɽ�Fu���5D��޺�{Q�㬩��{Ъ�]'Z's.�)�^u�ݿ����o�8�i|���B���P����&[�;������N���ik-	�O���q&���*��zE��c�eE�&=GOg�9|�s$:U�=L �She� �5H�rƉ^��T^���]�i�K%��Fw�y�eG'��߇�T�&=�{]���88k����n��/Z	��~�E�Y��nz�)k(r��5״Y��5ĝ:�2aҞ:z�[���1��l��������}������R�L(���d��q�-t��8������Y~���+_����q>�̳iw���F76���*�9�"_ξ��N���J�M�,'���.�"��=0V�DkW+c��ѧ̴#��̘���܊�gUV�����V\P�;V�B��S���]���cXn`�jFs�_l��C	o����i���[��?b�	��h�B!��rQ�Ѻ\5Q�	�a�+e��,\1yn�x�Yr�l<py�c�����1qCж�Y������p��G�P\6*��>�6�P�x�'{L��E&��)τ� �xϮy�eKٳ�U���ӯ��9������;��w|�������$Dc�{s�^�v��|s{ˋ�i��)���o��x+<�~<����p8��~8���ӾHb�9�������pws�K�3Ф�b�7g�u���淾��w����m0����^A�m�����Re����*�l�>���oφ7�E����?gY��;0��� ���"��
�I��l������.#\~�A�8��do�Ue�S5��Ǖ���s�k�ة� ��

p!�?�z�:^R���~���JW���azS��ȡ�G��`�ޕ@|\񵦌5ɑE�/Mů�~>�W��&H�H�e]w��2,$Hʘ���9�Ƕ�_%P�k�l�/\T^o�L�7�8nu&`�h[4�^���)��=[G����_��g�Ŏ��	�(�DK'��&0�:���@���3&�"�iZ	�tP�R@��h��� XH�GӢ�o�0
�1�b����U�Q-�iS�;Y�]$Q���[�E�"�ʤ��If�����߸��5���<�����X:b2#ߙAFV��h/��h/�]|օ�:D)����W ����qL�;k��0�o�fZ���iv����� C�C���~�g"w�P�L�.2��kCA�U�ޮj}���`�P��������7������m�YU]�5���D��nդ{��+6=�dl�܍�M�1Gi���䏣a�'�<��'E��d'E�Rr�h�ԊF���L��|��zl��pA����vM1l�y�MF���I0�IN0��+y
^�:�������.K/2/Z=[(ֱ���>�C9�e�S������@N�9�6"�#���-siGė��Y��DY+���O?*v�Y7SoYpB�����TXJ�DG����?������DϾ�Z"��s��4�*�:Ջ|ǽ��J���]iTǴ�ӳN'���mt�i����/Cr��3b?s��(`t��;Y�fBBE>S� �Ƥ���2d� 6�٣�r;�X[���=��b$J�ߎ(��ha�=E��{"�V���w��~���wtJ�izq��Pk����
1�"�Ra�`X|}�/k�َ�����Wǯ�3�S�Σ��)#�J5��kζ��lȍ0�9�.���Uy��6�]L�V)#������h����ք��)��\+���9)��w�?D<�I��(P �Ho�u���G:�>{8��J�W*L��+�\Yo�!��E�٫�KW�л��E-^��븓3�[�:�u:�׊�X/KA%���:u���YD��F���$�|.��    Mx:�2��z*%�S�&��|����b��-8�[9}��I�*��ǭ&����D�L���U��/�4V���r����S(h��/���)͏��-��z ����@S<�wo
�S�a|���`�3y�ʒ�H�XP)�j��F�cHJPh�la�N����5ĈT�Y\��k�xdF{|�u���N�3��}�Q~Q�l
r��v��tr�O�=Yرξ���pU��zG&;i�2�
f����ͻÏ�wG�gr,�,�IŅ�l`�p67�!��IGVRA�G���&k��θ�Zk��Vv��۹��U���^�;�EO �ͬ����}q�����ǷIvo:����X��qzr�I�"�ہwx<�[wu��v�L����j�ܜNR�����@)Ye]Kj�i5����p����Û�����h��7�ی��D�t]�>�NM��l�$2i�{�J茞5϶.6 ��Q�B����:�In������yeF<J`��S����6�H�t��K�%r�b�F~�2g��u�*�8"Ԕb�����6���c@ޛέk�	�_�i�D�Z1�ea�+����K�]�:,H{+�):�[�3T�Dy���ޞ����3F�o͋��bl��a:R?�ھ�5x(����B�!�k�ܧ�����W�5�W��� Y��Vvf:$�������XDs�^d�S���]��/�hcO�G
���H��Bʕ<�����:}�9���+#_}�}�i�r�t��� �X.�՛ܐOH��V56]G������l���5���A�2�����K~"�������E���(�ڒZ�um�x��c!�H�O��"�?�03��w��P����o�E�B���As��	s]��i�sW�Y6�� U|W�Ⴒ	�����)�	��J����#�q�ލ�G(�`zE�g���>�����k3���U�c����z�9�u.8e_p��W��M�����(�Z:J�$��LM.�|�÷:>TI�\����cT3�mU�6��S���c��N�@eX^���Fv����Ƨ+�
gO���ս��-Z�.?]%����b�=Kk��b�LX�����2�cS�g�*����Vt���MAQ�~��ܣ���}���Xd�B:w���^���Ѧlt�}��K^k�u�P�g 0�h�zp���������ǻ���S�������anԯ�NP�o�#Ɗ�8׃p����V4� ��9 ���@�p,�[V��8^�%�Y��K\�,8޴73<�\���I�J<�I�`n�X���������񿦿�"�M���*ha~�ѦwEgՂKo~�
�Z������#XAM(��T4N�9��"o��KY�y�$��6G��)���t:���k����<I�Fs(@���V�2?:;��B'H: [�%�w�Z�\�ب�~��0΋v�.�+�F\�18e�,_��C^!t~p�9�Z[
b��sS�<`
�C���b�
T��?IX��y����������ٲ6zc�b:�'%tJ;#e��D�[�B���6L��� ,U����
z��'��{b���p��H�d'f>'"���Wv1`t��}�P)B��be���bJ>�@��
�*cb�O�l��s�K΀O� S�MG�D��2��`�+Y�':$�U��(�(!��|�6�1�ɸ�Ѷ&�v�(�G�}A#k�k��QS���eO��o�4�8ᖷ��҉%({)��Z@�ru�����e�>@�7�������-�B�ٜ�=s�����!K艳�T�t��F�ѫ/�~:O� q<��GT�H;�} -�M��F]:�x�*^ӝ_�8SD	���[�F��!��*��%y�{�6�[��b�-��!��3��B�t``�������R�Π�Z0����z�CrB�,�C��W��r�FY6��O���l-�hM��g��0�Ff�O����Hi�%:��L%��:V�8�N�Y�Nn��8VOl"�t���]7�[����������p���ɩ���	(4YLS�6d�Fo��O';j��1!�T��g3q�ϭ[g\���֡�E;�:=E܋���~h�T��M���I5�)v��8���n��B{ɹ����e�����պ���p���?L�%΅������S��鼧�9j�7L�
^�Q<��YAyi����˪����0�U2c �B����-���K6�;(��X�!�U���i��,��e�w��\�:��)�iS��,�w������S~�4*9����P��ϝ^{�W7��˦�]�^�R<k����_h<��DMqN���XYИ�>X|�u�iތ��;b�&�l�d ��eЪ#4�P�B/�<5���L껷�?�>����ԣ|�Q�!I6z��xBu_�u<��O7D$�ޯ�����X�j3ӾHe]6��f{��@��8�^>��/�~�$~�����T��P1sF�{�#�_��vz�Τy�ֻ��g!�KK���"�(�K�0!��-�m��d��n���������l�$�N���.Gh�Lt�U�,o�*�m���]��c]����Ǽ�L٨�O�̋J�`�#�r1�=wL`;9��ZBW�J'1��e�`�x�ȕi}W:E'��l�ܤc�XK1'Q������f$l,��,�?A��U(��=��c�E&O���,�)�m�ibVWOG�w)"�Ն���M��ĬS-o	���������M�/v
N���6�b���tq~�㾲Z?�i���}t�<�ձ��i�l
�Y_��MD*��y��eN��r��,"P2뜓
kq�)�[iʙ̈́��aJ�~xN��Fwч0��&:�Ԭ0fM�x�.�i��i]B���	߆���'�/��o�)��I�����`�����b�/��LUL�mNG'U����6O��y�Q�ygYK�����[p`�{o�GN�4ř��������}
.�-Ϙ���	�� nf��f:3a�����`g���.�T*@��e~������R(Ai�pHE�Uy���e����g��]����ը��ϫ����I1K������[�w_�?�\��~��������	gf�17)�}j����dwE~待�;��X��*&��
q'ǅ,�<��W��`�k��(���T��s�v�(��*[cj}�����V��}[Bj}�z[����`r���*޾uh�3��/ �j���P�t�P_�jTf�p�� -](&��m����V���/����y"
$r�鞇P��÷���IJn9����2��YR����ѿ-)=)�Q���0�*me��О	­�t\�9��I,$�����ݨ�g���3��I�V��Be:\��^0j�Rf7�������5�v��7�GP�z�A.�Dv��p͘#�B��S��Tj��_��1g$$lO#>�͐�1�ʻx��qS|�ۂ"=nh]U�����Q��F�ӿ�QAD׺Y�r#��eԼ�ؤ��
��=bqQA'�F�ʠ,#�X��[��"�	��V���wH��<�il�XHhy&�11�V�!giA鏜��Pv�&qr�堭�e�@��l�X�̰]��.J�R&��&���]�X}l���2+�LnNA'}��o�m��[�����4�1u
�+�u,%L����/�@�pO@�>E���E0�'d؄V�lMp�T���E}�Xw�FȢ!�Z�P�Y�J����̜��4� /�>�i�
���}��&��.|�Iz�:���ŵL����FcecAgs�lP�`�!��������Nph��NQ*\��;Ԛ��zn�(�a�����<`���X��|�j��N��*A�F���k�[Y�v��8��8ߍb���mkV]�x� R�ŭ�B�{��ۛ�]�d�_�x�W>Μ�l��u��f}��0e`�Q;0��3@� .�����eN��֮�4�[�3M̾H�=�fQ��?(�sa�Vti)��[~�����_��w=�eq��i�,r�쌵1X�*������:�f�a�[��Nw�R���G��:��X�'��k�G9y�f�\H�ʖ��� �3)U�+eK�ꔙ`�zg>jJ��7J; m�������    
�6v l�8�Mr��[ ��@�a�㵥���|���i�A���K���w�A�no���R��$ŊC�$�x`�I�O��GQ�N�Z�{�"$<� GJr�L+��t��vVn�vs��� ��dπQ]�r랞�S���z&�Kw�5[���a#�������d�M�g�M�+m�\˝��YG+Kw�ǡ�cB�i�~IWA�0����+ɕ��ɕ=`M��htҤ%��=�����n{B2�Y�<�%���︳b��4ζI4-A�<X�A���J	�6d�φ/��|h��8����T��ݴ��%,�� [k�as�%ka�08�,�l�_�ǜ�[��H�w{Q�l,����#�+NԄɵ��xʫ��{:O'��VX��*��)~�$U[��&��gc�\itjK^ZY��zt���w�I)a�_�HJx�hJb9�����KP_(= zOV:Ԝ#>GX'O͠�Wy/^h6I���Ud2K�ւ,Zy��́����9�M�܈���`�|jbʺ�n�s�_�1�a�#ؒ{S�<�����6��4��P�A��.��d�.?��r�
�ev��n�ZA'0���J�,بe9ѩ��x� ��'W4Z��ڔ�q��I�d���^;K��s�Z����yM��>�] �1�z:y��h���9Z�[�Z��b<j)h�X��[��
_ E��ذK���:�]1v��T�c汎.)k�䶪�ștQ)'e�L�(�)����Nsٶ��E-e\@K�_k��)���l<+E�N@� T^G����`�n�W��W�g�����X��W�}>���K�q���j�^��D�� ���U�'B��Q�#�����ME�Z�P��;Ti�x�da>���8INp�)��f�dL¿^��8������2D����S `�8%���I��)��Mw���"��C� <��}+�>}s�@���M��3ѺZ�'��4�IQ�lA;^N' �f ���t�h�hb��BB��շ��Y��Yp���Z�Yg0�;���m�7m�Gfp�I� 9�v�e��oVY�b8�p�\3%��)�A��g��8���W�w�s;M�˱��LΪK�.vh���+�Y��=��5WӤ$:���9.-�u�6��z�y�?�+�R6$�\m�n:�'������F�T;�K2
�/2?�u
��NA^�{�N%=5ѴU�����K���/�d��~��IR����9s�3��S��q���tb9/9�`[!g�-�҉��*�4X��@�u�ʿ�>�z����e�ŕ�(�0(<�[���2�*R8EG폮9���+�u��ֹL�<C�\o#|h�=8��O�Z��yv\��ω��I8���;mV����Z��?X+M�����`h�� ֜��+u���焯V'PO�d�_/�߅̯���6:=�]~����r���nF�Nx�^��c�<�M��ķ+�(ւ�<0�Rq��qŉ���|�j����#w}%����8��!A�j9_���mSK�3�~B�ZY��M����.~(����ޚ�J���o�q�5]\ι��g�����u�\���7�7Ҝ�Jr%��B&�I�^a���;��f��<"�X/���<sj�Bk��F�y���W4S�����{k�)����S'�yk-&[t�h)����{p����G�>L�P9�g�CP3�L�<֛�~�g����0�*�؜��4G�|/ �v�k�����ᐚ�77��n��]�q��yL�+t2N@F��A4*���0L�\��N��%��C�r�e�ck��6G����+)�����^o;�A���8;���wt޻`f�]M��lu<�e�u���I$�tp��PDCk���,������i�g��NLr���O_4 JS�R��R��k��E��{�&az�8ԉ�L��� ]��xѦM)���������$P3�����_����~�F���!�` #���nmu��(�r�S�	Dځ˯���
^�ƴ%� [pF��+l��A��¶��B�]B����/=��3�o���k�1/d�cd����#����pR;X� ��bU���hbO=��(����G� l#��`�t�
6q��3��\��ئ͖}���Q!e�l��Wg�dw�����2�>�)Vγ�;���rJ��D��J�1!,й��MV��fQ!s�l�/�:y�h����1�NJ�gW�7�e�1��"��m��v��U<���z{x��a�����NT�vo���z����F������6��v��C�L0a&z���D�r� �vi�5�k"�"�1F��~�s�|��Y��� �g����5���s�6ϖ��hS{n<��DQ�l4�>Q�B��o˶��H
Bm��K)��Dɺ�طXi�rmgl�3/I��#�x@O/������2�`#���\��@,k���ְ�h�L���w���$O�,b�|F5�\��T���x��/�C$>Ji�$��>L�A�*_!y}IAKS��Q�����e��:us�E�v���Y�L�C�� +�&�V4����v����D5ʀPȉ֢��1���iRe��d$��b���������7Oowv�Hw���=ſ�p�'<X
��5� �ۗ/�rz_ݻ��X|���l�����񹉭�ļ=��v�H����N1i2T+p��xA��2g	ӛ�[=�������q�2B*>Y�|*�Ϩ/m���Ѕ�E�T����u�� ]�P��:73o�:�S猉���F������*��N+�s�d�tg@�:�Ʊ�3?<�u�;����O�C[�Q�Y�4Ж�f���ε� d�x�D<-�\=����aK��?�!9�D��=93���6?c�qZÎ���2n	����ڨ�E�IL&�v�� �I�@ݯN�	��}I`[A_gV��ւ��4-tyQ2,��Ҵ\ҳ�ѹ�~?kOG��N�9�Z�P����}K�	|б��Q��w"��5�1�X��9���01�b)[�t"�f`�F��ţ�FՌ^��Z��I�zJB��LM$����ޖA��ި��NN�Kk��'	��Y��q�����0WB�X�i���՘v,��ܤ~�hte������6�~�����HU2�M�?��w��?��Y1S�Ϥ��]P4\��E�?Y��n-�������Y�&Lĭ�����m�I��6I]��ˠ��1�*f�U_���c�R@��f4�瀚.%0u�'�%�kɯ2���	 �ĹUꅤ�a;
,�HYl3U�u�l��Ni��tQ+J�ZsAB ���	�EF�'�O1�R8�7}��A��W��@������\޺���q��R�v�v���do����g��^�F���� p[�1, 1��J��d��1���y�X�\e�za���~��G1���g��I�nh��Lӛ!j�?��L�M���hqv�r��`&;��ǛJ-�*ջ�`R�݀����,��P1
��)��u�<dŚ�9_�'(�HU�Oz���o�J� ���N����Nq��H'r�'G�H��"h�U o���v�t����L���`Bs_f��*����Π1�G��� �*Y�e�1�a�<&`�XjVV�=�������|Z��!�;�u>��6�ʑ2�=)�A����#-��͵�33�њ��.s�m��`�Z����%]C,�yC�HF���z�_1-���Q���7ow���{�ˍC��"Jz:2ż=c_ct;%0>qz-�)�2��Tc�T3�F�R��!']�P���g������O�Y���v��s�d��ʲ�E�ʲ,�{���:F�K�V.��T��ũ(גZJ2�©�*|��&��ed�'��A)P�P3��	����>w?л��zO����Ђ��y&�!	��9ǲ�"<<��z8$���;��wLu�=���o��I�q�{s����?����j}ڿ~J���[��|6>�~<����p8��~8�O���QƟ����~��w7�;.��і�77 U���_e�p�h�l�<Bf��ʱ�`E���`ͬC�M�u��`1�ϝ�%>ű�{'��4p�(=U�2�[�N2�rrD�S-~x;�6`�#�}$���iD    �#e���}�d��S+o��ê}V�L��|�X&�t[��#�>��o����;�Z�HV� �X(7a"��BS��|#m��;s�#2&F]L���1	�Ւ��F6����+�z΀�Ͱ��ѧ+8�'[�� 5�aқ�Vݬ��7��D��-���t���(Z)��C����O��ښ�a�f�7��L�L��8ϥŮ���JY�cD;
2c�M�+�_U�H�}�(.*Jb�Uk��n��`	����
ո�rDd+�Z��b���D��R�<$϶G��Z���zki� t-Δ��j풒� ��Z�_P���ӹ�:Z+(;���h>�����Rv�y��H��@u����R��kǰF�1X�a�'�*��ƹ��OL	HJ�vDj(ok�i��v�&��iHI��⼽P�|;�̲mL���9ʞ M��L>a֬_�Or�d��Q��A_[���;@)�O��`L:*y�Vi��q�n��,�鲥��$eFUOa��lq��GI˴�Uڶ^�jM���A�&���'fuPS�@�>�z��� 
�jz>�Y��A�(vg\����<���Ʃ֖�sNJϚ�5�[�_R���V+i�יΗ��N�",��Q�oCp���q�ϳ���T���e���ܧa�bAg[�W�����8Y�}���N�$L��`�V!��($��˺H��G�����x���o��oR=gʕ�Q��(���ʘ����P=�J'z|
�4�
թ��J'��L��q2�/^��sB(�ih��/g&gd��b����u�S���(����p�09Fa�L�J�I[C�o�c(�B!EG�J]��#i�AߺL�UI{�����F:ˍ�))0�0IA��V#H	$^��`�AjK
Nt�fI��r72S���~�C�<�vl����]T$�|7{����1V��Y��>�}Z�ɨ����e�yl�����4&*�[c�I�b�i�0N������0f���.�ѻK�(QY��J��z�|�����S��<����mz�D��||AB�h�x���"���v�є��v $�؁���NP����	�G'3x���PͿ���;��ԓg-k�$-��Q���l�����{�W�p�&n���Rs��!���3Mq�9��7���Ҟ���ۗL_�Şؽ�z�ǴnNN�T\)'��#�\�CM���<�>��J^xUEO�����E���M[�+���d��m���-#!�$�y�u���|Ƴ��*yn� {q�k�t�{y��VJ"W���҆rI���L��ť��рP�� ڑ����qP����w� �^'�9�)Z��Z���в
�鼊N��D�k���C��&�	s��1B��ͣ׃��1��B�ic�C��L��S3:|�\�Z-��ׇM��ʊ?=�\�E3p��m�tRX�td��סu���nr�z	������p0y�����ܷQ#;�����ab�<e���Jʁp�r[RZ��T����UتmV��reF���J���S�&v�"���,_��,P�Mi���21�P� ���m�Dh��~���yBE�m{�G�%qk��1t���$c
� �)Uj}������̖�]Rc�c�ϰ=a��3���3��Y����Y+�6��ሸ��il=�d�B��(�܋u�Y����3��j�Mr�JvF2��.�u�!�K���`�c���-�,�bUM|ꆛ��'���2����X����0��y�w��(ǋ�d�i��J�g:��#e�bNK�à3�O��9}	�e��c�t��;�:�5x;i�c��L�����{��2��x9X7Ӯ�ť�d��עcB"]P�!:���ᛇû��G�����#�}�2u C&���V�p�Z�c��o��������I?� ��M���EЦf9Jz6i�jW�Wʼ,��{
�c��=e^f�Z�������M��h���f}(�b�8�"�^g�*��q�i�>
kYmTQ+�|�v|���L	��,Dq��f��i:e��ֆ���o����Ȱ#�i��T���ΐ)��YLY�ǮZ.�BGO�	���wn�� s��0i�$�EW� ����(7L�7�9)����e�m;Pi� ��).���ąƱId��H%j!�`�5���)�+K�L���EϮ9��䐷���ef�S�@;�����*�̺�˵5�~Ƀ�0%�fO�:�����jfAK��"[��~�-�5�#��� ��w}�$���L1�r�pM*)����S�Q������Ff��j��p��~��{�r�w7O��� <�� y�H��4�%3%�+;=E��ۼH��9�ɸY�{�E��A:%ʏ�כ��㇇�jn{X�4�c��RD�t~���e�}o��5��e�ДQT���Ӭ��)�ӂh��7Z�����Ɖ+
����L�]48�',3���A�h�Q� R~H�{��H9�P��8�v�&ic9�h+]���+������_�����	��<3�k�lP�!�#Sٱf9"N�ܭr7V����)���qf�*G��yK�����,=Yc�Az�>������!������~����ͩ�+z�h�Մ2�oӦ�[���E��2��EqwR6���V���}ْ%Ǒ�3��RZ�˼Q$��C�4�y)��D��]PW7g0_�p��H����&Zf0b!�{of��g1�x�Щy�R�D�<�# ��鋍2�o����7�,�ҁ�>k�����i�y��ЉA笒�no����x���V����]���\m^q��	P�~H>�M�~~&��;:ɄN���"��|']2׭Ѹt��pc.��o�'�D�d2�7m#��(Ź��k�biK�A����nge_�����LG�~��j����Z��d��[�<%�5��� ;�|޹n�f���&��66�ߗ	��XZ�2�4����L9ݒ��S��U��J��&,��g�G�����t����h������[I}�%d�ȯl���)% ���cv���}��`�'u���@�M3`�-M�_��sO��_�}T����2�"l��դT�1k��Xy����Ǚ��v�*:	��L���.j�+�e-[�ܝ)�F�����?|��*�l��{��%m�Y&���c�~�*�&�OC��w���ͷ�h�|7$�)����S��&�zI*��$����s4dՋR��u���6�]~Kh^7��g]=��#j�Ӊ7e��̓hh\�-�}<A�e<7�x$^>�`N�ޙ�͌�ʸ���^�.��SyŤ�"؄o�/�w��Gu���bK��5�l��<��y��_�_���Br^م\�6,�w�\D���|���C��ߨ^�MsI�"X�p��E�J5��A(��AAK�>Q7ʓ
�i0�
�� i�F�Q`�ؒ~��Sa�w]�\�_��e������L�-�'��H�|���K����Y����,��Y�:( 6j`<�S9g!婚��%��A���"�NS�$G-6gn#"�#s��A>���m[~����"j8�[��;�i�2�r{�����^��/jڸk5�'W�2�|�b��AnF�>o����/�2R �u�;����&���L�큛�G�Kh�Ɇ�$Ni�i;��W)i�*7����[�s�4r��&37?�����Tos�͉w�!�����I[өtik�x���v�ɺx���uzCk�<�ь����q�ZJe��f z�\d�m��?�Ku<V�LjZN
�A���p;^_e���t�7�X���|�O�iO�`�oK!������R�O�&�PJ���HI-N��^�j� �,}B�.� ��:��rN��nWҺ]�W[�O��H��-�ڜ*�sL�3�mF�]ه�v8f�v���n�u9<LN�uX<=�;�A9q�>6{j)�,3�s���-m'�TmI���K�}f��T����3^y��J�Kuv��W{����7J\�Q�>2fm�w\��!�~;�Xju�G�|ȕ�����q1ȓ�Q����K�S�����m�����u��P1��=����M�v�R"�0*��N(N���؞_�u��i�M�*\*e�,������=���w�*wJ!!|���Pϩ�S80q�tN    \Z!�ϱ�� �	(���B�.{��
I}ݎF��@�1�U�}/4��f��@����n��)�!�;+�Eo���:ށ�6�	MqY0�b�Af�BD351wE�qA�W���ܿ�����f_.��W��j��A��إ����]"j�L��I�O@DLe��8�D�;NDmrl������E�<T���$�PN/�;aՇ��vj)_���q[v�O@Tn.�&���l%�|E��V�"I���H�Gр�?�����Ƙ;Y�ji�IJ�]U�����0�s�pWn���x(S��6V��_m�/���ٷ��ю?.�W�&9�XV`W�5ey�5�Ґ�c�'�k��A8��_� tT����w��b����$ɕ�Z�FѮ�k浩���gںƺ[��1��������sj�x�:�y��F���KJE{���W1ǣ��]���>�{���Мx���=h̍F��k$^v�"%M��y(�q�hS*grk:�5�2��#��s��c*<������O%=���Ǉ�7w_���ް��2T�w��|��+�nS���Ѝ����^�C#�T�MQV�� M��}���P���9aNM�(����i��媑����*0�%:���
���q={�B������̕�s6�>zg���?ä���CG�,���yJ=0m�ǟ���@kTK龔�
-q<�:Qh��b ��ی�����r�G{��� ��A
%s�Y'b��=Ȅ3<�����������8�"����^h���zl�R���]�=?@�~����=�|�+&s�b�2�jIFԀIq�BR������*&a�O�`^r9f��Y�37,	���?%	a�b?cÒ�j�Ôza/Q}=���JK:pEN=�g;,#r+qæ�5^5�](��}�'�z~$�V��8�ڥ�:o=uFm�G>�Xۉ:�tt1�y�K��1B�=ػ��`�8�A4,�xǤs�/!��I�^\��s�\�Օ�gR^�����8���w��ʣ���hy���9veX񹤭�.m.yW�=y(���|Cq��j�Ь����w�t90I��No�.�����|�P�s�����
Y��  ��ͬ�,��g��ڔV�nH�3�)�-�7C��:g���# �>+eCw2�IY���o|{������_�/yoOyDWp<V���ñ�_r��c�y�i���lc��M�¢�X�D4#E-�thAA�F&��E��d�yb��_�c	�i>�Xe���> 	�����>�!�!�^���=p��H`�,�cM����^3Z��&yP:u�ro�)�Q��qyF�G`L�oS��2�2����:P�F}R 8ĩ����J��-2�������@��4��BOܟQ��3t�9SB�w�D�R`�ʴtw��<�}�ԣ> �Ol�Ǫ?��<��r��d%+���m�{��T]�j;X�.}C[_��ZFfʢ�v�LR�*�
O`�>&ܲ��ؾ�'1�u�W�:��ؐ��2�柞����cN���Uۼ_�m�)u:s��b�@*l{B>��]�ϖ�n��xn�{f�*���%�2�{]��m}�4�tԂX��9��g��]Rr�|:����t-ߵ4�+m�i1g�$��a��@��s�Fu�B�y����[a��Pj���B���rb��IM�Cs&�"t����=D7�#F���f"ܮ�cmwe��q�_�G���׏���q/	�_f��N*�22.�
�y{������ݿ���J�!iN�PI� I�K��Qr�(�j�1Ƞ��BM{�:Ԍ��r�X����y^�o�7�"&�L�>{'�Ր�Ɉe^V�W' �*Ц�x{"�AI�{$<R��d4����<��@�k���ǷZ^Z�2�W#�(�) ���!\�_���Pjm��9�<��+C� �����t\urw.�a����T�z�{[��w�1�v�Іr/�����d�=���%m�O`�\��#�����5�[6ln�\E�n
Ѳ��v���k�<h��k4z����M���i���:Y���z��r��&�9Rl��;ך��!�*r4�I4r�E���*��@���\ͭs��}��n�ө@����T�,�=�+ M��yF@8My�*%���`P?o��b���r�O�������]K���¼�t�=�QԽ��,���	�|�ͻxQ��ps#�An�F�EJ�D�DY��d)I�(�8�kE9��>���z8;y(�W�c5`�S��@�^�;vn�L�CM��U��1�� O�Y�dcL��y]��(����)E�b�tl�#i]���\<q�%�?:����ѼM�������:(Sժ?r�f��*��6�Gҵƴ��ܐ�h$�M��Ф��Y`�I����$ʗ�0�f��/�Y�pU� r���k�_�)S�滩Uk����N�3m1 �Ud.�\�O;�=Ѥoy����3{ ��:��s���?��%R�U�O�O�.`���i��[*�����'��4��u�>Va�0r�#�ꄊ�VQu^R���I�j�ճ�ש,SBq�Rd8e:ьPi}��������q�"�Ja�xb�-�n�:�;�ӡ��=3kvBp���f@�ާ�?
�q�*����fG^�2^�s��9�=j�	U>�w�q�4���n��j��dڱ�9���娪��V{1����**2�XkV1�$Ӌ�)PE��!I94^���'I9]���>.ι;�6|�W疽��xn���RLL�M����		~}��2�����I�w�!VV��g�/����}x)<��O&�~ߕ��t��)��de��_=��S��J61k�UVd(iYjEe)�T(�(#�BE+�ب�5���ٛ�(J�@_rc�}T����1
>�~o[o�h�k��.�e��I��#�t��*M���+UV(2Sb4SF+�s�}�==��<�V�R�\���Ե�E����+F۹�	���vĉ�ٍ�W��I�Y��A�������޺�Y��`�6����(NV�<K �#�1�q�8G��fT��Jj�R�iAq����U����>I�+4�-��ޱ<u��=�e\^{��k��>����>��1�&hQl��Csk�ͥ�YJ{�Xm�Ŏ��hKΥ�5��8�uuIz[s�	6$Jy�͇��Lf�'LX!M���L�/=b(����%��c�ӆ�q�@x����'�� j�����?ؗA�Dw#�\����[��b_�싊(�cL��DQ<�'OO{8ɬ��ʩ *x8��`�j<NCqK����G�To��T]�8lىA҆�~�q�Y�� _\����mE�������
�P�kg;a�R�A�{�EEU��_	tI������T���[�z�Zp���x4hp<�o�p�:�i�5� ���9���[����������:�0~��[�	�Q=����p��䫖�`c��(�j"��B�r@��E:���V]��([[ߌ�Ix�_amQ�[�V��a�_�a�z�1����g>�Q1xS�L����f�?�W�V�܊�w�H2����u�)�+�!���qEGFW��è*�	9~ZD��#7�;�+IG��wG���!� "��A�؏�>;j��:眻Q��`�3�qhW�k�[�t����x���N�.���jK��X��%l5'��1�H�����:�s��v$��F7ޕ�໹)䵟߭F��Ai�b0Z�7����uo�����do+5��Vj��0�R��ق�ځ�X�c�#s�����BV��Y�\Q�yA��dŐ6��wQ��ȗ�r��:�:ð8�
gS�.�ԺA���
��@2�Dq�ͨ�
U�m��0��R�w[B9��ov�g+�R<��"��/�yG��q��[P��V%����<��A�?�}��v�țGL	�&�E����p�R�/C��4�wJ
H���l�_	�Z��KU8q�W�O�pi��y�%���g˧��Ց��U�������ٗ;��\qڣɓZr�\r$	U%֠�@`:�R�,܅KO`�DJ�����l]���5B�G{8k}�E7�2w��|S��cR8w.�-MJ����ܵ��.љmk�"��Xa���D��+�ŭ���    ��w��)+�1��f�m-��`�)ĵ�E�P5ѬN���!���I��3ey�|A���`.C�H�$W �3����L��9�=aTRH����#�����/0o���"$K7F|�m�cP|��0q�$��Jc̅����u`�,8�@'E�9��ZK�{�=s9ur$��j���O���Z����q9q���������R���������-��b//:�~��ƍ4�[��.l�*�8�0�ŏ���y�r��|a@��M���	�aŸ+O=��*h.�c�C�����ؘ�djs4�����4���#M���*&�=�W��KK�H��g+pj fb�ќ)>��񨻖z�%��>����{��Z���k�\�ק����w{L��:n���d�k$�c���2�NW��[i�X�y&6k���d��P�[�O�2��9��ݪ��4����)��cX�s���_kRQ��enFS�S��y0���o$��ì��Y�]Ts ��`���_�d��3��,�c�(��}�O��J8p�y�,+=���2rA�(�X�n�62[Lܿ�����ww_����41�@�Յy��Q�I#f�:�L˧Zi���X��k(:K��3ei�e鄆�i�,ƛ���]D{}���{%C��Ŋm� l�X��l�,K�p�.�x~#���"a�� 6�6T�`�J�f���In�&-�ʅ�t~Nŋ�d��%�8�;@ť6���>~{���o���N�D�	7�a$�('�b8�g�p㖰���V^i��(k��iJI�"��C.8�,@|��e�ic4����JyZ��<���fc#;]���@3��p�L%-&P�it�5`������j�P7,�ˈ
 �~Ame|�>c|�9lΘ�F�8H_Rb�����s�a!�_��VM�x�����h���1�l����fg� S�H�&v�����_D=g �vK��ٴ�2װ�"�ݿ=ܿ�������Z�N��f��7,��S��S�[Ȝ���*�<kG"����Ɔ��DZ2�7�܅�x�c����	�LTQ2P��|�$�i$R��|hK_@!U0 �|s��y���Q��I��ȝ���wT͹ �������rӞ��p1�J�9�1B�j��j��Hc�3�H����C��Z���]Z1U���c�+p�	"����V�.%��w����>�sc@�:k9��`�ɺ|ث5�)��.N��&��������[R7p����7s1��@���X��B��Щ���%���/o������?��h���MA}�>u��[�T�����x)	n`�J"ð��0b^�28��ۨ�rˈ[D	(f�'jPhP��{8N8T�ϔr����X��ì3��e�W1�n���f��0�����2��&��j�'�o��u�����U~��^�I��4��*
�?}|ڭR�Yй�!��@��C)�;�ു�^fѓ>҆��bBiV�E�2|j�<l����5�Ko9и&����u�>+h*D����\[c���j�u2�m���;)���;^��*i�'ǣ�l�4x�Tc����%37'�9�C��<?����.*n�?v)�#�ꪓ���������#阯��rˣ��:�7�k���ǢB�a'Pb~.�o�t�h�o�PU�\��$���OI����[��LF��6���th��pof��G���Yc3�M�$���a�<�/��B�j���t�uܘ�q ��]\�e���F�k���.�)]e�%j�g�EͷJ����c�ZǰC'�!w�4����>�a�H�A�
�]n�1���`b3Ae��7�`[����/V�j�c�����$b���Q�%>sw~�7r�-�H)�N��!ʗv��y�:�9YB^/ӷ�m������V��h�]J��]��e���<'y��[�_�YW��X�������C�3��쎐��NqYKyv�3ֱ�+�'R��wj.�Z9b�����R���xx������%��1A�@�[��fox����C�*ֈ�!>S�Yݻ�b��~
�E`���۩(�^ד�p<6 )�K!S$��ɼ��مn݌#H��j�l&6(XfLTl����,El��Scpo+-i�JQ�k�����c���ߒq�w�Fи�=؟������d٬���&����4�2��c
��8W��n
J��Bd(�\H�¯4���h��3� aYBT��{��0�3�p?���}I��w%�v]a�]�/cqAP�-��)@aħ���uե����U����]+���ח>;�h[0�_�&ˬl�����y����_)ׇ{=(��bC�Lىa� C�	��D��ny-��M|�[N�?b����Ä�J�jI^�z��i�w���W���*sY���)p)�zZ,�Ԣ�d��V�M)^�+m�������ŗ�m�����p��	Wy�3��d��=���	G/=t��\�E��*A��6��tH2զZAC���vb���0�V�?��O,���ŭ���C�9/w-�b`}n�V,I2)[)?�T�u�{�8fz��T@���HOԐ�dp%���`z�����iQ�>OӾ�X_�� il�K'hy2L���r���d
�>[Ʀ��&����l��4�?Yq>�J��<4K?,� ��vCw)P9^�*��/re��C�F�!��L�Q'�[�y�N��������2�k�1�7m�>�IM!V�k�*;8j+���N!P��<� �%ܥ��E������z�ʉd��+Q����2/(�h�T{gJ��'��R�u���c�Oք�(�S�߬�q���I{n��Z|�(\֍E���M`�tD?|��Z�k�U�^�C��RĺCCꩬ ̖�9S��b�z�Y(��{��� �����O��_~��/�9�������C�3>[��ͣ��>��_�_'ݠ�`����5�Ktm}����~��`��ujc@1RoNĞ?�"���i�(^�2�F��M���K�EP�μٝ
c���''��Ug�Y4S��B���S�+#1JE/9h���xm�I��͖�+�K�a̖
�c�v��"53���q�
y�Al+���&� �������&�>6!�6��X f���^�� 7፟�Gl��������_v����j���ڨ�����v�������%k�ĊI@:����D�=��R�<3ʶ�c�(T��G�xU�7\N��J*�li�b�*��AIu"�jNome�/g-u^n��3j�������5[g�mj[D7;����kZ�`]�,*p�;Ty.li $�R���b�E��C�9b��66%��{��Zq�8ݭ�s�	HtAsH����'M`E�_��V��!g�FX�#ϥ���zї��Y� 	'��HL@�������/8F-N�a���'�0��9~�og����sͶ_
!�d:Kjv��rߔ���!VH����*wp���>�ql�7��j� W�E�y3`d��6�����])�������n�SJ䵆6%[Ӹ��I�:È]D��:C(��FL�Ѫ�Ç�J�#�g?`T��<[��pl�f:]\1~x|����d��Ӂ�z
&C�}�`���4�1f��*�`���R"%�B!�g}�۟?���|�1팩}�8LVJ�{�.EX�h�P�!�-A㞟p����.�Eϔs�<#R���_�6;���6.�(Vg$��Ӭ���q�Y�h�,C�9�8ǳڦ~�"m�[�M[�nz�i�2��t��V�n���oQ�U���&�X}���d�,�m��7\"Z��g�F8ˬ��rgۑ$y���_��1��yR�Mm@mQ���f�@��u�hz���M�NDt?�F�Z���̤]�a<W� ,��b������������E�}~zs�u����� �'>c'�z>^'�gn-;l]��N��Z0�>z�ܔ��j;qK��^D�����������]!A'+D���1��N��Ό�D�D��/"-�zF��SLr����plzFw�--������R���&����g�yɕΝ�� �m�TjC���*�_�(J��QV�ޑv_>?��Ɏ~eۏ����	�b�����Q�_����}x���|��w����    �wXd+|����o����p㑕ST Og+�D��1�j��6��p�,���ͫ:��<u�A���IlV��$eʿ�"^�;��K)�i�IM[�OJ}x�+Y�-Ѧ�R��nΤ	xk�p��a�t/�8'[ٲ��P��$l`ԓf�i� 
�φ��Ե��"M��s��յ�r�5��g_+\�Z�"�)D!�L�;C��Nif����@C���v��l�Hj9p�~L�� ƩB��l���b�H'��*�V;k�K�Eҙ��	1Ô�i����?q�[F$�#g*t��^�s�CV�>&�l�MN[]�"c�B��a���O� ��h�׻���/S2��S�TD{ͺ����I���4����݃�QI)y����_�v O��1&�qtK��o��l����t�mnP���
�OI�q�ӻ7ځ�U� ���� �W\\�zV���K`3�t؉+Öj���@£�dyQ��6����z���:{�UU+�3x	�����HS�������H�������fGM--��	�
|p@��xz��In�&6_v-��s��h��E�΋�$�N����4�T�ի���!�xPWbSq460�����\����>���v�e�6�|P� �`r�"hŁ�24F��&��к�k�ݼ��6� X2�(�cK�ϐ�:M��O'�|���,��a�K��bjHb��+���(,�H�B�4�H���'�"ͱiϟ�˪�������ٞ�Q�e@Z_z����"߆Qw���&p]�b��y���˯5������8������̉tgBK'�
Ҁ;��Μ�Y��>1q�a��W�.��%��"I��vA�lq=BMW�aC /vD1�\&�Bm�hZD�kL'�� 8LXT������lV|P�1%���4���Z9'��׵)�q��-��ROm�e`�()FA�Q(鰱��T���(.b�b�'bP?\�n�J����
��{�6�k[��Ț�82�6�$SpDM�g�(%ꐇ7:������-`a0�^󉙑�mOt'���o�%I�q�ST��z�-:{���}I4P���d}5Q��(}U8C*]s���c�����ŝ���\�%ã��iM׿�8ݰA	]�]P���Kp|q��M�\wz%
�5Qhǀ`�Ŧ�#bډ�vo��U��5hҥ�JL��O�@Z
�Z�c
��0؈����?6( ��-�NQE�Ѧ4��G��B&J%�L��U�O��<ak��a���҃d|#@�� 	���N���j~�����FE�nζo��ʎ�wd��4�W�KQ� ']����F(�t4��F�k����	p��W�M>�q8�K��#���t�k�ƹjVå�� 'I��8�Z"q}f`b0�tFL1p�$�JC+v��T�\��M2���t��]������ﾾ|T-ܥ���N�,�y���i7DL�ִ���p�t�wwB��I�HS2~f˗Ҷ^CAr��bƕ��YBIl����e��4��ת����բ��բ����+qYs��_�^�ĵ���̺��9&�̸��Я��x�Z6����|�i�'�]h�� tk�d���J�(&�Ĩ�-�X IS=�cB$���E������T��y��r��] ��*��wGF�2�_�R�t,BR�r����0 ��:�I� ��Q3� #�{d���COP��y�ri8�1��d^a
�.�u�����S+����Ǵ	���P��g:�H�R���3����{�;�~g\�\�h�g���i(W&�nY85>iV�R6���=Rҁ/��t���������*~��>��ʲݤ`�d��<�.6$�8er��h�C{�!���Ԡ7�q�����7��s��x����g�]��|m�E��:�t��v
U���� ��B��W�I����Zq 1]�2��c�}��p��Ӧ�Y��e���X��=J�=S�N0|'%��)����A`.5/P/���6�~j�XWB��Z|֊��T���A�Z�4ZfUL>s����;�>���p�v*wp�({��P{��ll��L����� /1̏�E+(퉘s^�%�2�I�SX����-�{��<Y�Vyn�� ��aL�8��'+����w9�I,v�d��>C����?�i�����h�	zB���Iu{h�:	�'�J0�(e�\`��[�$�2z�I�]	�10C���e�X~�DdОM�Ɋۮ��.���#G����{�g��I�w;	֗��q�!65m��_w�g��?�x��K�>N>]��}��]�	Oy <C%�`�dc��.�t[e�k���چlǐ�����c�!�Fb����r즏��nnM��Jkkm�:>�Ù��do�}{��D��0���H�ӱ|M0��Li��7�E��+���ʾ�d����R�z�)cg�(.�5U�>%Љ�S/��t�n3�@O+/�, ��d�,�z��-���s�#�&�f8�݋"����P�nKt0�Ӡ�����������K��������ª�� ��>����0�����??|��^`����oo\��g����Y�����_��=�ݬ}K�`m��������!G��m�:i
qk�'fvst�AB�9�x�8�&7P�G/�_��0�t�z�\B���C�V���1�DS�����
�r9t�o���x��;�Ǣ�f.1�����M_� �V�:��\i�.o���֐��E>(~�
ö��Ic����Ԅ��G�R�;������Lyܝ��w$�t��nK	���O~�鍪�.�dh�|����n��k���}V�,�p�'�W]Q�e����~�����u��fI���b��k�H�n�.:���'ȣ~�u��B���)��O�PA4�JP:�3$�*y$�ܢ(W,o�g�y�b �a��!p�	��!t/�B�Y��_Wr�� �a�G����)�Pg���%(JZ���8e'�+B�u�zKп 	��f�eur&��<������,��[�����(%��h��%�Ժt�s;�f�`��F�cR�P*���`n��.9�萁�\D��Y���{r�oe�X�T�1����@<�s��������1lG{aͺ�D��x`�䖒:U�e�+���
l�b�ߏAE��G��@eV��޹�\���`c� -�41��ȝu�\%������=0����<m1�5^��R�o��3)�F����+�|@��7�3-q�������+�R���(��I�Fj���˯�6�?����.*3g��.�h�5w32�Z 听v
��>^P��֙��J'��������Q���g��ĩ�z��s�g��tX4��6^��L>hN��C�b�ȡ0U�H����f˕�ų0�Fp,�Jw�pT�2���_�		��J�sl*�#;(Y�E��%������t�C�ӧf��.²˖S$�x^��v�VnU}�i4(�v�\L��M���p9���41�$����,'�̋�w,��Q��p��� 9{r��Ķ��h�_���O�Tٵ�r�o0�3�u�s��� 96M��rsg����"X�qSD�5�ʙ���{Ϛ��'$ށ7��ղq��D�2�V� �Gf�(�ZS�+ֈ	p��p�k8���u�P��^8Ҷq�P�2ʬX��[�7)�|�Q!rS�xe9��u͘0ͅŗ��J�yo��aϜ�Y�7:}X,S�L��l8
������S��l�S����y9����/�y{�������ԾH���q3�3�<Fx�=%�u�tb �	�_�}Ulޗ
�!��tyܲP`�N�_ם�Vf?��kGۑ��.�Ff�:辄��&b�� 紝�I^--�����̡�ݯ�>�{����jv C����Y��=v����/8� -"8,0h(K8�e	��D"�鸞��؃�m��-r�Ն���c)�REu��K?Έ��������E���wTR�NՓ����SI��;獩�����LUK����F�Dg���;gJ;��c�_��n�s��`Ԩ�����
�;�X=�ܯ !  ����`+@8.߾}�#3��]v�hL����Jx�1���I	�O�7/߽��e 0u�HE�q9�je�!XF�K=)�
A����J�qy�f}><N8�r�a��� �Q��	�ϫ%|r��fĩ�N���O�M�R�2���K�%���L��EllW�|�dpۯ���b#KTǆ؂�w��s��j�Bd1���ִb'���[�Vp	�>*މ빙�h��n�x�.�U`�9h8���5�A�F�,'�0�D��ځ-C��C}��?�Uؗ��o�sJ��U���CC'D{�����ΖQ,�j7w�a �?ףd�-%vL�^f���|x�3jK��}o��h��R�D��:����.��>��ҧ�E�Kg�xθȨk)�:��\b��z�*]����rQA;���5�8-?��e�Q\Z:Y����yR���6�f�O� Z�����\[��E��G��Kc���a�!��yܮ��S�ZJ��e�/�%0������Ь25��Vjg� ��p�(����f
�;n�dv�d�XH�� a�v�Z�hH2s�c�h�(���$�i����E�n˧��Ygh�O�#�*ʭKᘴ����
��r���������>5D�1����-̷ ���\͗�u�@���c��1g���g��j^%�R�NS���Q;�AI�E���z�i��o�ү`�yE��-�y�-���)������k(���V.�l�$�Nq��ڛ'��{$��=�[�F=q ~P����N̼5D�ؕ�X�zp�(�i�ܖS_�����cP��4��bMN��Z9��,�;A�(ELR��u-�OJ�($P�۱<=��"���R�Y�?&��@SS}8����Ċ�0�U�1���4���斎Lq�a���q5�W�W�)'��L�mF�/˝��d�_�}Q:$Ҷ!f�{Ξk����uJR!х�1�����Õn��È�9tۑNd(c�uS2"s��Y�{*8W4Bhȳ�gk�C}=��l��`S��7�@5����x��� ʼ���-w���I|�~��1|����pb[�梌.S&n	xe���S*� �d���{���K�P��b=�c�}�'�UT�e��k 0$�(gn���Ӥ)�4�Fwu[��,��i�9#���s�6���mSb�f�(F*Y���O�>�����Lt�������=Ia�>��6���d_��ȴ�7��Sʄl4��O�z���GN�@3�v��\��F�����ojv��뻙s���K�l�h���C�A� �.+G�DI͏�	�}��d�F� �>�u:�s'�/+8��ϏV9���m'(��������� �B�B1�4n{L�,�aX��t�_���w�}������O/{�2�k~8��� ��ԋq|:j�	G�����Xd~�CnGNw	]:�-�gZ(�:@���P�m��.V,���>�W�f�d�{p�d��J��c���W��z�����ߗ��αL#Q�)�r��3y�HF�t>5Lm!a�S����}p���cM^u1�Y��dʴ��i���_>���������7�?��r�k"=�
��?�Kv���^R0;�P�1Y���M��QKk�ѥμ]_�sLT�x�������܎��@]� :�R�(6!]=������sD�C���B�+#���]v晨��i��j�vۮQ�M0(r�T}*)*��-џ:SGΏG��"_��_�l���&�P�Vvq�'f,h���wA�o��J����ӛr��z������"é!���
�n�u1�%&�P�s�6��E �GU��$ba�.�KC&6%��z�m��xa�UF�{�h���$�)�:�l��@�}C<�֍���ͣ�[L�X;�'�^��a'����y����w+�x;9�o�@%4B�� �t^����d7�8�=��� �9���c�F����%�m,�4G�L��k�a���"�'g�L�T���ș�`� h��v*r]QwA�c>d�)�![u~*\7�5��
��������b5M��Ǚ�I� Հ<�ɜ�P��i�2$���bݶ�q;��*̠v�AB9:�|��:�Սpl�R�v	�__L����9*6c=i��8�G0�L�Z���|GF(�2���o �k��l���-�R@=��d�kŧ@�A�_heQ��&g]�ѷyy����GW��~1��(�R��>v�$X��z\�WZRS鈓EY�ݚ�L�s
Ƙ	��R�;���������;�Z5@����A�1,�#c�n�~m	:�U`�Q���k��=͐򰝶�=:�(!���E��k�}`+l��-lO}��rS�1����^	�l�ί���dV+O$qŐ�>GsؿXG�2��!	���
E>�1���]P���>���%K�Vq�H�~���!wHiJ9Cg�����7��7�?������}�Ϗ�����;4;Qhv>1���@��M�s�Os�ė{�BU�)��x��(U�i<k8�~���O����s	��Kg�r��܁rѓ��q�B�F	�j��2��(n�m6"C-���L�
�@t8�����-����;��M�PP����)�f��Kρj5�XZʍH�_�̾��.B�?��.�
ـ�e�D �]�k��l�1�w0�ɥE����L���x�B��=N�|�,�_j���)��#�JD $𙾨E�g�_>?����X�J����#>X�q*͸�|����?������Z�}�@��N`�@e�X����A��������O�C��>�����QO��S��t��}��d�1���T�*Q��5�iN��'��]jX� f��l������ɥ�-J:�C�Ң8���嗿���=I@      �   �  x�}��n�0E�o��_�
�@x�iҢF�*��}��պ��U�~}�Ih�Z	t$��W3���`:]�Zdz5�����DY�c����c!���&H�p��(7�b]�2�w��F��ۢ�q��!X��� �-!�y�1oQ ��D ���{[S�^{ۺ�3�٣�Z^' �������_�V ���e
��]��p	�m�C����� �Uo�w��;��X���`ģ<��(��խ�~�=T��Qo,E ��b���N@l�FۚS�W��������e	bo>Ĺ�����9� �j^Ԓ4m
Y�X'ֽ��L�B�V��o��և����_��_�#�F�)�P��2	T0M;4��eߦ�����TN}E���`_�T��u�tFS�훊4�ѹ��b��]{4�Y.EuTB�gcܔ`ԟ�,�ob��      �      x��|mS�:��g�rf`�b��NMl7V�l�/sf�Ȗ����B !��Q��ni����3��i(�!�˺t����E'�����4�/\.���r|p�&q�o��>������_���#�7�������'�_B[��:)��
�y��+%�H�l|8%9����E����V��,FI�q�ᠴ<<�g�u%�c&k�äѰN�	e#���-s�5�G�������+0�B��Y��Q%��f����AUb�M�Q��d+���6˧@�MS��0MY�%�/I>\I_�l��'�:�%��m�����,��S&u���.��R��)���*���̌��Tp��T2�_�E?|id��;J/�žFÁ��J��"��s:+���ف?�����:��Ha��#��ݓX�X�a[μ�I�]�}��ަ��J��:D�{��uɿ�s�c���@Oၩ�,6ޅ�"��vj�����P�A��l`��A�Tfl�P��J�r"z���-Yf�=�.��$�%fC��5��%��(��y9�	D�X��=������d�#���9���t�VyTki�8Z7��	��Z�D!���1��*g]r�z�v�je��R��c�މ���`U
�Ě�>�ׁ����ө�M�`V?��E�>A�+zPǦ���������ɜc���	�Y��~�A�p�O���k�G�2eI�u~���%n�J�7�M 8H8\dL�Ğp�c���,�=}RC0u�eV�5��C���{"�F轅^ʘ
3Vݛ��3pk�1����/��_I����8���1	�;x�#�׸�xVޗÔ�}��r�y�!*��:���Q�Y��F��q$3=k����5s~'�����M
�ު�ZY?J!h��B�u�C����޲�Y�[W���	L�?"��H���`��c�ɇ
��H?�b�� UYO��0^���|���$���~?�~�\�`݄(28&����(3��gC��K��k�ƨ��;��'R�Մ%��H��|���ބ/b�H���A�C+6�[��U��(��3Y��޶	�.��e*��A�K?(DI��Ĵ͵�������v\�c�ʽ��}�A�}��uW��4c��i~���®��O�QQ8���h,:K�@�W�lڕ�z�5I7��6Ӻ���˻�I5ʕ���ʰ��h�q{Ё�VC0�9��<0,>�2���:7���l��Q��'�*�@�qS#�� i�ZӪq)�.�m�6ڱ	ljk�Tk
��Y�\�D31�Bt��Z��9�֙�?�ɮ��W�VJm�v�����pVߎ'�Is�4mo��9~��6�c����D�)|zh�i�l��=�|�pd@�6<`3�0|��TC�ӵ�+t�\'�m����r��y���/|�-W�����<���北Ɍ/����|4�D�K���~{�������q��K~D�8W�Y�@!�W8�=��<��vfn:6�/�&XŰ[�����@�4�*-JX�FA!�^�>�J�F��;�e��#�Y���xn���V�y'�];tjWSQcѺ��mj�blQ��Di�`�F�i1BR�[9�9G��g�C F'�jT��}S���e@��@��;�e�[d��܉��񡼭{z�m��HM̤�:ž�1[5�@�4x���b9�梟B1��j踱�XC�3���B�O�j=�}�e�-kꗁn��MnN*
g`��Q�j���n+j�I��c�n݂��-!�vI�i[����pR α{N�3@��I��f:5�JS�_G��jB1�>6
~!��YS�I?ߥ����٦|\�螣���!Oy�Svф4�>Mz�_ył�3�Ee"�"�2�^��C�/q�Q�C�X${	̬*�\"rh�.-���+m�#���f0c���4�*�7D�1�E�ʩ}P��/pp���uG\a�nWXN��*�#h��â	��"�@`���2Ֆ�& ؽ�t���Q��>N���h}���?@�D�;���6�$�&9���B�Pn����Wa66f΄ �˫ZL���^͘_�r�8(JΫ!��7��Bt�e'���� /$�����.t��b
�y���V���{!���o�8-y`ƺ��E&Y6��T0m�T��\��%#?���ă��ݚ���4���Q� zɃ`'���Qq��//+�")��վY�(��~��4R�_d�r��_�����D?$�� Əǎ��K��c�[��(���۳��h��Ð�|�7����˯��],W�@N��$8�)���t���!O|.S\� ��ΊŻҩ�
D�l>@|��3��.�$���,�!��P�,��t�P�/�e�Dm����!�L�ДH�&܃l�=�F�h������H�d�	�������i���!�NBDH�VQEՈZnP]��!°j�Ť%6l+][�ml�x
P
�yZ��H[��5�5Cu��=�ww���*~c_Th�m�=^=9���_5C{{��\o����s��ȴ�-�q��Sd��穷����9��$ԉ��|��T˼&���)?84���?��i\�����(�r�MDĨ�T�sȼ��!� ��V8*��z
�s������a��zѱ-@Ld�) ���/�0|��5=�7�1f&�8�NG�4 ~�'%��GƘI%�f��e�39���1L�`��3����m�蟕o=�k~�	�I���+~��i�Q���>A,x��i�m�e�1�y>��Sd��=��'�f���*E��3����ȆY�H,��tf �Ff�ǣu�z�}ˀXީ<ڜ m<5l,Վ6)�VT=7ipC\���պ �o���[���a
�9��-c�
�}r�uˆ�_Zn�N�����Φ͟9�O���h�?n���M��\ϵ`�2(����h{v/Cy%�!`EDz$��
��,����M�L\oe��+�?	�����Z����.��)�,z���Ή���l�A����\?9��On��2κ+6tm����39{Vf��u�*/�?-�b�X W�,eX
1��l�J9�`�m�F�S%W��2L��ǩ��0�����A���X�#�����&W�9�����|���V�o#���,Y�%��!��h�
T��dp*%�E����#��G�k���Y�[����и�-�F�~B����xm��t�f](�_���"bp�|=?q,L���"b�
a�?��>�q�6:>O���#�V���fz�G�Y.�F��LVb�,����Ձ�ԏ.���C���ᘇSW�,�z�|�`'*+�tY����y"|�������(�k�N%^��)�;��t�b�ާ�p��e�2#��'���U��Z,{��e[i��،�Z�z�ȼ�Kyk-�ɵ��q���x㽃��s�]�X���l��! �����U��S�h]����5�������0��s�VY�V�O}�v˅�7��-6H�6��:0"���*�,ї�4W�|���NT�2�Z��y���2��H񉶑c���R���T��7Tc�j���Z�Z#�۶�"����q?��7%1I:�9Ag�R��{5���v{����(�6��n[�ڵU���%�Ɩ��J�ncD=%��4�e��kMm���i�K��쨛"p��s�>�"F�w��^m��]�BB�Sc�^��k�������3$L���o͊y*�>�aVn�Y,�x5��\�\���Yt/FJ<ݖP�+���K���M���Ci�;�&&�w|��.+�H4�Ұ˔x�F�~/ �<�	0�\Gi�j ��]#6�EJ�5�*��D�6�Y�������s��!8�k�����0��ye�W]uh�:�rj�4M�66�A�fY��Y&��XUS۰�f��֬�w�J�1=3�u(}wW	9A�P㪁�!�~\���$X3>�xX�����dƠ�_Z1����Бg���}��\�5�Y`���\2.CW�l�p�f&FU�8g(	�^���2
&���̍�,7&�¦����8��Ue�t�m�P�n��(D�[�50�_+D	t��gV'��9���=sj�b�> �  q�wK�q��҆����66���v(RaH��k�)t��6?�n�cpN���6�;v��k��}4�E�<�n�i����8hu�Ae��r	R��j+�[쪶-�MS�T���>�#�3��� ˅�S�+�1F|Pa���������-CGV#�h���j�]4#˪�����9�ʤ��y� cko����A��.ɢM
n�d$���b_�h��_Z|�����Y��w��B��	&4"V{<݀Nc��¦u�eSm
A�,j�  ��"])�������b̤q�Cz-ǥ�{5�c�����1�ܶ?���)��!˻�sa�@W��,9h���h{�?���O�^g�Q׽�I�)U��D�F}�����"��Z��Bp�B{��ha4�瓵�!kf���FV�L��*���#P����ϧX���N��Sζ��}���:�rL�~�<s!qM�~P����}ŏ�}=r eL��ğ`�g�y����><R
�ƞWi�-	c�M@;Ġ������Բ��T&e}�3����xd0��k����;i T�e���6%�&�%�k�)H*J1m��m(PV�ՑQme��]��/��)��s@ΰ!�'���p��Qm�!Sm�]�q_ѩ6vS;
!PE���Ԯ[j����6�Z0�D�m��oP��S��gn��Z�;����;jC]���2���֚�F;�	o��j�!~#JKSc[�.D�����Q�b�	E��}��^	X?�L�`�\Z�J)�4�A�lc�[ZU��D5���"Ǥ��w;j�`(��xoG�W��.9�ŧ�[rZ/.��$'�E_F�:��x���n|�E��J���!�2}	���u��y���S]�C9S��l��U��Q��7�-��{��r�H�P΃A�`��{�"v��=H��~�嚁���x�pJ��a��߁h�>6��Q^�T�x���V=K�a`��'���ifd���Ƹ�a�\�@	w_��R�[X�p�ʤU�[��A��``��ّq&(�݅
˙&.!���
T��;���
DB����?	�,�/��}p�ѨG��p�������N]��0ԟ�Ѷ��n� �$#m��4�o~zJ ��L���-�d��d^o+��U�)�^(�_�y�gi�ƩB -�m�: 9�Q�v0p�U���P���B!���$~!�) G�`9��2�k��9��lo�wR�c�7eX��J�چG+�N���N-G7�J[���Fm�4�jND�"���  <Z:�6w�N�"H���v�_����ڡ��q�&�)�\�ԪisJ\�����[C��	B�W;�bl��z�	
^o׻D�
���������D��b^��
���v���מ�`��
����v��6��nǬ�
�64������Aw��!)��/w���]a�!3�d�������EO�����[�HG���pi�P�R>�`��h��=.��m�s{i>��(��hn�ˍ &	d�ڈ ��<�_̸T3����'�4�V�2i�}�=����Gi�O@��;_j�=R;�s�B�b%��[띥Y��̽�!��!�1mD�2�H@E��v���hQo�\nt���V,�(g��a3��� l��c*���>��@�����qb�6�{��xz�Xe:�rW8�c}YJ��K�` ���|�F�g;��}�eӪ��k�){d�����r�=.|��h/$���J@ӱ.L�r�7����I_I��o9,_η�=�������~����o���q�G�ʤAɳ�a)���^OE��^����7�e�h�_�C�VV���Lzh��i����5Q�}�W ! �#��ȭo#9�fܙ%Y�jӕYO�z6����<��3�r>��ePz]c�),��ȇ��?�{���x��̻6	����]-��50�6<��d�R6k������_�|yk�ݚP#v+rj�=յݾ(�6�%�����F7�4f��5l\|<��æ��*�^�G*��bDn�ͱDT����˰�e8�R�0<�5�S}4���A�����
��:���ODp�}�^�up�KM�Xo$Th{��miq���K�6?�?^����m����<ܫ�������L�i�>���!@�M�s��#bEr~�E�]�㽠�ЌP9�b�%�,�V#���������8��
���P���c9J�>��J�5���N�sq�Aˈ�I��~���+\?�&���
��IHUhC�VƋ�k������nm�¶��ui�F7@��������}�����6�l�X�|-�!�a�q᫒��.��P�����_����      )   �   x����n�0E����4���]�v������<���I@
j�M�n���+ۏ��qUuJ�_�����c:gڢ"���t�*r)��
����e�m���$�u ��HZ9�����d}	�N!itb	_h���T|7����+Xk�4}N��#�{xC�,���ؖ ���ʲ�no@#���6�8��(�u�j�=l{����ӼB�����o�[Yܵm����J\_��ρ�2;z��)��"�m�      3      x���O�丑��Y�����e�lƺM���N�?� $�����$K���'�ϳ�,Y�7����m�
|�\
��J����W���Oc�/����?�$��L�������w�7�?��?�bp��O��������5 ��K!���;zM�Ė�ɖ���a'Eذ'��G�	��%��N����[��ې�$oIv6߇mL������_�ŴY�K6+���@:������Wn��-��ٗ��J-|���+k~�t4G��Ӷ�uo4�f�WN1ٴ��;5�h���R�a��!Iwj��Q|;�cq��$6�x�e�r���P�}�:R/o�u�[77jۨ5�oz\���LO~�����M=h4����0�����+�-��TLܛ���>�p�7���8��J���õd^c|�~�:��6X�P�E��j�����G��fc�?��������?�����Am����g�Tg a%�#����p��6�3w���{]�lΓ�KIhҳ�C��c(ί$�I�#B�]7E��]��dl1q�������[��&��mץ���!IM�oh������?�^�o����J:����r�wx/B(���6]��]�b�������k�Pǁ�>�v}W�Fo��%�ǈ�7�=��������1s2�)b�oקw�.t�D��ԇQ?�e+e�g��&��v{ju�b��n�����D�@4o�h��^����j�	+I�Kv~7���u�).�$��Ɉ��\j)��M��&�n񞘻<��].����?�)Iw��\ o�~��̧$�%�d$�9'��]����Mx�TG+��S��r�$~����Z�[��t��b�E��rj3�$��I�VR]�1����d�?.��'��g�򐤻\4����1c�)IwɮB\�n�$E��E��e����?$��I��h�1[�+o򒤻�Lh��M�VPW�$�.�٪Kh�i��Ơ{IR��� �W�]7X�3_��`M��gz~b.Ijr�`����Ez��$$�w�luion�{\4�{���&B#�%	M�{Z.�׍���$<�U��S�P���9%�.�IH·��)�����d�,�}�T����k�:	3+�_�goM����m��uݺN�ή$�I~���m��u�:m̄��)	m��uy�}�Ũ��%�K�W��j��@��S?�	�֩�&��X��c�V'J�.��}}��Ȫ��{�j��-E�^�����h����k�+IwQ���+ۂ+[�dzޗ��;�⾿�58W�X��|,Iw!U�	tg�|��AR�m�&�<�������q%�q�)?T,���2�S��S�HS��%�M��m�n[�u���6=��7��|��j6d]�E3K��3}�'�{����dd[6�C�V�>��F[��N�R�AG���*��r�#G�)��NF�'[�<����a'M�葆��~|�%u�9(�(���B腼$u���۰#��VGr���%��n��g��M1�~�+�����T]0�ߩ��sq���{���\�ۘs\IGk���h��B9g��C}~�sJb�����Gw�H�n���F�GȆMp+I�8*�g�""0m���0����5a;�f�-�YBF��%��VL�s�1{���U7�$��g5h�g@�H��8�$=��~�Дȑ�$��u@b��9��;$�q�)1� �u����,����+�q��$�p��$6�X�{��N���?�D�~�C��D�#wI���uKZ�+[?|l�$���0�TG�s�D��t���8�I7��%��.�Jb~�B����FX�a��y�Z�~O~�Ao��K�#��H �{��N��mdT$���[�m�_t�ٌw�#Ps' H�ƭ�4K�,$����>5oK��Mi%Q�~�l2��p�tޜ������j�{_�Lʙ�Jz �Π�C�&Qc|���]��>t���1tS:p�3}pf)} O� O��Ku��W�M�uө㷻����O~%=�mFm>�\I�{�ζO�Bz �Oޔu��������"I}����]z�G�t�����n{���ǻ��w0�7�_�u
~I�8G|Jf_1�a������'�U���S��06M��A��������r
'�OI�֯��@��7��S��dgeu*��?K]�qS�]矋����zR(��-Βx�hq�R�T
s�hWēD�ԣ�t�R�0�A҃ ���E)�H�$}B]7�>�ܘ����M�ǭ�����F)$ȹ�=�8�n(��vF!Yй/E��Hb������C�ǭ�.2C(����,I��O@_8���$xa�H����BQ��$��6�TLO(��`>�����P (3��o0��%}�Ev��E�/�?Kz|A�Pw���-�:�\Jz@�I<�L-KI�h�����(�dP'�$}�0'���#-� ������iGvc��$���������B��f��y=�X���m�����ԫ�HZ�ڒ�1�X���!=�v/���䇥��W����PG��܈����{0��/�~�H7$fIdGV�fG���)gI"s���7Z���0m�x����g�z��y�oO̒�(�0����<�k����EB>tЅ5�M�����^1@:س��󯃱?���w ���K���@��US� ��R�q���v���������J�����O�����c����l����YчTa'Կ�-����\տ;F�]ެ�����<~���G�F���v�| ��_I���k�u��;��
��ޒ�T�("�swxL�a&IO*~�l�#��G뗒�0Tlf�i�|�?���ZEs���1G�X���X�f0�!mq�+�)����������Ds�E��)]a�C	�E�� �d�F{I$y6bu8��$���Y[ñr%q��!�i���/кW�}�o��F��ƮNi̅�co��]9c�C��$�N�e�u�vR�L��"��*]��3��6Ilt�z��f3ӳ$5��M�ho�ո���S�PW��4�ɘM��I�1�&-فn�H�]ZI��aG^���� �~�۾Pu�_(��/��&���"�ӝ��8Ro� �p9#�r�������KR�G�OR�pf`��|q��N�\����y��&3��$����t���K��=�:Hfŏ�D؈%�v�w%I��j���윱L6�Ĕ������4���/?ӵa�Ӏ���	Η�tΊ��o }�3��n�'�����>�Z���4�H䁣�NG떒>n�:��DV�tT�� P����*nhKS{q(~v��%=:�s�A��K�_�#�/*P-��!U<2=zKzxJ��PB*���(�$�S����uRf�B{I���f:�EH��ܩ�$xjq�r��.gAgIO!i�H��h�or&��[c4a�������~�K��S[�p_���j��[��8L!y����,�/a��#[�v�{%��)�+B��٠��𔆰��4ik;�u�$=<U��ӷ�T���Zڨ���J�/>�����0���zϬ���X�Pc�ޤ��8���V��%�L���O�|L{��M�p�����Jz z�J��x�+�F.�s=P��d~W�pD�8>/��"�{ʋ���h0��%	-ˋF�B�NxL����!=�_8��%�����9�n��
����n����)ƕ"a{��*x�.�-��=�l.��M�xD56�g��Sz p�z=�58�;��ۥ�7<RG�R��L��Ǹ��xV��:rj�(� T� �4[i!�ǚ�hrv�wH�bj3����&�N�tO�rf�r���9t�$t/�P��\6�B���%��?���g�A����Mn��7�m�og[1h<�,���%[�#�%�yA��y/����P)e��a+X�J+7*�UsB֐��'5t�g���}	�oIOj2l�#�\:�,��ފd0�X��:>$S�g��?�6�,���C8%�\U3�ƅ���-#I���� ﹺZgaBsA�xoE2,b���$a���L��i�Ҏ�/%�Q�}������J#)����὆"�X��HF.�sȔ�ɬ��p��{�3��a��    K��هk�v0Տ�?(��|��cFF���>����T�ڗs[I�MJC�迚E�Z�'��E{��$��e%�s����! �,eIj�����k��YOD� I���N�����)R��pL��������D٭��.\�y\8�$���W,0	-S�6g��M�в!1�eo����z��S�=i�P<��z)z�M�\���,��<�I�
c
��\ޒ���$=��*���N��n*�3q.fuN�*�]�vS�L�7/ ���>n̙�޽Sq����n��$Ho���h�rU�$Az��=S�5봥�'�4u����^�l�vJ��5�]�e��s(�KғgΏ��bgIO���F��͕�(��ak�D��.����� �Pfd�↳����4�_g ?Pq��(�*/�	`N�U��1#�J������W�_W�F�v�&�N��?��r�;��o]�k��Ҭ����9��D���Gt��-	?�S����n3z_g��K"��ߨ�k:�+־б�@�1�fguo4�����ۊ��x)`0*�ģ�v��ҟ����,�ĢB]E��J�\E�D�z5H'����wTP�3k�Z68��9�WY�A?��UiΕk��`T/gB�5ouuX xtI�2;���.�l����h���>�����0�P<�t4��w�<Y6�q�K�Eu$ߒ��Ke��|���WJ�͒�Q����v�z!��-�AU�葶����;$}ؚ���\g�Sd������f+�DL��i����^Q~�k%_8��Dhh��`���RcKIjt��Ř]Q!�=9$��kU8����7���D~gA{�
��uoIBi�3-��a41�%�ka鳂�U�l%�]���e1�R����J�s�p]�W.�&���F}��F�O9�;=%���E�EcNw�&I���o~b�t���mT ���$�;�q[��[�� ���`���&�}IJR�@��~kY�ռ��7��l�u&����Ҟ�,Q.;!DM]����Nzc�-g_2j�&�W�1��.�m�NI�\x�&����u6��=�9H���+J~���Bz�KM]3���M�rYJ�5_E��:E&���L�,=�o���{B?�s쮫����/��ڡ6��/�]J�Ae~��gWn{�9��I�$6�O~(�m�h�C��ׅ�Tpt��a�X�i$~��>/�I���^4�=/�)N�� Im.�`���k�Z�Ȓŗarp<.�֕sm�^��\��a!�:��L�rI��Z�ǁ7S/���%Im��o��o���H�,�y+v�8�S��g)OIJ.��:?u1`o�$�?���Y�$��=0y�C�ҟ�"�Y��.��qHR�|/r�Lp&�%ɾ`щ��u�n83KR��������Q����"���l�j��ٻ$��2�`n&%*KIL����R@�f��wa0(=��U�lt?bl�]N�Ye��M�+e�?�+ooCa�?�̛>�*-�=����ԯ[���P�?�G�7��zB��Kz�(Pe[�Z��,A�Kz pE������t�Yݝ�]�e���¼��������_���?�5I�3�� ͡r� �5�p��.=�Ƣ_D�WL�a)=�
�I�氦%GV������)9-%CY���=�~+R��;�$6�O{�` \J}g,�$��7��aufOV{Kz����E\�nP벽=��<�C�:y��,`.I��((��=M3J���na����+o�%Zd���Ƹ�7싆�5�ۆ�Y�P��LM�Cٗ��Ktn \�!bRD��p�/�%���%�х�\E�eO3P�@��k~.��-a(M$	B��#��|3��I�7i��L�!��$l'�oN�F%k�R� X���\v�F%������e��J�g�> �N-%�d��r�m�.Iʿ��~�`�k����$���$�m֙�\�g����ʭ�Aڒ���IB�?�[��Lf��S�5�,C����I������R�5K�.
�8���28%�:;oI���R��ӟ^��"Õ<�惤w�P]�S��EF�$N{I�s(���? �������j��w�2ÇI�Y)��U^%��\���'K�Aһg��J�d �.;�Q���$Ɓ�@���PA�O�����6yǅcs��$1���!̏����zIj��G!߁F�$SPY�KR���*�\�?������ M��S���JϞϒ>l�D���V �t��@��mh <z��vV��Y��mhpX+_���%��ּ�]r���a߾$}ؚ"f���Q��e�$�K����M��K��J�KI�e�0�rI�d�R[Hy`�⫽ܑ�ň�8g�Cz�����x�ґ���~)=�gk
,���b_?���$ьiEb"�5fI,ƴj�a��c��$�rQ�2�b"�p��"q�+������aOI������fsb��)�������+7ږ��Il��D>3�5ı�M�_~K��UV�'?�C�$6��TC��57΄��Kz SQV��w��Ł� e��$	.i����)=��pqm;����]��������]�����$P��-sE���u?h�h��C�v�DIec�q�%8\?�$p'�� 9�Ҏc'�^:%����ɲ�VV��$6�n�e�c�D���7Io��	_�c�OIvZgItYY�0�)m�ΰ#�$VZ�{f|;�b!�����
�`����fV$�ce`� "���z@�0�����6غΒ�u�@c�S�{X7����h��ƚK��%)������훰5s,k�)`�4H����$���0~6�$&���c�lp9pH"��(:�g�<��$n0�*@u��{�*�����@V^rE7Ë7��J�$�x[X�p><�0��)I��j�5�زwL(=�����>`g�sjǖ��CYJ`ge��A(Ϸ��3{߇��yH��P�Ȳ�	h�e���%�3M�:�$As<�L�^�VW�e*]3H4����}��-x�Ů��@ZA�zn#��(a��1K�T�&����R+҆�K�#m�%̈́�Y�i��̒iS�o�뷈bdh�C�#m�\qjn���n5H��5;Y'�Wݧ<�ヤ��T���D)�۠6U?��Ot��%��$f�SE�EV��$	��.f*�xRd�$�/�$C�U���s�42س�̲akM�~gH갃�ԲEfa��P�x�xr��ul�|��[C��^{�)�ק���Y�.�Q�m�h�4KzNKS�+ �1d9��/Iv���:p�4�Ma�C��e�(���z�s|_�H"���K�K\��YJӲ���oYML��������1�X.�F@��\�B��VB�1uJ"Ѳ�K��%]W	�a��D�I~A�3�e4q�D�e�Ou\	ÞĬ<@��J(�4pؚ53t���We�a���Ĕ9�e� Z4��P�a+�{)�,��Q�ZID��.=���O� j�:v�1��W��J`y��/!GqI�,�-ޚ��cQ�C�o�u&�-��@,H4]���J�a�Ӡ`|�DFcqd+3������{�`4
��Ro��xNIl�����0�z�8$	�X�w���L4�i/�ef���h����,��򰏵�Aw�9@rJb&{u�i���x�,�����}WB�;����maK��P���~�x4��p�s�%ͯ����WKҘ�\���V#�&=�]����CG&����̡�Cz �O�9xs�="n��2����,?����Y�Y|�k*몛Y����ZX�3�����UxOIlt�m���p�I<��#�/�B2Z���ّS� �x����\��T�M� �E����K�ɿO�B�",�����i�� F�U�6�[J�jFjGַ̽ʍ+	=���/i��%�����唨)���N���G��_��"sw�98�zW)"åK���W)�ʱu��&`D�$D�9i�.�9��Je�$Df��i��@\�Y$������w ƁwAlpq��2����R�*,|J<Bb3�rxKzF�8x\��E��(�ʷgz-/���{ 0  I���|{��?y�Bx.I���\���;��e�I��'�λD�R2Mң0*�����\}���S�P���`���	���)I(�bki��N���l��K
��C3�sh�K2���Ga4���i�K��fI��
� /ֻ�¾$=Ub5T	�v��E����*!M�شȓ��M�NI��򨓄�P���$=��$1<u�l\,���!�a�+x�ŠnIO�0
o+�X�ĐM氊]�f��j��o���:�����!�p�!-t�m&w�C�#F_����[x��������ee�{y/���JIB��[0���w/�d��h��@5%�kV�o�F�*[?lC^*~6e�ysI`@*������\������ ��ko]���jo���Td0.��IU	*��Z���y�]���xX�����Cy R�����f�3m^�a�F���.uB�Fr\~�P�8�m#�υ-���]�~�g?��x�%���XY2��%=0K�a��R=��J�z�Pz ��B!�	��:�.�x4��&_}<ƉZ��7�DiW8F��x6���2�����q}j9���?�Z�'�?�n�q�x������^���a�,R~����OG�� ���(nJ���3^� �Q<D��:�B��L�r��9��2��_U=*�3qo�!��Vt6%3��������c$p~ȕw}(=Q�^;�["f���4�ؼ��Je���W����)鷯H�ap�b��@�_��_X�N�.��Kz�������&e�����Лy��r�h!rI`����pK������/�0���{_
 �FbaY�Ӕ���l�kz\U�>�0��#&4�T�}�	J,a�_�D0D�|d�E��@�,ap�1�K�ϋ��ˎ�&1K�Cz`���~�4�2Q���8�]����:es�]�4�%�7z�����y�8<ʝ�lX� q_�f�>`�0��9 5����� �M���������'axe���[FC��n����أ����M�j.��{�<NtI,ܴ[�u郿�>�T�5�.�Eo��:��]�3�����)9(=�p�/�1��:WE�w��������}^���i =���\���<��qg����M��wc21S�C�`^�4�M�5c�<����Y��b�xx�\;3�8%��Y��dJ����ө�c��+�Ys������U�s~��ow)8fNtHO��N����|���~����.���f6��ks����.�S���`sΉy��tF?9�� z�nſ������t��      �   �   x�Uλ�0���D�{D��t��]L1�RI��-�O������^yg
>�@S�3�jReg?�B�����	���e\B���⯮ҼP�p�pdz开���LY�p@���)���$�78�<��-S	{��IN'kfƘ7�!C      �      x��]ˎ�:n���̃c�/=�#�=ɠ��I'2�߇�wm˒-����(��u�HI�(iI�D_�~�����y�B�q$��?�������/	_��o�n?��o�%-��C�������?�����P��2�����7��	�d$z;��(*��P�^S���{�������ȷ�2^� �G�ڟG ��I[���Ͳg<D��oL�$+R����[�/�o�o�k (#�(N���U&�!�!',�	��CÂG����;��t��8���Z��{�u��Ͽ����~�~}g�6ri�ӷ�
����&����$U�⯐�%|c��+!�DG�L�G\O��7�o�5��y(�}��Q���sq�����H3�s!n�k����DG�<�PX�U&d�QJ�Кp�q����2�>Y�5(�HT�<���u�tL�ѥ�8�F��k��ң���L��G�s�?Ņ��F��RaD����t(-��6�5[g�w�����S�M4�q�AZN"�\@ean�i��U����j�%=�pX���C�i%$+d�(�iXC��6	w�5���˸p>�꤭Y���d�q$r̀��VX�+:ܠ��@��e��k�vL9c� :D���V~c\)C8�;X��JY���s�}Eu�x�ɋP��r�1d���h��H�7� ,�g���^t䨉Y^�ҙ��XG0P�i$�����6��Z���B/:��g$\$��U'Yˆ�����3/��C��\�r�g�^��3@���kcX%sI]բ*���0����nְ�5��z{y�U��~�-b���N���x�Kl�U��κ���(9��f¨,��׽�L�W�Q-:P�XȆ%��U���J�W�P�Z��c�L���jsd�#�kҋ���k�Ϩ�@����"�;��7��@��s�]41�&�.(�5A3PU@�B-К�1B��p�鄖t$f�Mm�$i$��7�8�T)�wb�jA�n�����X�ĭ6�Z-kB��������d���e%F(4��s�K�TY�l�f��P�YC'Yr���9��ȳFKq��*+�,F�*^�\�cJK�F�F�٦��$r�)/���Hj[�$�,jRYr�<V��C)�éE��,�2օ� ġ�J>�C!Òc�M3�N�\�db�˸�i8h�Y���r��[�%�	���!@h��$�3/��zU�y9pLԎ��輡�$K9g���W(�G����).M<ҷ��N�H��Ht��3}���ڍ6Q�u��|m��f
0�����[W+��,�����J=Y�4�4��6!ɩ�?��(a)-,&�wr���p<=�]`i��(چTJ\F"WaYp)�ܡ%P�z�\F"W�Rh)�Ѧ?O1���%��YKe�G���hC�eר�Ɇ���,��u����֎��ȇ��z��ex�>GB��-��`����S��i��H�m�_Vmm[�tB�<��,���>�Q}Y�x_l�=a;�flR���ez<�HW����d�Ԛ�5���M2����f��%�7K����7�$��,���<3�Ęt�W8���!�ձ��[���ޣځl����"�j��c-uHZ���^����;��P���Ac��!X�:7�m{fŘ �������!��$h��ɶܥ��uŘN�g[���`/L����&l3��� �Ќ��O��rM?����
�8�����t ]m���-���&�dN��݉��s`��-��V�6�δ�� ٣��\4����ҀXШ	Z3���KQ]|=63E�&84>����Lc�ѣE��G(P����6=�Lǆ��X+%�G(T�*�ц=�A���%�D�ࡉ�cE*���q(vH��5�i7-�w�>�S9U�����z^j7)��m݋�̢3Z�|���b�nK] �3�D���
u�����8A�9�O��o�� ^9H�4yvܵ�)��,rB>1�z��L{I�Z�u���l���^����NR�ܪۋǒIp$�F/�F�.�W&��=�g$^
�:�F��6�IT��g$�]:�n�N`y՘9e�^��D�:;�)k`
G"עZ;I���W��r��u�$r�i/)ԅ>�kօvעcF����/�F�$]e�TBu���4x������j��M4"'QR��r�/[%�"�0�Fi�Rgz�\jy��x9G��/�^��5!�|a�!r�
��t��IL��ƭ��Q�E�=�~�f٥>���m�L���=8��A:��8��xR6O��� �j��b{p4�rn�M��=ͭRm����m��|_�f9�\�I�M	ҒOgI��iɧ��]�Wq:e��]���e��]�N�2d�D��ch�M�v=8��b�<�%�zpt\ǖy:������;e��]��OM�q1v=8?5����u��FOC�e�zPtL���:����蜐:��$׃�sB���,\��Nuz�#�zp4vRˁ�%�zp�*אi;yp4vR�X���:pD��'qNRp=8:���;����X�v�3ſ��h��V��փ�Q�/�M�o=8����Nro=8���;Ž��h��;I���h��6�g����Fi�8���[�Fi���No=8��B��փc�a;e��[����I֭g��?5�E��¹�ܞx�.ҭ��4~ʧ�[N��y�1C�HB�[ik~��i�Ա{�\qjgp>�,߁l��(�;:ܴx��*�J�/]5����!u`H�+8��FX�c`_�i:�;a�D�UN����l�?h�^+&:$�%�qr�m�f�r�[>r��?�I!�j;�L��\@Q�h���̜Ek��$~�5l���+$M�)H=��Ri����uO�ZBmy���u�XeHP�<8�P;��$w݃�	���3K]���C���e�{p��F�2�89(NK�e�{p@q:��q݃���q�'y�R�!7} ���M3K[�����<k݃gHL�<8IqJ�l�����\ -������< gU�uN�< �(���{P4@�k�����L -|�����L --{�����L �Q6�A��h&���?�@��h�BKޟ�{p4�T�?�܃�QZﴺx��Q��z���{������yZ�g�c�|J��c8C��@�9�
TQ�|�`h����;Iv�Gm?�҂]@:���N��]@�LZm��`�fӆ�4�vi��:;�vi�fn�Mҁ]@ZZ��ڦ��. {go���<@��e��2�]@G-3v����GZ��,��+�h����4`;�gY�. Xi飳$`��t��I�H�H�4߁�E�ӉOZR�,���+��)��Ȯ�u��I����	;E�ui��6����[2�,���?%���H'�X���Mc ��?r5�I��ks�t���r*��]g�$��%�RC��`�#�A�c��\Ҵ�H�K�NJ��
�}��t����}]V(E�����&�z�X�>��j��������i�(�!բӕ�S�4�#��ۍg�Ц����ҭ��D�:�mM+�"�$ߋ\��D�P�!T=�'�2�Cn������X��8�E3}E�����HN�|��$ݨ�U��K�������kU�o��Es���9�mF��)�:vO��"��Z�ZU�ȇ�/b@�hܗ��e q]�d-���ރ�r�`��1v�s����K���)k���C$�KԵO�s��5j-�|XK�j�ч�rɀ�*;�^W�C����^�"�\R �	�^ԠP|,Ԥ�g扞#)��9X��&�9����A;��3�t����:�V���x9��B��h9��sD�
q-9�đȗ���/�C$��6 ��ً�+H|i!�$�Y�;C�2�w��D�ϥ�!����"y\ڀ���N�8��;j��UI-�K7�&�\.�BtpA^��ib���T�P��՛I{������V��C��e�u�Ӥ�����u�!&�5�ĝ{��;������ef�m� �4 �hKv�D༬�Awm�TN����U���F��-�G��=Р��c-*���#���5^^'� ]�9o}2$iԑ]�Y�P�   �*�D�d���'�
!�����k��:"޶uA�K�*��&ڐOjS�Ц����"<��]�������G�DvoL�MW��M�3�I���D�p�m��D��T֢/I*y$:-��w������M�����T��v<�g��ܤiFI��3�$E�]��i����g�C�����K�i�m3�I�ŵFk����ݝ輳���LEm�ͤMU	�-O&i�2�LjR(m�b{�%��*�w>l�k�
�/���7���s�T$<�[�8�Z�q,X�-���� NN+��d�?2DT��kQ�u�o��p�D�qJ)�>_�"Wِ�B>D:\�^L�����vm8&�.��"�� ���!��T�Yy�A��'�R���N�z����D�<�P����wy]1��9n��It���~*�3�k��Qp���Jk��"��
����l�І�'5�&�����F}=QZG���n`�k�����A8,o_)3��k��0HO�Uv��A���fo���Nτ���n�ƚ�����ۚrc�ZSf�Z6[���T�q����H�m���ӻ9X���n�8wB�V������b�^��M�=W���������>�-�-�[���1�^-<{�X�ȡ棟�an5�Ը�o��1H�y$:��ά����q!��J���m)d�s[/r}�"+Tg�$��'���dL�r�Tk��HTe���C���>���x.=�O2�*ԟ5D,[ 1&�6��v�栧Y-���ߥG��J�m��QgJ�Vt�I]S�Mz?�[m�3@4�\r��&���L����-��d�|)�C���]�܀J���w�*(��ȕ��K�lW�Xe]t�\��%��k�J	r��5w4��0_ϫqZsD�8M���:���Ʃ��^t͵��� �m��|5��ù
�׬r�:�")#QM�����ᨻ\UގouZuю�ꪢ�Z�{�?%����x�)C�V]�؉)�.
߉\����ޚ� �2jo�2$i��g�����T�]
��:�JN)R:?{��6E9�c���^B�Zf&�i2�PUOɫ���1�4��Y��?D��)��а2�&��ٖ(�u����,��`_�f�і��H47���uYy$�L}�c�m(�PiDU�+#�~p�ź��$�'�����`�7�J����E���T�v����tN�恑h�N)����o���w$�Lo�r�,�z����eay��p��p����Q�y��t��"uً&3B�٥*7��0��v��;����H�T[~�cr'�R��sۍ����e�1 �*��s� �]�!�D�kiC_^� ��wnn�y^@wF�eh�s~FA�֦!g�.����lw��^�Yc��#ѤK�>�.��ħ�`/�v�[]VHЪ��+c��]Q���#|��2юhFw#�=8t ��cOʐ.�2䶏N��>�7е6{���mx�&=:����: �8U��H�@m���T���ᝨ.O@�hc� d�������+�`��q���q������$���yt ���VĲ&
���'��3��.� h3î-K �ڮUs+��݁t�Ŧj�O�%�D�.�7^j�9_��M�D�6���q:�jQ��(���/�i͖C�l-�<�Ѹ;����m�v�IkW�w�z�d��a�;е6.��R�U.1\:����CE�ދ�/@�ݴ������~:��rZ���Ϥ���â�սYTZX��W�Pmq]�\�����!��Vq5N���f��q{`����p��)j~h����[�Iu�ul1����B�����>���iCj��=�j�~�<��h�'ô%jG��ΆM4�S a�@�!�����������,���"uQ��T��>�5�K�D��M�"0�q$�>w����+�a"�q�t�_����9�Pm\�N�R�q�{�a�u�n����/a�V9U.��7Y�mS7uW6��YqS�))�"�Ņh�d�鏸0��&+�
��I_�g����>oO"�"/@�?o_J��vup�ml��1/jOv�#�����R�z����~g�m�Aob��c`[Jٗ4%�D����}꿿"����D�C��ȕ����
��H��\"��\/EsE���Ex\9kӂK��O���dpP�WP��=t�)���u'���g�Թ_�C�ze��;ҩ���5/�7Y�~��C�U���M����`��8u�T�Zm"�Mq��m��g�"����Er~h`߼�/nJ���S�sN�k��a#���Q#T۶7[��nOײv��8;_R�w~*�b���<�y�(��Y��5�v��I���|)`�Fdϋ����\�}�DM�1��8C�K���q�!C['DC���sg�ȗ]t����ɝ�J}�]��(=�I4������j������H�V���}I�h(���&��?D���T����v�R֘!���KQ]�Ti��K�Ma*퀮�R��&�;�t�����H��#�+��Nl��Er�d@�jc[���Nٗ"�A���{��]h#�F��� x)򼕢s�"��\.�Vgmyc�㪪�H�y�1*~��_�Ӧ�P���b�m-r%GL����I�m{�8`�PF��%�@ʊ?Dr�d@�6�O�*:O�"������<.m@m�ۚ���q��Rt�'�`���I$�K��m��X���\����4��rɀ��l�.������S��D����,��%J���2-#�.s�D>�t��v:��r��֥��n ��[-���s��:��v�+�wp	�n9�J/֑G�!R��y^ȱ���WOނ�X?]�z�����eY��m.      �   #  x�Ց?O�0���SD��P�VbaK
C��Ăd�ΑXu����c�D+�������<�J�Zfͺ�I^s���h\q���2{"\�y�?��D��0�E�|�KJA{�Q���[Za�G�T�Xˑp3�F�N������]�cN�G�4mO����Q�1�{�N�辒D���*�lԁQc "�=���}p�E�Jʝ������<�1>��)�R
m�!��G�27k-#?��o�(ܸ?����ޒE��t�4��zu_OdF�M(�=� �u0�N�r�<ˑ��ʼ�<��4}�7      A      x������ � �      ?   w   x�m�;�0E�z�
�(���&�=��q����)("!�{����Ez�H�tkc��#E�r�5�
u�^�1�N�Uă�v!�Z��Q��zvk��l\4��h�������篺�R�c
#Y      ;   W  x�ř�N�@�����}�jg�\�����ʡ�7A�{w���ΎO�`��X�ǜ�Y�ҢB�jb�~��]���"Duq{��<.���~<�:��?����?��;����ϛ���=���˻���C��w[��{z���?_��T�3z' >S?0���&GPA�Po)B86��O�����b�r)���5��2GЕV-�z�Ah�������
>����yVP[p�{�ǽ�@T6>#!:�Gc�Gir)�x��1��b� �PF;�� YYYH���0gP�/Ҕ�;��b�������b�vy}�0�!S��1[��$��o���T(�IL�	_�f@����%�P����>���E��O0�����e�ʨ./�����̼�ZVs��$b?&W��<�ÚvHk����,��[>/,k��"L��/FƇy���2;4ǘ�h_LMQ����򾰬/�1/�������<_�r3L�s�/�%�0���k�g񠏾�|R��C38r��8)����i�c=��b4&�3�Ť�c�01齓$(�3����1D<v���9*6dg�YҶ���hz.H�|��2��047
@4q���� ,M�5 Q|べD�1�����D򕁈2�0��,�To���P�UL�r1��� �T��!�'������Zh�[Eu�h�\���Y���BS�U@ 7��[ �CUW1.& 2	\�K�G��(���Y�o`�S��� ��^��@z��d�#RdB��)@���$iV��)�j@QH�0��J���������Y[؁�Tt�}�21��aa��ҥ�-��7�R�rq�i�*y��)��˧�{��d��=S�ϳ��M����4���Bһ��CԗJܥp�
�Aյ1U�c|m6������Z�9�W5�"YZ�B!���7����"e�%w	�c�Yj��g��7UdyV���.*�Ή�꼲	�H0��\��%�.]XFkO$6��
$�!qB'$X�2���Y������'
�!�5��I\�`��{k��u�Ȗ|�֑H&З�H�{�QO��yq�|eVK,-t�:]�t�ڶ��*���j;@׆ȥ¼�G���M�q���b��=�l6�a ��      �   �  x���9v1D���$�� X�É}�#��g�ra��_l��O����������!��(�ߏ���^Ϫ-9�ɹ&�#9���r��+�����/o�{�W��s)�7�02`f�� ob-� FNf�9�d�����I.�ػἾ=���(p�z��x�s�8�r��U �nn0����\��@|�z����?� �	�Pl #%�4�����i���\I u���@ �=������7���`������Mpo:�{��^I ^(�@I%�v �A�߀OȭMv PRZ��03`e�N�Z2@2 S�fJ��>��uu��x�Z!���*L��Bӿ�A�B!m7��j�9� �0�>�0�Ƞob:A�4 �]π����ăA<�[����#oŜ�x�����o��&�j�(�8�i���6@��QdV0�L�0�c��v��� VpF���P�B+pBb��wǂ;�p�X|�q �p���xH8����p)��%%jJ�ƴ��lWXV���v��n^o<�'����	`����Ӏ#��+��d@� ޹�;VB-\Ip%��t@������*��J(i@����
 PҀ@I%�4 P�TB���@���K�� x�t -��6�N��N�M�3�	�1��^C  Z	��v�F�����ձ��6�e�sm��"��Qw;�Sw���N��:4� ��OF�\�\����fv��D�N�5(��<@�5T�H�Ҷ�@I��3��V8�n�h��X�tp+@�w��r Ϭ��<(	`�uL�3*���<��3[������:���Ж$XluJ"�f�$�Ĥ�ݍ�Z<�ĤAL�kTE� &�1����L��J6���J:�g�xv;��(�_�>��xv;�W���㣻4$�=��&��Gw�� :p���|>� ��a�      �      x��]]S��Ҿ��
߽�������B�$pINR[��8`Hȯ�g$[I�2���!46����tO��8ݹ�-����?�n���wx�Vw�_�}<�;(P=�T`톒��/!:[�ﶶww�_t������<�ݜ��_{�a����z|�98�]�:Б��@��O�ƃ����(���_�:�%�������h��z����ߧ��`�]�:�7�x�sԻ>�`Y7�Y7a2鄐:I��MF?W�v����;턚�t���|eŏ�wQnhO��c�I��L9z	��z{s�%��0���p��F|�y���lP�Q�+"�!�y�����lon�����7_��y�,�`d��`|��Uoxw����L e�PFy]�4����У�&I��[	h;�FnE �����������u��{���\^t{���E�����;������
�Ro ���f������\_���C�����	�C����?RE&�Z�R�ݐ�	C6��J�	XZ�;��_K��>'/?9��'^�:�3o�^N�0fJ� �������Gy9 =A��%���7Pg(�6&)~ߍ7�a�5��>N��2�:�e."h|��u^rp��w�z��"�Bn �(�c|:�B9PʚT�[K�M���~������ϻ�}٭��7t&�_4>>%���h(Ί$١#۳^b�@�_�	�
��WD��>bJ�3�=1�ӫ�{��O�+x+R�dJ�_/^b��r��g���LR"59�mb<�_^�߸;�����_19(b���c������ۗJ,������T�nDv}&�#Q��LX���dp{u5���ǃc2�q�jpt�������������"�`<��'׽Q?B_D�S9*�1s��}{�!���ڒ�,�=�$�G�_d���	h?�<��P��"��H,�B��4G��B�-!{rv���g%$��������I���O_U�///n:�G���`�/1M�,!y��M���w5+dʪ\f���$"��f�+&�ܵȌ����h�� ��<e���O�ޗ�m��ln�U�\���cU[��L;Χ"��L�Sy}�W���3�R���b�C�2l��2=��&%�eq3A��`��qp��@YI
��q������/B�tX��% 2t΢���轖�Ld�r(I<T�/��h��?��9^n~������7��[H;���^�{���޻�;��n���&�Zһoq��FUqT"[O����%&O9�ibHN�J�H�X����G�  ���R-ɗ�A���0�F�\ۊ�p?�lEi�u��L/��S�'�o�R�����"�����})���}�V_ߔq�!��'qe��롭��epq������Q�w< F�ǔc���3��%��<��]�h� �L��Oq�N��ѐ�?E��?�K��� ��i��������T`�2+qC�`��>����AS��ת"�Gj�0�lP��?�7"w@*.���j�k�����V�t��WP��,0.h�����0�ZA p ��Y*��~��?��Xy4�}����~���X;S�A[]0��ڦ��&
&���E�E�7�;�����T�-�ȗ��k~Q×�ÏU w�)����ɺ���"CQV%弈���ͼ�.Ah���2��0<�C��0��@��XHa�!f	��uX��N� JQ��{u���}���J`L���,.��3E�KEzCz"�FX=7����R�Wr����T�F�)����_ei#�U��a�J��LS�α���EP��E�)Jf��<.�1�򈎮�q\HP��2�
_7��pK����r}�P(�x��ʒ��X��
Gy�#E�@$��f�$~�����jp�U-��/ϡHSr�<�*"J�F"����J,ޖ��7��T�NB� TЯ�L_#!`�g�欐�*�T�j�$F�hW7e��eB��d���V���s��w'gU$7CA�m���H����lp�"�
�Ъ-(��,����d�'��7�ߦ���|-��z�Fk̡&h��+����Bã� Y�Q�x[�<w�����yv
⿰��)����Y�FB�6�+�f����W��ݝ??���d��G/���9��s��t#
/�S*AD�F�%x�!�2&��K����Шu,��X>��5��s��K ��� ���Mq�"<B9��i=��Z�C;�pO��A���T4[�[W�q���mkg?1$����AZlb�gP&�ȅ��ҥ��3�5r��k�����ik��uw����w�����g(�(xQI��j�Yt.B��{��a��q1�)�{E(����qu)5-K�!����R��������@��<xM��
O�*(
6(����b�&"�!��Fm�Nh}�\%~���s���4�~�y�}�%��pu�����_�j�<)D�8��8�;"�`-���HJ�T���$�O*\��v�m��\��;�6�>h-[�ۯ�5�-�.���~vz{s?���h0]f�q�_�~�T����I�L�$��^d<�5�F/������E)�|�>?2�M��8(��EV�R���aF:o˅c�",���8]�d�Mo���n�T�u�����]����+���[�RфwG�j��Y�L������������頞������(Qs�a�����4#��f|=����ȥ�9i4�rBͯCٔgT5��J���A3]	p�B;��s��?��U�p ��P����
#ݢ���c����̈́���S���~�h_\�nVֹ9�
��%����OX�&倗pwY��ReN���h�YNJz-']h�g�&4�0�y�,�Q���K�����˟[pӛd�M�vAV�T9�l*��@�4����Yg��cc��~�F��kA��"1itK��U�k�f�����"F)g��<+���N�ɳЈy�
�:�*�����3��VJ	<����힇�-���R��SRbZ�H�i������H���+��4���=�d!4dC:�T�@��0�	�?af�ÃVtx��n^��P��M4"�4��KAҌ�������
ʾ�!����$�Ę8��J��A���N��~�J�BV���u*B�������I5�?�Lx��傂�vÂ�1������g���YJ�Z�
��b4���h`\!�XW09���5����w)&��w��I!��x�aVڻ����:�w{�#���x�%`$�*���a&�2��ϵ'r����}M�d5 �?�E.���ި7�nȭ�}��Q�{��KT0��QR�f���|��do�� Col�z�oE�
1���KW=B�+!T�{��0�b~1�'�j�h�UTH�
y/(s?$*�ȣp���>�03g(�qgT�9{�)a����|w���{{��<������v..B�R����Ml�85/��s�fbqTX�
+�vfD�;+��-�0�V��A1~���M����d�H��_�?�p��R]��.���Xɡ3�/F婳�D��8��(kD����	A-~�`x�J�d#�=��~g�nV�p����J�~Lj�&i�
ҒJBBb"B��E�Y(�N�����vn��.t���C<Ϸ	>�.��C�����T�ԈUm+|��!J4!�v&�?�2Mqն~ȻQ�U���w\3�ϜiL����	Q-'�H�;c ��U��G`��+c�֎���E��ND<C��	�
j��1[����X�ʁ�>:L�"J"
�Y�Z�8�`}��ax�p#�$���*"�.��D����@��p;��I�Ҋ��͹*��։��ZX��>;0��b�v��.*�ԈxMX�0a	A-~̛B�8����]i��p`μ�Vi
qHT�/����f��(�]k񬝔��|hӵ�"�J�p� O7/X�sC���3uީ�n2�Sn���T�S3���_sH�ѐ�]E"	��8�B���Ь���vw��{;�*�U��%��]�o�����ҙϰ	��>@I�N<iV�$
��=}��B-����C��	�vE�bR�|SZM�s������Vg 
  ®�9�����e�{�˽�(�m��d-��R�S��H��ve��f8�k]��3]��O�o�Ѷ�����/{�
V��>�n�6��H-5Yio쳠T�?+%"�kr}��HT���J����=]���p��ml���~�^bH���3��o�QK6vk,��j��V%���jљZt)��9���i����;�����G%y%�Aش���,���t��@�J�"l*°!�Kڻh&� 8�?�7EJ���/NC�T��ףQێ�}?���{]^��/�JcPE�j�1(֐�/��$,{N��T}E����F�Q~�:����-&쏄�VRZw7�aV.��p+c�P�D2�3,:�Rx�ꄭ�b	S�6O��;q��߭�U���l3[}hZ�bM�LWM��W���K2Cna�T��Ҧ�r�mJR�7�a��5�TR^	�8�f�l���O_���� �	��_m �p����D�� �,� U�緟%�η�c>��Q1.�l�����*���T��.]#:������ZƆ��ئ'B��иi�a���|f��WV.�Ɋ����Yo4�{���A���}ߚ���JD��2��zy"5�d¤H9R��� 
�4�;��<���_aM�������,��J�pT�%AԺ*�����i�ɨ�1���� J�;�iR�=�\�O,���My��t2���*LN�K:�氀��fIn��|'>v@����zp��FY��1�!j���z���������L�l�Vj����l��y��Q�dfO{)Zs ��M>q ��|����n�?B��Nل5�<��-?/AE�!������$xrقN�'WL"0噷	0��I�p�KH��6l�Y�I�
�~0 �4㌚�`8M���`\H���P�
�c�.�jj%�aևEE-lا���`�u,�n*@��L�D@�Y��ә��e�im�����$�W��c�k��"WMp�YQ8<'�R��������Y��1h�� 1�jX҈�=^�4�`�va�X#�]�2]�NW�8�4�S��u5�#:8��?܎b"	I��d�:Oc��L�y��q�����J(@
�E��U�,� �Ú1�p��T�L%�܄�c7Y�>�DP��j��Έ�>>�"�1sG!"��1�ע��*�c����Λh����,�y��$��EQT ����^��
 �YH�c�e�$"*n��.a�) ��ځ
'P8�Ra:A�p�<γ��ɨ�O�0��o}�H��=��Hu�4��h�S��'A��׈�<W��b���(��6[��a��^׉|�(Q)��(�0���|)~9S���0`8+�؆�i>�\�K�Q-��4,����-��!\`��4�xejD.�MiR�f\�1;�lk�!5�<(Gu��1 ��f֠���<0PŬ�#�S*mce����m򆊇��ZJW#Ra�E���Q/����	�ƴ�2��Nڷ��JY"�*�A�v��fKM��^��(4���!\
�!�;'}�Hf^��jn���s���K 7"��TQME�Ƕ�-ԻD#�h�v<��PxS���0��Kqz�E�	M-�%q��f�<#��.����\?Xom*�q[�D7�H�F"цE�� �89�$%�������x$U��n�4��$�SC��B�i�@Ѽv,@�j̩D� ޘSSc%zj	��Rk��pwL�5� }8�3�5���t�xk��`�5;�:�L� �jD��^�J!�7���1���@X�T�OM�E����ksM`}��G��qC��ME� �`� 1��h���$$�k
�m�WB��3�nz۳������.���4"���Fi|���xw2���u"��|�`�v��em�����e�OSF���A��C�oI������L���;��� ;T�w�F�Z��T�!
W)�u�.b�@�lZJ:��1�=C(�
�
U���N�ƥ �Ąv��b�Eܤ�-ԉ�*w0)I�b����{�H1]�����z���v��c��P�)�RE�3���c�1�vd����ڀ�5"bC���fA�j�̦���Q�5&[E��֪��[��Rc��S���K7�����{j�hg�g�.��$v���$���:����]J�a]������H�t�YTҹ��ZSxr�Ц)~��yv&�L�V�Xc
�fȭa����w}ܿ��~����;�9h�ٖ1�}Va2���
�"F�]����h���6�L�ac�K��E�`�W��T��۠��d'�̪mP�oV%�$ N,Q{�G�RN��*�Dʨ?�84TS���b�=�,#�r�|X.ߤ����*DR��J�sS���Ep4l׉�ŁHJ<Xo���,�V��J��'�#�1��*�2s\:�5�u�Qi���	�BG��|3cI%��")��N9�I=�����&����u�����e�H�vS�HO�ax��e�J��@U7��|�F���'���v�j>ȥ"�G[����f/?�ŏ[pŋp�
�|�}%�@�_|w?m���צ���t"n=sSh 6�ϵ�)`}�ٖ)`�*���J�o�E��ħ)�V�XX4�[��4s���X&���-Z�Z�b����ږ����DgBs\H��(����1}�44#�O��AC0]C%6�շ=��5���>�
���܅����|&nj�"���E����?Z��*ܮ3>�ҩ-D�95߹|ғ�j�㏣;���h�w�n8j���/��!Þq%uڝ�j����i���hد9q�aj�Y8K5~��Y�3����U��v���z.�4
�	f=��Ң���b�<^[5^�Ҷ�nH+�#���u��O�HB1N�R'
|���;M$zو�R�rb	M��mY�	7,�pv���,��GOTN�3���}xm`m�Q��@��	�5"�.=v4�e��;h:�yI �f�aq�����E}��s'X_;�P��&ݖӦ����n�Ta9�m1��q�A7��������7z�M��I�P�xS靃�R�w��v�l#�:�v�mx�-��f�R���I�p�>;P���ˬ�Z#i�N�T��a.jŢs�&��hP"LR9)m��f�o��D���"Cz�A;����]#���c��d���t}���lX�Y����i@%o���l����Ma�Z�8�����
�_S0�|�*��KiL�ޫ����ɇ����f^V�v�ް��U�+�Ϣ �LG=�Z�����*ao햯�a��i�U�(u$}҃�ja����")��$�:�7�ta�����*����D��$�������J�B      �     x�}�Aj1E�3����K�-�]u�MhCZB3���ܾ�C;Y��y��d��0!9F!.l^L��������ӠuC^w���[N'&�TDJ /�QSm6�յ��j����
���"��P5�RXl�j�_Bb�T�|� @��&ͅXO�>F�P�)g��C��{]|�.�>�s}���Σ= ��}%i����J�C�o���)��1��ǜ!oQA]�s���r�oRP�Ys����
�i��`	]t9�>����~=���;�����ψ��      �   -   x�34����44�4�� ����,h�i�,h��b&�=... �K@         W  x����r1E��W�P�[j�vv��,�M�e6`^c;�ã��i1π�*F�eN��o7$����
�ɉ�
4h�H
RƔ!����NKҋ$~�o
N��B�3����I���f�AQ�)�����~����T��x) >K&����#�T�%Ć�����e4��u?��W]�7j�5����뺪\2j�!(��AF�m C�#I@Ϊ�]-f/���m�p��\[�xR�$�c���<'yWoF/�&��1����:x�z$	$~	)[�=��Cr[���K����e�4Z�=��30��:Y6��6U�����K��� ���B�Q'	G��X�~��������:2�Do���d�J�N��ST��8u\�)�I�)��R��8�Vk]L�B�U��lb<��ED��8��z�_����s� ��O-cK��ٮ�O���<��å����f�����n�2f�XI�db8�ȒԴs����ݱz�S>�@��DB���HK�Ķn�4k��N����'$�$�v�.nCA�M��q�$�Bn��c�kȜs��sNXk������"o(A�$��s�L������:O&�I��R���V��      �      x������ � �      �      x��][w7�~V~E?�f�:�/�';vv�3N|,yr��9s�RK�5E*�D����U@_�E��f��ǖ����P��P �8b��o(��ʄ�	�!S���i�	��'\��ZK�ч����2?[O�w�uv�O��)~�ϒ�|�,�%���_L]����z��m�j�ɛ�lu	o:/��y�㋗~��~�+�J\�"�`�R��Z� ,����l�'�??:xFj�2�P��R+�Va��P�
Ia!�U�\�{\��kl3Fx��֡9���*65�i����n$�b&�L�M	��M����c+K5JFF��X�.ϲ��m�X�&�r�6G�bv� -?I�����CN��P�r��o��Г	%aS*(��"O�P:�U~�1_,/�k�ҩ���Uq��/����{�.�T�{r����V��J�Ìë���,�&�EV��Ň���|>M�%9~�"��x=�e���*Ϯ�?|�1x�?&�g�f4���O�����d�ơNJ�_Q�qF 6�"U��j��	y��2!����^��?W��w��b�U�,�Խ�|y�(���G���	j�|1�J���$�Wɪ�N���>fK0��������X���կ����.�	��\���MM������ޘEh�0�x.©�4)�#)猙HojwcV�1S�kͪך)�Ϝyٖۜ�\JC���IS&�1}�P)�J(J�&�y��E4�>_�+
'�XL�'��^G[
�6�zRc`)�RQ��	3�	7�=�|י����*�"ڥd�P:M0򙛇�6"��i�r~3,��.�oK;��@S�B(�J͔��lf
�C?M`NQ����6y��AyW����ؠ�p"{��)[w͉���~��mH�d��R���ZJK���2����ۣN-j_�p�jSe��=ȸM��q����
L(s���a���F�Q��b��p�2&-�b���y�`c���l�M�d� �[���D�1Gr{5_���eˬ����	Pr�H�F�%��h� ���>��I(K�N�bQ�8�Y.y�ND(�P�q�t!7#馦 e�T2��5��*��� !*����p�i3��9 \F;S,P��v�R��y2@�P����P��h*s�rqq�(�pJsVଅ�m�5�3 J�æQU�	N�Dh�c��Y�8�KT�7���b  &���
������h}��/��@�0�,��j{�:��0|��*�c��i"I��t8���[뾢T!D�j���Q��2�D�8k�>��R�ۧ��q�\C��4AhHT�)�,�+j�>��'�w[�m0቉0._d,3�5P�0�⩄9J��?��>��F5'��Jk)ց)'�Ӕ+�e����X�ZJ�(��lZ,W���8]z���8i���T�hMS%P�a?'8Է���Q$Է�ҁ/+�8����񳓾�۞�K&8P+c���q�?��g>�0w�R�8qL5�)��H���@܅sO}K�C�H!T���a*Ɣ�oZ<EZL��X����|�/�ur�͒�90�:�<�Mj+s��@��
��sd��I޾i��޾���2�3u	N�#�8�!��8���>�	�'�{��RX�%�<���Hv�N�G���]���@��:.zt-
��(d��6UV�+�;���v������ੋ���*B�1� ��	��W;���V�>�K =������=�)�^ѭL��?�C$N0.�a�1"/�4	4iˣ���rv3�r��|���0���k��H`lۀ/�dف.�}����+����f��5�$��{P��4:2�������w�;hn(K�F���N	��p�1��0��) w�/�v9_�uj}�N�Q�R�G��`��
��+% �`�H�a,�T�0�%T��;F�����$v���6�1�nĴ�a��.q��Ĥ���(���p�T1Q�F�S��/yK掖:/@>IqW�&#�K�Ọ�oc��b-=�Ts�L&�:U��S���s������_��~����/��Q5߀Z{�e�Q�	�Z�����V�E���9����I0ܔ�6Y�rnSΤ��;��U�\/�Q����2Y/������{��E�J�׸%�\�(�[)('���z� �,Ա5^��HH���/u+���ؙ<��NE�1Lq�>ʪ��g9وx�r{���&4j�Ҩ��}J׸�,BW*��ptW����E��C�L>γU�m����X�m�ΐԝ.�Y���JJD1��c��h�y��Η�H��)I�Bq����u��L����O�|������U1K�-�u<������&%��7�e��(@~�t���-�q��Ѱ��X���uI[�H�dpS�Ϊ���a"�����r�0+��H��cǥgW���/����gi����Pp�c;�9'��0MC������(��s��~E�-$&"��P�Ewpj�^��ٱ+�h!~m�H\�q�7O�X�&���x����&��cc�9�W?G�Xaܻ���:Tc��n�jW��XO��pS�C�D���5��������U���r�t)D9
D�
��+c燾��j7w�}�i ^��+eW�#w%8~W|��5M�����=���U�iAC�?��~ eֆ��Ք��:�Jwp��L���Kx �� P��Cw��H���E�p��1���A�6F�i�.F�ޒ��k%��8�[I�J[Em?�+ Uuw|�b�!zO�����w�ɫ�$���8y��ϯ_�i����?�G� K���j����ޔ ٦7����:�L�T����d��_�R��Մ�b��3�ȴv�.�a�b���{ Tj��Jeq� ���e�$.�010���y]���ᪿ�*.x����4�il$έ�]Ye�q���(�zc�f+@I��i~V���Λ�?U|��:��v�&���+`��F�%GÀ������������U~V����g8RƯ�(~�`��Ȑ�d���X���Gr#Β���2 
f׋�4�㱩�ܡ#*����5�E>EbJ]	�m���Rދb6@�Gb�>�
�&� ���yоco�S��s>�*�^���>_O��3�~$���d���#b�K1-a�R��4�:��.�� $�|�z,�<�
S(�hAsbc��+ILC�w\�=*P �3�T1e"KwwE1'��G�IC�
�C�ȭ뉴�*�)0o��e6=op��$1N9 6�u���	<դ�M敍�g��G��mՕ�	,�Dj\�36Ҽ7���i����E%�����p��6����>&N��h="�daJI9o<i4&����S!:C�6����qs]D��vyPx��
\Sθ�� ��EXAl���
.�xܲ��Hڃ��n-�HoLypp���� �+��#{2�&Dv�@�$`Y�5�W�>��UV���v�� � �b�%��c����������Co-p�xi�GN�Z1W�&jY_L��-5u_����V�%�/�fԆ�ô`*�q�<]��^�&�����竜������	a�R�J1����W*p
ц����\�`텊��}�2�1��@�Hڸ�+C�EV�Y]�ģ� ݔ�ܡ��R"6��0��zl!��qeYu!W������)G��Y�_����q����&��n$���t�]������{^@`I	��2͍�.���p
_��%n�;�/�0Y�,U�q�{o�����l�
!��x����!�l�����ٴ����l���v�F������P%nܷ���cu�a�;x(/b�p+_6�	��0�a�U���޻V(5!�����W�m\�
��wHA�*S`���)�(Z+m�4��-��b��v�8R���(ț9�U���P�8�%�+�9�uhj�,&e,Ƈ3eF���0���T><� ������"&�{n�X⋄�ֶ�Ԇ��+��8��=����Sv�S}��!Ѕ"�0��P�Ҹji�k�!@P�G'<�w=��'���%��q�\f����T&��L�C�W!F���IvLZ�G�����*�B�7��ݍ�������\    �����&�q7nq��x5��E��b~��0k�}�P/w-���m��9�uc���9W1�y鑊�K��D���T�W�x�A�e�2G�̡-�] ?�l��H���8�������1-��o���<<h�����м�+��pU�h^ha-c#�Y�!fwN��-4܏��s�8u������"�4E�[.�sҊV�|OS ���/���Q+ߛ�SfBw�*����X��=�VK�t�>`�f7wb Sc�w��8�����v���7�w4I�����%��U��|�/ۍ��A����1J�I+TxA���T����m7a�4�L8�,�[bР�!�n�b����������/�C�rv�*�5�uPY��Mne��ɭ[��"�_�>孁�P��P5|����|M*�1�Aq|��-_���>!�
⒘Ԍǐ�DS՜�8�z��Av��v*B��&��������g��x�wpց�cf8�F # ��4u��e���5:��-S�'�ʑ��Y���W��^ڱ���i��:�.�p�q̹n���ʩ5qƵuB��������Yr|
r�8�'���U�緩$!t鲘��*�k� o06⌫�G<����'l�Dk-��1>\TǛ��3��a� �!���h�ٞ%�9��p�t�r�8���O�X� ���d�6K={9�C�T!N�'�ikEk¬qJ]P*����<u~(��uĪ;t�
ܫ����6��'�=�D��(�8���/�I�Z�B����9N"G�-a3c��Z�:
V�S��)�ݝɝg�w&W-���=̘�"KoS M$�M��үQ�3$�۱���R�DşO
�H�MMJ�;���*X�4E�v%i��*��Ն�pr�5���<��e5�� �$�|�c�@+4�Ѱ	Ͽ/�����c�A��
�p�Ʀ-7&lri|��{d�FYb<L�Heqn�]"�̒��\�MM�i֜<J���c���]5��HXj���b��$���ÞVn+r�5�WR�F�axp|����R���D���.B)�&�C_@���Ԟ�ʽV�86���+���[)C�3��X�����j~�^&'7�r�/�<g��
(�
�^D�rM��7�ӕT̑�1ruj�_�8Dh,�1���V�j9|�ܞkK(��X�x��������7�R��O�V�[���ܾ߽�G��X�qmR%ҚW��Z����U�*1�R�P͂�p�&>೒�hIX��7���`�6׍t�:�8��4D��аI:b"5���\6A`IZ�6�o>����+�XWL!P�,��0r���ߺ#@O�٬X6�z�L�v���(�����$Sm���;�	�	w���zK}6�q�a�n���D���������n�[4���n"7n�KV�e�����=�d_7�7*���С6��1U�Q)�JBr/6���)|���||�*.�I%T5D8^T�,�����ߏf_G��fDC3ri{���g4`���T[���~o��v��� ����E:*Tn�.�F�n7�h����ș�ʅ�Rj�#m���}���ϧk?���:d�t��6Y�{{��^��
ml��z!��(�zN'k��� b% {��YD.��wL��4�I���V6��Y�a}N[���*�-��@�Z�+���4A0�v�e�,N�h�*~�Q]��H_�tr	C��������2_���|����VS��,)f�s���M����b�7K��ߋ��D�׫�d~�E�W9��e��\��y�X�\�7~�̝�t��G`JY�s����_s���/������:���<����Iv}=-Nݕ����b�]�'�aWN/��e�~�����J�G��g���'��(+�or�z1?��/�x~�i�X���\����<�bV�=?Krw��g���}w�y�����p�nU/���ڝɎP��r�X�c͖�}	�s|q�p�Nr�����}��_W���_���n��]z��y��f���I-N|`��f������b�_���%*�#<>+�*�:��7|��Ш�c~�g}�Ԗ��^ޮ�m��.T�B(w�Ja����=6�^p��x��J��}ی�6���y���\`6eĚVB�lbn�%,��^D����',F���O���)���8���M�xv�%��u�M��;E�R������=�]��36�&��A��L�{5�"*�{[�a�d`�p�ċ���O	}d���(�;�EYu c&N���`n����i�V���04l� /�R<>����Y΂tIˈ��h����A	I�D]6Iw�2�6.��tU�t��E��ή��|�^e������N*
�����:Ux����ooS �ݩ��=����D%�f��|��������BT�����j���TF5P�v�Y��\��0%b���;A��� �wf�ۄش+�1���^�Mw��b�TV����M�T�ӆX�;n��P�Zb�s�~�u�5_,V��b��������o��t����POJ� ~���׺�׀!�?Ѽ��Vs�agDM�ǭS�p�75���d����ӈiu��-��O��������x�~[�x�1����?�4&D!���eЄ���h�����
�2mՠ;Xᩱ!L�Α��6�0��Z�V�ٶ7M��0w-���F1�ų���A�Au�:�N*���
��s��)�}U�"dI�**m�ɰ4PjL���o'ԭ�LH�A�Ϋ�`��U��M
�o����jvV*߯Y�?�lS��#�GFS���*hB��G�[��Ø��l7Q�E�����?ON�˼��r�^��g�� )+��@���h^��pw����C�V[�#���,�5���.+`��<?���`�#��@Y�[����=\��IL �{O��=w�pJ�EV̎٦��_��?�M��Yq�l�ϓg3���g]��r�͒i��'7g�����1x��\�˫�k�����d����1���z��g��?�/���q�׳�����o�������׳�[ߖd�ϻ���	�}����g�x���L�n��Y���3Xkb��aT�#����_��2[���5p���*f/��O��uL���*wmK�k��
�e����fk�;���*b�wxy]m5n�~�M��?�Kc�nS��`Ú�I�Tf⽑��������' ��Rǀ�e����~C��C3��Rg��GߤG��֖)Jv�)Rq������h����`dc���5n%⠯:����V�2�Y��/��9���e�`��u����?༛�뫎׷��Ɲ̦��7�0w#�N9���q�� ����'��~]�EwI���;ܹ�g�@����D��FI��z���^\i�i���G���;O}�	�{6�3����f�c����<jK�܊������]zx�� ����fC�Ã�� ���Bȍ]��fkJ_O!�5Z�/������܉D�{'��a�H����IAI{oAS�Iey2�Q"y�$	��q���R�ߵ�����(�9��4���=��+ץ)7�h6amd
3 ��A�'�~�D�Ѵ�����r�tu[u��0����^K�/=&f�m#Հ4혮z���멷$o�ҩ���.�>|2�������{�|:�����j~�6_���*���9s?<;~������Ym�`C�=	GG��)_���r��]6����@9���H%��ͼ���ߕ���{[/��ͯ��^���Cw4~��ZM�"v̊n���ˎ�b���b9	��1w������?��|k��7?�*��O޿>u>,����Տ�և���?�7*}`J���=*�}�d{�o~@�r6��	U~�����Q�P�_��������o�����*Y��u>��!j}d}Tz?�{b��Q��Xߨ�/M�m�'"����}�,9�-gh�oT��8ߨ�!r�Q��|����F���JR��޳�9�1r�ϒ���h9_0�U><�7�|��o�� 9ߨ��q>>����|�ҟ����{�wr3ON����}�����*�u>D�7j}��oT��x߸�k��oT���<.G��ӄܡ0�ÀX}䦿�X���ij���a6�pY.�5� 6  aS��l���ٰ�?�F����iv�)\�\-��zߑ�����=#��z�q�<�U����;������w�����8��/X���wT���8��/M魵N�I�R��t��N1}b�͎��%s�Q���~�·��F����J�U>@�7*�I�_�<����,�'��ޓ�F���ߨ��q�Q�C�~����F����* �����O�o����,�ߘ=�U><�7�|��o�� �ߨ��q�Q��~�ҟtݯ�G��[����s�c|�ʇ��F���Z ��>8�7�|��oT��2>�b|...W���r�O��34�7�|x�o��9ߨ�r�Q��|����F�?)�kWxV�W|�������ѿQ�ã�·H�F����J�U>@�7*�I�_�����y��2�G�F����:"��>@�7*}p�oT� �ߨ�'��ːwr3�:%TڽːO���
%-��2{�e�^���.C����񳤻��29�/��*�u>D�;j}�twT�������Q�O��i���.o21Z���ި���Q�C�{����F���* ����|ϴ��d�,��h4#�U>ҽ��|�{C��H�����N�#�����f�MɪJ(�x�J-���MM�Y��f�;V�-h��ߏ���֜3��i#4uh��~�02���<%���oj� �_L�~�t��D���p6a6��+�@#&�tB��TRÔ��ίo�Wã�������y�(�����9 d	�	�R-�"h��4�l�+#��(�Kx-	am��P3a$$4�t��(�vKO���t��)[�w/���لX�/UVkE�&=�,���n���R��Ak��������xԤ&um��(5,�w�����LX=f��)h�&�a)�����	�C3�h�����[�4�[ �0��B�����݉L�m���ޢ���X*��oj
�M��b5͗�jh~�wY�.��ߖ�R�g�'	��0�?�O�Fҩ����r�8'4�"R*~�����V�32p n�N%ӄW�Y�9�N���R�d�(����|H��������      �   �	  x�}X�n�H}���o����Χ�s3q�8���BKL$D��d���{�)�%ڛ��x�X}��).�>��������]�����)X�y�?%sM�����uc�TɺV����Q9o���ş7�}��̪��f����ʔT_+U�P��ya��YI���[w����� *�����U�*M��E����LU^�PhUN�dN��	��q���7��	Y9V�V�boT0S`W��P cm�x�tf/�f�λ�b_��z��V��ˮ[�Ρt��9����nzN�9T�S,��a=����ͮ+_���������V൪5U��q
(꣢%�݌u7C�L,^�7M�.@N�Ь�}�A���a����_3� V��µ����@��j��Q��j��q������>�\3��Bj����IA��TP�2�fpߺr��C�i�i�������D�0�p�1D��u���h@7�9Gp�ľ $����m��|���w��j���jw؏�$NY��&�$��qb�
#�ws&�6�Y�n�X��\���L���`�$�}mU��ht8���B��%b�v�o6�{���;n9u�<�m���F���TT�V�+c}�l���(�
�k�ReP�S����4�2�bm��.��Ы6��ap��)��� �'��p�F��͆L��)a*�4�氚��e[�w�n��������E�l��JS�aUi�h���x%����A�>t�ͺ�]m���$4�A�ʢN\͎."��!��F�Z�8��)�����}kʻ�q���0u�B&TƠc��B�?�w㊫�E��-7Ͷ�kח�(J��Ԟ�?B.<��ϰ�����9���Y�p�p�����a�µ~����e�x�����P
hnY|&k4�����j�B����M&�I����ꋐ�~P1Ugc~���#�]���"=�4F�UTV�8	�f}�1 �a� �2��sk�Gы*T�)�|,�C� `"\���}�U��\��-&=
�6�pR�R�h�0���wP0�k�=���A� �>�)�R���%�A����:��_W���[-�q�s�-N�m�C���Xa��w6��C�C�|����]�4�Fj,�^��(T#!���5YyP-k�AÛ^��,}�jV0Db�`�\��4�L�v��@�ɻ\���*��処;~-ow�>�!��(
f�Rκ��K�+���c��M'���[��j{�oփ��OD/���kr�"���/���?g�z0���А����eV*�B�O�������Pzuw�M���'\k<k*Ş�O"�m�ۺM�b��/H���G�
ٌ^�D �0� 9f+j���R5R	�y;�4�����c�=��0h�C��3���	�^u6(�l�5<�{L��$eZO���<���)v�&!M�[�N�X$0kF�W���&���P3L)�Y-e�ϫ"#_���%5k�W6�UY q� Ty��������oo߼η�J�!"����vJ/E���U�yL� ����[�ha��E�Ә͢�dy
�~i���b�h� ��Η�>�F�J�{�����c�������-�C�Sj˷�o�_>���bRO��X���\-�+Q�0_F��/cG�b�}_�]��ڭ{h_h%М��♂%�y�"��^�� =�X�^������P�����$����5B��"l�f.��y �qy��C�s
77�m�k��c�ۏ-�sVr.�q��J8���h�s0&��4�5��m�V��V`����}l?�໵yr,�3F@9�7ga*�S��rb<ى�����Dh��IZ���)]��Y7�����lv���Y�Ѡ�-��ueѵ�\����b� #:��0�k�<�Ծ�b �h�x��{�!������/e9w�%c;�-g��쓝׫����\~��b���|�|�ҽ���u�%Ҁ���Uvܲ��%�! Q����rf���g�HD/W��QZ9�!�#6�(���P�;;q�؝��b.�]��߫���$0+б��d��,>2�a'�y�c����`�J�e�(��Z���~4C}ȧ�;��(�2�9�n%�7��]3
c��HI�{¨�Z�\k�l�@�.8����j�śCh��<�eU�Bd&�C!}(�B,�h#�2/�����|����y܌�����Ics&D;���DiI�.QH��K��*^��M�/oϺ�
R���#��yH�2m�3JŔ���M��D�N��wc2�R�ēl'�U��/����fٛns�:n��.�YY�����$$_?\2�r���%�<��}�0���_��$J�"�������|P�]1�t���]���l��|�}B�~���i��ZM:��!��{\;.|��	?�.n��.���E�A�0�R~��6+!l�ӖH��\�Kz�k�S�����ʞ�L��g����B�V�(VǇٟ�l6�5���            x��}ے�F��3��<�fv����G����F���g�n�$�E�H���.ml��3aG����?�/�9'q'H�fwmOD�Z�UH �'�����re5+]�>]��ڕ�"=Ti��w��6����L̸�)1�|���ׯ߾~E-8�e�V��F�3Q7�����-�C�X�9t���t�"��7I�2O�`ç�8YU���z
�2H���%U�<U�W�.[��ں�8�� ����u�dkz�>����]Va�ҥ�=|�o,�6���`	#���t�dWB��O��dIu,���a�	>-�E��5���T��w�W�J.�����K`n����E�?���O�C^T�,i�d0���\~�	�x�"͏�ٽ+i��!�킝�^˛`�<�,�
F;��.)��6�m6yX��Y�"`��2l��X�IY�ap�l�� o��E�<��AR��v��?%�W�9l���٤4+�⸢��-±�uk/n�������N/�-��6��/
f�?R�;��x�3��}�{��aŌ���|&��՗w/^~=�GD�Vŷ�
7�o����G�J�ZI��\���$�����5�m�b���.}ض���`k��M������ ��|�]^��=�3��1� 4��K����*��I�k��vs4�0�C~��bM����,Y�,��E� \�#����;xFH﷕?�枬��,i��佃�?��� `2Y '���p�v�3ڥpA� �ϋ�s�v��ػ{�vat�*e K�E���� �&� �'�>��L
�;m��S~�/�p���v
~L���)���tKjL��y����@��7���HS���a������/f���c�w�@ �$����~Y$Nr�[|�<�r����=L��%�͸�������x*�d�X��&�0o�吮�ʟ�p�����J+���O�#�4�d��Kw�i�0h����!�~|�R:G�Lz ��3,���L8-�(5��e�G��s��|+X#\�����?¹f����n���gp ��O�^A��mi��+L�M���)��>Y6�����L�x�~�P?�`���O9\L@���w����'��3d����I�u��-	�����ѷ�)ۛB������ve
(�E3f����ߎP _p0}+�md�Xq�� 9�"�Ȃ�8�s��(�Eu��e�T����#1>!� �1�B��P��Jh;I���Hc�j�/�- �5O�P���h�g
/��!�ӷ/޼����og �?��ߪ(4��m��J����X�9�t<��6�y�@���n���hN�s�����`�8!v�`W��Q|�i���eZT�5ܹ7�^��O�7@��? ^A�͋�$K�C}̳5`��.X��[�d��0�) ��UR��R@���'� u��CC���d__ j�ft���]�y�{� �=������Z兿~��Zm�G�I���&��h��<�[��T�)���YF,���
/>�1���.�ìy G�4��Ӄ�A����+dJ
�*S���\	k���{wH����"-]�l+���lδ/=-kY�"���1;�917F3P�6�ad4���8�Z�6���(,�s�f/�G��xD���p^ T�Pn�Bʀ�V�U�MC��k�T����<ǄX�& J[7�X펄�{�)?����ve8u��iH��B�X��q��!4Dr��9q�����=�jWKM[j�	Z���N�,�)3�zr" ��ws������1�#B܊(T�i��n�V�;�!���af#Dd���X�+�8�F4X���bA�1B397-нX�?�'�9K��e;��1K����U.��� �@���>�@�Ԩ̃{�)�'.�>�2V�6���@��!�2	=�v��0���(pl|�@Wy��?�Hs⋗x�B˥�fp"��I
���pS9�Q�iA~jw�q!U�JG�  ���ӓ�5�)�4�&҃"'�h7ж�0S����oǯq�K��0���x`�T����n(��ԡT 0@b���G׍�>/��&^r�t� �g�u�	�d<{C;�փX��lgr������Đ��1�믁�#���\)9h�xu����������D5=�^{wJ��$�<-&�ˉ�rz �Of���� ����f3|����u�����!�S��5$�j˘�9̾xڣز�˽M������V��XmS���f�A^~	)>��/��]�8a�+�)��]�着��-~pɮ�>�[VO;$�_#�{�D�?� {c	�77I�oբ��#ܻ
h���2҆��������4�Q��[�;7���_N-�{��_'
��g@:�Mࡋ�}�*\v�k@�|�>��t©����忕4'��2�-U��,��}Hal�	��5Q�o�����c��?�K�7�SV�_~I��t�|��ݻ����Qz���Vy�lc_�_#@)�-ńx	�P!�!9�;�% ���\0���	�B �����*�a���$��$3���z�\;6n"laR�ۨ�5�����U�<9�V-8#&i|(����n"�������t|V�������J���	:��s��&4FD��M�#��1���s��x�mLM,��A�,���O[z8��S�ݏƴ��x0�5ȍUČ�ķ-P�0+Ѓ��!�v"�����"l��QYp���q����\h�����#��/�,��=²�"o�2��ۓ���і!'���}$o9���>@�� *�֪ �,�����2�����O��3���ب�~�`�@"BZ",3����������{Fڑ�Ci�HAr�����>��+YZ��$�	H�W#��1*�c�jrf�͊N1#�qN2
cܻΔ$�R\�����1ρ1�HNy,6�����I-���=��3Ҏ���Xߐ��k?���w^���
��V�J���։J����X��4n����4c:�8Y�t��A��˴�$n?<�����;^��\5�����m��J�[�,�m�9Wm�%2<���΁���ZE���Pt����C�HS�I�vի`k���ϫ��� 6$��F��*R���a�f_�6<5���F�����f;��
"�/�}�mw-@�<�;8���«^�O Q�@~�� M�8��Jn�݋���dpib���9�4��#i�#͙�4^�DZyȥ��7��gZ���^�&�c�����@����L<����_����hņl�Ĩ�͋"6h2(h)��R���ݪ��2x��X�}x��BEm6A�(vx3.��&,h�Q;�DmJo��dI��)��oK��Ee`��>�`l{@-jcth��U�����k��"�!����9!�	Q]�D\�,�0�V�Aj��a�@�*)���7�z�Ҥ=�E����?_�>|�7������k�O ]���X�e���q���k�購B���I��'��_�b����C&�Q`����\�'�os�ld���<s�����=�ǒ�,���d�7!z�p?��OYn���gw?'h���-�1�Y�
�ζ�5S7�)6��Pj5k��:��I��z4ԟ�N�Oa��� ��JJ2' )]�ݎp&ҝGԒ����F�%T��l&��m!M�p�뇰CH������:P��0�P��	~ �w#Q���
�#:%�&V���h�bf�!��_*_-�8jf#�{
��c@�V3bR�n�uG���`r��%;��[�|�T������>�@�v���#4����f�$��s�&�œ]�p\��o�B\����lJk�dMD
9��<�#p,8��#eY-�D�t�OY���-��ӆ��(�V��H�Z���쁠 A"�:��5���K��V��-���d���c�0��-9��;ЖE¶�y�B��g�/)\���i{/{:�.�j��!�k,k�<��
�`����,}��F$�{?  ^8���p�\UNQo}�z+T�HJ`����>���r�F    ��|?z�s[�ᶦ������.�Ma��c�,(�x��j�Z$fw��2	^!&���r=������OK��Ugi��ߤ��܂�#n��Ti�s��oz����y������7�t��������Y�!�����MRm���^&����?����c�:�������M��ݥn��n�_֭�ҭ������	 �������y���{��#�0 S�O��ԚF^7~�����@�|_��=��rM�Ě&T��/q2�t�����J����@�+=��!,��]��l-��K@'�;�7)�%*aC�X�A�M��խ��T$�H��-�W�Z��"�抩%��1iZ��TӜ���<E1�^%0E)��Nh�hk�p��M���L�o��X��ҽ������|�O�]��17h�c,�x�,��;��_��ĝG���헻|�L�:���֋���K�^ɗ����6Ҹȝ^�ɩd9p*"Th��"�~yze�ְR���,���Am6Y)�ߖ�8q6�ħk@�E?n�?��*���"M~���y��!���y�N�c(~L�N���^��v�����Ŋ[��R���l���pxk�!Sg��ُ�����$��=��G�1���5��9^\�_���V�l��Fċ(�`eq�Z$�-� `.��j�>���_���k;Dу�<��Y|���ch>��,:����AcD]�OR[�Pơі�5�d)�-�B+ )Ι0g�s���NO����LL��i�F*�߱0V�`���ϝ�V�}�~'���4��I#`�	���� ���Qƾގ���[bم9q�� �Q,�:��@e�
�#4G��	��p0��<��>�4��W�|��٪�c2�[���0�̰9�zd����Q��4r��FN�4�{?>'N6�X)*���_e�/���@;#Kf/4�q���6ق����^��n��"��ɺ�5�ߚ��+t��C�MsgH�e��L�l�Y�e�듊v��qS��oQy�c�8|���6ߥ��{]��%�t[1�ԛk�i��	���@�2�Ls� �&%GL����H�9ldc��@|'Z�f����6�YM@�:a��$�HD8<�F_h�ь7������I�ʆ�����9��.���d?6�E��T��}����z�뽕С.@CbF�L�/�-�F����7�abLtU̜bb�1����<���B\w�HԕGD�tT��\F��2U��>�քN?*�?*�/)ģs
qr�P��:2����	B��9�՟wf�N��emD'�g�{�P�	y����WPCJ����.��[NWIQ��"DySi��ޝ�D��?$�GM��u�o}�÷���V[��?��I�.#}2Y{I޳�5^T��T�V�{o�^�8�{�;��'C��u������ī
`ϼ�5�UC���m`�~�Ò� G����	��{�q˄��(LI��+ G�j�1������4^��qk�$�'~��*�O˟�|�d�ʉ��0�ƛG��L$��&̡�8� �L�Y��}[�P�C��i�}<Y��*Oʪ�8# ��B�V�t�v�+'{�<��|Y;E�r�#�(l���-ԃJҺ*��Յ�W�-�)� �y+nO{�s��mP���(���
�ɦ��q�������=��a�[tAf�kѢT��E���i-��U���s�	&WۣG=������S��_�k�õ'L�D�ES��&]|������КXq������[�f{�ƇZ�"��@=r��K��L,����&��CWǦ�ȮƯ�l<YN�s�IжG[��1�%?<�x��ᾨ�U
��(�Df&iѣp�;�o�Y�t�\H���۫�-*;�&L7yaj��N�؍�t7�Dӹ�}Z��s5�͟��C��˟����N�b�������i�_�/�	���Q$e|8&mȘ� �<�}�s��ʣ5 ��L1�5@������+�C���цR#C��<�c�?
y��GWy�h���>)���b�\��a�)Ī|*���f,���G�Fkϝ"�C�f�U�\pw�� �9����3e���b��ф�XV֖`������2�������>����@gz@U��0�|�����6��Ea�t�(G�@� �okL�CJ]���d����잚KT[�O�#���%�kCls�߷��t>���k�L��;����Gga��V��Xh3}q��A�5��[,��]w�����nP?Lt|��@E���K�J��2OE^�PF��9���,�=���>i�1���C
��Vة�*dB���)V�(W�d�E�k��B�;2�`e���zJ�@j;������a.�8~6L��.j�:j˅>1<���V{癠�=CO6��̃��_��}i�43��ip�c躮t(7�+�TӜC��:��A�Ν�7��:>Jj;���݀j�kO�{4��5�����(TB��2v�4gL?C�����A�)Doʬ�'�lEF\�lVK�\/�VʅT+�H��,Y)�2��	��_F\nt�4 �$�n!�,�����IؒI)yֈ��J�y~5�c�خ���,���Z�K-Ud�JpmΨ���nw]�`N�N��̩	���=1V�i���{C�$'܀�4CH�4�M��Xs��@��=4�[0�����@��.��^����)`Zƭ0s&�sh|�\O�K��
����ֈ�3��#Y��O�k��즣�f7�0�7~�M�śPp8S�v�,{f{z�Sf[y�lk(Vc�Q��\jd��n��O��5�|}��E��j�w��&I�v���XĴjv�39'��J�� I�H�(U�#( �Ji�b�o�d�z��(n����((�t��.���-!��&22�-�,�-� Ө~͎���|�t�"�/[$1Ё¨cm/4͙i��dL������P$��N�%��؈�[�5�:�C�&P�ƷE
R�6����X<0V�����)ˤ�`�d���<T����,���-����d���������u�Dk'�P�*��+.a�H\h���^����I��n��Ή�1��#��s�/1ҀH�p�@�:�(��v����ʲ9�j2�Q�e ����2z���D{
��Nq�5a��Έ5�Rkq�	��y|��2�Fik0\���8���CR��ҲKB�4)J6!�s��٫���������w�љ��>"j [B����ٗ�Yh#̸ 䮹���|�G�LY�Ip&�^�G�&���^�����8���IZ$�V��F��;e��\W7�t��:lH�JZ�v8�yT�;B	pm���nR�UPg�vO��>Gu�:� �c:b�&��'�x��C��<xt)��Α�$���G0<�_v��� h^7��:�B���;�P��@���`$�U3��cI}�(G7�0bZ�.ezI;��p)�o���x8�RW� Ŷ��c��Da(��^��$�朏��)N��ű@�"$Ї���#b�wA��
bD}c�α�@���I�R6	f	ȤS��/��k��YD�R��_7lc�4��MsK9y�pX f�e_�u2��X����	�pY��)�Mb�:�2�}��v$���$���Z`9�@֪����p]G�Tqw����V���P�L������L_����3���_^��/�:��u|��I����D�쩯���ى���p3A�U}�7%Ht)!���uFI� A΅���M�	����$���D�^	;�b<�Q�*-�J�TeW���"�d|������/%b���դΡ�e�EZ߱�-F�QF� ��:f�_��� ���͔�2;���kt�8�Y��<zt�аN����K�L�>AU�Kq�L�D�������h�%z��2l�W���6��Y� ��U�pOa�]����X�R8�q{*�t/���G�s]��L��iN�M�Λ�u���ޣ#���.Qu�g�3<�_A\���	|�`�^8eT��`S��9b{��H���`ԉbp2�mL�i�x���$}�G�Տ��������*er��*�m/���    �Zk빈g�B�Jx�јr'��'�N�����p�
=Cm����	��`�#G9��
#J1��2�m��<gF�ڌ8YÕ2Z��	4&�s��3�6���DP	�C�'&"B�#����?�&�r���t�& .L����a�0(�� V�L�sdſHvI24�M���e}8f�������Fڧ��c�?�>$LFg�i抹�L�ۮ�
��wYsyr���Ck�X`�S~ƌufZ��)3��H@C�vK�8��ӊ�:���vˌ�}�����Y�5���ϠkEӰV�H��Y�Q��^��E���F�����#�ŋ�٨�o�AU��������a�'�멵�2�_r61h#Q6��A&�|��y�*�D��]��W<m�2/�K�E�r> 0�54CKR��ep�4Y���xN����0fpε�.tHf߳�]\�C��؅�9��8����P8|�^6.K��3.F� B�$��M��M�)�h�lDEs��0�#��Y��F����qȔ�'K0����]�!�NT���@o��ь��7��Qȸa={�O`�ޔŊ���g�=�����wfy��H�E�j�=����d����ȧ��Z|Yb�w��P�?�ۼ�u,Q��jn�}Z�]���v�Iv��K�x���I���w��(�Dˤ�����P�i���^KIq��ޫsX���»z�����z'��R�ע�&V}U�d<�n�r���`AL�tO����n��F��:S�ِ�����c����!���!����VZ�����n���o� ê��(!�D�V?P�șp6���i�:)����~ے&C7�w����7o�(YG�o���B��.	�.��T`��@\��M~x��̫
��I4}��-������ӷ����.k6�ހ�p^��H�SH�b�?yv��݀��I�f?l�~�˒���D�aU�2ېr�� 7�W�H`o�җ�i��wٷ9�ۭ���_atW
�� ����M4��O\U��&WY��C5^HV@�_>5�CШ���B L,]=�[���o��,�
��gS `�7%�VOm#�-��M�}2h�>�C�N�I���G�a?P��=��{r?f�`�J���c�#�jW�Ua$��2Ӳ=�&��u��~9��������ف��#TM�IŦ#��P�x�(�WZΥel���&Ž�(���/����c�%ꬕ��AHQ �E �03��r�..�6��:���0O+���Ä8m�&ʋ�Ecln��������/��"� ��V�(Śv�S�v�I��tyD��m`$LWf��&]�&^Ц6�x��qǴ��@5�+V)����*����}:,@t�Qnǒ��G�d�4��(��#��{uJ��>��V��FXAY%X%�c�"L?�89�
�/�|��Y��
���� ����]�	�'����*q�!D�a�m��T������9��p='� َ�H��T=�m:��<�KG��|J
]3Z2*S��J_h�[3m��߬���w?-�����ߥ�O�'�O��3�S�
)ȫ_3]ZL�X:js�O5�c��!�D,s�*�=�^�Ū�5�p�&AG�0�u=�.4{��ٜX=�{.�\��w�� ��j=`����Z"�H���1@�)wh����:x]:�n:'q�T�P^ִ��QĢ�L�T��9W����ݹ����1�\u&)��G���Cм�Mu�{��1��K��V�֐��<��f%�p������뱔��ľ>���p�����TM��	��益�ũ�U�T}�e�AA	r ����7I��Y��c�o���0��	I��s�����b�w-�XQ�h8cX���b���_�u.��KO�ѸS��.�ܓ�u��M�Ԉ��5����IvFh��
������9f�B��Q|��S����
�!Ψ�L��>�*��@�S��:�N�#ń�V0�3`_�����I=��<��.�*3�h��t�s̍��vBm�$pF��P^�T�#s�	���ب�	;�]ҮY_�԰��	ݸ�4=x��Jdb�0A����ۭ��x%��O��e� 
>��#�s��@@A`az���@�?��7EsP�4]4�Y�9�R�+�J?�㏕�1πU3J>7��tݳ��7�G�J��P�XT��0�1���I��9��Ҋ��#q�IT�)i2�}�>�d�D2~A$S�nn�B�S��"���� �L�>�=T�gb	V1F?J`[�n�"�ۤ��7>��@�Z�=@���qʆ�X*
d���R_�wKA�6�^ɵ��̺���b�x��-U�Fg,K^���K���s����.�r􇈳 �f��C��&�r%?i��,�Ħ��`.!�Hm�7r�dH���*�<�8�+�1�Λ�FD���c�;��XK�@����0���ѥXw-['~Ew	V�p��f�Bzp�5dX2@:Ҿ6a�5�0M�U��d~w�HO�΃/�1}B�3)�a���M(7K�T���?x`�\7�6�
���$�T~�x
Ҋ*�|�}СҪr����0e�1K�eu����#wmM���:q���b
`�Vɮ�1���a�'�C�❘�%���?	M����ܮ��f�@�@��.{�U�� �1���o��֔�1�F���@�Ȃ�i;��с��4u�B5Bu�^0|��ޣ��:�d[×X�7����p��ptTE���4K��20� ���v��v����h���{Ep�J�`�/ +�C}K��P���1���\�¢c�����;�79�hs����5�҆@l��1��O�Q5�hM��m]N��i��c,ց夶��P�=o�q_%S�г}�����+͆�ep�����ڣ;�VWϋ�;ýG�Kؾ�u�J���mY8�x.��4f�^#��?��v�AA��L7K��V.�A
G|L�H#��A���{�&07�~���	�As ����CoJݱԓ(�/
JZ{L�I���0:���h�%%��@�WO��˂

��f� [0J�&4�s����$1o|)$���@��е�A<䧍{�Mb�p��	�:��=��X��m�����}�2�>V �m
��%����n��똒M� TSƮ|D�������([O���OWX=�r*�������_S�r,YWZ�X���.�<������5.D�9�%�����Xm�K����ϮS��.��F3�,
�[��r��{ͅ�m�kPO5� �����^�Ҵ6#���=��}��;�U��aO���ǲ����m��r;�z�8C��E.�Q��ԧ>F5� .��x�KTW�g�N����<C��k�@QE�=#�˂�6����O%���-���.�E�t�]K*1�z;Y��;2h��*�eլe��QI��3&�5����eB�}J�`�hP�Yl�{���A�:�sӕf�'�r�o����j}M�Y)Ƀ$j�O������c1����Y?$Q��<��o��%����t8�_�Z��Z	yF�Ů(�ؔ�K^t�2���}���ALzIέ�s 0/�K5E�z�.T��W��%��is�/4����o����6���C����dǮ�m
 �=:�R��a\�[/RL���S7��yf�oV���	_�d�,����@�j�W��_Ov	23N.6v{�ql�4�8��k�T�u�^�u-Y�H�U�EK�v!#�\؄��!i�Td��4�+�:�#�%�fD�F�px��������+?}�*�ұd����B�Vj�0�Zl83�D
!�ѹ��V\H^���Cy��{,�{�� ���|��P-V�����aE���9iΟ�i*��r��Ɖ%ƴG�."�U�&:��9��8�6�s�E��x'����{.�D� +'�Q����ڌ��/ZkᏵa�Ħ �9�?'�"l�#RJt&RBK�#��ʫ��\��w d�0Z��D@��ES�䮽������4��5����]|�ٵ�~F1��u#����{4��jӑ.���� Y  Z�n1ΌJ=ǚK�J���h��AF]q�1��
���4G���iU�
�������B]��-�ȇ	~R`I��|$��稢.c7�ޣ�LF��ao�?�Վ&�[nԅ�9���k|��鳞@�d�P_1k*x��I���6�.`��Wx����5���2�+Gģ:c��������k�Liݘ�p&�|��O�`�ǌ�,����@�8���1�����t��I,�d�՘<�BEPR3�_h�3`�_��e����l�(�Og��������X4*���5��H��\�
���(:H�����nE�n̠���ΘA1�
1ǒz�D~��a�N�s��T�1��Fq���i_�3b�/��HK�Y!Ĩ��nBKK	���Y�l�2u] ���##��6�j�����}v���Op�mO?є9bS�(v�����W��6�zr�2��*s,�y�^��sjyEz����F��}��`-�XP�a;k��j��xb�3D&ӈ=��#г9-�GMJ�M�p��؊~�h��Zb�k�:bDK8�8p*AJ:���Ą��@uZ�c,bb$�[ey�$5�4ε�.��'$������Duv�v���}��IlQ�DJP���[LTE�ʉ\G}u��K�Hx�v�ĹP��#��Em����m��՚&��7�gd��$]2~�O~@�a?H��Mߐ�6Kާ��/"�}�¥�II���	\�����6)Mr���v��s��ڣk�i���8�e�w�rq��'��3���m���(�.?�I�.M�H��_4 (�Ļ��e��� �R%rn��T�1%K��]���,�=�6'ʪ+h�s)F�:�A'M���G7��n:��t���	���D1�B��ȉ�c�;�6m���.P��-SmE�O�����=a�xS�Bp�v���@�s�Ȼiu�%�$gy�'�+��O^I��:���:~v�NP1W��{�
��)���@bn��MZ�~�Y��ۀ��?��S	��c��~��x\�,�� Ӄ�js�Tm?�<��ʬ�_�c�qY�	�m�@ԦF���3��ﱲ��r�O*�ڟ�kJ~A�RȄ.i"/��Z}r2-�uy���W��DtܷA�sF��1��3�v� YԿNi��e���U��c���Pb��s8ôZ�̓��,Fn��ڧ�,糊{e
����9�2ǼL5�d���)���^ Wk�)B�m9����?�+��~���8]IFO�VHyb���:�4��!�I��ռ�>e�����5�F8��/�S�3 _|�$��U̖�t����И�]h���>PL���7V` �!0�eH?���>�\���"E���)n�6�6b���"%���7�Bq����F���f$��@N?G�p��}��QQ������m�w;t�|���2����߂TR�	qe��HuQ�-���i��G�LO���~!$
`�#Ŵ7Y
�Jb��y�X�7x8Vw�hMY���>q��ፉMup�Y�WI�z�������"Q�$�n)���!��F6�}�z��	��=�~*��i잋�B�D-�����|I�&ק��L��ν�y�x�|�+��B��\���g�5O61c���;����۬�p����¸�]m�hcѣ`���{��r;�y`/������/�>����l��tfDC���c3 �`2��oڢ>w�0��GDd-B�\�'�M��!���ڑ��	���L�Q�#Y{���k�Տ��@h�֖0x���z���$bjO����8<�O�Udğ�Y���=�1���W>|���Y|�w��3iӵ�E�H���$�2���Z��1u����������w�l۸){�`t�|��iW}.�|��Q�nxn0V,>�^�
��CS0��^:�V�����2G�1����Z�v:�-�G_������E���h�^�p��S䥻S� ,?Q�H^Q�)zS�f�3�o��>�j�=^1�')�pS�HIA�ƸG�Z���c}��>��ߵ�%���UW�(����m�J��[�"?P�6��`ƙ�}�PE�
Y�]�V���'ʒ�F1���:����)�/�E�ω�[�u{nӪ��4*�s%f߸5fɹī\�OX��;&[m�vq���`[�C{MX4҄R!������S|.U�qr����|@J#S�&�#g��`����#������f~�Dxo��_�~;uSQA��X+�Š�B*�-l��?�+�VuUn�HBJ���J�^Ne��bF�|8M_���1b��Pv6ș#@�STPN0wܡn��C�~����}���<y��Ӟ��bZL�!Pya�8,GR4���f�ほa���cw6CM�w�8�������'^��6X�UGr�q	�P�u�D�6j�y2��|�J.�*N�~l�o���"�Z�y�9h��2a��=�4�f�4����
|�cT�G!xuU�kC�@��Q���.FU��zy��	�̕����9�جQ�w�������6���0l��0Yx�M�QȀ���ʰ� ~�T�b�M��oz)��9	��d��}X�aR#i/�Q���f���(>"�iLK�f�g{gԑ��)�ߕpNIw���L �Apf�>��T�EZRvEK�g+G�A0����9�>��$�0z,��r��ĪQ�� ��lM�IOb���	*)�X�f�cS[�xd�t1��������X��]҄ŊVRO��������o}��m�mb���ٰ�1�ѤpF�H��f�A1�˂7��.Y�IÔ��^���=(5q����
����X�p2��?�2d�+�,�儰&R����sC|�6E6�UC�Rh�J��|�}]�&����j6����>_��Hd>�7�E�z!� s\�0��]�b�.������      +   ^   x�-ɱ
�  �Y�Bܕ;O)�GZZD4��=���P8pހ3.*\�C�D��E�B�DL�zZ��e�q��J[���-լY�f����J)_�*      -      x��\�RK�}.}E}�x�E�G8��c��㘗T�@]�P��o�c���;Z�f��������Yk��R	�>3��v+��2w���k�tٛMfg�'�lr�����hv=�zˍ��2�e�z��������������d�df7I�� �����g_�}3h�b}O;�>y��S��ow��D~�ۖw�сi��e�?��p<��M�cL�H[���~�����]�Jz��.��2�9��2�W*G9���޳^�4�-Y܉|��{5H���^�<�C$2��';��V�Q���x�S���4+����%�ԩ|��9�VL���-,nl��r͛]̾`�z�Ig��p歚�vf��r�jZ�Q*�=,�/�Lo�����`ɛ�B,'�����c�Aٻ�~Ł<O��-E��������0�v����	V��[O���eU}�GY]ὟT����LƘR��&'<��m����!h�W��?�F�����0�`w{��9��bچ�c1�dHIn��򉨨���(R:�$�u�@�j�=����\�Ӵ���8p�C�0�[�^��Ie�#o�O�g͝Q)�F!����a�Jߋg��coy�o ���W�����]S
�t�Z�4�=���iY����h��I�;.�e'7*��J�>�����a(]�e�F)�d~֟�@Teˌ�_��W
Å)�&7eU^�jp��Z��(���J�~����Bdg8j�E9��T�Qˌ��/��?��Bv���@���e͌�խ���@�W��'��$3��Ҽ�o�Ԗ�IBS�P;�{C�3]��0-q����Wŋ��Q��k�J4��ks��z��{i�2�ݑu@2���i���V�c-��I�[�"=�SL��	�G�R��f���1ٸU�jO�����5�o�8��fW��޿���.9���Z�,��	uK�j3McS������)i=�l��9��c�T�k��S�^�K1���^R=��^�l˴�Hҥ��!������|��Չ�s��G�Y=��^Ap�tD�6�6�\şM�uj���"��{/+���.��;H �sل�ŵ|�T|�[�[:���)�u�����Ϙ#�~j��Y��݉�Me�r�[/[��
��uZ	٘���R��O�!8�RE��z��o�S���-gM_����ŕ0�w���Me�6����]�;O4�"��`���C#3�vOm%v��:��h�������/U�RN�v�7���N!�RuC��	\�G���h�j�*5��X��yһ���c�l'�R%w�Slib#I:�=V��diu/+X�t��B>���;1	�N�j}���7	mϺkLx$\XXXa�]\�4�j��	��[;wg
�Ƌn����^�ZqP�G�Nq����f��c����3���Ӥ���j.@���z����gf���>��j%8C�U�sj��������p;�%�,��,�(�\�A<����NG$HB���y�y�3d,��ᖿ5���5�`C�sN`�|�8MwJ�ha�xOt�;�Z�`���	�d���*��@�3��up�=�fO�F@ř|�c�>e�#f��:m�v��R�
����ֶi�M�n�wڧ����mfp���îQok�˽LR0��G\�y�7.�C��W���j���١�ףG�EE���MCE�Ǐ'��&[��s�}��D�xyh2:���❠�^�#~5K�<~]n9VQ�,�C.��3�'���%��z���� ��?}$��O��Aj�9�y��څiوX^
��;�b'��,'�_�M��z/�tSa+Њ&��������%x�������$]hh�"�)/U��;lUV�'�Zs�R9/e��?>Rw�ǐ��(�/���GK�ѫ����*2\~0l7-�qj?��e㐦hn�eU���E�Q_Yv�V��"��eу��i>�Y@��ewT��d>�򓾑�����Y��w?��hɭ>��V�����=�}��,'����#���AK��.e�=$!x��ӝv)꒛q%v%A�ݔ�2{  �p ��n%�v)�� @q1vH�4h<٦ݖ����Ԟ�^:����09��t&U]��O�~�Π��F��(���4l�`%� -{�p&I�F[Dd�\3��\��'��Y�o�Y���<���!(��9����W4�nhA��-S�cIn�-�Lv� r�����=�Սd6@o]HG�$1`:p&���e%��1ǋs�1��}`�c;����f�Ϻo�x�0s��3�����b��KӀ�f�N)�!US��E��ʋ�{�T�&I�����DK����"Ӵk�����H�0��:�c0O��J�<rfp��>�ig��܌�`=M��C�u9g��Ox�	IB����%��K!��<yc��%���+(�������f{�8��|h��5
�D���ʧ��p^��V��E1N5Qa�y�m���������t�P�̼�-e�4�
nv=�ɐ'4|�VV��u�p��C�)�,vt�����l����i�#�/��QEm?�"OF�r�X*��_%/��6VsXR:�Z����#���1�&{��m�	��������]�%*���Ř�`�\a,������f7�T��J��5ѕ��*yn��
,�zs̱��#��H���5H�ޠjΣ0\9P�LH�A��)�J��V�)�܇��?:�a�7��Sj��x��+�����a`9@RX�J�M;{t-�t���u:h5��c�Ï��ޢdn����97�hӝ���>z����ϘR��ɑ������M�_̐&W#��So$�n��(�'���3����M��z:$����-���x�m*=7 &���B+\+f���y4�L����*�LI��A���s"��x��8�������O�N��S��p�N��\�� ���7�~�nB-��o"�3˾@�PJ���/~-2���r��O�!�f8B�ή|����>�!r��j�aifr�!b�P��<w%Ir�BK�	��։0�G�o-�#`����<]��L��������}_�w�p9�P��ѝ|�ڼW=�M��j�P�P�iA)����1~���"�-��x�~�����>[㲵\�	¶�y�9�����6�x^�:pf�e�ؤ�~G�1^n��`�{p��s����6o��B܆��oc��ڛ1���$me��f��)�K`}��2�W���85` ��Z���$?�¨i>�|�8Sq��p�*����B��ɣ�`X���:n�(���~*��n�+^���\	-z!���t��kx9�<,M��60�[�� fVw�I�E�:T��3��Du�O홉�/���ب��!�ԕ߃�0��B�>��+aX����T��[J����@
�X�:��JLKΰ4{ru==_�@��3_(țP�"�KG�����{�D�$���XDۦ?����ll���H8n񀀝D�Cks�|��l,��f�(>魶�ۈ��j�]#��q$Htn$k=(
KR�'�s���ч{�(�IG�!0��nz	1N��b�"��I���� Q�Jvu7O;L�@���Z�\8� ��'�pXM%�Ŀ�'����|��af�-!vI�g�Z�/M�%e�|ɏ3�:߰�t7�hۣɑ�����^�i�&H}��"R^SQ�<����`�Ҝ�?�Ԃ T�!K|;�v%�$x;١��Y���9�i��9Q��rťVj���.�6��uy?���J�*�~�mC���$�Lg�Ҙ���ռ[����A�+]�P�[1��aM�L��c���V������U+�x���O��=���;Dg�ʣҢKы�E���g�U�����`v@w�t�v��\p�W�ǋ�.�<�η�
x�.rT��YNQA%G'���ʚ���<֕(HSִ�H�f_����h�u2�6{% ��QO����{^��B��d�*4��,O�
�T��'/��E5��Ѽ,�N��A��������DiuY�@s�֡�vW_��s+�!t�|��V�1�>��AN����B֒n�bg2�ι�*GȦ��1�lXf8��@�X�����.��,�M    5W��]��`��/i6D.�֫����\������.���CxT����7�ފ:�	�E����>L�$BO�V��2q�W�����
E��7������]Q��*�Zr��Zf�j��D;�S���4(���fȌ���"n������2./��`.���H�Y�\:}nɵC�_p2 O�;mX�+�X������`P�1�������!:hӴ+'�vP�-$*_,q��DE�̘�M�s��MK�PN�]�v��°��d�o;�Y��.t�e�������b1f_t���z��,�M�����|X�j�7�.+�e��%���?�9�[���e�RT��!X#� ϕ��ꆞGy�:��MU�7��>����AhI"2���r�"�9�e�Ը��(�(Rh�	q���Aϴ�c$�$��?�4\QW9�W�AJː���Y�%"7{mi
d���A��]��r�&�i��R���ߟ���;���ٟ}�J�"�r�LMK��G�Z�
�[Ҧӎ���#a�Iv�iGs{��>�C[O#T�B�=:����_(�����Tz���ט��"� ���2�u���%&�Q�&*R�'ɼ�)�jb���b:<e��%�Zh
���fvM���Ec�0���v-�|�\��Dx��?�}.x�����Ԅ���s�_����q1 �`[�:�T1f�FY\�@�#I��a�A��ʰ�乌x1��rw?$-k��ߤ-v�e�qb}8��p�H�T�؟6g���v4b�;��y�D����5���?�l���ᔈ��]="
N�R���t1��9݉^ٰnĮ\��w�-�Z5 J��뷬$4���L��b�jz�g�����r��/����჆���� �|���B�Chì��'�K��n:x5ds�{y򈌑	#s�Ϣ�7���Y(i�.�f�����������������>���i�6zi���7�_�~2�_��B�c���<�^����J�,����F��D�{Do��_Eο��Y��,��E梈|��B���<�`{4���V+U�N�^h���C�]�>��$M���/&�`?�$/��913��|J�`Qi���"o1��V,� o��ИO,͞(�Rޕ�!]:3����&�.c;��_'Hb��qɃQ|W�fZc�韺��`y8`�I*	�rZS�I���b� $�t>o4�@_��̙3V)Y2�!yI�[�����I���}�d�ۤL¨�8��	�.���/�N;������\�=���(�"�p��C�ia$���w�2d簏����<����d��bt*8�V�7{� $�L/�s�2���T��57w^���ƦHQ��;�d3m�~Ja�@���vf���\���[8������0�wg(�����ؼ1���=;��K���"TG����̏ �P�xR
w�����	ߓ�]�%�'�(���
�ʒ�J�@�a����']{:� U�z��/�CAR�r&�D��g���3��`J^����L���0O\���3�[]�AD��)7H~��D��T*qq&��������1ux�1���@�[���a�Zh��=��U��D��c_��[Y5YNGj,����!�*s��4N�]o����n�U��d$��0f�aa����l����/D��*$�j~��ٞXx�{M�����	���-���?σ�&7<m$6�4�ᩓ�zNZ�rQ�s�9`%��c��^O�g�1�`r!3e)�y&q��f$�����9u[��� �	������&�%�����9�E��oڰ��w��j��;{T��Vj��l�胷-[a-zT�X��Nm�+�ɘB�Z��n��$z�2<�"���OO��'n�L��;�؁h;��\n�A�8��;B�9�!��A�1�\������S��X_ŖD;��So�삄-��^{�.�Ou�`O];Q?�M�Ӈ�		d�=-)�ܤ�$?F�}�
zM,%ɥ:%�Ǟ&Ȏ��Q�&[��T�Dna��@���d̳�>fH6uO:�:����݁�����7�jԕQ�l�������������e�0�n-I;�_a'ӹ����NSl`����oLG�k���7��,��Jw�c�B�Z�z-�d���:i�7�猖�G3��K�cw3�G3��m�KGI�ͭ,̕[C/��jq��wr��Ƶ���f�0nF����4g�`X_�^ш�1��v��r�I$#�rADZفܣrX�X�r�Л$ T���.g9�rwc�	��b^�ܼ��]&�#XS�^��傼�|)��Rb^KG;��~%8*�#�T��;NoX���M>KW�We�ɒ�u�<RM�H�Eu]Z4���]�\�c�Su�}:G{�ޖ\m�Q`���26vBF�>P|�b�~8v���R"!��?D�Wڻ�?V�0�/DNOc����-�G��Th��,ڨ��ԺL-�����Z�ϯ�ELh�Qx����F��mI$>#�,:�i)�J�5NG���g�l�U�(�r�xC�������=6�;%���l��3���)�+a��,岤�p#Wy��#�������K&$r��y�,aF��(�F������$�h�2�&�s
�E[>(�:��̓[�l�/��x,m��KB~t�-r}���^��#����@򣯰&�º��~҆M�
�Ѕz���#
5�5`�RT�M��F��lX�\��R�.�h�Bĵ���-���}�.��@;���%M�[I3+�A���9T�N筶���NhX T��7RD�g��vU�⨰G�W���`I�RL���P�������M�k���û�����$�xW<��~��2Z��+�˻P���y�Ӗ��i��-�S�K�M��"��7��.�{��ETuR�~�m�6c�̻��Z�]u�����.[�v`�\n�
6(ƆM+Ix�/,��q��}IC�ˑ-³���\��`�������v?���I|�TVy��?$BԀW=����4��u���Z��A&	��|��"��X�����锸ֻ
�rփ�*{�x����b#A�E���L�5	p�E(�H��@Z7��6�(����T�����y���s�S@�t����{������u�i�@�#���(	a�U:�$�<ѧ�<׺ƙ�q�zߌa���Ӫ�$�q�����覓�R��4�1m���_������� ��6|N��"�m���lih�JZ�>!��7U��`�IGP�(r�,7��j^��"wˊ��J;h��\��n�vx�3� W�� �co��|� �[�S8�a��Q��V1j���*�^/m"K|Xs� <g��e
��L���e=�%{��9R#���1�:H��j�G.g����ݫ�u!q[D����I�r���6t��\Q���HM	�`������ǽ˱p%���|S�U&����/6p����i�~ݸ"������XP����ls��ĕ-�#A&_׊��vfy���@Ӏ�Q�q�2{x���`Q5<�eQ��z�9���%����SD�jZ{,hE��q��7o}e���/�'�7��:��;��)����`iJ[*�����ZnC��b�a��{G'�Q���h����������z�u)1:^�a���&F �.�;i5��>f��?���?_ۙ�� �8q�	��ty+��%��mTL������rF�w���!I
e:��kX��2�I�"O� E0�rHS�l��T�{�	[��0���æ:@�}:����a���-�Sv�8�u��P!���&����Hq�P�ꃆ��o�Op��BTb��!�B��ѕ�E��o{8ֻ�+��mjXz����Y�;�L���+��]�Ϲli��6B��j~�Mj����FE�U�?[�{m����7g4���[@4���i�U�Vɏl���H٥�D����q�k߹���$���W�^K
�Q�wk�Q=���ֻ�8�����I����=�'X{��I����1��ŮwgJ%V�%Kq~.#R���"X��~���]���Sq����[o�� ��\�ïJ��g�#�j���f��� Y  �F[�M���!(��fMת�u����24��-�'A'�3�imm/�ܽtA��֚��.=��A�p�.�#��WE�Xm#�/�7�b���)�F-ӣr����߉���]������S�y������+b���D%����]ݤɐu�X/O�0�fw�,"�v��]�Uķ�ļ%׿2����Vn�Ֆ
��o��e��`�г��-N�Z���뭄4�����nD�p Y�����Pd|�7�-��HU�A��á¥J�=Ǝ����Z����bi,Q����7-�Z+�G�����K{8�,u�~�[G��$��T�X ���|�eJ�ɬM&�z���qC'\�\��0�2�ǵ�a"�ֹT4���R;X�;S��a�����.���Zl������Y�d�[_8�K(���ג�0Vq�/
\��q�}�r	��^�a��>��\�<���4�V��=)�Sq���֋n߉�ϝ���&'�ҝ�[�ӐW΍V\�?�F^��L��Fۉ�LA�x �1,/��rB"1�(ԝUõ$�:�e���vgL��9�z?yު�ɫ�ڦ�X��h�HNU�K�����Ҏ��G��)�wG����R��?���P      C      x������ � �      �   Q  x��[ksT��<�
��o�^��o��y�۰P�J��l��k�>R�g�o�\�TH*�lt���ґ�.0 < ��Ӓ�b���D\B�s�����_������G���t��ϞЧ��޼8w��e����x~t|�����Ed1,8 �CA��b+cX
(Qb��!�Ą+�k8�-;�|�����b	qa!� Z�vtxq�+��S]X��.)v��ː��H�w!5������Q�CYD8�_���=}�������{��==��w	�9?������� �)C�.4df��_O?7~�B�����.��vA�h�<@]сwF� �ߴ�0��%�]�
��#A���5����u�P�����'w��q���!b�d�%��2�� Ϟ4'�*��Ӈ.�(�*,+���A���`tRq�`�NI����`
"�ۣr�����ɿ��^��bQu�@���Y��8���z�m����,�������R�!8u[&��I�O֌Y�vɔ1�y�eČ	5�@�~A��пQj���%'��<I����O��_������ᣋŸ?��ŁԵt]�c'�?CbD�l�$ �~����ޜ�G�r���;���7�6� �����[וF�IfI���3��.�y���n��^��yx��X�e��})	sO��G��FH�D��e�4+�Y/�4�x����
�������4�ha�v�*��z9rY����G͑z������.3�	*�wK5�tU�Wr�e(�S�qI8p���y�Ǉ-qx�����������a����߱������x�+HW�b�}E{IM�	���|����bN[?�_�h������ �o�C	�;w��y�zr����X,�vN����[�,�g�?Y�k�N���G��JS�:|���������O���|5.��|%�%7�=�h�O@k1.~4����˯��cK��N��K�<�3 ��i�A7�l�	^�Q�����?>�X"���;��h�eI�%j>ͱ���:�9i��Wy|������0�$ÈV�[̨/"��� HTH��X�F���=������%]��"�h������C�<�f���)��\���bV�o�n��zŮ��xdЂ�R�hJk�㏍^���O/\,�E7u���"E~ݶ0�E�X�h��H����!j�[��Og�C�fz����7�],�YP�3�R%���2TE��g������F5DX�����X�����Z���),�j�� �J8�	��_���n~w|��/K*Ff�uܪ��(���x`�D��T��?>y�˓�.�h&\ wY5��>�L{ ��*�78��MH����L.�T��'vx����8b�>��z���fIǏ���������=s��۴�msR�Vd�+����^���%�ܡ!e�i_�4�+�:���/�6�?�����#K\S
N{�B��j�0����n�ֲ��ɬpq���?�O\,�=mF��E�AO��N?�����h5*Pnu��lG������S9K�~}>�|n~����M�؟���Ֆ���b5ih�IUpM���$��[���������w����xР�C�3�P�i�kdY�T�֪��=��(�XRm秅1mZ֖l�R�@�Rs������~��޽��߸X��V�v0�k���V�l=u1#�7-��hg��O×�{.�R�۴����
Y ������,e�,���6VNnN�硋�$��h����Ȫ���F�^X�Q��[ͿF0Vq(���W?���>�G|q�����~L�h5��VX��Je�D������K3�oo����XZu?{�s荳pG��A)�4R�2�fjg��������_|�~�c�a.���]�b}uQ?C��
a4���^ў�����7῏ޟ�XuL!8���3$D�Y[m�(�]q�q�����Е�e�lM�Y�t�\�Gr��:'�0$]��K�;RI��2H�w��u�(b�NTwvU�K���zJ�ך�M\G��a+��q���'.�A6#�fp}`�㒴[g`Ȭͅ��ް�*�U���k鐸M�9�F�+8A���d`�#g�h߫���2��3�`�(R��z�XQWM���ƹ��
�#w�Jo�Mj�@���rN�"�R�+2A��+�>M�/�L�[�>@Sc���{g7w��AwG���q�{�֦h���� .g6N�,m���Ԇfhٸu/䲖9���6>���^�cU�9úc:/Q�Q���߇��0ù*�,[�\�x7�~/䲢��Y�d�δ)L�����5���$+v�W:Q;���q
�|)�#���]����&��4s���R"X^�$�$����$ڕRV�e/�'>��3K���|��~d���;��}Z���� ��A.k�Ψuf�Uz�y	Z�C����rY�RC��i����wp�x�1��w��ʕF��*��A.�̱�MG;���3����Ȁ�27ݜ0�1�ͩ��4M[�����L�ư��͍Z�H�fB��C+�J��==:��ܢ����K~��Ŋ��noR�b�Xob+*��ޯgʹ;������mk�K���6�齐����ޫ��&���*�7����x���D�$el�ui��K����y��H�_�l4����9E2Ʋ�l�N���^d�βqːrI 䑒�:J1n�0F;3�̀t�y��Z/,P4B'X��빰�hMhQe���sߚ`kZå�^�����A�V��vP'Y�.���1i�VA�\V��q��$ٶMͫ�fri�h��7v[����Q噵�}��rYKeu66����I��0z�Ǌ��uX��t��0�� �����S��6f첟���� 1frYy�)�bƑi�zN��b���\V�c�ִ=t��[3H� �5α6�ꥣ�-(�@�<�eM>+�m{G�n {g��4c�A\Qf47�eڮ�Ґ�Pr�4U��e*��Q�+˚��J�ԯ�E\N�2�-�S�]r�?t���ro�IZ�m'��qL�C\R��T�-gk�������޶)�渳�-�ҮZ�i�����46�1z�K{���Y�iMy�ˉŃ\�2�ڛ6I���(y�ǚ�+�޴]�1��{�E\�z\�e�'t����o.�~؃\���kjĀ�m���QkJr!����y�}�n�R}��͚�,*��J��4�ͳ�,XM��ă\�2S������F��Ak	3�z�������+�&�B;%�����xy�{�b�LF���rY�X�Gm��L�9��Jd���+���+��<�e�9V�L�������� �uF���E���[
Z�\�e���z���d��E�-A.k�c�Q��l��������4}�}�B}ow�4���9��=��u�䲚���οQZr�fr��u��r}�g�,H��A.+��+o��W�ў����
R� �uո:��δ�/����_�rYe&�6eee�N��Ho.��B.k��pc:ڵ�M	�`�B�䱪(r�[�y*�1mQ3d���z�˺�oM�9jNG���l?�,S(��h"�[�i�PU�$rYe�u�AP��P}g�ړ�����1��i����5����X�a��t�Cg��Ń\�\Y�+cgZ��]�e�cK�Ѫ��M�G6ZA	ك<�����ֱiY?;���<�eŹ}��t�G7���k��5K����82�#Z�8��+��!���(s�5-6���d�r�q�+�)��Y�{t
`&rY�T)����d}�k�I<�eM3�*�3m�ֳ������ӧU�7M��ۈك\֚#p��I�AD�WkZW�y�*:�uz_ǉ`��c.���@�!��f�4}n�w#�Xj']�����̄ξ���`o@�{\�e��/�d&��F�-c�urY�~)�����Ν;�>r�      �   k  x����r�6���S�-� �s=��=�b��$��g֮�}���ȶDyg&3�E$�:7�	�f���߆�'�'
-�>�>I�c	1V��Y2�1� PsЂC����a���&A�㧀O!��}H=b���BM�G�L�$Q�  6q:��y�L����XD*H�4�D�bۮ�������v�^�an����@]��*�͈��0�u&VP1#��������`��1h�1��x2N���� 0���d�G�I�V���R���YL=a�r�
�X̸��f9�Y QͶ���F�+8�q!�W�
�
F3^�l[˲S�2}���ɖ�_^��>-�>�aWRB�
�����c���V�=f�3]��)�����>������K��ic�r'���c��̄i�L�),f���e�g:֦�`����}�9�F��<4X(v���\*ln�p
�O�S�-6�1�D�I����t���������\o�����ڜ�]5������
�܈�3��	�H?`L�� Q�x�5�_���Ux�{�v8�,�� YA����F޶ԞKG�6�+���^ᴇ����۽)oP�,j�t�~#b��3u�������n{��>��3ʷ�1�����6����\D�"��Ӧ���˪��P*�]�˪��a��NĆ�G��)��'?)�p;F�\B���-A1U�,F��*�7w#5B �UqI���r� u/���T���t�L�b��`�>p�85GG2�ѥ.$�2�;#��:zL��O�NlTQ�,�H��4�B��u��N��LgO��/"�|������O K\N�ꈻC`���XF�TA`�z)� R�<�F'Fы���� �Q+����DhۀL��A�y��D�s����<܇gXNM�K"MQqZtB`wUQ]�;/�o6�kv�A��/�l�SAa��jΫ���mA����3��V���y�/CМ*����8�
��]B5	ٕ@����Ě$ک]Ap��|�����"Z��EW����y�@�;��(4�
�{^(�P�/Ik���'�M�Es��;N_
�d`A)�*����q�l���!ڿ�i��{̝ؕ��)~7���$*A��(�B�{ �u���         �  x��YKs�6>���s��M@���t�ImO�v:�s`(Hf#�.I����wJ"	Q��p}�$v�����v�\I^Է�D����7 $�x@1�SL�#�g�O;���1x����o����Nǈ�g3F#%4ѱ't�ID)�:d���^����%�.���P�`a���)�SFf=,,""�aqOQ�( a3!#)��E+−�$qęL�DD98 ��?��[4���>�E���׋WWWo/8�&�|2CD�@�:�Wn&�it>�j3���C�ԯ������\�%�s�M7ei���Q��/��mm5$e��'���v�[T�;���;��T)�^gE>��,�uuUf�����4q��e�p���Hr��k���γ*-6y}�ۑ|�Zuw�qg�]���V���N�(J�-sSvgUJ���o�������~n�@cS��X_c�������6eRf;?Γ�ݤCK0q/�(��(��(��J�?��� �gLFJK��^D��y�#&�q(��b579�/�h�:Gfij��eZ�{�ByVe�J�ʔY��ƠE�I��
�E�r�"�O��d��b���%ym���l�YR#�ɪu1��e�f�<j-$uaM��r6a�u��9�)j+39�`�z� ;C�ͳt��g֛*B�$&+��T5\�L����C+�-L>G ������m	o/�c	�.����5� ��;3GI�n�U����N��AY��5�ߛ�ʑA�
X@����8F�dJbD�P��0�9{�����Qq���!T�g��w�<�֕m؏�SP0�\dLY�(�mǠ r�{�s�E��_�Ҥ2��Zq�>+sW��Y��`	rLa#�P�������~��*x���T��?)�,) �����H�����Ia���6!���Ia�TELa.UDڧ/Sϊ��m����hV�e��uN�tՈ���1���%L~\��MH~����Q4w�o�F��x$��R��B��>]�BW&	Pus3��vqsS}\I���ߝ�zqv�KX����2Z����q\A���$��H�tb�q��Pb�YF�Q����KQ���à��m'oAv�}�s��n�~�����<�o��~�_���h�Y'u]��m0��&9��~�vS9���x/�����/����@�ɭǮ+�ʭ���n X�Z����g

�'b�L�(���W��.6�Px.�����#����T���a�������l˶g
q̄�#�z�����^{�лn��`�!m�W���;V)���8�Li,FD!�}huZ[§¢k�0�!叇�m3��Z��B�h���5�+o� �Q�
'fm�:�S�u��t�N��v.b�\S��eF�WW)ʞ����9�K6�����=�oW�''�%'ɸ��'b��yXiܤ����f����ڪ��y}�][ŏ��ꆫ�:��d��c����w������x�/���g�R�����E)�_���;qx7�8p�7�8p�7����4�v�+$�D4%��3�(VR�*�P���6���Cg0Utx>Nv�T�j��wB !u]�Ƃs�l�`�T̕)���5�.���%��#f��P2w�/��#����#��� KAg��TB�d�mK9�t)�] ��Q�L���@j4�=2���n0�{dD�o��@��7��ï.���?-L�����i�iQz"�(d��K*;I5J`�	�@�Ө�_&������=8�a����P	;��3�#�>��#l�2���Û(���̈́      �      x������ � �      �   4   x�3�4202�5��50S04�2��21�3����0�'������������� ��            x�Ľ[�%�u&�L���� #�;���� $E��%[��yz����> >9<�=����R�����	��_�o��U��v�:{7��"�N�/ok}+s]L�NO�޵����x۪x�y��	:�y��w��F�(��S��T/�9hBp{M�>}�ί������ҫ?��:��i���6(I�\���{e�&'cPVI)�2�����>��}a�r�B�v�^(�Bꃴ�:N���5<}�����o޽yx��;���}wxS�6��m����)��I������^�k?��9�q�%��U�,��Y��H���Q�Z,3�>]�p/�>�}8�^�x�*`	�)Z��׬A���Qm}�K��l~�F��ޜ��p(-OH~�����V��#LK���}����|��>~Yx��i+)$�)�B��$��{M��P����M����1n4����w�\Ȳ�"b�ZX���\��d�������gю�����Nk�p.��>YGت&;+l�A�V4[�d��Z���(��������v�ufKP=M��m��Z�8Q]��l��U�V���2���G�t�.�s$����G:uL�;�q�"T+E�*&_zr1_+o�8�F*e}�����Vŀ)S�
�X{��
F�(�\H\>q@k^(u H}�����N�6���T�e�a�!h���k�����(��N�ч�?�ُ�|l��Zh�C+H���<��4���ڝ���7�����7������4���;��2��7@0�������_�@���[��������o�nS$����:S�w?xx��6���h�"�����t�nY$�+��_�A=���$ԉ|��!��;�E�H-$/4d���e�q^$m��,m.��'n<N�Yz|���7w?a�w7A�w��� ���?��c�f��p�3��^Ӵ�75���{v"��.�����J��n$�Ez)��T� ��o{N����Iף����8�v�@=$T�X��*��U�&� Y�O��r��(��7�MN��l�m���=/��Ƶ	�Xե`�,E�{a������^S�׹�1���/~��_��w?�ŏ��!�|�����:8Ȫ����[jϬ�>>vN���|
@ߡM\���筌���nF��0�D����7}0�9����Z�$E���=�P��8����jݯG��&4̣�tP��_�J/�{!�4���k��������R��^�no��&�{�Ǎ [H������qz�^����7����s�h��Z��n�S���7���l����N�-5�<}�8�J:\	B�䓒͸�V�G�[��������Ȣs�����cKZD�

�gH$,��yS�$����~��������V_&�ŝ#�/,� h{��{M�N�2�왲�Q�M��w2�l� m�RM�a���E�I��N�JK�D/��9���m�-���=g���$����T�l]�}p@��ʔ�n@_{��I*�5M7S[ki�W2ߵ4N$Ӎ�w+|l)��N�!�xi��4}�o|��������z"�&}�ָZv�m�>F)@ఀ��H^�b�Z2E��(�ۓŊw2d%[0��>^�C+,}k^��*r��o3��a�AG�f� z��s�Andۺ�r���ք�ǜ����-���n��|���{a<p;컽�m^���é�{j�'���^�4%ם7L����c���˗o?m��h��0hK;-gL�����Q�.���4ب�+�ʖ�����Γ����nqc�HI>�
"�d$��4��և��l����O8���׵=�N�Y7��`T�MU���K���\���p�X�E1q�H��EdS���D�
�"hv�u���7]5T�u��<c�,5�m�h���o0?d퍟1l�z�2��h�͇�[r׊{��m;��$��0X����"5�4�zӭ(�q3��l�V�!%./�zƌ��]����VIݢ _4�=+R�N�V3Q�15�v�Fa�ӗ��sɻw���/_�W�{�?�~_���^>�o?����-/��Wb&Y�@���&�B��E���L�x���l׍���/޽|lw?{�����m�uO����I)�v�Xʫ��bl�	��_����C������_v@EO�( 6˵��ti6�s����H��rlZ]�^�}}�f}�\`9s��B<�,���R��~Ѐp5Y$[��ͥ��j�╧O��W�����f&���*�=��7Ao=Uٛ�#�t��$p��������<c͐��ҥ�`�^u!+�ߒ�"d��DTSW���E���H�4�ema���
mh� $N�9`��]'�+�iW��v82�|���x�����@�V��A�c��Pm��<n���'�^��$�Zݿy�����em�_B���������c�v��<�^HF3��v	��Vj����*�ӕᕪe�v} !�L|��h�=h�Vg����xi3�f�J����6ڌ�ã�u�
R��4����xf9�I<}R�6�쳇ǻ�����t�7�$�Ў0^��k�4�crg�U����௿Hw�^��69����O��j��F[�A�\���w��7 :(�7a�-%m���M��X�."�X����J�]���(���.o�d���KQ��� �~���Z�&_	Ҫ�Ͼx|+z|(��'#IJ��j���6��X�ya:8��:$��h��!�U���hԴqUCX����~usn����ǾSM�@�����Bz&VJ�������f/��r��B���oߵ��/��ן�?�D��L%��2]�m�^s�@�Y�0�i=���`����թ�$��<:������,�|=��;���Wv;H�N;�A/:�4+el�h`�YӆW8�G�(�$�\ڝ�Y9�n��I�p><O$a����-�-�Bt�V]��4.�=�O�o�y�ƋTځ$&L� y�*:�p�^�o�Jq���M`O:����"�?P|�� }���������I��]S��k���<�_~��<��j!���qv��md�.?�a~��}��;#qxϺ	�r.Xs	�N�蕈�z��b��*5��Ս�Q&��N�F�p�$D���8h�n��m���`,乳g��z�cT�^S�h������>E��J�$h��"dlR�p
�2�1y�&�����%T�q�$]�]�{c9��%S��UtpC�aP"w��JM�|��
�iY¸�w�1��v�m�D��aW����z���V��Z�6��mdw���Aϗ��;��G�X�A�<����c�����^��{հL����
𡈅���W���pQB������ڍ&:�аx�=N9tI���l!!aml*��d5����/d��v#��䓟,�~�dˌLc�B�h2㬇�6��x��.c[H�NoL	����.L *7X�t#�������'�o�Z뿻�e{W�h��%\��RἉI�T|mq�?��jT�-�&
�9���o������w[�c��'o��>~u����]��e�f�fW����TE�[�-��+�;�$�nz���fz��ل&?����~�������g��^sTXė,�چf���m�����C!���3���{�v�]5�6�]ǟ��_Z�=�Λ&��eژ�g%����bq��_}Ն����n"Gv@�����)�;S�b���hG��.}��U=����s ����/)êI�6@<�����9�S�������q!�ॄ��hb�@���(VO�ULTr����Hvf|��'t]n�0���\?i���nF�jdu-�SGT��)���<"�Lx�4%�b��P�n������;��uMׂ>uD����Ek.�AK*-�3N�y]o ��UgjҘ GWMF���z��e�t��n!�Y?�<H4�R���W����|I5}G$J1!Ċ�5M�g�ќ�L.��X>g*�P����TX�ReHQ7#��l���	f6薣��M�4�h�AR�A�/_��G}��/�MAo4m4�C�F���ɒ*VT8Ǧ��0U����+�����7�}�    �{a��DP�k�ͩ�bM��쪌)�)Ld��e�r�-m��c�'/�M�yt�fUci���J���Z��	g�BJ��Bc���\y��ǁ��ٽ�'�{�?va����Y<t�R�@�s�IW]���f�K�n*(f��؉l-);6+/�V����"��]��@b�vҦ9�� X��Ѽ{��_gYCT���+_��$�i,����2�N��</ߥH^~����o��5}�4�>9B���9F�0� 	�aTtr��<|=��q�X�C�`?�YP˱	+��-z�	y��4l��Ѓ)��I׬�2��a�^�8�����?�ş�B ���xF���^�Z���k��ؕ�s�Ws��0=_lƋ.T/�Vl�d!Wm��ʰ���d��9x��Gi�.`ֻ�n������&{�z�C��"v�X�A�ך]��b4v�_��������ۻ����������o���ww���ݻU���83΅�״\|��f��x���'eвw�Wx��K(��Р�g�MkK�jX#y��_��_���;L�0q������o����o��1�����r����5��F��j'���'?���x�?�����m���������0+��t�.
�h���{hz�o+��抩�C�8���)P{Ū�(���R�����r-Pf�p����,Ǥ9�kݍ(�e��К��>OZs�
�����۾5w>�ͱ#U��fU`���N�&\<�-�U�yzv����+�� �3W��@�.�M*SՂ��A?4v	��P�8���oY��γ�m��É�Ѓ�ę7̹c����eUZ�I\�#�M�������઩�>��w�0��kŏ�k�9�{|���_�<�gح����`.w�K�!$��� 0ND��'ʹԻ�`^~z�{�����xԌ�ry�j�9�[|у�(��.&�b���D[L}	��z����'�֐�C������p�0O=6o��!�jn�`��$��y#���t�`<����E�V\*´�y*�'hy	;+F���-G��yv0�y�#6�ԭ�b	��%���t�س�)�	�[���Mz�?�4�Z9��!�ǿ�tP�0�^�,�Zy�����6�����\�["�&B��t����^*�)lh[[���;輡�u_�;��Z
{B�¦��D4�Ra�au���.�;Mݴ5�8����]����BB�:%م���X\���{hXW�ؗ�ac��v����z�؊���/��}����Ĺ}���9gM�+�w�y�
����
����IT�����K�9��v���fo睦�������~L�D!�Ř�)Ԋ(���=��}�WM�im�������K�1	g��򞄸�nO?�	Ǚ�hl�X	�6$pJt̰�+����][39o�q�=?�;��k���h��E�)�]b/�hB�ư��-S�{fǩ���N���1ٖA���ǢeP"ma*�=&5�z�ԍ����C�+lAZS��ӏs�0C��+�!P���!�;�D�I�nJ�B;�
�@������޵���F0�!#�2�`lZ���/k��׊M��#MZ:7>��ڕ�����w[�>�
��',��ъ���.��[��׏PW���'�S���=����DNk�[������U�����6� R��6=v�|�Ѯ�T��&�n�����2��\F[��;"z��fc#�`������"�MK��i0N=w��>8j<�?�ُ��A5Eϛ��A]4U�3��@�l���єB7�s䬽��4�|g7C*��Bq{�,ұ�S�RA���h�r�yK5C�1յW!��́j%w�����{��� ��]�'���DU��*�įn��q�颀�/oN�>��9��K�� ��!��i�R+��~)zv7g�̫���ׯR������E�g,34�=���!�]��߭9�z�%]��>ݣ����߯߾��/�b���M�� �{����s��͎``+�/Zg�p ;5'Y2�ԤeY����&j�F���I��ݧ���$�U�7����È�z2,WA���37b'�q�ћ��wΔ%l�{�u���7o>(����6�U�guN5��ñK�e��o�`���Qy}�q��������԰d�U�g=����҈^��SUD�VIL�a�w�������>�J�F�'�k�28�F3E���F`�Z�\g�Y�׻�u��X�Ǟ���(!�o�� ���5�� f���d��>��N�O}��x�2$�����I���Vλ�aL	
2d �4����}3�����$�v�|n�␔�m����/�bg[/�"���׍Lņ�<\��!)�u�MD��|Ӷ�e?�,�����D�RA=;��n����nE����At�9����WM�0I�D*�%6�慴/t<	�_�7Yu�@�-�P)�H�l��i���5��A�khٻ]5f{f�1��K�9��"l�~j����1{����4¶
��e�3�aZ�>��v�(�����~��9|�,ǩ�U�H�StZ�řaypX�t��~�0��w(���F��\��g�x�����F���!ٺH��|�d�_���~��~پl��hw�^=<.Ķ��l�-E"�a�4dp5���e� Y��ܯ�嵌l��V�42����̎���'�����7:��U�JNC���Cڒj֮���3����%	���h��{��Rz3���x��E)��s�Ϟ����לFiI𦗁�_�������(��Xm�ߜ���TBRsޓ�����{�Piy�pɕnB�n�N���#;�N?�	�HTN�i[j"8�*)��d��^�n����1l2ȚM?/([�nI�i%�F_��p�Kꞓ�s�s��쐈1jP�J�����I�]p�R+�f�SZ�}�c/�`�	<8pd�͠��%��� Z�o��Wp�.�)2y��I��틠̆R
�
 b/������g�Nw�srr'�~��U]i���j�3�,����8i��6�԰�{,d�9���N��aJ����u�-�`��~#aT����Q��#Y�c��[���ʶ�vm�|���`�����w�.s�aKN�#u��j�5*uM-i�m(W�����B���C50+��];�/8	�>hO�Z/5�{���S���WjEd�3�r7�V��.������+چ�f��\+�cV
5\<���C����X�Q�Kǭ����6Xq.�"MR�^�ȶ�Vz��v`9׶[@0[����x;B�ka�=�Aq�jf7�h�d������շ�-�%����!��QG�Ttע>uT�M�R8[��s��x`�!��S�:�o���x�C�_X�M�!�V��&�9?�[�_kW�D���8?��§�.%-��N7���~ʜ��Xo(����L)����Z�������H�����a���u`k�؛e�=t�����^j��P�p儞�ɺXC)`kZŠ�!��1����WM��N��g�2���6r:��1���)n+:��K�L�����#QZm6���{�o#�S��N0�k�{/��N�`a���خGKs�2wi}�0T�!~j$(5{M�Tm�ןe��ǟI�����y��0��nBN�$+L��8�=P8��+����h�Lg�]k�4%�� t�u�
N����y�ςT��-�.����83���bt�c�~| ����ޛ L4?����B��݌n��?@Jj�\^ۡd��NNT����$Y��g��@�S��ӻ��nk�W,�QQ�Oq��^�d����O�ӎ���*p�6ԟD����oQN�X��m+��O#w/!���n�"�KPH9{������ݕ��B+=����\h�ȹ��J�~z�ΚԦ�������׀�d(+"���`\�'�#��g_��G�|L�g4��8KsW��i�o����n2� 6��hg�-;R@�e�[5֭�?G�ʘ����Y����2
�q����.8E�!��r4кI��^T�`����8X�|�ሲ���7*	��*1�\�S=��M#���c�=����٣$��N&�;w�~j���on�E�:����Y6�zcSs�*������͗3]|?#�r��rbr�<ԩ    �T�5�6��&F"&��E�L�X�Wa'u�#�Xe�"�=u�#�~��,x���H�TTZ��ao��-��x*�Tj�<Ա��k� K���Z�MRVу����d�7A���|x�e��2?������<��h�i�g[�t�o�N���#��m��z�����0,>�2v_���ވ�:�a)�,�E	���'���8$�]�;+/VP��+X/tV�ͭ�y,SJ'b���o�ť�JtQ��9:���7P<B��հ*�4���Q�X���\�&J2{���o��E�`�`_X��	e�C�֕^pto�t�<�	�4`�H�K�KM[��z����^ۛ�w/�A��W�Z� ����8_����;�����>�E�����3�+��d�z���VH9H�\�tH�@j�a�$M�[U��M��ߚi-��@��q���]�S�|¶'���c�֢�n���蹃�U����|f�5|�t��,1�FӔ�t�L��d,.\�	�|��:�����q����3��*��e��v�X�u\�C��z׃ݥ�I�:	p+��KP�vwޤ8��6Һ���Ze%���T��bc�fG�A)��۵��NU���#W�U�_r�!M�v\�6��5MZp+;�m+��ٚ��؍�x��l\��h���9s��P����SJ* \�����R����tU�A��Ϲ0�4;�e~o6�N�Q8OZ����.��1)\�n�t�Iq�5�o��%8*�FX �Χ�2���7)�$�t4�;�����c*������ca����h0#�O�(gM8}:@�k:�]��aT�8�m\V'�"r�[mwz���F-��g��Q2k��n=���S��~�~-������\���h� eHk��`�9/'�>�}���K��k�T?��A#���e�_[�@�Y�Er�3���Q�<�-�͖���Q���A�La�k�"J���6O$vZ&=�u6�Z9BO7AC���i�=�]��O̽���v�{F����)� FG�[M�BBA������1=Ǉs����A֙mIo�ʀw�	k���ے��t�y!��p�HK�N6�.prԵ��<�h�E� �-Fϑ���"�+��PcY�Eݏ.
�9�3|��4�I#�q��5M�i+�ׯW��qZ��3�GL���m�b7ԅ8Hά�:��$�(��yk��=q��ZXH�Ur��Dn�i��k�ճ�@���zyJ�I7�lu�ĵI��!lu$[#ǵKC����2�,!��I��\z N��v�>��y��r�E�ޯ�EW�7| ��,�g����78#��Qv�-��������̿��>������vB+�vk���؊YO��F�v"� cu"ą�]��9n�r[�y.�B�a��?���܁m�,fi����e��q�.�'fD�`�Sm�qdyl?�6:fd�/\+h�H���qx>b/O{ޤ���`R[=���d߷0W����1�,2�\!�W�,Ol�f��O�=~���������=9&��6?8W�J�)xP��ǘr��&s{���E㳿���/^=~��>
�Rb/b*�_A�����Ŵ�Z�H���i�!��:�n�gtу7�	
�� �����M5T�e��L��9:�43�0kΓ�L8���LS��N]D#��9Z8[�P�.��%�Z�U���M@G+��T�G���3Wׅ#���h7�4Lɘ���R����gn�;U����[�=���>�1���m�><=.�_�26ltDݕ����#o�^8;Kh{�Ӽr���������e���;p]?SѢ��h� d�1
��9_''�Jr�?ؗf'��/*�^��8v�J�Ur���^�=..�,��4�Z��{&�A��V
O(��!��r��N.�e.A<E%u��2�֒M�Zj�W��B�M�5�1F�o	t����"��	�1��g���� {�*�'�.�.�x+1��P̯dW�k���[��]rxX,[Jw8��E��L]�(��s�e�"��%��|U��6Z8ِ���g�@�goZ��j�E=��I%������D��^#�=C������<�}y�����Ğ�f�ul ّ=v�3���[K\r=���:����`�J�2ԩ6��r^����"u+#"�9[�L��70�����k��ƍ�T�tp-:�u�AU�7IV��S��!3�F�_^j�4�Hv��"H��M�|�&vF�\Aa��̩���ף��nlҸٽ��t�z�\�����M��H��P��2�%G�\�1�yd��ԀA�{���{#��9����ҕ��!���d��`��6q�V���%ĳ�r:.�!�H����5�l��{�4Ap����VN���zM%��ףWrze�+%�>��O~�û���?�H����:	���˼�Q`s��U��!�2{KiH��B/y�7=Ц��Ͼ
�4vK���)3饦�Nr�^�?w/�SYk�sO��M��y��Y(����d�گ�$M���n�\Y~1K��Z�ٹn���UM׹%H�ݓ��O��|�">�/�@{lX��r����C�ߍ���',�=Gs]�Ʊ~%V�of�k6�DM�+�ڕx]�F�;��6��Sf�/Zr�$��U�� zb��,���G���}�ǘ�YOْ퉋�piv��#�'-J�UQ��`sj�F��G�G���l�YO=�R%�l�}��`l�(hJ�ֹ�x�(^�w���h-G"$Y�M�^Cf=ؾ�'�z�C�2g�K�r�
mT����mzJ�ɵ�['�6e�9o�K�hX=l^:qb׻���eT"�Y�\�͛+����24�f9��[�����7�p�FK���D�pe��e�E�6X�.�3�I�!�0�!t��N�%���e��0����5�o��nm-p�:��*:+z��dD�c���)wcV���
�h���� "�9�G{�wgR.�8s�ե  �M������M �p�U�)L����X!D�W0'�)�K(A�;R��x<����?�����%9�	w�It�FS`����G��j�h�p��ZE,{��&=,ʶΛ5�ov�������e����X��{֓i5v"в��K��Bi��|M6��+�%��t�����鋿ځ����TmÞ��5hL��J���v��L^��u�/��ٻ�'�~����wх)������d7O����&J�ۜo Jj��`�l(.5<Z�q�M�zD|�e�]0��
�%g+��<��P��|s��K��Tl]�=�:m첋�Y�TQ�S!	.e,uH�C��}��v��4������o�w���S�:r�4d'�Ơ�>5Ԛ�׳�{��y>{��N3-w�Xt�CV��Vؓ��n������c��'�O]PR�7��i���t|%��Ӣ���8��8����t.z0JMK)d�4;U�Zf���0�z����6��Y���/��[)���s��)(�K u��[�˲V�UO�S%���s3�3;�����Z%�@��9B��&BʚJ0�k��
K���WH�g�w`�:�W[�(SLq�E��%�cni#�����[[`r{y���֊u�n���Z9���3v�h�3*q��d8�UCVe'eԫ���q�ܞ�S�2D��a�5��.Z���ò�#7�P��ebBKn�o�@N��r�,X�^y
���8T��~��o�L�}�ŻΙ}?9B�B��Ⱦʛ4�)o}4]��y�_�� 5��r�AIF�j�����lDk�`{�r«P�&r��;��>\�{����b�P澲���As�@׶cS��*���Q����_�fi�7��?}�
�&�Rs	'�N
c�.��n7j���6�i�W�Za��M�pD�x����Q���;�6.a�1�.�dv~�X9|M�����������/�=ޝ_�L(����U15�����m0��<W&�1�yU��q&��=�:��)]��}�PK|���m�:���ؑ��������'�$��L��(�՘؁�䣚TZϰ�W>~�����e�8������ٞ��Κ�O9=��[N'䃀����{��!��Z�ރ�m9d    ��$4�6Q[+�4sP���ע%��$����� ��ؗ��T3�x���t�F]��ۀ;��H�fc�G^V�A]bS�S�����2�q��O�[7`;��ͤ�h��apF���$Gv��+��-ئ"2[��jl����1c)�T$ι�^�e�ɤrKq�-�,�����i��8烎������
i�0��� ���SzC���Er���zt�6����N�U�7ܳ�";�*m�����+Q,'+O�Ŕ�'c1#5Y��]�'n<S�5uNn �O2D�VJRq���pG�a
I�vq�xܸ�S��m�5�A
wp�Gٓ/�4�X�T#䳼�侧���e�Q6,�֍���,�D"�-�1��-L���6K��d�}C���Z�n ��Y�P{��X����ϛ4R{3�o�����~��s|&M����HMEw�l�x����������okS�`%�6,��訉��\�2`1�K��XGɾ|E�{�pW_�+_�~��4o�Ľ�=�gjNe���UG.aSD��ը�:������+}���S} �i��m{�N��[Qj��0�:��H,�q���s	Z?JNQm,r�\�(����J���B76'E��EJ�>�C�x�2��N�M�L(\-���LP Kx�`
�B9�X�<;��L�������o����)�?������A������h���n��Q��q�r�%h�ѯa�v۩�T��j��؛F��ˣ4N�.��k��/���z�Jg�6S�@�E��vW��i�i���(�7�p������9]��s�m�U�"q��¹���ܩ�
pj�7᱖�[��V�ϕ��(!��ӜZ+�9V�ں�A����ĉܙI�E�n��TVm4����B�{1��CV5�k(Ad�� �t>��s��y��K��?o��ܣ�a���^	Ű!�Ș,4up���О����W�j(N2�`B�����rm=L!�%��$�ȸ��js��z*ϯ,�c*���B`�|��[��\�8�P�1-�<g��SIqv����	�4E�FD�|�ťk����M	"��vX����8���=߿{(/ӫ��[}��{*-?<�f���!���n��}x����K��`{�+���5�^���0cu9�ą����*6㶘P��iv��(��]���a/��qjv�$;،\2��M�eL"LlW}0O!�ؽ�?�,a��+�����҅Mf+Y�r;�C���9P<X}�����#���%��>���bT^1��t��U%:cz_t]L_r��q^Dt¼��)-CP{M��.��N�As��5F&l9CB�V)��v.V���Mu:a���S�8�lC|��(4�A��FJ����b�:��_jz�/e���$d䨃*�G�C���,�[ǃ��OO��e�cc���K���]LMP����sf��=�a�د8f-q�)#{ha��|�<����FpE��{A >�Y��
?����l4��H5�S���T!]VU��(��u�T�"��;���C���\|�pllH{�Kz� Ek������[�a�^_H��mF�YM��n��r�����P|�ٻ���+�t���'Q� �6k���➮���|�	�NK�JNn�9�����l4��>���~iUp��}�S �/$T]�X�.��0��hu�-֏>�?&,PL%�����ȝ�J�;�/v��R�N(��׉��`EDS\DDY-o����"�술pJT�'����C�?�D5��$'߂�9d�/L`\%�F�z)(�e����u�R���U-^5a
�vʒXPe6����<P�Y���>s��B�PC����STZ�]��zv�4�T�ɬ����-��[��>j�WP	Y89��k��lyй�������=,�S�&�9m��<A�>j.=�U�K�?�~�!2���H��h�7z��y��C�S���x˩I�����b��p.߱鸧�&3ư�Ӱ�2Z�{5����s=N;�6V)i�UV�<����_b�]�PD�w[!.S�Y8td�ℷ����6��%��)��*6��pz�����ؤ!3���-��`Ǥ��>��+��-J��cs�IK/��Qe�>2��@��e�VI�Gzꂽ$�*����N���cw�V�봪?p	�8�q�����z�"�Ra����k���J^��)k_����A.�z}(�<�S��tv�T,��Bl&u�.V̮��~:����N=�.��#���~�<��Y�#�:*{�/�c7�9�j�\ޓ�=���$��ѫ�>���!ӋН�^�J�Z�{�]r��U|�s��ي��mta�Iiδp��sn���K�8Y�D(�͆��|����Lv�7/��!�k��+��%Q����3E �Nq�i���^�'E���nPk�lĞ�A�{$�X{�8{8_]�#��t0�(����]K�O'��PР���B/]�ѭ7��{$X��������QF�]B��A�@�j�<���'1qz��sלR��[p>Řo�2;V!
l-��`J�jb�q�����m�[ W!�"h+�*��ZU)7�3L������g91�Sl�N�"9�Ɔ�%M���z4���oK�:R�UM��>���3�=�\eFt� ��ͼ�o�چ0+{��*u�<���6p>.�+�Mv��E�~�H[I��z���g���',�n��9g��Ro�'��}:E�d�K�D*�\i��ч=�nr'�� vi�/�Κ�T��ƴ��^e3�ך97!����+Yт)ZW��*��R�ى�O����su����ߴ����x5>����|uK��s,�vL)ab�v�EH>�*pA/m��$j�Яa�:�I���o��XQ�0���vӍ�ũ��|����k��W��<����n�f��Q�l���tQ��!e��� B�`���@�N9O7�F��,��0�������\{��q/������7q).��~�� �L�{�*�����fa�C8�c�H�����Q`$��;�X�|���K���Q��R�$a4�$�Bw�%�����ƊC���9���A�p�y�KBWҭ� !�n �'����<\�b���p޴�b:v�YP����P�
{�|��,�
��s=<{��UX0\V~�rV�qP~4�N��Q��]jMd3�P�x'HC�7��ܶRB�WLu����Yv:m�����2t��v~�*A���d��5�W����=����囿���?����G�����8�z��.����v9�۹���n��>,�3�`��E��� ��xfE���Ÿp�;���o���K��씠Z��\vعz5G�5�)��U]�ĩ]���~��1�e��s�pە��Z���q)݂���r�����5�҆��[2����LV��-�N�+|u��yL	;kN�kD�h�$8����K1?�v[�ۑL�.S�xF2�}�Ar����9�՝!��*�7����	����w��1�w������5/۫�8��g��6�pȦ�Ä�S1��VtNeo�Qi�7���'U�4�Q9p�뎍�ܺA�`�I�x��ғE�l�I��.R�\l�A�AŖJI;C�Ď�;C�������'s��E�r�f�S\W������<�����^=~&��B]L��r�Ӳ�Ą���M�!r��'��6c�rE3/'���G���L8�m��)���hD���%a|I1���0Bْ��h����`��Nz�D�� "?F������r�\U� �����kr�h�p����^5��R�o���w����,����!2��-p�����s%�/e0��M�,��A�����-���S�^�5���7��'K��%�\+�D�	��H�h�ݬl�KC���~�Z��i!���\| ��� �p������l'Q�Uʡg6���a���� �)���r���5zkEx�>��i����tYd���+��A*9���Gf(�2d�u\�t�D������:#AL�L��l8o�*E�hH��RZf�+ŭ#��*w\��޶�|�ޭ�q#;e¢�n��`�H?�=I�r�	�)�eM�m�����W����M�	>�����    �:�w^�d�����Q��s��5M���͑��<�?����Mؔ`���r֍�l+�56w�:�����peVW�(M	�~���[������O>����ك�振\��qiyC�)��iH|��h��h/���TIk痟
a�l�r�'�_���\���}���X��Q+sP��|Ð���5�d�h������̬��Y�`�H&��sim���u�xM�rV���y������O��5��9�
	������^���l�k�8.��^"���#q.�o7�S�2���:i�םQ���;u(��o᮪^���8B�T�k���5����}A/N1��PQ;�f߯ս���SFS퍑��woaqE�P��|��{eN���3�S�)�x�է��'|[�^5qB^u��S\�}��V���g�C�'�v�]qP7٤�,�[h�n�Q���-��8ZM�c�cƽ��G�8�
�0�̅�;�vׄ��.�������Iv)5�K_,X,���d�y~�Ł8������8)��Y�町�J:�}kG�ga9w�D�US���F�� �䋟�6�q�+%<��Z�!���m��u��X�<�b��V������g/_����_�e�����/~(�x��ͫ��Cl����]ӱ�ֺ��:zWT�F��ГW����4.9y��Q���q3��O��7��ǹ�J��(r�vn��A�ʵ�xj���7�iv�1�ձ��b�f�;�1������58����%N��Z����&˫���Q:�L��AUj�7�\[*ø�&�۷�s��;V�R1Z����?e��:p��[f�;�R씏�� l��u*ٷ����,S9uP��ť,�p�&�r�M��R�:W�R�e*��<wZV%*`�}�
J�����vRd�/�8#�C�_��"9Ui�l���oFG��TZm9���k6��c��X�ʯ�<�`���ŭ�2W�֎��\���i�0��UgJ������Ȑ@�~J�� {|0U��X��\x�>�f�0Qh��#��[v�����w΋b "��r��D�+��u^�a3�	��ra��ȼ�Y����+�q������sYa3s�=���6;A�DŨ���	����ʦ�����ok!�@%����P[�E|�x��̔�_�G�ͦ�'�?���[8��$����h���BY�SS����~\J�FL\���?���à~�}�!lp�!}�V�iJ�#s�[څ���bd+s�;���Y=��o�VM������=���qHk����L�`���lٱ�ɵh�mh����`ͅ��s�V��{H����-!�Ɉ&���E�XB��k�_�R�)Ѕk}���+����]|��~��6:
ͩ�RbUE|�ɩ]	NZ����K}���1OG3M�b��쌍1�5Mf�qg�~�������Q��mz|�DS��r�%�c����8o�Pl�xpg�k��"ȣ��g�QN:�ɟ7�Zz#���=��4eQs��|�=��՚}ƺ�U:��U�m��N��В\i�Vq��p*sb~O�K��J2D)ae(�t�p>�@�ٽ�ϗ�C�J��q)c�|`�qpz\U�4��Ɯ�=��`��c�c"{k��ޓ� kT	���q�W����^�r\kB��C8��kI�K#{UpT��G�i�#�	6цp��(i��#�:rbt���[���2J�7���R�ҨdNT��}s����1e�q��Æ)7�{x�wn�E������{M��*¦�D|�R��g(X�h�&��n7Tb�Vz�8""�.�R~SK&���,���Jq�R�a]t����{#H�'oe/F	��S�=��7������h�֢>M��zgNZ-�����6C9�%�kQ���,6��{#�k,r���}PX=k�3.�y�`�`,��S�Ǫ	�j��|�Y��ҥ��;G�ΥT#�
�]D	��JL7���+S����^�q��=Q��
r���+C} c|o؁�>;��TdW�u���b��"�Il��;>\5�x�)��W��5�;r>�Q�pPh�j>���Y 3qw��qw�����3lB��(���p2�d������M�Ӱ!�f�F���$������i�5�m��vJ�nr�7����_J�qy4�\�T�/9W-J��*�&�MÞ��Y�9l�{��%1��"�hΫ"P��[�6����R��.��������)��Q��q�Cuڔ�=;�ʐV!褷>�)Y-48pG�v�����ǰ����2$��h%�����S���K+"fX{������8�I�������E�:v|��u�]���{�p�rNBTC�@���z�&̫%�Oe�A�b�jP��<5���\�q1>�4�)��§< Dl��5������T���0*���D��s{�=>E`���&�]���
{Rej���W�������U�KR���a ķ�\��z7s�> /T���:gP���� ����Ŷ���\KyuT�6��2�T~l4�,$��G�_�ͽ���,bg��`���n��^����ϗ0>����Q>z���+g�O+���5�ҸOq8R]X6M~gh��Z��.�؛��+��WL���c4=�E㈮[��^��l+��՗�[����	��7�K���I��\����S� 	խ����S��̽�:���6�M�����e`861WC�:��I�D��2l�6߬�F� /�ivV��� ��M��p8�Ұ*wk�~���O��%q��f2�h�|��ˊyE���k^����}��)�� z�"V�,�]䷩�9�-قV��.0^t\�yq@������	��ٷ!�)q��{��z����a��Ftγa������^�w�'��꠯@���D^.� 6b���,�G��&���} }*��.���4�xj�T+���� �X��E����5��������)�U��i��s���(P~e��O�v��@�g��W��'�Vr2sBN�]qvr���eD�J�H�E��/[���W��>��������hq[��2*�ވ����W��`��W)2�����D�Ln7@�S����<�+�(�!bc�ч����nRm<�&���=�4@��\�*�ҵw�ީWZgH������G� �=C���q��3�:*��餲*עS�p�>KW}j'oV�*Y�Wҕ��BT-wG�)���qUϦRu\� '�y�@�Z��ZAŢ������|����7�ݟi�irp��o�Œ���W v\�>a��Hw��:Q�z��6.Ymo޽|@�����ĻǇ�q��U*�=�/_�78�}�,��,��H��[�Y���j
�|T�_̃(��C�r�}�����wL��7��W�_������W��������������Et�T̳h��&������[���څI���xp��)Iؔ�����uȶg��U��A2�[q���z>�hv��q�K��g.s��E!Pb�N%&l��-z�D��:n����J�'��K�����&�F`���A6�hN'�,pNY+��V�k)J��V��S�mKՍBbEć��j�z� oў7�?{1��omW
0�dŉC�9�Q5�{Z���5Κ�$S��^�u
rÒcC��6����n�k*yؼ ��6�*�Yj|�SŢe�K�4�[�M�s+Y�܁M�k�]	{�)Gk��d�]�c���qP��B�z��	�p�Xm�gQj�ю��}�I�|1\��)덈����T\���U5��`o��8Kʹ�M&\?ۧ�H{/9�^�� ���\&�\��4��J�aC:���=} ���Y�ZH����,w�P�s�TX ��j��"��"�.��i�S����87,`Ҵ7���T#'[�xf��6s��m|3��W�ώ|f��p>pn�.����|���ڪ���X����A����t_�e��?e�yS�­V�����Wz���j��m�<��?ϱh�8ٰ1�>|�^��������Ǘ�?] a�U�ʗ����5���H5�#�� L��i�N!H��������C�©�,��X#�!Μ:7��I#��i�n�    i��j��@�*�2��o���|�����M�h&���f�%&0����h���@;�S�:&�5������H�S��k�M�&��h���:�Ў�N�� md��H�� ���W��[���.�q{]�!����ؾ��c�˫y��J��6dúɰ�y0��{�;�)�4`�
�na�q�\,�,�du`T[��j>nq?������Q��$�fصպjDR��?��+�3}�,� o��p�&j��a+yP�,3^�봁c[���rbb6�jĮ�V�mI����?�-�wq��;�Կ{�#�Ղ� Es̴5̖�)���=t2����V@E�}{(u )����j'��:���&�I�и�_�I���5��t�deE�yaRǱ2��ϛ����|уT>h=m��gU��*� ƍ]j�)]�v��0Q�Ǉ����>�㯋2YQB�8k�P�܈NNc^U���'�ݚ$ɍ3�g���G�e��>o#QK�9�D.uv%���p�qfz�����ן�#+�""#"#�����nt��/p���!���xk�y�<��#��ӹ126��*�����a�y�:�8i�x��G^��C�#��H�^^�ԝNA4��?C���c��:<��(��C��t�o+V��K��Ձ��9���EuzHr"�2$S����Bun�muɽ�j��R��1 �y� ���*`�s.�fQ�r��1��y�G����Ȝ�|(�E5�t���) �TЉ�0:A"��L���3xaBBXJ�7t�_��R�](��Tq�"�SQ�-�a[4�5�h{�ԛ��4=��-�^�0����k���Y�Hj�B���� �%*�`����;��N������`��T�v�$i�Ì��B�q�z�����rGQ��	ۢ�E:�<?�[��#�fF(�MB��}B�g��TB��y>8;�3�2U��,q]w+:���_PqW�r��S8g�B��K���K\Z��^�Ld�S9��ra�qi-?D�T��s^	L/ь�Г�"H��t*iW����Hq�W9��"�ت�G��92Va�z�u#伴K��)�����x<>?2�,'�xF��gɊ^JMlP$��x���{������o��������w�^����|�Ϳ������_��������O���w�ڝ)��*��=_��õO���|p�_��h��Q��m��������k��D�Y�KZFK���\{m���ΡQL>�y�!���=�{-�R����̭������7�;���\MiJ���4��c=��XK�\`3-������v�� ����
��]Q���qT�8H�gv��٤�2"�z6h��e����<�W۹oMMĩ!�fsh�4���So�>ͫ=V��%j
���|I\DIn�CT�tU�uˌZ���&V˲�Pa��ߍ��?cO껇�hm���~�'(B ���`9=%-R��
��𭇈�n��������Ti~�'kXj ���;�����s>��CQ�h^�y�nt�����yJ5�w?-p�\+�R\X�֒qBHy}�h~U�ĥ���o �[)��P|"���ss�P�M���6���4�`9�
濛[N��6��?�v�^e?�@l���r�t�0�6MD�`���]���զHؔ[壤�+���8H1���O��?�.��ZG�X0��t�z˅D���M͌���� ��%�3���7%��mhD����B*��7{�Φ��!A�[�p�i��1~��x�A��x��0>O���s��'r�ی�M���5�]'����Ӿ�;��3�^L�3"e�F��24�.������ה�2k{�%��7���fZP2��oh2�fN�ޣ*P0{Ck3��Y��57����Ö�{Ck3�$��.LF�����N�����G/�v�A����%�;P!2M��9sC�D|���{ґH�!�d�g��ӗb��w�����E,��}��{���Ң+cvՍ�c���m����#.R.$G߹�'q�D�02������,O.(��lQ7�оf%��H,M�g��"z엪���k�~W�ج�KF�{��x����������[�?B����0�������(�������\�!y)c�iy�s�#��J\;T���m����/
�D��艢�ڔ4��>�©�iF�.������ۧW�:W����=�ᵦ��������f�����^ΦD�o�����ߚq�0���)|�~����bq�c���S��_�}BՌP�	U�������\[Z�-3�qC��j����+�L�}2a_7�|l)��Rဆ�p��fd�P��Q���4ў`<<��Ve�Ih�8D�kW3{s.0�nX��n	Ƒ��Ȫ˩�U1BX !���X{���6�
���8<<=n�������nt��*C��� 8|-��cgl�z7Y
�`� ���,#�W:� sPms��c����W�F��; ������6�TU�6Ȼ:ڭ� �k�do�����a/b���,^!�!�pLH���m/�M%Q��[͉Z�cN�,�V��o����Z���~]{y�z$��+C�@Ȯ�_6f�%82���
�{�����CܝT��o�������(%Oq�����$K5�1z�	#Q�#sӶ�T�Q*��ݭ���	N�sil޿�?6����빑�]Y~��q�r���H�d���8��9��	˨%��͕���8\o�zv�<fx�0⣙&j�2���&{J�p�#۱G�[��!|>�U��Ȼʪ��N�i=�-���S�>��*�)�y����cʤJ]q�7̃�x ��i<{���ыҽ���*r2]Y�����RN[q2k�;���)�G����}�᎛\��������J��~z�D�5�����4c�|�|��:a��O28�[iCF/���ⴁp;d$T�S�̧�Il�dl����i�|�{�l�a4�h,�s��:�P^������ڡ4F�G�lPYP�Н�HY�u��#���0��!B�����J�t��7��+�>O�a@(.�0�q\9���Z.��џ"4L	��l�%�ef�-��)���	�"N�"vyb*��I�z#}'Ž��ߥ/�%�/_��/�S������������o��`��.�����J�%�Ei�o�}��1.���b�h�sG&_�S{oMXL4�Քo�hk2��J�:pC��4������������z��1������d��Y�N�yx.Pܝ�Μ��=q�f����\jLJ@�6�q��R]�T�n.PFϮ��(9�/k9�M�!�X�K���h,uy�}~���È �gN�Ѯ#���c�yXƐ6����\�b��Ħ�X�`='�K'��aɓ��F��#�&Oz�X댽{�)��>� �=0���0Ǌ˂��d��OQ�d<x��`p�%:ʠ�ʐr�#�sA1Af��RV�)QrU>�t��z�����ƭSc�^!&pe��е��,�9�jaEqP�Ӽ3c��^kO��x�rC�����dlz���ӂbm��ۡyA��7�R��m�3DI.Ad�7��DT]���V������������ �Ǐ�ůq�������p|���t|���<�9L2�TQ��1<�T�=7z^N��fW��z���p��p�;c<z~g�P���Y�X8އk���9�`���=&>q�5�CVs�5��Z�g]���*�+`a;�/	�fU	�U'�2�p[�vDny(����Q��}�Z
F��ܺ8��h��D)
���|#�V��1xE������"�+�k��7͘�psC�p 3���ؐ}��mш�2�����KAA5����M𛬠T�A6[�9��Io=3l!����j��У$@j6��l�1H	�D��2�S��D���ܝ	�V���}8����Ӂ`�H��.�E!���w������c`P^���E�+\%�";{��NV�D-�8�;���M=&ǡ;ʓ3�8.�]�{,E%�fx���:����Å�1u�,�����Q$�:�!Ͽׇ.`n�|�J���F{�u)\�UQ$�6���]7o��1�2��G��K�GAy>2�Z�T4�Q��E�zA�&c7���j)��t�3��21"4�    ^����,
���� ��P	#>pE����9�Ǿ�wEvRY@������X�J�r,V��k%@�-����y��=�G�l
�W����r+�ʭ��h=�0�[��RIZK[fE�����)�]>_^���/3tÆ@�k9󊑤6�2��X&��K��Vz?��U�p=�n���ޅ���'#�O<��!���'�7��,\�Z9;Ss��N�<�P�˯�Y$�ަ`�N^�=q�=�7����5���a��U��0��S� ���c �������/����r�[L������O���_���_ۇ_������O�W�����O�˼�)�6�\���2Y�� *���Z����ӊ���yV�Z)l9׼�Ҳ�C!�%LZ���F��!�v%䝆�>��i��u��2J�M��ބ��R6�Z�=���g���4�f���(��:��$���8�CfJ��#|��,>Is�y���2�Dlb7�d`XѲb<W�b��K|��/_�s�ho�����Vaa��8E0�����E��g�d����7�
Gu���RL|]��tOf���ޖ����Ә��S����r���8��z�f5ga�"���%��l�?�!��z�ZP�FZF��ܝ�B?ƞ�h��P���ݱ/v=�^��".x0�����UJ���/��Ƚ�d�#��G�ܧOk��r�~g�3==�2�8�\��Z&�k�!�,d		�Ii��Z3N/�v�k9�3&^D�����9&�S��RHΆ��_)U�A.����5��:,X�1�X��^�K�8J����e-����gX�#��y��qZjl�5����iD\&��Z�VmDn>KTkŘ{��|��ڝL�RWQ{J	$��0��kAa�ȥ `3�ܩ�f�/�N�Z��������C?Z�6���,�+�	f���Z
�[�����Z���p!x��ag��nX2G	~�ȩZ:�[��8,rN��N���l����`�V��w��=�y�bkF���Ù�XI>;�c6��\]��[=��x�j��7J?�B�^���#���h�Z@##�N�)�( ���!`���;�h��{o��DM�?�#�B�d�Z��Q��ʐ�a����l���1�8~��Y ���!��\�����	��"�̌T�IU�E���<�����PQg��Mm6SU��q^��o�z-k]3�VKq�����yl�M2�[�Lsi��d��xxn����AvM>���>�_�����<O���v���ϑ�x0R�䚄I��'h�;q(��?�d@�khZtq6�z���F�`Hya7��
xХ%�.��/������nF�"�;�p郕��\��Ͷ��]h%�KH��p���//������_yo�ex��a�gO;�ۤ���@9㿟�>tgB�A�\�}k�v�\�OP�j#�Ň�{,B~ٙ��q[~�����}�"�Hl���sg�'N|f@H8�Yڞr�˩}�J��ax�8���J�J��ݟҭ%�{rwk��<wv����4ܞX|ѐ%%E\l}����^+�W����h��S ��Y���d�`m�A���T��!���<M�
��he�u���K1ѓ���V1�2��"���<#l3�i�:�Pw��.^�s{���[��\1��N�!���M�(��`�wr���g8\R?)�#��4����LR����p/�$����B�q�7�P��2[q��Cix��5=�fr�Z6��!�y���d���
����D蘡
�e-�z�F6�����$�ݧ��ĵL<�K��D�p�lL��g���Zx�V�.@�ZpB��Λ����4!��i t�\G�A$��3Ne�]Lz
����WĢ5��
?� ��L �x��(�1�
����C�K��$ }I"��	��EO���C~�O��v	2�C�r!n4�Z_ $�-�<��	�lG�`ag�e���Z,��qհ����ͮ�m�ϔQ�=E���|��u˕{�V�ഞAA������J>�����3����o�iN3y��3�0G�U~$���}�_�c+�)wK�4@u��Q��/�N�iWD�܆-�ϯ[�s�V��:vb�N�ѯ8���8	�)�Ԟ�&�s��
E��a:t���0�?�¤UmY6��%��O{ˣ��$x����Б�|F�^_���	v�eL�z�ǫ�1G�+��q�I������u� _I�k����us"��^���ć��ۧ�z�@��,��3y.�������cki��*R�%y�h�.�h�(�2���,��p�L��3�_�ya%j��6�:tv���gq����G&�!~cTao�uk��,��!�5��7���w:�a�����Czy������8z�!�`��)�#�.�[���N�sH�q��i�V1&��Qc��t6�N�4���rH�d~a%0���Ά�zH7�?�#S�/��;�r�fC�9��8��zH�4��s����琎ݻ7�{�!5�b,�̲:f6��C����)�#�@����\fk�!��.g�Z�ǭ����hn��t��Z���>�n��^�|���[��3�iY�v����Q{C�9��8S�wD5g$sG��ڽ�w:����xD-=��^Y	�M������v�O�vH��G?ED�y��Ǘy�#���@�n>�t�A�ۮ|s)�.9haw��Zd\3ԓm�*�I&��!��9ħ���*�Y�=��ѵ
�k�r��l'��t���8�G�3\����ҋ���S4�D�A�P�s�Sh�#�?������b�l��׹��d���Փ�H=�٫�%�1
�rO�5����I�Zq�2)�B�u������ǯ�&b�%�^���Y]^�v��)��܋ӊ\a�O:T�us��|iWB�(�Zu��J�i��*��+o#7_�el��gu���g"�ߡ)Z�vFƭ\K�f��%��=FŪ��&����;z���r�%l�~O]ta%hN&�z'si����q�{L��ut@액�X�8{IY���^��`̉�NEn���(/��¶��g�+]��+Z�84+J���]��'���JA�;��/i��eޢu67OLn+u.2RE�>g��șL
��c5��M�:��D�����w�h)�+���Z-H�\L��3���{��n0��,3�
{��}\TH�KS��/�Ey|�XK>RrZ�n"�'�fC�i�a_~yE`pR{j<=��:� ��7^wAC����wz5��괛bL�M.�\a[��O?~���R`{���V��a]ZΒ���J�ĥ1�վ�Yإ�ܑ�Rogȥ�R�Y�;��&����v��C��� ^z^�G�l@/T�f�k�q��D$ܦ�������|RkeHq�jrΣ��YyfȰI���Z��4��-�Ĳ,�Ӣ�F�q�:R$3t�VfDh8[��m�C���+'�{C�矒������v�l�H�h�k��r�3�6���&�����rJ5aD�b3:�k4I��j��kY���H�����+y�ܻ{k����|�`;+�ȜЩ������2��כJ^ki��MP\d�>W��J3̇�O{gX�c1�/h���C��ȧ*0Hj|�:���|�B�B��,���jJڴ�� ���w�o�8.��_:j�!m��_��� H�]���yk�8��W%RTС�i��}-�eү>�������T�OV&J�Bq}����4٦�I�^�s�YA>���|�w|�y:�Ȍϵ0��"��B:�}��M�Xk�'�N�?�I���"��X=��&��8t��/���2�lZU�O�C�p�.
W6U�ƨ'�MB�;0z��G �t��KO�����q����5t��/XX�#Ex[�����*��Z���[��>0�L�X��C����0�O��;�e>��?}��o>���4�9��fkʒ����J��`xC��`��(tߢ߾��<����]&����������1@I	���2�)������(ZUVMȎ���KR����so����"�]��Г����*����:����e,��.*�7����+�1�BS�Ḛų�b�!o��l�K�����}᝜y��C�B��'$����f�n� �3�TH��U��r\�o|[��u�pbCR    �d�O�	ÿ$����դtV�m��,�*�����Wq}~�փ�=��J��ŭ��o!kQ��V1�vxD4dʠg0&����;�p�|��%�r�Lx��8������2����9��no�]�ϕ�G$T^�&��vO�Zm��r6���|՚�_���5��F�/1�hcS1�5���z"���z:�PQ-�Zm�0�0�e����h_����Z��v{F����6�x�*�Ӆ��܀�(!RZ!}�&>dt��N�%)��4�'c�3K�=z��\#/��C��S^��7���tk|� ,�m��ɷ�?N��գ0�]%w�R`��7o��y�3��V��w��)��`�臒�?z�Z-5�%�s����$Rr�߶m)�Dݻ�S��%a�����Å����У��0�}�d�%0�QT�kl#�������C��m`įۇ�x�a��n`�;��(�OiM�sQ�<z�3<�C��{p���k��2_�xi ҕ ���6�)H�s��K��c�Ś����x������:n�}G��^I�v�6��g䞥���J�Fm��:�J(6�`DO�}NA���9���-^Q|WfQ^<�K�9�vo蕠ϑ�yoE�M��GǀnFhE��NN.P�v�v�~��y������O�۹#�*O��i���l���4!���i�l��&TS���L�sD�����w�G�S������?�!��v��%��C6�/�iTY�|�!�z϶A�,�#��a�N#ʯ>kӸr������ĕO/e]6����J�⨆��[����6��ߍ.��������?����_a3��9[ϥ��Ls ���kJ�yX�&2;���*[}��L���/�f|Ma��Xه���PE��	�l�V)�<¦�QE�}-�8�ڿ�C,�l�oq�8�zo�A�g�Js0�TǶ���N��b�&���K9�[={cғ�K�[m������K��Ж�Us"���(]l�^�1����?�)vʛ�R+�7���rvV����5xv��}��jib�up��b�{AL���X���pVvX�͞��M��.�&ʰ�t.��ٍ����nzHI�⼐m��f�l�$��,���lM0��z[笡
+*��E��Nv�Ɠ�,2<�k��I�\����D�:�.ÆGƎ���gw��lX�����Z�0���NG3���8��4C���}?q�SJp�W-L�4�z�{��s{}�IB_2��5elv%�8���d�sC&ݩ�Vk��J=���26�����y�k3�J*�$���w����Z[�=���Ç�J77�%�J�8$���.���[|������^ͩ����`�H���pHjӢ��jH�Uyo��cL���~rK�g���o��v1��!���&2�h�4F�0�m�-��x�^����d<.ʯ����#�oJw��}���əj(�py,\&e�Z�S\m,�y(�cT�����Q��)w���L:F8�(p2."v��Lrp�
��N�&G�-��2L�Q��2�&��a�iIp�n�Z�@���:*�ϭ�oc�wO�����~��w�(�����$^A��E���7�=F���G�3�d���0���Sw5��-���L��o&�7]@�'{U ������Q��3UE���m�Glul�)]n&5YO�f���wdm���〻��Gfm�s/�s�VY�r��^]�5iaIŰA�x���-�~���qR�q���b#n3ɯ]�����2��%~p��9F�u���v_'�	~������l+�Y)|f1��x�۬���tS�I�����9�V'
���ѓ�z/�MFf�r��h:\w8	�]���j_RC����A��๎~ձѰej��ߔ確���N�hg��q�}�*����<Q�5Gvl"i�D������?�|�����Q�:�Gظ";�Ѝ_{P"C{�
+P�]w7|$��*������_}�S���7�~*����M_�~*�~J?~���_���v�c���qO�(飚��р�+B��	�����v�
e`֜v�o�H�hHb�^��� �5�s;��\�,u�F�q�74�;��q^w2��X��ɕ+�̍l��%n|��U�j�p�ͤpw����6�aT�qk�>��p;��ZsȰq�:F�x<VT$=�"s� w螵K=��7�j��Ox`��+�^ચ�s���9�̊��\Ch� wΐ�~��N+u�nl�M�KѣN$��o���$K+�u�6��K�#1V[�Z����.�xwZ�����4l���(TKJ�ǵ�}&%�O�0+lv)��;L�4ǙZ�6��p��(&�K���b�뒲�Mo� S�Z�n��L"��U1���xs���4�6�+5X��],qJn`��܍i���<����.��On�'�m8��ʹUk�fG5������$���`[W�4OW��?������矇���&����~����;�ao�$i��4��F%�VR���o����ކJ�-����!����vv%PC�ZU$�q�>��(������3�^��:TʌV��ܣu6?�F�
���&ōp;~Tv������nI��z��Ixa����e���O�������w����׶`M�h������Un��aj.?�;�/�΁U�s��#��Ͽ�(j+|7>���������aA��Ù�rq��_���G�[}7��f��ΛF��#ӿ3��7ǉ_�ϓ~U��~�N~���߷���X�CC�EfȽ���?���`�/��Yf�؍���O��|m�R�<1��`ꇡv�<E����hn-�n�n�
��)M
e����������8�j�����uL�*�D��������)���⾝�;"������Zs"T�`Rs�6N<������X�Ͳ��e�	�M�m�L���Hbr���풶�h�ɣ�֫�7t|��a�S�Br��q�c7
U	���e���G�_~����Ʌӎ����`�3њ"p�9������@g��ٝ��l��(k����4)���:��!��n<��/�����Uΰ��YV�8�6������b�Q:�
*�=�BY �w������~��mf@&V��<f���E3�ܮ�X�����kQU���D��t��ʴ�P=��g��@���.��v��n�	{���X��2g����f�":� ��5�z;��E���,k�Ѥ�̀���|:�@����8QCaJ"�KҌd���b>��s@������k}s��1~d��VV��æ7�O'����|�V�Ե��g�!�nuOi�=��<P��������m:�6�ߣ���T*:���$CC��T��&Zj�-2��*i�J��]*/?�K��1V���2�$�FњӖl7J.���Q��J�Ce�!��Sy�y뵢n��bY��0
���9T���'�T��&��S���[
OւJ;����c�Q�&1� lV0D����"��e�9m�9�Q&n}�g:�����y�y���=��v20^��;�fY�&G��G�"s�N=��m*��jy�ow���Mr�򊣲*V,~��xgS)ƞ��ܹ�W*),�+T^~��a5_�^����W�`o�nc�K5x��u����@�������r�ENq��i��D�F:�:��p(�jp������Y��[�Jy�ڛ��#�4��]�u6E�Mߡt9Pa���H�������@B��$?�ritm8)('I��'��)����k�]72��G]Ԝz��J(��2kY��/���}��������A&�4�j�b��2���@f>��>���la�g����k�����@o�"���6�[{���i�Mјڅ*&r��6�%�V��=��xC3��������<��N��L��.�c𺊡?���K_� �h�e_�;4~����q\�S�!/��8�*�Qa r*C����]����s~�Ef�������<hqYu�W���jI{��tM�z�M��r�=��l�$�;�'�q̽f�`���J�ߌ#P)�E��M��� |�ۤu���鵜���ˊ�f��y'I�J!�Q�;��0�Z.���^��@��=I��|����    AÊ��R\'�.�l���ʀ����2�n�6�6?�>�;����#���S�r�L�f�AKw��O���������zk}�Rh,��ԛ=oN�k�	n�I�P@O��� ���O�cX��굉dI�NO��,ErjP�!ծthzكe��MQ�%�/���`XB3�wJ��6���L$
07�+��lZ�EJ�E�
8� x5��Bԝv������Ww�K+����a��"�VD�;�a�l�O����k��;��xr���S��5�N���w���8�]Ð�Z9����/޺�W�t�4hA4o��\l�<QǗ��-�h���q����j����MoƢ?-�N�m���J� HF�ӄ&���vx�e�a3r�;��|z%��h|gWI�8[H�j����׍����{a�]���
fe/^��x��r;%�,Gn���,8!����9��*C�v���ja�E�Q�;.5CfZ����И��WW~)!��$Ȟ�:D�.�M00�W&J����7U��b)�3w*K���L����%�ŞZ��K�7#:r��A���5CSG���j�^(���WӤO��'M�Vޥ}���+��(����e�Z��gr�FaV!V�m���{�0�2��|�y�p�h �Y'7Ӝ���>^���'���z������7�dv9m[�e(>YnK���K��ȅ�R򓯶0k8h�r�5��|��o9��{�6��)3yF[�u6�U�}H	�u�iWa4B@F�qO��T�:�9��}�4�(N��e�j�-�yݜM�J�*W�#�˞�w��є��[����G�kD�����--�ƌ��iL��s͜��`oɤ'z��$*�ǈ~�Mv�������?A~-N��x?��N郞�Aꃄ])9��j�&H!�C�P18��fG�NV���N:Ƣ8J�9bL>�9�K$5F��\�m,]=�\�D$5=A�O+���<������ec���037��Eh�b(�j����_�5'��-Ͼs�Y{�t-hPir���c4duh�^���oi�r�����ʩ�8����~y�y�?q�(а2QÍ��B%�H��	�	�{k�B_$7d�?v�RL��H�NS񑓅��Ms��D��US�զOM4!q[v�V��Wm�3�k3���P#Z��/*]wn}�xiiș0��ޣ|��T��牬��kؑ-q���>����lU7�)��<i�k�Ji�2K��C����u�Cb����	������S^F�ݝC���ǖ��72Q�h�9�3��iL8<e1��5�a�-C�[���������,ݟM��'�&~SU�q�W˩2)C�XM2�n;�R�ߡ���v�{��%�~�����ָ��@�T�]�n!�bQ&'�j����>7N-�%���\y��4���@A�ƍ�k��k^Z��d4p�A>���.M��n��/�f
0B܅ўH��Q)���������}��t�!.+y/�x�w���qN����k-�m���S��Kr6�o,�
�L۞�<� [*��r���QDSmH��S���T&lB���U��]8�F�B�,	�"��� ��"'�C�����{UJ�1�N�|z��U�!U��;�"1kQS0dB�>>��G��J�/|	��R��ź/��;J3�(W��e�)���;׌�O��������<�d=C�#����u˲e���}��"DX�-�]�L�E�z���py�{��}n��3@G��˾��zy/2��/�_q98+�K�}�^�INS^w��xYw��7��%7�o4+eŇE��b��^�����Z�S���¸�J��4����,�$S����ؐ.GQ������p}@k�p�q{����J��j��Όp��J���ޅtq/�3�����\��8?�5F�-"�(�Si*:�^�Jf'.��7����LSJ!�m'|��� ��T�Jg��,�mX�<�Ç�(�k!xS�'8Vi@ga�r��m�陵q�츊ҹ�t��h�a��6\��Q3�0)��.B�[�6��]sG(��s�8��Y58���7{|�s�.x\��\F�&T[I�%��C����4���ȗ-�X:l�EQ�ѣ�xkw��h��pj^�!���J�$��8A6@�����uG��ڿ�m1����/�s���PfF)��5����j_O���Ŏ^ێ��iޒ��41�x��A���*�6�$��!�r��`DJ��m��% ŵ�ڙ�ryw��X;��m�ԦO�����x�wZʵ��"�RŎ�N�.d�S9$.�VH\1e���z;�������Z�.�hX�Hc`F�0m�2�:U���Q�Lb�q�RYmT�*yi^Ćd�[{|�hw��7tv�`s��C������jj㜔%
�&���yL'�o�f������*M�V�2�m7�dX~hU�Y+C��p�y�e�|�����'�~A+��<��z�.Z��
��q�^�U�R5����Z5|,k�qXX����w���5���Mw��{n�����(��}��:�ڊ�iȻ
�IN���lC�4�h��!��u���
����_V˱#���O�(�4��]��,һv���z�5q�i��7�c_�r���Rtbc5dx3�r՚N��昩}w�_�^�0���q<��$�������7��]s`��(����P�Dh�b�l��2����o����.����TC�M�%���%AMf�r�&�"�;��t�<�����3.�*±�9T�:�r^Ǆ��Tj��z�WGkd�$EC[ q��1�pJ�֑�l�IF9����������@ō#Ȋ��6��RNͼ����m����N��O�{R;#'�77R��N܋���L���x�m٫F����(�6 ��(%3ØX�ţ[:��w^w.��ܾ������ٜ����]`@o3:~�w�T�*oL�yTAO���V��T��f���\験)jȮ8�;f�`�qZ�EXҧ,'�yɬR�g�~۷�G���'H�Br-ò5�t�~U�[J�,|�ޜʂ����w�ſ�`��ɻ�Z��?#�'����w2�T�g�O�"[��2zSRq�ۭ�i��.��-t���9-B4��H͍��|rFJ�b�rKR���B��zr,�b;��\>]�T�:�(-T��m����]'�96_>����K���\,[۵�w1�
�����lU/V�SLr��3�����[$hn2#�v�}��z3��e�t|�G�`l�{=�?zgFl��a��jv��$��I��_A��׻�������yP�޵[��z͎S�˜+�Hټ�ԩ�+*#mέ��N��(�x�1hߕ�afDN4,m�i���m�
�,^6����ٯ؍�k�m�]*h����*���K�͞��<�����7���d?q��~t��9N�KF�s`�Wh[Sޓ��>&č�0e8�����g�Lbp����f��]5�t��f��v�iF�!�|b,�2�Gбu7
C���� $��̚�Y.<db���b8vc��Fã�=*I%8�jL�W6�+�/bi�@C�����\ߛ��H��<��&���noh9KP�¦P;?��[�BՊd��'Z��/9���Y*�F���*:qn1j,Zt�>2����77e$��]&�LG��^J�����0��E
~02VL�tߏ�x�&c��FxP�7Pz��4p��{L]�m=<"Z��y�������{�S�k�����&�w�$��*�$��Q
n�*/���|z�ZRw���C����<��el�1��IӮ?G����Ig�	lT�g�\ǯ�M��=�}a�.���NW�Ǝ��U&4�!�0a�P!�6�C2�xe��Pf�@�k�*s���ִW�
���Z�T)0)'��`�=���5�nC<�6g��#�i83 2���:����y����j�"��V�
\��!���	��]#��rlC����">��7�/Jl�f��C�M��>(�'F���wj	�a�x�3	�r����!(�T��Д)�t�l�n���.J5��3c��N�iT)�H^�e�MSE��o����6����uW)�s������;�YS@ҏlj�q�핡Y�    c���'�Z�R�qV�Q(���M?a�`�UXqnGu�񑟸��������&@�����ӗ�������ϟ��E����l����W|�%�X����)N��6'���#q�m�z��9KN|	�e�kS�t#�N�?n�O�.��J��|vLVj?�Ծ|�"���@�aD����gw䕋e�����K�x��L}�Kq.��T��=�c���fN�U���Eg�?��7�zh�m�dH8�?�D\T.t�]rwĞ�J�g/)�����������so�du*z��"UΌ�E��.���;-�=2�P��3��=zR�P�EԽ��SKɰ���J��Q[K��S����j�3�c݂x�xG5�UaO_I���3�:t��)�Z�W�N��0 C��V��Y[L��I��[:��ˑg�y2_f�yFi�r�f�%���C7�)�����#�._-�XM����믤ܺ�մ���p&�ݼ�FG�a_�f�NJZ�(t	T8�0m!��l��L��>L�֎�H���"�"d��fo���s��p*D�tYa��W��j��4$������@/I�+���:S��L�pe����u������m���]�(Ӌ��p�� 2d5	�Y��~���"�e'���:����voIW$5~E�6e�j������[�[���B�VO�à�+R[j6��Y�����Ԇ�Y�+�4R�>FS�%?��袠�u�7��Q�T�M�U��v�`,R�HA_�y~g����4g.f�pp��F!�;W��}Q������`����]r@�o4>��n�<g�0R.�Z��rq����&�|�jl�ݡ̚!ho���~�~n_h���̪K��e�n���!�M�͐�k^�l��5X��0lU�(+̣�����#v�r���89ooh9KV�W	;-��pda��m�Ռ�ˬ���1R�l�1#ŐL�u�7tfm�)0��>to��;Y�նT(�J�.�N��!�ȫ��!��XZ���^��kPa�T�¡Wȍ<A��X���sa};��ڌ�ڳ�f�|	^�7˵�O�cjVNe��9Do�TjN���n%�ja*���zr;v�:+�ϲr|~�Z�����p�#��x�?_�)���{�5#��F����[i%Bѐ���&d>�������&1����m�>[�R�B9GY��褽\��$�86٤e��z�3rb��c�q�B�k��p軅�UK�2�n�9��w|���d�y�7tb�T��i��Y�D���1)���x��j#�d�$�Vd�
Cq��44q�ī��v�)�/Qf�ՠ���T�bc��7�nW�n����W��0.�ݣ�����g�=�.3�o�YڗК�]��%�M����|�S��>����u�?�h��G��<.�޸�{RP�C�Ln��}M���zi';�#�{�LDW^�o��X\�.�as6��
��׊���L��h��f�c��������Z�cd�©��)���
�4�[��u��o�ܥm
����XSW=��v;#�2��e�4��B$���G�;吥�t7�s���E�룳%���h~��z����j{���\��h�}H�`2Z59cS����*�	������U��Vk0�uc�����p��B�h�J�x<�����7�2ӡ׭��w�����,X8����&�/*�Y�#�Ƿ6myAyQ�����Y �t&e��'�@40�k���O��\��.��[��4b�% �5��?���^Bo���}� JcPFI)����ܛ��,[##z�v�^��+=j.ۂ�.l8���@p�$]�	�F���w�#�ӮqV�0�4�.�������r|M{��M²��n����ݷ���?��w�~��o/��[�������W���/�~��_����u�����GN�4O��[���+���µ��q�h�l�A�X�S���7�j�/=?��E"�!��缢�ŤDM��,����;^؉އ�t������0�S2
[��K����Zt�Q]�����*�����ǅ1��q��;�7���&q��;����;���àB<~'��lV-t�/ܹ���Ij���<�kԘ1hF� )`$ѣ��sn�^K0�v5��BS�|�Mp���Z��@�������3O�Ҵ=C�k.�r|n�m��о+C#��j+Ȱ��~�lć������_��~��������(��?��7X�߈�f��2�����n�o&ct�,�!��ηM-u�7�w�����1ĭ}�fY;
��]|ǖ6��(�R���+�(�c�x�gS�[L��Ȩ����o�V�0�7+�md�dks;�Ʋ���o��{ׂ/�;g�y�3�p�Y��������a�$2e����kPѸ�����ڹ�_���^�)g���z�@�Hǽ�Ҿ|��?���?	��TX�i��g��$�Ὼ3�]��٤/r��������?}�~� �ǧf����E���Ą�Ѧb'O�ӯ.2�D��9�c��N,P��j�		���a�EL��
V1n~��/�B6��c��]j��|ғ�\�7�����8��rd3��:���n�Uz�bph{�?�Y�Mᶶ;C�[�{�S�|%�р��H�U�
��2�|�yC�q�1��s�9+)X��&C�d�ۥ2N����:
����4���p��������(p����s��{����c8�PG��;lpVCV]xnp(�Ԧ����a5i�ܞ(;��s��I��|��6@}6�]LH�Ȋ����*�V�B��*���fi���wL����#��tO2��8�q6�0���M�������d&展�5�r}���K�\+�2	�GOL�W3y��.֧K�w�QEۙ
����	�(t�܎É�Hq�n�[�!�)�֭��E�#$��Q��N��r(�����!ƍ��&fҔ��]�pu�{���MJ#q@�N�f���B�$���7As���ވO9K]��P����;?�s5�7t|~Ng�|�:��5K��s��9:��=��z%wu՘��/�ћ�L���r-��%�+gB�[�$
��`0ƅeAc���D.�?���'������ӟ>}��~������9ڶ�.�C��d��iw;D̂0�M���x�C�!�X�D�}/|�Y*�Q�x'�غx4�xΌw~ڄ떗�	�j_��]/%a�f�Mָ诳��(��V�|��Vw�J)Hc���S6"����+|�N	�O��N����P6p�e�ZY��K��AF��s��.�'#Aiafn~n����c{Ʀ���Q,5��YW}:�h8�!�:ÆW�ҥ`~�A��7�nӡG-n����)�Rq�lsΥ�5�%�ɦ 3�^ P^�����2�q�ցQ`4xNly�Jp�Ro�U
,�76AQx��K�Ӧ��suL����t��pV��+�n��YJ�QZ=��v�'n)���S;-���Ƅc :���_8%��J���A����H�i���c9C���)7ۂ^|����z[�vzs��p/�T�C�a�5ٸ�Hn�m&u{`�.�k����p����9{u�e�eP�E��b�9���2&Ys�QC�(Fd�ξ���x����� '6�!��������d�����d��#I��dt��v��1Q�l���TP���/93�C��o0�۫���-�S�	h����5�=5�>7��J�u �9���[�-gq�$��	�ܨ��!�kb�o�tm�(�ZMb���R���W�\�.�!��K\�p�VI��QF��y�~��E�8s�'�C=L[�M��*�S֍�J���(���
�Z�7�C~{�JX��/��&d_�@��N�|�g㻘���ň�s�_'[��a�-���)�οt9��f�4�Z�E`�=LEfX�ո(�q���Y��G�]��M]�����4����q�%C�I+��S{
4Y(#���!�q"˝5�e�O��S�J��V��1��R�\����#9�����C����ğ��_������CJN�[��fk,�:7N4\l�������䨃'����#�����%�[���]��_X:>��$Kb���5L������    ��	R8�a�z7�D���Œ+FRm�����u�Υ����P�-����[x�CS�ڸ���V?#�jB������)k�T?J�_}���?|��}��/�݃���'�����9�j���)#���ՊZI_��N��Ȓw�/�g�o~���{�[�Q����Ҡ�5g8��^@�<T��:�%w�M�+�ؗ{_Y.�"^��9����b�g�RT,�^�b4�zk7�r�����ÿ7u��_�b�w�^�.�D|�8)~oh1��~m���1l�������$vY�6z7��x��N�?�O?����T�P�M4)�y�������t�8�tR�]��!�c�2��}��ޚ�k���m�$��2�2������qp���E�w�=Rh��ek��t�5�w	9E�����DTu(͋޹A�dǰW�dH0���G��w���^Q�nwv�xd9tb�^�o�@�:�r]
�R��F��%j�^2�����8�{4�1��k�3�c�Ć�)�E:p�����?滼r�݁G	pM&�r�3�L\H��9�����g�c݈���s�WֺY~�����=��[:�T�.+�}�ʐm\�nVx^/:tj��__��}VS^�y$e|Z�p�3�6�Z�EE�s05�sUYn`�I�����b~o�����d8�2/L�����䋁�\]k>��K�X7��'x�7tb��27Nҝ��΅vF4��v��]��E�~f��
Oe�?����8۴?Ot�Tմ��n����a牘"�Y�w���bhK���S��)��6x>����?�!�\&��$�	�h�9�a�ۘ6�W�]0��L'hQ�*�5�1ˬ �]������Ǚ]��=��E֞Wz��o��g��FtYm� ��GvÕ��$����MT�}���ЯF2yJ���ښ�uC=��!���n��c��)�@΢���$��
G�\_�(���Qmd�.I��/(�4CU8���N�4�-jN���h{��Ι�5��=�$��~����op�R���Ɲ��	��O��Й�]��K�p�r�LU���U]�H�������|RsfY��u���5���p6t�厎���Eg�?��V0r�PU'O���}� 9����R?)���qj:rbzת�"*U7�1��ù+s�F�W�΄|D�8`�^�����5Q�:{Ѽ�FB���"�'\Z��^_8�c~�����6�xW��_4'�\1|=#aǆʙ��<�J\��w���=�hW���)3�IrwQ�7t��:���UF��7��&)e��� �ch{�?�f�/h�QѬ� ��;G���˿`��Gh��bD�d�����(+�lK��]�U���"*#`��>G��*Y��ֻ�x�xi�v,�v	����=�yw��r��|�q~"U�;�ʞ��&ǻOG3��|c��=����mM���y�ү�G��&�}#%R�MY�l����������3�E�z�W�Ou�����r59�	$�@�7y��塑kF8ނ�%��'<&N-���>�_<��+_� 
���y���.��= �ش���+�r<s�[�6{r�7h=y�_:��;��#/ �`���5.X�2���x�Z}�,$wx�sǝ	��J�|b7�[ˇ�����!A���(�)��Bp���k�,p��@�ؑۊ2�����E4
��'>�։�����y1u8�-�,!#��&�4�k��q{��� �6%J���юc����e��2��ļz��d����w�xѽx�\�w�9I�{�ƾ@�՟�s�.=��Ja���\���d(�$(��X){.x1	F��PXq�_���1�R� ͓Qz�H��/��,�lg d�a^]=8O읧솔ps��F�+�f��ܓe��cT��w$�C�-�)�l�A4>z�jp���E�r��08���{Cz/�9ǞMo�Ҕ��W��6�t��Ccj����9�,}�yK� q��W+�$���UL�8��{6�5[�DSF�#5��*�l�d O�)Ԁ�#�j6u�&qS�hd�`�hn]c��J}��y��7�g�v�c$��f^�_�F6�̧Gq�f�w ��4��(3Z�{RΨ�h��o�'�+�F���k`M��ܐ6�hF��8�ZeB/#%r���IZ����h�*�w���d�wߐ^	�@��q�x5 'vH�FK��V���>(��l����z�:;-���z&ݎ����X�
�"��`V��6}���ϭ$�?"1�	}%�:"����h��N�#0�x�Gt=��-�m�9��z������+��f��kIH�; ��C��c�Ed��o��6 �T��N��1��57|r���`���@9q��V4��MmQ�csƎ�	�뜎Y�z����t����$dDN�E?�UG���8�|��9�f<�YZ�q��ߢ���\��e�R5f������+ە�����r������~�a�>IIv�	�$��*���0���P��� بd�2���1O�e���c�o�M�����2�׵���;\�M�:�E�M�H�Fw�X*'e����a�J ?�R"�A����s/�M�0��]W�Vo��M���#|�];R%�0*�=�	�Y?h���O�XKe�qd70�9�t�t�1*v�"�f�5��iI��K�������j#��Τw�x��(���
��"��0]r��}r��͏B+���_ʟ~j��}����3�#c	�_�I(+T;��0�E��K�mr��P��{�h+UO�5V9���4h6,�tnWK"���$��s!G;�;�Q�x9x��k��/�O�>���o||��e��7J����t�oaK�T�åh19j�)�6� ���o�9�=j�B�@]����l�B<Z�+L(%����,c+�iGȗ��7��,�!���t��R#�E�l��5$G�5$�����>*�u[�����l�[���/u^���_���	J����(����Od�<Z1��K�$���#��;b���8J���G�V"gEC[o2�6�r���8A���``9:��B�!�j�OD�o�(�C"�r�J��J�#�О��҄�y'w4�Tv{�I��q��'��&�y�4u�^J����X�o~�r�w�ŧd|"������/�}�h0,9kF����l����L��1��ox�by��nK�L:�]ft/v+��%0�u�q���1ԒzP�y�͛��D�2/ٔ����ٖt� T���J^e%�c,z��<^�ޓ�}���4"\�D/�6I�x٤DJ:e�{B�,H��U�o��W]e�t���ǻ��E\c�\_�/Ig�Қi��$*�w��x{�M��w���A�g��#z���6R9;ě�q�Es^	ɟ�E
0w }�k5��]�竉�_��zfj�l�Ǫ�V��j���qQ�9�.��/|t�8���}�r��<쥽`�o��k�^K jNB`{`S��ו׷�s�4/*=r�}�Ň�F%�!-�j@3�&�Bh\'qG�
ǐ �4>���>rY�Ql�7�>������ۖ���������	9F̧M��������a��x��SB��O�=I�|����m��oD91~/�*��v��a��E�ħy��[rΫ��շ�*�_Z�o
{:��ϳPArh&���d-j�Q����s��Ç�)�g�5�z�z��+��r���H�({��W��m��e����K�w��Wq*[��>ޥ��r�,�g���R��\�K:Z��yI݉��D!}D��ژ���� u;:�)�cn�XƎ�wY�>׺�Dd)ɑ�VvIz/�B��V
]�� n�.OiM�P��{�����&�x��Ufe"�H�lE��	}�RV�E	=s�
3;�yt�v����>�g^y�ʬ^ _�.��˔]�р�1
>1� K3Z���9f�с�����?Y��������%�Jzk�H'>P���s�����a[c�� 06=l�F����ԶB���%K.�"fo���[.���7be���aK�����eg�OK�
�{�;    /�~G�->����x�#�t��}��5!}a%�d�s���+�I���9Y��07�8-I���J`o;�l�2h��,tR���p�sG� �7t���`T��l���Ux�R��S���Z�>H	,}c�"�������f���%u	�*H%l�en!���4CA^�K���:M�r�m�Fp}DZ�*
�@�jQ=���8	 $c��S_�[7�ޥy�f����'�;"���6Q����X�sT�n�Ԥ�[-Gge��yr�6����k�����!0��d\��k��@�่���V�s�,y�D�U&��x�w���u�0	��B�m5��]���N���#�U�h�^�䐻�y��ܕ.G?�^�b�w��� q\��8���S�Md���%Lu�$ra�`8rW��.��� 뭍��˓gMZ��y����:=uKb�� �ҳgk+K7t���7�#쁙[�Q�I�h�nH'>Un����[��ё�ƫ֫7}��w_f<�W�
/�ak���D���5�+ Н��"8�Pn:P9�w|�s������Y�`�Jg���J��J�+lE/�&��V{��}h��q<#���)���8)n(s�O����� �Rq()��Q�&9F��ڐ1����_�-��ɼ�#�{=�y� ��f��)�0�#�M~~��T�R�숊m��(���լk�g��7��M�C��t'�v6k� G� ��>��Z���p��8�Q���Z����7�*8:��x'	�g���
��z�HZe��	գ:��>$�����d�]����r�Ρ�2,����{g���.��#R�0�t#��;�e\��Ig�6���݉�с }����T]k�&�:vĸs�D��ȥ0�ĸ �� ���䀽V����}"@/�]C5�V@�~L�y9�B�RN'����"9���5���[7�NÅu!pi��*�x�w�ԫ��!��������U�t�Շ�Ɖ��E�V4��|~h�Z�ٍ�:/9f{�$���w|҅4��_��VZ�N|���t�V��K6}(Y�B��SS%��b_й��wlj5�XtIy�O+vk8�E�^��P�H6���ުs�C�Ky[�	��O���E+�ҙl� �����y/[�Gv���mA3�8�T��D��[��X�Y��Z捯IgP�<�W�N�~�G�C�$�>���&�����~��[A=/ �#�{�s���R�)ʫ@<T1��5E�V
����7�P< +*H�t&K/�T����k]_]��Irn����>��b)�"��="�������UL	!d�Uupݗ�}~O��W���]ʢ�UV�?���vR�Ex�"�Q���L�ҩ�i;�R�r�9D]\ɻ����3���s��&����Q���P"�ٺ��KҘ/4�,1��t�NK��l�����]��S��&��8��Y�x� /ׄl�	�ȔT�w�dn���7�:��
IIC��+��x>���[�C�
��t��|�0��n֕Mҫ>�5�B��@W�vnmYw#Q��zsJv���i����;�l6D�J�[�N��F�T���R�@|BF�N���R�p�j����e1on�w�V7�W|�y>(� �3��b��m�\����}��T������. ��i^�z7I[#q��̔T�o��2D՝0�kNu>��r~�mW�`�E�������U�qCZ���|�	}�5 /��D�6�ȹ�Dc=# �禆q·�G.��@+7��0ݘ�&���P�M���Fd��[�q�w���z@�	qq����;"��XU�j9��3r��CK�*��'���6�9���·�_�w4TZ!-,I���N�!�5V�"o{��̀�.��_������w��Wi������%�t�f3ކ0l�7&���g&E׭ꡌx4{�
��vx���;'Wx�z����,��%�G�)(��7dK=�>�~�a9�mӼm�"rE����Y�,I��y�B5���8�� �L�nR�%�4�z��g���H�ÿ}���U>ڒ�9T�]�������/{�C5u���;��������K���o��]�<���b�����Zq ��SVO��\[bז��r����Wrt���$��fkŏ�{c��$����φ��EzN@���5߉�T�^�(mJ��FD�h��4�����_̎����y��D�K�����Ck�r=>Mguѻ��O����.����)��-�)�D�ʉZTv<I�1+`[�9'`ݳ�{����0��L�����>7�T�C�������'�Dz͗�%���Rp@��!0���S�
��Pn���|��aH+4��ύ36I!%&��V#�'p�h��k]9ָ�Nϥ7��4Wx�f�cp���&iw8�\��z���5��"g*��xu�i���'ߏ2����������?��pI#ݖ#��-l��L5��3_<d���j��T�9�E}�)Y8�V��MP;R�S��˿>"��C��>�[��8��AN�y�B6�U��W��}��%�Ҋ����:���6�T�����e�X5��&(���4��lYy�&��+�i9���Dj�KZ=�eƋ�]���)�I����;�(�F��'��(��įV��%"ꀫ� E��g�8�l���
�y�;�gPo-P[
�g N��ٯP���#��ZvR�C����pj=�]�v%�Ձ��Yrn)��^�g��HlH�%%-:��( �"���������Q�2��hT�-��6H��{�%Yz@�q���>Ur=k���vz������i�_��"�� ��Jg��U<V:�-���C�`���bO�Y!n�M^]����I���/Ղs��/���ٮ��%O #eDf�'��_1���-P��z��"�#���s�~B����b+�ȹ�_f-љ�L޹>
sv�/?�<�H�e�= i��f���EE�ԭWh��!^�GUZUc�X����<����%_��K�=�Ϥ͡���E<3#M�cB>�z�F��r}p�gֿ���.w���(id8"���M'��R�fљ�$��O�4��.M����,*��n�Ҳ��E���%f�)�̬��e��3�ڐ�3iL�ޓxV�nv�*[td�="��[�s��W����.����2��N!��;]�?�<��Dw0G����p'5�^�/����G���n8ι:��n�����Xn������.����S�w�v���A���w�y�� m�2��/��o��Q�&�8�3re����n�'��ɻ�0x��1��Y��M� m�]��"*{F���Dn�ѩ�Mlc��9�nWK�m=�.�hq���k�8J$����P�p,�|	ݷ��7E�e�
��x��7�\�5����WxQ����'�M\(�̣+�ڮt5���G��W@�_���{R�)CG���rͭ j��IV$�����BKi�Tt�̼a��0e���~%Fȸ"BD����	�W���dO�y���U�BX=��k�{��b��Y4����G�F�^�%�K'��;��^��i p���H����)c|�h�.X��2�1���N3���~��n_e�,�1D:��pC���Rp��ALoI"u�E���gO`�h���uQ�>lõ����5q�P7�͡yޝ-
����7҄D3��ںJ�4y�u��l�����~�[��o���������t�FK�o���U5��$��o�� ��[!�(b�j9k���K_j�v2��6��H󞲼M��\&���n�7F�N}������KMx�G#��Y*V��X���΋u�T|È���{zˬ�5��'B����o���$j���#$�T�9Y��8�/��}��c[����O�����FD���ľ?�U�N�Lle�����M���M��b0��o��Y����&�^~/������"�"�O�J��5�D��� ���Ќ�P�5������gF^�q7I����K���+���'	�����PТ��s��?�k���>|��˷�ԅu9�_^
�H�ad�ť�����Ke���+�k)	��>*%�^�%�\�꿗�[���_�}����ct���1PL�؝�"T<�    �8��Y_��9��1��S���J�m= m���m:J��5�^z;��>�|�7���x�q>¯~�o����A|��/��I�N�P�|�'�-RN6H7H�o�yW)��{ў9���r[����a����
`���MMϮ�Yr��;�& �)ԇ� �B*9�ɪ O,�I��^������Տj�W�������U������M���D<�G���+c�R"i`*�E�,r*A�Һv~4�{b�;¼����ढ़Q�7I�2��r� ��K����T㨔��e��U������~�p�v���r?Wd�uDZaʄ�+��w�Ndn"�J@<=�^r�g��� M��ʫ�^4��$��Lb8R�Z �ht�HAx�ڵ��;��������R}��>8�>z�c�N��{C.*x&d\I�D�/�ζH���ѡ�����ziؗ9�QJA��j[hG�9P�˦�9a�3y���d���ŏF��U�}+�D�'u$��r��Az͗�C�loE���cD?l�,��Z���K�wE��-�X
��lS��:!�2�c�F�mp.j?�n�NKT��뾅v,��sB�_�л����\���G~��z*�-i��\g�P��t�-��c8���D����A��a�Vy��������j��>{�m�J�nHϽn�3pFJAwԩ� �h�v�2>� {��]/��w@m?"]~�:52���2�Q�Gv�P7��b+�Z���s�--��q�h��	6����-H�llj��:�C'�J���|��7t�l(�k���D��v�QS�x������ؾ�\�O˻��LT�glQ-����"��dKCQ��đ���EZ��U��fde�͎G� *.��YKk+5���������Ӟ=K���H��Vr&U��D`t���hА&J���h��J?�	����*��?(�Ħ�V�K]�0�S\[6��xƛ�?iwDZys�'�����)>X[��r���^>�ͽp��9"�xs��� Z`��DV^�m��g$-=άoNK��)�isD�j�9/L���`�!���;�E�H73jb�1z#�N9��.���Ԧhxe�L�`���ΌExv�<?�Vj[�R�#DQz�k瀗���Ye���|ϭ�fh2{r���^��D�~�Ee�֣)Yမ(��
e���|>��	f_M�v����s�GU��*.���:L��o'|�d�j��ෝ�K��{DzէJ��u?�O����ʌ�-����~V�y;���������w�O��}����
��Z?��"�e��;�*J�ě)5�p�(�X�e���=����6x����ַ�R�u5p� S�E�?�n��'�ǘ�N|Tת���	���1�榵�E�Ͳs��ڱoU���\�
��|��
CS]"��qC�.�&u��e@��s�T�k�Z�<�<*���0���\8����/I�aJJձ���Ϳ�)bQ�W6g�Ә|���<�������yuD�(Gˬ1�h�n{�"�!mJ�]��{;v��;�Sþ�}���(���l[RJ�ʇ���id�q�m0���F���S�g����$�!����<��l��� +��sBr�.{L?O{�[�6��re��ep�&m��m��d[����E�7t%T�L�p�ouR]4����舴;��0��VE�Ӆ����3�G���e�Ty��0qn{rOa.���i5LB�X�EP&8k�0��R8�6l�}|��y�͆��M�yfͪ��/I9�RK�$%k���2xh���>zow��'�V��(ꕺ/I����m�Y��ko��#[-��k6�ٶ���
s�=��C%m-������r�Q�p�c��h���u�#���<O�l��9���W�>�5��i�6V>�ik$_��Ԑʅ�)��y�щ��ͨ�Q��r��M�Yi9<���^�VØ��tD>_\ܤrR�f���ܐ0��=Qg����z�.I���*ے��i6p����CeV��z/!=(�<��q��xt�4:^7���d$�����h�����p>���J�#R�}��c*c�T������_�T4�(Џ��E|T��5y_�JnDk������6C�+s1����H���ld� iz�h�g�'����x��>O�{�(z掝�0����@	�g�4���Ю	�{{V�w,5?Ew�~Ip���_����u��ݏJQ�$us��&i}��Mw�kZD*�,�I��+�ل���ܕ[��^�_֟>0��pD���#>Ϣ�_�j=�)����nM!��&S�i�I����T���>�OH�+d�@� ���.��o�r��9��\[>ݻ�<��O�*<����d%����W�cf��c�z=v��.����#s��G���<r�ts���d����M�$EG�s��`m�3l�y�Is��঳���bY�&
��&rxѸ�(�i�k�G���M>�?���j1��t���L��y9\"��vG3#3����W#�F�;v%LE�{��
�j�T�>�Ә3�bvv�;��aOFɻ����� ң�=6�Z�\ةV�C���Eo��Y���A�n�g>)��#��@���F� �ǹ��[�J�%>���D�R]T嵋jDN�QH-�&>I�_�7I����� ��'PN[�!5�Y7U$���0<�2��8t��٧#��@1I�e&�0EVM
�̔�]�C�MPwU*���3���&D��w�[%%*U`n�*�Cjl���
�A!��?�?��gf9�yA��$I:���O��Xh�{9�]� K�e{V�GNm� NQ���rG���r��'��RFzZ/��f��Zө�!S���H��c{�#���iw8$ZV�s�4v`��H�V��ֽ�
1O��s{����;��pHB3�#U��K�d@vZo���������)��T�I��b8"m�z���O1`�mT�(���M�Xlvz���"�N�#E���1�v?\� ��@F���v��óϑ5�`���b����=E����Út8dՑ���)6�rS��΁w�]����uܕ�?�H���S�X�G�-E�͢�ː8��2�I�M���<\n{W��9E����Í�`I���Y�ħ3�a� ���W��"��&=(�<�����=��Y�����v�`2�4Ϣ`2�ym�\�(��r\e��e��E@x�~b7�{D��d���"$zW[��M��e��8eF�w��Ȫj4���R�;\�lVM4����H��_%e��)Q���'�<�����"�0yuD:V$�j@�4m]
@릪;vt��A�Ỵ���Dz��y��H[�j�e-h�b}����fB�>������x(��1�]�/���rѦwoQه֦���sݣ�I�HnO�y�υ�3��I�"�&��C�$+�&��@���?R(1���.�,�#Ѵ�����7�ꚴ1P��gC�Y�es����TGŔ�����*�
|W�fϲyit�I�w���-vJ�F�V�!��(��ƞ�2cRٮ���Ū�*тQ%�ߑᙴ;���P���jL>�-��Y����f�we�������oG���^Yd��H7C�i�@������z-�s���;�S7WN�?��Ev������c!�f�d�x6��$Rq�ȚI�GټN�������[N?��A���0��zDG�N��l��Pl�	���P�ï ]�y|�r����iU?8<G>���G���ɶ��a`c<�s,H:�B����[�-����]��gCm���Ftu �p��G�5�;^5���/�ʦ4�������<�v��<�1@戴1���.������m�<��}����.���z<�U�ҵ��{��\�d~P�g9j�7��t�]j��7�Y��|vf����t,���o��w��a;�++X�'m��5����'d��ڷdA��&�K	D`��{�v^�Îķ��;��B�#ҹOˋ�@�({F ���0o��Y֎4����;����Fܡ��9�DHtG����e�&�N��g��P Dl�cL��~���y+��CSm   O�3�`˺��IA$q�@�ټ9Iŧ��QN�U��]�o��l8��>��%rT,%�� њ�ǖ[f�:�����]����D<�qq7H�k��S�h3�cҽ��1yҵ��!i9�="��C>7�g�N��ǉ�(�uIt^��bQ��zޢtx�4���+gn�d$=>>)�b�l��{UP��4���\Tգ��sV���2E��NZ2P���nϤ�Mq��Jd$Y4G�xQ��V��NQ���A�g�1\�)��v�t�.��r��,�F�r�#��r
�75�>=COh��I��ٷ}F(>�$��
Ǳ���<�E~�����*�a�`x�
"�*��>�҇*�}A�:�8^.-v�O���i1�"�u�-Z�ۨ�.!u+h���u�O��f���H�'����@L����O�J���� �����W��*����6ձ��H�!V�^6�6 f��-'n_X�7i�;"��D4l�М�i��I����2�1Sh���u�v^�C����k!�����(��5�B)Q4	j�H�{�b�]��'����)���OM�vH�������x��8�hPV*���r�c�]������|�H�9"���G�Am��
�xJ����J5&r�1�����2�w>��/�$G�uC:����0a����jxM�� s�U��Ө�ǲjm�Kg<�韮�4L��˩#�;}�C�Z�e�I���/r�9��H������w������	_�I�k�Q58ra?ͥ�R���[�����|�H��_c�Y���"#�+�*�*�R��A)g�_�*�lq1g�3$��#���f�z0H�@�Bhia��᢮�i^����Q�tҟ�6���a�5�^��˖���\�_�N��&�TH�R����t¹ذ����[����= l�7���q��6�%���rWҹ��$ ��L��XĿ��Hs ?�\��_��uW���W��?�����Ro��\��`��(�*�/c�S�좻�	eْp�|ӥ"����m�w�k����}����������ʄ����h�I'v/8fF�bk�%�F}�]��o뼰0��.����ag_Hg��[�fEg��z�֌#֎k[�a{hm�������3��i� KG��}� ӀeJim�"��%��|�s����q�cO��i�SY��n!�ig���E���`�B�K�=	��)x��G���{��]�����·����&��'�����5^J+��� ����A��x_�y�����
����ҩO�U��)�E�a<k�k�g� ���霬Roy������Ɣ��^���es e�v)���:�{��MH����~���م���JJ��
A��NQGsD�*���3�i���7�w&�ն��o�����u��&b���y��:"mUJ�i���kz�CT�l9�p��k��z��
�V��f/f,Z��98��k"���,O��O��\��l�.�eo�:�w�{9�D��6��T)1+[�n��ݽ�z�=�:$]rpJ��a���H��*)�d��[��+�7���tz�y�H�9�҇�W^v�,�䘻b�6�w}�hy��rG�KQg��9O0���4k�&��Z���9/x�و�.���[�&i��&��Zah�g��gy����SttDz���MQ����ľ��F��1�����fE�v�>{�8iI�oC�Z&>Ψ����j��Ռ�9+\>��UU�\s��=�@��2�kG�5f�R`��x��.y�ժT>���~�����L��      �      x��[YO+M��N~���[v��"p��}�>�	Y���� �׏]Iw�;���j4#!.xԵ��Ǐ]VP��	O?[ ���E�	aa�*�9-�T5��&�&�@U]c$�Q���k�P9�M���7�X[9i7+�ɨ�4���O�Z�Q -���ty ����G�{g�r2S��.i:��4OSyB��j1U��}<���Ϡ/��h�tf�Τ=z}＾G�����F�q�jl��3l�[���G7���恎������9���_�v��Ǎ��������j����K<�t���_ղ`���#/��ES�}���^���BӦ�Z���=�0 �uB��<��t����6R ��:D���v˧f���@;=7jƿ��_��t���׏7W������}�k��">���~�8_ZI Z�*��]��-���Htua��F�)$�(@d	�hS�E�,@�ha�S��x�]�\Td�G��K'��e�����l Nf��ߝ5�����^�?��w�'��z�wu?^�eV*��.L]�H8@�7A �*>�A<hc��oU��l	���)�48��I:������x� �躙F�F)2u�w�-ĺ�uԑ@"�ȥoA�\2�즶BLCs�SP�m��;6��W���r�k3�����������t����o_��ooOn���Qy�f�W�U��8�Z�4����I�s�����64F�/�3�t����{�����դ�O�|ٿ[���RQkM�-��"d�JD�˘�d\x���R�&/����B��CD�!�:D�.�g?nv�f�*	��Q���׵%6���F�"���%����T��t��ml�G�d>�y�LϮ�ڌ��G�ur��﹯����`��1%X�]Q�2^�l��*8Go��Q7nwF���HEq��Z)��Y���z�M:�S_�Sf$2�d��,@�\\d�W��������a<H1O�M�anJ�:D��Ӷ��ԏ�j�t8���G�_��'������:m���cߝ^��oWۙ����R�� +G�p�S�#F���A����z��\���c3��
���>���A�P^��8�??j�̠���8<s��F�pZ���(���X�.P.���Q�l�H���ƭ�ΰ?ݹU����˷��GO����g_�oӍ�Ӿ(���,Cه���	�@W��Ҵ���,�E��a?v�#m�����睯ϗ��M���{p�}h�;�j�Ý�j���v���ߔ��%,3R�'u "#���&șg�����u[�����/��NW;G��8}�ݣ����巛���%���Ȕ�$�8�	r�_蛆~��zT��I�����?����i�t:������_�Ϯ���$䱆�C^��r���Θ�J�T�(ʲ�a*�,C�$�["�����NF���a4�ϫ�s�zH��Ӥ��j9��Z>?�H�`%8� 5�Ҝ�.��ڟ}�/�������q������w_�G�]��O��Ͻ���g����mg:��[��x��[U)�G�L�V[�rI�q��/�-�9��ܓ��M�kc!�Ǣ�4z�PH+s�f��{V#�b�R,0����Ҝ��e<�oU��!v\J�|-�^!��U�B�ܦUɅs��%e,�t��=ЖU�ӑ�V�(�Ve�Ζ夢lN%��M������\kSh3���4LL���wF��i��"N��!Qs�t�������dd���	ucH..D�����´��	z0��\u��a��s��UV6�P9%�* �3hV��R� �sJqݻ��͙As�DU$���Y^�ΒQ<�E�+�$�H��AN$����%���X�pF�1��b���:�Z�+�f~gW�vxxt~��2�;�j���rv�_gW�/.�GS��cW�z��`b(��F��B��h�9������X*-�S�V��ꫥi2����d�'NP�b�&��g�8~?uv{���^�;T��E�Qퟶ>��W����5�٥p������үA��#�h�cŇl�����Q*g\*�f�'3�'N��&ɡ��YE$-���KWG�c���3tT���Nf�9���RDH�$uBN�t����pQ��R�h�^�1\�-�U�bRq�n�Q)�!����>�! ��T���_�aM�����t������������}�r׿�v��v�����(9T,s]�ɑG�a�ha�Cr��D���tɍ���8S�#Op"�-r!e�D�
( R$u����S���;YY��d?k�C�~����"��lȇ��΢Y�^�r�<��$1[�P6�*-R�x,"���X�77s̢Փ�@%A+����+b�DJ!UW�\,M�􏋺��99�x���s��t���Xn�.���ǝ���H|�}�����t��H�,L�����jW��d�7ѐah��p.3z�\Z%ը��m	�������"�|�Ԇ���e���z#M�M�6��V�:)� ����f�-����8P�6qL#�g O������IP���|�	�w�N��4�������ת�m��!�}.�Qe-�&vC3�ހ�t$ɜv��m�,��3�W�����gTPRd3�xgY%����|�I��4D�)n*���'iYܯDVH�%�rz��N�G���'�O�Dn�}����:��>�^�.�vG5?��޿&.ùR�%j��Əq%��߃Aܯ�],ң:_m�-���'��I�)-��ľPf6�E�N�g���j�cJ����*BP�|�B.H'�I�Q������������ՋP���K�}?��\����}�����G��k2�gO�/+�Q�K�,�V��4E�P/P!�9�����L-�,e*Yf+�!45$�ʖޞ[�*t�%�re+����Xϒ.a2�b�4�$�:f��9"�����X)kV�;���jEv1��C݂�e�q�A���p޴>*����eQ)G�����!ZJd�%be�L+|@�&3�h	)�:�mk�&�l�CzQ�aM$��DS�m����=(�������!
w��r���%t�����e�Y�G�#ȖI;4�*�L��֕c6�}e�?� �����,�8���t�ϣ�s\��=G>^V�40�I�w~�������M:�E��:ʳNRݟ�1����V�����K�׌�B�g�M�$Œ*Lz���6���|U"f�.��)�o_��J C�P
XZm��.*��f����C2T��^G�FQ������Ց3�q����7�jN��f�Rdr�`ǐ���|N�#M��\�PrW��jCi`�� s
�"D|` � �?�/2jm������y#3;ԭ��ƍ�M[�������_ϻ��h�R�r
E*������QgZ�%H���辐�t*�N>V��%���HK ��ո�e��7��#%\��z�S<ќ��t��@���.�htԏ�Ø$�[�qխΊ�x"<`!��L����d?[~⸩���l�@������Dw;Y��bGQ��s��%H_�LU���g=���(N���`����%$�����),g��fs�0%���HrZ��� P�l8W���M�*E�M(U6�/|ú�t�G��&�l�΋�7��U�� !�~�,,}��2tf$����l0,|�ޥ(YZ)�&T�;2/��(�(�tW8�<�,"
���"*��)� �.�_��/Y��Ѳ8S]>o�84N��	 �ei���p�OKi/W�~������޳Jf�T,�T���	�>_��_ov���$���N��&�a�����ٯ����^l�t�*��\�W&�h֭�|P�v���0$!�%M���n�$׈Hr)�U���)b��j�ҶC�[��V�*@���x[�!R%�h���j����U"�i���*�$a`Ғ��`��$x�Ūh�@��R���2���N}\��/�r�P���k��s��}\�v�Tm.��_�e�.��R�V5�%?A�p��F�F�*�]F��"��?$#M�1�]Ǝ��y-?ҡUj��F��������d����}�x����څ'��C���.#InV��e��P̈LeV�ֲ�2F�!��Ш�ƃ���a% �  �B)&ae���炂��HIa�:��W���2�;�T��`6�w<�F�v�W��}�^�Hi���_1��YG����[�i�!�t�j��P'o�u$Քy�Hf6�i�ʓ �]��K������2�U�/��K��{(fRO	${���2=�E:�r,�_��\�. �8�9��5	�գ�����Og��ϯ�����=����a?�}�6Z7�N[�{���0�ˣ�S�����3��į�^���cuE�v���e�랄a�\�dB1�4X�����04_Ƀ 4-��T��5$�L�*�S��.�J]xOV�&�������H�6C�˷�z�O�3�a����(	��}�-��� S�Ci$�-��!8/� ���/�u����2����S�/f巺Hrۚ��,�U��r��&��e�4s%���>�_/v8oo����Ŏ�o������/���h���ў��r�,P�:���X���OTDjif)�0CN��|�����^;ݧW]ɉ��(�����B,�`�=�-��[8�[��ʿ�����o��;��e���am���"ib�'�A��n���N2�U�$A����!4e3�����y��c�^7�����E���>����!t;�,�c�ZQ��Z�%���)�Nu��?H�wQ����)ta�@ED���f9$K�l
S�U!�'7B�4�˦�[��+l�o�dih��P�hЦS�<�R+Z��\p�FH��v�^2E2�Z����'��ɲ��?Q�Z���      �   5   x�-ɱ 0��&��%���tz/��7&��Q�jX�0�6�w�|�$>      �     x�E�ە�0E�o��_��&����{G�|� :�S��KzY�MVy����򕙞M�ܥ�M'^G܌w����jP*l�HoY�#Z�����tGF�mx2�^q�h �����o�|7囡�{)�J�N*6��G@�
z�����!a�?x��hqjCL��&8���	�)�EacGxj�v��c�����w�6��]>u}���]/���Vk��S�(Nf���n���ߒƫ8���l5���Cny"%���V,K��be�iҗ�1��n~��y� ���=      �      x����n#M�&x�DusQ��l_�*��wqE$�0w7��,��f�A��L_��<J�ی�S7wFD���Ed��H!?<v�wv��!���I��|���D"������M%�o�|�����������`2_ͦߒ��K;����ֿ-���t�p�ћ����f�o�J����۟���|[���n��o�>8}��t6X����f0[
n�ӷ�h�����_ ��& ��	�S��CH�:2�#��c�^*�l��,E�p�o |K��>8(������������5o�~Ig�^�W�/����T����T�_YO�ȥ��+R�
�����^�*�e�á�FR��������wh��/%g�4M��� �n�aV?Y|��Y�Fz�/����R��K���Z���\�3�gDB�$����|��&�!A���%�9T�g̃`�|$�����!�����d�����OJˁ���j��}K��/�5M4�x�jw����:�̦����L�V�o5>9�r�Ǯ�N�/�um�E������,=�o���4�H7�Z�m�ZyCGr�@H%��+�>���3Lq�'¸@'�{q�Z���A��8��wtf����;��p��B��#�1�A�`<������[=���Ï�l�u���<\��sS����i�w:��7I��N�,�|�ncW˵6mP���F5'�Ph �&�"�\Ľ� �)�����;a��F��#�*�PGP�c����z}���g��l�V�O���a�</�3���}�:h��*M�,���g�t:��3[�D�x��o���o)b�,>t��m�ע��ĀF���-!��F8�E/$��@\�#����2��uq��42�o�#�i�y��H&�Q��;%����(��}�\u���l�_�������z����]Z�+�3�T|]��lX܈rN{�co������ҳ$u��:��~k�ߵ]������ ��yo��������K�̹}���B�{9�ZHQ�Ok�J-��`<� ��⻵W�1c��ѽ�N����x���zy�}��s`���[o��+�t���Vz��.����D�~��;����[��1!F�Jo��-���se��4�Us��rv6ݭ�N���ҝ�� ��z.��t�C�+eR�ʫ��1���ⵖ-o���-��쬫 �H �cO�@Q.����j_�/�nU����C)F�\IkB �@Ǖ7�u_-��x��X�씫�\ Ihw��ϖ!k>�":��s�����[O��\WȎ.n��,�;�-��B��Q��R�������x���	its]��1\��,��
0��9F�N���UG��:jn����LQ}�(���VI���>%��q��L(����-Oz�I�9@�I� �6�t�#�����������?���τ�?���o�������������3��#��r(���? ���:�#�_��>.�f'�{ɚ�Z�*K.upś~��1
;c��Ǽ.��(��/�cxh| ʸ��;���o2o���v5
WK|cQ����޾�n�'q$��5(�Vb(�N�#���1��7��&�o�l)��f�e˵R�=����	�C��~\�er�OO�U���|w�ζ�z�y�&�\�������xn�F����ۯ�H��0L� O*�10@�<-	�/��+J1�/����?s���a�UF�]�0�݉U}vP�Dm0M���L{	OO�ƃ�����h5�-�G�����A�i��۽9���2���NhY��3�N�iX�ou�@\�v\﷕�{[���
������3��$u�q8��`l�����	�H!� D�B�"3��F4Y�KVTqD�z���^y5}w��1���Q��-�<{�=�%m���nΟ^�n��,����+O8��i�QH��i��-k�g)�1�P����;@�	p�)$�ƳւL�����a�p��x��܌Vd��-�i��^v+�3�^f�.^�f��V=L2h�y�?�C$[9!�l\����u�H�΍�ҍ4t��D�q���	M �	�wJ�u��N$�0��v���^s��O�������`7�8�a��t����q������"���i�w�]Z/l2b�Kn��CfZl�ֵ㮵m���P���8%D*��>��8���0��N��/������M��4�ո��?��U��y���&��\�m��c�l�Gm��:8j>�ik"淧���p��Z�Ȍ��/�z�R���Y"7���t�4��7 ��$j�v��H`�6�ǌ��t�SE����;+�8pF�ar�1m�����A��k�;����A�o�"�`� /�]�'��_gɚ����o�

]�̃�Fc����>ͻK]A�~�F��Á���qϸk
��$��E:�JC�};y%1ȘL�� �k���ɔ�����R%��x��bS��	f���������{�<;�:��f�t��nr��:�t��®Zݦ�_���+�ɸ�$��OU�͇�	!����<�O��\)����Cѻp�>C�^>­0~���\~Y�bF+ n��׷K�4��Na��}L��d~�Ɲ��@	�?V}��(�+���a�?�������,+�Jo��4�2������^����PF�}7��Fnl DR�-K-�6�E+e �\ �7܀ )T<j�r�=�Y��h���k����[+�\�xE�T���ʝmz�W���N��=�8~�U!-F�dħ<��&���0\3yb��/�?��m" ZF��(&G$��'0s��fE�.i��#$c-�Z��p%?��7���9=��%� �u8w���J��{�[��<xу�3\�l�%�����=�{�����h)�P� 6��Ba=�S�9Br�my�0�L6���wKs�r�R& ̶j�967p�9��=<�/�|�n����/�m~kN�v��Rw���`�؏���,�w��_�]\�:f�8���*p���ݰ�>Bm� H�ѯ�FfF&jiT��O���w��jz���9����K~AV/��b���"��ͺn��[�4[Վ�)e���N�4B�� ���G1.�A����,����an��&�X��؏�P~��S�a��#��c�͜Ĳ�w��'�<���r�?���N�0v6���R��J�~�*|J�b���+J���p��i|$ڨd�Ql&@��!� ),��/�a�]�<�sS�6�d�%�Z�hLcc91����}��ז�$��E�����`����=�������f�4L�7N�m����Kv[M._+��ط��Fз5L�zUu����ǚR1�<�8Q��5a��F�b��(�=V��G��HXDl4%�,^!�#����������኿.���[���Q����{=�K� ?clS�薽��
3�SdhI��ڴ����G^�4�S�	�0ք��4��׾b�����m@�F���9��a�0�~���������Wd�˹W��ѧ�ۈҍ�������z}��1Yn��ժo�T��=��LL����wrO4YZ&��4Ň9 ��^�b�ʰ�����|��1������j�uˇSv��l�(z�V����
C�݀i@<*�e(78�.ޙ����(� $!��GFwSiC���<Js��ʘ�DW���Q��}���+�Ů�,��c4i[� (��i����d�[o�j{�к���^&�I;u��B�M���k�b	�ͷ�����Ҿ=B���jQ+��Id<tz>b�VQj|J�Ci����jl��`}���BA�c2]��^���^��n�*�C0��Au_lj"�y��������3ou|�/��N_,7SB�	�-�k�g�A����0L����eӆ�G� ʬ�m~b��)��؈NC-����*|��Ue�������]	�f�D���-��%�  &"�2b0�0
�	wE& ��c_ť?�yb�f�uv��e��o59D��N��ae�m0�!�ܘ$���s�K�X)��q�	�`���h$$�X"(e��l��H    ���	�;���䡥e��!r����`n�Q�v�����9<P(nU����FkX9��b�O�������_H�'�U�M�<W��.,�3�o F4d�A�a�h�c.0o�BI���zD��srmv.�<6�EĀyH�
@ �C|���B<�P��G��@�v�jr��,gs����+��f�=�+�{A�v�o\� =�5�>�N7��i>��[�-��ߚ�;�=9���;��վ_j��ce<)�BP!�D��+��������6�_#�?:�s�44��&(,�k��<�ru�L�������U9Oz�W�v*�~ݏ��j��.��ܷ_��1: ��1�:0�Kk����(�G�ʥ�ф��jl\�7�Hn�e�s�⌬lȸ%6���q�ݴ�KZ�b�j�]���hl��K�y3��t&�E�]*�U>5`ØOh�J�I)8;1d��li0��|`_j![��8C�`y�Z/i��w��fkp��J?.��Ņ����c��ƪ�j�4N�k�jf�'�ja�Ԯ&�� �s�L�ay��z�k6�eU	cȂ;c��с��SC���(0g�&]��8�Ct��aSrHX�b��,p9I[��
\*�W����=�����*��<��"��#�~�>��wq�$d�c��M{�	 p����9
{Ʉa:$_G��3GT|���bQvI�����H�oJ�Ɔ�X�c����^ɜ�a��7��0J�T�M.h���A�}�{��9����k��mM�������%we�:B�$��WS\�&�N�F]�b`Y����+6 �;�sAc�/�Ünfҋ����7��+C�����J�n�u*������O����x��l8�g�U_p���z�BE,���~3��T>R� αK�|�mo����e�F��3��M`X l�2�^��{]�I2����L���Nn�~P5����4U���;+�WG��u���+[_��qG2��e��w�t���8���a�p(�p\XG �(ϸ	�Zn	��M{d��0�v6��~t��\���l"�;@Q|uD��5VXJa+���!�_����n��`:P����Q�����O�02>22�dv���ǵ��<�Ӳ��aЪ�;���@#�@$3��G"��2�Y&����.݀aWfS����@�Qb��S�;���
F�+����a�
ݢ���_�n�LH�DݕnT����奇�W�U�w`zP[>y�F�;�S�q����8P���b.c�[�� ��b�[`H�;5C\1�&l^@RJ�S�-u��B�#����ǳ��	t�I�q���Y��p�FqTlw�|��Ь�@�S^�v��U���ל�j�}OΟwe�^iD	Y c�����AY ��7�H�"�a��1�L0Iϖ�T0hy,A(�,��	�m�a�W+5Y��R뫘�m�6���uz��HFN� ֝1�Mpt�9AF�I|�%_} !��@\�l��qq�|o��i���8��6{[�_4���մw�B�裣?酢x7tA��W�Ǽ�|�-�xw����<�%O]U@)�t�9��h���|�(~�e�6..�f�L���j�Dc9#��/����FIi��1�uC���0j��2:�u���G�j��9�K�|�:3h�#�oD��A�g�u���n�K�f�X��S9�]�'c��*�jg��@��!^ך�A3yg�;;����.�Z`?p5���2:�&I����N��ܦ�q�3l��d@ʶ���x�b�ҟy��R����,�9ũ�i���PrZV�L��lh���r����Zq�\^,Az��� x��~4�ڇZ�ؒJ���v��3>�al��������9��eKX,�X��(ӫK8�Zs֜�^�z���E�Ar��"�I9�b�����
���ar��TK�&���6�yh�%��0��`c�Է�N��v5�����v�R����	>[�S߰�1�ex�A��4̸U9@@A�p��iR����|�N���>�ǳ���; ����ɂ�����z��D'�l;�-�i�mӕ���y��R� ���Acb�fD  �)�"/pQt�k��?^���qq����4t�o��� .�)�;��sn��P����w@�*�-��O>MJj�p�m?9����QwVM���)ˬݪ�y�Yx�ay=X����4�IH)�k6�� �&q�0� Y��ӯvH��ЛG�|(����zw���U�. wA�C'*�h~��f���Nc0n�G��z�L6}5�(��B-�3��[)-tZ��4�8GHz�~�Q���R|0�ŃL���s��ׇՓ|Y��l��R����ҋ�12�?֍5�$ 6�.�qc-	.��`�7�D	.=} ��l���]�1۬��75֫ЄΡ�S����1���R���o����Wr��/�~P�ц�r�=Xϗ�q5v�iuR���Ӽ�ۼo���R������0p���N��\tb%��l�TQb��e �%	d   ��d�	"��K�G�����X<��䧦�傶�:�'���#
maַ�/����ݩ���\���&H���l�Wˈt�j��R~#��ci�v�be��'��S^��C	�i����7���z�̀;dpSm��b@���,���(	vN}�0�e�F������x�rd�@m4�J$#i�-a��2k��zϑ ��v���*��V%S��[zH��;����*�����f�G��p+�y}�,n�J���o��$h��f'zpA��9���8�ӗ�Ga��F��� ��D�]�D���ٸj�m���ً���ADH�s����^0}�׫���pß��,K�Eg�/���s5w �֮sLR�Y�RA�Jq�0@\O�s��MH��Ɛ�Ӆ��$�1�8�磰�0ZeT�}��%s�wW�ak�5O}B�ay5���c�������2�@��O+g>�,^�à�y��J�X\�2�\�6Ȼ�;��q|t���h�f�Pe�����(�@�[���y.�)(�۹l���
��1���mQvh��ʅ �q*I��H��$�e꿚_��D�)���'�g����\b p�ٵ��3JG��% ����F��V�3&Ł���u.X%«	²i,�=���0�كj��"�����^��ӡȀ�_�tZG������= y���u��O:,^*wt�(�0`��QX�l�1GF�^��E��������=h�j}S��7���G��ή�(�5J��Ȃ�]= =I��M+���+BZ�e\])l��%6vb~-����S}�
g�ժ��[V��x�����3��M�0RJ�y�~ �����R��q��v�l�	aV
̽�_�ANf��B��;���FDh�S�/����d\6�c��꯶V$��pHKm�2����\t}c��u<3�A���|՗F=(���g�B��Ci���j?��N���$�7�;�*^�=���E��x�;�]C�n �߉�ˡ4�����Ԉ`\���R(l3惑4F�����Fsp�̅��&>d���k�B�]�%
�����1��wW�d)���%[F)�}.̹nF*�\z���`m>���Q?�lv~����n<fX�ֱB�ǡ������4:II��D<h���>v��P�Q	0��s[��VQ߁�/jC
��p?��(=N|6n�BO8�-՞C'~L�D�f�+͐j����Ӫ]ͽuKI��?9�N���:�R�I-SJ=K��Z�9/��_��k�`� H�{�l
$��	i�c&�
���'�4�¸{�:�zə��''�3'�GM{z4����$q��κ�����2���y'��r���P:�TG������wt顋�ZT�'0y8о�/����v0BNe7@ӀQ�$����̖1��H#�8���`l �}��N�+�}->1�O�Ed�22�������*��ѡ�RĖ+�@�Bw1�˖1��,V�!���*����D�M�|s��R"�y��4>ӳx�����*��M��䦚��u�ӅA7�e��N7�aSN(_ם    e�âk�H��N�+��������b�{HQ�=?F����a+������ˣ���g;�/�c��Zt��]v�X��r���]���B�ΰ1���j�mu�����su�.,��T�r?��Y0�k�t�� ʀ��`�*ʑg���X�A��>#;:`��gF�'Y��S�:��E������m>-��V�u�n��mg���\�/�C�Y�L*����8��p2���汜�CS��<6ꅘ�/����_Y�O�b[k��a#��X��ϡ]�.'l�t�8�Q�ؗBa��ql�:6���6�����c���lꯌ���V^6��A�+���x���Y�qfp�$��ʏ3X�kZ�ɕ%b�0����#dv
7P�Ńoi�M���&�U��0b��4�:����)�fq�]O���{���]��m�Rj��Z�Nz7�j!} ��]�:���%SƢH�qsi����SE��F�.��m	N8l�IL/�9|ф3�g����_�F}����Ul_���2����s]��Ir=�-�@��g�W�s7 ��[�;�≜���/m�Gm���F;�Ɔ>�{.h>Z"�t-ңDQ��W�'�'�?�dY�R���V5�p�6w�����Ϻ��2Ԁ$#���:[���#4\��)�\�'J/��_����@��'.q�+���(e�����Msal���=��4���]��$46n�1����d�-�P���c�#{r�#n&a_9q�m�5�JFl��m	�i��˻t�-���T5Um������q�����O*����B� im���C�ߎt�:�� ;��.�\��d��j�ˋF�I���&�wzk`����P�нdOI��{(``4�����>@ٶb��{��|�0Oy�3pR!�������,h�c�"��Ql�L""��`�O,l5&7��b��zd{��΃�6�A�L�`=vylv$Sߴ'Ց��L�_C��օ�T�i�Q{���c$nl��C/�	$q�1� ��1&a�%�X5@�D �ByudL������x�.oB9��l���Gq��fY��]����hw,>��m�Ԫۅ�Q��\(ҋ�kr;�pC�w�e��F6��_LA��1�}8<n
�%�!A�l�E �p��DY��x?�^�f�4��Rtk�� #X��ӌ�5�q��	;����K��M��qJB�@P�8[&xJ�q;��J¹��:�Z"	#w�-��Tsï�J�U"�7erH���Z�]]Z���%�6�	CqIxQ���ON2����Y1;�IG�$l����Ol'? D�#��`�1W8�;Lbv���"��U��X��~?Ւ�*٤ɨ8��-��v=����|{{�Y�9m4J�M��J?�cC�A(5�@�37��}�ϥ5�'���V3y{�pXZi��m��g����t���D�_��������iH�]7N��9��- ,��aX#���:�$#w���4������:�_�\#>ۙ�}��X&Q�lI��]W�0]QdE����:�z�R�V�Vqq��w��x��3n�ˌ\2��6*�]�1�PJc�%�!���� k�{��Kژ�ϟ�M�*8��PDIC ���F,&��H@B�p�ÑPH؏����L�D{Лm�� ����Ε�JO@Wse���DV^L�$a/���Ixpt��#3��������`���+��K����/M~��a 0'�PZ��$u-6�K��rD0�Ĩ6��Pk�{�{B�ķ�>�f��@a�XZ�E ��q��d���l�h�M�=��=m�[s���8q	���Tx�u1��$�&�����f[}����Hqt�V�Y�(��u�lh���CǸ8�p�ѻ�7kE1�.�v�R̻0r6<'d"�b?.�3<4-v!��էo]!��Q���_��y�L��r=P�U"�\��n����_�� �4�	���)�Hl�����4�&߇57��.�0F��Z�MĐ�g5U끗X�u�������
	_��W��?9�����o�P��E���"F):ۇS���+(�����60b�կ"�4��Ug������u�̱��_o��Lw�a-�2��+#)ż$$�a,V��+L\�8��/;EM���/��:���w��L��Lf�a���Lw�c����l���(�j)��ἴ���Cٓ�	f�J�Y��`&%x�?BHl��f[�@�oD.}S�>������:"�!��h(�N"z��i�|},W넲3 ��ϥ�_,,IH�N!���YE��0��'Gl����6wrs5���myOe��tqd��F��LFư�ut؆q� �1!1K�(�Cf���܄e�𴢉�9��e�v
�=�5���2���XU�@�� �w�|�תr�~~[f���y�+n��	�/r�I6��gu����%G}��xcaT��j�9L���$�M�!Ǡc��͑/dl���M�r��4�-���6��d1�'��<f�������������ʥ���7�r��<�<���J����k7�����T*��.�]�*�'��/��N�i ���#�oB(���d������r�g�������{5 ÂB���:})H�2F� ��2�7s����\8.R@��b�%A ܀� +[I��F�ck��B��p�G�������φ�cc���4j�P���i�ʥWo�*}^%��~�Y%\ϧ�3��x����<��^,J��=h�G��(�/B��ի��32ɠ�KK|�'���Ј-�"�0qwΘv��S{Ks���ﳞJ4�0��Ȟ��k�*�?�׮��Tc3�B a��%�{!�9D i�XCB�'�g�*��᢯<2��$l� ���� �tD�V;�d��;zMcl�ٌ�w��k�E��l����W}�)g9_�ׂ�����n��;6�K��_�t�Qn�� �rۤ�I���aC
��Xa	 ����̷�v.o� �Q<d���.�$;���ʠ�B�"�V�X�o���"*�Z�mmҪ?['��_���?�:)�e'�f��c�����]�����9F?�rmѫ}E�ąXڑ�֠Um�|��Sg5���4����Q�]J;�a�9?m��6��:�/.�^j�MyK�2h��x����jt��.��_Ph�#'��T4�0$�O���sil���o'ɭw���E.)���t��D�C�����j�`��JNc�����Uw�͖�ꤺ^�ӯ����N;z:��d�������00���2v���2��f�0�`�Q�"4~��p.�C��������ȱH�;1=��底]*@�#�JiSݿ�����%w$W�v6U�(=u����*fG	ƴ<<15i��1A-�o��K�j�@Í�D���Ϟ<,�\����~��K+Ӱ�m��X=�$�	\�n�Җ�q{~�H����\���95w��#xѮ�؝A���������0hl#��ns1�O����_'ĉ
=�u ����&�}��~)(ps��VP��s��lǅ�l�����_�U�t7�P�^*|QQ�Z��z�Mߩ�����0{V%2[���\��|2�^�h�o\4SO^(��ۋ��෶�+�"�\̆���d�/��	�Q
���MO�����O���mD;�qۥ���O+��hG+�Y��3��Ҥ��(�AaTa���&:*#���Q�2w��v_�BK�;LZ��e���0T=7x8	�:¶������)��c��<��l����[�����A���28�^:�9���l�!����@A �����f<�d�i�KX��bM��?Cas-���[�kc.6���p��G?�Qc�+�DM-���|;P�_q��?�J ��A����D�|����Cl�ۍO��f0��C�`F���i�k7�o��;3���i9�Mo��Ƿ�z=y��9����u���)޷����,���܌���2F����6��=���8�����b��Gq>;=ﰸ��
 �1��j1�p�qэ�ۖf���B���f�j�n������R֯#    �Z(�Bq�ׯ�#=�`�՜-x|��ܠ&AL�MH -��L͂�0�
�#�  |o+²L�#g�]Vc~�^�ް�p�d�IPMu]���~2�n6������+9�Iβ���\r��T#�;0�i\��rJ�}7��`C ~o�Ea"ŖP�E�앎��#w�oF*�+{ԏg�˦�n��$��"�N�b�;`�R��דN��'ǷMALꯝI����7����v-Ǳ��4��"�84c 	~��D�m�I:[�Ei��59��~Ed�K?ȏ�g�k�i"5ۅ-_�0��+Ys��FU�*�#���X �TBz���
d�bJq���j)�Q������|J��\�J�U�D��<=j��|Vpj����J@&��So����i@����/;�THiL 5L�xFc'�����%��G�&ðY�B�3����,���p@���*mpY�aky-�&��r����B�{����� �{ �<�}��}9��Y�������ٜ���($CéM��u�DA��iEQ"3��D�ע��.����1LM�ƽ�2�mD�՘�(x&��ĸ^Mr�R�p���ǖcp�)<t?MUO�$��J/o�]�#���bܕ���F	���'��|�>�ZJ\!��{�x �.�q��G�5�H���O�7l�۸�� ��X�-�}�s �{��fsuP�A?6��ܦ9�RDO�<�C�٢.���:ͼ;�^3�����O��|��ǇER��d<^6��D�z��S�hOƕARq�z���(���� ���n�5��KQ�aǁ![C�g���&�ڸ���i��;��9]C��p�8�`4��%� �" jgX���R�2MaЍ��@�'�.�̂Ё���0?]H~��(&8U�!`~nD	�%��i@��h���\�'V��>�ԃ�w%s�4�>���(���I+y�}E��v��U��:t̖i	j���d����;W/�ǄP̭�b����&Fe4�`�Z�k�������9ߨ���+!�B̸䟡N|V�-�8l�]�$�W��Ѐ� 7W�>�tI�.�ܕ���DI�V�������%��Q��w��xb������f� ?��l�[�0V�G���w��A_S�q�,�l�W�6d!t�.�v�Y��������g����m��ۡ�.vp�n����!ΰ�~��6S���K��<Cz�q�{j�U�Y�A�q�Tg<
`���0��|sl(� ��`������@�,ja���A�|��b�<�����	S�񁦮7�%e�Ed�@y��_n�y"�N-�=�K� =Oӭ�^/��p)^���ؒGJ��Fa��ȓFy�}Jr�9�X�^`��qg=��jFGz7�}�ɒ6�o'9�0�ikk.�F��Ȯa,3��}I�5���-W����*�����H"�uӸ�+R�p@=��		dHp�?<D"	3j>����Nڔ0��`v߶
��Bc�2ztt���q�q�CNϠ�2�6���cLۍ����x�6��t�hF���	��<$��,CF� � ��\�}m�o���0gd@?�>Km���T���Ų����$*Fu��5��ę��=�pڙy9D�:Ï)�F-���`� ������E���Q m�� J�ΓFO�����÷�kz����JS7@��#��M+G�����mh��̮���j�)=-�괷}���"��k����!��Fp����u��n�����bJmg�c�>����2LN�H���~�?�%w6���@�5_l���������58l����q�{�v煦����jj�z�s�Ձ�Q���Y�,<|�Kj��x��?�}=��?0>/">�|�Q�lZ�l�]����I���1	[�`�s9A,^�N�Û�\���� \a�k�����-��N�4�8����������ajj�=��T�����m�{�4��
^�P�|Q)�ѹң�Ժ��~��]�'a��񔀴f�;����=�>������jz]�3�]����=X$1��쬾��F�*��Z�}� ����/V��[���,)���l����4�����C�1('���\G�h,~I��1�r���1;���ͧ#a�#�m��Ϡ�Q���*|ҟ|<���2�7�kw��Y7;N>��}-6�Β���l��WڭU���|}��_�l�"��f���!,�:0Ly������!v锞&�B;�_�G� m3�qr_wd�����m�����S1NFo���;�&�5҈��|����T`��n�+o6b@;��H$��&�W᪦�43�jf0b$�������?)ԏ�����4��d�eYC?Us��7�<��#�����W���%��l�E' c"v��P۞�xe<���얍ĖJ[�N���^R[��n|%�������C����⌻�e�ͷ6���A���Ҟ��E��[I	�ξ���Pm��^�d�OOۺv�VӇld!�o�!v���.f��j�џ��Mb����KF��������!u�T���P�����{�ɨY�.wϹ�]~e|62���t��� ����"Dt���u���gw�1l�_|��\����@>	�&���`�q���E�w���V�	�"�M՝Z��Q:�6�WW�SB�L�M{�����j�*�at��8�IB1C�(���"��@�-�N;%(�t�>���TDFm0ចz2O�?�u�׃Z��
�p>�Y8�]Nڇ
ހ�����q�~]�����,[:�x�u?&)k�:_@ap!`F��� !��pP\$6��)����/�Õ;�� �ѻ~�[�����~��f� Q[�U��r��~������Ǜ�i��%o��`�tWdq��C�ݙ:�F�0m��N{^��N0I΁J���tt��B.P�XܰiW=�Adt�%$0�Pp7��
+�Sx���vl��� ���*��ɡ�rB�̆s�A����x��t�U<�tzOlP����$�ƽ�^�i��jR�_���2��e�
N7��֧��#�Łqrl�(�� �*}!��P�� �`����;��VG���YOUh��l�ƃ��V������MO�=����^���j�M�!���?�6�J:X�ΰ ]1,�T�)����9x.�ʾ[���������y����I9�z�7_Q��Ja����=sN�ː��d"��b0��$ �av���E����$b)����׉�ҋ_���"�/��k=ؼO^PS�&E��F�i5�F��_����y�Ϻ��̭ͺ��������i�5t�𕭛���{�Ű�p�3h�6c��#jǂ1*�]�3��7�o4��4kǼ�>����<σ��}nՇ�y��Sl���N���{�yI��s���Q]���g�>�4�*�g�C���-񃗱�pB�uu���u�Ց��e5�Ę�;f�����^��nv�g?F�����(�l����jӂW�w���q7��c�C����߿�������i1���->��p�D��iO�gK��N��� {�R��@��y��Ē�a��-$'�Eюu��UI���D�C�ωjb^~�)HVw�����MTA�+���YF�<��P	HK��od��l/0,��R�-׉��qA����S�!�U�v|<C3�[�� �(V:������q�lǡ��Cra*,���Z�r�R�J����	@��+L��EZ�����l�*���Qk=qA�jE1���Y�&|�pʉT	%\B�J��܍�P&��/�mB�p����L�n:�K8"����m���y︗�该�נ�y[!�=���� r�����d���h��*_�W�[O�yQƈ1a~ ��Bj��\b��B.7�`�kEW	��.4�fp��G��'s�������g�z'�*|�W��,^�𢓩���x�^��'�F���͘�3��Ӳ�òJ;�j�u�.��B;[N��0�*�+**W�*]��k�okbt!`�Br��]�����6�����~)A�A��tb��o�S���[oO�_)����S�9-0���&3�WU{�n��.ϽRV�����<Y-=ώ�!^� Q  %�*�7�q0|��(6đ6��DjC��| �gl�#�(�o"�Ck�$�b�
kثNX��;�,Y%�K�ֻ���>H��
Vo�Q���`���!1(��O�b��Y(C��1o���Hk�l���y��x� ?���#|1��c�fX�c4���vo����w7�Qx�q`�_O��f����ru�G���Y�4r�g�g��k6�v}P��S�uZ��X�|��k�~u������Z�нk��E�é��భ�c|�;�l�����#���f|S�uz��g������x��z0���o�?�*v�NY6�s�Ѧ��3��zw�/.�kS��T���gjO����Yr�N�����^�]V����Rr����*���O7x�����v����?�.7���k� �}A�H�p= d<@>�7�˓*�~����a�F����#�g�>BYڡ���H�A��s!�('/���_�2��ݣ�����RTN��	�l :�me�nU��x.������U�Lh�=d[\]�?P�׮��3�a���n�dX�����xP�ҫ��(N�uU��<póG��(UsS��;
��iD�����h��x��X8F׎g]�p{,�@�U�?Dbщ=��|�3j�%1k��6��-z�NsZ0�,���ɫ����6�����d��~Vl���N�@6�d�=BW0�W��0{����*�u��-��l;�zW�����`�pj�E�b0�j�)ϋ�S�r���wKT.��N�Q��Tf�Q�R)�e7���+��v�M*6�57�&6ofnc�ӆo�}d��WK` �%��]@z�� [E0P,�i�7QhG���1�G�aa<"�p�n?.Xj��V�����u�=3��m�`��G9�e�҅}������A!0���ʽ�ɧ�.�FV�\]g�V"F�)��q��q]^q�G�!6��y�^xd��Y����i�EC��c�ѽ�V����k׹��-m�ߙ���xP�Q�t0�T��f��afQ�zU��-Y�]��E��nI4��~��Y�j��v�j�B#<0n9���r��M��0$��t�?}ݠU.����9�cҒ4�Y�x+r*JrU�7��W���t�#׭��<���;��g§���د��yW��<D�1>w�Q	��Z_
ȅo�:������+9Ca�L8���k����s�t`�����~�)��v�w���`8��oc|ػ4�sH+���C��2v޸�L7�y��ju�����b��vSM�����=��e>��
\�ð��z�L�S����a6A���p�zXA�c�{���F�c=	���=��4[�=9�i�h���z�(o�YR��G�DO&���2����%t��ph�}�9�Ms�m�;M\z���r�6K��R6�-�� @�<t|冇���*v��-�E��j8� �#��/i��E�FL�!��`=��\���#�h#y{A����1)[�����T�͟�j�9�Zr4��̱�>m:�c�T)���a���/�Hf"taL2��8 ���	XHpVo!(�RC�� J�s�j��x��R �r� ���
���)>FI�����9B!����?J8��e7���^��7"��[-0K�����9κ�ꡩ��ј�=<�Kg�F���o��)=�w[��;G���#�.nm�r��]���M£�a0�1���CGPc��ݔ��G�HC��`t�+�zt?v?�#Dr�b�R_)�P������N�
�������v�U��&k���Qȱ���o�D}�7�����}:�C�Ζ5I%��f"��N�(�YY�E߯�|Җ/���[�ttz��X���1��G�Pޥ�}-�Ꮭn>� ���I.>�0'&��-���������Cʘ3p��I��6ۄ�S�+��X���]x��]�X���e�F��$dQ���i��*"/�����p�����"��j=���-�0@�\��'7N%��^75�X���ɯ�S�� 	n�䮎�\��/|����4��Uy��7����zz����_���&���3M��u������	�=X��0�_��6;��Di�a�>F@��)��˧�yʕE),2d�4hʧN�Z�u�*��a좭�Z��R�$r��_���'�du�������Ev�x�i@w]��2A:��ˣ?-�(NT�6��A��Mgt3��e���D�`>-4__��VR34�%鬴K5�87��Ma��Ŵf��
���QG'	�j4	�|^FoA����X���~𘄨�X�m��Ȗ9�kcp����0m�����8���1L�̣:�\�F�<.�>⽷�QX}z���k2���b��|e�\ؐ_sp̾���%E�2.�$px�c$�}n5A�e�+���Ŕ����ձ�찳��F�X��] �u~_�n͖�H݅���h9|�M��Wi8z ��� ��[��t��N����ؼ:_���}Y8�&t�b���r�(2�ze~�nT���d����7��a%5�@�p2�����U��-n�6�
��n��3�m�&��54V?�Mv��ݐ�z_���/�K�V7�j�,v����d��~_�e�����8/'��JW�cN�w��4���RwC�~gT����Ԗ�X�%�$��ۣp;7����/����xl\��N��#��t4Ol��ZI�����ň��]MS"1��+�C>&����R��jY�^�I"*���*�~��ÌXV��a�N��~�/��*ͩU�tͿ-��,t� 4�葐'��ۃ����c�=]�1=|�סc�Vs�y�	 ϥ�Ҳ���d� �b�0�S��ʘb{k��A+^H��X�ȱ�������Q�m�K�(~�N}˟�������d&�4�F98<ߴ �/>A�����!�Ix_�mj��2���H#_�ʒ�F�E��,�(Q��D�:.�%)D���6e����
�-��C�ӂ����(�@���?�R��i�l�,�R�N\b��!Q"�c�<^�?F�3Q�Jמ�F7�}����~aF�6s�X�*[O�>��v��ٌ�=��;�^\�}6�-���%9Ϲd'�[�>�_Z�삷G��J��!��q�D��j���zy�j��B^9�h�(��P���H��jq{��@���f��
��ycRi�G�n-��.R}$A�Ȉ�Y�1�K�<	[͢�2!� n�"���	 ֚�����)�Ґ6�Z�D#���$4x��.�5TXF}�ń&ҋ 9
e8�F����R.E0𱄀`>�N�Ҡ�U�FQ���2�6.e��R��PAv�A�����;��lPx�:��x��Q�J��r<��i���%��(ʣ #���&�t�����*W{�U�bRu�~.&�q�����:}�����]�߭na'�8oO�m���}~�������)��`{=98_5��ZSs~�����pFS_��N��}��N�:��ż���t,GP\LI�l�V�����wz��o(���{k	@��>[H��1-@,��Scw�D��>y��5}7	���O�����b5�p4}���E/�i�����0쪳�������&����9��U�Sv�t�����/�����f�Fo���	�la@2 M���-�"���W�������      �   6  x�5T�nSA|>���?7��\���JH�H����MO���ym����Շ)Nm~E���J3��+�@J3��� �9 y�����F�����<A1?�Y���4�
�0[��,�%;���ݖ��#d��lXv��2�쟾}:���x}���<Y�Ju6Q��S� ��9k��������xԻ��@_P����>?.>�~���~?��,Y��4/Bh���C��Y:��Ư(<�~����\�a}�%�t"%�;Pi�4�or���ųt$i��V�	�!���TV(/K���@���Q#��j-R%�o�,�ʂ�Ke�D)T	c*��`2���/��L�JV
V�RK%I,�t&�&�	����'��RY&]Kp�h�y,a�:x(���Q�Ƃ�������<�_z���I�������eޅu��O�ҩF5VNCM��;�-�N5P�T�P#�-�Z��aY��u�n��-���J�/�g�^���e�{^]���j��VÑ�O�2�cH�v�B&��
�]���m=lۀ��_m�mm��o�ڔD^]��̻�6'��Z��l����<v����� W�D�?��(�     