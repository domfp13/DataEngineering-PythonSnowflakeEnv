#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by Luis Enrique Fuentes Plata

import pandas as pd
import snowflake.connector
from os import environ

class SnowflakeConn:
    def __init__(self):
        self.snowflake_accountname:str = environ.get('SNOWFLAKE_ACCOUNTNAME')
        self.snowflake_username:str = environ.get('SNOWFLAKE_USERNAME')
        self.snowflake_password:str = environ.get('SNOWFLAKE_PASSWORD')
        self.snowflake_dbname:str = environ.get('SNOWFLAKE_DBNAME')
        self.snowflake_warehousename:str = environ.get('SNOWFLAKE_WAREHOUSENAME')
        self.snowflake_rolename:str = environ.get('SNOWFLAKE_ROLENAME')
        self.snowflake_schemaname:str = environ.get('SNOWFLAKE_SCHEMANAME')
    
    def values(self):
        return self.__dict__

class DataLoader(SnowflakeConn):
    def __init__(self):
        super(DataLoader, self).__init__()
    
    def __get_data_from_db(self, query:str) -> list:
        """Private Method that should only be used inside of this class

        Args:
            query (str): Query to be execute against a virtual warehouse

        Returns:
            list: List of tuples, result set.
        """
        try:  
            conn = snowflake.connector.connect(
                account=self.snowflake_accountname,
                user=self.snowflake_username,
                password=self.snowflake_password,
                warehouse=self.snowflake_warehousename,
                database=self.snowflake_dbname,
                schema=self.snowflake_schemaname,
                role=self.snowflake_rolename
                )
            
            cursor = conn.cursor()
            cursor.execute(query)
            
            return cursor.fetchall()
        except Exception as e:
            print(e)
        finally:
            if conn:
                cursor.close()
                conn.close()

    def get_all_sales(self) -> pd.DataFrame:
        """Returns a pandas.DataFrame with values for the Sales Table

        Returns:
            pd.DataFrame: Data from table Sales
        """
        data = self.__get_data_from_db(f"SELECT * FROM CC_DW.PUBLIC.SALES")
        return pd.DataFrame(data, columns=['PRODUCT_ID', 'RETAIL_PRICE', 'QUANTITY', 'CITY', 'STATE'])
