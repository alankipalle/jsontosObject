/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 2019-03-06
 * @description Converts an SObject to a Map<String, Object>, as typically sent to JSON.serialize()
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

global class SObjectToJsonObject {

    private Map<String, String> sObjectFieldToJsonObjectField;
    private Map<String, Function> fieldNameToFunction;
    private Boolean skipNulls;

    global SObjectToJsonObject(Map<String, String> sObjectFieldToJsonObjectField) {
        this.sObjectFieldToJsonObjectField = sObjectFieldToJsonObjectField;
        this.skipNulls = false;
    }

    global SObjectToJsonObject setFieldNameToFunction(Map<String, Function> fieldNameToFunction) {
        this.fieldNameToFunction = fieldNameToFunction;
        return this;
    }

    global SObjectToJsonObject setSkipNulls(Boolean skipNulls) {
        this.skipNulls = skipNulls;
        return this;
    }

    global Map<String, Object> toJsonObject(SObject sObjectToConvert) {
        Map<String, Object> returnVal = new Map<String, Object>();

        for(String sObjectField : sObjectFieldToJsonObjectField.keySet()) {
            Object value = SObjectGetter.get(sObjectToConvert, sObjectField);
            if(!(skipNulls && value == null)) {
                Function fieldFunction = fieldNameToFunction == null ? null : fieldNameToFunction.get(sObjectField);
                if(fieldFunction != null) {
                    value = fieldFunction.call(value);
                }

                List<String> jsonObjectFieldPath = sObjectFieldToJsonObjectField.get(sObjectField).split('\\.');

                Map<String, Object> boxingPosition = returnVal;
                for(Integer i=0; i < jsonObjectFieldPath.size(); i++) {
                    if(i == jsonObjectFieldPath.size() - 1) {
                        boxingPosition.put(jsonObjectFieldPath[i], value);
                    } else {
                        Map<String, Object> newBoxingPosition = (Map<String, Object>)boxingPosition.get(jsonObjectFieldPath[i]);

                        if(newBoxingPosition == null) {
                            newBoxingPosition = new Map<String, Object>();
                            boxingPosition.put(jsonObjectFieldPath[i], newBoxingPosition);
                        }
                        boxingPosition = newBoxingPosition;
                    }
                }
            }
        }
        return returnVal;
    }
}