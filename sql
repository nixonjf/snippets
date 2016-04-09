#!/bin/bash
 
starta=$(date +%s)
###########configuration ####### 
. /home/estore/importscripts/config.sh
################################ 
 echo  "post processing"

 

start=$(date +%s)  
  echo "updating unique manufacturer Id in steve_pool_price"
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
        UPDATE  steve_pool_price P
        INNER JOIN  steve_pool_manufacturer M ON M.Name = P. supplier_manufacture_name
        INNER JOIN  steve_pool_unique_manufacturer U ON M.ID=U.steve_manufacure_id AND M.ID !=0
        SET P.unique_manufacturers_id = U.unique_id
        WHERE P.unique_manufacturers_id =0;

	UPDATE  steve_pool_price P
        INNER JOIN  steve_pool_manufacturer M ON M.NAME = P.supplier_manufacture_name
        INNER JOIN  steve_pool_unique_manufacturer U ON  M.BertId= U.bert_manufacure_id AND M.BertId !=0
        SET P.unique_manufacturers_id = U.unique_id 
        WHERE P.unique_manufacturers_id =0; 
"

 end=$(date +%s)
 runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime"  


 echo  "Updating Product ID's from Steve"


start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
            

        TRUNCATE TABLE steve_pool_tmp; 

        UPDATE estore_full.steve_pool_price T   
        INNER JOIN  steve_pool_unique_manufacturer U ON T.unique_manufacturers_id=U.unique_id
        INNER JOIN DataSource.cds_Prod MP ON T.products_mfg_part_no=MP.MfPN AND U.steve_manufacure_id=MP.MfID
        SET T.steve_id=MP.ProdID,T.content_from=1
        WHERE U.steve_manufacure_id !='0' AND T.steve_id='0';
 
"
  
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 


 echo  "Updating remaining Product ID's from Bert"
start=$(date +%s)    
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
 

                UPDATE estore_full.steve_pool_price AS T  
                INNER JOIN  steve_pool_unique_manufacturer U ON T.unique_manufacturers_id=U.unique_id
                INNER JOIN estore_us.product AS BE ON T.products_mfg_part_no=BE.mfgpartno AND U.bert_manufacure_id=BE.manufacturerid  
                SET T.bert_id=BE.productid,T.content_from=2,T.category_id=BE.categoryid,T.category_from=2          
                WHERE T.unique_manufacturers_id!=0 AND U.bert_manufacure_id!=0 AND T.steve_id='0' AND T.bert_id=0 ;
               
                UPDATE estore_full.steve_pool_price AS T  
                INNER JOIN  steve_pool_unique_manufacturer U ON T.unique_manufacturers_id=U.unique_id
                INNER JOIN estore_na.product AS BE ON T.products_mfg_part_no=BE.mfgpartno AND U.bert_manufacure_id=BE.manufacturerid  
                SET T.bert_id=BE.productid,T.content_from=3,T.category_id=BE.categoryid,T.category_from=2          
                WHERE T.unique_manufacturers_id!=0 AND U.bert_manufacure_id!=0  AND T.steve_id='0' AND T.bert_id=0 ; 
                
                UPDATE estore_full.steve_pool_price AS T  
                INNER JOIN  steve_pool_unique_manufacturer U ON T.unique_manufacturers_id=U.unique_id
                INNER JOIN estore_sg.product AS BE ON T.products_mfg_part_no=BE.mfgpartno AND U.bert_manufacure_id=BE.manufacturerid  
                SET T.bert_id=BE.productid,T.content_from=4,T.category_id=BE.categoryid,T.category_from=2          
                WHERE T.unique_manufacturers_id!=0 AND U.bert_manufacure_id!=0  AND T.steve_id='0' AND T.bert_id=0 ; 
                
                
                UPDATE estore_full.steve_pool_price AS T  
                INNER JOIN  steve_pool_unique_manufacturer U ON T.unique_manufacturers_id=U.unique_id
                INNER JOIN estore_uk.product AS BE ON T.products_mfg_part_no=BE.mfgpartno AND U.bert_manufacure_id=BE.manufacturerid  
                SET T.bert_id=BE.productid,T.content_from=5,T.category_id=BE.categoryid,T.category_from=2          
                WHERE T.unique_manufacturers_id!=0 AND U.bert_manufacure_id!=0  AND T.steve_id='0' AND T.bert_id=0 ;
                
                
                UPDATE estore_full.steve_pool_price AS T  
                INNER JOIN  steve_pool_unique_manufacturer U ON T.unique_manufacturers_id=U.unique_id
                INNER JOIN estore_eu.product AS BE ON T.products_mfg_part_no=BE.mfgpartno AND U.bert_manufacure_id=BE.manufacturerid  
                SET T.bert_id=BE.productid,T.content_from=6,T.category_id=BE.categoryid,T.category_from=2          
                WHERE T.unique_manufacturers_id!=0 AND U.bert_manufacure_id!=0  AND T.steve_id='0' AND T.bert_id=0 ;
                 
              
"
 end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
 echo  "Updating category_id's from Steve"
