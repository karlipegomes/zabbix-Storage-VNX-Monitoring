# Scripts de monitoramento VNX

Scripts que são utilizados para realizar algumas funções de monitoramento do Storage do site backup EMC VNX.

##
Inicialmente é necessário configurar a crontab para executar o script de obtenção de informações para a cada 1 minuto. Conforme exemplo abaixo:

[root@svrmonitoramento externalscripts]# crontab -l 
*/1 * * * * bash /usr/lib/zabbix/externalscripts/navi/00-getinformation.sh
