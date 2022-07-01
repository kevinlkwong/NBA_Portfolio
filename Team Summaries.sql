-- Creating table to import data
create table "NBA".teamstats(
season char(50),
lg char(50),
team char(50),
abbreviation char(10),
playoffs varchar(10),
age varchar(50),
w decimal(10,5),
l decimal(10,5),
pw varchar(50),
pl varchar(50),
mov decimal(10,5),
sos varchar(50),
srs varchar(50),
o_rtg decimal(10,5),
d_rtg decimal(10,5),
n_rtg decimal(10,5),
pace decimal(10,5),
f_tr decimal(10,5),
x3p_ar decimal(10,5),
ts_percent decimal(10,5),
e_fg_percent decimal(10,5),
tov_percent decimal(10,5),
orb_percent decimal(10,5),
ft_fga decimal(10,5),
opp_e_fg_percent decimal(10,5),
opp_tov_percent decimal(10,5),
opp_drb_percent decimal(10,5),
opp_ft_fga decimal(10,5),
arena varchar(50),
attend varchar(50),
attend_g varchar(50));

-- DATA CLEANING --

-- Deleting unnecessary rows #1
delete from "NBA".teamstats
where season < '2000'

-- Deleting unnecessary rows #2
delete from "NBA".teamstats 
where team = 'League Average'

-- Deleting unncessary columns 
alter table "NBA".teamstats
drop x3p_ar,
drop pw,
drop pl,
drop sos,
drop srs,
drop arena,
drop attend,
drop attend_g,
drop age,
drop lg;

-- Viewing all remaining columns
select * from "NBA".teamstats t

-- Identifying all teams with incorrect abbreviations
select * from "NBA".teamstats t 
where abbreviation = 'NA'

-- Updating NBA team names
update "NBA".teamstats 
set team =
	case team 
	when 'Vancouver Grizzlies' then 'Memphis Grizzlies'
	when 'Seattle SuperSonics' then 'Oklahoma City Thunder'
	when 'New Jersey Nets' then 'Brooklyn Nets'
	when 'New Orleans Hornets' then 'New Orleans Pelicans'
	when 'New Orleans/Oklahoma City Hornets' then 'New Orleans Pelicans'
	when 'Charlotte Bobcats' then 'Charlotte Hornets'
	end
where 
	team = 'Vancouver Grizzlies' or 
	team = 'Seattle SuperSonics' or
	team = 'New Jersey Nets' or
	team = 'New Orleans Hornets' or 
	team = 'New Orleans/Oklahoma City Hornets' or
	team = 'Charlotte Bobcats';
	
-- Updating NBA abbreviations 
update "NBA".teamstats
set abbreviation =
	case team 
	when 'Utah Jazz' then 'UTA'
	when 'Boston Celtics' then 'BOS'
	when 'Memphis Grizzlies' then 'MEM'
	when 'Washington Wizards' then 'WAS'
	when 'Los Angeles Clippers' then 'LAC'
	when 'Phoenix Suns' then 'PHO'
	when 'Milwaukee Bucks' then 'MIL'
	when 'Philadelphia 76ers' then 'PHI'
	when 'Denver Nuggets' then 'DEN'
	when 'Brooklyn Nets' then 'BRK'
	when 'Los Angeles Lakers' then 'LAL'
	when 'Dallas Mavericks' then 'DAL'
	when 'Atlanta Hawks' then 'ATL'
	when 'New York Knicks' then 'NYK'
	when 'Portland Trail Blazers' then 'POR'
	when 'Miami Heat' then 'MIA'
	when 'Chicago Bulls' then 'CHI'
	when 'Charlotte Hornets' then 'CHO'
	when 'Cleveland Cavaliers' then 'CLE'
	when 'Detroit Pistons' then 'DET'
	when 'Golden State Warriors' then 'GSW'
	when 'Houston Rockets' then 'HOU'
	when 'Indiana Pacers' then 'IND'
	when 'Minnesota Timberwolves' then 'MIN'
	when 'New Orleans Pelicans' then 'NOP'
	when 'Oklahoma City Thunder' then 'OKC'
	when 'Orlando Magic' then 'ORL'
	when 'Sacramento Kings' then 'SAC'
	when 'San Antonio Spurs' then 'SAS'
	when 'Toronto Raptors' then 'TOR'
	END
where season is not null;
	