start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
    
                UPDATE estore_full.steve_pool_price PR 
		INNER JOIN DataSource.cds_Cct_Products CC ON PR.steve_id = CC.ProdID 
		SET PR.category_id = CC.CatID,PR.category_from=1 
		WHERE PR.category_id = 0  AND LENGTH (CC.CatID) = 10 AND CC.isPrimary=1;
		UPDATE estore_full.steve_pool_price PR 
		INNER JOIN DataSource.cds_Cct_Products CC ON PR.steve_id = CC.ProdID 
		SET PR.category_id = CC.CatID,PR.category_from=1 
		WHERE PR.category_id = 0  AND LENGTH (CC.CatID) = 8 AND CC.isPrimary=1;
		UPDATE estore_full.steve_pool_price PR 
		INNER JOIN DataSource.cds_Cct_Products CC ON PR.steve_id = CC.ProdID  
		SET PR.category_id = CC.CatID,PR.category_from=1
		WHERE PR.category_id = 0  AND LENGTH (CC.CatID) = 6 AND CC.isPrimary=1;
		UPDATE estore_full.steve_pool_price PR 
		INNER JOIN DataSource.cds_Cct_Products CC ON PR.steve_id = CC.ProdID  
		SET PR.category_id = CC.CatID,PR.category_from=1 
		WHERE PR.category_id = 0  AND LENGTH (CC.CatID) = 4 AND CC.isPrimary=1;
 

                UPDATE steve_pool_price pr
                JOIN steve_pool_cat cc ON cc.category_name = pr.supplier_category_name
                SET pr.category_id=cc.steve_id,pr.category_from=1 
                WHERE  pr.category_id=0 AND LENGTH(cc.steve_id)=10 AND cc.bert_id>0;

                UPDATE steve_pool_price pr
                JOIN steve_pool_cat cc ON cc.category_name = pr.supplier_category_name
                SET pr.category_id=cc.steve_id,pr.category_from=1 
                WHERE pr.category_id=0 AND LENGTH(cc.steve_id)=8 AND cc.bert_id>0;

                UPDATE steve_pool_price pr
                JOIN steve_pool_cat cc ON cc.category_name = pr.supplier_category_name
                SET pr.category_id=cc.steve_id,pr.category_from=1 
                WHERE  pr.category_id=0 AND LENGTH(cc.steve_id)=6 AND cc.bert_id>0;
                
                UPDATE steve_pool_price pr
                JOIN steve_pool_cat cc ON cc.category_name = pr.supplier_category_name
                SET pr.category_id=cc.steve_id,pr.category_from=1 
                WHERE  pr.category_id=0 AND LENGTH(cc.steve_id)=4 AND cc.bert_id>0;
                
                UPDATE steve_pool_price pr
                JOIN steve_pool_cat cc ON cc.category_name = pr.supplier_category_name
                SET pr.category_id=cc.bert_id,pr.category_from=2
                WHERE  pr.category_id=0 AND cc.bert_id>0;
                
                UPDATE steve_pool_price pr
                JOIN categories cc ON cc.categories_name = pr.supplier_category_name
                SET pr.category_id=cc.categories_id,pr.category_from=2
                WHERE  pr.category_id=0;
                
                UPDATE steve_pool_price pr
                JOIN supplier_steve_bert_cat cc ON cc.supplier_cat_name = pr.supplier_category_name
                SET pr.category_id=cc.bert_cat_id,pr.category_from=2
                WHERE  pr.category_id=0 AND cc.bert_cat_id>0;
                
                UPDATE steve_pool_price pr
                JOIN supplier_steve_bert_cat cc ON cc.supplier_cat_name = pr.supplier_category_name
                SET pr.category_id=cc.steve_cat_id,pr.category_from=1
                WHERE  pr.category_id=0 AND cc.steve_cat_id>0;

"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
 echo  'Converting price to USD '
start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
 
                UPDATE 
                estore_full.steve_pool_price T  
                JOIN currencies b ON T.currency=b.currency
                SET T.usd_products_cost = (T.products_cost/b.rate)
                WHERE  T.products_cost  !=0; 
        
	 
"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

echo  'Updating product short/long description from Steve'
start=$(date +%s) 
mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"     

                UPDATE estore_full.steve_pool_price a
		INNER JOIN DataSource.cds_Stdnezshort f ON a.steve_id=f.ProdID
		SET a.products_short_description=f.Description
		WHERE a.content_from=1; 
                
                UPDATE estore_full.steve_pool_price a
		INNER JOIN DataSource.cds_Stdnez f ON a.steve_id=f.ProdID
		SET a.products_long_description=f.Description
		WHERE a.content_from=1;   

"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 


echo  'Updating product long description from Bert'
start=$(date +%s)   
mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_us.productdescriptions f ON a.bert_id=f.productid AND a.content_from=2
		SET a.products_long_description=f.description 
		WHERE f.type= 1 and a.bert_id!=0 ;	

		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_na.productdescriptions f ON a.bert_id=f.productid AND a.content_from=3
		SET a.products_long_description=f.description 
		WHERE f.type= 1 and a.bert_id!=0 ;		
		
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_sg.productdescriptions f ON a.bert_id=f.productid AND a.content_from=4
		SET a.products_long_description=f.description 
		WHERE f.type= 1 and a.bert_id!=0 ;	
		
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_uk.productdescriptions f ON a.bert_id=f.productid AND a.content_from=5
		SET a.products_long_description=f.description 
		WHERE f.type= 1 and a.bert_id!=0;	
		
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_eu.productdescriptions f ON a.bert_id=f.productid AND a.content_from=6
		SET a.products_long_description=f.description 
		WHERE f.type= 1 and a.bert_id!=0 ;	

	   
	
