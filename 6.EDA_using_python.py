import pandas as pd 
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv(r"C:\Users\LENOVO\OneDrive\Desktop\360IN_Projet\Dataset\ivf_equipment_utilization_2yrs.csv")

df.shape
df.info()
df.head(10)
df.tail(10)
df.describe(include = 'all')
df.dtypes
df.isnull().sum()

df.date = pd.to_datetime(df['date'], format = 'dd-mm-yyyy')


# first moment of business decision 
df.max_capacity_hrs.mean()
df.max_capacity_hrs.median()
df.max_capacity_hrs.mode()


df.utilization_hrs.mean()
df.utilization_hrs.median()
df.utilization_hrs.mode()


df.utilization_pct.mean()
df.utilization_pct.median()
df.utilization_pct.mode()


df.idle_hrs.mean()
df.idle_hrs.median()
df.idle_hrs.mode()


df.technical_downtime_hrs.mean()
df.technical_downtime_hrs.median()
df.technical_downtime_hrs.mode()


df.planned_maintenance_hrs.mean()
df.planned_maintenance_hrs.median()
df.planned_maintenance_hrs.mode()


df.workflow_delay_events.mean()
df.workflow_delay_events.median()
df.workflow_delay_events.mode()


df.avg_delay_minutes.mean()
df.avg_delay_minutes.median()
df.avg_delay_minutes.mode()


df.total_cases_day_lab.mean()
df.total_cases_day_lab.median()
df.total_cases_day_lab.mode()


#second moment of business decision
df.max_capacity_hrs.var()
df.max_capacity_hrs.std()
range = max(df.max_capacity_hrs) - min(df.max_capacity_hrs)
range

df.utilization_hrs.var()
df.utilization_hrs.std()
range = max(df.utilization_hrs) - min(df.utilization_hrs)
range

df.utilization_pct.var()
df.utilization_pct.std()
range = max(df.utilization_pct) - min(df.utilization_pct)
range

df.idle_hrs.var()
df.idle_hrs.std()
range = max(df.idle_hrs) - min(df.idle_hrs)
range

df.technical_downtime_hrs.var()
df.technical_downtime_hrs.std()
range = max(df.technical_downtime_hrs) - min(df.technical_downtime_hrs)
range

df.planned_maintenance_hrs.var()
df.planned_maintenance_hrs.std()
range = max(df.planned_maintenance_hrs) - min(df.planned_maintenance_hrs)
range

df.workflow_delay_events.var()
df.workflow_delay_events.std()
range = max(df.workflow_delay_events) - min(df.workflow_delay_events)
range

df.avg_delay_minutes.var()
df.avg_delay_minutes.std()
range = max(df.avg_delay_minutes) - min(df.avg_delay_minutes)
range 

df.total_cases_day_lab.var()
df.total_cases_day_lab.std()
range = max(df.total_cases_day_lab) - min(df.total_cases_day_lab)
range


# third moment of business decision
df.max_capacity_hrs.skew()
sns.histplot(df.max_capacity_hrs, bins = 10, kde = True)

df.utilization_hrs.skew()
sns.histplot(df.utilization_hrs, bins = 10 , kde = True)

df.utilization_pct.skew()
sns.histplot(df.utilization_pct, bins = 10 , kde = True)

df.idle_hrs.skew()
sns.histplot(df.idle_hrs, bins = 10 , kde = True)

df.technical_downtime_hrs.skew()
sns.histplot(df.technical_downtime_hrs, bins = 10 , kde = True)

df.planned_maintenance_hrs.skew()
sns.histplot(df.planned_maintenance_hrs, bins = 10 , kde = True)

df.workflow_delay_events.skew()
sns.histplot(df.workflow_delay_events, bins = 10 , kde = True)

df.avg_delay_minutes.skew()
sns.histplot(df.avg_delay_minutes, bins = 10 , kde = True)

df.total_cases_day_lab.skew()
sns.histplot(df.total_cases_day_lab, bins = 10 , kde = True)




# fourth moment of business decision & using multivarient(bar plot)
df.max_capacity_hrs.kurt()
plt.bar(height = df.max_capacity_hrs, x = np.arange(0, 10434, 1), color = 'red')  

df.utilization_hrs.kurt()
plt.bar(height = df.utilization_hrs, x = np.arange(0, 10434, 1), color = 'red')

