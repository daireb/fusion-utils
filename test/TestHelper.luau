local TestHelper = {}

local suites: { { name: string, cases: { { name: string, passed: boolean, error: string? } } } } = {}
local currentSuite: { name: string, cases: { { name: string, passed: boolean, error: string? } } }? = nil

function TestHelper.suite(name: string, fn: () -> ())
	local suite = { name = name, cases = {} }
	table.insert(suites, suite)
	currentSuite = suite
	fn()
	currentSuite = nil
end

function TestHelper.case(name: string, fn: () -> ())
	local target = currentSuite
	if not target then
		target = { name = "(ungrouped)", cases = {} }
		table.insert(suites, target)
	end

	local ok, err = pcall(fn)
	table.insert(target.cases, {
		name = name,
		passed = ok,
		error = if ok then nil else tostring(err),
	})
end

function TestHelper.assertEqual(got: any, expected: any, message: string?)
	if got ~= expected then
		local label = message or "assertEqual"
		error(`{label}: expected {tostring(expected)}, got {tostring(got)}`, 2)
	end
end

function TestHelper.assertNotNil(value: any, message: string?)
	if value == nil then
		error(message or "assertNotNil: value was nil", 2)
	end
end

function TestHelper.assertType(value: any, expectedType: string, message: string?)
	if typeof(value) ~= expectedType then
		local label = message or "assertType"
		error(`{label}: expected type {expectedType}, got {typeof(value)}`, 2)
	end
end

function TestHelper.assertTrue(value: any, message: string?)
	if not value then
		error(message or "assertTrue: value was falsy", 2)
	end
end

function TestHelper.report()
	local totalPassed = 0
	local totalFailed = 0

	print("\n========== TEST RESULTS ==========\n")

	for _, suite in suites do
		print(`  [{suite.name}]`)
		for _, case in suite.cases do
			if case.passed then
				totalPassed += 1
				print(`    PASS  {case.name}`)
			else
				totalFailed += 1
				warn(`    FAIL  {case.name}`)
				warn(`          {case.error}`)
			end
		end
		print("")
	end

	print("==================================")
	if totalFailed == 0 then
		print(`  All {totalPassed} tests passed!`)
	else
		warn(`  {totalFailed} failed, {totalPassed} passed`)
	end
	print("==================================\n")

	suites = {}

	return totalFailed == 0
end

return TestHelper