"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 


 echo  'Updating product short description from Bert'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
   
	
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_us.productdescriptions f ON a.bert_id=f.productid AND a.content_from=2
		SET a.products_short_description=f.description 
		WHERE f.type= 0  and a.bert_id!=0 ;	

		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_na.productdescriptions f ON a.bert_id=f.productid AND a.content_from=3
		SET a.products_short_description=f.description 
		WHERE f.type= 0  and a.bert_id!=0 ;		
		
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_sg.productdescriptions f ON a.bert_id=f.productid AND a.content_from=4
		SET a.products_short_description=f.description 
		WHERE f.type= 0  and a.bert_id!=0;	
		
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_uk.productdescriptions f ON a.bert_id=f.productid AND a.content_from=5
		SET a.products_short_description=f.description 
		WHERE f.type= 0  and a.bert_id!=0;	
		
		UPDATE estore_full.steve_pool_price a
		INNER JOIN estore_eu.productdescriptions f ON a.bert_id=f.productid AND a.content_from=6
		SET a.products_short_description=f.description 
		WHERE f.type= 0  and a.bert_id!=0;	

	
"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 








 echo  'Updating Weight attributes'
start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"				 
				
				 
				########## insert to steve_weight
				INSERT IGNORE INTO estore_full.steve_weight(products_id,manufacturers_id,products_mfg_part_no,gross_wt,LENGTH,width,height,volume_wt)
                                SELECT 
                                  B.ProdID,
                                  T.unique_manufacturers_id,
                                  T.products_mfg_part_no,
                                  CASE B.UnitID WHEN 'Y00137' THEN ROUND(B.NNV * 0.0283495, 2)   WHEN  'Y00135' THEN ROUND (B.NNV*0.4535920 ,2) ELSE 0 END AS gross_wt,
                                  CASE C.UnitID WHEN 'Y00098' THEN ROUND(C.NNV * 2.54, 2)   WHEN  'Y00100' THEN ROUND (C.NNV*30.48 ,2) ELSE 0 END AS lengths,
                                  CASE D.UnitID WHEN 'Y00098' THEN ROUND(D.NNV * 2.54, 2)   WHEN  'Y00100' THEN ROUND (D.NNV*30.48 ,2) ELSE 0 END AS width,
                                  CASE E.UnitID WHEN 'Y00098' THEN ROUND(E.NNV * 2.54, 2)   WHEN  'Y00100' THEN ROUND (E.NNV*30.48 ,2) ELSE 0 END AS height,
                                  CASE E.UnitID WHEN 'Y00098' THEN ROUND(((C.NNV * 2.54) * (D.NNV * 2.54) * (E.NNV * 2.54)) / 5000,2)   WHEN  'Y00100' THEN ROUND(((C.NNV *30.48) * (D.NNV *30.48) * (E.NNV *30.48)) / 5000,2) ELSE 0 END AS volume_wt
                                  FROM estore_full.steve_pool_price AS T 
                                JOIN estore_full.steve_weight_atr AS B
                                ON B.AtrID IN ('A00357','A01969','A01973') AND B.ProdID=T.steve_id
                                JOIN estore_full.steve_weight_atr AS C
                                ON C.AtrID IN ('A00355','A01967','A01971') AND C.ProdID=T.steve_id
                                JOIN estore_full.steve_weight_atr AS D
                                ON D.AtrID IN ('A00354','A01966','A01970') AND D.ProdID=T.steve_id
                                JOIN estore_full.steve_weight_atr AS E
                                ON E.AtrID IN ('A00356','A01968','A01972') AND E.ProdID=T.steve_id
                                WHERE T.steve_id LIKE 'S%'
                                GROUP BY T.steve_id;

				
				####  steve_shipping_weight
				
				
			        INSERT IGNORE INTO estore_full.steve_weight(products_id,manufacturers_id,products_mfg_part_no,gross_wt,LENGTH,width,height,volume_wt)
                                SELECT 
                                  B.ProdID,
                                  T.unique_manufacturers_id,
                                  T.products_mfg_part_no,
                                  CASE B.UnitID WHEN 'Y00137' THEN ROUND(B.NNV * 0.0283495, 2)   WHEN  'Y00135' THEN ROUND (B.NNV*0.4535920 ,2) ELSE 0 END AS gross_wt,
                                  CASE C.UnitID WHEN 'Y00098' THEN ROUND(C.NNV * 2.54, 2)   WHEN  'Y00100' THEN ROUND (C.NNV*30.48 ,2) ELSE 0 END AS lengths,
                                  CASE D.UnitID WHEN 'Y00098' THEN ROUND(D.NNV * 2.54, 2)   WHEN  'Y00100' THEN ROUND (D.NNV*30.48 ,2) ELSE 0 END AS width,
                                  CASE E.UnitID WHEN 'Y00098' THEN ROUND(E.NNV * 2.54, 2)   WHEN  'Y00100' THEN ROUND (E.NNV*30.48 ,2) ELSE 0 END AS height,
                                  CASE E.UnitID WHEN 'Y00098' THEN ROUND(((C.NNV * 2.54) * (D.NNV * 2.54) * (E.NNV * 2.54)) / 5000,2)   WHEN  'Y00100' THEN ROUND(((C.NNV *30.48) * (D.NNV *30.48) * (E.NNV *30.48)) / 5000,2) ELSE 0 END AS volume_wt
                                  FROM estore_full.steve_pool_price AS T 
                                JOIN estore_full.steve_weight_atr AS B
                                ON B.AtrID ='A01559' AND B.ProdID=T.steve_id
                                JOIN estore_full.steve_weight_atr AS C
                                ON C.AtrID ='A01557' AND C.ProdID=T.steve_id
                                JOIN estore_full.steve_weight_atr AS D
                                ON D.AtrID ='A01556' AND D.ProdID=T.steve_id
                                JOIN estore_full.steve_weight_atr AS E
                                ON E.AtrID ='A01558' AND E.ProdID=T.steve_id
                                WHERE T.steve_id LIKE 'S%' 
                                GROUP BY T.steve_id;
				
				
				
				##########################################################################
                                  
				###1.from category_weight for steve products
				
				
                                        UPDATE category_weight a
                                        JOIN steve_pool_cat b ON b.bert_id=a.categories_id 
                                        JOIN steve_pool_price c ON c.category_id=b.steve_id
                                        SET c.products_weight=a.weight,c.weight_from=1
                                        WHERE c.category_from=1
                                        AND (c.products_short_description LIKE CONCAT('%',a.category_condition,'%') OR c.products_long_description LIKE CONCAT('%',a.category_condition,'%'))
                                        AND c.unique_manufacturers_id>0
                                        AND a.weight>0
                                        AND c.products_mfg_part_no != '';
				
				
				#####################################################
				####1.from category_weight for bert products
				
                                        UPDATE category_weight a
                                        JOIN steve_pool_price c ON c.category_id=a.categories_id 
                                        SET c.products_weight=a.weight,c.weight_from=1
                                        WHERE c.category_from=2
                                        AND (c.products_short_description LIKE CONCAT('%',a.category_condition,'%') OR c.products_long_description LIKE CONCAT('%',a.category_condition,'%'))
                                        AND c.unique_manufacturers_id>0
                                        AND a.weight>0
                                        AND c.products_mfg_part_no != '';

				
				
				#####################################################
				#### update with same partnumber 
				
				
				
				UPDATE steve_pool_price a INNER JOIN steve_pool_price b ON a.unique_manufacturers_id=b.unique_manufacturers_id AND a.products_mfg_part_no=b.products_mfg_part_no
				SET a.products_weight=b.products_weight,a.weight_from=b.weight_from
				WHERE a.products_weight<b.products_weight AND b.products_weight !=0;
				
				#################################################################################
				####2. grn/artech weight 
				
				UPDATE weight AS w
				JOIN steve_pool_unique_manufacturer AS u ON u.bert_manufacure_id=w.manufacturers_id
				JOIN  steve_pool_price AS t ON t.unique_manufacturers_id=u.unique_id AND w.products_mfg_part_no = t.products_mfg_part_no
				SET t.products_weight=GREATEST(w.gross_wt,w.volume_wt),t.weight_from=2
				WHERE w.manufacturers_id != 0
                                AND t.unique_manufacturers_id>0
				AND w.products_mfg_part_no != ''
				AND t.weight_from NOT IN (1);
				
                                ###############################################################
				#3.steve_shipping_weight
				UPDATE steve_shipping_weight AS w, steve_pool_price AS t
				SET t.products_weight=GREATEST(w.gross_wt,w.volume_wt),t.weight_from=3
				WHERE w.manufacturers_id = t.unique_manufacturers_id
				AND w.products_mfg_part_no = t.products_mfg_part_no
                                AND t.unique_manufacturers_id != 0
				AND w.products_mfg_part_no != ''
				AND t.weight_from NOT IN (1,2);
				
				
				######################################################################
				#4.steve_weight
				UPDATE steve_weight AS w, steve_pool_price AS t
				SET t.products_weight=GREATEST(w.gross_wt,w.volume_wt),t.weight_from=4
				WHERE w.manufacturers_id = t.unique_manufacturers_id
				AND w.products_mfg_part_no = t.products_mfg_part_no
                                AND t.unique_manufacturers_id != 0
				AND w.products_mfg_part_no != ''
				AND t.weight_from NOT IN (1,2,3);

				###############################################################
				####5.update weight from bert
				
				
				
				UPDATE bert_weight AS w
				JOIN steve_pool_unique_manufacturer AS u ON u.bert_manufacure_id=w.manufacturers_id
				JOIN  steve_pool_price AS t ON t.unique_manufacturers_id=u.unique_id AND w.products_mfg_part_no = t.products_mfg_part_no
				SET t.products_weight=GREATEST(w.gross_wt,w.volume_wt),t.weight_from=5
				WHERE w.manufacturers_id != 0
                                AND t.unique_manufacturers_id>0
				AND w.products_mfg_part_no != ''
				AND t.weight_from NOT IN (1,2,3,4);
				
				
				#########################################################
				
				####6. insert to supplier_weight 
				 
				INSERT IGNORE INTO steve_supplier_weight( manufacturers_id, products_mfg_part_no, gross_wt, LENGTH, width, height, volume_wt, supplier_id )
				SELECT  t.unique_manufacturers_id, t.products_mfg_part_no, MAX( t.sup_weight * s.tokg ) , t.sup_l * s.tocm, t.sup_b * s.tocm,t.sup_h * s.tocm, 
				MAX( ((t.sup_l * s.tocm * t.sup_b * s.tocm * t.sup_h * s.tocm) /5000 )), t.supplier_id
				FROM steve_pool_price AS t, suppliers AS s
				WHERE weight_priority =1
				AND t.supplier_id = s.supplier_id
				AND t.unique_manufacturers_id >0
				AND t.product_id >0
				GROUP BY t.unique_manufacturers_id, t.products_mfg_part_no 
				ON DUPLICATE KEY UPDATE gross_wt = VALUES (gross_wt),
				LENGTH =VALUES (LENGTH), 
				width =VALUES (width),
				height =VALUES (height), 
				volume_wt =VALUES (volume_wt);
				 
				######--6.supplier_weight 
				
				
				UPDATE steve_supplier_weight AS w, steve_pool_price AS t
				SET t.products_weight=GREATEST(w.gross_wt,w.volume_wt),t.weight_from=6
				WHERE w.manufacturers_id = t.unique_manufacturers_id
				AND w.products_mfg_part_no = t.products_mfg_part_no
                                AND t.unique_manufacturers_id>0
				AND w.products_mfg_part_no != ''
				AND t.weight_from NOT IN (1,2,3,4,5);
				
				#####################################################################
				##-7. update category_max weight for bert
				
				UPDATE category_maxweight a
				JOIN steve_pool_price c ON c.category_id=a.categories_id 
				SET c.products_weight=a.max_weight,c.weight_from=7
				WHERE c.category_from=2
                                AND c.category_id > 0
                                AND c.products_weight>a.max_weight
				AND c.unique_manufacturers_id>0
				AND c.weight_from NOT IN (1,2,3,4,5,6);
				
				################-
				##7.update category_max weight for steve
				
				UPDATE category_maxweight a
				JOIN steve_pool_cat b ON b.bert_id=a.categories_id 
				JOIN steve_pool_price c ON c.category_id=b.steve_id
				SET c.products_weight=a.max_weight,c.weight_from=7
				WHERE c.category_from=1 
                                AND c.category_id > 0
                                AND c.products_weight>a.max_weight
				AND c.unique_manufacturers_id>0
				AND c.weight_from NOT IN (1,2,3,4,5,6);
				
				####################################
				#####7.update category_min weight for steve
				
				
				UPDATE category_maxweight a
				JOIN steve_pool_cat b ON b.bert_id=a.categories_id 
				JOIN steve_pool_price c ON c.category_id=b.steve_id
				SET c.products_weight=a.min_weight,c.weight_from=7
				WHERE c.category_from=1
                                AND c.products_weight<a.min_weight
				AND c.unique_manufacturers_id>0
				AND c.weight_from NOT IN (1,2,3,4,5,6);
				 
				###############--
				#-7.update category_min weight for bert
				
				 
				UPDATE category_maxweight a
				JOIN steve_pool_price c ON c.category_id=a.categories_id 
				SET c.products_weight=a.min_weight,c.weight_from=7
				WHERE c.category_from=2
                                AND c.products_weight<a.min_weight
				AND c.unique_manufacturers_id>0
				AND c.weight_from NOT IN (1,2,3,4,5,6);
				 		

