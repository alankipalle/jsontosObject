/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 09/11/2018
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

@IsTest
private class SObjectGetterTest {

    static Account testAccount;

    static {
        testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    @IsTest
    public static void basic() {
        Account childAccount = new Account(Name = 'Child Account');
        childAccount.ParentId = testAccount.Id;
        insert childAccount;

        Account queriedAccount = [SELECT Id, Name, Parent.Name, Industry FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(queriedAccount.Parent.Name, String.valueOf(SObjectGetter.get(queriedAccount, 'Parent.Name')));
        System.assertEquals(queriedAccount.Name, SObjectGetter.get(queriedAccount, 'Name'));
        System.assertEquals(null, SObjectGetter.get(queriedAccount, 'Industry'));
    }

    @IsTest
    public static void relationIsNullPartWay() {
        Account queriedAccount = [SELECT Id, Name, Parent.Name FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(null, String.valueOf(SObjectGetter.get(queriedAccount, 'Parent.Name')));
    }
}