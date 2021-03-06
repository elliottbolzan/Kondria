class QualityDTO():

    def __init__(self, name, percentile):
        self.name = name
        self.percentile = int(percentile) if percentile else 50

    def serialize(self): 
        return {
            'name': self.name,
            'percentile': self.percentile
        }	