"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
 echo  'Updating frieghtamount'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"	
				#################################################################
				 
				  
				UPDATE steve_pool_price P
				JOIN suppliers S ON P.supplier_id=S.supplier_id
				JOIN stores ST ON S.store_id=ST.store_id
				SET P.frieghtamount= ROUND(ST.frieght_per_kg*P.products_weight,2)
				WHERE P.products_weight!=0;
				
				
				######################################################################
				 
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")
 echo  'Updating margin'
start=$(date +%s)
    mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"					 
                                UPDATE  steve_pool_price PP
                                JOIN steve_pool_cat b ON b.steve_id=PP.category_id
                                LEFT JOIN steve_pool_unique_manufacturer MP ON PP.unique_manufacturers_id=MP.unique_id
                                JOIN margin_rules m ON m.category_id=b.bert_id AND m.store_type= IF( PP.store_id= 1, 1, 0 )
                                AND m.manufacturerid=IF(MP.bert_manufacure_id IN (10393,1037734,10306) AND PP.category_id IN (100301,10030111,10030304,10061403,5006,10030101,10030105,10030106,10030107,10030108) ,MP.bert_manufacure_id,0) 
                                SET PP.marginp=IF( m.margin_percentage = 0 , 10 , m.margin_percentage)
                                WHERE PP.category_from=1
                                AND (PP.usd_products_cost + PP.frieghtamount) >= m.price_start
                                AND (PP.usd_products_cost + PP.frieghtamount) < m.price_end;
				 
				##############################################################################
				#margin from bert
				
				UPDATE steve_pool_price PP
                                LEFT JOIN steve_pool_unique_manufacturer MP ON PP.unique_manufacturers_id=MP.unique_id
                                JOIN margin_rules m ON m.category_id=PP.category_id AND m.store_type= IF( PP.store_id= 1, 1, 0 )
				AND m.manufacturerid=IF(MP.bert_manufacure_id IN (10393,1037734,10306) AND PP.category_id IN (10153,4810,4805,4807,4816,4821,4820,4822,11515,5089,10015,11517,4966) ,MP.bert_manufacure_id,0)
                                SET PP.marginp=IF( m.margin_percentage = 0 , 10 , m.margin_percentage)
                                WHERE PP.category_from=2
                                AND (PP.usd_products_cost + PP.frieghtamount) >= m.price_start
                                AND (PP.usd_products_cost + PP.frieghtamount) < m.price_end;
				 
				###########################################################################
				#Default Margin 10%
                                UPDATE steve_pool_price PP SET PP.marginp=10 where PP.marginp=0;