df.utilization_pct.kurt()
plt.bar(height = df.utilization_pct, x = np.arange(0, 10434, 1), color = 'red')

df.idle_hrs.kurt()
plt.bar(height = df.idle_hrs, x = np.arange(0, 10434, 1), color = 'red')

df.technical_downtime_hrs.kurt()
plt.bar(height = df.technical_downtime_hrs, x = np.arange(0, 10434, 1), color = 'red')

df.planned_maintenance_hrs.kurt()
plt.bar(height = df.planned_maintenance_hrs, x = np.arange(0, 10434, 1), color = 'red')

df.workflow_delay_events.kurt()
plt.bar(height = df.workflow_delay_events, x = np.arange(0, 10434, 1), color = 'red')

df.avg_delay_minutes.kurt()
plt.bar(height = df.avg_delay_minutes, x = np.arange(0, 10434, 1), color = 'red')

df.total_cases_day_lab.kurt()
plt.bar(height = df.total_cases_day_lab, x = np.arange(0, 10434, 1), color = 'red')



# finding outliers using univarient   -  Bix plot
sns.boxplot(df.max_capacity_hrs)
sns.boxplot(df.utilization_hrs)
sns.boxplot(df.utilization_pct) #replace the outliers using IQR techinque 
sns.boxplot(df.idle_hrs) 
sns.boxplot(df.technical_downtime_hrs)
sns.boxplot(df.planned_maintenance_hrs) # outliers 
sns.boxplot(df.workflow_delay_events) # outliers 
sns.boxplot(df.avg_delay_minutes) # to many outliers 
sns.boxplot(df.total_cases_day_lab)



# AUTO EDA 
import dtale 

d = dtale.show(df, host = 'localhost', port = 10434)
d.open_browser()



#Data cleaning 

sns.boxplot(df.utilization_pct) # before replacing outliers 
Q1 = df['utilization_pct'].quantile(0.25)
Q3 = df['utilization_pct'].quantile(0.75)
IQR = Q3 - Q1
lower = Q1 - 1.5 * IQR       # use IQR techinque for replacinh the outliers below lower limit values replace with lower limit 
upper = Q3 + 1.5 * IQR       # above upper limit values replace with upper limit value 
lower, upper

df['utilization_pct'] = pd.DataFrame(np.where(df['utilization_pct'] > upper, upper,  np.where(df['utilization_pct'] < lower, lower, df['utilization_pct'])))
sns.boxplot(df.utilization_pct) # after replacing outliers 


sns.boxplot(df.idle_hrs)
Q1 = df['idle_hrs'].quantile(0.25)
Q3 = df['idle_hrs'].quantile(0.75)
IQR = Q3 - Q1 
lower = Q1 - 1.5 * IQR 
upper = Q3 + 1.5 * IQR
lower, upper 

df['idle_hrs'] = pd.DataFrame(np.where(df['idle_hrs'] > upper, upper,  np.where(df['idle_hrs'] < lower, lower, df['idle_hrs'])))
sns.boxplot(df.idle_hrs)

#Create a Downtime Flag
sns.boxplot(df.technical_downtime_hrs)               # no need to replace  
#Q1 = df['technical_downtime_hrs'].quantile(0.25)
#Q3 = df['technical_downtime_hrs'].quantile(0.75)
#IQR = Q3 - Q1                                    # this values are also turn into zero so that this is not a good imputation 

#lower = Q1 - 1.5 * IQR
#upper = Q3 + 1.5 * IQR
df['downtime_flag'] = (df['technical_downtime_hrs'] > 0).astype(int)
df.downtime_flag
         

#Create a Downtime Flag
sns.boxplot(df.planned_maintenance_hrs)    # inthis one also sany 0's is there 
df['planned_maintenance_flag'] = (df['planned_maintenance_hrs'] > 0).astype(int)
df.planned_maintenance_flag


sns.boxplot(df.workflow_delay_events)
df['workflow_delay_flag'] = (df['workflow_delay_events'] > 0).astype(int)
sns.boxplot(df.workflow_delay_events)


sns.boxplot(df.avg_delay_minutes)
df['avg_delay_minutes_flag'] = (df['avg_delay_minutes'] > 0).astype(int)
sns.boxplot(df.avg_delay_minutes)