-- Updating playoff teams for 2021 season (Method #1.1)
update "NBA".teamstats 
set playoffs =
case abbreviation 
when 'BOS' then 'TRUE'
when 'WAS' then 'TRUE'
when 'MEM' then 'TRUE'
else 'FALSE'
end 
where season = '2021';

-- Updating playoff teams for 2021 season (Method #1.2)
update "NBA".teamstats 
set playoffs = 'TRUE'
where season = '2021' and w >= '40'

-- Updating playoff teams for 2022 season (Method #2)
update "NBA".teamstats 
set playoffs =
case
	when w >= '46' then 'TRUE'
	when abbreviation = 'NOP' then 'TRUE'
	when abbreviation = 'BRK' then 'TRUE'
	when abbreviation = 'ATL' then 'TRUE'
	else 'FALSE'
end
where season = '2022';

-- Checking to see whether all playoff teams were captured
with t1 as (select * from "NBA".teamstats
where playoffs = 'TRUE'
order by season desc)
select season, count(team)
from t1
group by season
order by season asc;

-- Adding two new columns (Championship and Conference)
alter table "NBA".teamstats 
add championship varchar(25) null,
add	conference varchar(25) null;

-- Assigning values to Championship column
update "NBA".teamstats
set championship =
case
	when abbreviation = 'LAL' and season = '2000' then 'TRUE'
	when abbreviation = 'LAL' and season = '2001' then 'TRUE'
	when abbreviation = 'LAL' and season = '2002' then 'TRUE'
	when abbreviation = 'SAS' and season = '2003' then 'TRUE'
	when abbreviation = 'DET' and season = '2004' then 'TRUE'
	when abbreviation = 'SAS' and season = '2005' then 'TRUE'
	when abbreviation = 'MIA' and season = '2006' then 'TRUE'
	when abbreviation = 'SAS' and season = '2007' then 'TRUE'
	when abbreviation = 'BOS' and season = '2008' then 'TRUE'
	when abbreviation = 'LAL' and season = '2009' then 'TRUE'
	when abbreviation = 'LAL' and season = '2010' then 'TRUE'
	when abbreviation = 'DAL' and season = '2011' then 'TRUE'
	when abbreviation = 'MIA' and season = '2012' then 'TRUE'
	when abbreviation = 'MIA' and season = '2013' then 'TRUE'
	when abbreviation = 'SAS' and season = '2014' then 'TRUE'
	when abbreviation = 'GSW' and season = '2015' then 'TRUE'
	when abbreviation = 'GSW' and season = '2016' then 'TRUE'
	when abbreviation = 'CLE' and season = '2017' then 'TRUE'
	when abbreviation = 'GSW' and season = '2018' then 'TRUE'
	when abbreviation = 'TOR' and season = '2019' then 'TRUE'
	when abbreviation = 'LAL' and season = '2020' then 'TRUE'
	when abbreviation = 'MIL' and season = '2021' then 'TRUE'
	when abbreviation = 'GSW' and season = '2022' then 'TRUE'
	else 'FALSE'
	end
	where team is not null; 

-- Assigning values to Conference column
update "NBA".teamstats 
set conference =
case
	when abbreviation = 'CLE' then 'EAST'
	when abbreviation = 'TOR' then 'EAST'
	when abbreviation = 'WAS' then 'EAST'
	when abbreviation = 'ATL' then 'EAST'
	when abbreviation = 'BOS' then 'EAST'
	when abbreviation = 'CHI' then 'EAST'
	when abbreviation = 'DET' then 'EAST'
	when abbreviation = 'IND' then 'EAST'
	when abbreviation = 'MIA' then 'EAST'
	when abbreviation = 'MIL' then 'EAST'
	when abbreviation = 'NJN' then 'EAST'
	when abbreviation = 'BRK' then 'EAST'
	when abbreviation = 'NYK' then 'EAST'
	when abbreviation = 'ORL' then 'EAST'
	when abbreviation = 'PHI' then 'EAST'
	when abbreviation = 'CHA' then 'EAST'
	when abbreviation = 'CHH' then 'EAST'
	when abbreviation = 'CHO' then 'EAST'
else 'WEST'
end
where abbreviation is not null;

-- Verifying Conference column
select distinct(team), conference
from "NBA".teamstats
order by conference desc;

-- QUERIES -- 

-- NBA Champion by Season
select 
	season, 
	team, 
	conference as champion
from "NBA".teamstats t
where championship = 'TRUE'
order by season asc

-- NBA Champsions by Conference
select
 conference,
 count(championship)
from "NBA".teamstats
where championship = 'TRUE'
group by conference;

-- Pace by Season
select 
	season,
	round(avg(pace),2) as pace
from "NBA".teamstats t 
group by season
order by season asc;

-- True Shooting by Season
select
	season,
	round(avg(ts_percent),2) as ts_percent
from "NBA".teamstats
group by season
order by season asc;

-- Ranking teams by Pace per Season
select 
	season,
	conference,
	team,
	w,
	l,
	round((w/(w+l)),2) as winning_percentage,
	round(pace,2) as pace,
	rank() over (partition by season order by pace desc) as pace_rank
from "NBA".teamstats
group by conference, season, team, w, l, pace 
order by season, conference, pace asc;

-- Top 10 teams by True Shooting % per season
with t1 as (select 
	season,
	conference,
	team, 
	w as wins, 
	l as loss,
	round((w/(w+l)),2) as w_percentage,
	round(e_fg_percent,2) as e_fg_percentage,
	rank() over (partition by season order by e_fg_percent desc) as e_fg_percent_rank
from "NBA".teamstats
group by conference, season, team, w, l, e_fg_percent 
order by season, conference asc, wins desc)
select
season,
team,
conference,
e_fg_percent_rank
from t1
where e_fg_percent_rank <= 10
group by season, e_fg_percent_rank, conference, team
order by season asc;

-- Teams ranked by True Shooting %
select 
	season,
	conference,
	team, 
	w as wins, 
	l as loss,
	round((w/(w+l)),2) as w_percentage,
	round(e_fg_percent,2) as e_fg_percentage,
	rank() over (partition by season order by e_fg_percent desc) as e_fg_percent_rank
from "NBA".teamstats
group by conference, season, team, w, l, e_fg_percent 
order by season, conference asc, wins desc

-- Average Win/Loss by Conference
select 
	conference, 
	round(avg(w),0) as 
	average_wins,
	round(avg(l),0) as average_loss,
	cast(round(avg(w),2)/(avg(w)+avg(l))*100 as decimal(10,2)) as winning_percentage
from "NBA".teamstats t
group by conference

select * from "NBA".teamstats t 