"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
 echo  'Updating priceA'
start=$(date +%s) 
   mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"				
				
				
				UPDATE steve_pool_price AS t
				SET t.priceA= ((usd_products_cost+frieghtamount)+((usd_products_cost+frieghtamount)*marginp/100))
				WHERE t.supplier_id!=3000020;
				 


                                "
                                ##################################################################

echo "Runtime:  $runtime" 
 echo 'Updating steve_pool_unique_manufacture '

start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
                                INSERT INTO steve_pool_unique_manufacturer (steve_manufacure_id)
                                SELECT ID FROM steve_pool_manufacturer
                                WHERE ID NOT IN (SELECT t2.steve_manufacure_id FROM steve_pool_unique_manufacturer t2) AND ID!='0';

                                UPDATE steve_pool_unique_manufacturer a
                                INNER JOIN steve_pool_manufacturer b ON a.steve_manufacure_id=b.ID AND b.BertId !='0' 
                                SET a.bert_manufacure_id=b.BertId  
                                WHERE a.bert_manufacure_id='0';

        
 "
  end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

###################################################################





                echo  'Updating product status for backend'
               start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"

                    UPDATE steve_pool_price P SET P.products_status=9,P.products_last_modified=NOW()
                    WHERE (P.unique_manufacturers_id='8172' AND P.store_id IN (2,4)) 
                    AND P.product_id>0  AND P.products_status !=66 ;
                    
                    UPDATE steve_pool_price P SET P.products_status=9,P.products_last_modified=NOW()
                    WHERE 
                    (P.category_id IN (10030101,4810) AND P.store_id=2 )
                    AND P.product_id>0  AND P.products_status !=66 ;
                    
                    UPDATE steve_pool_price P SET P.products_status=9,P.products_last_modified=NOW()
                    WHERE (P.category_id IN(4966,4840,10096,10202,10803,4912,10024,10528,10030303,10061403,50080101,50090401) AND P.store_id!=1)
                    AND P.product_id>0  AND P.products_status !=66;
                    

                    UPDATE steve_pool_price P SET P.products_status=9,P.products_last_modified=NOW()
                    WHERE (P.unique_manufacturers_id='24' 
                    AND (P.category_id IN (4912,10448,10294,10914,10153,4810,4805,4807,4816,4821,4820,4822,11515,11655) OR P.category_id LIKE '100301%')AND P.store_id!=1)
                    AND P.product_id>0  AND P.products_status !=66;

                    UPDATE steve_pool_price P SET P.products_status=9,P.products_last_modified=NOW()
                    WHERE (P.category_id IN (10325,10984,10322,10321,10320,10318,11019,10235,11516,30030202,30030203,30030204,30030205) AND  P.store_id IN (2,4))
                    AND P.product_id>0  AND P.products_status !=66;
                    
                    UPDATE steve_pool_price P SET P.products_status=9,P.products_last_modified= NOW()
                    WHERE supplier_id IN(3000212, 3002822) OR store_id=4  AND P.products_status !=66;

                    UPDATE steve_pool_price P SET P.products_status=9 ,P.products_last_modified=NOW()
                    WHERE P.unique_manufacturers_id IN (2535) AND P.product_id>0  AND P.products_status !=66;

                    UPDATE steve_pool_price P SET P.products_status=9 ,P.products_last_modified=NOW()
                    WHERE P.products_status = 4 AND (P.products_long_description LIKE '%third party%' OR P.products_long_description LIKE '%thirdparty%' OR P.products_long_description LIKE '%3RD PARTY%');

                    UPDATE steve_pool_price P SET P.products_status=9
                    WHERE P.supplier_id IN(3002596,3000094) AND P.products_status = 4 ;

