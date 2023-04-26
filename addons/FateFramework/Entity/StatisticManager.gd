extends Node
class_name StatisticsManagerNode
##Manager node for [StatisticNode]
##handles adding removing and getting statistics


#adds the provided statistic to the
#current statistics if one with the
#matching name doesn't yet exist
##adds the [annotation statistic] and applies the [annotation statisticName] if it doesn't already exist
func addStatistic(statisticName:String,statistic:Node):
	if get_node_or_null(statisticName):return
	statistic.name=statisticName
	add_child(statistic)

#removes statistic with matching name
#it defers the removal so you can reference
#the contained data immediately after calling it
##removes the [annotation statistic] with the matching [annotation statisticName][br]
##returns the removed [annotation statistic]
func removeStatistic(statisticName:String)->Node:
	var statistic:Node=get_node_or_null(statisticName)
	if statistic:statistic.queue_free.call_deferred()
	return statistic

#returns the statistic with the corresponding name
##returns the [annotation statistic] with the matching [annotation statisticName]
func getStatistic(statisticName:String)->Node:
	var statistic:Node=get_node_or_null(statisticName)
	return statistic


#applies the change to the relevant statistic
