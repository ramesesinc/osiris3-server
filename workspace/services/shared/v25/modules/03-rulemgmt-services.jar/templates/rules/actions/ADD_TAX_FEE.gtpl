Map map${} = new HashMap();
map.put( "lob", ${action.params.lob.name} );

TaxFee tf = new TaxFee();
tf.setAcctId( "${action.params.acctid.objid}" );
infos.add( tf );

${action.params.value}