"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
   ##################################################################


 echo 'Update steve_pool_products_temp for unique product id and show_status reset'

        start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
 

            UPDATE steve_pool_products_temp p, (
               SELECT     category_id, 
                          products_short_description,
                          products_long_description,
                          products_last_modified,
                          products_sup_modified,  
                          products_mfg_part_no,unique_manufacturers_id,products_condition,category_from,products_weight

               FROM steve_pool_price PPM 
               WHERE  PPM.unique_manufacturers_id > 0 AND PPM.products_status=4 AND PPM.category_id>0
               GROUP BY PPM.products_mfg_part_no, PPM.unique_manufacturers_id, PPM.products_condition
            ) PP
            SET p.category_id=PP.category_id,p.category_from=PP.category_from,
            p.products_short_description=PP.products_short_description,
            p.products_long_description=PP.products_long_description, 
            p.products_last_modified=PP.products_last_modified,
            p.products_sup_modified=PP.products_sup_modified,
            p.weight=PP.products_weight
            WHERE p.products_mfg_part_no=PP.products_mfg_part_no AND p.unique_manufacturers_id=PP.unique_manufacturers_id AND p.products_condition=PP.products_condition;




            UPDATE steve_pool_products_temp p, (
               SELECT     category_id, 
                          products_short_description,
                          products_long_description,
                          products_last_modified,
                          products_sup_modified,  
                          products_mfg_part_no,unique_manufacturers_id,products_condition,category_from,products_weight

               FROM steve_pool_price PPM 
               WHERE  PPM.unique_manufacturers_id > 0 AND PPM.products_status=9 AND PPM.category_id>0
               GROUP BY PPM.products_mfg_part_no, PPM.unique_manufacturers_id, PPM.products_condition
            ) PP
            SET p.category_id=PP.category_id,p.category_from=PP.category_from,
            p.products_short_description=PP.products_short_description,
            p.products_long_description=PP.products_long_description, 
            p.products_last_modified=PP.products_last_modified,
            p.products_sup_modified=PP.products_sup_modified,
            p.weight=PP.products_weight
            WHERE p.products_mfg_part_no=PP.products_mfg_part_no AND p.unique_manufacturers_id=PP.unique_manufacturers_id AND p.products_condition=PP.products_condition;

            UPDATE steve_pool_products_temp SET showstatus=0,storeprices='';


       

