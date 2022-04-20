declare module "@salesforce/apex/ProductRMA.getCaseProduct" {
  export default function getCaseProduct(param: {casePrdId: any, qty: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductRMA.cloneCaseProduct" {
  export default function cloneCaseProduct(param: {caseProdData: any, qty: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductRMA.getProduct" {
  export default function getProduct(param: {rid: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductRMA.saveproducts" {
  export default function saveproducts(param: {prdlist: any, Causecode: any, causetype: any, disp: any, retreg: any, caseProd: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductRMA.saveSingleProduct" {
  export default function saveSingleProduct(param: {prodId: any, Causecode: any, causetype: any, disp: any, retreg: any, prodCondition: any, serialNum: any, macId: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductRMA.getCond" {
  export default function getCond(): Promise<any>;
}
