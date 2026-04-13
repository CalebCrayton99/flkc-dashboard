-- ══════════════════════════════════════════════════════════════════════
-- FLKC Dashboard — Supabase Setup
-- Run this ENTIRE script in the Supabase SQL Editor
-- ══════════════════════════════════════════════════════════════════════

-- 1. Create sales table
CREATE TABLE IF NOT EXISTS sales (
  id BIGSERIAL PRIMARY KEY,
  project_number TEXT NOT NULL,
  name TEXT NOT NULL,
  amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  date DATE,
  proj_mat TEXT DEFAULT 'Proj',
  rep TEXT,
  market TEXT,
  rep_project TEXT DEFAULT '',
  playground NUMERIC(12,2) DEFAULT 0,
  k9 NUMERIC(12,2) DEFAULT 0,
  landscape NUMERIC(12,2) DEFAULT 0,
  golf NUMERIC(12,2) DEFAULT 0,
  sports NUMERIC(12,2) DEFAULT 0,
  misc NUMERIC(12,2) DEFAULT 0,
  sqft NUMERIC(10,0) DEFAULT 0,
  note TEXT DEFAULT '',
  year INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create install_pos table
CREATE TABLE IF NOT EXISTS install_pos (
  id BIGSERIAL PRIMARY KEY,
  project TEXT NOT NULL,
  sub TEXT DEFAULT 'RCG',
  amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  sqft NUMERIC(10,0) DEFAULT 0,
  date DATE,
  note TEXT DEFAULT '',
  year INTEGER NOT NULL DEFAULT 2026,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create job_costs table
CREATE TABLE IF NOT EXISTS job_costs (
  id BIGSERIAL PRIMARY KEY,
  project_number TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Material',
  description TEXT NOT NULL,
  qty NUMERIC(12,2) DEFAULT 1,
  unit_cost NUMERIC(12,2) DEFAULT 0,
  hours NUMERIC(8,2) DEFAULT 0,
  rate NUMERIC(8,2) DEFAULT 0,
  cost NUMERIC(12,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3b. Create ar_notes table (contact log for Open AR invoices)
CREATE TABLE IF NOT EXISTS ar_notes (
  id BIGSERIAL PRIMARY KEY,
  invoice_num TEXT NOT NULL,
  note TEXT NOT NULL,
  contacted_by TEXT DEFAULT '',
  contact_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3c. Create ar_uploads table (persists parsed AR Excel data)
CREATE TABLE IF NOT EXISTS ar_uploads (
  id INTEGER PRIMARY KEY DEFAULT 1,
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO ar_uploads (id, data) VALUES (1, null) ON CONFLICT (id) DO NOTHING;

-- 3d. Create wip_uploads table (persists parsed WIP report history)
CREATE TABLE IF NOT EXISTS wip_uploads (
  id INTEGER PRIMARY KEY DEFAULT 1,
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO wip_uploads (id, data) VALUES (1, null) ON CONFLICT (id) DO NOTHING;

-- 4. Enable Row Level Security
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE install_pos ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_costs ENABLE ROW LEVEL SECURITY;
ALTER TABLE ar_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ar_uploads ENABLE ROW LEVEL SECURITY;
ALTER TABLE wip_uploads ENABLE ROW LEVEL SECURITY;

-- 5. Allow anon read/write (app-level password gate handles auth)
CREATE POLICY "anon_all_sales" ON sales FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_install" ON install_pos FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_jobcosts" ON job_costs FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_ar_notes" ON ar_notes FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_ar_uploads" ON ar_uploads FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_wip_uploads" ON wip_uploads FOR ALL TO anon USING (true) WITH CHECK (true);

-- 6. Migrate SEED data into sales
INSERT INTO sales (project_number, name, amount, date, proj_mat, rep, market, rep_project, playground, k9, landscape, golf, sports, misc, sqft, note, year) VALUES
('25001', 'Lowenstein Mound Repair', 9139.93, '2025-01-02', 'Proj', 'Austin', 'KC', 'ABC', 0, 0, 0, 0, 0, 7768.75, 0, '', 2025),
('25002', 'Richmond Dear Elementary', 73614, '2025-01-02', 'Proj', 'Austin', 'KC', 'ABC', 62826.71, 0, 0, 0, 0, 0, 3975, '', 2025),
('25003', 'Ripke Material', 847.98, '2025-01-03', 'Mat', 'House', 'IA', '', 0, 0, 0, 0, 0, 720.76, 0, '', 2025),
('25004', 'The Hudson', 28984, '2025-01-10', 'Proj', 'House', 'KC', '', 0, 0, 20444.34, 0, 0, 0, 1905, '', 2025),
('25005', 'Painted Woods', 42370.05, '2025-01-13', 'Proj', 'Derek', 'IA', 'ABC', 36013.65, 0, 0, 0, 0, 0, 1185, '', 2025),
('25006', 'Ford Manion', 7689.72, '2025-01-15', 'Mat', 'Larry', 'StL', '', 0, 5816.66, 0, 0, 0, 0, 810, '', 2025),
('25007', 'Wentzville ECC BNJ', 107967.4, '2025-01-20', 'Mat', 'Larry', 'StL', '', 74931.44, 0, 0, 0, 0, 0, 8325, '', 2025),
('25008', 'Kearney Elementary Swings', 57910.14, '2025-01-20', 'Proj', 'Austin', 'KC', 'ABC', 49222.4, 0, 0, 0, 0, 0, 3150, '', 2025),
('25009', 'Greenway Elementary NKC', 118466.22, '2025-01-13', 'Proj', 'Austin', 'KC', '', 100951.18, 0, 0, 0, 0, 0, 6660, '', 2025),
('25010', 'Matt Bundrant - KOS', 5197.19, '2025-02-11', 'Mat', 'House', 'KC', '', 0, 0, 0, 4417.5, 0, 0, 375, '', 2025),
('25011', 'Focal Pointe', 1125.5, '2025-02-14', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 955.76, 0, '', 2025),
('25012', 'Des Moines Airport', 5499.73, '2025-02-17', 'Proj', 'Derek', 'IA', '', 0, 3933.56, 0, 0, 0, 0, 75, '', 2025),
('25013', 'U of I Health Sciences Rooftop', 68112, '2025-02-17', 'Proj', 'Derek', 'IA', '', 0, 0, 47034.84, 0, 0, 0, 3660, '', 2025),
('25014', 'Scotts Bluff ESU13', 77657.35, '2025-02-21', 'Proj', 'Austin', 'KC', 'ABC', 67165.06, 0, 0, 0, 0, 0, 3915, '', 2025),
('25015', 'Eudora ELC Phase 2', 110119.83, '2025-02-24', 'Proj', 'Austin', 'KC', 'ABC', 93578.11, 0, 0, 0, 0, 0, 4410, '', 2025),
('25016', 'Trinity Lutheran', 101376.6, '2025-03-03', 'Proj', 'Joey', 'StL', 'ABC', 86167.96, 0, 0, 0, 0, 0, 6660, '', 2025),
('25017', 'Kearney Dogwood Elementary', 39309.5, '2025-03-03', 'Proj', 'Austin', 'KC', 'ABC', 33412.25, 0, 0, 0, 0, 0, 1725, '', 2025),
('25018', 'Kearney Hawthorne Elementary', 106674.36, '2025-03-03', 'Proj', 'Austin', 'KC', 'ABC', 90670.95, 0, 0, 0, 0, 0, 4980, '', 2025),
('25019', 'Kearney Kearney Elementary', 61565.37, '2025-03-03', 'Proj', 'Austin', 'KC', 'ABC', 52329.26, 0, 0, 0, 0, 0, 3210, '', 2025),
('25020', 'Wash U Tab Early Childhood', 52596.96, '2025-03-03', 'Mat', 'Larry', 'StL', '', 43830.8, 0, 0, 0, 0, 0, 8100, '', 2025),
('25021', 'Focal Pointe - install supply', 1404.83, '2025-03-07', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 1192.96, 0, '', 2025),
('25022', 'Kearney Southview Elementary', 29700.04, '2025-03-07', 'Proj', 'Austin', 'KC', 'ABC', 25244.39, 0, 0, 0, 0, 0, 1485, '', 2025),
('25023', 'St. Clair Animal Facility', 74276.32, '2025-03-18', 'Proj', 'Larry', 'StL', '', 0, 54832.88, 0, 0, 0, 0, 4440, '', 2025),
('25024', 'Reflections Apts', 35391, '2025-03-18', 'Proj', 'Austin', 'KC', '', 0, 0, 8037.54, 0, 16177.44, 0, 2370, '', 2025),
('25025', 'Summit Apts', 43269, '2025-03-19', 'Proj', 'Austin', 'KC', '', 0, 10315.32, 0, 0, 9689.02, 0, 1755, '', 2025),
('25026', 'Rothermich Gym Turf', 4045.34, '2025-03-20', 'Proj', 'Joey', 'StL', '', 0, 0, 0, 0, 2721, 0, 100, '', 2025),
('25027', 'Will Andersen Landman', 3591.69, '2025-03-25', 'Mat', 'Joey', 'StL', '', 0, 0, 0, 2626.8, 0, 0, 420, '', 2025),
('25029', 'Jackie Kuhn Backyard', 23807.27, '2025-03-27', 'Mat', 'Austin', 'KC', '', 0, 0, 22875.22, 0, 0, 0, 2000, '', 2025),
('25030', 'Sean Miller Residence', 10562.06, '2025-03-27', 'Mat', 'Larry', 'StL', '', 0, 0, 0, 6858.48, 0, 0, 1260, '', 2025),
('25031', 'Gladstone Woofs', 612.5, '2025-03-31', 'Proj', 'Larry', 'StL', '', 0, 0, 0, 0, 0, 490, 0, '', 2025),
('25032', 'SW 1st St. Bridge', 191073.36, '2025-04-04', 'Proj', 'Jordan', 'IA', '', 127808.96, 0, 0, 0, 0, 0, 3825, '', 2025),
('25033', 'Davidson Elementary', 27403.32, '2025-04-07', 'Proj', 'Austin', 'KC', 'ABC', 23292.24, 0, 0, 0, 0, 0, 1320, '', 2025),
('25034', 'Bell Prairie Elementary', 27405.35, '2025-04-07', 'Proj', 'Austin', 'KC', 'ABC', 23293.95, 0, 0, 0, 0, 0, 375, '', 2025),
('25035', 'Putting Green - Dana', 2931.33, '2025-04-07', 'Mat', 'Larry', 'StL', '', 0, 0, 0, 1988.5, 0, 0, 375, '', 2025),
('25036', 'Wentzville ECC - Playground Consultant', 1426.05, '2025-04-07', 'Proj', 'Larry', 'StL', '', 0, 0, 0, 0, 0, 982.5, 0, '', 2025),
('25037', 'No Leash Needed Ellis', 1125, '2025-04-09', 'Proj', 'Larry', 'StL', '', 0, 0, 0, 0, 0, 900, 0, '', 2025),
('25038', 'APA - Hanley Front Area', 9193.45, '2025-04-09', 'Proj', 'Larry', 'StL', '', 0, 6747.48, 0, 0, 0, 0, 555, '', 2025),
('25039', 'Ripke Material', 2368.48, '2025-04-11', 'Mat', 'House', 'IA', '', 0, 0, 0, 0, 0, 2368.48, 0, '', 2025),
('25040', 'Tyler Moser Backyard - Remnant', 7405.68, '2025-04-11', 'Mat', 'Austin', 'KC', '', 0, 0, 0, 0, 0, 5172.48, 0, '', 2025),
('25041', 'Kindred Supplies', 1411.52, '2025-04-15', 'Mat', 'House', 'KC', '', 0, 0, 0, 0, 0, 1411.52, 0, '', 2025),
('25042', 'Caleb Miller', 7485.74, '2025-04-15', 'Mat', 'Jordan', 'IA', '', 0, 5271.64, 0, 0, 0, 0, 825, '', 2025),
('25043', 'Church of the Resurrection', 17466.96, '2025-04-16', 'Proj', 'Austin', 'KC', 'ABC', 14884.5, 0, 0, 0, 0, 0, 1080, '', 2025),
('25044', 'Jackson Elementary', 1687.5, '2025-04-23', 'Proj', 'House', 'IA', '', 0, 0, 0, 0, 0, 1350, 0, '', 2025),
('25045', 'Jones Advisory Group', 6558.76, '2025-04-25', 'Mat', 'Austin', 'KC', '', 0, 0, 0, 5574.8, 0, 0, 885, '', 2025),
('25046', 'Mission Hills Country Club', 13289.57, '2025-04-30', 'Proj', 'Austin', 'KC', '', 0, 0, 0, 9301.5, 0, 0, 855, '', 2025),
('25047', 'Boonville Animal Shelter', 35108.3, '2025-05-02', 'Proj', 'Austin', 'KC', '', 0, 25077.36, 0, 0, 0, 0, 2460, '', 2025),
('25048', 'Church of the Nativity', 14418.1, '2025-05-06', 'Proj', 'Austin', 'KC', '', 10153.58, 0, 0, 0, 0, 0, 840, '', 2025),
('25049', 'KU Football Stadium', 2108.4, '2025-05-09', 'Mat', 'Austin', 'KC', '', 0, 0, 0, 0, 982, 0, 150, '', 2025),
('25050', 'Clive IA Tracy Stein', 16434.93, '2025-05-13', 'Proj', 'Jordan', 'IA', '', 13695.77, 0, 0, 0, 0, 0, 1065, '', 2025),
('25051', 'Lake Park IA Harris Park Playmound', 5555.86, '2025-05-15', 'Proj', 'Jordan', 'IA', '', 4424.5, 0, 0, 0, 0, 0, 150, '', 2025),
('25052', 'Kyle Kryger Putting Material - KOS', 2466.54, '2025-05-16', 'Mat', 'House', 'KC', '', 0, 0, 0, 2096.5, 0, 0, 330, '', 2025),
('25053', 'Nicki Alexander', 20448.23, '2025-04-16', 'Mat', 'Larry', 'StL', '', 0, 14102.22, 0, 0, 0, 0, 2295, 'sales tax on freight not collected, Illinois', 2025),
('25054', 'Blue Bird Dog Park - BNJ', 35819.4, '2025-04-16', 'Mat', 'Joey', 'StL', '', 0, 29849.5, 0, 0, 0, 0, 5250, '', 2025),
('25055', 'Xtreme Green-Playmound', 11864.47, '2025-04-22', 'Mat', 'Larry', 'StL', '', 1717.2, 0, 0, 0, 0, 4537, 360, '', 2025),
('25056', 'Focal Pointe Bear Boards', 1028.93, '2025-04-25', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 609.04, 0, '', 2025),
('25057', 'Mitchell Park - ABcreative', 76426.02, '2025-04-30', 'Proj', 'Larry', 'StL', 'ABC', 64899.81, 0, 0, 0, 0, 0, 4275, '', 2025),
('25058', 'Webster Groves Aquatic Park', 80043.72, '2025-05-01', 'Mat', 'Joey', 'StL', '', 0, 66703.1, 0, 0, 0, 0, 12330, '', 2025),
('25059', 'Jinnie Tkach - Putting Area', 3609.07, '2025-05-09', 'Mat', 'Larry', 'StL', '', 0, 0, 0, 2343.55, 0, 0, 300, '', 2025),
('25060', 'Walter Ambrose Family', 58005.84, '2025-05-12', 'Mat', 'Larry', 'StL', '', 48338.2, 0, 0, 0, 0, 0, 6030, '', 2025),
('25061', 'Pattonville Schools - BNJ Material', 35745.72, '2025-05-14', 'Mat', 'Larry', 'StL', '', 23665, 0, 0, 0, 0, 0, 2160, '', 2025),
('25062', 'Sean O''Sullivan - Material - KOS', 20500.14, '2025-05-16', 'Mat', 'House', 'KC', '', 0, 0, 0, 17083.45, 0, 0, 2385, '', 2025),
('25063', 'Ranken Jordan', 6586.67, '2025-05-21', 'Proj', 'Larry', 'StL', '', 4480.95, 0, 0, 0, 0, 0, 660, '', 2025),
('25064', 'Doug Koons', 15446.64, '2025-05-19', 'Proj', 'Jordan', 'IA', '', 0, 11851.61, 0, 0, 0, 0, 1170, '', 2025),
('25065', 'Focal Pointe Bear Boards', 1668.39, '2025-05-22', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 1400.12, 0, '', 2025),
('25066', 'Sheldon IA Adult Fitness', 14504.89, '2025-05-23', 'Proj', 'Jordan', 'IA', 'ABC', 12328.84, 0, 0, 0, 0, 0, 990, '', 2025),
('25067', 'Charlena Peppes Landscape Material - KOS', 3343.68, '2025-05-23', 'Mat', 'House', 'KC', '', 0, 0, 2786.4, 0, 0, 0, 480, '', 2025),
('25069', 'Focal Pointe - Seam Tape', 1125.5, '2025-05-28', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 955.76, 0, '', 2025),
('25070', 'Todd Around Pool Material Only', 480, '2025-05-29', 'Mat', 'Austin', 'KC', '', 0, 0, 0, 0, 0, 240, 0, '', 2025),
('25071', 'Kindred Tape', 4281.69, '2025-05-29', 'Mat', 'House', 'KC', '', 0, 0, 0, 0, 0, 4281.69, 0, '', 2025),
('25072', 'Oelwein IA Depot Park - Repair', 1830, '2025-06-05', 'Proj', 'House', 'IA', '', 0, 0, 0, 0, 0, 1500, 0, '', 2025),
('25073', 'St. Thomas Moore -FLSCK Reciprocity', 1923.75, '2025-06-13', 'Proj', 'House', 'KC', '', 1923.75, 0, 0, 0, 0, 0, 2565, '', 2025),
('25074', 'Kiddi Kollege - FLSCK Reciprocity', 810, '2025-06-13', 'Proj', 'House', 'KC', '', 810, 0, 0, 0, 0, 0, 1080, '', 2025),
('25075', 'High Grove Elementary - FLSCK Reciprocity', 1260, '2025-06-13', 'Proj', 'House', 'KC', '', 1260, 0, 0, 0, 0, 0, 1680, '', 2025),
('25076', 'Jeremy Cohorst Materials Only - KOS', 5516.76, '2025-06-13', 'Mat', 'House', 'KC', '', 0, 0, 0, 4597.3, 0, 0, 690, '', 2025),
('25077', 'Dogtopia-Lake St Louis', 25176.83, '2025-06-13', 'Proj', 'House', 'StL', '', 0, 15021.62, 0, 0, 0, 0, 1530, '', 2025),
('25078', 'Cooper Residence', 2681.12, '2025-06-20', 'Mat', 'House', 'KC', '', 0, 2331.12, 0, 0, 0, 0, 600, '', 2025),
('25079', 'Kindred - Glue Supplies', 518.47, '2025-07-01', 'Mat', 'House', 'KC', '', 0, 0, 0, 0, 0, 414.77, 0, '', 2025),
('25080', 'Fat Cat''s Dog Boarding', 24241.14, '2025-07-01', 'Proj', 'Austin', 'KC', '', 0, 16662.8, 0, 0, 0, 0, 1380, '', 2025),
('25081', 'Oxford, Ia CCA Elementary', 84536.13, '2025-07-01', 'Proj', 'Jordan', 'IA', '', 72760.26, 0, 0, 0, 0, 0, 5355, '', 2025),
('25082', 'Small Sliders - Ellisville', 8897, '2025-07-08', 'Mat', 'House', 'StL', '', 0, 5563.28, 0, 0, 0, 0, 690, '', 2025),
('25083', 'Behavioral Health Allies Playground', 66493.14, '2025-07-10', 'Proj', 'Austin', 'KC', 'ABC', 55410.95, 0, 0, 0, 0, 0, 3600, '', 2025),
('25084', 'Lionsgate HOA', 54490.57, '2025-07-11', 'Proj', 'Austin', 'KC', 'ABC', 46315.81, 0, 0, 0, 0, 0, 3555, '', 2025),
('25085', 'Caroline French Backyard', 12675.02, '2025-07-16', 'Proj', 'Austin', 'KC', '', 0, 0, 8825.12, 0, 0, 0, 690, '', 2025),
('25086', 'Kindred - Seam Tape', 4460.68, '2025-07-24', 'Mat', 'House', 'KC', '', 0, 0, 0, 0, 0, 3568.54, 0, '', 2025),
('25087', 'Urbandale IA Cresent Building Plaza', 30074.73, '2025-07-24', 'Proj', 'Derek', 'IA', '', 0, 0, 23065.85, 0, 0, 0, 2281, '', 2025),
('25088', 'BNJ-New Reach ECC Facility', 1970.34, '2025-07-25', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 1279.44, 0, '', 2025),
('25089', 'Pleasant Hill Animal Shelter', 25949.42, '2025-07-30', 'Proj', 'Austin', 'KC', '', 0, 18274.24, 0, 0, 0, 0, 1320, '', 2025),
('25090', 'Aplix Seam Tape - BNJ', 3021.6, '2025-08-01', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 2417.28, 0, '', 2025),
('25091', 'Aplix Tape - Focal Pointe', 2477.28, '2025-08-04', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 2064.4, 0, '', 2025),
('25092', 'Austin Redd', 3004.44, '2025-08-05', 'Mat', 'Joey', 'StL', '', 0, 0, 0, 2021.25, 0, 0, 375, '', 2025),
('25093', 'Tim Rypma', 24344.38, '2025-08-07', 'Proj', 'Derek', 'IA', '', 0, 9342, 0, 0, 0, 0, 1800, '', 2025),
('25095', 'Little Leaps of Faith Daycare', 13534.6, '2025-08-07', 'Proj', 'Jordan', 'IA', '', 4006, 0, 0, 0, 0, 0, 840, '', 2025),
('25096', 'Focal Pointe - River City Material', 4231.06, '2025-08-13', 'Mat', 'House', 'StL', '', 0, 0, 0, 0, 0, 3525.88, 0, '', 2025),
('25097', 'Crumb Rubber Jackie Kuhn', 144, '2025-08-19', 'Mat', 'Austin', 'KC', '', 0, 0, 0, 0, 0, 144, 0, '', 2025),
('25098', 'K9Grass area by Shed', 420, '2025-08-19', 'Mat', 'Austin', 'KC', '', 0, 0, 0, 0, 0, 420, 0, '', 2025),
('25099', 'S Des Moines LA Vet Ctr', 30941.5, '2025-08-25', 'Proj', 'Jordan', 'IA', '', 0, 23630.75, 0, 0, 0, 0, 1815, '', 2025),
('25100', 'Elevate Landscaping', 3368.77, '2025-08-27', 'Mat', 'Larry', 'StL', '', 0, 0, 0, 2588.25, 0, 0, 405, '', 2025),
('25101', 'Gary Julius - K9 Area Material', 2099.72, '2025-09-04', 'Mat', 'Larry', 'StL', '', 0, 1106.7, 0, 0, 0, 0, 210, '', 2025),
('25102', 'Sky On Main New Dog Park', 22718.99, '2025-09-05', 'Proj', 'Austin', 'KC', '', 0, 15929.18, 0, 0, 0, 0, 1200, '', 2025),
('25103', 'Jenkins Residence', 9899.19, '2025-09-11', 'Proj', 'Larry', 'StL', '', 0, 0, 6895.81, 0, 0, 0, 645, '', 2025),
('25104', 'Ashawa Park GLSCK Reciprocity', 798.75, '2025-09-12', 'Mat', 'House', 'KC', '', 798.75, 0, 0, 0, 0, 0, 1065, '', 2025),
('25105', 'Bonan Residence', 7308.84, '2025-09-18', 'Mat', 'Larry', 'StL', '', 0, 4999.2, 0, 0, 0, 0, 660, '', 2025),
('25106', 'Kyle Thiessen Residence', 26750.55, '2025-09-19', 'Proj', 'Derek', 'IA', '', 0, 0, 0, 22144.63, 0, 0, 2565, '', 2025),
('25107', 'Ascent Apartments', 62097.56, '2025-09-19', 'Proj', 'Austin', 'KC', '', 0, 42647.04, 0, 0, 0, 0, 3030, '', 2025),
('25109', 'River Forest Park', 13423.37, '2025-10-03', 'Mat', 'Austin', 'KC', '', 10420.16, 0, 0, 0, 0, 0, 1080, '', 2025),
('25110', 'Family Pet Veterinary Center', 6031.79, '2025-09-29', 'Proj', 'Derek', 'IA', '', 0, 4266.91, 0, 0, 0, 0, 255, '', 2025),
('25111', 'Bark Park Repair', 1800, '2025-10-01', 'Proj', 'Jordan', 'IA', '', 0, 0, 0, 0, 0, 1500, 0, '', 2025),
('25112', 'Small Sliders - St Peters', 11423, '2025-10-06', 'Proj', 'Joey', 'StL', '', 0, 8037.9, 0, 0, 0, 0, 705, '', 2025),
('25113', 'Forest City Elementary Repair', 6172.19, '2025-10-06', 'Proj', 'Jordan', 'IA', 'ABC', 5153.78, 0, 0, 0, 0, 0, 0, '', 2025),
('25114', 'Des Moines, IA Grandview Child Dev', 93095.51, '2025-10-08', 'Proj', 'Jordan', 'IA', 'ABC', 79129.21, 0, 0, 0, 0, 0, 6135, '', 2025),
('25115', 'Petsuites, Shawnee', 1417.14, '2025-10-09', 'Proj', 'Austin', 'KC', '', 0, 0, 0, 0, 0, 992, 0, '', 2025),
('25116', 'Clayton Dowd Residence', 15912.4, '2025-10-14', 'Proj', 'Joey', 'StL', '', 0, 11925.35, 0, 0, 0, 0, 1065, '', 2025),
('25117', 'Ripke- Supplies', 1388.35, '2025-10-23', 'Mat', 'House', 'IA', '', 0, 0, 0, 0, 0, 1156.96, 0, '', 2025),
('25118', 'Fryar Residence', 14283.86, '2025-10-24', 'Proj', 'Jordan', 'IA', '', 10785.34, 0, 0, 0, 0, 0, 870, '', 2025),
('25119', 'O''Fallon Carshield PG Materials', 30394.75, '2025-10-24', 'Mat', 'Joey', 'StL', '', 20698.43, 0, 0, 0, 0, 0, 2715, '', 2025),
('25120', 'Papillion Park Renovation', 181053.5, '2025-10-27', 'Proj', 'Jordan', 'IA', '', 0, 137585.6, 0, 0, 0, 0, 15345, '', 2025),
('25121', 'Ripke - Supplies - Grandview', 1148.35, '2025-10-29', 'Mat', 'House', 'IA', '', 0, 0, 0, 0, 0, 956.96, 0, '', 2025),
('25122', 'Ripke Supplies for Behavioral Health', 543.46, '2025-10-29', 'Mat', 'House', 'IA', '', 0, 0, 0, 0, 0, 452.88, 0, '', 2025),
('25123', 'Mahmud Residence', 9705.77, '2025-11-03', 'Proj', 'Larry', 'StL', '', 0, 0, 0, 6688.63, 0, 0, 570, '', 2025),
('25124', 'Penny Hendel Residence', 4696.74, '2025-11-03', 'Mat', 'Larry', 'StL', '', 0, 3131.16, 0, 0, 0, 0, 420, '', 2025),
('25126', 'Spirit Lake Phase 2', 56746.92, '2025-11-21', 'Proj', 'Jordan', 'IA', 'ABC', 47900.91, 0, 0, 0, 0, 0, 5355, '', 2025),
('25127', 'Wilkinson Residence', 28174.11, '2025-11-21', 'Proj', 'Larry', 'StL', '', 0, 21695.19, 0, 0, 0, 0, 1920, '', 2025),
('25128', 'Blue Bird Dog Park - BNJ', 61267.53, '2025-11-25', 'Mat', 'Larry', 'StL', '', 0, 45950.65, 0, 0, 0, 0, 7995, '', 2025),
('25129', 'Des Moines, IA Dog Park Barn Renovation', 155367.44, '2025-11-25', 'Proj', 'Jordan', 'IA', '', 0, 118537.5, 0, 0, 0, 0, 10995, '', 2025),
('25130', 'Hyperion Country Club', 31300.66, '2025-12-01', 'Mat', 'Derek', 'IA', '', 23536.99, 0, 0, 0, 0, 0, 3915, '', 2025),
('25131', 'Cottonwood Pet Resort', 82192.5, '2025-12-03', 'Proj', 'Jordan', 'IA', '', 0, 60505.93, 0, 0, 0, 0, 6030, '', 2025),
('25132', 'NKC ECC Repairs and New Areas', 3938.98, '2025-12-09', 'Proj', 'Austin', 'KC', 'ABC', 3363.05, 0, 0, 0, 0, 0, 195, '', 2025),
('25133', 'Ottumwa, IA Riverfront Park', 53854.46, '2025-12-11', 'Proj', 'Jordan', 'IA', 'ABC', 45047.43, 0, 0, 0, 0, 0, 225, '', 2025),
('25135', 'Gilbert Elementary 5-12', 120727.28, '2025-12-23', 'Proj', 'Jordan', 'IA', 'ABC', 100807.67, 0, 0, 0, 0, 0, 8250, 'Will be ordered in 2026', 2025),
('25136', 'Gilbert Elementary 2-5 Area', 41925.27, '2025-12-23', 'Proj', 'Jordan', 'IA', 'ABC', 40604.64, 0, 0, 0, 0, 0, 3060, '', 2025),
('26001', 'Boys and Girls Club Phase 2', 68241.63, '2026-01-06', 'Proj', 'House', 'KC', 'AB', 68241.63, 0, 0, 0, 0, 0, 5010, 'Was not able to get to AB in time', 2026),
('26002', 'Schroeder Park Renovation', 40634, '2026-01-15', 'Proj', 'House', 'STL', '', 40634, 0, 0, 0, 0, 0, 2475, '', 2026),
('25134', 'Thomson Additional Play Area', 57253.31, '2026-01-15', 'Proj', 'House', 'KC', 'AB', 57253.31, 0, 0, 0, 0, 0, 2640, 'Ordered in 2026', 2026),
('26003', 'Mission Vet Emergency', 23560, '2026-01-15', 'Proj', 'Austin', 'KC', '', 0, 23560, 0, 0, 0, 0, 1260, '', 2026),
('26004', 'Bailey Backyard', 37489.12, '2026-01-16', 'Proj', 'David', 'KC', '', 0, 37489.12, 0, 0, 0, 0, 2850, '', 2026),
('26005', 'Gilbert Elementary', 122758.86, '2026-01-27', 'Proj', 'Jordan', 'DSM', 'AB', 122758.86, 0, 0, 0, 0, 0, 8250, '', 2026),
('26006', 'Gilbert ECC', 44114.98, '2026-01-27', 'Proj', 'Jordan', 'DSM', 'AB', 44114.98, 0, 0, 0, 0, 0, 3060, '', 2026),
('26007', 'Cico Park Material Only', 53368.84, '2026-02-11', 'Mat', 'House', 'KC', 'AB', 53368.84, 0, 0, 0, 0, 0, 4650, '', 2026),
('26008', 'Evren Apartments', 15916.07, '2026-02-05', 'Proj', 'Austin', 'KC', '', 0, 0, 0, 15916.07, 0, 0, 500, '', 2026),
('26009', 'Rainbow of the Heartland', 12830.91, '2026-02-12', 'Mat', 'Derek', 'DSM', '', 0, 0, 0, 0, 0, 12830.91, 0, 'Mounds', 2026),
('26010', 'Grimes IA DSM Christian ECC', 103672, '2026-02-12', 'Proj', 'Jordan', 'DSM', 'AB', 103672, 0, 0, 0, 0, 0, 5700, '', 2026),
('26011', 'Mary Castro Mound', 7035, '2026-02-16', 'Mat', 'David', 'KC', '', 0, 0, 0, 0, 0, 7035, 0, 'Mounds', 2026),
('Pending', 'Waukee Play Area', 104962.34, '2026-02-19', 'Proj', 'Jordan', 'DSM', 'AB', 63825.43, 0, 0, 0, 0, 41136.91, 2277, 'Sold pending job #', 2026),
('Pending2', 'Waukee Landscape Area', 122739.61, '2026-02-19', 'Proj', 'Jordan', 'DSM', 'AB', 0, 0, 122739.61, 0, 0, 0, 8085, '', 2026),
('26012', 'O''Fallon Carshield Field PG Install Mat', 1121.7, '2026-02-26', 'Mat', 'House', 'STL', '', 0, 0, 0, 0, 0, 1121.7, 0, 'Extra mat for install', 2026),
('26013', 'Twin Oaks Golf Complex', 21845.17, '2026-03-04', 'Proj', 'David', 'KC', '', 0, 0, 0, 21845.17, 0, 0, 1602, '', 2026),
('26014', 'Orelt Residence', 24761.37, '2026-03-05', 'Proj', 'House', 'STL', '', 0, 24761.37, 0, 0, 0, 0, 1440, '', 2026),
('26015', 'Jackie Kuhn Backyard Mat Only', 15128.34, '2026-03-27', 'Mat', 'House', 'KC', '', 0, 0, 15128.34, 0, 0, 0, 1260, '', 2026),
('26016', 'Libby Worley Backyard', 10398.62, '2026-03-24', 'Proj', 'David', 'KC', '', 0, 10398.62, 0, 0, 0, 0, 690, '', 2026),
('26017', 'Cottonwood Pet Resort Shade', 15956.57, '2026-03-27', 'Proj', 'Jordan', 'DSM', '', 0, 0, 0, 0, 0, 15956.57, 0, 'Shade', 2026),
('26018', 'Gretna YMCA Mat Only', 776.02, '2026-03-26', 'Mat', 'Jordan', 'DSM', '', 776.02, 0, 0, 0, 0, 0, 0, 'Pad Mat Only', 2026),
('26019', 'River Of Refuge', 35755, '2026-03-31', 'Mat', 'House', 'KC', 'AB', 28977.55, 0, 0, 0, 0, 6777.45, 1890, '', 2026),
('26020', 'Miller Park', 27372.44, '2026-04-02', 'Proj', 'Jordan', 'DSM', '', 27372.44, 0, 0, 0, 0, 0, 1680, 'Mounds', 2026);