"
 end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

   ##################################################################
 
echo  'Updating attributes in products from SG'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
UPDATE products_atr_solr_sg S JOIN steve_pool_products_temp P ON S.ProdID = P.bert_id SET P.attrs = S.attrs
WHERE P.bert_id > 0;
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
  ##################################################################
 
echo  'Updating attributes in products from EU'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
UPDATE products_atr_solr_eu S JOIN steve_pool_products_temp P ON S.ProdID = P.bert_id SET P.attrs = S.attrs
WHERE P.bert_id > 0;
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

  ##################################################################
 
echo  'Updating attributes in products from UK'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
UPDATE products_atr_solr_uk S JOIN steve_pool_products_temp P ON S.ProdID = P.bert_id SET P.attrs = S.attrs
WHERE P.bert_id > 0;
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

  ##################################################################

 
echo  'Updating attributes in products from US'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
UPDATE products_atr_solr_us S JOIN steve_pool_products_temp P ON S.ProdID = P.bert_id SET P.attrs = S.attrs
WHERE P.bert_id > 0;
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

  ##################################################################

 
echo  'Updating attributes in products from NA'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
UPDATE products_atr_solr_na S JOIN steve_pool_products_temp P ON S.ProdID = P.bert_id SET P.attrs = S.attrs
WHERE P.bert_id > 0;
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

  ##################################################################

echo  'Updating attributes in products from steve'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
UPDATE products_atr_solr_steve S JOIN steve_pool_products_temp P ON S.ProdID = P.steve_id SET P.attrs = S.attrs
WHERE P.steve_id LIKE 'S%';
"

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

 ###################################################################
        echo  'Updating Category Attribute names in category_atr '
               start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"

            #--update STEVE attributes 

            INSERT IGNORE INTO category_atr(cat_id,AtrName)
            SELECT 
              P.category_id,
              REPLACE(REPLACE(NA.Text,')',''),'(','')
            FROM
              estore_full.steve_pool_products_temp P 
              INNER JOIN DataSource.cds_Atr A 
                ON P.steve_id = A.ProdID 
              INNER JOIN DataSource.cds_Vocez_Common NA 
                ON A.AtrID = NA.ID
              WHERE P.steve_id LIKE 'S%' ;
            #--update BERT attributes

            INSERT IGNORE INTO category_atr(cat_id,AtrName)
            SELECT 
              P.category_id,
              REPLACE(REPLACE(DS.name,')',''),'(','') 
            FROM
              estore_us.search_attribute ES 
              JOIN steve_pool_products_temp P 
                ON P.bert_id = ES.productid 
              JOIN estore_us.attributenames DS 
                ON ES.attributeid = DS.attributeid 
              WHERE P.bert_id > 0;
"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
 echo  'Updating product rank'
