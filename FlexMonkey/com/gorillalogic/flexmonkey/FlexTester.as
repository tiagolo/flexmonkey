package com.gorillalogic.flexmonkey
{
	import mx.collections.ArrayCollection;
	
	public class FlexTester
	{
		[Bindable]
		public var tests:ArrayCollection = new ArrayCollection;
		
		private var currentTests:ArrayCollection;
		
		[Bindable]
		public var testsLaunched:int;
		
		[Bindable]
		public var results:ArrayCollection;
		
		public function FlexTester()
		{
		}
	
		public function addTest(func:Function, desc:String):void {
			tests.addItem({func: func, desc: desc});
			
			
		}
		
		public function runTests(tests:Array=null):void {
			
			if (tests == null) {
				currentTests = this.tests;
			} else {
				currentTests = new ArrayCollection(tests);
			}
			for each (var test:Object in currentTests) {
				test.result = "";
				test.msg = "";
			}

			testsLaunched = 0;
			runNextTest();
		}
		
		private function runNextTest():void {
			if (testsLaunched == currentTests.length) {
				return;
			}
			var test:Object = currentTests.getItemAt(testsLaunched++);
			test.func();
		}
		
		public function assert(cond:Boolean, msg:String="Assertion failed"):void {
			if (!cond) {
				setResult("Fail", msg);
				throw new AssertionFailed(msg);
			}

		} 
		
		public function success():void {
			setResult("Success");
		} 
		
		public function error(msg:String):void {
			setResult("Error", msg);
		} 
		
		private function setResult(result:String, msg="") {
				var test:Object = tests.getItemAt(testsLaunched-1);
				test.result = result;
				test.msg = msg;
				
				// Do we need to reassignS to trigger binding?
				tests.setItemAt(test, testsLaunched-1);	
							
				runNextTest();			
		} 

	}
}