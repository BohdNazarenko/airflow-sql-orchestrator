INSERT INTO shop.store (address, city, opens_at, closes_at, timezone)
VALUES
  ('350 5th Ave',        'New York',   '09:00', '21:00', 'America/New_York'),
  ('6801 Hollywood Blvd','Los Angeles','10:00', '22:00', 'America/Los_Angeles'),
  ('233 S Wacker Dr',    'Chicago',    '09:00', '21:00', 'America/Chicago'),
  ('901 Bagby St',       'Houston',    '09:00', '21:00', 'America/Chicago'),
  ('1100 Lincoln Rd',    'Miami',      '09:00', '21:00', 'America/New_York');

INSERT INTO shop.customer (full_name, email, birth_date, created_at)
VALUES
  ('John Smith',          'john.smith@example.com',          '1990-01-15', now() - interval '20 days'),
  ('Emily Johnson',       'emily.johnson@example.com',       '1992-03-22', now() - interval '19 days'),
  ('Michael Williams',    'michael.williams@example.com',    '1988-07-09', now() - interval '18 days'),
  ('Jessica Brown',       'jessica.brown@example.com',       '1995-11-01', now() - interval '17 days'),
  ('David Jones',         'david.jones@example.com',         '1991-06-18', now() - interval '16 days'),
  ('Sarah Miller',        'sarah.miller@example.com',        '1993-02-10', now() - interval '15 days'),
  ('Christopher Davis',   'christopher.davis@example.com',   '1989-09-05', now() - interval '14 days'),
  ('Ashley Garcia',       'ashley.garcia@example.com',       '1996-12-30', now() - interval '13 days'),
  ('Matthew Rodriguez',   'matthew.rodriguez@example.com',   '1994-08-02', now() - interval '12 days'),
  ('Amanda Martinez',     'amanda.martinez@example.com',     '1997-04-14', now() - interval '11 days'),
  ('Joshua Hernandez',    'joshua.hernandez@example.com',    '1990-10-28', now() - interval '10 days'),
  ('Megan Lopez',         'megan.lopez@example.com',         '1993-05-07', now() - interval '9 days'),
  ('Andrew Gonzalez',     'andrew.gonzalez@example.com',     '1987-03-01', now() - interval '8 days'),
  ('Lauren Wilson',       'lauren.wilson@example.com',       '1998-01-19', now() - interval '7 days'),
  ('Daniel Anderson',     'daniel.anderson@example.com',     '1992-07-23', now() - interval '6 days'),
  ('Brittany Thomas',     'brittany.thomas@example.com',     '1995-09-12', now() - interval '5 days'),
  ('Nicholas Taylor',     'nicholas.taylor@example.com',     '1991-02-27', now() - interval '4 days'),
  ('Rachel Moore',        'rachel.moore@example.com',        '1994-11-16', now() - interval '3 days'),
  ('Ryan Jackson',        'ryan.jackson@example.com',        '1989-06-03', now() - interval '2 days'),
  ('Victoria Martin',     'victoria.martin@example.com',     '1996-10-05', now() - interval '1 day')
;

INSERT INTO shop.sales (store_id, customer_id, sale_ts, total_amount, payment_method)
VALUES
  (1,  1,  '2025-09-01 10:15:00-04', 39.90, 'card'),
  (2,  2,  '2025-09-01 11:05:00-07', 72.50, 'cash'),
  (3,  3,  '2025-09-01 12:40:00-05', 55.00, 'mixed'),
  (4,  4,  '2025-09-01 13:20:00-05', 18.99, 'lidl_plus'),
  (5,  5,  '2025-09-01 14:05:00-04', 91.20, 'card'),

  (1,  6,  '2025-09-02 10:10:00-04', 44.70, 'cash'),
  (2,  7,  '2025-09-02 10:55:00-07', 26.50, 'mixed'),
  (3,  8,  '2025-09-02 11:35:00-05', 63.00, 'card'),
  (4,  9,  '2025-09-02 12:05:00-05', 32.80, 'lidl_plus'),
  (5, 10,  '2025-09-02 12:40:00-04', 47.30, 'cash'),

  (1, 11,  '2025-09-03 10:20:00-04', 79.90, 'card'),
  (2, 12,  '2025-09-03 11:00:00-07', 21.50, 'cash'),
  (3, 13,  '2025-09-03 11:45:00-05', 66.10, 'mixed'),
  (4, 14,  '2025-09-03 12:30:00-05', 28.00, 'lidl_plus'),
  (5, 15,  '2025-09-03 13:10:00-04', 53.40, 'card'),

  (1, 16,  '2025-09-04 10:05:00-04', 35.60, 'cash'),
  (2, 17,  '2025-09-04 10:50:00-07', 84.00, 'mixed'),
  (3, 18,  '2025-09-04 11:35:00-05', 41.70, 'card'),
  (4, 19,  '2025-09-04 12:15:00-05', 27.90, 'lidl_plus'),
  (5, 20,  '2025-09-04 12:55:00-04', 62.20, 'cash');address='1100 Lincoln Rd'     AND c.email='victoria.martin@example.com';