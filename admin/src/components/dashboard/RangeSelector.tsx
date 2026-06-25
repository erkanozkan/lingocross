import { Button } from "@/components/ui/button";

interface RangeSelectorProps {
  value: number;
  onChange: (days: number) => void;
  options?: number[];
}

export function RangeSelector({
  value,
  onChange,
  options = [30, 90],
}: RangeSelectorProps) {
  return (
    <div className="flex items-center gap-1">
      {options.map((d) => (
        <Button
          key={d}
          size="sm"
          variant={value === d ? "default" : "outline"}
          onClick={() => onChange(d)}
        >
          {d} gün
        </Button>
      ))}
    </div>
  );
}
