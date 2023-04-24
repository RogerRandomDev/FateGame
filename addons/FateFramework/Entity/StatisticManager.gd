extends Node
class_name StatisticsManagerNode
##testing


#adds the provided statistic to the
#current statistics if one with the
#matching name doesn't yet exist
func addStatistic(statisticName:String,statistic:Node):
	if get_node_or_null(statisticName):return
	statistic.name=statisticName
	add_child(statistic)

#removes statistic with matching name
#it defers the removal so you can reference
#the contained data immediately after calling it
func removeStatistic(statisticName:String)->Node:
	var statistic:Node=get_node_or_null(statisticName)
	if statistic:statistic.queue_free.call_deferred()
	return statistic

#returns the statistic with the corresponding name
func getStatistic(statisticName:String)->Node:
	var statistic:Node=get_node_or_null(statisticName)
	return statistic


#applies the change to the relevant statistic
