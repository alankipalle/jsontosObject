/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 09/11/2018
 * @description Allows the retrieval of fields on related objects using calls such as get('Related__r.Field__c') which 
 * are not directly possible on SObject
 *
 * MIT License
 *
 * Copyright (c) 2018 Aidan Harding, Nebula Consulting
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

global class SObjectGetter {
    
    global static Object get(SObject obj, String field) {
        if(field.indexOf('.') > 0) {
            List<String> objectFields = field.split('\\.');

            SObject currentObject = obj;
            Integer currentFieldPosition = 0;

            while(currentFieldPosition < objectFields.size() - 1) {
                currentObject = (SObject)currentObject.getSObject(objectFields[currentFieldPosition++]);
                if(currentObject == null) {
                    return null;
                }
            }
            return currentObject.get(objectFields[currentFieldPosition]);
        } else {
            return obj.get(field);
        }
    }
}