# find ing null values and imputation 
df.date.isnull().sum()  # 50 null values 
df.lab_id.isnull().sum()
df.equipment_id.isnull().sum()
df.equipment_type.isnull().sum()
df.max_capacity_hrs.isnull().sum()
df.utilization_hrs.isnull().sum()  # 104 null values 
df.utilization_pct.isnull().sum()  # 104 null values 
df.idle_hrs.isnull().sum()         # 104 null values 
df.technical_downtime_hrs.isnull().sum()
df.planned_maintenance_hrs.isnull().sum()
df.workflow_delay_events.isnull().sum()
df.avg_delay_minutes.isnull().sum()
df.primary_procedure.isnull().sum()
df.redundancy_available.isnull().sum()
df.total_cases_day_lab.isnull().sum()

df.isnull().sum() # fill null values in single line 

# date 
df['date'] = df['date'].bfill() # use forward filling 


#utilization_hrs
df['utilization_hrs'] = df['utilization_hrs'].fillna(df['utilization_hrs'].mean())



#utilization_pct
df['utilization_pct'] = df['utilization_pct'].fillna(df['utilization_pct'].mean())


#idle_hrs
df['idle_hrs'] = df['idle_hrs'].fillna(df['idle_hrs'].mean())


#bivarient  - scatter plot
plt.scatter(x = df['utilization_hrs'], y = df['idle_hrs']) 
plt.scatter(x = df['max_capacity_hrs'], y = df['utilization_hrs'])
plt.scatter(x = df['utilization_pct'], y = df['idle_hrs']) 
plt.scatter(x = df['technical_downtime_hrs'], y = df['utilization_hrs'])
plt.scatter(x = df['planned_maintenance_hrs'], y = df['technical_downtime_hrs']) 
plt.scatter(x = df['workflow_delay_events'], y = df['avg_delay_minutes'])
plt.scatter(x = df['total_cases_day_lab'], y = df['utilization_hrs'])
plt.scatter( x = df['utilization_hrs'], y = df['utilization_pct'])
plt.scatter( x = df['idle_hrs'], y = df['technical_downtime_hrs'])

plt.scatter( x = df['planned_maintenance_hrs'], y = df['workflow_delay_events'])
plt.scatter(x = df['max_capacity_hrs'], y = df['avg_delay_minutes'])




# Multivariate
sns.scatterplot(data=df,
    x='max_capacity_hrs',
    y='avg_delay_minutes',
    hue='primary_procedure')

sns.scatterplot(data=df,
    x='idle_hrs',
    y='utilization_pct',
    hue='equipment_id')

sns.scatterplot(data=df,
    x='idle_hrs',
    y='utilization_pct',
    hue='equipment_type')

sns.scatterplot(data=df,
    x='utilization_pct',
    y='utilization_hrs',
    hue='primary_procedure')

sns.scatterplot(data=df,
    x='utilization_hrs',
    y='utilization_pct',
    hue='equipment_type')


sns.scatterplot(data=df,
    x='technical_downtime_hrs',
    y='workflow_delay_events',
    hue='equipment_type')

sns.scatterplot(data=df,
    x='technical_downtime_hrs',
    y='avg_delay_minutes',
    hue='equipment_id')

sns.scatterplot(data=df,
    x='planned_maintenance_hrs',
    y='avg_delay_minutes',
    hue='primary_procedure')

sns.scatterplot(data=df,
    x='workflow_delay_events',
    y='avg_delay_minutes',
    hue='equipment_type')

plt.scatter(
   df['utilization_hrs'],
   df['idle_hrs'],
   s = df['workflow_delay_events']*10, alpha = 0.6)

df.duplicated().sum()


from sqlalchemy import create_engine
from urllib.parse import quote

user =  'root'                       # give MySQL user name 
pw   =  quote('Sarath@1911')         # give pssword
db   =  'ivf_equipment'   # give data base name 

engine = create_engine(f"mysql+pymysql://{user}:{pw}@localhost/{db}")  #create the engine to connect the MySQL databse to SQLalchemy 

df.to_sql('data_set', con = engine, if_exists = 'replace', chunksize = 1000, index = False) #push that data into MySQL 

sql = 'select * from data_set'

df = pd.read_sql_query(sql, con = engine)