start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"					
				
                                UPDATE steve_pool_products_temp P
                                INNER JOIN steve_cat_brand_rank R ON R.steve_cat_id=P.category_id AND R.unique_manufacturer_id=P.unique_manufacturers_id 
                                SET P.rank= IF(IFNULL(R.rank,0)=0,10000,IFNULL(R.rank,0))
                                WHERE P.category_from=1;


                                UPDATE steve_pool_products_temp P
                                INNER JOIN steve_cat_brand_rank R ON R.bert_cat_id=P.category_id AND R.unique_manufacturer_id=P.unique_manufacturers_id
                                SET P.rank= IF(IFNULL(R.rank,0)=0,10000,IFNULL(R.rank,0))
                                WHERE P.category_from=2 AND P.category_id>0;
				  
				"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 



                echo  'Updating category names in steve_pool_products_temp'
               start=$(date +%s)   
 mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"

           
               UPDATE steve_pool_products_temp P INNER JOIN 
               DataSource.cds_Cct_Categories C ON P.category_id = C.CatID
               SET P.category_name = C.CategoryName 
               WHERE P.category_id>0 AND P.category_from=1;

               UPDATE steve_pool_products_temp P INNER JOIN 
               categories C ON P.category_id = C.categories_id
               SET P.category_name = C.categories_name 
               WHERE C.categories_id>0 AND P.category_id>0 AND P.category_from=2;


               "
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 

        ###################################################################



                echo  'Updating steve_pool_products_temp'
               start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"

            UPDATE 
            steve_pool_price P 
            INNER JOIN steve_pool_products_temp PP 
            ON PP.products_mfg_part_no = P.products_mfg_part_no
            AND PP.unique_manufacturers_id = P.unique_manufacturers_id
            AND PP.unique_manufacturers_id > 0 
            AND PP.products_condition = P.products_condition 
            AND P.product_id=0
            SET P.product_id = PP.product_id,P.bert_id=PP.bert_id, P.steve_id=PP.steve_id, P.content_from=PP.content_from,P.category_id=PP.category_id,P.category_from=PP.category_from;     

  

            INSERT IGNORE INTO steve_pool_tmp (product_id,showstatus, storeprices, price,products_quantity)  
            SELECT P.product_id, 
	    MIN(products_status) AS showstatus,
            CAST(GROUP_CONCAT(DISTINCT 
            CONCAT(P.products_status,'~', 
            IF(P.store_id IS NULL,'0',P.store_id),'~', 
            IF(P.usd_products_cost IS NULL,'0.00',P.usd_products_cost),'~', 
            IF(P.marginp IS NULL,'0',P.marginp),'~', 
            IF(P.supplier_id IS NULL,'',P.supplier_id),'~', 
            IF(P.products_quantity IS NULL,'',P.products_quantity),'~', 
            IF(P.products_criteria IS NULL,'',P.products_criteria),'~',
            P.products_sup_modified,'~',
            P.supplier_sku
            )) AS CHAR), MIN(((P.usd_products_cost+P.frieghtamount)+((P.usd_products_cost+P.frieghtamount)*P.marginp/100))) ,
            SUM(products_quantity)
            FROM steve_pool_price P   
            WHERE P.unique_manufacturers_id > 0 AND P.products_status In (4,9) AND P.product_id>0 AND P.usd_products_cost>0
            GROUP BY P.product_id ; 	
	

           

            UPDATE steve_pool_tmp T
            INNER JOIN steve_pool_products_temp P 
            ON T.product_id = P.product_id 
            SET P.storeprices = T.storeprices,
            P.price = T.price,P.showstatus=T.showstatus,
            P.products_quantity=T.products_quantity;

            TRUNCATE TABLE steve_pool_tmp;


 

 
"
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

echo "Runtime:  $runtime" 
        ###################################################################



 echo 'Join all desktops as one category'

        start=$(date +%s)  
  mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"
 
            UPDATE 
              steve_pool_products_temp a 
            SET
              a.category_id = 10010101, a.category_name = 'Desktops'
            WHERE a.category_id IN (1001010101,1001010102,1001010103,1001010104,1001010106);

            UPDATE 
              steve_pool_products_temp a 
            SET
              a.category_id = 1001010105, a.category_name = 'ALL-IN-ONE Desktops'
            WHERE a.category_id =4871 
              AND a.attrs LIKE '%Product_Type~All-in-One_Computer%' ; 
            UPDATE 
            steve_pool_products  
            SET category_name = 'Desktops' 
            WHERE category_name = 'Desktop Computers';


 "

echo "Performing post transaction copying to backup and moving to live"
                                mysql -h$_host -u $_db_user -p$_db_password $_db --local_infile=1 -e "use $_db" -e"       

                                DROP TABLE IF EXISTS steve_pool_products_live;
                                CREATE TABLE steve_pool_products_live LIKE steve_pool_products_temp;                                  
                                ALTER TABLE steve_pool_products_live CHANGE product_id product_id INT( 11 ) UNSIGNED NOT NULL ;
                                INSERT INTO steve_pool_products_live
                                SELECT * FROM steve_pool_products_temp;                                 
                                DROP TABLE IF EXISTS steve_pool_products_backup;                         
                                RENAME TABLE steve_pool_products TO steve_pool_products_backup;
                                RENAME TABLE steve_pool_products_live TO steve_pool_products;  
 "

end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")

 ##################################################################


enda=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${enda} - ${starta})/60, (${enda} - ${starta})%60)")

echo "Total Runtime (last.sh) :  $runtime" 
