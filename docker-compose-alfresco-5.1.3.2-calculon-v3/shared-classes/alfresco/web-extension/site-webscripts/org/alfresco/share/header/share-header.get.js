<import resource="classpath:/alfresco/site-webscripts/org/alfresco/share/imports/share-header.lib.js">

model.jsonModel = {
   rootNodeId: "share-header",
   services: getHeaderServices(),
   widgets: [
      {
         id: "SHARE_VERTICAL_LAYOUT",
         name: "alfresco/layout/VerticalWidgets",
         config: 
         {
            widgets: getHeaderModel()
         }
      }
   ]
};

widgetUtils.deleteObjectFromArray(model.jsonModel, "id", "HEADER_SITES_MENU");   
widgetUtils.deleteObjectFromArray(model.jsonModel, "id", "HEADER_TASKS");   
