

  #!/bin/bash 
 
   #Pass arguements
#1 Run all ftps - FTP
#  RUN all non ftps - NFTP
#
#2 Run Periodic updates- PRD


 


start=$(date +%s)  

###########configuration ####### 
. /home/estore/importscripts/config.sh
################################ 


 #process status 
mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e" 
     UPDATE estore_full.run_status SET progress='running',last_updated=NOW();
  
"



if echo "$2" | grep -iq "^PRD" ;then
echo "Running periodic updates  "
/home/estore/importscripts/periodic.sh
 
fi





/home/estore/importscripts/showstatus.sh

if echo  "$1" | grep -iq "^FTP" ;then
    echo  'processing all ftps'
 

/home/estore/importscripts/3000003_1.sh 
/home/estore/importscripts/3000003_4Quantity.sh  
/home/estore/importscripts/3002822_77.sh
/home/estore/importscripts/3000012_14.sh 
/home/estore/importscripts/3000002_5.sh   
/home/estore/importscripts/3000002_6Quantity.sh 
/home/estore/importscripts/3000008_3.sh
/home/estore/importscripts/3000060_49.sh  
/home/estore/importscripts/3000004_2.sh 
/home/estore/importscripts/3000005_13.sh 
/home/estore/importscripts/3000006_7.sh  
/home/estore/importscripts/3000006_8Quantity.sh   
/home/estore/importscripts/3000009_10.sh     
/home/estore/importscripts/3000011_11.sh     
/home/estore/importscripts/3000015_21.sh  
/home/estore/importscripts/3000094_45.sh  
/home/estore/importscripts/3000016_22.sh 
/home/estore/importscripts/3000017_23.sh   
/home/estore/importscripts/3000024_31.sh  
/home/estore/importscripts/3000024_32.sh  
/home/estore/importscripts/3000024_33.sh  
/home/estore/importscripts/3000024_34.sh 
/home/estore/importscripts/3000024_35Quantity.sh   
/home/estore/importscripts/3000057_46.sh   
/home/estore/importscripts/3000065_48.sh   
/home/estore/importscripts/3000212_50.sh   
/home/estore/importscripts/3000289_52.sh    
/home/estore/importscripts/3002596_72.sh  
/home/estore/importscripts/3003030_85.sh   
/home/estore/importscripts/3003031_86.sh   
/home/estore/importscripts/3003032_87.sh   
/home/estore/importscripts/3003035_89.sh 
/home/estore/importscripts/3003035_90Quantity.sh  
/home/estore/importscripts/3003036_91.sh     


elif  echo  "$1" | grep -iq "^NFTP" ;then
    
echo 'processing all non ftps' 


/home/estore/importscripts/3000321_59.sh
/home/estore/importscripts/3000001_15.sh 
/home/estore/importscripts/3000010_9.sh  
/home/estore/importscripts/3000014_19.sh  
/home/estore/importscripts/3000020_27.sh
/home/estore/importscripts/3000021_84.sh
/home/estore/importscripts/3000066_57.sh  
/home/estore/importscripts/3000102_63.sh
/home/estore/importscripts/3000291_67.sh  
/home/estore/importscripts/3002595_70.sh  
/home/estore/importscripts/3003000_96.sh
/home/estore/importscripts/3000838_78.sh
/home/estore/importscripts/3003047_93.sh
else

  echo 'processing all files'
 

 
/home/estore/importscripts/3000321_59.sh  
/home/estore/importscripts/3000003_1.sh 
/home/estore/importscripts/3000003_4Quantity.sh  
/home/estore/importscripts/3002822_77.sh
/home/estore/importscripts/3000012_14.sh 
/home/estore/importscripts/3000002_5.sh   
/home/estore/importscripts/3000002_6Quantity.sh 
/home/estore/importscripts/3000008_3.sh
/home/estore/importscripts/3000060_49.sh  
/home/estore/importscripts/3000004_2.sh 
/home/estore/importscripts/3000005_13.sh 
/home/estore/importscripts/3000006_7.sh  
/home/estore/importscripts/3000006_8Quantity.sh   
/home/estore/importscripts/3000009_10.sh     
/home/estore/importscripts/3000011_11.sh     
/home/estore/importscripts/3000015_21.sh  
/home/estore/importscripts/3000016_22.sh 
/home/estore/importscripts/3000017_23.sh   
/home/estore/importscripts/3000024_31.sh  
/home/estore/importscripts/3000024_32.sh  
/home/estore/importscripts/3000024_33.sh  
/home/estore/importscripts/3000024_34.sh 
/home/estore/importscripts/3000024_35Quantity.sh   
/home/estore/importscripts/3000057_46.sh   
/home/estore/importscripts/3000065_48.sh   
/home/estore/importscripts/3000212_50.sh   
/home/estore/importscripts/3000289_52.sh    
/home/estore/importscripts/3002596_72.sh  
/home/estore/importscripts/3003030_85.sh   
/home/estore/importscripts/3003031_86.sh   
/home/estore/importscripts/3003032_87.sh   
/home/estore/importscripts/3003035_89.sh 
/home/estore/importscripts/3003035_90Quantity.sh  
/home/estore/importscripts/3003036_91.sh  
/home/estore/importscripts/3000001_15.sh 
/home/estore/importscripts/3000010_9.sh
/home/estore/importscripts/3000014_19.sh  
/home/estore/importscripts/3000020_27.sh
/home/estore/importscripts/3000021_84.sh
/home/estore/importscripts/3000066_57.sh
/home/estore/importscripts/3000094_45.sh    
/home/estore/importscripts/3000102_63.sh
/home/estore/importscripts/3000291_67.sh 
/home/estore/importscripts/3002595_70.sh
/home/estore/importscripts/3003000_96.sh
fi

 






 




/home/estore/importscripts/last.sh


 
 echo  'Indexing Solr'
 wget "http://www.computronestore.com:8080/solr/collection1/dataimport?clean=true&command=full-import&commit=true&debug=false&indent=true&optimize=true&verbose=false&wt=json"
 

/home/estore/importscripts/image.sh







                               
mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"	

#updated date 
UPDATE suppliers a SET updated_date = IFNULL((SELECT  
      MAX(products_sup_modified) 
    FROM
      steve_pool_price p
      WHERE  a.supplier_id = p.supplier_id  
      GROUP BY supplier_id),'0000-00-00 00:00:00');

     		
##active products	 
UPDATE suppliers a SET product_count = IFNULL((SELECT  
      COUNT(product_id) 
    FROM
      steve_pool_price p
      WHERE  a.supplier_id = p.supplier_id AND product_id !=0 AND products_status=4
      GROUP BY supplier_id),0);



#downloaded 
UPDATE suppliers a SET downloaded = IFNULL((SELECT  
      COUNT(product_id) 
    FROM
      steve_pool_price p
      WHERE  a.supplier_id = p.supplier_id AND product_id!=0 AND products_status IN(4,9)
      GROUP BY supplier_id),0);


 
#notdownloaded
UPDATE suppliers a SET notdownloaded = IFNULL((SELECT  
      COUNT(product_id) 
    FROM
      steve_pool_price p
      WHERE  a.supplier_id = p.supplier_id AND product_id=0 AND products_status IN(4,9) 
      GROUP BY supplier_id),0);


 
 #process status 
UPDATE estore_full.run_status SET progress='idle',last_updated=now();

"

 



end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Total Runtime  :  $runtime" 
