create table events (
  id bigint primary key generated always as identity,
  name text not null,
  date date not null,
  location text not null,
  description text
);
create table attendees (
  id bigint primary key generated always as identity,
  event_id bigint not null references events (id),
  name text not null,
  email text not null unique,
  phone text
);

create table tickets (
  id bigint primary key generated always as identity,
  event_id bigint not null references events (id),
  attendee_id bigint references attendees (id),
  ticket_type text not null,
  price numeric(10, 2) not null
);

create table sponsors (
  id bigint primary key generated always as identity,
  event_id bigint not null references events (id),
  name text not null,
  contribution numeric(10, 2) not null
);

create table feedback (
  id bigint primary key generated always as identity,
  event_id bigint not null references events (id),
  attendee_id bigint references attendees (id),
  rating int check (
    rating >= 1
    and rating <= 5
  ),
  comments text
);

create table users (
  id bigint primary key generated always as identity,
  username text not null unique,
  password_hash text not null,
  email text not null unique,
  role text not null check (role in ('admin', 'organizer', 'attendee'))
);

create table user_permissions (
  id bigint primary key generated always as identity,
  user_id bigint not null references users (id),
  permission text not null
);

create table employees (
  id bigint primary key generated always as identity,
  name text not null,
  email text not null unique,
  phone text,
  role text not null check (role = 'organizer')
);

alter table events
add column organizer_id bigint references employees (id);

create table employee_stats (
  id bigint primary key generated always as identity,
  employee_id bigint not null references employees (id),
  event_id bigint not null references events (id),
  tasks_completed int default 0,
  feedback_score numeric(3, 2) check (
    feedback_score >= 0
    and feedback_score <= 5
  )
);

alter table events
add column status text not null default 'planned' check (status in ('planned', 'completed', 'canceled'));
